# Visual & Mobile SEO Audit — Lian Kok Electrical
**Date:** 2026-03-25
**Tool:** Playwright Chromium, automated DOM audit
**Pages audited:** Homepage (/), Products (/products/), Shop (/shop/)
**Viewports:** Desktop 1920×1080, Mobile 375×812

---

## Screenshots

| Page | Desktop | Mobile |
|---|---|---|
| Homepage | `screenshots/homepage-desktop.png` | `screenshots/homepage-mobile.png` |
| Products | `screenshots/products-desktop.png` | `screenshots/products-mobile.png` |
| Shop | `screenshots/shop-desktop.png` | `screenshots/shop-mobile.png` |

---

## Summary Scorecard

| Area | Rating | Severity |
|---|---|---|
| Value proposition clarity (desktop) | Pass | — |
| Value proposition clarity (mobile) | Partial | Medium |
| CTA above the fold | Fail | High |
| H1 tag usage | Critical fail | Critical |
| Meta descriptions (Products, Shop) | Missing | High |
| Navigation — desktop | Pass | — |
| Navigation — mobile | Pass (hamburger) | — |
| Mobile tap targets | Fail (multiple) | High |
| Horizontal scroll | Pass | — |
| Body font size | Pass (16px) | — |
| Shop page content | Critical fail | Critical |
| CLS risk | Medium | Medium |

---

## 1. Homepage — Desktop (1920×1080)

### Above-the-fold content
- **Logo:** Visible top-left, recognisable LKE triangle mark. Pass.
- **Navigation:** Full horizontal nav (Home, About Us, Products, Projects, Resources, Contact) visible at ~98px from top. Pass.
- **Top utility bar:** Phone number (+65 6298 6822), email (sales@liankok.com), Share icons, and a cart ($0.00) are visible.
- **Hero headline:** "Powering Singapore's Future" in large text, white on dark blue. Immediately visible above fold. Pass.
- **Value proposition:** Sub-heading "Your Trusted ABB Authorised Distributor Since 1991" + descriptor "Quality Electrical Solutions for Residential, Commercial, and Industrial Needs" is visible. Value proposition is clear.
- **CTA:** There is NO primary call-to-action button visible above the fold. No "Contact Us", "Get a Quote", "Browse Products", or similar conversion button appears in the hero. This is the most significant UX issue on the homepage. Fail.
- **Hero image:** Photo of the Lian Kok shopfront/showroom alongside an ABB product ad is visible. Relevant, trustworthy.
- **Contact info band:** Partially visible at the bottom of the fold — "General Enquiries", "Find Us On Map", and "Business Hours" cards begin to appear, which is useful but not a CTA.

### Layout issues
- The hero section on desktop is visually well-structured with no obvious overlapping elements.
- The absence of a call-to-action button in the hero is the dominant above-fold issue.

---

## 2. Homepage — Mobile (375×812)

### Above-the-fold content
- **Logo:** Visible top-left. Pass.
- **Navigation:** Hamburger menu (three-bar icon) visible top-right. Pass. Mobile nav items open as a full overlay with good 48px touch targets.
- **Hero headline:** "Powering Singapore's Future" renders on two lines, readable. Pass.
- **Sub-heading:** "Your Trusted ABB Authorised Distributor Since 1991" visible. Pass.
- **CTA:** No CTA button visible above fold. The hero fills most of the screen with the headline and a background image — no button before scrolling. Fail.
- **Body text below headline:** "Quality Electrical Solutions for Residential, Commercial, and Industrial Needs" is present but small relative to the hero image.
- **Contact band:** The "General Enquiries" section (phone + email) appears just below fold on mobile — requires ~100px scroll to reach.

### Mobile-specific issues
- The hero background image is large and takes up significant screen real estate without a conversion action attached to it.
- Social share icons (Facebook, Instagram) in the top utility bar render at only 20×20px on mobile — well below the 44px minimum tap target. Minor but present.
- "View more" buttons throughout the scrollable content are only 76×24px — failing the 44px minimum height requirement for tap targets. These appear repeatedly across the product showcase sections.
- "About More" button: 124×42px — marginally below the 44px minimum height.

---

## 3. H1 Tag Usage — Critical Issue

**All three pages have severe H1 abuse.** H1 tags should be used once per page for the primary topic. The audit found:

| Page | H1 count |
|---|---|
| Homepage | 46 H1 tags |
| Products | 28 H1 tags |
| Shop | 1 H1 tag (correct) |

**Root cause:** Every product card, project card, and blog post preview on the homepage and products page is rendered with an `<h1>` tag instead of `<h2>`, `<h3>`, or a semantic alternative. This is a critical SEO error that:

- Eliminates Google's ability to identify the page's primary topic
- Dilutes keyword authority across 46 competing signals
- Signals poor semantic structure to crawlers
- The homepage has no single `<h1>` that says "Lian Kok Electrical" or describes the page — all H1s are individual product names

**Expected fix:** The hero section should have one `<h1>` (e.g. "ABB Electrical Products Distributor Singapore") and all product titles should be `<h2>` or `<h3>`.

---

## 4. Meta Descriptions

| Page | Meta description |
|---|---|
| Homepage | "ABB Authorised Distributor since 1991. Singapore's leading provider of quality electrical solutions, low voltage products and wiring accessories since 1975" |
| /products/ | MISSING |
| /shop/ | MISSING |

The homepage meta description is present and well-written. Both the Products and Shop pages are missing meta descriptions entirely. Google will auto-generate these from page content, which often results in unhelpful or truncated snippets in search results.

---

## 5. Products Page (/products/)

### Desktop above-the-fold
- A large dark black banner with "Products - Lian Kok Electrical" and breadcrumb (Home > Products) occupies nearly the entire above-fold area.
- No introductory text, product category grid, or CTA is visible above the fold on desktop.
- The section below the fold begins with "Innovative Electrical Solutions for Every Need" (category navigation tabs visible at bottom of fold).
- The banner wastes ~400px of vertical space on desktop with only a page title. This pushes all product content below fold.

### Mobile above-the-fold
- The dark banner is even more dominant on mobile — it fills the entire 812px viewport with just the page title and breadcrumb.
- No product categories, no CTAs, no product images are visible before scrolling.
- The category filter tabs (Circuit Breakers, Motor protection, etc.) are 33px tall — below the 44px tap target minimum.

### Tab filter buttons (mobile)
Multiple filter buttons are 33px height: "Others", "Circuit Breakers", "Motor protection and control", "Residual Current Devices", "Softstarter", "Wiring Accessories", "All" — all fail the 44px tap target standard.

---

## 6. Shop Page (/shop/) — Critical Issue

### Both desktop and mobile
- The shop page renders with only a banner (page title + breadcrumb) and then immediately shows the footer.
- **Zero WooCommerce product listings are rendered in the DOM** — `product_count_in_dom: 0`.
- The page title is "Shop - Lian Kok Electrical" with a single H1 (correct structure), but there is no shop content.
- This could indicate:
  - WooCommerce shop is intentionally empty (products may live under /products/ instead)
  - Products exist but have not been published to the shop
  - A WooCommerce configuration issue where products are not assigned to the shop archive
  - A rendering issue where products load via JavaScript after the networkidle event

**This is either a broken page or an orphaned URL.** If the shop is not intended to be used, the URL should either redirect to /products/ or be removed from the sitemap. If it is intended as the e-commerce archive, products need to be published here.

---

## 7. Navigation Assessment

### Desktop
- Full horizontal nav is functional. All six items (Home, About Us, Products, Projects, Resources, Contact) visible and above fold.
- Nav link heights are 36px — slightly below the 44px tap target recommendation, though this is less critical on desktop.
- The cart icon is visible in the top-right, implying e-commerce functionality.

### Mobile
- Hamburger icon is visible and appropriately sized (≈ 44×44px).
- When the menu opens, all navigation links render at full width (350px wide, 48px tall) — good touch target sizing.
- A close button ("X") is 45×46px — acceptable.
- The social icons in the top utility bar (20×20px) are the only remaining tap target failure in the nav area.

---

## 8. CLS (Cumulative Layout Shift) Risk Assessment

Visual inspection and DOM analysis indicate moderate CLS risk:

- The hero image is a large asset loading over a background. If the image loads after text, the layout will shift.
- Multiple product carousel sections on the homepage load product images dynamically — each one is a potential CLS source if dimensions are not declared in CSS.
- The "Share" bar at the very top of the page (with social icons) loads before the main nav, which could cause a top-of-page shift.
- No explicit image width/height attributes were checked at code level, but the number of product images on the homepage (40+ H1 product entries suggests 40+ images) means multiple opportunities for layout shift.

A Lighthouse CLS score test is recommended as a follow-up.

---

## 9. Font Size Assessment

- Body font size: **16px** on all pages and viewports. Pass — meets the minimum readable text standard for mobile.
- No text-zoom issues detected in visual screenshots.

---

## 10. Horizontal Scroll

- No horizontal scrolling detected on any page or viewport. Pass.

---

## Priority Issue List

| # | Issue | Severity | Page(s) |
|---|---|---|---|
| 1 | 46 H1 tags on homepage; 28 on /products/ — all product cards use H1 | Critical | Homepage, Products |
| 2 | /shop/ page renders with zero products — empty or broken | Critical | Shop |
| 3 | No CTA button above the fold on homepage (desktop or mobile) | High | Homepage |
| 4 | /products/ and /shop/ missing meta descriptions | High | Products, Shop |
| 5 | Massive above-fold banner on /products/ wastes entire viewport with just a title | High | Products |
| 6 | "View more" buttons: 76×24px — far below 44px tap target minimum (appears 6+ times) | High | Homepage (mobile) |
| 7 | Category filter tabs on /products/: 33px height — below tap target minimum | Medium | Products (mobile) |
| 8 | Social icons in top utility bar: 20×20px — too small to tap reliably | Medium | All pages (mobile) |
| 9 | "About More" CTA: 124×42px — marginally below 44px standard | Medium | Homepage (mobile) |
| 10 | CLS risk from undeclared image dimensions across product carousels | Medium | Homepage, Products |
| 11 | Nav link height 36px on desktop — below recommended tap target | Low | All pages (desktop) |
| 12 | Footer social icons (Facebook, Instagram): 40×40px — marginally below 44px | Low | All pages (mobile) |

---

## Recommendations

### Immediate (Critical)

1. **Fix H1 structure across the site.** The homepage and /products/ page need one H1 each for the page topic. All product names should be demoted to H2 or H3 in the WordPress theme templates.
2. **Investigate and fix /shop/ page.** Either populate it with WooCommerce products, redirect it to /products/, or remove it from the sitemap and navigation.
3. **Add a CTA button to the homepage hero.** A button such as "Browse Products", "Contact Us", or "Get a Quote" placed directly in the hero section would capture intent from users who land and need an immediate next action.

### High Priority

4. **Add meta descriptions to /products/ and /shop/.** Each should be 150–160 characters describing the page's content with relevant keywords (e.g. "ABB circuit breakers, wiring accessories, and low voltage products — browse Lian Kok Electrical's full Singapore product range.").
5. **Reduce the /products/ banner height.** Replace the full-viewport dark banner with a compact page header (120–150px) so product categories are visible above the fold without scrolling.
6. **Increase "View more" button tap targets.** Add padding to reach at least 44px height. This affects multiple instances across the homepage product sections.

### Medium Priority

7. **Increase category filter tab height** on /products/ to at least 44px for mobile usability.
8. **Increase social icon tap targets** in the utility bar — wrap each icon in a larger clickable area (min 44×44px).
9. **Declare explicit width/height on images** in product card templates to reduce CLS risk.

---

*Audit produced by RightClick:AI Visual Analysis Agent — 2026-03-25*
