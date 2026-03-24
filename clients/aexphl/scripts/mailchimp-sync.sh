#!/bin/bash
# =============================================================================
# AEXPHL — Mailchimp Lead Sync
# Polls Webflow form submissions + Calendly bookings → Mailchimp AEXPHL audience
#
# Runs as a scheduled task every hour.
# State file tracks last sync timestamp to avoid duplicate entries.
#
# Requirements:
#   WEBFLOW_AEXPHL_TOKEN  — in ~/.claude/settings.json env block
#   MAILCHIMP_API_KEY     — in ~/.claude/settings.json env block
#   CALENDLY_API_KEY      — in ~/.claude/settings.json env block (optional)
# =============================================================================

set -euo pipefail

# --- Config ------------------------------------------------------------------
WEBFLOW_SITE_ID="5e1ef6e0ff2a7e7d638dd146"
MAILCHIMP_AUDIENCE_ID="bba8715471"
MAILCHIMP_SERVER="us9"
STATE_FILE="$(dirname "$0")/mailchimp-sync-state.json"
LOG_FILE="$(dirname "$0")/mailchimp-sync.log"

# --- Logging -----------------------------------------------------------------
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# --- State management --------------------------------------------------------
get_last_sync() {
  local key="$1"
  if [ -f "$STATE_FILE" ]; then
    python3 -c "
import json, sys
try:
    d = json.load(open('$STATE_FILE'))
    print(d.get('$key', '2020-01-01T00:00:00Z'))
except:
    print('2020-01-01T00:00:00Z')
"
  else
    echo "2020-01-01T00:00:00Z"
  fi
}

update_last_sync() {
  local key="$1"
  local value="$2"
  python3 -c "
import json, os
state_file = '$STATE_FILE'
try:
    d = json.load(open(state_file)) if os.path.exists(state_file) else {}
except:
    d = {}
d['$key'] = '$value'
json.dump(d, open(state_file, 'w'), indent=2)
"
}

# --- Add contact to Mailchimp ------------------------------------------------
add_to_mailchimp() {
  local email="$1"
  local first_name="$2"
  local last_name="$3"
  local phone="$4"
  local tag="$5"
  local notes="$6"

  if [ -z "$email" ] || [ "$email" = "null" ]; then
    log "  Skipping — no email address"
    return
  fi

  log "  Adding $email to Mailchimp (tag: $tag)..."

  # Upsert subscriber (PUT = add or update)
  local email_hash
  email_hash=$(echo -n "${email,,}" | md5)

  local response
  response=$(curl -s -w "\n%{http_code}" \
    -X PUT \
    --user "anystring:$MAILCHIMP_API_KEY" \
    -H "Content-Type: application/json" \
    "https://${MAILCHIMP_SERVER}.api.mailchimp.com/3.0/lists/${MAILCHIMP_AUDIENCE_ID}/members/${email_hash}" \
    -d "{
      \"email_address\": \"${email}\",
      \"status_if_new\": \"subscribed\",
      \"merge_fields\": {
        \"FNAME\": \"${first_name}\",
        \"LNAME\": \"${last_name}\",
        \"PHONE\": \"${phone}\"
      },
      \"tags\": [\"${tag}\"]
    }")

  local http_code
  http_code=$(echo "$response" | tail -1)
  local body
  body=$(echo "$response" | head -1)

  if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
    log "  ✅ Added/updated: $email"

    # Add note if provided
    if [ -n "$notes" ] && [ "$notes" != "null" ] && [ "$notes" != "" ]; then
      local member_id
      member_id=$(echo "$body" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null || echo "")
      if [ -n "$member_id" ]; then
        curl -s -X POST \
          --user "anystring:$MAILCHIMP_API_KEY" \
          -H "Content-Type: application/json" \
          "https://${MAILCHIMP_SERVER}.api.mailchimp.com/3.0/lists/${MAILCHIMP_AUDIENCE_ID}/members/${email_hash}/notes" \
          -d "{\"note\": \"${notes}\"}" > /dev/null
      fi
    fi
  else
    log "  ⚠️  Failed ($http_code): $email — $(echo "$body" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('detail','unknown error'))" 2>/dev/null || echo 'parse error')"
  fi
}

# =============================================================================
# PART 1 — Webflow Form Submissions
# =============================================================================
sync_webflow() {
  log "--- Syncing Webflow form submissions ---"

  local last_sync
  last_sync=$(get_last_sync "webflow_last_sync")
  log "Last sync: $last_sync"

  local now
  now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  # Get all forms for this site
  local forms_response
  forms_response=$(curl -s \
    -H "Authorization: Bearer $WEBFLOW_AEXPHL_TOKEN" \
    -H "accept-version: 2.0.0" \
    "https://api.webflow.com/v2/sites/${WEBFLOW_SITE_ID}/forms")

  local form_ids
  form_ids=$(echo "$forms_response" | python3 -c "
import sys, json
d = json.load(sys.stdin)
forms = d.get('forms', [])
# Deduplicate by displayName, keep first of each
seen = set()
ids = []
for f in forms:
    name = f.get('displayName','')
    if name not in seen:
        seen.add(name)
        ids.append(f.get('id',''))
print('\n'.join(ids))
" 2>/dev/null || echo "")

  if [ -z "$form_ids" ]; then
    log "No forms found or API error"
    return
  fi

  local total_added=0

  while IFS= read -r form_id; do
    [ -z "$form_id" ] && continue

    # Get submissions for this form, paginated
    local offset=0
    local limit=100

    while true; do
      local submissions
      submissions=$(curl -s \
        -H "Authorization: Bearer $WEBFLOW_AEXPHL_TOKEN" \
        -H "accept-version: 2.0.0" \
        "https://api.webflow.com/v2/forms/${form_id}/submissions?limit=${limit}&offset=${offset}")

      local count
      count=$(echo "$submissions" | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d.get('formSubmissions', [])))" 2>/dev/null || echo "0")

      if [ "$count" = "0" ]; then
        break
      fi

      # Process each submission
      echo "$submissions" | python3 -c "
import sys, json
d = json.load(sys.stdin)
last_sync = '$last_sync'
for sub in d.get('formSubmissions', []):
    submitted_at = sub.get('submittedOn', sub.get('createdOn', ''))
    if submitted_at <= last_sync:
        continue

    data = sub.get('fieldData', {})

    # Extract fields (handle various field name formats)
    email = ''
    first_name = ''
    last_name = ''
    phone = ''
    notes_parts = []

    for key, val in data.items():
        key_lower = key.lower()
        if 'email' in key_lower and not email:
            email = str(val) if val else ''
        elif 'name' in key_lower and 'first' in key_lower:
            first_name = str(val) if val else ''
        elif 'name' in key_lower and 'last' in key_lower:
            last_name = str(val) if val else ''
        elif 'name' in key_lower and not first_name and not last_name:
            # Split full name
            parts = str(val).split(' ', 1) if val else ['', '']
            first_name = parts[0]
            last_name = parts[1] if len(parts) > 1 else ''
        elif 'phone' in key_lower or 'whatsapp' in key_lower:
            phone = str(val) if val else ''
        elif val and val != False:
            # Collect checkboxes and other fields as notes
            notes_parts.append(f'{key}: {val}')

    notes = ' | '.join(notes_parts)
    print(f'{email}|||{first_name}|||{last_name}|||{phone}|||{notes}|||{submitted_at}')
" 2>/dev/null | while IFS='|||' read -r email first_name last_name phone notes submitted_at; do
        [ -z "$email" ] && continue
        add_to_mailchimp "$email" "$first_name" "$last_name" "$phone" "source:webflow-form" "$notes"
        ((total_added++)) || true
      done

      # Check if there are more pages
      local total
      total=$(echo "$submissions" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('pagination',{}).get('total',0))" 2>/dev/null || echo "0")

      offset=$((offset + limit))
      if [ "$offset" -ge "$total" ]; then
        break
      fi
    done

  done <<< "$form_ids"

  update_last_sync "webflow_last_sync" "$now"
  log "Webflow sync complete — $total_added new contacts processed"
}

# =============================================================================
# PART 2 — Calendly Bookings
# =============================================================================
sync_calendly() {
  if [ -z "${CALENDLY_API_KEY:-}" ]; then
    log "--- Calendly sync skipped (CALENDLY_API_KEY not set) ---"
    return
  fi

  log "--- Syncing Calendly bookings ---"

  local last_sync
  last_sync=$(get_last_sync "calendly_last_sync")
  log "Last sync: $last_sync"

  local now
  now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  # Get Calendly user URI first
  local user_uri
  user_uri=$(curl -s \
    -H "Authorization: Bearer $CALENDLY_API_KEY" \
    "https://api.calendly.com/users/me" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('resource', {}).get('uri', ''))
" 2>/dev/null || echo "")

  if [ -z "$user_uri" ]; then
    log "Failed to get Calendly user URI — check CALENDLY_API_KEY"
    return
  fi

  # Get scheduled events (invitees) since last sync
  local page_token=""
  local total_added=0

  while true; do
    local url="https://api.calendly.com/scheduled_events?user=${user_uri}&min_start_time=${last_sync}&count=100&sort=start_time:asc"
    [ -n "$page_token" ] && url="${url}&page_token=${page_token}"

    local events
    events=$(curl -s \
      -H "Authorization: Bearer $CALENDLY_API_KEY" \
      "$url")

    local event_uris
    event_uris=$(echo "$events" | python3 -c "
import sys, json
d = json.load(sys.stdin)
for e in d.get('collection', []):
    print(e.get('uri', ''))
" 2>/dev/null || echo "")

    if [ -z "$event_uris" ]; then
      break
    fi

    # For each event, get the invitee details
    while IFS= read -r event_uri; do
      [ -z "$event_uri" ] && continue

      local event_uuid
      event_uuid=$(basename "$event_uri")

      local invitees
      invitees=$(curl -s \
        -H "Authorization: Bearer $CALENDLY_API_KEY" \
        "https://api.calendly.com/scheduled_events/${event_uuid}/invitees?count=100")

      echo "$invitees" | python3 -c "
import sys, json
d = json.load(sys.stdin)
for inv in d.get('collection', []):
    email = inv.get('email', '')
    name = inv.get('name', '')
    parts = name.split(' ', 1)
    first_name = parts[0]
    last_name = parts[1] if len(parts) > 1 else ''
    event_type = inv.get('event_type', '').split('/')[-1]
    created_at = inv.get('created_at', '')
    print(f'{email}|||{first_name}|||{last_name}|||{event_type}|||{created_at}')
" 2>/dev/null | while IFS='|||' read -r email first_name last_name event_type created_at; do
        [ -z "$email" ] && continue
        local notes="Calendly booking | Event: $event_type"
        add_to_mailchimp "$email" "$first_name" "$last_name" "" "source:calendly" "$notes"
        ((total_added++)) || true
      done

    done <<< "$event_uris"

    # Check for next page
    local next_page
    next_page=$(echo "$events" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(d.get('pagination', {}).get('next_page_token', ''))
" 2>/dev/null || echo "")

    if [ -z "$next_page" ]; then
      break
    fi
    page_token="$next_page"
  done

  update_last_sync "calendly_last_sync" "$now"
  log "Calendly sync complete — $total_added new contacts processed"
}

# =============================================================================
# MAIN
# =============================================================================
log "========================================"
log "AEXPHL Mailchimp Sync — $(date)"
log "========================================"

# Check required env vars
if [ -z "${WEBFLOW_AEXPHL_TOKEN:-}" ]; then
  log "ERROR: WEBFLOW_AEXPHL_TOKEN not set"
  exit 1
fi

if [ -z "${MAILCHIMP_API_KEY:-}" ]; then
  log "ERROR: MAILCHIMP_API_KEY not set"
  exit 1
fi

sync_webflow
sync_calendly

log "========================================"
log "Sync complete"
log "========================================"
