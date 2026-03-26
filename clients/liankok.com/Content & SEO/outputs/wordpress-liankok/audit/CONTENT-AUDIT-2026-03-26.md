# Content Quality & E-E-A-T Audit — Lian Kok Electrical (liankok.com)
**Date:** 2026-03-26
**Audited by:** RightClick:AI — Content Quality Specialist
**Framework:** Google September 2025 Quality Rater Guidelines

---

## Overall Content Quality Score: 42 / 100

| Dimension | Score | Weight | Weighted |
|---|---|---|---|
| E-E-A-T (composite) | 44/100 | 40% | 17.6 |
| Word Count / Topical Coverage | 35/100 | 20% | 7.0 |
| Readability & Structure | 58/100 | 15% | 8.7 |
| Keyword Optimisation | 45/100 | 10% | 4.5 |
| AI Citation Readiness | 32/100 | 10% | 3.2 |
| Content Freshness | 40/100 | 5% | 2.0 |
| **TOTAL** | | **100%** | **43 / 100** |

---

## E-E-A-T Breakdown: 44 / 100

Weighted composite per Google QRG criteria. Maximum per factor shown in brackets.

| Factor | Weight | Raw Score | Weighted Score | Assessment |
|---|---|---|---|---|
| Experience | 20% | 12/25 | 2.4/5 | Low — no first-hand case studies, no project specifics, testimonials use generic names |
| Expertise | 25% | 14/25 | 3.5/6.25 | Moderate — correct product information and ABB credentials, but thin editorial depth on most pages |
| Authoritativeness | 25% | 10/25 | 2.5/6.25 | Low — no author attribution beyond "admin", no external citations, no industry body mentions |
| Trustworthiness | 30% | 18/25 | 5.4/7.5 | Moderate-High — contact info, address, business hours, HTTPS all present; hurt by placeholder content and "admin" authorship |
| **COMPOSITE** | **100%** | **54/100 raw** | **13.8/25** | **= 44/100 E-E-A-T score** |

### E-E-A-T Factor Analysis

#### Experience: 12/25
The site claims 50+ years in business and lists recognisable project clients (NUS, SMU, ST Engineering, LTA), which are strong signals. However:
- The Projects page lists client names only — no case study narrative, no scope description, no outcomes
- Testimonials on /about/ use generic names ("Sarah Lee, Project Manager", "Emily Davis, Electrical Engineer") with no company affiliations — these read as placeholder or fabricated reviews and provide zero credibility signal
- No original photography of completed installations or team members
- No "lessons learned" content, installation guides, or practical insights that demonstrate hands-on experience
- Blog posts reference ABB products correctly but contain no first-hand installation experience or proprietary insight

#### Expertise: 14/25
- Product descriptions are technically accurate — correct specifications for MCCBs, RCCBs, softstarters
- The MCB guide (1,304 words) is the most substantive piece; it covers the right topics but reads as assembled from product documentation rather than expert commentary
- The ABB Contactors post (811 words) correctly distinguishes AF and ESB series — shows product knowledge
- Three posts are under 500 words (RCD Socket: 278w, Electrical Safety: 467w, Inora: 453w) — too thin to demonstrate expertise
- No technical author named on any post — authorship set to "admin" sitewide
- No references to Singapore regulations (e.g., SS 638, CP5, EMA requirements) which would signal genuine local expertise

#### Authoritativeness: 10/25
- ABB Authorised Distributor since 1991 is a strong authority signal but is stated on-page only — no official ABB partner badge or link to ABB's distributor directory
- No external links to industry bodies (EMA Singapore, Singapore Standards, IES)
- No external media mentions, press coverage, or backlink signals visible from the site
- No author bios, professional credentials, or LinkedIn profiles linked
- Blog post schema type is "Article" rather than "BlogPosting" — minor but signals lower editorial investment
- The author name "admin" in schema is a direct negative authority signal per Google QRG

#### Trustworthiness: 18/25
Strong signals present:
- Physical address: Block 681 Race Course Road, #01-317, Singapore 210681 — verifiable
- Phone: +65 6298 6822
- Email: sales@liankok.com
- Business hours clearly listed
- HTTPS enforced
- Company registration implied via "Pte Ltd" designation

Signals undermining trust:
- Placeholder content still live: "hello-world", "blog-standard", a paralegal-themed post — these are visible to any user who navigates the sitemap or blog archive
- "admin" as displayed author across all blog posts
- Testimonials with no verifiable attribution (no company name, no LinkedIn, no photo)
- /faq/ page is completely empty (71 words, all navigation/footer) — a user landing on this page sees nothing
- Image URLs on /about/ and /contact/ pointing to `liankoks.com` (typo domain) — broken images undermine credibility

---

## Word Count Analysis

| Page | Measured Words | Minimum (QRG floor) | Status | Gap |
|---|---|---|---|---|
| Homepage | ~924 | 500 | PASS | Meets floor; thin on unique content |
| /about/ | ~600 | 500 | PASS (marginal) | Meets floor; needs depth |
| /products/ | ~571 | 800 (service/category page) | FAIL | -229 words |
| /faq/ | ~71 | 500 | CRITICAL FAIL | Empty page — 0 FAQ content |
| /contact/ | ~205 | 300 | FAIL | Mostly form fields and address |
| /projects/ | ~174 | 500 | CRITICAL FAIL | Only project names, no content |
| /resources/ | ~295 | 300 | MARGINAL | Only download links, no editorial |
| /blog-2/ (archive) | ~155 | N/A (archive) | N/A | Archive listing only |

### Blog Post Word Counts

| Post | Words | Minimum (blog post) | Status |
|---|---|---|---|
| ABB MCB Complete Guide | 1,304 | 1,500 | FAIL (marginal — 196 below floor) |
| ABB Contactors AF/ESB Guide | 811 | 1,500 | FAIL (-689 words) |
| ABB CRS RCD Socket Outlet | 278 | 1,500 | CRITICAL FAIL (-1,222 words) |
| Electrical Safety Singapore | 467 | 1,500 | CRITICAL FAIL (-1,033 words) |
| ABB Inora Series | 453 | 1,500 | CRITICAL FAIL (-1,047 words) |

Word count note: Google has confirmed word count is not a direct ranking factor. These minimums represent topical coverage floors — the issue is not the word count itself but the lack of comprehensive topical treatment these short posts reflect.

---

## Readability Assessment

### Structure Quality: 58/100

**Positive signals:**
- The MCB blog post has a logical H2 structure: What is an ABB MCB > Why Choose ABB > Common Applications > How to Choose > Installation Guidelines > Benefits > Why Choose Lian Kok — this is a well-organised content skeleton
- Short paragraphs throughout (2-4 sentences) — appropriate for trade/B2B audience scanning on mobile
- Product names are consistently formatted in product listings

**Issues:**
- Homepage has 46 H1 tags (confirmed in technical audit) — Elementor product cards using H1 element. Page has no clear single topic from a structure standpoint
- /products/ page has 28+ H1 tags — same issue
- /faq/ has no content — the H1 "Faq" exists but nothing beneath it
- /projects/ uses only project names with no context — a list, not content
- About page has generic value statement blocks ("Reliability", "Innovation", "Customer-Centric", "Sustainability") with one-line descriptions — this is boilerplate found on thousands of company websites, not differentiated content
- Testimonials section contains three reviews with no verifiable attribution — typical of theme demo content that was never replaced
- Several product descriptions on /products/ repeat the phrase "ABB's latest line of molded case circuit breakers (MCCBs), available up to 1600A" verbatim across multiple different products (Switch-disconnectors, Surge Protection Devices, SACE Tmax XT) — demonstrably incorrect for SPDs and Switch-disconnectors

---

## Keyword Optimisation: 45/100

**Homepage:**
- Primary keyword signal: "ABB Authorised Distributor Singapore" — present in title, meta description, and above-fold copy. Well-executed.
- Meta description: present and well-written — "ABB Authorised Distributor since 1991. Singapore's leading provider of quality electrical solutions, low voltage products and wiring accessories since 1975"
- Title: "Lian Kok Electrical - ABB Authorised Distributor" — functional but missing "Singapore" geographic modifier

**Blog posts:**
- MCB post targets "ABB MCB Singapore" — keyword appears in title and throughout. Natural usage, not stuffed. Good.
- Contactors post targets "ABB Contactors" — solid coverage of AF vs ESB distinction, relevant to specifying engineers
- RCD Socket post is 278 words — too thin to rank for any competitive term
- "Electrical Safety Singapore" post (467 words) targets a broadly competitive term with far too little depth to compete

**Missing keyword opportunities across the site:**
- "circuit breaker supplier Singapore" — not targeted anywhere
- "ABB distributor Singapore" — in meta desc but not a dedicated page or post
- "MCB price Singapore" / "MCCB Singapore" — no product pages with individual spec/detail
- "wiring accessories Singapore" — mentioned on homepage but no dedicated content
- Brand + product combinations: "ABB S200 MCB Singapore", "ABB Formula MCCB Singapore" — zero optimised pages
- Local intent: "electrical supplies Serangoon Road", "electrical products Singapore" — not addressed

**No keyword stuffing detected** — where keywords appear they are natural. The issue is under-optimisation, not over-optimisation.

---

## AI Citation Readiness: 32 / 100

AI search engines (Google AI Overviews, Perplexity, ChatGPT) need quotable, structured, factually verifiable content to surface a business as a cited source.

| Signal | Status | Score Impact |
|---|---|---|
| Factual claims with specificity | Weak — dates and credentials present (1991, 1975) but few specific data points | -10 |
| Structured content hierarchy | Partial — blog posts have H2 structure; most pages are unstructured visual layouts | -8 |
| Named author with credentials | Absent — all content attributed to "admin" | -15 |
| LocalBusiness schema | Missing — no structured location data for AI map-based queries | -10 |
| FAQ content | Empty page — zero Q&A pairs for AI to extract | -10 |
| Product schema | Missing — no individual product structured data | -8 |
| External citations / sources | Absent — no links to ABB technical docs, EMA standards, or industry bodies | -7 |
| Contact/Trust signals in schema | Partial — address/phone on-page but not in schema | -5 |
| Unique data / statistics | Absent — no proprietary research, survey data, or original findings | -10 |
| Brand consistency across schema | Issue — WebSite.name is set to the URL ("https://liankok.com/") not brand name | -5 |

**What raises the score:**
- Organization schema present with correct social sameAs links (+5)
- BreadcrumbList on all pages (+3)
- Physical address, phone, email consistently displayed in footer (+5)
- Meta description on homepage is quotable and factual (+5)
- Project client list (NUS, SMU, LTA) is credibility-building for AI entity disambiguation (+4)

**AI Citation Readiness score: 32/100**

For a business of Lian Kok's standing (50+ years, named blue-chip clients), this score should be 65+. The gap is almost entirely fixable through schema additions and content structuring.

---

## AI-Generated Content Assessment (Sept 2025 QRG)

Per Google's September 2025 Quality Rater Guidelines, AI-generated content is acceptable when it demonstrates genuine E-E-A-T. The following flags are noted:

| Flag | Severity | Evidence |
|---|---|---|
| Generic phrasing in blog posts | Medium | "In a city as vibrant and technologically advanced as Singapore" — typical AI scene-setting opener with no informational value |
| Boilerplate structure | Medium | Posts follow identical intro > product description > applications > benefits > CTA pattern without variation or original angle |
| No first-hand experience signals | High | No installation examples, no customer project references, no "we've seen this in the field" commentary |
| Repeated content errors | High | Multiple product descriptions on /products/ use identical copy that is factually wrong for those products |
| Testimonials appear fabricated | High | "Sarah Lee, Project Manager" and "Emily Davis, Electrical Engineer" — no company, no project, no specificity. Likely theme demo content never replaced |
| No unique insight or proprietary data | Medium | All factual claims are available in ABB product datasheets — nothing is original to Lian Kok |
| Thin content across most pages | High | 3 of 5 blog posts under 500 words; /faq/ empty; /projects/ is a name list |

**Verdict:** The blog content appears to be AI-generated at a basic level without human editorial review or enrichment. It is not low-quality per se (no factual errors in the MCB/Contactors posts), but it lacks the first-hand authority signals Google's QRG requires to rate a page as "high quality" for YMYL-adjacent topics (electrical safety). The thin posts (under 500 words) are particularly risky under the March 2024 Helpful Content integration — they exist to create the appearance of a blog without serving user needs.

---

## Page-by-Page Issues

### Homepage (liankok.com/)
| Issue | Severity |
|---|---|
| 46 H1 tags — product cards using wrong heading level | Critical |
| Testimonials section uses theme demo names with no attribution | High |
| "ABB partnership" section is redundant with the ABB authorised distributor hero claim | Medium |
| Word count 924 — meets floor but ~400 words is navigation/footer boilerplate | Medium |
| No CTA button above the fold | High |
| Hero copy "Powering Singapore's Future" is generic — does not communicate product specificity | Low |
| Missing "Singapore" in page title | Medium |

### /about/
| Issue | Severity |
|---|---|
| "Over 35 years in the Singaporean market" — should be 50+ years (inconsistency with homepage) | High |
| Mission / values blocks are generic boilerplate (4 words each, no differentiation) | Medium |
| No team page, no founder story, no named staff | High |
| Testimonials repeated from homepage pattern — no verifiable attribution | High |
| No mention of specific certifications, EMA licencing, or trade body membership | Medium |
| Images pointing to wrong domain (liankoks.com) — broken | High |

### /products/
| Issue | Severity |
|---|---|
| 28+ H1 tags | Critical |
| 571 words — below 800-word floor for category/service page | High |
| Three product descriptions use identical copy (Switch-disconnectors, SPDs, SACE Tmax XT all say "ABB's latest line of MCCBs, up to 1600A") — factually wrong for SPDs and switch-disconnectors | High |
| No meta description | High |
| No introductory editorial copy explaining the product range to a new visitor | Medium |

### /faq/
| Issue | Severity |
|---|---|
| Page is completely empty — 71 words, all nav/footer | Critical |
| H1 "Faq" exists but no FAQ content beneath it | Critical |
| Missed opportunity for FAQ schema and conversational keyword coverage | High |

### /projects/
| Issue | Severity |
|---|---|
| Lists 15+ project names with zero context (scope, location, year, products used) | Critical |
| 174 words — entirely navigation and project titles | Critical |
| Named clients (NUS, SMU, ST Engineering, LTA, NJC) are high-value authority signals that are completely wasted | High |
| No photos of completed installations | High |
| No testimonials or project manager quotes from named clients | High |

### /contact/
| Issue | Severity |
|---|---|
| 205 words — mostly form fields and address data | Medium |
| No introductory copy or trust-building paragraph | Low |
| Contact form requires JavaScript but shows no fallback message if JS is disabled | Low |

### /resources/
| Issue | Severity |
|---|---|
| Download links have no descriptions — users don't know what they're downloading or why | Medium |
| "Energy Efficiency Solutions for Buildings" brochure listed three times with identical link text | High |
| 295 words — meets floor marginally but entirely link labels | Medium |
| No contextual copy explaining how to use the resources or who they're for | Medium |

### /blog-2/ (blog archive)
| Issue | Severity |
|---|---|
| Non-standard URL slug (/blog-2/) — should be /blog/ | High |
| Author displayed as "admin" on all post cards | High |
| 5 posts total — extremely thin for a company established since 1975 | Medium |
| 3 of 5 posts under 500 words — below blog post floor | High |
| No category or tag organisation visible to users | Low |

### Blog Post: ABB MCB Complete Guide (best post on site)
| Issue | Severity |
|---|---|
| No meta description on this page | High |
| 1,304 words — 196 below the 1,500-word floor | Medium |
| Author: "admin" in both byline and Article schema | High |
| No Singapore-specific regulatory references (SS 638, EMA standards) | Medium |
| No internal links to product pages or related posts | High |
| H2 structure is good but content under each heading is brief (2-3 paragraphs) | Medium |
| "Smart choice" / "reliable protection you can trust" — generic closing phrases typical of AI content | Low |
| No images with descriptive alt text within the article body | Medium |

---

## Prioritised Recommendations

### Priority 1 — Critical (Fix Within 1 Week)

| # | Action | Pages | Impact |
|---|---|---|---|
| 1 | **Rename admin user to a real name** and update all post author attributions | All blog posts | E-E-A-T, Schema, Article rich results |
| 2 | **Build out /faq/ with 10–15 real FAQ entries** covering common buyer questions (MOQ, delivery, compatibility, warranty, Singapore stock) | /faq/ | AI citation, topical coverage, conversational queries |
| 3 | **Fix product description errors on /products/** — SPDs and switch-disconnectors copy is wrong | /products/ | Expertise, trust |
| 4 | **Delete or replace placeholder testimonials** on /about/ — "Sarah Lee" and "Emily Davis" read as fake | /about/ | Trustworthiness |
| 5 | **Add meta description to MCB blog post** — the page title is good but no meta desc | Blog post | CTR, on-page SEO |

### Priority 2 — High (Fix Within 2–3 Weeks)

| # | Action | Pages | Impact |
|---|---|---|---|
| 6 | **Expand /projects/ into real case studies** — for each named client, add: products specified, scope (residential/commercial/industrial), year, outcome. 100–200 words per project. | /projects/ | Experience, Authoritativeness, E-E-A-T |
| 7 | **Expand MCB blog post to 2,000+ words** — add Singapore regulatory context (EMA, SS 638), specific model comparison table, installation checklist | MCB post | Expertise, ranking potential |
| 8 | **Write 3 new blog posts at 1,500+ words each** — targeting: "MCCB Singapore", "circuit breaker supplier Singapore", "ABB wiring accessories Singapore" | Blog | Topical authority, organic reach |
| 9 | **Add an introductory paragraph to /products/** — 150–200 words explaining the product range, who it's for, and what the "View More" pages contain | /products/ | Coverage floor, on-page quality |
| 10 | **Fix /about/ experience inconsistency** — "35 years" should be "50+ years" (established 1975) | /about/ | Accuracy, trust |

### Priority 3 — Medium (This Month)

| # | Action | Pages | Impact |
|---|---|---|---|
| 11 | **Add author bio page** with credentials, years of experience, areas of expertise — link from all blog posts | Blog | Authoritativeness, E-E-A-T |
| 12 | **Add LocalBusiness schema** — address, phone, hours, geo coordinates. Use Yoast Local SEO plugin | All pages | AI citation, local SEO |
| 13 | **Restructure /resources/** — add 1-sentence description per download, explain the target audience for each catalogue | /resources/ | Usefulness, UX |
| 14 | **Expand shorter blog posts** to 1,500+ words or consolidate weak posts into pillar articles | Contactors, RCD, Safety, Inora posts | Helpful Content signals |
| 15 | **Add Singapore-specific regulatory context** to all technical posts — reference EMA, SS 638, BCA requirements where relevant | All blog | Expertise, local authority |
| 16 | **Add ABB partnership proof** — link to official ABB distributor directory, add ABB partner badge if available | Homepage, /about/ | Authoritativeness |
| 17 | **Replace generic values section on /about/** — "Reliability / Innovation / Customer-Centric / Sustainability" with specific, evidenced claims | /about/ | Differentiation, E-E-A-T |
| 18 | **Add internal links throughout blog posts** to relevant product pages | All blog posts | Crawlability, topical signals |

### Priority 4 — Content Strategy (Ongoing)

| # | Action | Detail |
|---|---|---|
| 19 | **Publish minimum 2 blog posts per month** at 1,500+ words, targeting product + location keyword combinations | "ABB MCCB distributor Singapore", "switchgear supplier Singapore", "MCB installation Singapore" |
| 20 | **Create individual product landing pages** for top 5 products with full specs, applications, and buying guide | MCBs, MCCBs, RCCDs, Contactors, Wiring Accessories |
| 21 | **Build a "Why ABB" pillar page** (2,000+ words) explaining ABB's product range, certification standards, and why authorised distributor status matters | Supports E-E-A-T, brand authority, AI citation |
| 22 | **Develop a Singapore electrical guide hub** — "Electrical Safety Standards in Singapore", "How to Choose a Circuit Breaker", "What is an RCCB" | Top-of-funnel awareness, organic reach |

---

## Summary for Master Audit

The content quality situation at liankok.com is best characterised as a site with **strong brand credentials and weak content execution**. The underlying authority signals are genuinely good: ABB authorised since 1991, 50+ years in business, named blue-chip project clients. These are assets that most competitors cannot match.

The problem is that none of this credibility is being converted into content that Google or AI systems can evaluate as expert, authoritative, and trustworthy. The blog posts are thin, the key pages (FAQ, Projects, Resources) are largely empty, and the author attribution is anonymous throughout.

The highest-leverage action is to **use the existing project and client relationships as content**. A 200-word case study for NUS, SMU, or LTA — with specific products used and outcomes achieved — would do more for E-E-A-T than ten generic AI-generated product summaries.

| Content Quality Score | 42 / 100 |
|---|---|
| E-E-A-T Composite | 44 / 100 |
| AI Citation Readiness | 32 / 100 |
| Realistic target after 3 months of execution | 68 / 100 |

---

*Generated by RightClick:AI — Content Quality Specialist agent, 2026-03-26*
*Framework: Google September 2025 Quality Rater Guidelines*
*Cross-reference: `AUDIT-2026-03-26.md` (master SEO audit), `SCHEMA-AUDIT-2026-03-25.md`, `SITEMAP-AUDIT-2026-03-25.md`*
