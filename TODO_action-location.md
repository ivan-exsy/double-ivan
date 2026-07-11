# TODO — Action-Location (Path B only)

**Status:** Location MVP **green** (closed 2026-07-09/10). This file is **post-MVP residual only**.  
**Updated:** 2026-07-10  
**Evidence (archived):** `done/20260709_action-location-midflight-report.md` · `done/20260708_hallucinations.md` · reports under `generative_agents/tests/reports/_20260708_mvp_a_*` / `_20260709-1_*`

**Last green scores**

| Run | Steps | Class A desk-excl. | Hallucination |
|-----|------:|-------------------:|--------------:|
| `20260708-mvp-a` | 2,600 | **15** ≤20 | **0.6%** |
| `20260709-1` | 2,489 | **17** ≤20 | **0.0%** |

Product rule (locked): `desk → table / podium / student seating` is **not** Class A.

---

## Remaining — Path B residual themes

Do **not** block launch. Prefer a dedicated worktree (`ivan/path-b-class-a-residual` or similar).

| Theme | Typical count (mvp-a) | Fix direction |
|------|----------------------:|---------------|
| Computer where arena has no PC (supply / pharmacy / library table) | ~5 | Policy and/or fixtures: nearest valid work surface **and** normalize description, **or** block “computer” language at plan time |
| Cafe counter vs seating / wrong venue leaf | ~4 | Prefer counter leaf on inherit + LLM paths when action is order/at-counter |
| Refrigerator @ pub seating | ~1 | Fixture / staff-zone (Issue 2 rolled in) |
| Piano @ bar seating | ~1 | Affordance / leaf preference |
| Soft bed still in desc after transition | ~2 | Timing / soft — watch; fix only if it dominates |
| Desk text @ shelf (anchor already `desk`) | ~1 | Keep as real Class A; Path B |

**Player-visible bar today:** ~0.75% of unique actions still look slightly wrong after desk exclusion. Not chaos, not invented places.

---

## Path B packaging (first agent pass)

**In scope (stop when done — not “Class A ≤ 5 forever”):**

1. Desk synonym **not** Class A in analyzer (+ documented aliases in SOT).
2. Impossible-computer policy implemented and tested.
3. Cafe-counter preference on inherit + LLM paths.
4. Unit / analyzer tests green → **250 smoke** showing those themes down → human review → optional 2,600 baseline.

**Out of scope for first pass:** full Tier 2 flat-enum · deleting all band-aids in one go · survival/chat work · changing MVP gates.

**Longer-term order (later):** world-truth object lists → flat-enum LLM pick → retire band-aids → formal impossible-object policy.

---

## Closed — do not re-open unless regression

- Path A measurement (planned vs actual + stopword match)
- Hallucination token-budget (`max_tokens` 100→800)
- Issue 1 post-validate / orphan redirect
- Issue 3a map registry + prompt grounding
- Location MVP ship gate (halluc &lt;5%, Class A desk-excl. ≤20, no chaos)
- Survival RCA-1 / overall MVP engine sign-off (`20260709-1`)

---

## Links

| Doc | Role |
|-----|------|
| `double-docs/sot/sot_action-location.md` | Runtime contract SOT |
| `done/20260709_action-location-midflight-report.md` | Mid-flight evidence |
| `done/20260708_hallucinations.md` | Tier 2 flat-enum = Path B later |
| `done/20260705_close-for-mvp.md` | MVP closure archive |
