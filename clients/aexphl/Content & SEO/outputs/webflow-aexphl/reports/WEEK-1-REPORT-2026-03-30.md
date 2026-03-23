# Week 1 Report — Aussie Expat Home Loans (AEXPHL)
**Report date:** 2026-03-30
**Period covered:** 2026-03-23 → 2026-03-30
**Pipeline start date:** 2026-03-23
**Platform:** Webflow (aexphl)
**Campaign duration:** 3 months (→ 2026-06-23)

---

## 1. Initial Plan vs Execution

### On-Page Changes

| Category | Planned | Executed | Status |
|---|---|---|---|
| SEO Titles — Static Pages (5 pages) | 5 | 5 | ✅ Complete (confirmed present in prior run before pipeline start) |
| Meta Descriptions — Static Pages (5 pages) | 5 | 5 | ✅ Complete (confirmed present in prior run before pipeline start) |
| noIndex — /landing-page | 1 | 0 | ⏳ Manual required |
| noIndex — /landing-page-v2 | 1 | 0 | ⏳ Manual required |
| Schema Markup (4 blocks) | 4 | 0 | ⏳ Manual required |
| Internal Links in 4 Existing Blog Posts | 4 | 0 | ⏳ Deferred to Month 1 on-page pass |
| HTTP non-www Redirect | 1 | 0 | ⏳ Manual required |
| Blog CTR Fixes (4 posts, meta title + desc) | 4 | 4 | ✅ Complete (executed 2026-03-20, pre-pipeline) |

**Summary:** All API-executable changes to static page titles and meta descriptions were confirmed in place. Five blog posts were published to Webflow as drafts. The four categories not executed are all gated on either manual Webflow Designer access or a deferred API pass.

---

### Items Not Executed (reason for each)

| Item | Reason |
|---|---|
| noIndex `/landing-page` | `noIndex` field is not exposed in Webflow Data API v2. Cannot be toggled via API — must be set manually in Webflow Designer. |
| noIndex `/landing-page-v2` | Same as above. |
| Schema Markup (4 JSON-LD blocks) | Webflow Data API does not support injecting custom code into page head. Requires Webflow Designer: Page Settings → Custom Code → Head. |
| Internal links in 4 existing blog posts | Body content fetch + HTML injection deferred. CMS API can do this but requires careful per-post content fetch to avoid overwriting existing content. Scheduled for Month 1 on-page pass. |
| HTTP non-www Redirect | DNS/hosting level — cannot be done via API. Requires Webflow Hosting settings review + GSC preferred domain update. |

---

### Manual Items Still Outstanding

The following require Tim to action directly in Webflow Designer / Dashboard:

| Priority | Item | Action |
|---|---|---|
| 🔴 CRITICAL | noIndex `/landing-page` | Webflow Designer → Pages → /landing-page → SEO Settings → toggle "Exclude from search results" |
| 🔴 HIGH | noIndex `/landing-page-v2` | Webflow Designer → Pages → /landing-page-v2 → SEO Settings → toggle "Exclude from search results" |
| 🔴 HIGH | Schema — Organization + LocalBusiness | Webflow Designer → Homepage → Page Settings → Head Code — paste F1 block from IMPLEMENTATION-PLAN-2026-03-23.md |
| 🔴 HIGH | Schema — FAQPage | Webflow Designer → /faqs → Page Settings → Head Code — paste F2 block |
| 🔴 HIGH | Schema — Article + Author (blog template) | Webflow Designer → Blog CMS Collection Template → Page Settings → Head Code — paste F3 block (applies to all posts) |
| ⚠️ MED | Schema — BreadcrumbList | Webflow Site Settings → Custom Code → Head — paste F4 block |
| ⚠️ MED | HTTP → HTTPS + www redirect | Webflow Hosting settings → confirm "Redirect HTTP to HTTPS" + canonical domain preference; update GSC preferred domain |

---

### Blogs Published as Drafts (5 posts)

All 5 posts are in Webflow CMS collection `66104d468c50c15134bf0447` as `isDraft: true`. They are awaiting Tim's review and manual publish in Webflow Designer.

| # | Title | Slug | Webflow Draft ID |
|---|---|---|---|
| 1 | The RBA Just Raised Rates to 4.10% — What It Means for Aussie Expats | `rba-rate-hike-march-2026-australian-expats` | `69c0f822516496872957b969` |
| 2 | Foreign Income Shading: How Australian Lenders Assess Your Overseas Salary | `foreign-income-shading-australian-home-loan` | `69c0f82474911f1a6421c17e` |
| 3 | How Much Can an Aussie Expat in Singapore Borrow in 2026? | `how-much-can-australian-expat-singapore-borrow` | `69c0f825737ae96589972355` |
| 4 | The Documents You Need for an Australian Expat Home Loan | `australian-expat-home-loan-documents-checklist` | `69c0f826160a92a016a00015` |
| 5 | Can You Refinance Your Australian Mortgage While Living Overseas? | `refinance-australian-mortgage-overseas` | `69c0f82718732148ca257a87` |

HTML source files: `Content & SEO/outputs/webflow-aexphl/blogs/`

---

## 2. Starting Baseline

| Metric | Value | Source | Date |
|---|---|---|---|
| SEO Health Score | 47/100 | SEO Audit | 2026-03-19 |
| Organic sessions (30d) | 294 | GA4 | Feb–Mar 2026 |
| Organic share of traffic | 2.6% | GA4 | Feb–Mar 2026 |
| Total GSC clicks (30d) | ~120 | GSC | Feb–Mar 2026 |
| Total GSC impressions (30d) | ~20,000 | GSC | Feb–Mar 2026 |
| Average CTR | ~0.6% | GSC | Feb–Mar 2026 |
| Average position | ~8–10 | GSC | Feb–Mar 2026 |
| Blog posts in CMS | 43 posts | Webflow CMS | 2026-03-19 |
| Blog posts in CMS (after this run) | 53 posts | Webflow CMS | 2026-03-23 |

**Top queries at baseline (from GSC report 2026-03-20):**
- "australian expat home loans" — 425 impressions, 8 clicks
- "aussie expat home loans" — best CTR at 5.6%

**Estimated audit score after all changes are executed:** 57–62/100

---

## 3. GSC Data for New Blog Slugs

GSC query run: 2026-03-23 → 2026-03-30 against `sc-domain:aexphl.com`

| Slug | Impressions | Clicks | Status |
|---|---|---|---|
| rba-rate-hike-march-2026-australian-expats | 0 | 0 | Not indexed — posts remain as Webflow drafts (not live) |
| foreign-income-shading-australian-home-loan | 0 | 0 | Not indexed — draft |
| how-much-can-australian-expat-singapore-borrow | 0 | 0 | Not indexed — draft |
| australian-expat-home-loan-documents-checklist | 0 | 0 | Not indexed — draft |
| refinance-australian-mortgage-overseas | 0 | 0 | Not indexed — draft |

**Note:** This is expected. All 5 posts were pushed as `isDraft: true` — they are not publicly accessible and cannot be crawled or indexed until Tim publishes them in Webflow. Once published, allow 1–2 weeks for Google to crawl and index. Impressions should begin appearing in GSC 2–4 weeks post-publication.

---

## 4. What's Coming

| Milestone | Date | Type |
|---|---|---|
| Blog publish — Tim to action | ASAP | Manual (Tim) |
| Manual SEO items (noIndex, schema, redirect) | ASAP | Manual (Tim) |
| Week 2 blog run | 2026-03-30 | Automated |
| Week 3 blog run | 2026-04-06 | Automated |
| Week 4 blog run | 2026-04-13 | Automated |
| Month 1 on-page review | 2026-04-23 | Automated |
| Month 1 report | 2026-04-23 | Automated |

**Month 1 on-page pass will include:**
- Internal links in 4 existing high-impression blog posts (deferred from this run)
- Review of all manual items above (confirm completed or re-flag)
- GSC delta vs baseline
- Crawl re-audit to confirm noIndex and schema changes are in place

---

## 5. Notes

- Blog posts published as drafts need Tim's review before going live. Once live, submit updated sitemap to GSC to accelerate indexing.
- The `/landing-page` noIndex is the highest-priority manual item — a paid landing page competing with the homepage for organic rankings is an ongoing authority drag.
- 48 pre-existing blog posts (some generic/old from prior team) remain candidates for noindex/redirect review. This will be assessed in the Month 1 on-page pass.
- Campaign is on track. All automatable items from the initial run were executed or logged for the correct deferred pass.
