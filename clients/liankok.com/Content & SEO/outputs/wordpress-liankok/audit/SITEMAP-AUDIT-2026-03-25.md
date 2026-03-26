# Sitemap Audit — liankok.com
**Date:** 2026-03-25
**Auditor:** Sitemap Architecture Agent
**Site:** https://liankok.com (WordPress + WooCommerce)

---

## Executive Summary

The sitemap setup has one critical structural problem: two competing sitemap plugins are both active and both referenced in `robots.txt`. The Yoast SEO sitemap (`sitemap_index.xml`) is the more complete and modern one — it should be the sole active sitemap. The Google XML Sitemaps plugin (`sitemap.xml`) must be deactivated. Beyond that, the page sitemap contains significant content pollution: theme demo pages, automotive service pages, duplicate WooCommerce utility pages, and CartFlows checkout steps that should not be indexable.

All 9 key pages are confirmed present in the Yoast sitemap and return HTTP 200. WooCommerce product pages are included. Total URL count across Yoast sitemaps is 117 — well within the 50,000 limit.

---

## Sitemap Structure

### Discovered Sitemaps

| URL | Plugin | Status | Notes |
|-----|--------|--------|-------|
| `https://liankok.com/sitemap.xml` | Google XML Sitemaps | ACTIVE — should be deactivated | Sitemap index with 3 child sitemaps, 2 of which return 404 |
| `https://liankok.com/sitemap_index.xml` | Yoast SEO | ACTIVE — keep as sole sitemap | Complete sitemap index, 9 child sitemaps, all return 200 |
| `https://liankok.com/sitemap.html` | Google XML Sitemaps | Listed in robots.txt — should be removed | HTML page, not an XML sitemap; invalid robots.txt entry |

### robots.txt Conflict

`robots.txt` currently lists three sitemap declarations:

```
Sitemap: https://liankok.com/sitemap_index.xml   ← Yoast (correct)
Sitemap: https://liankok.com/sitemap.xml          ← Google XML Sitemaps (duplicate, conflicting)
Sitemap: https://liankok.com/sitemap.html         ← HTML page, not a sitemap (invalid)
```

Google will crawl all three. This means duplicate URL submissions, confusing signals, and 404 child sitemaps being crawled.

---

## Validation Checks

| Check | Result | Severity |
|-------|--------|----------|
| XML format valid — Yoast sitemaps | Pass | — |
| XML format valid — Google XML Sitemaps | Pass | — |
| Dual active sitemap plugins | FAIL | Critical |
| Two child sitemaps in sitemap.xml return 404 | FAIL | High |
| sitemap.html listed in robots.txt as a sitemap | FAIL | High |
| Total URL count under 50,000 | Pass (117 URLs) | — |
| CartFlows step page returns 500 error | FAIL | High |
| WooCommerce cart/checkout/accounts in sitemap (should be noindexed) | FAIL | High |
| Theme demo / template pages in sitemap | FAIL | High |
| Automotive service pages in sitemap (irrelevant to business) | FAIL | High |
| Duplicate WooCommerce utility pages in sitemap (shop-2, cart-2, checkout-2) | FAIL | Medium |
| `priority` and `changefreq` tags present (Google XML Sitemaps plugin) | Warning | Info |
| Duplicate image asset referenced 13+ times for homepage in page-sitemap | Warning | Low |
| Key pages present in Yoast sitemap | Pass | — |
| WooCommerce product pages present | Pass (21 products) | — |
| lastmod dates present on all Yoast URLs | Pass | — |

---

## URL Count — Yoast sitemap_index.xml (Active)

| Child Sitemap | URLs | Notes |
|---------------|------|-------|
| post-sitemap.xml | 24 | Blog posts + project posts |
| page-sitemap.xml | 48 | Pages (heavily polluted — see below) |
| product-sitemap.xml | 21 | WooCommerce products |
| product_cat-sitemap.xml | 6 | WooCommerce product categories |
| product_tag-sitemap.xml | 3 | WooCommerce product tags |
| cartflows_step-sitemap.xml | 2 | CartFlows checkout steps |
| category-sitemap.xml | 8 | Blog/post categories |
| post_tag-sitemap.xml | 4 | Post tags |
| categorie-sitemap.xml | 4 | Custom "categorie" taxonomy |
| **Total** | **120** | Includes URLs that should be removed |

Note: The `<loc>` count above includes the sitemap index itself in each file's grep count. Actual URL count is approximately 117 indexable URLs.

---

## Key Page Verification

All 9 requested pages are present in the Yoast `page-sitemap.xml` and return HTTP 200.

| Page | In Sitemap | HTTP Status | lastmod |
|------|-----------|-------------|---------|
| https://liankok.com/ | Yes (page-sitemap) | 200 | 2026-03-13 |
| https://liankok.com/about/ | Yes | 200 | 2024-10-14 |
| https://liankok.com/products/ | Yes | 200 | 2025-06-30 |
| https://liankok.com/shop/ | Yes | 200 | 2023-08-08 |
| https://liankok.com/blog-2/ | Yes | 200 | 2024-10-18 |
| https://liankok.com/contact/ | Yes | 200 | 2024-09-17 |
| https://liankok.com/faq/ | Yes | 200 | 2022-10-01 |
| https://liankok.com/projects/ | Yes | 200 | 2024-09-20 |
| https://liankok.com/resources/ | Yes | 200 | 2024-10-21 |

---

## Problems Found in Detail

### 1. Dual Sitemap Plugins Active (Critical)

Two plugins are generating sitemaps simultaneously:
- **Google XML Sitemaps** (plugin: `google-sitemap-generator`, version 4.1.21) → `sitemap.xml`
- **Yoast SEO** → `sitemap_index.xml`

Both are declared in `robots.txt`. The Google XML Sitemaps index references two 404 child sitemaps (`producttags-sitemap.xml`, `productcat-sitemap.xml`). The Yoast sitemap is more complete and uses the correct Yoast XSL styling.

**Fix:** Deactivate and delete the Google XML Sitemaps plugin. Remove the two non-Yoast `Sitemap:` lines from `robots.txt` (Yoast manages its own `robots.txt` entry automatically).

---

### 2. CartFlows Step Returns HTTP 500 (High)

`https://liankok.com/step/store-checkout-thank-you-03/` returns a 500 Internal Server Error.

This URL is listed in `cartflows_step-sitemap.xml`. A 500 error signals a broken page to Googlebot and may cause crawl budget waste or negative quality signals.

**Fix:** Either repair the CartFlows thank-you step so it returns 200, or remove it from the sitemap and exclude the `cartflows_step` post type from Yoast's sitemap settings entirely.

---

### 3. WooCommerce Utility Pages in Sitemap — Not Noindexed (High)

The following transactional/utility pages are in `page-sitemap.xml` with no `noindex` directive in meta robots or `X-Robots-Tag` headers:

| URL | Issue |
|-----|-------|
| https://liankok.com/cart/ | WooCommerce cart — should be noindexed |
| https://liankok.com/checkout/ | WooCommerce checkout — should be noindexed |
| https://liankok.com/cart-2/ | Duplicate/legacy cart page — should be noindexed |
| https://liankok.com/checkout-2/ | Duplicate/legacy checkout — should be noindexed |
| https://liankok.com/accounts/ | User accounts page — should be noindexed |
| https://liankok.com/step/store-checkout-03/ | CartFlows checkout step — should be noindexed |

Yoast SEO should automatically noindex WooCommerce cart/checkout pages, but it is not doing so here. This may indicate Yoast's WooCommerce integration is misconfigured.

**Fix:** In Yoast SEO → Search Appearance → Content Types, or via individual page Yoast settings, set noindex on all cart, checkout, and accounts pages. Then remove them from the sitemap. Alternatively, exclude the `cartflows_step` post type from Yoast sitemaps entirely.

---

### 4. Theme Demo / Template Pages Polluting Sitemap (High)

The `page-sitemap.xml` contains pages that are clearly leftover theme demo content from the WordPress theme installation. These pages have no relevance to Lian Kok Electrical and are indexed with no noindex protection:

**Automotive service pages (completely irrelevant to business):**
- `/tire-balance/`
- `/change-oil-filter/`
- `/clutch-replacement/`
- `/engine-replace/`
- `/filter-check-up/`
- `/vehicle-wiring/`

**Generic theme demo pages:**
- `/sample-page-2/`
- `/home-page-two/`
- `/onepage-home/`
- `/rtl-homepage/`
- `/blog-grid/`
- `/chch/`
- `/2802-2/`
- `/about-2/`

**Theme service detail templates:**
- `/data-system-wiring/`
- `/generator-ups-systems/`
- `/panel-upgrades-system/`
- `/outdoor-and-motion-lighting/`
- `/digital-thermostat-installation/`
- `/baseboard-heating-installation/`
- `/better-performance/`
- `/landscape-lighting/`
- `/house-wiring-repair/`
- `/safety-inspection/`
- `/wiring-repair/`
- `/service/`
- `/service-details/`
- `/pricing/`
- `/team/`
- `/team-details/`
- `/testimonials/`
- `/portfolio-details/`
- `/our-clients/`
- `/appointment/`

All of these pages are live (returning 200), not noindexed, and submitted to Google via the sitemap. Google will crawl and attempt to index them, consuming crawl budget and potentially diluting the site's topical authority signal.

**Fix:** For each of these pages:
1. If the page has no real content and is not linked from navigation, delete it permanently.
2. If it cannot be deleted immediately, set noindex via Yoast on each page — this will automatically remove it from the Yoast sitemap.
3. Delete is strongly preferred over noindex for pages with no purpose.

---

### 5. Placeholder Blog Posts in Post Sitemap (High)

`post-sitemap.xml` contains posts that are clearly theme/plugin demo content, not business content:

| URL | Issue |
|-----|-------|
| `/hello-world/` | Default WordPress installation post |
| `/what-can-paralegals-do-a-guide-for-lawyers/` | Completely off-topic demo post |
| `/blog-standard/` | Theme blog demo page listed as a post |

These are indexed, not noindexed, and submitted via sitemap.

**Fix:** Delete these posts permanently. The `/blog-standard/` URL appears to be a page rather than a post — verify and delete.

---

### 6. Duplicate WooCommerce Utility Pages — Legacy (Medium)

The sitemap contains both `/shop/` and `/shop-2/`, both `/cart/` and `/cart-2/`, both `/checkout/` and `/checkout-2/`. The `-2` variants have `lastmod` dates from September 2022, indicating they are legacy pages from a prior site build.

**Fix:** Delete the `-2` variants or set them to noindex and redirect to the canonical versions.

---

### 7. `categorie` Taxonomy — Unclear Purpose (Medium)

The `categorie-sitemap.xml` contains 4 URLs under `/categorie/` — a custom taxonomy separate from WooCommerce's `product-category`. These pages appear to be a redundant product categorisation layer:

- `/categorie/abb-low-voltage-products/`
- `/categorie/residual-current-devices/`
- `/categorie/softstarter/`
- `/categorie/motor-protection/`

These overlap topically with `/product-category/` URLs already in `product_cat-sitemap.xml`. If these are not actively used for navigation or content, they add duplicate taxonomy pages.

**Fix:** Audit whether the `categorie` taxonomy is actively used on the site. If not, noindex these pages and consider removing the custom taxonomy.

---

### 8. Deprecated Sitemap Tags — Google XML Sitemaps (Info)

The Google XML Sitemaps plugin outputs `<changefreq>` and `<priority>` tags in `sitemap-misc.xml`. Both of these tags are ignored by Google and have been since at least 2023. They add no value and are a signal that the plugin is outdated.

This is resolved automatically once the Google XML Sitemaps plugin is deactivated (see item 1).

---

### 9. Duplicate Image Assets in page-sitemap.xml (Low)

The homepage entry in `page-sitemap.xml` references `Background-7.png` 13 times as a `<image:image>` entry. The `/products/` page references `Background-10.png` 22 times. This is caused by a page builder repeating the same background image across multiple sections and Yoast registering each instance.

This does not affect crawling or indexing but adds bloat to the sitemap file.

**Fix:** No immediate action required. Yoast cannot easily deduplicate these — it reflects page builder structure. Lower priority than content issues above.

---

### 10. lastmod Accuracy (Low)

The `faq/` page has a `lastmod` of `2022-10-01` — over 3.5 years ago. If the FAQ has been updated since, the lastmod is inaccurate. Yoast derives lastmod from WordPress's `post_modified` field, so this date reflects the last time the page was saved in the WordPress editor. If the content was updated but not re-saved, the date will be stale.

All other pages show plausible lastmod dates.

**Fix:** Open the FAQ page in WordPress editor, make a minor save (add/remove a space), and publish to force an updated `post_modified` timestamp if the content has been changed.

---

## Missing Key Pages

No key pages are missing from the Yoast sitemap. All 9 verified pages are present.

However, these pages that arguably should be in the sitemap are currently NOT present:

| Missing URL | Reason to Add |
|------------|---------------|
| Individual project pages (HDB Punggol West, Jurong West, Tengah, etc.) | These are in `post-sitemap.xml` — confirmed present as posts |

All project pages (HDB Punggol West, Jurong West, Tengah, Tangerine Grove, Tee Yih Jia, SIM University, SMU, NUS, National Junior College, LTA Office, Jln Besar Plaza, Lim Chee Guan, ST Engineering) are present in `post-sitemap.xml`. No missing pages detected.

---

## Prioritised Fix List

| Priority | Action | Where |
|----------|--------|-------|
| 1 — Critical | Deactivate and delete Google XML Sitemaps plugin | WordPress admin → Plugins |
| 2 — Critical | Remove duplicate Sitemap lines from robots.txt (done automatically once plugin is deactivated if Yoast manages robots.txt) | Yoast SEO → Tools → File Editor |
| 3 — High | Delete all theme demo pages (automotive, generic templates — ~30 pages) | WordPress admin → Pages → Trash |
| 4 — High | Delete placeholder blog posts (hello-world, paralegal post, blog-standard) | WordPress admin → Posts → Trash |
| 5 — High | Noindex or delete WooCommerce cart, checkout, accounts pages | Yoast SEO per-page settings OR Yoast → Search Appearance → WooCommerce |
| 6 — High | Noindex CartFlows step pages (or exclude post type from Yoast sitemaps) | Yoast SEO → Search Appearance → Post Types → CartFlows Step |
| 7 — High | Fix or delete CartFlows thank-you page returning 500 | WordPress admin → CartFlows |
| 8 — Medium | Delete or redirect legacy -2 pages (shop-2, cart-2, checkout-2, about-2, sample-page-2) | WordPress admin → Pages |
| 9 — Medium | Audit and noindex the `categorie` custom taxonomy if not actively used | Yoast SEO → Search Appearance → Taxonomies |
| 10 — Low | Force re-save of FAQ page to update lastmod if content has changed | WordPress editor → FAQ page → Update |

---

## Post-Cleanup Sitemap Health Targets

After executing the fix list above, the Yoast sitemap should contain approximately:

| Sitemap | Expected URLs | Notes |
|---------|--------------|-------|
| post-sitemap.xml | ~20 | Remove 3–4 demo/off-topic posts |
| page-sitemap.xml | ~10 | Remove ~38 template/utility pages |
| product-sitemap.xml | 21 | No changes needed |
| product_cat-sitemap.xml | 6 | No changes needed |
| product_tag-sitemap.xml | 3 | No changes needed |
| category-sitemap.xml | 5–6 | Remove irrelevant categories |
| post_tag-sitemap.xml | 4 | No changes needed |
| categorie-sitemap.xml | 0 or 4 | Noindex or delete taxonomy |
| cartflows_step-sitemap.xml | 0 | Exclude post type |
| **Total** | **~70** | Lean, accurate sitemap |
