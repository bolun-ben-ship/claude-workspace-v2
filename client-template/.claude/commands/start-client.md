# /start-client

Load all client context and produce a Client Briefing for this session.

Run this at the start of every client workspace session so Claude knows exactly
who this client is, where they are in their SEO journey, and what's pending.

---

## Step 1 — Read client configuration

Read `CLAUDE.md` from the current workspace and extract:
- Client name, website, market, niche
- **Platform (CMS)** — exactly: `Shopline`, `Webflow`, or `WordPress`
- Store / Site handle
- Access token env var name
- Outputs path
- Analytics: GSC site, GA4 property ID, Google credentials env var
- Context Loading Rules
- Voice & Tone guidelines

Note the platform — it governs which skills are available and how they route CMS calls.

---

## Step 2 — Read all context files

Read each file if it exists. Skip silently if absent — note missing files in the briefing.

- `context/client-info.md` — brand, products/services, competitors, audience
- `context/current-data.md` — live metrics, web assets, baseline data
- `context/strategy.md` — content & growth strategy, current focus
- `context/tone-guide.md` — brand voice, writing rules
- `context/personal-info.md` — founder voice, values (if exists)

---

## Step 3 — Scan SEO output history

Replace `{PLATFORM}` and `{HANDLE}` with the values read from CLAUDE.md.

```bash
ls "Content & SEO/outputs/{PLATFORM}-{HANDLE}/" 2>/dev/null || echo "NO_OUTPUTS_YET"
ls "Content & SEO/outputs/{PLATFORM}-{HANDLE}/audit/" 2>/dev/null | sort -r | head -1
ls "Content & SEO/outputs/{PLATFORM}-{HANDLE}/research/" 2>/dev/null | sort -r | head -1
ls "Content & SEO/outputs/{PLATFORM}-{HANDLE}/implementation/" 2>/dev/null | sort -r | head -1
ls "Content & SEO/outputs/{PLATFORM}-{HANDLE}/blogs/" 2>/dev/null | sort -r | head -1
ls "Content & SEO/outputs/{PLATFORM}-{HANDLE}/blog-plans/" 2>/dev/null | sort -r | head -1
ls "Content & SEO/outputs/{PLATFORM}-{HANDLE}/keywords/" 2>/dev/null | sort -r | head -1
ls "Content & SEO/outputs/{PLATFORM}-{HANDLE}/reports/" 2>/dev/null | sort -r | head -1
ls "Design/" 2>/dev/null | sort -r | head -3
```

Record: subfolder name → most recent filename (or "empty").
For Design/: list the most recent 3 Carousel folders (or "none").

If the most recent audit file exists, read the first 50 lines to extract the SEO health score.
If a `reports/MONTHLY-REPORT-*.md` file exists, note the most recent month.

---

## Step 4 — Check credentials

Replace `{GOOGLE_KEY_ENV}` and `{TOKEN_ENV_VAR}` with the actual env var names from CLAUDE.md.

```bash
echo "GOOGLE_KEY: ${!GOOGLE_KEY_ENV:+SET}"
echo "GOOGLE_FILE: $([ -f "${!GOOGLE_KEY_ENV:-}" ] && echo EXISTS || echo MISSING)"
echo "PLATFORM_TOKEN: ${!TOKEN_ENV_VAR:+SET}"
```

Report: `[SET ✓]` / `[NOT SET ✗]` / `[SET but file not found ✗]` for each.

### WordPress clients — additional connection verification

If `CMS: WordPress`, run these additional checks. Replace `{WP_USERNAME}` with the username from CLAUDE.md and `{API_BASE}` with the API base URL.

```python
import base64, os, subprocess, json

token = os.environ.get("{TOKEN_ENV_VAR}", "")
username = "{WP_USERNAME}"

if not token:
    print("WP Auth: NOT SET ✗")
else:
    encoded = base64.b64encode(f"{username}:{token}".encode()).decode()
    result = subprocess.run(
        ["curl", "-s", "{API_BASE}/users/me?_fields=name,roles",
         "-H", f"Authorization: Basic {encoded}"],
        capture_output=True, text=True
    )
    try:
        d = json.loads(result.stdout)
        if d.get("name"):
            roles = d.get("roles", [])
            is_admin = "administrator" in roles
            print(f"WP Auth: CONNECTED ✓ (user: {d['name']}, role: {', '.join(roles)})")
            print(f"WP Role: {'Administrator ✓' if is_admin else 'NOT Administrator ✗ — page deletion will fail'}")
        else:
            print(f"WP Auth: FAILED ✗ — {d.get('code', 'unknown')} (check username in CLAUDE.md matches Application Password owner)")
    except:
        print("WP Auth: ERROR parsing response")

# Check Yoast REST fields
result2 = subprocess.run(
    ["curl", "-s", "{API_BASE}/pages?per_page=1&_fields=_yoast_wpseo_metadesc",
     "-H", f"Authorization: Basic {encoded}"],
    capture_output=True, text=True
)
try:
    pages = json.loads(result2.stdout)
    if isinstance(pages, list) and pages and "_yoast_wpseo_metadesc" in pages[0]:
        print("Yoast REST fields: REGISTERED ✓")
    else:
        print("Yoast REST fields: NOT REGISTERED ✗ — meta desc/noindex updates will fail. Install 'Yoast REST API Fields' Code Snippet.")
except:
    print("Yoast REST fields: could not verify")
```

Report all findings in the briefing credentials section.

---

## Step 5 — Verify connections

Run live connection tests for every integration. Do not skip — these tests catch broken tokens and misconfigured APIs before any skill tries to use them.

### 5a — CMS connection

Use the platform value from CLAUDE.md to run the correct test.

**WordPress:**
```bash
# Test 1: API reachable
curl -s -o /dev/null -w "%{http_code}" "https://{WEBSITE}/wp-json/wp/v2/"

# Test 2: Auth (Application Password — Basic auth with username:token)
# Try common usernames against the stored token
for user in admin administrator editor; do
  code=$(curl -s -o /dev/null -w "%{http_code}" \
    -u "$user:${!TOKEN_ENV_VAR}" \
    "https://{WEBSITE}/wp-json/wp/v2/users/me")
  echo "$user: $code"
  [ "$code" = "200" ] && break
done
```

Interpret results:
- API 200 + auth 200 → `[CONNECTED ✓]`
- API 200 + auth 401 → `[API reachable, auth failed ✗]` — token wrong or username mismatch
- API non-200 → `[API unreachable ✗]`

**Shopline:**
```bash
curl -s -o /dev/null -w "%{http_code}" \
  -H "x-shopline-access-token: ${!TOKEN_ENV_VAR}" \
  "https://openapi.shopline.com/openapi/2022-01/shops/info"
```
- 200 → `[CONNECTED ✓]`
- 401/403 → `[Auth failed ✗]`

**Webflow:**
```bash
curl -s -o /dev/null -w "%{http_code}" \
  -H "Authorization: Bearer ${!TOKEN_ENV_VAR}" \
  -H "accept-version: 1.0.0" \
  "https://api.webflow.com/v2/sites"
```
- 200 → `[CONNECTED ✓]`
- 401/403 → `[Auth failed ✗]`

---

### 5b — Google Search Console

```python
import os
from google.oauth2 import service_account
from googleapiclient.discovery import build

key_path = os.environ.get("{GOOGLE_KEY_ENV}", "")
try:
    creds = service_account.Credentials.from_service_account_file(
        key_path, scopes=["https://www.googleapis.com/auth/webmasters.readonly"]
    )
    service = build("searchconsole", "v1", credentials=creds)
    sites = service.sites().list().execute()
    site_list = [s['siteUrl'] for s in sites.get('siteEntry', [])]
    print("CONNECTED:", site_list)
except Exception as e:
    print("ERROR:", e)
```

Interpret results:
- `CONNECTED: [...]` with the client site in the list → `[CONNECTED ✓]`
- `CONNECTED: []` (empty list) → `[Connected but service account has no GSC property access ✗]`
- `403 ... API has not been used` → `[Search Console API not enabled in GCP ✗]`
- `403 ... Permission denied` → `[Service account not granted GSC access ✗]`
- Key file missing → `[Key file not found ✗]`

---

### 5c — Google Analytics 4

```python
import os
from google.oauth2 import service_account
from googleapiclient.discovery import build

key_path = os.environ.get("{GOOGLE_KEY_ENV}", "")
property_id = "{GA4_PROPERTY_ID}"  # from CLAUDE.md
try:
    creds = service_account.Credentials.from_service_account_file(
        key_path, scopes=["https://www.googleapis.com/auth/analytics.readonly"]
    )
    service = build("analyticsdata", "v1beta", credentials=creds)
    result = service.properties().runReport(
        property=f"properties/{property_id}",
        body={
            "dateRanges": [{"startDate": "7daysAgo", "endDate": "today"}],
            "metrics": [{"name": "sessions"}]
        }
    ).execute()
    sessions = result['rows'][0]['metricValues'][0]['value'] if result.get('rows') else "0"
    print("CONNECTED: sessions (7d) =", sessions)
except Exception as e:
    print("ERROR:", e)
```

Interpret results:
- `CONNECTED: sessions (7d) = N` → `[CONNECTED ✓]`
- `403 ... API has not been used` → `[Analytics Data API not enabled in GCP ✗]`
- `403 ... Permission denied` → `[Service account not granted GA4 access ✗]`
- Key file missing → `[Key file not found ✗]`

---

## Step 6 — Produce Client Briefing

Output in this exact format:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Client Briefing — {CLIENT_NAME}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Client:    {CLIENT_NAME} | {WEBSITE} | {MARKET}
Niche:     {NICHE}
Platform:  {PLATFORM} — {HANDLE}
Outputs:   Content & SEO/outputs/{PLATFORM}-{HANDLE}/

Context loaded:
  client-info.md     [loaded / MISSING]
  current-data.md    [loaded / MISSING]
  strategy.md        [loaded / MISSING]
  tone-guide.md      [loaded / MISSING]
  personal-info.md   [loaded / MISSING — optional]

SEO history:
┌──────────────────┬────────────────────────────────────────┬────────────────┐
│ Folder           │ Most Recent File                       │ Date           │
├──────────────────┼────────────────────────────────────────┼────────────────┤
│ audit/           │ AUDIT-YYYY-MM-DD.md                   │ YYYY-MM-DD     │
│ research/        │ GSC-REPORT-YYYY-MM-DD.md              │ YYYY-MM-DD     │
│ implementation/  │ IMPLEMENTATION-PLAN-YYYY-MM-DD.md     │ YYYY-MM-DD     │
│ keywords/        │ KEYWORDS-YYYY-MM-DD.md                │ YYYY-MM-DD     │
│ blog-plans/      │ BLOG-PLAN-YYYY-MM-DD.md               │ YYYY-MM-DD     │
│ blogs/           │ [post-slug].html                       │ YYYY-MM-DD     │
│ reports/         │ MONTHLY-REPORT-YYYY-MM.md             │ YYYY-MM        │
└──────────────────┴────────────────────────────────────────┴────────────────┘
[Show "No outputs yet" if folder is empty or missing]

Last SEO score:   [N/100 from most recent audit, or "not available"]
Active campaign:  [Month N of X — from most recent MONTHLY-REPORT, or "none"]

Credentials:
  {GOOGLE_KEY_ENV}:   [SET ✓ / NOT SET ✗ / SET but file not found ✗]
  {TOKEN_ENV_VAR}:    [SET ✓ / NOT SET ✗]
  [WordPress only] WP Auth:          [CONNECTED as {user} ({role}) ✓ / FAILED ✗]
  [WordPress only] Yoast REST fields: [REGISTERED ✓ / NOT REGISTERED ✗]
  [WordPress only] Elementor:         [note if site uses Elementor — page content not editable via REST]

Connections:
  {PLATFORM} API:          [CONNECTED ✓ / API reachable, auth failed ✗ / API unreachable ✗]
  Google Search Console:   [CONNECTED ✓ / (reason for failure) ✗]
  Google Analytics 4:      [CONNECTED ✓ / (reason for failure) ✗]

[If any connection failed, print a fix block immediately after the table — see Notes]

Voice & tone:
[1–2 sentence summary from CLAUDE.md Voice & Tone section]

Available commands for {PLATFORM}:
  /ai-seo-pipeline          Full automation (3/6/12 months)
  /3blog-seo-first-run      Full run → 3 blogs + on-page changes + before/after report
  /seo-implementation-plan  Build plan only (no execution)
  /seo-final-report         End-of-engagement report
  /{PLATFORM}-onpage-implement  Execute on-page changes via {PLATFORM} API
  /carousel                 Instagram carousel → HTML preview + PNG slides

What's pending:
[If active campaign: "Campaign running — Month N. Next scheduled: blogs {DATE}, on-page review {DATE}"]
[If SEO plan exists: "Last plan: IMPLEMENTATION-PLAN-YYYY-MM-DD.md — review outstanding items"]
[If no plan exists: "No SEO plan yet — run /seo-implementation-plan to start"]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

After the briefing, say:

> Ready. What would you like to work on for {CLIENT_NAME}?

---

## Notes

### Credential issues
- If any credential is NOT SET: remind the user to add it to both `~/.zshrc` AND `~/.claude/settings.json` env block, then restart Claude Code.

### Connection fix blocks
If any connection test failed, print a specific fix block immediately after the Connections table. Use the exact issue to give the right fix:

**WordPress auth failed:**
```
Fix — WordPress token:
  1. WordPress admin → Users → your user → Application Passwords
  2. Generate a new password — copy the full string including spaces
  3. Update WORDPRESS_{HANDLE}_TOKEN in ~/.zshrc and ~/.claude/settings.json
  4. Restart Claude Code
```

**GSC — API not enabled:**
```
Fix — Search Console API:
  1. Go to: https://console.cloud.google.com/apis/api/searchconsole.googleapis.com/overview?project={GCP_PROJECT_ID}
  2. Click Enable
  3. Wait ~2 minutes, then re-run /start-client
```

**GSC — service account has no access:**
```
Fix — GSC property access:
  1. Go to Google Search Console → Settings → Users and permissions
  2. Add {SERVICE_ACCOUNT_EMAIL} as a Full user
  3. Re-run /start-client to verify
```

**GA4 — API not enabled:**
```
Fix — Analytics Data API:
  1. Go to: https://console.cloud.google.com/apis/api/analyticsdata.googleapis.com/overview?project={GCP_PROJECT_ID}
  2. Click Enable
  3. Wait ~2 minutes, then re-run /start-client
```

**GA4 — service account has no access:**
```
Fix — GA4 property access:
  1. Go to GA4 → Admin → Property Access Management
  2. Add {SERVICE_ACCOUNT_EMAIL} as a Viewer
  3. Re-run /start-client to verify
```

### Context files missing
- If context files are MISSING: run `/onboard` from the agency root to auto-populate from the live site, or fill manually.

### Platform routing
All CMS skills read the `CMS:` value from `## Platform` in CLAUDE.md:
- `Shopline` → REST API + `SHOPLINE_{CLIENT}_TOKEN`
- `Webflow` → Data API + MCP + `WEBFLOW_{CLIENT}_TOKEN`
- `WordPress` → WP REST API + `WORDPRESS_{CLIENT}_TOKEN`
