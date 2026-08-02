---
status: canon
updated: 2026-08-02
sources:
  - north-star.md
  - pillars.md
  - ../index.md
needs-review: false
---

# Feature / bet alignment rubric

Use **before** `@cto` build briefs or committing roadmap slots. Output a short scorecard in the task or eng brief.

**Inputs:** proposal (1–2 paragraphs) + which pillars it claims (`pillars.md`) + whether it touches Draft forks (`v1_opensource/`).

---

## Scorecard

Score each row: **2** strong · **1** weak / stretch · **0** absent or conflicts.

| # | Criterion | Score | Note |
|---|-----------|-------|------|
| 1 | Serves ≥1 Canon pillar (name them) | | |
| 2 | Fits north-star category (simulation media / personal mythology — not generic social or productivity agent) | | |
| 3 | Strengthens watchable / shareable loop **or** rehearsal safety **or** squad intimacy | | |
| 4 | Teen / privacy posture acceptable (no dark patterns, no reckless psychographic exposure) | | |
| 5 | Clear Current vs Desired: does not pretend eng SOT already supports it | | |
| 6 | If it depends on `v1_opensource` (or other Draft): explicitly marked **undecided** — not smuggled in as Canon | | |

**Max 12.**

| Band | Action |
|------|--------|
| **10–12** | On-mission — proceed (still need normal risk / eng gates) |
| **7–9** | Weak — tighten scope or rewrite pitch before build |
| **≤6** | Off-mission — founder override required to continue |

---

## Verdict line (paste into briefs)

```
Alignment: <score>/12 — <on-mission | weak | off-mission>
Pillars: P#
Draft deps: none | v1_opensource (undecided) | other
Founder override: n/a | requested
```

---

## Examples (illustrative)

| Bet | Likely band | Why |
|-----|-------------|-----|
| Better daily trailer pipeline for Survival | On-mission | P3 + P5 |
| Dream-chat UX polish | On-mission | P4 + P1 |
| Local-first Double Gateway marketplace | Weak / undecided | May help scale; depends on Draft `v1_opensource` — do not treat as Canon |
| Real-world email-sending agent by default | Off-mission | Violates non-goals / P4 |
| Public teen psychographic dashboards | Off-mission | Violates P6 |

---

## Related

- [`north-star.md`](north-star.md) · [`pillars.md`](pillars.md) · [`../index.md`](../index.md)
