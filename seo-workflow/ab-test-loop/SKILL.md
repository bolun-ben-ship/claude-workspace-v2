---
name: ab-test-loop
description: >
  Autonomous A/B test iteration loop for PostHog experiments. Monitors all running
  experiments for Bayesian significance (>95%), declares winners, rolls out the winning
  variant to 100% via PostHog feature flags, generates the next copy variants informed
  by brand voice, and launches the next experiment — without manual intervention.
  Supports CTA button text, hero section headlines, and any other PostHog experiment type.
  Also handles one-time scroll depth tracking setup (25/50/75/90%) via Webflow Pages API.
  Use when user says "ab-test-loop", "check my a/b tests", "run the ab loop",
  "check experiment results", "declare ab test winner", "launch next variant",
  "set up scroll tracking", or "automate ab testing".
user-invocable: true
argument-hint: "(no arguments — reads all running experiments from PostHog automatically)"
---

# A/B Test Loop

Autonomous PostHog experiment iteration. Monitors all running experiments, declares
winners at significance, rolls them out, generates the next batch of variants, and
launches new experiments. Runs from the **client workspace** (`clients/{domain}/`).

---

## Prerequisites — Scroll Depth Tracking (one-time setup)

Before the first run, check whether scroll tracking has already been set up on the
test pages. Look for a `ab-tests/SCROLL-TRACKING-SETUP.md` file in the outputs folder.

If the file does NOT exist, run the scroll tracking setup (Phase S) before Phase 0.

---

## Phase S — Scroll Depth Tracking Setup (one-time, skip if already done)

Adds PostHog scroll depth tracking to the relevant Webflow pages.
Fires `scroll_depth` events at 25%, 50%, 75%, and 90%.

> **Note:** Webflow's custom code API requires OAuth `custom_code:write` scope, which
> is not available via a standard site API token. Phase S therefore gives the user
> exact steps to add the snippet manually via Webflow Designer — a one-time action
> that takes under 5 minutes.

### Step S1 — Provide the snippet and manual instructions

Tell the user:

> **Scroll tracking setup — 5-minute manual step in Webflow Designer**
>
> The Webflow API doesn't support injecting custom code without an OAuth app, so
> you'll need to add this snippet once per test page. Here's how:
>
> 1. Open Webflow Designer → navigate to the page (e.g. `/aussieexpathome`)
> 2. Click the **⚙️ Page Settings** gear icon (top right of the page canvas)
> 3. Scroll to **Custom Code → Before `</body>` tag**
> 4. Paste the snippet below
> 5. Repeat for `/landing-page` and `/landing-page-v2`
> 6. **Publish the site** when done
>
> **Snippet to paste:**
> ```html
> <script>
> (function(){
>   var fired={};
>   var marks=[25,50,75,90];
>   function check(){
>     var h=document.body.scrollHeight-window.innerHeight;
>     if(h<=0) return;
>     var pct=Math.round((window.scrollY/h)*100);
>     marks.forEach(function(m){
>       if(pct>=m&&!fired[m]){
>         fired[m]=true;
>         if(window.posthog) posthog.capture('scroll_depth',{depth:m,page:window.location.pathname});
>       }
>     });
>   }
>   window.addEventListener('scroll',check,{passive:true});
> })();
> </script>
> ```
>
> Once pasted and published, reply "done" and I'll create the setup record.

### Step S2 — Wait for user confirmation

**STOP — wait for the user to confirm the snippet has been added and the site published.**

### Step S3 — Create setup record

Save `Content & SEO/outputs/webflow-{HANDLE}/ab-tests/SCROLL-TRACKING-SETUP.md`:

```markdown
# Scroll Depth Tracking — Setup Record

**Date:** {TODAY}
**Pages instrumented:**
- {page slug} — {PAGE_ID}
- {page slug} — {PAGE_ID}

**Events fired:** scroll_depth with properties: depth (25/50/75/90), page (pathname)
**PostHog project:** {PROJECT_ID}

This file marks scroll tracking as active. Phase S is skipped on future /ab-test-loop runs.
```

---

## Phase 0 — Load Context

Read these files from the client workspace:
- `context/tone-guide.md` — brand voice rules (used in Phase 3d)
- `context/client-info.md` — business context, audience, key value props

---

## Phase 1 — Fetch All Running Experiments

Use PostHog MCP: `experiment-get-all`

Filter to experiments where `status == "running"`.

If no running experiments: output "No running experiments found." and stop.

List them:
```
Running experiments found: {N}
1. {id} — {name} | flag: {feature_flag_key} | started: {start_date}
2. ...
```

---

## Phase 2 — Check Each Experiment for Significance

For each running experiment:

Use PostHog MCP: `experiment-results-get` with `refresh: false`

Extract from results:
- Winning variant key + name
- Bayesian probability for the winning variant (0–1 → express as %)
- Exposure counts per variant (control_count, test_count)
- Days running (today minus start_date)

**Decision rules:**
- `exposures < 100 per variant` → **Too early** — skip, note exposure count
- `winning_variant_probability >= 0.95` → **Significant** — proceed to Phase 3
- `winning_variant_probability < 0.95` → **Not yet significant** — report status, skip

Report for each experiment:
```
Experiment: {name}
Status: {Too early / Not yet significant / SIGNIFICANT}
Winner: {variant_name} at {probability}% probability
Exposures: control={N}, test={N} | Days running: {N}
```

---

## Phase 3 — Conclude + Implement + Generate + Launch (significant experiments only)

Run this phase for each experiment flagged as **Significant** in Phase 2.

### 3a — Conclude experiment

Use PostHog MCP: `experiment-update`
- Set `end_date` to today's date (ISO 8601)
- Set `conclusion` to: `"Winner: {variant_name} ({probability}% Bayesian probability). Rolled out to 100%."`

### 3b — Roll out winning variant to 100%

Use PostHog MCP: `update-feature-flag`
- Flag key: the experiment's `feature_flag_key`
- Set the winning variant rollout to 100%, all other variants to 0%
- Keep the flag active (do NOT disable it)

This immediately causes the Webflow site's PostHog JS to serve the winning variant to all users.

Confirm: `Winner "{variant_name}" rolled out to 100% on flag "{feature_flag_key}" ✓`

### 3c — Log to AB-TEST-LOG.md

Append to `Content & SEO/outputs/webflow-{HANDLE}/ab-tests/AB-TEST-LOG.md`
(create the file + folder if it doesn't exist):

```markdown
## {experiment_name} — concluded {TODAY}

| Field | Value |
|---|---|
| **Winner** | {variant_key} — "{copy_text_if_known}" |
| **Probability** | {X}% Bayesian |
| **Exposures** | control={N}, test={N} |
| **Days run** | {N} |
| **Feature flag** | `{feature_flag_key}` → rolled to 100% |
| **Next test** | {new_experiment_name} (see below) |

**TODO for monthly-onpage:** Hardcode winner "{copy_text}" into Webflow page `/{page_slug}` permanently and disable feature flag `{feature_flag_key}`.
```

### 3d — Generate next variants

Using the tone-guide.md and client-info.md loaded in Phase 0:

Generate 2–3 new copy variants for the same element type (CTA / hero headline / etc):
- **Build on the winning angle** — don't start from scratch
- **Push the winning insight further**: if specificity won → get more specific; if benefit framing won → sharpen the benefit; if urgency won → test a different urgency signal
- **Vary along one axis per variant**: urgency / specificity / benefit framing / audience acknowledgement
- Each variant must fit the brand voice (refer to tone-guide.md rules)
- Keep within character limits appropriate for the element type (CTA: ≤35 chars, headline: ≤80 chars)

Present to user:
```
New variants for "{experiment_name}":

Control (current winner): "{winning_copy}"

Variant A: "{copy_a}"
  → Rationale: {one sentence}

Variant B: "{copy_b}"
  → Rationale: {one sentence}

[Variant C: "{copy_c}" — optional]
  → Rationale: {one sentence}

Approve these variants, modify any, or provide your own:
```

**STOP — wait for user approval before continuing to 3e.**

### 3e — Create next experiment

After user approves variants:

1. Use PostHog MCP: `create-feature-flag`
   - Key: `{element-type}-{iteration-number}` (e.g. `sales-cta-2`, `hero-headline-2`)
   - Variants: control (approved winner, 50%) + test (approved variant, 50%)
   - Rollout: 100% of users

2. Use PostHog MCP: `experiment-create`
   - Name: `{Element} — {control_label} vs {test_label}`
   - Feature flag: the flag just created
   - Primary metric: same metric type as the concluded experiment (funnel click)
   - Secondary metric: `scroll_depth` ≥ 50% on the same page (if scroll tracking is active)
   - Stats method: Bayesian
   - Start: now

Confirm: `New experiment "{name}" launched ✓`

---

## Phase 4 — Summary Report

Output a clean summary to the user:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
A/B Test Loop — {TODAY}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CONCLUDED ({N}):
✓ {experiment_name}
  Winner: "{copy}" at {X}% probability
  Next test launched: "{new_experiment_name}"

STILL RUNNING ({N}):
◷ {experiment_name}
  {variant} leading at {X}% | {N} exposures | {N} days

TOO EARLY ({N}):
⏳ {experiment_name}
  {N}/{min_exposures} exposures needed

SCROLL TRACKING: {Active (set up {date}) / Not yet set up — run Phase S}

LOG: Content & SEO/outputs/webflow-{HANDLE}/ab-tests/AB-TEST-LOG.md
NOTE: Check log for monthly-onpage TODOs (hardcoding winners into Webflow).
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Scheduled Task Behaviour

When running as the scheduled task `aexphl-ab-test-loop`:

- Run Phases 0–3b silently (no user prompts needed for polling + rollout)
- At Phase 3d (variant approval): surface the approval prompt to the user — this requires a live session
- If no experiments are significant: append a status entry to AB-TEST-LOG.md and exit
- Format status entry: `{TODAY}: No winners yet — {experiment_name} at {X}%, {N} exposures`

---

## Output Files

| File | Purpose |
|---|---|
| `Content & SEO/outputs/webflow-{HANDLE}/ab-tests/AB-TEST-LOG.md` | Running log of all test results, winners, TODOs |
| `Content & SEO/outputs/webflow-{HANDLE}/ab-tests/SCROLL-TRACKING-SETUP.md` | One-time record that scroll tracking is active |

---

## Sub-skill Reference Paths

This skill uses:
- PostHog MCP tools: `experiment-get-all`, `experiment-results-get`, `experiment-update`, `update-feature-flag`, `create-feature-flag`, `experiment-create`
- Webflow Pages API (Bash) for scroll tracking setup
- `context/tone-guide.md` and `context/client-info.md` for variant generation
