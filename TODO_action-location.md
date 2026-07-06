# TODO — Action-Location (reopened 2026-07-06)

**Status:** **Reopened** — sign-off `20260705-or-smoke` @ 2,600 steps: Class A **21** (gate ≤ 5). Survival gates pass; location blocks MVP.

**Prior:** Issue 1 (post-validate vs orphan redirect) **shipped + validated** — arc 70 → 9 → 2 @ 250 smoke → **21 @ 2,600**. Bed/closet bounce fixed; scale exposes different failure modes.

---

## Issue 1 — Post-validate vs orphan redirect — ✅ CLOSED

- Fix: `_action_names_address_object` in `location_resolver.py`
- Tests: `tests/test_post_validate_object_exemption.py`
- SOT: `double-docs/sot/sot_action-location.md` v1.7 §7.7

---

## Issue 2 — Missing maze fixture (cafe refrigerator) — DEFERRED

- Irene Dove "cafe refrigerator" → counter; no maze object. Revisit only if recurrent in Class A list.

---

## Issue 3 — Scale Class A: inherit + LLM object mismatch (21 cases @ 2,600) — OPEN

**Sign-off breakdown (`_20260705_or_signoff_action_location.txt`):**

| Source | Count | Fix direction |
|--------|------:|---------------|
| `parent_location_inherit_v1` | 12 | Label-object force / detach when action names object not at inherited anchor (computer, sofa, piano, desk, cooking area) |
| `llm_location_v1` | 7 | Stricter object pick; semantic nearest in-arena; post-validate for named objects |
| `planner_contract_v1` | 2 | Contract builder anchor vs description reconcile |

**Acceptance set (plain language):**

| Theme | Examples in report |
|-------|-------------------|
| Computer @ wrong tile | Alexis/Andrew @ library sofa; Dean/Ivan @ store counter |
| Piano @ wrong tile | Dean @ pub microphone; Max @ cafe counter; Vince @ cafe counter |
| Sofa @ classroom | Dean, Diana @ student seating / blackboard |
| Kitchen sink / cooking area | Dean @ supply counter; Olivia @ pub bar; Alex Butcher @ supply counter |

**Not in scope for Issue 3:** bed/closet post-validate bounce (Issue 1 — done).

---

## Issue 4 — LLM location hallucination at scale — OPEN (monitor)

- 250 smoke: 0% (8 calls)
- 2,600 sign-off: **14.7%** — exceeds 5% “worth fixing” threshold in analyzer
- Tier 2 strict enum **only if** still &gt;5% after Issue 3 inherit/LLM fixes

---

## Verification checklist

- [x] Issue 1 unit tests + 250 smoke Class A 2
- [x] 2,600 sign-off scored — **Class A 21 — FAIL**
- [ ] Issue 3 fix + unit tests for top themes (computer, piano, sofa at minimum)
- [ ] Fresh fork 2,600 VPS run → Class A ≤ 5
- [ ] Gap 2 on re-run — monitor (sign-off: 369; smoke: 2; pre-fix full: 434)

---

## Reports

| Run | Steps | Class A | Report |
|-----|------:|--------:|--------|
| `20260703-or-2` | 2,600 | 70 | `_or2_classA_disk.txt` |
| `20260704-or-smoke` | 250 | 9 | `_orsmoke_action_location.txt` |
| `20260705-or-smoke` | 250 | 2 | `_20260705_or_smoke_action_location_vps.txt` |
| **`20260705-or-smoke`** | **2,600** | **21** | **`_20260705_or_signoff_action_location.txt`** |

**Tracker:** `double-docs/20260705_close-for-mvp.md`
