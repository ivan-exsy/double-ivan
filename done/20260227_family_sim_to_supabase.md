##✅ Family Sim Profile SOT Backfill (2026-02-27)

This note tracks the implementation prepared to bring `base_family_sim` profile context parity with `soul15_seed_20260224`.

### Goal

- Keep runtime behavior unchanged (fail-open on missing profile context).
- Backfill `base_family_sim` personas into:
  - `double.persona_profile_documents`
  - `double.persona_profile_snippets`
- Do **not** change sprite assignments.
- Align RPC action-task context with SOT/runtime builder contract.

### Implemented Changes

1) New script: `scripts/backfill_base_family_profiles.py`

- Reads local scratch files from:
  - `environment/frontend_server/storage/<sim_code>/personas/<persona>/bootstrap_memory/scratch.json`
- Generates deterministic markdown profile docs from `scratch.json` fields:
  - `innate`, `learned`, `currently`, `daily_plan_req`, `lifestyle`, `living_area`
- Compiles snippets using existing `import_soul_profiles.py` compiler.
- Upserts only:
  - `persona_profile_documents` (active doc)
  - `persona_profile_snippets` (active snippet set)
- Leaves sprites untouched.

2) New migration: `supabase/migrations/20260227000001_profile_context_action_parity.sql`

- Replaces `public.get_persona_profile_context(...)`.
- Fixes `task_type='action'` allowed snippet types to:
  - `decision_heuristics`
  - `values_and_principles`
  - `do_not_do`
- This matches:
  - runtime `profile_context_builder.py` action ordering
  - SOT prompt contract

### Operator Commands (Approval-Gated)

No write commands should be executed until explicit approval.

1) Preview backfill input/output (no writes):

```bash
python scripts/backfill_base_family_profiles.py --sim-code base_family_sim --dry-run
```

2) Apply profile backfill (writes docs + snippets only):

```bash
python scripts/backfill_base_family_profiles.py --sim-code base_family_sim
```

3) Verify profile coverage for base family:

```bash
python scripts/verify_soul15_mvp.py --sim-code base_family_sim --expected-personas 4 --expected-maze the_ville
```

4) (Optional) Verify action context now includes values:

```sql
select public.get_persona_profile_context('<persona_uuid>'::uuid, 'action');
```

### Notes

- Sprite coverage for `base_family_sim` will still fail sprite verification until a separate sprite decision is made.
- Fail-open behavior remains unchanged: missing profile context does not block simulation.