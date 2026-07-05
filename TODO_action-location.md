# TODO — Action-Location Residuals (post-MVP)

**Status (2026-07-05):** Issue 1 fixed at root — `_validate_address_post_resolution` now stands down when the action description explicitly names the resolved object (`_action_names_address_object`, location_resolver.py). Drift protection and staff_only unchanged. Unit tests green. SOT updated: `double-docs/sot/sot_action-location.md` v1.7 §7.7. Pending: 250-step VPS smoke to confirm Class A ≤ 5. Issue 2 remains deferred (missing maze fixture, 1 case).

Previous status: Class A dropped 70 → 9 per ~250 steps after the generalized orphan-anchor redirect (`_redirect_orphan_anchor_object` in `plan.py`, run `20260704-or-smoke`). Gap 2 / Class B / C are clean.

## Issue 1 — Post-validate guard fights the orphan-anchor redirect (8/9 cases) — FIXED 2026-07-04

- **Symptom:** actions that legitimately involve a bed/closet ("making bed", "waking up and stretching in bed", "getting dressed from the closet") get correctly redirected home, then `_validate_address_post_resolution` (`location_resolver.py`) bounces them away via the `bed_non_sleep` / whitelist rules — landing at a fallback arena (often Oak Hill library). Source tag: `parent_location_inherit_v1`.
- **Root cause:** pipeline order in `plan.py` (~line 1686): orphan-anchor redirect → dorm-rest redirect → post-validate → label-object force. Post-validate had no awareness that the action description names the object it's rejecting.
- **Fix (shipped):** `_action_names_address_object` exempts `bed_non_sleep` / `whitelist` when all object tokens appear in the action description. `staff_only` and `affordance_required` unchanged.

## Issue 2 — LLM resolver picks a non-existent object (1/9 cases)

- **Symptom:** Irene Dove "gather milk and cream from the cafe refrigerator" resolved to `behind the cafe counter` — the cafe arena has no `refrigerator` object. Source: `llm_location_v1`.
- **Fix direction:** low priority; either add missing fixtures to the maze or let the label-object force pass accept nearest semantic equivalent (counter ≈ refrigerator zone). Revisit only if it recurs.

## Verification checklist

- [x] Failing unit test for Issue 1 (bed-object action survives post-validate) — `tests/test_post_validate_object_exemption.py`
- [x] Fix + `python tests/test_orphan_anchor_redirect.py` + `tests/test_class_a_subaction_redirects.py` (+ affordance/reconcile/inheritance suites)
- [ ] 250-step smoke on VPS (fork baseline, diagnostics on), score with `tests/analyze_action-location.py`
- [ ] Gate: Class A ≤ 5 extrapolated to full run; no Gap 2 / C regressions

## Reference

- Runs: `20260703-or-2` (Class A = 70, failed gate) → `20260704-or-smoke` (Class A = 9/250 steps)
- Reports: `tests/reports/_orsmoke_action_location.txt`, `_or2_classA_disk.txt`, `_or2_classa_slice_out.txt`
- Docs: `double-docs/sot/sot_action-location.md` (v1.7 §7.7), `double-docs/20260630_merge-openrouter-railway.md`, `double-docs/15sim-polish.md`
- Related: `TODO_memory-writes.md` — Supabase `dbl_memory` write gap (no new rows since 2026-06-09 on duplicate project)
