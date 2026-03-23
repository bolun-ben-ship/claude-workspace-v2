# Implementation Plan — AI SEO Pipeline Initial Run
**Date:** 2026-03-23
**Platform:** Webflow (aexphl)
**Status:** PENDING APPROVAL
**Scope:** On-page SEO changes for all static pages + internal link injection into high-impression blog posts
**Building on:** POST-IMPLEMENTATION-AUDIT-2026-03-20 (blog meta titles + descriptions already done)

---

## Context

The 2026-03-20 implementation addressed the 4 highest-CTR-gap blog posts (meta title + descriptions).
This plan addresses everything that remains:
- Static page SEO titles and meta descriptions (all keyword-barren)
- noindex for paid landing pages leaking PageRank
- Internal links injected into the 4 updated blog posts (API-executable)
- Schema markup (manual — requires custom code embed in Webflow Designer)
- HTTP non-www redirect (manual — DNS/hosting level)

Audit baseline: **47/100** (2026-03-19)
Organic sessions baseline: **294/month** (GA4, Feb–Mar 2026)
Blog CTR fix already executed: 4 posts updated 2026-03-20

---

## Plan Summary

| Category | Changes Proposed | Via API | Manual Required |
|---|---|---|---|
| A — Static Page SEO Titles | 5 pages | 5 | 0 |
| B — Static Page Meta Descriptions | 5 pages | 5 | 0 |
| C — Blog SEO Titles | 0 (done 2026-03-20) | — | — |
| D — Blog Meta Descriptions | 0 (done 2026-03-20) | — | — |
| E — noindex (Technical) | 2 pages | 2 | 0 |
| F — Schema Markup | 4 schema blocks | 0 | 4 |
| G — Internal Links in Existing Blogs | 4 blog posts | 4 | 0 |
| H — HTTP Redirect Fix | 1 | 0 | 1 |

---

## Category A — Static Page SEO Titles

All executed via Webflow Data API (`data_pages_tool` → update `seo.title`).

| Page | Before | After | Priority |
|---|---|---|---|
| `/about` | About - AEHL | Meet the Aussie Expat Home Loans Team — Singapore, HK & Melbourne | HIGH |
| `/services` | Home Loan Servicing - AEHL | Expat Home Loan Services — Purchase, Refinance & Borrowing Capacity | HIGH |
| `/faqs` | FAQs - AEHL | Australian Expat Home Loan FAQs — Aussie Expat Home Loans | HIGH |
| `/book-appointment` | Book Appointment - Schedule Your Visit! | Book a Free Expat Mortgage Consultation — Aussie Expat Home Loans | MED |
| `/stamp-duty-calculator` | Stamp Duty Calculator - AEHL | Stamp Duty Calculator for Australian Expats — AEXPHL | MED |

**Note:** Homepage title ("Australian Expat Mortgage Broker - Aussie Expat Home Loans") is already strong — no change.
Brand standardisation: all titles use "Aussie Expat Home Loans" consistently, eliminating "AEHL" acronym.

---

## Category B — Static Page Meta Descriptions

All executed via Webflow Data API (`data_pages_tool` → update `seo.description`).

| Page | Before | After | Priority |
|---|---|---|---|
| `/about` | (auto-generated / missing) | The team behind Aussie Expat Home Loans — specialists in Australian mortgages for expats in Singapore, Hong Kong, and Dubai. Meet Tim and the team. | HIGH |
| `/services` | (auto-generated / missing) | Home loan origination, refinancing, and borrowing capacity assessments for Australian expats overseas. We handle the whole process remotely. | HIGH |
| `/faqs` | (auto-generated / missing) | Common questions about Australian expat home loans — income assessment, deposits, lender policy, foreign currency, and the approval process. | HIGH |
| `/book-appointment` | (auto-generated / missing) | Book a free consultation with an Australian expat mortgage specialist. We assess your borrowing capacity and walk you through your options — no obligation. | MED |
| `/stamp-duty-calculator` | (auto-generated / missing) | Calculate stamp duty on Australian property as an expat. Enter state, property value and buyer type to get your estimate — includes foreign buyer surcharges. | MED |

---

## Category E — noindex (Technical)

Executed via Webflow Data API (`data_pages_tool` → update `seo.noIndex: true`).

| Page | Current | Proposed | Reason | Priority |
|---|---|---|---|---|
| `/landing-page` | Indexed | noindex, nofollow | Paid Google Ads page — indexed version dilutes homepage authority and cannibalises organic rankings | 🔴 CRITICAL |
| `/landing-page-v2` | Indexed | noindex | Staging/revamp page — creates duplicate content signal against homepage | HIGH |

---

## Category F — Schema Markup (Manual — Webflow Designer)

Cannot be executed via Webflow Data API. Each requires adding a `<script type="application/ld+json">` block via page settings → Custom Code → Head Code in Webflow Designer.

### F1. Organization + LocalBusiness Schema — Homepage

**Page:** `/`
**Action:** Add to Head Code in Webflow page settings

```json
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": "https://www.aexphl.com/#organization",
      "name": "Aussie Expat Home Loans",
      "url": "https://www.aexphl.com",
      "logo": "https://www.aexphl.com/logo.png",
      "contactPoint": [
        {
          "@type": "ContactPoint",
          "telephone": "+65-6050-5259",
          "contactType": "customer service",
          "areaServed": "SG"
        },
        {
          "@type": "ContactPoint",
          "telephone": "+852-6475-3895",
          "contactType": "customer service",
          "areaServed": "HK"
        },
        {
          "@type": "ContactPoint",
          "telephone": "+61-3-9125-1190",
          "contactType": "customer service",
          "areaServed": "AU"
        }
      ],
      "sameAs": [
        "https://www.linkedin.com/company/aussie-expat-home-loans"
      ]
    },
    {
      "@type": "FinancialService",
      "@id": "https://www.aexphl.com/#financialservice",
      "name": "Aussie Expat Home Loans",
      "description": "Specialist mortgage brokerage for Australian expats buying or refinancing property in Australia while living overseas.",
      "url": "https://www.aexphl.com",
      "telephone": "+65-6050-5259",
      "address": [
        {
          "@type": "PostalAddress",
          "streetAddress": "1 Phillip St, Royal One Phillip",
          "addressLocality": "Singapore",
          "addressCountry": "SG"
        }
      ],
      "areaServed": ["SG", "HK", "AE", "AU"],
      "hasCredential": "Australian Credit Licence 509125"
    }
  ]
}
```

### F2. FAQPage Schema — /faqs

**Page:** `/faqs`
**Action:** Add to Head Code in Webflow page settings
*(Exact FAQ content to be pulled from live page — structure below, fill with actual Q&A from page)*

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "Can Australian expats get a home loan in Australia?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes. Australian citizens and permanent residents living overseas can apply for Australian home loans. Most lenders will assess your application — the key difference is how your foreign income is treated. Currency shading, income type, and lender policy all affect how much you can borrow."
      }
    },
    {
      "@type": "Question",
      "name": "How much deposit do Australian expats need?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Most lenders require a 20–30% deposit from expat borrowers. Some lenders will go to 90% LVR with LMI, but expat lending policies vary significantly. A specialist broker can identify which lenders will accept your income structure and deposit level."
      }
    },
    {
      "@type": "Question",
      "name": "Can I refinance my Australian mortgage while living overseas?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes. Refinancing from overseas is straightforward with the right broker. The process is the same as a new application — income verification, credit assessment, and documentation — all manageable remotely. Many expats refinance to better rates or release equity without returning to Australia."
      }
    }
  ]
}
```

### F3. Article + Author Schema — Blog Posts (all existing posts)

**Pages:** All blog posts under `/blog/`
**Action:** Add to each blog post's Head Code in Webflow CMS collection template settings (applies to all posts at once)

```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "author": {
    "@type": "Person",
    "name": "Tim Raes",
    "jobTitle": "Founder, Aussie Expat Home Loans",
    "url": "https://www.aexphl.com/about"
  },
  "publisher": {
    "@type": "Organization",
    "name": "Aussie Expat Home Loans",
    "url": "https://www.aexphl.com"
  }
}
```
*Note: Apply at the CMS collection template level — this covers all blog posts in one edit.*

### F4. BreadcrumbList Schema — All Pages

**Action:** Add to global site `<head>` (Webflow site settings → Custom Code) or per page.

```json
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "https://www.aexphl.com"
    }
  ]
}
```
*Per-page breadcrumbs should extend this with the current page name and URL.*

---

## Category G — Internal Links in Existing Blog Posts (API-executable)

These 4 blog posts were updated 2026-03-20 for meta titles/descriptions. They currently have no internal links to conversion pages or tools. We will inject internal link HTML into their body content via Webflow CMS API.

**Links to add to each post:**
1. A contextual link to `/calculators` ("check your borrowing capacity" anchor) — mid-post
2. A contextual link to `/book-appointment` ("book a free call" or "speak with a specialist") — end of post

| Post | CMS Item ID | Internal Links to Add |
|---|---|---|
| `/blog/australian-expat-home-loan` | `66104f746ff4cec5f0bcddee` | /calculators (mid), /book-appointment (end) |
| `/blog/housing-interest-rates-australia` | `6610502613f26e657abf2667` | /calculators (mid), /book-appointment (end) |
| `/blog/minimum-house-deposit-australia` | `6610520150da980371228540` | /calculators (mid), /book-appointment (end) |
| `/blog/australia-home-loan` | `66104f166305423fcf259fb3` | /calculators (mid), /book-appointment (end) |

**Execution method:** Webflow CMS API via MCP — fetch current body content, inject link HTML at appropriate points, update collection item, publish.

---

## Category H — HTTP Non-www Redirect (Manual)

**Issue:** `http://www.aexphl.com/` generates 1,637 GSC impressions. GSC is tracking HTTP and HTTPS as separate properties, indicating the redirect may not be 100% clean.

**Action required:**
1. Log in to Webflow Hosting settings for aexphl site
2. Confirm "Redirect HTTP to HTTPS" is enabled
3. Confirm "Redirect www to non-www" (or vice versa) is consistently set
4. In Google Search Console: set preferred domain and submit canonical sitemap

This cannot be done via API. Flag for Tim to action in Webflow dashboard.

---

## Expected Impact

| Change | Metric | Expected Outcome |
|---|---|---|
| Static page SEO titles (5 pages) | CTR on branded/navigational queries | +CTR lift on /about, /services, /faqs |
| noindex /landing-page | PageRank consolidation | Homepage authority improves over 4–8 weeks |
| Schema — Organization/LocalBusiness | Brand entity in Knowledge Graph | Improved SERP appearance, rich results |
| Schema — FAQPage | /faqs SERP | Rich result eligibility — direct Q&A in SERP |
| Schema — Article/Author | Blog posts E-E-A-T | AI citation readiness, YMYL trust signal |
| Internal links in 4 blog posts | Conversion path | Clicks to /calculators and /book-appointment from high-impression posts |

Estimated audit score after execution: **57–62/100** (from 47/100 baseline)

---

## Execution Order

1. Category E first (noindex) — prevents further PageRank leak
2. Category A + B together (page titles + meta) — one pass via Data API
3. Category G (internal links in blog posts) — one pass via CMS API
4. Category F (schema) — manual, Tim to action in Webflow Designer
5. Category H (HTTP redirect) — manual, Tim to action in Webflow Hosting

---

## What Is NOT Being Changed

- Homepage SEO title (already strong)
- Blog post slugs (URL integrity)
- Blog post body content beyond internal link injection
- Blog post meta titles/descriptions (done 2026-03-20)
- Any page design elements
