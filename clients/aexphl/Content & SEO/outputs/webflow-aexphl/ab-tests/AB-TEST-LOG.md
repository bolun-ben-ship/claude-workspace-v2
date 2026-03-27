# A/B Test Log — Aussie Expat Home Loans

---

## 2026-03-27: Status check — no winners yet

| Experiment | Flag | Exposures (control/test) | Days running | Status |
|---|---|---|---|---|
| Sales Page CTA — Book My Session vs Check My Borrowing Capacity | `sales-cta-text` | 0 / 0 | <1 | ⏳ Too early (0/100 exposures) |
| Landing Page Headline — Location | `lp-headline-location` | 24 / 28 | <1 | ⏳ Too early (24/100 exposures) |

**Next check:** Monday 2026-03-30 (automated via `aexphl-ab-test-loop` scheduled task)

**Scroll tracking:** Not yet set up — add PostHog scroll snippet to `/aussieexpathome`, `/landing-page`, `/landing-page-v2` via Webflow Designer (Page Settings → Before `</body>`).
