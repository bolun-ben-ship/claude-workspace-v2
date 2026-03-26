# Schema / Structured Data Audit — Lian Kok Electrical
**Site:** https://liankok.com
**Date:** 2026-03-25
**Pages audited:** Homepage, /about/, /products/, /shop/, /contact/, /blog-2/, one live blog post, one WooCommerce product page

---

## Summary

All pages carry a single Yoast SEO-generated JSON-LD block using `@graph`. The base schema skeleton (Organization, WebSite, BreadcrumbList, WebPage) is present across the site, but the implementation has five confirmed bugs and is missing the most commercially important schema types for this business.

| Priority | Item | Status |
|---|---|---|
| CRITICAL | `WebSite.name` is a URL, not a name | Bug — all pages |
| CRITICAL | Image URLs point to `liankoks.com` (typo domain) | Bug — /about/, /contact/ |
| HIGH | No `LocalBusiness` schema anywhere | Missing |
| HIGH | No `Product` schema on WooCommerce product pages | Missing |
| HIGH | Blog posts use `Article` not `BlogPosting` | Wrong type |
| MEDIUM | `Organization` has no contact details | Incomplete |
| MEDIUM | `WebSite.description` is empty string | Incomplete |
| MEDIUM | `Article.author.name` is "admin" | Low quality |
| LOW | Homepage logo image is 87×86px (too small for Google) | Dimensions |
| LOW | `Article.keywords` only contain "All" and "LianKok" | Low quality |

---

## Page-by-Page Detection Results

### Homepage — https://liankok.com/

**Schema detected:** JSON-LD via Yoast `@graph`

| Type | Present | Notes |
|---|---|---|
| WebPage | Yes | |
| Organization | Yes | Missing: address, telephone, email, contactPoint |
| WebSite | Yes | `name` field is set to the URL string — should be the site name |
| BreadcrumbList | Yes | Only one item (Home) — correct for homepage |
| ImageObject (logo) | Yes | Dimensions 87×86px — Google recommends minimum 112×112px for logos |
| SearchAction | Yes | Correctly implemented |

**Validation result:** FAIL — `WebSite.name` is `"https://liankok.com/"` instead of `"Lian Kok Electrical"`.

---

### /about/ — https://liankok.com/about/

**Schema detected:** JSON-LD via Yoast `@graph`

| Type | Present | Notes |
|---|---|---|
| WebPage | Yes | |
| Organization | Yes | Same issues as homepage — no contact info |
| WebSite | Yes | Same `name` URL bug |
| BreadcrumbList | Yes | Correct: Home > About |
| ImageObject (primary) | Yes | **URL points to `liankoks.com`** — wrong domain, image will 404 |

**Validation result:** FAIL — `primaryImageOfPage` and `thumbnailUrl` both reference `https://liankoks.com/...` (missing "l" in "electrical"). This is a broken image reference in schema.

---

### /products/ — https://liankok.com/products/

**Schema detected:** JSON-LD via Yoast `@graph`

| Type | Present | Notes |
|---|---|---|
| WebPage | Yes | |
| Organization | Yes | |
| WebSite | Yes | Same `name` URL bug |
| BreadcrumbList | Yes | Correct: Home > Products |
| Product / ItemList | No | Missing — this page lists product categories |

**Validation result:** FAIL — missing `ItemList` or `CollectionPage` markup for the product listing context. `WebSite.name` URL bug persists.

---

### /shop/ — https://liankok.com/shop/

**Schema detected:** JSON-LD via Yoast `@graph`

| Type | Present | Notes |
|---|---|---|
| WebPage | Yes | No `dateModified` present |
| Organization | Yes | |
| WebSite | Yes | Same `name` URL bug |
| BreadcrumbList | Yes | Correct: Home > Shop |
| Product / ItemList | No | WooCommerce shop page has no product schema |

**Validation result:** FAIL — WooCommerce is installed and active but generates zero `Product` schema. Neither Yoast nor WooCommerce's built-in schema output any `Product` nodes on the shop archive or individual product pages.

---

### /contact/ — https://liankok.com/contact/

**Schema detected:** JSON-LD via Yoast `@graph`

| Type | Present | Notes |
|---|---|---|
| WebPage | Yes | |
| Organization | Yes | Has logo and sameAs, but no address, phone, or email |
| WebSite | Yes | Same `name` URL bug |
| BreadcrumbList | Yes | Correct: Home > Contact |
| LocalBusiness | No | Missing — this is the highest-value schema gap |
| ImageObject (primary) | Yes | **URL points to `liankoks.com`** — same typo domain bug as /about/ |

**Actual contact data visible on page:**
- Address: Block 681 Race Course Road, #01-317, Singapore 210681
- Phone: +65 6298 6822
- Email: sales@liankok.com
- Hours: Monday–Friday, 8:00 AM–5:00 PM

None of this appears in any schema block.

**Validation result:** FAIL — broken image URL, missing LocalBusiness, no contact details in schema.

---

### /blog-2/ — https://liankok.com/blog-2/

**Schema detected:** JSON-LD via Yoast `@graph`

| Type | Present | Notes |
|---|---|---|
| WebPage | Yes | No `dateModified` |
| Organization | Yes | |
| WebSite | Yes | Same `name` URL bug |
| BreadcrumbList | Yes | Correct: Home > Blog |
| BlogPosting / ItemList | No | Blog index has no schema for listed posts |

**Validation result:** FAIL — `WebSite.name` URL bug. No `ItemList` for blog listing.

---

### Individual blog post — /abb-mcb-complete-guide-to-miniature-circuit-breakers-in-singapore/

**Schema detected:** JSON-LD via Yoast `@graph`

| Type | Present | Notes |
|---|---|---|
| Article | Yes | Wrong type — should be `BlogPosting` |
| WebPage | Yes | |
| ImageObject | Yes | |
| BreadcrumbList | Yes | Correct |
| WebSite | Yes | Same `name` URL bug |
| Organization | Yes | |
| Person (author) | Yes | `author.name` is "admin" — not a real name |

**Article block issues:**
- `@type` is `Article` — for a blog, `BlogPosting` is more specific and preferred by Google
- `author.name` is `"admin"` — Google's article rich result guidelines require a real author name
- `keywords` only contain generic values: `["All", "LianKok"]` — not meaningful to search engines
- `articleSection` is `["recent"]` — a pagination label, not a content category
- `dateModified` is absent

**Validation result:** FAIL — wrong type, low-quality author name, meaningless keywords.

---

### WooCommerce product page — /product/miniature-circuit-breakers-mcbs-2/

**Schema detected:** 2 JSON-LD blocks

| Block | Type | Source | Issues |
|---|---|---|---|
| Block 1 | WebPage, Organization, WebSite, BreadcrumbList, ImageObject | Yoast | Same `name` URL bug |
| Block 2 | BreadcrumbList | WooCommerce | `@context` uses `"https://schema.org/"` (trailing slash — minor) |

**Product schema:** Completely absent. WooCommerce is not outputting any `Product`, `Offer`, `AggregateRating`, or related schema on product pages.

**Validation result:** FAIL — no Product rich result eligibility whatsoever.

---

## Confirmed Bugs (Fix First)

### Bug 1 — WebSite.name is a URL (all pages)
**Field:** `WebSite.name`
**Current value:** `"https://liankok.com/"`
**Required value:** A human-readable site name, e.g., `"Lian Kok Electrical"`
**Impact:** Google Sitelinks Searchbox and Knowledge Panel rely on this field. A URL as the name is invalid.
**Fix:** In Yoast SEO settings → Site Basics → set the site name.

---

### Bug 2 — Image URLs pointing to wrong domain (about, contact)
**Field:** `primaryImageOfPage`, `thumbnailUrl`, `ImageObject.url`, `ImageObject.contentUrl`
**Current value:** `https://liankoks.com/wp-content/uploads/...` (note: `liankoks.com`, not `liankok.com`)
**Impact:** Schema validators will flag these as broken/unresolvable URLs. Images will 404.
**Fix:** These appear to be Elementor-set featured images. Replace the featured images on /about/ and /contact/ with images hosted on `liankok.com`, or correct the media library entries.

---

### Bug 3 — WebSite.description is empty string (all pages)
**Field:** `WebSite.description`
**Current value:** `""`
**Fix:** Set the site tagline in WordPress Settings → General, or in Yoast SEO site-level settings.

---

### Bug 4 — Article author name is "admin" (blog posts)
**Field:** `Article.author.name`
**Current value:** `"admin"`
**Impact:** Google may suppress Article rich results when the author is clearly a system username.
**Fix:** Rename the WordPress user or create a named author account; assign blog posts to it.

---

### Bug 5 — Duplicate BreadcrumbList on product pages
**Issue:** Both Yoast and WooCommerce generate a `BreadcrumbList` block. Two competing breadcrumb blocks on one page can cause Google to use the wrong one.
**Fix:** Disable WooCommerce's own breadcrumb schema (in WooCommerce settings or via a filter) and let Yoast own all breadcrumb output.

---

## Missing Schema — Recommended Additions

### Priority 1 — LocalBusiness (homepage + contact page)

This is the single highest-value missing schema for a B2B distributor with a physical Singapore address. It enables Google's business Knowledge Panel display and rich results showing address, hours, and contact details.

```json
{
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  "@id": "https://liankok.com/#localbusiness",
  "name": "Lian Kok Electrical Pte Ltd",
  "url": "https://liankok.com/",
  "logo": "https://liankok.com/wp-content/uploads/2022/09/LKE-logo-w-name-transparent-1-1.png",
  "image": "https://liankok.com/wp-content/uploads/2022/09/LKE-logo-w-name-transparent-1-1.png",
  "description": "ABB Authorised Distributor since 1991. Singapore's leading provider of low voltage electrical products, wiring accessories, and circuit protection solutions.",
  "telephone": "+65-6298-6822",
  "email": "sales@liankok.com",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "Block 681 Race Course Road, #01-317",
    "addressLocality": "Singapore",
    "postalCode": "210681",
    "addressCountry": "SG"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": 1.3214,
    "longitude": 103.8560
  },
  "openingHoursSpecification": [
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": ["Monday","Tuesday","Wednesday","Thursday","Friday"],
      "opens": "08:00",
      "closes": "17:00"
    }
  ],
  "priceRange": "$$",
  "currenciesAccepted": "SGD",
  "areaServed": {
    "@type": "Country",
    "name": "Singapore"
  },
  "sameAs": [
    "https://www.facebook.com/liankok.electric/",
    "https://www.linkedin.com/company/lian-kok-electrical-pte-ltd",
    "https://www.instagram.com/lian.kok/",
    "https://www.tiktok.com/@lian.kok.electrical"
  ]
}
```

**Implementation note:** The `geo` coordinates above are approximate for Race Course Road, Singapore — verify exact coordinates before publishing. The `priceRange` value is a placeholder; omit this property if pricing is not publicly disclosed (the site currently shows no prices).

---

### Priority 2 — Product schema on WooCommerce product pages

WooCommerce product pages currently have no Product schema. This blocks Google Shopping eligibility and product rich results. Each product page needs a `Product` block.

The following is a template for `/product/miniature-circuit-breakers-mcbs-2/` — the pattern applies to all product pages:

```json
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "Miniature Circuit Breakers (MCBs)",
  "url": "https://liankok.com/product/miniature-circuit-breakers-mcbs-2/",
  "image": "https://liankok.com/wp-content/uploads/[product-image].jpg",
  "description": "ABB Miniature Circuit Breakers (MCBs) for low voltage circuit protection. Available in single pole, double pole, and three pole configurations for residential and commercial applications.",
  "brand": {
    "@type": "Brand",
    "name": "ABB"
  },
  "manufacturer": {
    "@type": "Organization",
    "name": "ABB Ltd",
    "url": "https://new.abb.com/"
  },
  "offers": {
    "@type": "Offer",
    "url": "https://liankok.com/product/miniature-circuit-breakers-mcbs-2/",
    "priceCurrency": "SGD",
    "availability": "https://schema.org/InStock",
    "seller": {
      "@type": "Organization",
      "name": "Lian Kok Electrical Pte Ltd",
      "url": "https://liankok.com/"
    }
  },
  "category": "Circuit Breakers"
}
```

**Implementation note:** Since the site does not display prices publicly, the `price` property should be omitted from `Offer` — `priceCurrency` and `availability` alone are valid. If price is never intended to be public, the entire `offers` block can be replaced with an `Offer` containing only `availability` and `seller`.

**Recommended implementation method:** Install the free "Schema & Structured Data for WP & AMP" plugin or use Yoast Premium's WooCommerce SEO add-on — both auto-generate Product schema from WooCommerce product data without manual coding.

---

### Priority 3 — Fix Article to BlogPosting on all blog posts

Replace `"@type": "Article"` with `"@type": "BlogPosting"` in the Yoast schema output for all posts. In Yoast SEO, this is controlled under SEO → Search Appearance → Content Types → Posts → Schema tab → set "Schema type" to "Blog Posting".

The corrected Article/BlogPosting node should also include:

```json
{
  "@context": "https://schema.org",
  "@type": "BlogPosting",
  "@id": "https://liankok.com/abb-mcb-complete-guide-to-miniature-circuit-breakers-in-singapore/#blogposting",
  "headline": "ABB MCB: Complete Guide to Miniature Circuit Breakers in Singapore",
  "url": "https://liankok.com/abb-mcb-complete-guide-to-miniature-circuit-breakers-in-singapore/",
  "datePublished": "2025-08-27T09:47:06+00:00",
  "dateModified": "2025-08-27T09:47:06+00:00",
  "author": {
    "@type": "Person",
    "name": "Lian Kok Electrical",
    "url": "https://liankok.com/about/"
  },
  "publisher": {
    "@type": "Organization",
    "name": "Lian Kok Electrical Pte Ltd",
    "url": "https://liankok.com/",
    "logo": {
      "@type": "ImageObject",
      "url": "https://liankok.com/wp-content/uploads/2022/09/LKE-logo-w-name-transparent-1-1.png"
    }
  },
  "image": "https://liankok.com/wp-content/uploads/2024/08/Untitled-design-91.png",
  "mainEntityOfPage": "https://liankok.com/abb-mcb-complete-guide-to-miniature-circuit-breakers-in-singapore/",
  "keywords": ["ABB MCB", "miniature circuit breakers", "low voltage", "Singapore", "circuit protection"],
  "articleSection": "Electrical Products",
  "wordCount": 1288,
  "inLanguage": "en-US"
}
```

---

### Priority 4 — Fix Organization schema sitewide

The existing `Organization` node on all pages is missing contact details. The Yoast `@graph` Organization node should be extended to include:

```json
{
  "@type": "Organization",
  "@id": "https://liankok.com/#organization",
  "name": "Lian Kok Electrical Pte Ltd",
  "url": "https://liankok.com/",
  "telephone": "+65-6298-6822",
  "email": "sales@liankok.com",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "Block 681 Race Course Road, #01-317",
    "addressLocality": "Singapore",
    "postalCode": "210681",
    "addressCountry": "SG"
  },
  "foundingYear": "1975",
  "logo": {
    "@type": "ImageObject",
    "@id": "https://liankok.com/#/schema/logo/image/",
    "url": "https://liankok.com/wp-content/uploads/2022/09/LKE-logo-w-name-transparent-1-1.png",
    "contentUrl": "https://liankok.com/wp-content/uploads/2022/09/LKE-logo-w-name-transparent-1-1.png",
    "width": 87,
    "height": 86,
    "caption": "Lian Kok Electrical Pte Ltd"
  },
  "sameAs": [
    "https://www.facebook.com/liankok.electric/",
    "https://www.linkedin.com/company/lian-kok-electrical-pte-ltd",
    "https://www.instagram.com/lian.kok/",
    "https://www.tiktok.com/@lian.kok.electrical"
  ]
}
```

**Note on `foundingYear`:** The site states "since 1975" — confirm the exact founding year before adding this field.

---

### Priority 5 — Fix WebSite name (all pages)

Replace the URL string with the actual site name. This is a Yoast setting change, not a code change.

```json
{
  "@type": "WebSite",
  "@id": "https://liankok.com/#website",
  "url": "https://liankok.com/",
  "name": "Lian Kok Electrical",
  "description": "ABB Authorised Distributor — Low Voltage Products & Wiring Accessories, Singapore",
  "publisher": {
    "@id": "https://liankok.com/#organization"
  },
  "potentialAction": {
    "@type": "SearchAction",
    "target": {
      "@type": "EntryPoint",
      "urlTemplate": "https://liankok.com/?s={search_term_string}"
    },
    "query-input": "required name=search_term_string"
  },
  "inLanguage": "en-US"
}
```

---

## Not Recommended

The following schema types were NOT recommended despite being common suggestions for this type of business:

- **FAQPage** — Restricted by Google since August 2023 to government and healthcare authority sites only. Not eligible for this business.
- **HowTo** — Rich results removed by Google in September 2023.
- **SpecialAnnouncement** — Deprecated July 2025.

---

## Implementation Priority Order

| Order | Action | Where | Effort |
|---|---|---|---|
| 1 | Fix `WebSite.name` — change from URL to "Lian Kok Electrical" | Yoast settings | 2 min |
| 2 | Fix `WebSite.description` — set site tagline | WordPress settings | 2 min |
| 3 | Fix broken `liankoks.com` image URLs on /about/ and /contact/ | Replace featured images in WP media library | 10 min |
| 4 | Fix author display name — rename "admin" user | WordPress Users settings | 5 min |
| 5 | Change blog post schema type from `Article` to `BlogPosting` | Yoast → Content Types → Posts → Schema | 2 min |
| 6 | Add `LocalBusiness` JSON-LD block to homepage and /contact/ | Yoast Local SEO plugin or custom code | 30 min |
| 7 | Extend `Organization` node with address, phone, email | Yoast Local SEO plugin (auto-populates) or custom | 15 min |
| 8 | Add `Product` schema to WooCommerce product pages | Yoast WooCommerce SEO add-on or free schema plugin | 1–2 hrs |
| 9 | Disable duplicate WooCommerce BreadcrumbList | Code filter in functions.php | 15 min |
| 10 | Update blog post keywords with real topic keywords | Post-by-post or via Yoast focus keyphrase | Ongoing |

Steps 1–5 are Yoast/WordPress settings changes — zero coding required. Steps 6–10 require either plugin installation or code.
