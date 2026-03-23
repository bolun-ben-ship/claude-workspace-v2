# Phase 6 — Post-Implementation Report

**Goal:** Produce `POST-IMPLEMENTATION-REPORT-YYYY-MM-DD.md` — a complete before/after record of everything that happened in this run.

This is the most important file in the cycle. It must be complete enough that a future Claude session can load it in Phase 0 and know exactly where things stand — what changed, what was left, and why.

---

## Step 1 — Gather all execution data

Load the following from this run:
1. `audit/AUDIT-YYYY-MM-DD.md` — pre-execution health score + issues found
2. `implementation/SNAPSHOT-YYYY-MM-DD.md` — before/after record of every change attempted
3. `implementation/SEO-PLAN-YYYY-MM-DD.md` — full proposed change list
4. `blog-plans/BLOG-PLAN-YYYY-MM-DD.md` — the 3 post specs
5. `blogs/*.html` — confirm all 3 posts exist (check filenames)
6. `research/GSC-REPORT-YYYY-MM-DD.md` — organic performance baseline
7. `research/GA4-REPORT-YYYY-MM-DD.md` — traffic baseline (if available)
8. `HISTORICAL_CONTEXT` — previous score, resolved items, outstanding items

---

## Step 2 — Write the report

```bash
mkdir -p "Content & SEO/outputs/{platform}-{handle}/audit"
```

Save to: `Content & SEO/outputs/{platform}-{handle}/audit/POST-IMPLEMENTATION-REPORT-YYYY-MM-DD.md`

---

## Report Structure

### Section 1 — Run Summary

```
# SEO Implementation Report — {CLIENT_NAME}
**Date executed:** {TODAY}
**Platform:** {Shopline / Webflow}
**Run type:** 3blog-seo-first-run

## Health Score
| Metric | Before | After | Delta |
|---|---|---|---|
| SEO Health Score | X/100 | X/100 | +/- N |
| SEO Title Coverage | X% | X% | +/-% |
| Meta Description Coverage | X% | X% | +/-% |
| Schema Coverage | X% | X% | +/-% |
| Organic Sessions (last 30d) | N | N | baseline |
| Blog Posts Live | N | N | +3 this run |
```

---

### Section 2 — On-Page Changes Applied

List every change successfully executed via API. Group by field type.

```
## On-Page Changes Applied (N total)

### SEO Titles Changed
| Page / Item | Before | After |
|---|---|---|
| /mattress-guide | Mattress Guide | Best Mattress Singapore 2026 — Owllight Sleep |
| /about | About Us | Owllight Sleep — Singapore Mattress & Back Care Specialists |

### Meta Descriptions Changed
| Page / Item | Before | After |
|---|---|---|
| /mattress-guide | (none) | Singapore's top-rated orthopedic mattress for back pain. Free delivery & trial. |

### Schema Added / Updated
| Page / Item | Schema Type | Action | Details |
|---|---|---|---|
| /mattress-guide | Product | Added | name, price, rating, review count |
| /blog/sleep-tips | Article | Added | author, datePublished, headline |
| Homepage | Organization | Updated | added sameAs social profiles |

### Other On-Page Changes
| Page / Item | Field | Before | After |
|---|---|---|---|
| /products/pillow | noindex | true | false |
```

---

### Section 3 — Blog Posts Published as Drafts

```
## Blog Posts Published as Drafts (3)

| # | Title | Slug | Primary Keyword | Word Count | CMS Status |
|---|---|---|---|---|---|
| 1 | [Title] | /blog/[slug] | [keyword] | ~XXXX | Draft ✓ |
| 2 | [Title] | /blog/[slug] | [keyword] | ~XXXX | Draft ✓ |
| 3 | [Title] | /blog/[slug] | [keyword] | ~XXXX | Draft ✓ |

All 3 posts pushed to {PLATFORM} as drafts. Publish when ready — no SEO value until live.
```

---

### Section 4 — What Could NOT Be Updated (and Why)

This section is mandatory. Every item from the SEO Plan that was NOT executed must appear here with a clear reason.

```
## Items NOT Updated

| Priority | Page / Item | Proposed Change | Reason Not Done | Action Required |
|---|---|---|---|---|
| HIGH | /checkout | Add BreadcrumbList schema | Shopline API does not support schema injection on checkout pages | Manual — add via theme code editor |
| HIGH | /collections/mattress | URL slug → /mattress-singapore | Live URL changes break existing links and GSC history | Manual — plan redirect strategy first |
| MED | Homepage H1 | "Welcome to Owllight" → keyword-targeted | H1 is inside theme template, not editable via product/page API | Manual — edit in theme editor |
| MED | robots.txt | Add sitemap directive | Not accessible via Shopline Admin API | Manual — edit via Shopline dashboard → Online Store → Preferences |
| LOW | /blog/old-post | Update internal links | Batch link replacement not supported via this API version | Manual — or schedule for next run |
```

**Reason categories:**
- `API limitation` — the platform API does not expose this field
- `Live URL risk` — changing would break existing rankings/links without a redirect in place
- `Theme-level` — change lives in theme template, not in page/product metadata
- `Manual dashboard` — accessible only via the CMS UI, not via API
- `Scope` — valid change but deferred to keep this run focused
- `Error` — API call failed (include HTTP status and error message)

---

### Section 5 — Resolved Items

```
## Resolved Items ✅
(These will NOT be re-recommended in future runs)

- ✅ /mattress-guide — SEO title optimised
- ✅ /about — Meta description added
- ✅ /products/pillow — noindex removed
- ✅ Blog: [Title 1] — pushed as draft
- ✅ Blog: [Title 2] — pushed as draft
- ✅ Blog: [Title 3] — pushed as draft
```

---

### Section 6 — Outstanding Priorities

```
## Outstanding Priorities ⏳
(Carry into the next run's Phase 3b as starting list)

| Priority | Page / Item | Issue | Proposed Action | Reason Deferred |
|---|---|---|---|---|
| HIGH | /checkout | No schema | BreadcrumbList schema | API limitation — manual required |
| MED | Homepage H1 | Generic text | Keyword-target | Theme-level — manual required |
```

---

### Section 7 — Regressions

Check `HISTORICAL_CONTEXT.resolved_items` — flag anything that has broken again.

```
## Regressions ⚠️

- ⚠️ [REGRESSION] /checkout — canonical tag removed (was fixed previously, now missing again)
```

If none: `No regressions detected.`

---

### Section 8 — Keywords Targeted This Run

```
## Keywords Targeted

| Keyword | Type | Intent | Target Page | Action |
|---|---|---|---|---|
| best mattress singapore | Primary | Transactional | /mattress-guide | SEO title optimised |
| [keyword] | Long-tail | Informational | [new blog post] | Blog published |
```

---

### Section 9 — Organic Baseline

```
## Organic Baseline (set at time of this run)

| Metric | Value | Source |
|---|---|---|
| Organic sessions (last 30 days) | N | GA4 |
| Top page by organic clicks | /[page] | GSC |
| Top keyword by impressions | [keyword] | GSC |
| Average position | X.X | GSC |
| Average CTR | X.X% | GSC |
```

This baseline is loaded by Phase 0 on the next run to calculate before/after deltas.

---

### Section 10 — Next Run Recommendations

```
## Recommended Focus — Next Run

1. [Highest priority outstanding item — likely a manual task from Section 4]
2. [Second priority — e.g. new keyword opportunity from GSC data]
3. [Third priority — e.g. content gap from social trends]
```

Keep to 3 actionable items. Next run's Phase 3 will re-derive from fresh data.

---

## Step 3 — Confirm save

After saving the report:

```
Phase 6 complete — 3blog-seo-first-run finished.

POST-IMPLEMENTATION-REPORT saved:
audit/POST-IMPLEMENTATION-REPORT-{YYYY-MM-DD}.md

Summary:
  Score:        X/100 → X/100 (Δ = +/-N)
  On-page:      N changes applied (titles: N, meta: N, schema: N, other: N)
  Not updated:  N items — see Section 4 for reasons + manual actions required
  Blogs:        3 posts pushed to {PLATFORM} as drafts
  Resolved:     N items ✅
  Outstanding:  N items carried forward
  Regressions:  N

Run complete. ✓
```
