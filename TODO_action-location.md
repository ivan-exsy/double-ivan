# TODO — Action-Location (reopened 2026-07-06)

**Status:** **Reopened** — prior sign-off `20260705-or-smoke` @ 2,600: Class A **21** (gate ≤ 5). Map/prompt fixes shipped; **`20260706-map-smoke`** @ 250: Class A **3** ✅. **`20260706-map-signoff`** @ 2,600 **in flight** — MVP gate.

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

## Issue 3a — Map data + LLM prompt (2026-07-06) — ✅ SHIPPED (smoke-validated)

- Maze registry aligned (222 objects; removed 3 phantom `common room bench` entries)
- `action_location_unified_v1.txt` — verbatim-copy + named-object grounding rules
- `_normalize_location_pick()` in `run_gpt_prompt.py` + `tests/test_location_pick_normalization.py`
- Smoke: Gap 2 **0** (was 2); hallucination **0%** (6 calls); Class A **3** (all inherit — see Issue 3)

---

## Issue 3 — Scale Class A: inherit + LLM object mismatch (21 cases @ prior 2,600) — OPEN

**Sign-off breakdown (`_20260705_or_signoff_action_location.txt`):**

| Source | Count | Fix direction |
|--------|------:|---------------|
| `parent_location_inherit_v1` | 12 | Label-object force / detach when action names object not at inherited anchor (computer, sofa, piano, desk, cooking area) |
| `llm_location_v1` | 7 | Stricter object pick; semantic nearest in-arena; post-validate for named objects |
| `planner_contract_v1` | 2 | Contract builder anchor vs description reconcile |

**Map smoke Class A (3 @ 250):** all `parent_location_inherit_v1` — Andrew bookshelf, Max refrigerator, Vince bookshelf.

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

- `20260705-or-smoke` @ 250: 0% (8 calls)
- `20260706-map-smoke` @ 250: **0%** (6 calls) — post map/prompt
- `20260705-or-smoke` @ 2,600: **14.7%** — exceeds 5% threshold
- Tier 2 strict enum **only if** still &gt;5% after Issue 3 inherit/LLM fixes **and** map-signoff @ 2,600

---

## Verification checklist

- [x] Issue 1 unit tests + 250 smoke Class A 2
- [x] Issue 3a map/prompt shipped + 250 smoke (`20260706-map-smoke`) Class A 3, Gap 2 0
- [x] Prior 2,600 sign-off scored — **Class A 21 — FAIL**
- [ ] `20260706-map-signoff` @ 2,600 VPS run → Class A ≤ 5 (**in flight**)
- [ ] Gap 2 + hallucination on sign-off — monitor (prior sign-off: Gap 2 369, hallucination 14.7%)
- [ ] Issue 3 inherit finalize — only if sign-off still &gt;5 after map/prompt path

---

## Reports

| Run | Steps | Class A | Gap 2 | Hallucination | Report |
|-----|------:|--------:|------:|---------------|--------|
| `20260703-or-2` | 2,600 | 70 | 434 | — | `_or2_classA_disk.txt` |
| `20260704-or-smoke` | 250 | 9 | 1 | — | `_orsmoke_action_location.txt` |
| `20260705-or-smoke` | 250 | 2 | 2 | 0% (8) | `_20260705_or_smoke_action_location_vps.txt` |
| **`20260705-or-smoke`** | **2,600** | **21** | 369 | 14.7% | **`_20260705_or_signoff_action_location.txt`** |
| **`20260706-map-smoke`** | **250** | **3** | **0** | **0%** (6) | **`_20260706_map_smoke_action_location_vps.txt`** |
| **`20260706-map-signoff`** | **2,600** | *in flight* | — | — | *score on completion* |

**Tracker:** `double-docs/20260705_close-for-mvp.md`
