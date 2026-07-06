# Supabase-First for Production

## Purpose

Instruction doc for making Supabase the true source of truth for simulation state in production — not just in dev via local overrides. Audience: anyone changing persistence-layer code, deploying the simulation to a server, or auditing production readiness.

For the architectural overview of what lives in Supabase (tables, RPCs, frontend hooks), see `done/4.0.supabase-first-architecture.md`. That doc describes the target. **This doc is the honest status + the instruction for closing the gap** — because on 2026-04-22 the migration is not actually complete: some code defaults still write to JSON, some load paths still read from JSON, and one subsystem was never migrated.

---

## Principle (one line)

Supabase is the only durable source of truth for simulation state. Disk is either a message channel, a diagnostic, or a dev-mode cache — never the canonical copy.

---

## Why this matters in production

Server deployment makes disk-backed state much more expensive than it appears in dev:

- **Ephemeral disk.** Containers (Railway, Fly, ECS, GKE) restart, reschedule, and get rebuilt on deploy. Disk at T+1 ≠ disk at T. Any canonical state on disk is lost on the first restart.
- **Horizontal scaling.** More than one instance generating sims in parallel cannot share pinned-to-node state. Forking a baseline from node A on node B fails if the baseline partially lives on A's disk.
- **Product features that require cross-node state.** Shareable sim URLs, multi-device viewing, live co-watching, resume-after-disconnect, and replay of finished sims all require canonical state to be queryable by anyone from anywhere. Disk-backed state breaks all of these.
- **Operations.** Post-mortem triage happens via Supabase dashboards and log aggregators. Nobody SSHes into a production container to open a JSON file.

In dev none of this is visible because disk, process, and user are colocated. Production exposes every assumption.

---

## Three-bucket file taxonomy

Every JSON file the simulation produces belongs to exactly one bucket, by role. The practical test is: **"if this file disappeared mid-run, what breaks?"**

### 1. Transport — FE↔BE step exchange

- Files: `movement/N.json`, `environment/N.json`.
- What breaks if deleted: next step's FE↔BE exchange. By design.
- Production policy: **skip disk writes.** Set `SKIP_MOVEMENT_JSON_WRITE=true`, `SKIP_ENV_JSON_WRITE=true`, `USE_SUPABASE_STEP_SOT=true`. Treat this as wire-format only; frontend reads step data directly from Supabase.
- Dev policy: may write to disk for local inspection.
- Not a Pass 2 migration target — already correct when flags are set. Governed by `sot_be-fe.md`.

### 2. Diagnostics — human-readable forensics

- Files: `STATUS.json`, `COMPLETED.json`, prompt dumps, `analyze_sim` exports.
- What breaks if deleted: debugging is harder; sim keeps running.
- Production policy: disk is acceptable short-term. Post-MVP, ship to durable storage (S3 / blob / log aggregator) so crashed containers don't lose forensics.
- Dev policy: disk.
- Not a Pass 2 concern.

### 3. Temp cache — simulation state that legacy code persists to disk

- Files: `scratch.json`, `nodes.json` + `kw_strength.json` + embeddings, `reverie/meta.json`, `spatial_memory.json`.
- What breaks if deleted: sim state is lost or stale; agents misbehave or lose memory.
- Production policy: **Supabase-only.** No JSON reads, no JSON writes, no fallback. Fail loud if Supabase is unavailable — better to halt than to silently corrupt state.
- Dev policy: Supabase-primary with JSON cold-start fallback (for first fork/bootstrap convenience).
- **This is the migration target.** Everything in Pass 2 is about this bucket.

---

## Current state (2026-04-22)

| Data | Supabase write? | JSON write? | Code default | Load path | Status |
|---|---|---|---|---|---|
| Scratch | Yes (`save_persona_scratch` RPC) | Yes (`bootstrap_memory/scratch.json`) | `json` | JSON-first | Code default wrong + JSON-first load |
| Associative memory (events/thoughts/chats) | Yes (`HybridMemoryStore`, async) | Yes (`nodes.json`, `kw_strength.json`, embeddings) | `supabase` | JSON-first | JSON-first load |
| Reverie meta (step counter, sim state) | Yes (`update_simulation_metadata` RPC) | Yes (`reverie/meta.json`) | `json` | JSON-first | Code default wrong + JSON-first load |
| Spatial memory | N/A — derived at query time from maze (Supabase) + access rules (`persona_scratch`) | Legacy `spatial_memory.json` exists but not read at runtime under `USE_GRID_OBJECTS=true` | n/a | Maze + rules | **Resolved by architecture** (see §Spatial memory) |

### Two issues named

- **Hidden default trap.** `SCRATCH_PRIMARY` and `SIM_META_PRIMARY` behave correctly only because the local `.env.local` overrides the code-baked `json` default. A fresh production container without that file writes canonical state to ephemeral disk. First restart → data loss.
- **File-on-load.** Even for subsystems whose writes go to Supabase, the load paths read JSON first. On a fresh container the JSON doesn't exist, so reads may silently produce empty state or mask stale data.

### Spatial memory — resolved by architecture

Under the current production intent (`USE_GRID_OBJECTS=true`), spatial memory is already Supabase-first — just not via a dedicated "spatial memory" table. Instead:

- **Structure** (what sectors/arenas exist, where they are) comes from `maze_tiles` / `maze_chunks` / `maze_address_cache` — all in Supabase.
- **Objects** (what's in each arena, what's being carried) come from `maze_instance_tiles` and `carried_objects` — in Supabase.
- **Per-persona access** (what this persona is allowed to reach) comes from `persona_scratch.living_area` / `work_area` and static access rules — in Supabase (`persona_scratch`).

Every question answered by `get_str_accessible_sectors` / `_arenas` / `_arena_game_objects` is derived from these Supabase sources at query time. There is no per-persona mental tree to persist. `spatial_memory.json` and `MemoryTree` are legacy from the pre-grid era; they are not read at runtime when `USE_GRID_OBJECTS=true` (which is the production intent).

Implication: **no migration needed, no new table needed.** The cleanup here is documentation + deprecating the legacy JSON path; the behavioural posture is already correct.

---

## Pass 1 — Documentation (this session, no behavior change)

This doc is the authoritative status + instruction. Three small edits in the project docs point engineers here:

- `CLAUDE.md` — one rule under Rules & Conventions.
- `double-docs/sot/sot_lifecycle.md §1.2` — replace the "JSON is diagnostics/backup only" one-liner with the three-bucket split.
- `double-docs/sot/sot_memory.md §2` — append a short "Known debt" sub-section.

Pass 1 is done when an engineer reading CLAUDE.md or either SOT doc can find this doc and understand the bucket rules. No code, no `.env.local`, no `/verify`.

---

## Pass 2 — Code (behavior-affecting, needs `/verify`, separate approval)

### 2.1 Flip code defaults — **done 2026-04-22**

- `reverie/backend_server/persona/memory_structures/runtime_flags.py:52` — `SCRATCH_PRIMARY` default flipped from `"json"` to `"supabase"`.
- `reverie/backend_server/reverie.py:188` — `SIM_META_PRIMARY` default flipped from `"json"` to `"supabase"`.

Result: a fresh checkout with no `.env.local` now runs Supabase-first. Hidden-default trap closed.

### 2.2 Supabase-first load paths

Load paths for scratch, associative memory, and reverie meta should prefer Supabase reads. JSON is a cold-start fallback for first bootstrap only, gated by the `SUPABASE_ONLY_MODE` environment flag.

- Production: `SUPABASE_ONLY_MODE=true` — no JSON fallback; fail loud if Supabase lacks data or the client is unavailable (both exceptions AND empty-row responses).
- Dev: unset or `false` — JSON cold-start fallback permitted.

Split into three sub-batches:
- **2.2a — done 2026-04-22.** Scratch Supabase-first load. Added optional `sim_name` / `persona_name` to `Scratch.__init__`; `_try_load_from_supabase` helper tries Supabase first and returns early on success, preserving the existing JSON population block untouched for the fallback case. `Persona.__init__` takes optional `sim_name` and threads it through; `reverie.py` passes `sim_code` when constructing personas. Strict mode (`SUPABASE_ONLY_MODE=true`, now exposed via `is_supabase_only_mode()` helper in `runtime_flags.py`) raises on any failure (no client, empty row, SCRATCH_PRIMARY mismatch, exception) — production is genuinely Supabase-only at load time. Dev keeps JSON cold-start for brand-new baselines. Follow-up cleanup ("Option B") tracked in Backlog. **Startup-latency follow-up noted:** persona init loop in `reverie.py:~1472-1595` now blocks on one Supabase RPC per persona (~100-500ms each). For 15-persona production sims this adds ~1.5-7.5s at sim-start. Parallelization via `ThreadPoolExecutor` (pattern already used elsewhere in the codebase) is a deferred perf-optimization — not behaviour-critical.
- **2.2b — done 2026-04-23.** Reverie-meta Supabase-first load. Added `sim_meta_primary_mode()` in `runtime_flags.py` (mirror of `scratch_primary_mode()`) and rewired the `SIM_META_PRIMARY` constant at `reverie.py:188` through it. Added `_try_load_meta_from_supabase()` on `ReverieServer` that calls the existing `get_simulation_metadata` RPC, converts ISO timestamps to the legacy strftime format via shared `parse_memory_created`, returns None on soft failure in dev, and raises under `SUPABASE_ONLY_MODE=true` on empty row / missing fields / unparseable curr_time. `ReverieServer.__init__` tries Supabase first; JSON read + write-back only runs on cold-start fallback. Verified 2/2 movement realism tests pass; no schema changes.
- **2.2c — done 2026-04-23.** Associative memory Supabase-first load. Added `sim_name`/`persona_name` params to `AssociativeMemory.__init__`; `_try_load_from_supabase()` resolves `simulation_id` via `get_simulation_id_by_name` RPC, `agent_id` via `get_agent_id_by_name` RPC, then reads all rows directly from `double.dbl_memory` (chosen over `dbl_get_sim_memories` RPC because that RPC drops keywords/meta.filling/meta.expiration and caps at 100 rows). Reconstructs `ConceptNode` objects via existing `add_event`/`add_thought`/`add_chat` methods, which automatically re-derive `kw_strength_event`/`kw_strength_thought` and populate all `seq_*`/`kw_to_*`/`id_to_node` indexes. Verified end-to-end against sim `20260422-7` (861 memories across 4 personas reconstructed correctly after a fork). `persona.py` threads `sim_name`/`persona_name` into the constructor. Latent bug fix: `parse_memory_created` in `memory_compat.py` now zero-pads Postgres variable-precision fractional seconds before `datetime.fromisoformat` — was silently dropping ~9.5% of rows on Python 3.9. Verified 0/893 parse failures after fix vs. 82/861 before.

### 2.3 Spatial memory — resolved (no code change needed in Pass 2)

Decision taken 2026-04-22: spatial memory functions as "what's reachable right now," derived from maze + access rules at query time. No per-persona storage, no migration, no new table. See §Spatial memory above.

Legacy `MemoryTree.save()` is marked deprecated in code; no runtime caller invokes it under `USE_GRID_OBJECTS=true`. Removing the class entirely is left for a later cleanup pass so the dev-inspection `__main__` block in `spatial_memory.py` keeps working until the JSON bootstrap artifacts are retired.

### 2.4 Fork completeness audit

Verify `fork_simulation()` produces a genuinely complete Supabase-only state for the new sim, with no residual dependency on the source sim's on-disk files. Concrete test: fork sim A on host X, run the fork on host Y with no access to X's disk, confirm it behaves correctly.

### 2.5 Production env profile — **done 2026-04-23**

Flag set finalized (see "Production env profile" below) and shipped as a copy-pasteable template at `generative_agents_supabase_first/.env.production.example`. Deploy checklist in the "Deploying to production" section further down this doc.

---

## Production env profile — finalized 2026-04-22

```bash
# Temp-cache writes (bucket 3). As of 2026-04-22, code defaults match these
# values, so omitting them from the environment is safe. Keep them explicit
# in production config for auditability.
MEMORY_PRIMARY=supabase
SCRATCH_PRIMARY=supabase
SIM_META_PRIMARY=supabase

# Temp-cache reads — strict (no JSON fallback).
# Activated once §2.2 Supabase-first load paths land; harmless until then.
USE_DB_MEMORY_READS=true
SUPABASE_ONLY_MODE=true

# Transport (bucket 1) — wire-format only, no disk.
USE_SUPABASE_STEP_SOT=true
SKIP_MOVEMENT_JSON_WRITE=true
SKIP_ENV_JSON_WRITE=true
SKIP_TEMP_STORAGE_WRITE=true

# Coord / fork strictness.
SUPABASE_COORD_REQUIRED=true
INIT_COORDS_PRIMARY=supabase

# Maze.
USE_SUPABASE_MAZE=true
```

Why `SUPABASE_ONLY_MODE` and not a new `STRICT_SUPABASE_ONLY`: the flag already exists (see `reverie.py:1095`) and is the "reuse existing flag" choice per the CLAUDE.md rule. §2.2 extends its semantics from "don't clear inherited movement dir on fork" to the broader "production-strict; no JSON fallback; fail loud on Supabase unavailability."

Dev profile: same flags may be set, but `SUPABASE_ONLY_MODE` should be unset or `false`, and the `SKIP_*_JSON_WRITE` flags may be relaxed for local inspection.

---

## Dev vs production — behavior differences

| Concern | Dev | Production |
|---|---|---|
| Temp-cache writes | Supabase (code default since 2026-04-22) | Supabase (code default since 2026-04-22) |
| Temp-cache reads | Supabase-first, JSON cold-start fallback OK | `SUPABASE_ONLY_MODE=true`; no JSON fallback; fail loud |
| Transport JSON on disk | May be written for inspection | Skip; wire-format only |
| Diagnostics JSON on disk | Written | Written short-term; ship to durable store post-MVP |
| `.env.local` required | Optional (code defaults now correct) | Optional for correctness; keep explicit for auditability |

---

## Deploying to production

**1. Copy the env template.** On the deploy host:

```bash
cp generative_agents_supabase_first/.env.production.example generative_agents_supabase_first/.env.production
```

Fill in every `[SECRET]` placeholder from the Supabase and OpenAI dashboards. Do not commit the filled file.

**2. Confirm three critical flags are set.** These are the posture-defining ones:

- `SUPABASE_ONLY_MODE=true` — missing Supabase data becomes a hard error (no silent JSON fallback).
- `USE_SUPABASE_STEP_SOT=true` plus the three `SKIP_*_JSON_WRITE=true` flags — transport is wire-format only; no disk.
- `MEMORY_PRIMARY=supabase`, `SCRATCH_PRIMARY=supabase`, `SIM_META_PRIMARY=supabase` — canonical writes go to Supabase only.

**3. Sanity-check at first sim-start.** Look for these startup log lines (one per persona for the memory line):

- `✅ SUPABASE MEMORY LOAD: <persona> — N memories (events=…, thoughts=…, chats=…, skipped=0)`
- No `⚠️ SUPABASE META LOAD failed softly, falling back to JSON` warning.
- No `⚠️ SUPABASE SCRATCH LOAD` warnings.

If any warning appears under `SUPABASE_ONLY_MODE=true`, the sim halts — that is the intended behaviour. Fix the underlying Supabase issue before retrying.

**4. Forbidden dev flags.** Verify these are **unset** (not just `false`) in the deploy environment:

- `BACKEND_LOCAL_ONLY` — forces JSON paths, defeats the whole posture.
- `SUPABASE_READ_ONLY_MODE` — blocks all Supabase writes; sim state can't persist.

**5. Post-deploy smoke test.** Fork a known-good baseline sim on the deploy host, run 10 steps, and confirm:
- All three `✅ SUPABASE … LOAD` banners appear for each persona.
- `dbl_memory` shows new rows with fresh `created_at` values from the test sim.
- No disk writes under `storage/<sim_code>/movement/` (since `SKIP_MOVEMENT_JSON_WRITE=true`).

---

## Open decisions

- **Diagnostics durability.** Not Pass 2. Noted here so the decision isn't forgotten: at what point do we ship `STATUS.json` / prompt dumps to S3 or equivalent so a crashed container doesn't lose forensics.

---

## Backlog (post-MVP)

### Remove JSON fallback at scratch load (Option B cleanup for §2.2a)

**What.** Remove the JSON reader from `Scratch.__init__` entirely. Scratch load becomes Supabase-only in both dev and production; `SUPABASE_ONLY_MODE` gating becomes unnecessary for scratch.

**Why.** Today's §2.2a (Option A) is Supabase-first with a JSON cold-start fallback in dev. The fallback exists because a brand-new baseline's shipped `bootstrap_memory/scratch.json` seeds are read at first persona init if Supabase is empty. This creates two read paths to maintain and a dev-vs-prod asymmetry that's easy to forget.

**Pre-req.** Audit the full sim-creation flow end-to-end and confirm every path — fork from Supabase baseline, brand-new sim from shipped seeds, custom-sim provisioning pipeline — imports JSON seeds into Supabase before `Persona` is instantiated. The fork case already works via `fork_simulation()`; the brand-new-baseline case needs explicit verification.

**Change.** Once the pre-req is satisfied: delete the `scratch_load = {}` + JSON read + inline population block from `Scratch.__init__`. Keep only the Supabase path. Update dev workflow docs if the bootstrap step becomes mandatory.

**Effort.** Small code-wise (~190 lines deleted). Non-trivial audit to confirm no legitimate dev path relies on the fallback.

### Subjective learned spatial knowledge

**Context.** Today's spatial memory is *objective*: every persona knows whatever the maze + their access rules say is reachable, and they know it from step zero. This is correct for "what's physically accessible to me" but doesn't model the cognitive reality that real people only know about places they've actually been to or heard about.

**Goal.** Not to re-introduce the classic per-persona `MemoryTree` (which duplicated maze structure and drifted from grid reality as objects moved). Instead, **enhance the existing grid-derived model with a thin subjective layer**: on top of the objective "what's reachable," track per-persona what the persona has *learned about* — visited in person, been told about in conversation, or seen mentioned in memory.

The objective layer (maze + access rules) stays the source of truth for structure and object contents, so consistency across personas is preserved. The subjective layer is purely additive: a "known-to-this-persona" filter or tag.

**Shape (rough).**
- New Supabase table keyed by `(simulation_id, persona_id, address)` — each row = "this persona knows about this sector/arena, learned via X at step N."
- Perceive extends the table on first-time observation; conversation outcomes may also extend it when a topic references a place.
- Query-side: `get_str_accessible_sectors` can optionally filter to "sectors I've learned about" vs. "sectors I can reach" depending on the cognitive use case (planning vs. navigation).
- Fork copies the table (per-persona learning inherits).

**When.** Post-MVP. This is a product decision about agent cognition, not a storage cleanup — it would meaningfully change how agents talk and plan (e.g., a persona wouldn't propose meeting at a cafe they've never heard of). Should be sequenced after MVP is in users' hands and we've seen where richer cognition would matter.

**Effort.** Medium. Schema is small; integration points are perceive, the `get_str_*` methods, fork, and any prompt path that narrates "places I know." Validation needs a clear behavioural goal (what does "better" look like?) before starting.
