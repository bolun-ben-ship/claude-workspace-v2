# Implementation Plan — Owllight Sleep
**Date:** 2026-03-23
**Pipeline run:** AI SEO Pipeline — Month 1 (initial run)
**Based on:** Audit (37/100, 2026-03-20), Post-Implementation Report (2026-03-20), GSC/GA4 baseline, Keyword Plan (2026-03-23)
**Produced by:** RightClick:AI / AI SEO Pipeline

---

## Situation Summary

The March 20 initial run completed the highest-impact API-executable changes:
- ✅ All 10 active products now have individual SEO titles + meta descriptions (via API)
- ✅ All 7 published blog posts now have individual SEO titles + meta descriptions (via API)
- ✅ 3 new blog drafts pushed (best-mattress-singapore-2026, best-mattress-for-back-pain-singapore-2026, woosa-vs-owllight-mattress-singapore-2026)

**Remaining work falls into 3 buckets:**
1. **Theme-level fixes** — require Shopline theme editor (developer/admin access)
2. **Content creation** — blog posts, alt text, thin page expansion (agency task)
3. **Token scope** — `read_page` / `write_page` still needed for static pages

This plan covers this pipeline run (2026-03-23) and documents the outstanding items that carry forward.

---

## Category A — SEO Titles

### A1: Products ✅ (done 2026-03-20)
All 10 active products have SEO titles. No changes this run.

### A2: Published Blog Posts ✅ (done 2026-03-20)
All 7 published posts have SEO titles. No changes this run.

### A3: 3 Draft Blogs from March 20 — verify SEO meta
These 3 drafts were pushed on 2026-03-20 and should have had SEO metafields set. Verify via API this run before executing any further changes.

| Draft | Expected SEO Title | Expected Meta Description |
|---|---|---|
| best-mattress-singapore-2026 | Best Mattress Singapore 2026: Buyer's Guide \| Owllight | — |
| best-mattress-for-back-pain-singapore-2026 | Best Mattress for Back Pain Singapore 2026 \| Owllight | — |
| woosa-vs-owllight-mattress-singapore-2026 | Woosa vs Owllight Mattress: Singapore 2026 \| Review | — |

### A4: Static Pages — BLOCKED (token scope)
6 static pages cannot be accessed until `read_page` + `write_page` scopes are added to the Shopline app token.

| Page | GSC Impressions | Priority |
|---|---|---|
| /pages/custom-mattress-singapore | 630 | 🔴 High |
| /pages/showroom-22-sin-ming-lane | 416 | 🔴 High |
| /pages/mattress-trial-singapore-100-nighs | 86 | 🟠 Medium |
| /pages/mattress-delivery---contact | ~50 est. | 🟡 Low |
| /pages/customized-mattress-policy | ~30 est. | 🟡 Low |
| /pages/queen-size-mattress-comparisons | ~30 est. | 🟡 Low |

**Action required by client:** Add `read_page` + `write_page` to Shopline App → Develop Apps → re-generate token.

---

## Category B — Meta Descriptions

Same status as Category A above. Products ✅, published blogs ✅, pages blocked by token scope.

---

## Category C — Blog SEO Titles (new drafts this run)

5 new blog posts will be pushed this run. SEO titles will be set during push.

| Post | SEO Title | Collection |
|---|---|---|
| emma-vs-owllight-mattress-singapore | Emma Mattress vs Owllight: Singapore 2026 Comparison | Mattress Comparisons |
| origin-vs-owllight-mattress-singapore | Origin Mattress vs Owllight: Singapore 2026 Review | Mattress Comparisons |
| how-to-choose-mattress-firmness-back-pain-singapore | How to Choose Mattress Firmness for Back Pain in Singapore | Owllight Series |
| best-cooling-mattress-topper-singapore-guide | Best Cooling Mattress Topper Singapore: Complete Guide | Owllight Series |
| why-your-back-hurts-in-the-morning-singapore | Why Your Back Hurts Every Morning (And How to Fix It) | Brand Story |

---

## Category D — Blog Meta Descriptions (new drafts this run)

| Post | Meta Description |
|---|---|
| emma-vs-owllight-mattress-singapore | Emma Mattress vs Owllight Tulip: back care, cooling, firmness, price, and 100-night trial compared for Singapore buyers. Which wins on back support? |
| origin-vs-owllight-mattress-singapore | Origin vs Owllight Tulip Hybrid: foam layers, cooling tech, back support, and price compared. Which mattress is right for Singapore sleepers with back pain? |
| how-to-choose-mattress-firmness-back-pain-singapore | Medium or firm? The right mattress firmness for back pain depends on your sleeping position. Here's what to choose — with Singapore-specific recommendations. |
| best-cooling-mattress-topper-singapore-guide | Singapore's humidity destroys sleep. Here's how to choose a cooling mattress topper that actually works — materials, thickness, and which to avoid. |
| why-your-back-hurts-in-the-morning-singapore | Waking up with lower back stiffness every morning? Your mattress is probably the cause. Here's what to look for — and what to do about it. |

---

## Category F — Schema

### Outstanding (all require theme editor access)

| Priority | Issue | Pages Affected | Action |
|---|---|---|---|
| 🔴 Critical | `priceValidUntil` expired 2026-03-27 — product rich results suppressed | All 10 product pages | Theme editor: update to rolling 12-month date |
| 🔴 Critical | Duplicate Product JSON-LD on all product pages | All 10 product pages | Theme editor: remove duplicate injection |
| 🔴 Critical | JSON-LD parse errors on blog article pages | 6 blog pages | Theme editor: fix malformed Article schema |
| 🔴 Critical | Organization `sameAs` has 13 empty strings | Every page sitewide | Theme editor: remove empty string array entries |
| 🟠 High | FAQPage schema missing on homepage | Homepage | Theme editor: add 5 Q&As as FAQPage schema |
| 🟠 High | LocalBusiness schema missing on showroom page | /pages/showroom | Theme editor: add LocalBusiness with NAP + hours |

**Note:** priceValidUntil already expired 2026-03-23 (today is 2026-03-23, deadline was 2026-03-27 — 4 days from now). **Urgent.**

---

## Category G — Manual Only

| Priority | Item | Action | Owner |
|---|---|---|---|
| 🔴 Urgent | Fix `priceValidUntil` — expires 2026-03-27 | Theme editor | Developer |
| 🔴 Critical | Empty H1 on homepage | Add H1 in theme hero section | Developer |
| 🔴 Critical | Duplicate H1 on 8 product/blog pages | Remove duplicate in theme template | Developer |
| 🟠 High | Add H1 to 5 pages missing heading | showroom, custom mattress, contact, policy, comparisons | Developer |
| 🟠 High | Fix URL typo: `100-nighs` → `100-nights` + 301 redirect | Admin + developer | Developer |
| 🟠 High | Remove `user-scalable=no` from viewport meta | Theme template edit | Developer |
| 🟠 High | Alt text for ~400 images | Manual per-image in Shopline | Agency |
| 🟠 High | Expand Custom Mattress page (133 words → 500+) | Content writing | Agency |
| 🟠 High | Expand 5 collection pages (<200 words each) | Content writing | Agency |
| 🟠 High | Fix title/content mismatch: Dubai post (says "Singapore") | Edit article in Shopline admin | Agency |
| 🟠 High | Fix title/content mismatch: Simmons post | Edit article in Shopline admin | Agency |
| 🟡 Medium | Implement hreflang for Arabic locale variants | Developer task | Developer |
| 🟡 Medium | Fix orphan products in sitemap (/products/11, /products/cloud-wrap) | Add internal links | Agency |
| 🟡 Medium | Create /about page (currently 301 to homepage) | Shopline admin | Client/Developer |
| 🟡 Medium | Create /faq page (currently 301 to homepage) | Shopline admin | Client/Developer |
| 🟡 Medium | Allow AI crawlers in robots.txt (GPTBot, PerplexityBot, ClaudeBot) | Developer | Developer |

---

## This Run — Execution Summary

### What Will Be Done via API (this run)
| Action | Count | Method |
|---|---|---|
| Push 5 new blog drafts | 5 | POST /store/blogs/{collection_id}/articles.json |
| Set SEO title + meta desc on 5 new drafts | 10 metafields | POST /metafields_set.json |

### What Carries Forward (not executable this run)
- All Category F + G items (theme-level, developer required)
- Static page SEO titles/meta (token scope upgrade needed)

### What Is Resolved ✅
- Product SEO meta: 10/10 done
- Published blog SEO meta: 7/7 done

---

## On-Page KPIs to Track (next GSC pull, ~April 20)

| Page | Current Position | Current CTR | Target (30 days) |
|---|---|---|---|
| /products/mattress-topper-singapore-4d | 12.9 | 2.0% | < 10, CTR > 3% |
| /blogs/.../woosa-mattress-review | 7.7 | 0.9% | < 6, CTR > 2% |
| /blogs/.../sealy-vs-simmons | 7.1 | 0.6% | < 5, CTR > 2% |
| /products/pillow-for-neck-pain | 11.7 | 1.2% | < 8, CTR > 3% |
| /pages/custom-mattress-singapore | 17.6 | 0.2% | < 15 (content depth) |
