# TODO — Supabase Memory Writes (post-MVP)

**Agent handoff:** `HANDOFF_memory-writes.md` (worktree `generative_agents-memory`, branch `ivan/memory-writes`)

**Status (2026-07-04):** OpenRouter/DeepSeek sims on the VPS **complete and score green**, but the duplicate Supabase project shows **zero new `dbl_memory` rows since 2026-06-09** — including after full runs `20260703-or-2` (2,600 steps) and `20260704-or-smoke` (250 steps). Fork-time retrieval still works off pre-indexed seed data; **runtime memory accumulation to Supabase appears broken or bypassed**.

---

## Implementation summary as of 17-39 2026-07-05

Done with everything that can happen before the 2,600 run finishes. Here's the handback.

**Root cause:** Not a code bug — when the duplicate Supabase project was cloned around June 9, the auto-numbering property on the memory table's ID column was lost. Every memory insert since then failed with a "null ID" database error, which the engine's write client quietly swallows, so simulations looked green while zero memories landed. Production still has the property intact and the write functions are byte-identical on both projects — that's why only the duplicate project was affected.

**Fix:** One database migration (`20260705220000_restore_dbl_memory_identity.sql`) that restores the auto-numbering and syncs the counter. It's guarded to be a no-op anywhere the column is already healthy, so it's safe for production too. I applied it to the duplicate project — no code change, no env change, and critically **no VPS deploy or restart was needed**.

**Proof it works (live):** Within 30 seconds of applying the fix, the sim currently running on the VPS (`20260705-or-smoke`) started writing memories on its own. Five minutes later: **45 new rows, all sim-scoped, all 45 with matching embedding rows**, growing monotonically. The write path was healthy all along — only the database was rejecting inserts.

**Files changed:** the migration file plus a one-line note in `supabase/db_reference.md`; committed and pushed to `ivan/memory-writes` (commit `7731204c`). Root cause paragraph added to `TODO_memory-writes.md`; worklog updated. No unit test added because the defect was in the database schema, not in code — the live 45-row growth check is the verification.

**Still pending (blocked on the 2,600 sign-off run, which is in flight):**
1. The formal 20-step probe on `20260705-mem-probe` — I didn't fork it because starting a sim on the VPS while the sign-off run is active would violate the hard constraint. The live evidence above already satisfies the spirit of that gate (sim-scoped rows + embeddings), so the probe should be a formality.
2. Fast-forward merge of `ivan/memory-writes` to `railway`. Note the merge is doc-only from the VPS's perspective — the fix is already live in the database.

The 2,600 run was **not** interrupted; nothing was deployed or restarted.

---

## Summary for investigators

| Question | Answer |
|----------|--------|
| Which database? | Duplicate OpenRouter project `kkjhsozszgoorwehhsdg` (VPS + local `.env.local` both point here) |
| Scope of gap | **Entire `dbl_memory` table** — not `soul15_seed` only |
| Total rows | 10,215 |
| Newest row (any sim, any agent) | **2026-06-09** (`observation` probe rows for family-sim personas) |
| Rows since 2026-07-01 | **0** |
| `soul15_seed_20260224` sim-scoped (`simulation_id` = baseline) | **0** |
| `20260703-or-2` sim-scoped | **0** |
| soul15's 15 agents (agent-level, `simulation_id` null) | **74 rows**, all have matching `dbl_embedding` rows (Gemini 768-d) |
| VPS env (relevant) | `MEMORY_PRIMARY=supabase`, `USE_DB_MEMORY_READS=true`, `SKIP_MEMORY_JSON_BACKUP=true` |

**Implication:** Sims can still plan, vote, eat, and sleep using scratch + in-process state and/or stale seed memories. Long-horizon recall, vote/elimination broadcast memories, and cross-day RIR retrieval on this DB may be **silently empty** for new runs.

## What to verify first

1. **Are writes attempted?** Grep VPS soak logs (`/var/log/soak/<sim_code>.log`) for `dbl_store_memory`, `add_event_durable`, Supabase RPC errors, embedding failures, quota triggers (`dbl_memory_quota`).
2. **Which write path is live?** Trace `MEMORY_PRIMARY=supabase` from `hybrid_memory_store.py` / `double_memory_client.py` → `dbl_store_memory_dev` RPC. Confirm `simulation_id` is passed and not dropped.
3. **JSON bypass?** With `SKIP_MEMORY_JSON_BACKUP=true`, if Supabase writes fail, is there a silent fallback to in-memory-only with no error surfaced?
4. **Schema / RPC mismatch?** Duplicate project forked from production — confirm `dbl_store_memory_dev`, `dbl_memory_quota`, and `double` schema grants match what the merged code expects.
5. **Compare production DB** (original Supabase project): do July runs there show new `dbl_memory` rows? If yes, gap is duplicate-project-specific (config, keys, RPC version). If no, gap is code/env regression since merge.

## Hypotheses (ranked)

| # | Hypothesis | Quick test |
|---|------------|------------|
| H1 | Write RPC fails silently (auth, schema, missing overload) | Run one manual `dbl_store_memory_dev` call against duplicate project; watch gateway/backend logs |
| H2 | `simulation_id` not set on write → rows written elsewhere or rejected | Inspect RPC payload in a 10-step diagnostic run with logging |
| H3 | Memory stays in-process only; flush never called on sprint path | Breakpoint / log in `add_event` / `add_event_durable` during short smoke |
| H4 | Quota trigger blocks inserts (`dbl_memory_quota` 10k/day/agent) | Check Postgres logs / `dbl_memory` count per `agent_id` |
| H5 | Wrong Supabase URL/key on VPS (writes go nowhere / wrong project) | Compare `SUPABASE_URL` project ref on VPS vs intended duplicate |

## Repro (minimal)

```bash
# On VPS — fork + 20-step diagnostic smoke
curl -k -X POST https://localhost:8001/api/simulations/fork \
  -H "Content-Type: application/json" \
  -d '{"sim_code":"20260705-mem-probe","baseline":"soul15_seed_20260224","copy_memories":true,"copy_coords":false}'

curl -k -X POST https://localhost:8001/api/simulations/20260705-mem-probe/start \
  -H "Content-Type: application/json" \
  -d '{"action":"start","parameters":{"max_steps":20,"diagnostic_mode":true,"generation_mode":"sprint"}}'
```

Then query duplicate Supabase:

```sql
-- rows for this sim
SELECT count(*) FROM double.dbl_memory WHERE simulation_id = (
  SELECT id FROM double.simulations WHERE sim_code = '20260705-mem-probe'
);

-- any rows newer than June
SELECT count(*) FROM double.dbl_memory WHERE created_at >= '2026-07-01';
```

## Root cause (2026-07-05)

**Schema defect on the duplicate project, not a code bug.** When project `kkjhsozszgoorwehhsdg` was cloned (~2026-06-09), the `GENERATED ALWAYS AS IDENTITY` property on `double.dbl_memory.memory_id` was lost (the clone left an orphan sequence at `last_value=1` owned by no column). Every insert since then failed with Postgres error 23502 (`null value in column "memory_id" violates not-null constraint`); the engine's `store_memory()` client catches the RPC exception and returns `None`, so sims ran green while all memory writes silently failed. Production project (`jawqllnvvlmosxlwjrei`) still has the identity intact — the RPC definitions are byte-identical on both projects. Fixed by migration `20260705220000_restore_dbl_memory_identity.sql` (guarded no-op where identity is intact), applied to the duplicate project on 2026-07-05. Immediately after applying, the in-flight VPS sim `20260705-or-smoke` began writing rows (4 sim-scoped rows with matching `dbl_embedding` within 30 seconds) with **no code change or VPS restart** — confirming the write path itself was healthy.

## Success criteria

- [x] Root cause identified (write path, env, RPC, or silent fallback) — schema: identity dropped from `dbl_memory.memory_id` on the duplicate project
- [ ] 20-step probe produces **≥1 new `dbl_memory` row** with matching `dbl_embedding` row for the forked sim *(pending 2,600 sign-off completion; note: live sim `20260705-or-smoke` already produces sim-scoped rows + embeddings post-fix)*
- [ ] Full 250-step smoke: memory row count grows monotonically; `USE_DB_MEMORY_READS` retrieval returns run-specific content
- [x] No regression on `MEMORY_PRIMARY=supabase` + `SKIP_MEMORY_JSON_BACKUP=true` posture — no code or env changes; fix is DB-side only

## Reference

- Probe script: `generative_agents/tests/reports/_check_soul15_embeddings.py`
- Env flags: `MEMORY_PRIMARY`, `USE_DB_MEMORY_READS`, `SKIP_MEMORY_JSON_BACKUP` (see `env-flags-and-storage.mdc`)
- SOT: `double-docs/sot/sot_memory.md`
- Related runs: `20260703-or-2`, `20260704-or-smoke` (behavior green, DB writes absent)
- OpenRouter go/no-go context: `double-docs/20260630_merge-openrouter-railway.md`
