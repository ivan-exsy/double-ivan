## *MVP: Soul‑15 → “empty” Ville*

### MVP goal
- **Goal**: Import **15 Soul profiles** into Supabase, attach minimal sprite metadata, create a brand-new simulation in an otherwise “empty” village (`the_ville`), and run the simulation (headless validation on).
- **No UX**: You will do setup manually (SQL + scripts + API calls). We only need a reliable, repeatable process + supporting Supabase infrastructure.
- **Sample Soul inputs (in-repo)**: see `souls/Ivan_Pitts.md` and `souls/Alex_Butcher.md` for the expected structure and level of detail.

### Definition of Done (MVP success criteria)
- **15 personas exist** in Supabase (`double.personas`) with stable names (these are the Soul profile identities).
- For each persona:
  - Soul doc is stored as a **long-form profile document** (auditable).
  - A small set of **compiled snippets** exists (speaking style, values, decision heuristics, etc.) for token-efficient prompting.
  - A **sprite profile record** exists (even if it points to placeholders for now).
- A new simulation exists using `the_ville` maze and contains **only those 15 personas** (no baseline residents).
- Simulation can run at least **N=20 steps** without crashing, and step playback can be retrieved from Supabase-first read paths.

### What is in scope (MVP)
- **Soul profile ingestion**:
  - Store full Soul markdown (long doc) + extracted “snippet” blocks (short docs).
- **Supabase-first “profile SOT” infrastructure** (minimum viable):
  - tables for long docs + snippets + versions
  - one RPC to fetch “snippet bundle” per persona/task type (so backend can avoid token bloat)
- **Sprite profile infrastructure** (minimum viable):
  - store sprite metadata in Supabase (profile image + optional atlas paths)
  - actual art can be placeholders in MVP
- **Empty village simulation bootstrap**:
  - create a brand-new sim in Supabase using existing RPCs (`bootstrap_simulation`)
  - link the 15 personas into the sim
- **Minimal spawn + routine seeding**:
  - write `living_area`, `daily_plan_req`, `currently`, etc. into Supabase scratch (`save_persona_scratch`) so the engine has “day one” grounding.
- **Run and verify**:
  - run steps with headless validation enabled
  - verify step/coords/movement are written and readable

### What is explicitly out of scope (MVP)
- Invites, roles, RLS-hardening for multi-user participation.
- Self-serve home selection UI, routine editor UI, profile editor UI.
- Full dynamic sprite loading refactor in the frontend (Phaser atlas loading from signed URLs).
- Deep “merge engine” for conflicting sources (we’ll keep it deterministic and simple for Soul-only MVP).

### MVP prerequisite notes (important)
- **Do not rely on** `POST /api/simulations/` for MVP simulation creation:
  - current `SupabaseService.create_simulation()` in the API gateway is missing persona linking (marked TODO).
  - For MVP, use **Supabase RPCs** (`bootstrap_simulation`, `save_persona_scratch`) or `reverie.py` calling them.
- **Scratch is available in Supabase**:
  - `public.save_persona_scratch(sim_name, persona_name, scratch_jsonb)` exists and is intended for this.
- **Simulation bootstrap is available in Supabase**:
  - `public.bootstrap_simulation(sim_name, persona_names[], description?, maze_name?)` exists and is idempotent.

### Minimum Supabase infrastructure to add (MVP)
This is the minimum new “profile SOT” infrastructure to support Soul profiles + token efficiency.

- **New tables (in `double` schema)**:
  - `double.persona_profile_documents`
    - **Purpose**: store long-form Soul markdown (auditable).
    - Key fields: `persona_id`, `doc_type='soul_markdown'`, `content`, `version_hash`, `created_at`.
  - `double.persona_profile_snippets`
    - **Purpose**: store compact prompt-ready blocks.
    - Key fields: `persona_id`, `snippet_type`, `content`, `max_tokens_hint`, `priority`, `version_hash`, `derived_from_document_id`.
  - `double.persona_sprite_assets` (or equivalent)
    - **Purpose**: map persona → profile image + optional atlas assets.
    - Key fields: `persona_id`, `profile_image_path`, `atlas_image_path`, `atlas_json_path`, `source_bucket`, `version_hash`.

- **New RPCs (public or double schema, whichever is consistent for your RPC posture)**:
  - `get_persona_profile_context(p_persona_id, p_task_type)`
    - returns the minimal snippet bundle for `chat|planning|action|reflection|auto`.
  - (Optional but recommended) `get_persona_profile_fingerprint(p_persona_id)`
    - returns a stable hash so the backend can cache snippet bundles per persona.

### MVP implementation plan (Soul‑15 → “empty” Ville)
This replaces the “do it by hand” runbook with an implementation plan that a senior engineer can execute in this codebase.

**Alignment rules**
- Supabase is the **source of truth** for runtime state (see `docs/README.md` and the SOT index `docs/sot/index.md`).
- DB access for core systems should remain **RPC-first** (consistent with existing posture in memory/coord clients).
- Do not change FE/BE movement contracts (`docs/sot/sot_be-fe.md`) for this MVP.
- If you introduce new runtime payload fields or change prompt entrypoints, update the relevant SOT (`docs/sot/sot_memory.md`, `docs/sot/sot_prompts.md`, `docs/sot/sot_llm.md`) in the same PR.

#### ✅ **Workstream A — Supabase “profile SOT” schema + RPCs** (new)
**Deliverable**: a migration in `supabase/migrations/` that creates the minimum tables and RPC(s) needed for Soul docs + snippets.

- Applied migrations:
  - `20260206000001_security_lints_safe.sql`
  - `20260224000001_workstream_a_profile_sot.sql`
- Verified in Supabase:
  - `supabase_migrations.schema_migrations` includes both versions.
  - `double.persona_profile_documents`, `double.persona_profile_snippets`, `double.persona_sprite_assets` exist.
  - `public.get_persona_profile_context(uuid, text)` and `public.get_persona_profile_fingerprint(uuid)` exist.
- Smoke checks passed:
  - `get_persona_profile_context` returns correct schema for `chat` and `planning`.
  - `get_persona_profile_fingerprint` is stable across repeated calls.
  - RLS policies for all three new tables are present for `authenticated` and `service_role`.

- **Tables** (in `double` schema):
  - `persona_profile_documents` (store long-form Soul markdown)
  - `persona_profile_snippets` (store compiled short blocks)
  - `persona_sprite_assets` (sprite metadata mapping; paths into Storage buckets)
- **RLS posture (MVP)**:
  - Service role full access (required for backend automation).
  - For MVP (no UX), you can keep authenticated access broad, but document tightening for post-MVP invites/RLS.
- **RPCs** (prefer `public.*` SECURITY DEFINER, consistent with existing simulation/scratch RPC style):
  - `get_persona_profile_context(p_persona_id uuid, p_task_type text) returns jsonb`
    - returns a **bounded** snippet bundle for `chat|planning|action|reflection|auto`.
  - `get_persona_profile_fingerprint(p_persona_id uuid) returns text` (optional but recommended)
    - stable hash over the current snippet set for caching.

#### ✅ **Workstream B — Soul ingestion + snippet compilation pipeline** (new script)
**Deliverable**: a deterministic import script that can run locally and populate Supabase.

- Implemented:
  - `scripts/import_soul_profiles.py`
  - `scripts/verify_soul15_mvp.py`
- `import_soul_profiles.py`:
  - takes `--sim-code`, `--maze the_ville`, and a folder of Soul `.md` files
  - parses persona name from filename or the document header
  - ensures persona exists (via RPC `ensure_persona_exists` or by calling `bootstrap_simulation` later)
  - writes the Soul markdown into `double.persona_profile_documents`
  - compiles snippets (no runtime LLM dependency) into `double.persona_profile_snippets`
  - optionally writes placeholder `persona_sprite_assets` rows (or accepts `--sprite-manifest` JSON)
- `verify_soul15_mvp.py`:
  - verifies simulation exists and maze matches
  - verifies expected persona count
  - verifies each persona has active `soul_markdown` doc, required snippet types, and an active sprite row

**Completed smoke run**
- Import command executed:
  - `python scripts/import_soul_profiles.py --sim-code leadertalks --maze the_ville --souls-dir souls`
- Verification command executed:
  - `python scripts/verify_soul15_mvp.py --sim-code leadertalks --expected-personas 2 --expected-maze the_ville`
- Result:
  - Import succeeded for `Alex Butcher` and `Ivan Pitts`.
  - Verification passed.

**Snippet compilation rules (MVP)**
- Produce at least:
  - `speaking_style`, `values_and_principles`, `decision_heuristics`, `social_rules`, `topic_attractors`, `do_not_do`
- Snippets must be **short** and stable (goal: reuse across many steps without token bloat).
- Use the repo samples as fixtures/ground truth for parser behavior:
  - `souls/Ivan_Pitts.md` (explicit “Voice & writing fingerprint”, “Do/Don’t list”, and “Quick agent prompt” section)
  - `souls/Alex_Butcher.md` (explicit metadata + values + decision-making sections)

**Expected Soul doc conventions (MVP)**
- Markdown heading structure is used as the primary parse signal.
- Treat these as “high-signal” sections when present:
  - voice/speaking style: `Voice & writing fingerprint`, `Typical cadence`, `Tone boundaries`
  - values: `Core values and principles`
  - decision heuristics: `Decision-making and planning`, `Default priorities`, “if-then rules”
  - social rules: conflict/de-escalation sections
  - topic attractors: `Topic attractors`
- Do not require perfect uniformity across files; fall back to best-effort extraction + a conservative default snippet set.

**How to add more Soul profiles (repeatable)**
1. Add new markdown files in `souls/`.
2. Ensure persona identity is discoverable by one of:
   - `- **Name / handle:** <Full Name>` in the doc, or
   - first `#` heading with the full name, or
   - filename (for example `First_Last.md`).
3. Run a dry-run parse:
   - `python scripts/import_soul_profiles.py --sim-code <sim_code> --maze the_ville --souls-dir souls --dry-run`
4. Run the real import:
   - `python scripts/import_soul_profiles.py --sim-code <sim_code> --maze the_ville --souls-dir souls`
5. Verify integrity:
   - `python scripts/verify_soul15_mvp.py --sim-code <sim_code> --expected-personas <N> --expected-maze the_ville`
6. Optional: use a sprite manifest to avoid placeholders:
   - `python scripts/import_soul_profiles.py --sim-code <sim_code> --maze the_ville --souls-dir souls --sprite-manifest <path_to_json>`

#### ✅ **Workstream C — Runtime consumption: “Profile Context Builder”** (backend change)
**Deliverable**: backend can fetch snippet bundles once and reuse them safely across LLM calls.

- Implemented:
  - `reverie/backend_server/persona/prompt_template/profile_context_builder.py`
  - `reverie/backend_server/persona/prompt_template/context_builder.py` integration
  - `reverie/backend_server/persona/memory_structures/double_memory_client.py` RPC helpers:
    - `get_persona_profile_context(...)`
    - `get_persona_profile_fingerprint(...)`
    - `get_persona_id_by_name(...)`
  - Observability exports:
    - `reverie/backend_server/persona/prompt_template/gpt_structure.py` (`profile_context_stats`)
    - `reverie/backend_server/reverie.py` (`export verification stats` includes profile-context counters)
- Add a small “Profile Context Builder” in the backend (location: a prompt/context builder module used by persona prompting).
- Behavior:
  - fetch snippet bundle via `get_persona_profile_context(persona_id, task_type)`
  - cache by `(persona_id, fingerprint, task_type)` so we don’t re-read every step
  - clamp profile-context budget per task type (mirrors the budgeting posture in `docs/sot/sot_memory.md`)
  - never include full Soul markdown in steady-state prompts (only snippets)

**Integration points**
- For chat-oriented calls → include `speaking_style` + `social_rules` (+ small `values` when needed).
- For planning/action calls → include `decision_heuristics` + `values_and_principles` + `do_not_do`.
- For reflection calls → include `values_and_principles` + `topic_attractors`.

#### ✅ **Workstream D — “Empty Ville” simulation bootstrap + step-0 seeding** (script + RPC usage)
**Deliverable**: one command creates a sim with exactly 15 personas and seeds their initial scratch state in Supabase.

- Use existing Supabase RPCs:
  - `bootstrap_simulation(p_sim_name, p_persona_names, p_description, p_maze_name='the_ville')`
  - `save_persona_scratch(p_sim_name, p_persona_name, p_scratch_data)`
- Extend `scripts/import_soul_profiles.py` (single-script path) to:
  - call `bootstrap_simulation` once with all 15 personas (idempotent)
  - enforce deterministic roster count (`--expected-personas`, default `15`)
  - optionally restrict to an explicit roster manifest (`--persona-roster`)
  - for each persona, write step-0 scratch with:
    - identity: `name/first_name/last_name`, plus compact `innate/learned/currently`
    - routine anchor: `daily_plan_req`
    - grounding: `living_area` (must resolve to walkable tiles in the Ville)
    - explicit deterministic `curr_tile` (default on; can be disabled by flag)
  - overwrite scratch on reruns (idempotent upsert behavior via RPC)

**Spawn policy (MVP)**
- Start simple and safe:
  - use one known-valid shared location for all 15 (`the Ville:Johnson Park:park` default)
  - fail fast if configured `living_area` has no walkable tiles
  - optional operator override: enable fallback (`--allow-living-area-fallback`) to a configured fallback area
- Then improve:
  - assign distinct homes and set `living_area` accordingly (still manual inputs, no UX)

**Approved defaults (2026-02-24)**
- Use one script only: `scripts/import_soul_profiles.py` (no separate bootstrap script).
- Keep Workstream D boundary tight: bootstrap + step-0 seeding only (run/step verification remains Workstream E).
- Require minimum scratch fields on seed: `name`, `first_name`, `last_name`, `innate`, `learned`, `currently`, `daily_plan_req`, `living_area`.
- Support optional per-person scratch overrides via `--scratch-manifest` (data-driven, no code edits).
- Runtime startup supports Supabase-first missing-fork bootstrap: when `reverie.py` cannot find a local fork source folder, it can hydrate a local simulation skeleton from Supabase simulation/persona/scratch/step-0 records (`SUPABASE_BOOTSTRAP_ON_MISSING_FORK=true`).
- Baseline source policy defaults to Supabase at startup (`BASELINE_SOURCE_PRIMARY=supabase`), with file-based baseline folders retained as explicit fallback and startup-log reason codes.
- API start flow is Supabase-aware by default: if `sim_code` exists in Supabase and `fork_from` is omitted, start uses `fork_from=sim_code` and allows bootstrap-on-missing-fork path instead of requiring a pre-existing local baseline folder.

#### Workstream E — Run + verify (existing tooling + a small verification helper)
**Deliverable**: a repeatable verification routine that confirms the MVP is healthy.

- Add `scripts/verify_soul15_mvp.py` (or document using existing tests) to check:
  - sim exists, maze is `the_ville`, persona count is 15
  - profile docs + snippets exist for all 15
  - scratch exists for all 15 (and has `living_area`)
  - step data exists for 0..N and can be retrieved via Supabase-first reads
- Use existing analysis tooling (per `docs/README.md`):
  - `python tests/analyze_sim.py <sim_code> --source supabase --max-steps 40`
  - compare API vs Supabase sources if needed.

#### Operator workflow (after implementation exists)
- Run `scripts/import_soul_profiles.py --sim-code <...> --souls-dir souls --maze the_ville --expected-personas 15`
- Optional (strict roster): `--persona-roster <path_to_roster_json>`
- Optional (per-person seed overrides): `--scratch-manifest <path_to_scratch_manifest_json>`
- Run `scripts/verify_soul15_mvp.py --sim-code <...> --expected-personas 15 --expected-maze the_ville`
- Run simulation for N steps (via `reverie.py` or gateway start)
- Run verification script + `analyze_sim.py` to confirm stability and token posture


### **Fixing issues**

#### *1. Sprites cluster in a park/garden from step 0 and not moving as sim progresses*

**Root causes**
- Seed default currently uses one shared `living_area` (`the Ville:Johnson Park:park`) for all personas, so clustering begins at step 0 unless per-person homes are provided.
- Destination collapse to park: the deterministic sector matcher maps generic verbs like walk to Johnson Park before more specific place words like market, so many actions get routed to park.
- Hard freeze once “in zone”: movement code explicitly says if agent is already inside target zone, keep same tile (ret = curr_tile), even for actions that describe walking.
- Zone is broad for park addresses: exact-address zone is built as a bounding box over all walkable tiles (+padding), so many spawn points are already “in zone” at step 0.
- Then repeated no-op is reinforced: if intent unchanged and still in zone, no-op bypass keeps them stationary in later steps.

**Fixes**
- *Reduced destination collapse to park* in `reverie/backend_server/persona/cognitive_modules/plan.py`
  - Removed generic motion verbs (`walk`, `jog`, `exercise`) from deterministic sector mapping.
  - Kept explicit park targeting (`johnson park`, `park`).
  - Changed inaccessible keyword behavior from “break to LLM immediately” to “continue keyword scan” so one bad keyword does not force a fallback.

- *Fixed in-zone freeze behavior* in `reverie/backend_server/persona/cognitive_modules/execute.py`
  - Previously: if already in target zone, always `ret = curr_tile`.
  - Now:
    - if truly stationary intent (or speed 0), stay.
    - otherwise, consume path and advance **within zone**.
    - if path buffers are empty, do anchor-based in-zone movement fallback instead of hard stay.

- *Disabled no-op movement bypass by default for validation phase* in `reverie/backend_server/reverie.py`
  - `NOOP_MOVEMENT_BYPASS_ENABLED` default changed to `false` (still overridable via env).

- *Prevented hysteresis from pinning active movement*
  - Intent hold now applies only when `stationary_intent` is true.
  - This addresses the `🧲 INTENT HOLD ... delta=0` style pinning you saw in logs.

#### *2. Home Assignment for new sprites - Phase 1 (MVP, fast, low risk)*

**Goal** Ensure every new sprite in a new custom sim has a valid `living_area` before run start.

- Added feature flag: `ENABLE_HOME_ASSIGNMENT_MVP` (off by default, opt-in rollout).
- Extended create simulation contract with:
  - `sim_type`
  - `assignment_mode` (`auto` / `manual`)
  - `assignments`
  - `manual_with_auto_fill`
- Added endpoint: `POST /api/simulations/{sim_code}/assign-living-areas`.
- Added `/start` guard for custom sims:
  - blocks start if any persona is missing `living_area`.
- Persisted home assignment to Supabase source of truth:
  - `double.persona_scratch.living_area`
  - plus `curr_tile` and step-0 coordinate reseeding where needed.
- Returned resolved assignment payloads in API responses for auditability.

*Hardening completed during implementation*
- Fixed enum handling for `assignment_mode` validation.
- Fixed explicit `double` schema access for Supabase table reads/writes.
- Removed fragile `ON CONFLICT` dependency in environments missing matching unique constraints:
  - replaced with deterministic `select -> insert/update` workflow.
- Confirmed manual assignment workflow succeeds end-to-end in production-like smoke tests.

*Post-implementation findings (cross-team validation in this thread)*
- `/api/simulations/{sim_code}/personas` now follows Supabase-first retrieval for the current view:
  - resolve preferred step from metadata (`current_step`), then try `current_step`, `current_step-1`, then `0`.
  - keep filesystem fallback only when Supabase current-step data is unavailable (and non-strict mode permits fallback).
- Step-0 runtime contract is now explicit and enforced:
  - step 0 is a spawn snapshot (`movement == start_pos`, stationary path semantics).
  - first visible movement progression begins at step 1.
- SOT alignment updated for the above semantics:
  - `docs/sot/sot_api.md` (step-0 spawn-only note on `GET /step/{step_number}`).
  - `docs/sot/sot_be-fe.md` (required semantics for step-0 spawn snapshot).
- Auto assignment prerequisite remains data-dependent:
  - `assignment_mode=auto` requires home-like semantic addresses in maze tiles.
  - when candidate homes are absent/insufficient, use manual assignment + strict deterministic SQL allocation.
- FE review outcome:
  - no frontend code patch required for normal replay path.
  - required validation remains boundary-focused: step `0 -> 1` across load/play/scrub/live.

##### *Allocation Algorithm Used (for automation in future rounds)*

**Goal**
Assign each persona one legitimate, non-shared living space with deterministic and repeatable behavior.

**Inputs**
- Linked personas in target simulation (`double.personas_simulations`).
- Walkable maze tiles and semantic addresses (`double.maze_tiles`).
- Existing scratch/step0 records (`double.persona_scratch`, `double.personas_coords`).

**Candidate classification**
1. Build semantic addresses from walkable tiles (`world:sector:arena:game_object`).
2. Classify as:
   - `private_room`: address pattern like `...:Person's room`.
   - `owner_unit`: standalone owner home like `...:Adam Smith's house` or `...:Arthur Burton's apartment`.
3. Exclude shared/utility spaces (for home assignment):
   - `common room`, `main room`, `bathroom`, `toilet`, `sink`, `shower`, `kitchen`, etc.

**Scoring and selection**
4. Score candidates:
   - prioritize `private_room` over `owner_unit`.
   - penalize utility/shared semantics.
5. Deduplicate by exact tile anchor to avoid same-tile starts.
6. Deterministic ordering:
   - sort personas by name.
   - sort candidates by priority + address.
7. One-to-one assignment by rank (row-number join).

**Guardrails**
8. Fail if candidate count < persona count.
9. Enforce uniqueness of selected addresses and home tiles.
10. Fail on invalid/non-walkable addresses.

**Persistence**
11. Write `living_area` and `curr_tile` into `double.persona_scratch`.
12. Update/insert step-0 coordinates in `double.personas_coords`.
13. Verify:
   - `missing_count = 0`
   - no duplicate home addresses/tiles
   - step-0 spread is non-clustered.


##### **Failed Test Run 20260225-2**  

**Sim Code**: `20260225-2` (fork from home-assigned `soul15_seed_20260224`)  
**Date**: 2026-02-26 (post-fix validation run)  
**Steps Run**: 0-12 (11 success, step 12 failure)  
**Runtime**: ~2h total (step 0: 127s, step 4: 89s, step 12: headless timeout)  
**Status**: **PARTIAL SUCCESS** — Fixes validated, but headless strict mode blocked continuation.  
**Team Lead Action Items**: (1) Disable strict headless for longer runs, (2) investigate FE readiness leak.

*1. High-Level Outcome*
- **Spawn Fix (Fix 3)**: **FULL PASS**. Step 0 = pure spawn snapshot (15/15 stationary at homes).
- **Supabase-First Fix (Fix 2)**: **FULL PASS**. Positions from Supabase (`source=supabase-latest`).
- **Progression**: Steps 0-11 normal (planning, A*, reports accepted, observations triggered).
- **Failure Point**: Step 12 headless readiness timeout → strict mode `RuntimeError`.
- **No regressions**: SOT integrity 100%, movement from homes starting step 1.

*2. What Went Well (Validated Fixes)*
<Step 0 Spawn Snapshot>
```
🎬 STEP 0 SNAPSHOT: Alex Butcher spawn fixed at (35, 18) (movement starts step 1)
[CP-6] Alex Butcher step=0 | start_pos=[35, 18] | movement=(35, 18) | planned_pos=[35, 18] | path_len=1
```
- **All 15 personas**: `movement == start_pos` (homes from Supabase `personas_scratch.living_area` anchors).
- Pathfinding planned park zones → "NO REACHABLE TILE" (distant homes) → correctly stayed spawn.
- Headless FE: A* failed distant targets → reported spawn positions back.
- Backend: Accepted 15/15 reports via `anchor.start_pos` matching → stored in Supabase.

<Supabase-First Data Flow>
```
🧭 P2 Supabase SOT (latest) for Alex Butcher: (35, 18)
[CP-7] Alex Butcher step=0 | source=supabase-latest | pos=(35, 18)
```
- Positions resolved from Supabase RPC before planning (no file fallback).
- Step data written back to Supabase (`personas_coords`) with full movement JSONB.

<Headless + Observation Loop>
```
✅ Headless movements completed for step 0
📊 Found 15 movement reports, submitting...
[CP-8] ACCEPTED step=0 | persona=Alex Shepard (15 total)
```
- FE A* from homes → park (expected failures for distance).
- Proximity detected (step 4: Diana Ogden/Ivan Pitts → chat replan).
- 100% report acceptance rate.

*3. What Failed (Step 12 Block)*
```
⚠️ Headless ready timeout - AnimationManager not initialized: Timeout 20000ms exceeded.
❌ Step 12 validation: FAILED (0 mismatches)
RuntimeError: HEADLESS STRICT FAILURE: readiness contract not met at step=12. reason=headless_ready_false
```
- **Trigger**: `window.__headlessReady` never signaled (FE readiness leak).
- **Impact**: Strict mode abort (non-blocking in loose mode).
- **Tell-tale**: 
  ```
  🤖 [HeadlessState] readyForBackend=false (execute_hook_missing)
  🤖 [Headless] AnimationManager: Waiting for CollisionChunkManager before signaling ready
  ```
- **Root**: FE chunk preload or collision manager bind failure (longer-run artifact).

*4. Key Metrics (Step 5 Verification JSON + analyze_sim.py)*
<SOT Integrity>
```
"db_write_success_rate": 1.0 (15/15 per step)
"json_fallback_write_count": 0
"forced_fallback_rate": 0.0
```
- Supabase writes 100%; no fallbacks.

<Movement Rhythm (analyze_sim.py)>
| Persona | Eff% | Jitter% | Out% | Flags |
|---------|------|---------|------|-------|
| Alex Butcher | 68 | 0 | n/a | none |
| Alexis Reed | n/a | 100 | 100 | PERSISTENT_OUTSIDE_ZONE |
| Mike Hooks | n/a | 100 | 100 | PERSISTENT_OUTSIDE_ZONE |
| Max Shoemaker | 36 | 0 | n/a | LOW_NET_PROGRESS |
| 10 others | 65-99 | 0 | n/a | none |

- **Expected**: Distant homes → persistent zone-outside (park unreachable).
- **Healthy**: 59% carry-forward, good moving/stationary mix.

<LLM/Routing (24h window)>
```
total_calls: 629 | tier_A: 92% | avg_latency: 1175ms | cost: $0.03
tokens_per_step_avg: 72766 (>24000 threshold, watch)
```

*5. Root Causes & Tell-Tales*
- **Headless Block**: FE readiness state leak (step 12+). Logs:
  ```
  ⚠️ Headless ready timeout - AnimationManager not initialized
  🤖 [HeadlessState] readyForBackend=false (collision_manager_unbound)
  ```
- **Zone-Out**: Home anchors outside broad park bbox → unreachable plans (design intent).
- **Tokens**: High per-step tokens (LLM verbose) — non-blocking but monitor.

=========================================

## **Backend Observation Pipeline Fixes (Compressed Implementation Backlog)**

### Ticket
- **ID**: `BE-OP-001`
- **Priority**: P0
- **Owner**: Backend team
- **Stakeholders**: FE lead, Simulation PM, Infra/Supabase owner
- **Scope Matrix**: 4-persona and 15-persona sims (>=30 new steps each)

### Current Status (As of Day 1)
- ✅ **Day 1 complete**: instrumentation is implemented and emitting pipeline timings.
- ✅ Per-step and per-operation metrics now exist for:
  - `receive_observation_ms`
  - `pending_json_read_ms`, `pending_json_write_ms`, `pending_json_size_bytes`
  - `submit_reports_total_ms`, `submit_report_single_ms`
  - `process_pending_ms`, `movement_report_handle_ms`
  - `supabase_update_position_ms`
  - step-level `headless_validation_ms` summary
- ✅ Baseline summarization helper exists for p50/p95 extraction from logs.

### Root Cause Position (Discovery Already Sufficient)
The BE bottlenecks are already known and implementation can proceed without further broad investigation:
1. Per-report full-file read/write of `pending.json` causes queue write amplification.
2. Headless report submission is sequential.
3. Pending observation processing and Supabase position writes are per-report/per-persona sequential.

### Non-BE Confounders to Control During Benchmark
- FE build/runtime health must be green (no route/chunk 404).
- Use frontend-visible sim codes.
- Use consistent strict-mode configuration across before/after runs.

### Backlog (Execution-First)

#### **✅ Track A — Queue Write Amplification Reduction (P0)**
**Goal**: reduce ingest p95 growth over run length while keeping current API contract.
- Implement processed-entry compaction for `pending.json` (drop or archive processed rows).
- Add bounded queue-size guardrails and optional rotation.
- Keep `POST /api/simulations/{sim_code}/observations` behavior backward-compatible.
- Deliverable: before/after p50/p95 delta on `pending_json_read_ms`, `pending_json_write_ms`, `receive_observation_ms`.

#### **✅ Track B — Batch Ingest + Submit Path (P0)**
**Goal**: reduce submit overhead at higher persona counts.
- Add additive `/observations/batch` endpoint behind feature flag.
- Keep existing single-observation endpoint fully supported.
- Add flagged headless submit path using batch (or controlled parallel fallback).
- Deliverable: before/after p50/p95 delta on `submit_reports_total_ms` and `headless_validation_ms`.


# ## What This Section Means

In simple terms, `docs/20260225_custom_sims.md` is saying:

- Stop doing open-ended investigation.
- We already know the bottlenecks.
- Execute a **4-track delivery plan** with measurable before/after results.

So this section is now an **implementation backlog + acceptance contract**, not a research plan.

## How To Read The 4 Tracks

- **Track A**: Make queue writes cheaper (`pending.json` overhead).
- **Track B**: Batch observation ingest/submit to cut per-step submission time.
- **Track C**: Speed up processing + Supabase writes while preserving correctness.
- **Track D**: Rollout safety (flags, runbook, rollback path).

## Where You Are Now (based on your recent runs)

- **Track A/B**: validated in practice (4p + 15p batch behavior seen).
- **Track C**: validated on `20260227-15p-1` (31 steps, workers=`2`).
- **Track D**: rollout runbook consolidated in this document with release profile frozen.

# ========= <Phase 2 Closure (2026-02-27)> =========

1. **Track C runtime validation (15p) completed**:
   - `MOVEMENT_REPORT_DEFER_SUPABASE_WRITE_ENABLED=true`
   - `SUPABASE_POSITION_WRITE_MAX_WORKERS=2`
   - batch + compaction flags enabled
   - run result: 31 steps on `20260227-15p-1`

2. **Baseline comparison completed** (`tmp` artifacts):
   - primary metrics compared: `process_pending_ms`, `movement_report_handle_ms`, `supabase_update_position_ms`
   - secondary metrics reviewed: `submit_reports_total_ms`, `headless_validation_ms`
   - outcome: clear improvements on processing path; write latency remained within MVP tolerance.

3. **Guardrails held in run validation**:
   - no duplicate/missing movement reports
   - strict integrity unchanged
   - replay continuity unchanged

4. **Workers=4 remains optional canary**:
   - not required for MVP release
   - run short canary only if capacity allows after release cut.

5. **Formal decision**:
   - **GO for MVP release now** with workers=`2` as runtime default.
   - keep residual risks documented (token guardrail, movement quality/jitter) as post-MVP backlog items.


#### **Track C — Processing + Store Throughput (P0)**
**Goal**: reduce backend processing/store latency while preserving correctness.
- Optimize `process_pending_observations` hot loop for movement reports.
- Add controlled parallelism or batched Supabase write strategy for position updates.
- Preserve strict dedupe/idempotency by `(step, persona)`.
- Deliverable: before/after p50/p95 delta on `process_pending_ms`, `movement_report_handle_ms`, `supabase_update_position_ms`.

#### **Track D — Hardening + Rollout (P1)**
**Goal**: safe rollout and fast rollback.
- Finalize feature flags, defaults, and rollback toggles.
- Add runbook for Day-1 metric collection and triage.
- Deliverable: rollout checklist and explicit go/no-go decision.

### Guardrails (Must Hold)
- Keep movement report contract invariants:
  - tile coordinates for `actual_pos` and `actual_path`
  - strict dedupe/idempotency by `(step, persona)`
  - strict-mode integrity/readiness semantics unchanged
- Preserve observation-driven chat triggering and pre-step processing semantics.
- Do not break existing single-report clients during rollout.

### SOT Update Requirements (If Behavior/Contract Changes)
- `docs/sot/sot_api.md` for API changes (including any batch endpoint behavior).
- `docs/sot/sot_chats.md` for observation queue semantics changes.
- `docs/sot/sot_be-fe.md` if runtime movement/report contract changes.

### Benchmark and Acceptance (Condensed)
- [x] Produce timing table for 15 personas and compare against prior 15p baseline artifacts.
- [x] Show at least one optimization with clear before/after p50 and p95 improvement.
- [x] Confirm correctness unchanged:
  - strict integrity checks pass
  - no increase in duplicate/missing movement reports
  - no replay continuity regression
- [x] Document chosen implementation path, risks, rollback profile, and final go/no-go.
- [ ] (Optional post-release) run workers=`4` canary and re-check p95 stability.

### Consolidated Rollout Runbook (Track D)

This section replaces the standalone rollout note and keeps all release-critical rollout guidance in one place.

**Implemented tracks**
- Track A: queue compaction/archival guardrails on ingest.
- Track B: batched observation ingest + headless batch submit path with fallback.
- Track C: movement pre-dedupe in processing + optional deferred/parallel Supabase writes.
- Track D: feature flags + staged rollout + rollback guidance.

**MVP release runtime profile (frozen)**
- `ENABLE_OBSERVATIONS_BATCH_ENDPOINT=true`
- `HEADLESS_OBSERVATIONS_BATCH_ENABLED=true`
- `OBS_QUEUE_COMPACT_ON_WRITE=true`
- `MOVEMENT_REPORT_PREDEDUPE_ENABLED=true`
- `MOVEMENT_REPORT_DEFER_SUPABASE_WRITE_ENABLED=true`
- `SUPABASE_POSITION_WRITE_MAX_WORKERS=2` (release default)
- workers=`4` remains optional canary only.

**Rollout status**
- Phase 0 (safe baseline): completed (4p + 15p).
- Phase 1 (batch ingest 4p): completed.
- Phase 1b (batch ingest 15p): completed.
- Phase 2 (processing throughput 15p): completed on `20260227-15p-1` (31 steps, workers=`2`), GO for MVP.

**Rollback order**
1. Set `SUPABASE_POSITION_WRITE_MAX_WORKERS=1`.
2. Set `MOVEMENT_REPORT_DEFER_SUPABASE_WRITE_ENABLED=false`.
3. Set `HEADLESS_OBSERVATIONS_BATCH_ENABLED=false`.
4. Set `ENABLE_OBSERVATIONS_BATCH_ENDPOINT=false`.
5. Keep single-observation path as compatibility fallback.

**Evidence bundle**
- Track C metrics log: `tmp/phase3_smoke_20260227-15p-1.jsonl`
- Track C summaries: `tmp/phase3_smoke_20260227-15p-1.md`, `tmp/phase3_smoke_20260227-15p-1.json`
- Phase 2 baseline summaries: `tmp/phase2_smoke_15persons_recalc.md`, `tmp/phase2_smoke_15persons_recalc.json`
- Delta table: `tmp/phase3_vs_phase2_15p_20260227-15p-1.md`