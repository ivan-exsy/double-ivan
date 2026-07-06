# Agent handoff — Supabase memory writes (`ivan/memory-writes`)

**Created:** 2026-07-05 · **Owner:** Ivan · **Parallel to:** 2,600-step MVP sign-off on VPS (`railway`)

---

## Mission

Fix runtime **Supabase memory writes** so new sims produce rows in `double.dbl_memory` (and matching `dbl_embedding`). Today: **zero new rows since 2026-06-09** on the duplicate OpenRouter project, despite green behavior on full runs.

**Outcome:** root cause fixed, 20-step probe proves writes, optional 250-step growth check, merge to `railway` **after** the in-flight 2,600 sign-off run completes and VPS is safe to deploy.

**Spec:** `double-ivan/TODO_memory-writes.md` · **SOT:** `double-docs/sot/sot_memory.md`

---

## Workspace (already set up)

| Item | Path |
|------|------|
| Worktree | `D:\Coding\generative_agents-memory` |
| Branch | `ivan/memory-writes` (from `origin/railway`) |
| Cursor workspace | Open `generative_agents_ivan-dev.code-workspace` (includes `double-docs`, `double-ivan`) |
| Main / sign-off window | `D:\Coding\generative_agents` on `railway` — **do not use for memory work** |

Copy `.env.local` from `generative_agents` into the memory worktree if missing. Duplicate Supabase project ref: **`kkjhsozszgoorwehhsdg`**.

---

## Hard constraints

1. **Do not deploy to VPS or `systemctl restart double-api` while the 2,600 sign-off sim is running.** Check status first:
   ```bash
   curl -k https://localhost:8001/api/simulations/<sim_code>/status/current | python3 -m json.tool
   ```
   Local investigation + unit tests are fine anytime.

2. **Do not rebase or force-push `railway`.** Memory branch merges forward only.

3. **Do not create new env flags** unless Ivan explicitly asks — reuse `MEMORY_PRIMARY`, `USE_DB_MEMORY_READS`, `SKIP_MEMORY_JSON_BACKUP`, `SUPABASE_READ_ONLY_MODE`.

4. **Surgical fix only** — trace the broken write path; no memory architecture redesign.

5. **Skip `verify` skill** for pure logging/RCA; run it if you change cognitive-loop behavior. After fix: 20-step probe is the gate.

---

## Known facts (start here)

| Fact | Detail |
|------|--------|
| DB | Duplicate project `kkjhsozszgoorwehhsdg`; VPS + local `.env.local` both point here |
| Symptom | 10,215 total `dbl_memory` rows; newest **2026-06-09**; **0** rows with `created_at >= 2026-07-01` |
| VPS env | `MEMORY_PRIMARY=supabase`, `USE_DB_MEMORY_READS=true`, `SKIP_MEMORY_JSON_BACKUP=true` |
| Reads work | Fork-time retrieval uses seed data (74 agent-level soul15 rows + embeddings) |
| Writes suspect | `20260703-or-2` (2,600) and `20260704-or-smoke` / `20260705-or-smoke` — behavior green, **0 sim-scoped rows** |

**Implication:** Sims run on scratch + in-process state; long-horizon RIR / vote memories may be silently empty.

---

## Hypotheses (investigate in order)

| # | Hypothesis | Quick test |
|---|------------|------------|
| H1 | RPC fails silently (`dbl_store_memory_dev`, auth, schema) | Manual RPC call against duplicate project |
| H2 | `simulation_id` dropped on write → reject or wrong bucket | Log RPC payload on 10-step run |
| H3 | Sprint path never calls durable flush (`add_event` / `add_event_durable`) | Log/breakpoint in write path |
| H4 | Quota trigger (`dbl_memory_quota`) blocks inserts | Count per `agent_id`; check Postgres logs |
| H5 | Wrong Supabase URL/key on VPS | Compare `SUPABASE_URL` project ref |
| H6 | `SUPABASE_READ_ONLY_MODE=true` on VPS | Grep VPS `.env.local` — skips all writes via `supabase_writes_enabled()` |

---

## Key code paths

| File | Role |
|------|------|
| `reverie/backend_server/persona/memory_structures/hybrid_memory_store.py` | `MEMORY_PRIMARY`, `_write_to_supabase_with_retry`, JSON backup skip |
| `reverie/backend_server/persona/memory_structures/double_memory_client.py` | `store_memory()` → `dbl_store_memory_dev` RPC |
| `reverie/backend_server/persona/memory_structures/runtime_flags.py` | `supabase_writes_enabled()`, `memory_primary_mode()` |
| `reverie/backend_server/persona/cognitive_modules/retrieve_double.py` | Read path + some write helpers |
| `api_gateway/app/services/chat_with_double_service.py` | Working example of `dbl_store_memory_dev` (gateway) |

Read `.cursor/rules/env-flags-and-storage.mdc` and `.cursor/skills/supabase-ops/SKILL.md` before changing flags or storage.

---

## Implementation phases

### Phase A — RCA (local; no VPS deploy)

- [ ] Grep codebase for `store_memory`, `add_event_durable`, `_write_to_supabase_with_retry`, `SUPABASE_READ_ONLY_MODE`
- [ ] Read `double-docs/sot/sot_memory.md` for write contract (`simulation_id`, embedding 768-d, node_id)
- [ ] Use `supabase-inspector` or MCP: confirm `dbl_store_memory_dev` exists on duplicate project; sample `dbl_memory` schema
- [ ] Optional: run `tests/reports/_check_soul15_embeddings.py` locally
- [ ] If VPS logs accessible (SSH): grep `/var/log/soak/*.log` for `dbl_store_memory`, `store_memory returned None`, embedding errors
- [ ] Document root cause in `TODO_memory-writes.md` (one paragraph)

**Deliverable:** confirmed hypothesis + minimal fix plan (1–2 files expected).

---

### Phase B — Fix + unit test (worktree)

- [ ] Implement smallest fix that restores writes (not band-aid logging-only unless logging exposes the bug)
- [ ] Add or extend test — e.g. mock RPC path, or extend `reverie/backend_server/tests/test_supabase_read_only_mode.py` pattern
- [ ] Run narrow tests: `pytest` on touched memory tests
- [ ] Prepend worklog entry per `worklog-own-update.mdc` (Backend section)

**Do not merge yet.**

---

### Phase C — Runtime validation (VPS; **wait for 2,600 to finish**)

Confirm sign-off sim `status: "completed"` and `backend_process_active: false` before any deploy.

**Deploy (after 2,600 completes):**
```bash
# VPS
cd /var/www/generative_agents
git fetch origin
git pull   # only after memory branch merged to railway and pushed — see Phase D
sudo systemctl restart double-api
```

**20-step probe** (from `TODO_memory-writes.md`):
```bash
curl -k -X POST https://localhost:8001/api/simulations/fork \
  -H "Content-Type: application/json" \
  -d '{"sim_code":"20260705-mem-probe","baseline":"soul15_seed_20260224","copy_memories":true,"copy_coords":false}'

curl -k -X POST https://localhost:8001/api/simulations/20260705-mem-probe/start \
  -H "Content-Type: application/json" \
  -d '{"action":"start","parameters":{"max_steps":20,"diagnostic_mode":true,"generation_mode":"sprint"}}'
```

**SQL success check** (duplicate project):
```sql
SELECT count(*) FROM double.dbl_memory WHERE simulation_id = (
  SELECT id FROM double.simulations WHERE sim_code = '20260705-mem-probe'
);
-- expect >= 1

SELECT count(*) FROM double.dbl_memory WHERE created_at >= '2026-07-01';
-- expect > 0 after probe
```

Also confirm matching `dbl_embedding` rows for new memories.

- [ ] ≥1 new `dbl_memory` row for probe sim
- [ ] Matching embeddings
- [ ] Soak log shows successful store (no silent `None`)

**Optional stretch:** 250-step fork; row count grows monotonically.

---

### Phase D — Merge to `railway` (after Phase C passes **and** 2,600 sign-off completes)

**Order matters:**

1. **Wait** for 2,600 sign-off sim to complete and be scored (separate agent/window — see `double-docs/20260705_close-for-mvp.md`). Memory merge does **not** block on Class A score, but **VPS deploy must not interrupt** the long run.

2. On memory worktree:
   ```bash
   cd D:/Coding/generative_agents-memory
   git fetch origin
   git rebase origin/railway
   # resolve conflicts if any; stop and hand back to Ivan if messy
   git push -u origin ivan/memory-writes
   ```

3. Merge to `railway` (Ivan or agent with approval):
   ```bash
   cd D:/Coding/generative_agents
   git checkout railway
   git pull --ff-only
   git merge --ff-only ivan/memory-writes
   git push origin railway
   ```

4. VPS deploy (step above) + re-run 20-step probe if code changed since local validation.

5. Update `TODO_memory-writes.md` checklist to ✅; note fix summary.

**Do not merge to `main`** — that's part of MVP promotion after 2,600 sign-off passes.

---

## Success criteria (from TODO)

- [ ] Root cause documented
- [ ] 20-step probe: ≥1 new `dbl_memory` + embedding for forked sim
- [ ] No regression: `MEMORY_PRIMARY=supabase` + `SKIP_MEMORY_JSON_BACKUP=true` posture preserved
- [ ] Merged to `railway` and verified on VPS

---

## What this does NOT cover

| Item | Owner |
|------|--------|
| 2,600 Class A / survival scoring | Main window / `20260705_close-for-mvp.md` |
| Embedding reindex (Phase 8) | Post-MVP |
| Gateway chat memory injection | Separate; may share RPC but not in scope unless same root cause |
| `railway` → `main` promotion | After MVP sign-off |

---

## Skills & rules to read first

1. `C:\Users\ipist\.cursor\skills\implementation-loop\SKILL.md` — one chunk → test → next chunk
2. `generative_agents/.cursor/skills/supabase-ops/SKILL.md` — RPC, RLS, duplicate project
3. `generative_agents/.cursor/rules/env-flags-and-storage.mdc` — memory flags
4. `generative_agents/.cursor/rules/git-workflow.mdc` — `ivan/*` branches, ff-only merge
5. `generative_agents/.cursor/skills/deploy-railway/SKILL.md` — never restart mid-sim

---

## Handback template

When done or blocked, report:

1. **Root cause** (one sentence)
2. **Files changed**
3. **Probe result** (row counts + sim_code)
4. **Merge status** (branch SHA on `railway` or blocker)
5. **Whether 2,600 was running during deploy** (yes/no)
