# Survival Mode — Cognitive Integration Upgrade

**Date:** 2026-04-16
**Last revised:** 2026-04-29 (Write side fully verified end-to-end on `20260429-1`: 4 distinct per-persona `agent_id` values, exactly 8 `alliance_formed` rows for 4 mutual pairs, every `tag_event` kind correctly attributed. Stage 3 Day-2+ retrieval target still owed — needs a ≥2 400-step run to cross Day-2 voting gate.)
**Owner:** Ivan (product) / Nicolas (impl)
**Branch target:** `ivan/survival`
**Authoritative contract:** `D:\Coding\double-docs\sot\sot_survival.md` (revised 2026-04-16)

---

## 0. Status at a glance (2026-04-29)

| Stage | Status | Note |
|---|---|---|
| 0 — mode flag + resolver | ✅ **Done** (2026-04-16) | Plumbing verified; `survival_mode` round-trips through scratch |
| 1 — Identity Overlay + daily plan | ✅ **Done** (2026-04-16, refined 2026-04-17 / 2026-04-21) | Overlay visible in every prompt; accessible-sector list + proper-noun rules added |
| 2 — hourly + task decomp; band-aid removal | ✅ **Done** (2026-04-26) | Interim acceptance verified on `20260426-1` (4 agents × 900 steps). 5-agent × 5-day formal stress (`20260415-5` config) still deferred — captured as §3 Stage 2d-formal follow-up. |
| 3 — memory poignancy + attention bias | 🟢 **Code complete + write side fully verified** (2026-04-29) | Phases 0/1/2/2.5/3/4 shipped; 46 unit tests passing. **Write side verified end-to-end on `20260429-1`**: per-persona `agent_id` scoping correct (4 distinct UUIDs matching `get_agent_id_by_name` RPC values), every `tag_event` kind attributed to the right persona, all `simulation_id` values populated. Day-1 retrieval at 0% sanity floor (passing). **Day-2+ retrieval acceptance target (≥50% / ≥80%) still owed** — needs a ≥2 400-step run that crosses the Day-2 voting gate (≈step 2 130). |
| 4 — conversation + reflect variants | ✅ **Primary + alliance trigger verified + over-firing fix shipped** (2026-04-29) | Chat / focal-pt / summarize survival variants; loader two-speaker dispatch. Alliance trigger verified end-to-end on `20260428-3` (8 mutual commitments across 4 pairs over 2 days) and on `20260429-1` (4 mutual pairs Day 1 — first sim with Day-1 alliances). Same-day duplicate guard added 2026-04-29 — collapses ~10× over-firing into 1 write per pair per day, verified on `20260429-1` (8 rows for 4 pairs vs. 40+ on `20260428-3`). Two conditional carryovers (reflection-skip, importance decay) still deferred pending Day-2+ smoke. |
| 5 — post-game decay + cleanup | ✅ **Done and verified** (2026-04-28; re-verified 2026-04-29) | `_clear_survival_mode(persona, archive_state=True)` helper replaces inline clearings; SurvivalState gains `archived` / `archived_at` fields (round-trip through Supabase). Verified on `20260428-3` (Luba + Ivan archived) and on `20260429-1` (Luba archived). |

**Intervening stability fixes (2026-04-20 → 2026-04-24) that back-support this plan:**

- Survival state is now a first-class Supabase entity (`double.survival_season_state`, `double.survival_agent_state`) with 5 RPCs; `fork_simulation` copies both tables. **This closes open question #3 in §8.**
- `fork_simulation` RPC fixes: `start_date` backfill + auto-set; `curr_time` inherits sim-level clock; UTC-truthful `CURRENT_DATE` → `(NOW() AT TIME ZONE 'UTC')::date`; `node_id` switched to fresh UUIDs to survive deep forks.
- `sim_code` stale-resume fix (both Supabase and local-file branches) so forked sims no longer write survival state into their parent's row.
- Survival agent-state save no longer fails on float-drifted int counters (`::numeric::int`).
- Reverie bootstrap now hydrates `survival/season_state.json` + `survival/agents/<name>.json` from Supabase after template copy.
- Spatial gate threshold changed to 80% with round-half-up: at `n=4` gate fires at 3/4, not 4/4. Relevant because Stage 2's acceptance test counts gate-fires.
- Location-resolver hardening: literal-sector short-circuit, accessible-sector proper-noun rules in daily+hourly prompts, parent-setting anchor for sub-activities (prevents drift), Tier-B escalation on novel anchors.

---

## 1. Why this change

Sim `20260415-5` exposed the limit of the current "directive-as-text" approach. Hard voting deadline at 20:00 (step 567) fired before the spatial gate met its quorum at 20:33 (peak 4/4). Luba was eliminated by a single real vote plus one phantom — narratively unsatisfying and procedurally driven by deadline timeout, not by the agents converging on her.

Nicolas's recent patches (`_inject_gathering_location_hints`, `_inject_voting_gather_override`) succeed at *signalling intent* but arrive too late and read as band-aids: each new failure mode adds another text injection. Root cause is architectural — survival is implemented as a *daily reminder* appended to a normal day, when it should be a **persona-level worldview** that reshapes planning, perception, retrieval, conversation, and reflection from the inside.

Real participants in survival games restructure their lives around the game. Their daily plans, attention, conversations, and memory all bend toward survival. The current implementation does not give the cognition pipeline that posture; survival information lives in `daily_plan_req` text and is competed against by every other planning input.

This upgrade moves survival from a text overlay to a cognition-shaping flag, while preserving the SOT principle that survival never bypasses or post-processes the perceive/plan/execute/reflect loop.

---

## 2. What changes vs. what stays the same

### Stays the same
- `SurvivalController` ownership of `SeasonState` and per-agent `SurvivalState`.
- Phase state machine, spatial gate, deadline fallback, elimination flow.
- Vote tally + tiebreak cascade, reward lifecycle, season persistence.
- All Supabase tables, RPCs, and triggers.
- FE A* pathfinding authority, `BACKEND_INTENT_ONLY_PATH=true`.
- Activation flag `SURVIVAL_MODE_ENABLED` — non-survival runs see zero diff.

### Changes
- New flag `persona.survival_mode: bool` toggled by `SurvivalController` on join / clear on eliminate / clear on game-over.
- Cognition prompt entry points (daily plan, hourly schedule, task decomp, conversation, reflect) prefer `<prompt>_survival_v1.txt` when the flag is set.
- Survival-aware variants receive an **Identity Overlay** block containing durable survival context: name, days survived, eliminated peers, alliances, threats, active rewards, today's challenge, hard deadlines.
- Memory storage tags survival events with `poignancy >= 7`.
- Perception ties broken in favor of alive-player percepts and gathering-location tiles.
- Conversation prompts (when both speakers in survival mode) bias topic selection toward alliance / voting / threat assessment.
- On elimination or game-over, `survival_mode` flips to False; `SurvivalState` archived (not cleared), memories decay naturally.
- **Deprecated:** `_inject_voting_gather_override`, `_inject_gathering_location_hints`. Removed once Stage 2 ships and verifies.

---

## 3. Stages

Each stage is a separate PR. Stages are ordered by dependency. Every stage must keep `SURVIVAL_MODE_ENABLED=false` runs unchanged (regression gate).

### ✅ Stage 0 — Mode flag plumbing  *(done 2026-04-16)*
**Goal:** introduce `persona.survival_mode` and the loader path for survival-aware prompt variants. No behavior change yet (no variant files exist).

**Deliverables:**
- `Persona.__init__` accepts/exposes `survival_mode: bool` (default False).
- `SurvivalController` sets the flag on `_initialize_persona_states()` and clears it on elimination / game-over.
- New helper `prompt_template/loader.py::resolve_template(name, persona)` — returns `<name>_survival_v1.txt` when persona has the flag and the file exists; falls back to `<name>_v1.txt` otherwise. Used by `run_gpt_prompt.py` only at the entry points listed in Stage 1.
- Unit test: flag toggles correctly across join/eliminate/restart cycles.

**Metric:** non-survival sim diff = 0 bytes in step JSON across a 720-step smoke.
**Rollback:** flag defaults to False; helper is a no-op when no `_survival_v1.txt` exists.

### ✅ Stage 1 — Identity Overlay + survival-aware daily plan  *(done 2026-04-16; refined 2026-04-17, 2026-04-21)*

**Goal:** survival agents start producing daily plans that natively allocate the challenge slot, gathering window, and voting block.

**Deliverables:**
- `SurvivalController.build_identity_overlay=(persona) -> str` — assembled once per step (cached per-day until next morning); returns the structured block defined in §4 below.
- `survival_daily_plan_v1.txt` template — same I/O contract as baseline `daily_plan_v1.txt` but adds an Identity Overlay slot and instructions to schedule challenge / gathering / voting first, then maintenance.
- `run_gpt_prompt_daily_plan` reads the flag and selects the variant.
- Smoke (3 agents, 1 day) confirms generated plan includes the gathering window and voting block in the schedule output, without any text injection into `daily_plan_req`.

**Metric:** in survival smoke, ≥80% of generated daily plans contain a gathering-window block before the existing `_inject_voting_gather_override` runs. Once verified, that override is disabled in Stage 2.
**Rollback:** clear `persona.survival_mode`; baseline template re-engages.

#### **Test Simmary**

Stage 1 smoke test — `20260416-1-surv-stage1` (500 steps, 09:00 → 17:20 sim time, 4 agents, fork of base_family_sim): 
- Ran clean to completion with no errors; 
- all four agents ended the run with survival.mode=true and a fully-populated identity_overlay in scratch conforming to §4 schema (day counter, eliminations, challenge, deadlines, gathering location, alliances, threats, rewards, reputation/social-capital labels). 
- The one fresh `run_gpt_prompt_daily_plan` call logged during the window (Katya, step 0) confirmed the resolver switched to `survival_daily_plan_v1.txt` — the prompt contained both the SURVIVAL CONTEXT block (overlay appended as !<INPUT 5>!) and the variant-only ACTIVITY RULES section — and the LLM returned a schedule explicitly allocating all three survival anchors (challenge 10:00–11:00, gathering 12:00–18:00, voting 19:00–20:00), all anchored at Hobbs Cafe. 
- Hourly schedules on disk corroborate: Katya and Ivan cleanly hold Hobbs Cafe across the voting window, Luba is there by role, Gosha is the weak case (checks in but drifts). 
- Stage 1 acceptance metric (≥80% of plans contain the gathering-window block before _inject_voting_gather_override runs) is met on the single fresh plan observed; remaining three agents reused forked-baseline plans and will need a longer or fresh-fork run to exercise. Minor copy issue noted for follow-up: overlay renders "Day 0 of 3" on calendar day 1 because days_survived starts at 0.
  
### ✅ Stage 2 — Hourly schedule + task decomposition variants; deprecate band-aids  *(code complete 2026-04-16; cleanup + acceptance closed 2026-04-26)*

**Goal:** propagate the worldview down to hourly schedule and task decomposition so the planner does not regress at 12:00 hand-off.

**Deliverables (shipped):**
- ✅ `survival_hourly_schedule_v1.txt`, `survival_task_decomp_v1.txt`, `survival_task_decomp_contextual_v1.txt` templates with Identity Overlay + survival-aware instructions.
- ✅ `run_gpt_prompt_generate_hourly_schedule`, `run_gpt_prompt_task_decomp`, and `run_gpt_prompt_task_decomp_contextual` route through `resolve_template`.
- ✅ `_inject_voting_gather_override` and `_inject_gathering_location_hints` removed from `plan.py`; helper tests deleted. Spatial gate + 20:00 deadline untouched.

**Post-Day-2 findings (2026-04-24, from `20260423-13-clean-day2`, 4 agents × 2 days):**

1. **Residual band-aid text in `daily_plan_req`.** The deleted injection functions wrote directive text ("CRITICAL: Gather at Hobbs Cafe by 19:00 for voting — missing it risks your safety.") into `persona.scratch.daily_plan_req` before Stage 2 removed them. That field persists through scratch saves and is copied forward by `fork_simulation`, so every prompt in this fresh Day-2 fork still carries the legacy text alongside the new Identity Overlay. End state: agents see the worldview *and* the band-aid, defeating the "replace text with worldview" intent.
2. **Challenge-decision and vote-decision LLM calls are invisible.** Across 1500 steps of prompt dumps the set of unique `function_name` values is 18; neither `run_gpt_prompt_challenge_decision` nor any vote-decision function appears, even though `season_state.json` shows 4/3 challenge claimants and real reasoning in `vote_history`. Either these calls skip the `function_name`-tagged dump path or don't go through the dump pipeline at all. Cannot verify the 13 `survival_challenge_*_v1.txt` templates actually fired.
3. **Acceptance rerun (5-agent × 5-day) not performed.** Day-2 run was 4 agents × 2 days and doesn't exercise the original `20260415-5` failure mode. The sim logs also do not record the voting-phase trigger reason (spatial gate vs deadline), so even for the voting phases we did have, the acceptance metric is unmeasurable from current telemetry.

**Closed items (Stage 2):**

- [x] **2a — Strip legacy directive text from `daily_plan_req` on morning reset.** Directive injection is removed, and `_resolve_today_challenge` preserves the needed bookkeeping without writing survival directive text into `daily_plan_req`. `_sweep_legacy_daily_plan_req` self-heals contaminated fork baselines by clearing legacy signatures on the first `on_step` call while leaving clean baselines untouched.
- [x] **2b — Add an explicit `survival_phase_trigger` log line, then persist it.** `_check_gate` emits `[survival_phase_trigger]` with `reason=spatial_gate` or `reason=deadline`, plus phase/day/time details. **Updated 2026-04-26:** the same call also appends a JSON record per gate-fire to `<sim>/logs/survival_phase_trigger.ndjson`, so the acceptance metric is `wc -l` against a known file rather than dependent on stdout capture.
- [x] **2c — Tag challenge-decision and vote-decision LLM calls with observability logs, then route them into the per-step dump.** `_collect_challenge_decisions`, `_collect_vote_decisions`, `_collect_paired_decisions` all emit `[survival_llm_call]` log lines and append entry/skip records to `<sim>/logs/survival_llm_calls.ndjson`. **Updated 2026-04-26:** `_run_survival_llm_call` wrapper now sets `cognitive_capture` thread-local context around each survival LLM call, buffers results per-step, and `reverie.py:_merge_survival_llm_calls` merges them into `<sim>/logs/llm/<step>.json` alongside the regular per-persona captures. Closes the observability gap that was the headline failure of `20260424-2` and `20260423-13-clean-day2`.
- [x] **Bonus — Self-vote failsafe fix.** Surfaced during `20260424-2` analysis: Ivan's Day-2 ballot had `voted_for == "Ivan Pistsov"` because `run_gpt_prompt_vote_decision.get_fail_safe` returned `eligible_targets[0]` without filtering the voter. Fixed two ways: failsafe now drops the voter before indexing; `_collect_vote_decisions` now builds a per-voter `voter_eligible` list and passes it both into the LLM prompt and the heuristic fallback. Self-vote is structurally impossible from either path.

- [x] **2d — Acceptance rerun (relaxed, interim):** 4 agents from `base_family_sim`, **900 steps** on `20260426-1` (Day 1 only — through the Day-1 voting gate at step 806 + ~64-step elimination tail). The original spec was 3000 steps / 2 sim days, but the architectural fixes shipped on 2026-04-26 made the relevant signals measurable from a 900-step run. The 5-agent × 5-day formal stress on the `20260415-5` config remains deferred (captured as 2d-formal in §9).

  **Pass criteria (acceptance results, mapped to the originally-defined criteria; full report at `D:\Coding\generative_agents\environment\frontend_server\storage\20260426-1\20260426-1_report.md`):**
  1. **No directive contamination** — ✅ **PASS.** 0 hits across `"CRITICAL: Gather at"`, `"SCHEDULE: Attend challenge at"`, `"Day N of Survival."` in 496 step LLM dumps.
  2. **Identity Overlay ubiquity ≥90%** — ✅ **PASS.** 100% on daily plans (10/10), hourly schedules (33/33), and task-decomp contextual (68/68). Repair-fallback variant remains at 0/4 (uses baseline retry template; not part of Stage 2's deliverable list).
  3. **Phase-trigger NDJSON complete** — ✅ **PASS.** 2/2 expected Day-1 events on disk: challenge gate at step 270 (`reason=deadline`, all 4 absent) + voting gate at step 806 (`reason=spatial_gate`, all present). For a 3000-step run the corresponding count would be 4. Original criterion's "4 lines expected" applied to a 2-day run; 2/2 is the 1-day analogue.
  4. **Spatial gate ≥1× of voting phases** — ✅ **PASS.** 1 of 1 voting gates fired on `spatial_gate`. Discriminator now persisted, so this is a direct measurement, not an inference.
  5. **Challenge/vote LLM observability** — ⚠️ **PARTIAL.** `run_gpt_prompt_vote_decision` × 4 records appear in `logs/llm/806.json`, matching the 4 `entry`-status records in `survival_llm_calls.ndjson` (vote-side end-to-end ✅). `run_gpt_prompt_challenge_decision` does not appear because the challenge gate took the deadline branch with all 4 agents absent — `_collect_challenge_decisions` was correctly skipped (no claimants to ask). The plumbing itself is verified-working on the vote half; the challenge half just wasn't exercised this run.
  6. **Sim completes cleanly + per-persona movement coverage** — ✅ **PASS** (criterion reworded per Ivan's request 2026-04-24 to handle eliminated agents). `meta.json.status=completed`, 900/900 movement files written, `movement/COMPLETED.json` present, FE forensics `blocked_rows=0` / `no_progress_same_tile_rows=0`. Gosha (eliminated Day 1) writes through step 870 (~64 steps post-vote-gate as background sprite); the other three through step 899.
  7. **Self-vote regression** — ✅ **PASS** (new check, added 2026-04-24). All 4 voters' eligible-targets lists structurally exclude self; vote_history shows Gosha→Ivan, Ivan→Gosha, Katya→Gosha, Luba→Gosha. The Day-2 Ivan-self-vote pathology cannot recur.

  **Net.** Every observability gap that was unverifiable / failing on `20260424-2` is closed on `20260426-1`. The single soft spot — challenge-side end-to-end LLM evidence — is a behavioural quirk of this run (no agent reached the gather zone before 11:00) rather than a Stage 2c plumbing failure. Captured as a follow-up in §9 sequencing.

**Metric:** all six original pass criteria + the new self-vote check; 5/7 ✅, 1/7 ⚠️ (challenge-side n/a — not a fail), 0/7 ❌. Stage 2 is closed.
**Rollback:** revert `ivan/survival` Stage-2 commits; Stage 0+1 still hold and are useful on their own.

### 🟢 Stage 3 — Memory poignancy + attention bias  *(code complete 2026-04-27; write side fully verified 2026-04-29; Day-2+ retrieval acceptance still owed)*

**Goal:** survival events surface naturally during retrieval and dominate ties in perception.

**What shipped (Phases 0 → 4):**
- Phase 0 — `cognitive_capture` records the rendered retrieval set per LLM call (`retrieved: [{description, poignancy, keywords}, …]`) into `<sim>/logs/llm/<step>.json`.
- Phase 2 — `survival/memory.py::tag_event(persona, sim_code, description, kind, poignancy=7)` writes through `dbl_store_memory_dev` with `keywords=["survival", kind]`. Four description templates for `vote_received`, `vote_cast`, `challenge_participated`, `elimination_witnessed`. (`alliance_formed` added in Stage 4.)
- Phase 2.5 — `_collect_vote_decisions` feeds the prompt's `TODAY'S EVENTS` slot via `new_retrieve` with vote-relevant focal points; structured retrieval list flows through to the dump.
- Phase 3 — Triggers wired into `SurvivalController` for all four kinds.
- Phase 4 — `perceive.py` ranks alive-player percepts and gathering-arena tiles ahead of equal-distance neutrals, gated on `persona.survival_mode`. Non-survival runs are byte-identical.

**Verification status (write side — fully closed 2026-04-29):**
- 46 unit tests passing.
- Fix 1 — unique `node_id` per `tag_event` write (no more UPSERT-collision). Verified on `20260428-1` (12 distinct rows on a 800-step fork).
- Fix 2 — deterministic `simulation_id` binding via direct RPC call. Verified on `20260428-3` and `20260429-1` (every survival row carries a non-NULL, fork-correct `simulation_id`).
- Per-persona `agent_id` scoping — verified on `20260429-1` via `GROUP BY agent_id` on the survival corpus: 4 distinct UUIDs (matching the `get_agent_id_by_name` RPC values), row counts per persona match the expected per-kind tally exactly (Gosha 7, Ivan 6, Katya 5, Luba 5; total 23). Defensive `_extract_agent_id` patch (2026-04-29) added a per-name cache + INFO logging — turned out to be defensive rather than load-bearing once the `GROUP BY agent_id` query confirmed the original code path was already producing correct UUIDs (the prior `20260428-3` audit was misleading because it joined on `dbl_agent.user_id`, which is the shared system-user UUID by design — distinct agents can share a `user_id`).

**Verification status (read side — partial):**
- Day-1 retrieval at sanity floor — ✅ 0/4 vote prompts surface a `keywords contains "survival"` memory (target ≤5%). Day-1 retrieval is *expected* to be empty: the Day-1 corpus is small and the focal points used by `_collect_vote_decisions` ("Who has betrayed me?", "Who is the biggest threat?") don't match alliance-themed content well at Day-1 vote time.
- Day-2 retrieval — ⏳ **untested**. Requires a sim that crosses the Day-2 voting gate (≈step 2 130). Conservative target: 2 400-step run (~13 hours wall-clock at 20 s/step) — overnight kick-off.
- Day-3+ retrieval — ⏳ untested for the same reason.

**Acceptance metric:** a `vote_decision` prompt "has survival memories" if its rendered retrieval set contains ≥1 node with `"survival"` in its keyword list. Day-1 ≤5% (sanity ✅), Day-2 ≥50%, Day-3+ ≥80%.

**Rollback:** revert Phase 2–4 commits; Phase 0 instrumentation is read-only logging and stays regardless.

**Deferred carryovers (now owned by Stage 4 follow-up, conditional on Day-2+ smoke results):**
- *Reflection-skip for survival-tagged memories* — conditional on Day-3+ smoke showing reflections collapsing into game-strategy monoculture.
- *Importance decay curve* (e.g., `effective_importance = base_poignancy * 0.9 ** days_since_creation`) — conditional on smoke showing Day-1 grudges crowding out fresh signal.

Both stay deferred until the Day-2+ smoke produces observable failure-mode evidence.

### ✅ Stage 4 — Conversation priors + reflection variant + alliance trigger  *(primary scope shipped 2026-04-28; over-firing fix shipped 2026-04-29)*

**Goal:** when survival agents converse, topics bend toward the game; nightly reflection bias toward survival framing; alliances verbally agreed in chat surface as memory.

**What shipped:**

- **Three new prompt templates** under `v2/`:
  - `survival_generate_conversation_batch_v1.txt` — chat variant with the Identity Overlay (one per speaker) and survival framing rules. *Spec deviation:* the spec named `survival_agent_chat_v1.txt`, but the live runtime uses `generate_conversation_batch_v1.txt` (single batched LLM call); the legacy per-turn `agent_chat` path is no longer wired. The variant lands on the path that actually runs.
  - `survival_summarize_conversation_v1.txt` — new lightweight post-chat prompt; returns single-line JSON `{"summary": "<topic>", "alliance_committed": <bool>}`. *Spec deviation:* the legacy `run_gpt_prompt_summarize_conversation` is dead code (no production callers); rather than resurrect it, this is a **new** Tier-A call gated on both speakers being in survival mode.
  - `survival_generate_focal_pt_v1.txt` — reflect focal-points variant. *Option A* (per implementation plan): only the focal-points step gets a survival variant; the downstream insight step inherits the framing automatically. Mundane source statements still produce ordinary questions.

- **Loader extended** (`loader.py::resolve_template`) to take an optional `secondary_persona`. Chat case requires both speakers flagged. Single-persona case (summarize, reflect, daily/hourly/task-decomp) unchanged.

- **Wiring:**
  - `run_gpt_prompt_generate_conversation_batch` routes through `resolve_template`; passes both personas; conditionally appends overlay slots when both flagged.
  - `run_gpt_prompt_focal_pt` routes through `resolve_template` (single persona).
  - New `run_gpt_prompt_survival_summarize_conversation(persona_a, persona_b, conversation)` — Tier A, registered in `model_router.TIER_A_TASKS`. Returns `((summary_str, alliance_bool), meta)`.

- **Alliance trigger end-to-end** (the one Stage-3 carryover that's not gated on smoke):
  - `"alliance_formed"` added to `survival/memory.py::VALID_KINDS`.
  - New `SurvivalController.record_alliance_from_chat(persona_a, persona_b, chat_history)` — runs the post-chat survival summarize call when both speakers are flagged; on `alliance_committed=True` it fires `tag_event(kind="alliance_formed")` for both speakers and writes to `SurvivalState.alliance_commitments`. Best-effort; failures log at WARNING and don't propagate.
  - Wired from `reverie.py` after `start_conversation` returns. Greeting-tier conversations bypass `start_conversation` and don't trigger the hook (alliances need real exchange).
  - **Same-day duplicate guard (added 2026-04-29):** `record_alliance_from_chat` now short-circuits before the summarize LLM call when both sides already record an alliance with each other for the current day. Surfaced from a `20260428-3` audit showing ~10× over-firing (40+ rows for 4 unique pairs); verified on `20260429-1` at 8 rows for 4 pairs (one per side, exactly).

- **Tests:** 19 unit tests in `tests/test_survival_stage4_5.py` (loader dual-persona dispatch ×4, alliance trigger end-to-end ×3 + same-day guard ×2 + new-day re-fire ×1 + VALID_KINDS check, archive-state round-trip ×2, `_clear_survival_mode` mechanics ×3, `_extract_agent_id` per-persona scoping ×3). 60 tests pass across Stage 3 + 4 + 5 suites combined.

**Cost envelope:**
- Per survival-pair conversation: chat variant adds ~150–250 tokens (Identity Overlay ×2) on the Tier-C batch call, plus one Tier-A summarize call (~80 max tokens). Net ~+7–9% across all LLM calls in a 4-agent survival sim — within the +12% Tier B/C envelope spec'd for Stage 4. Same-day guard cuts the alliance-summarize call rate to one per pair per day.

**Acceptance smoke (verified on `20260428-3` and `20260429-1`):** survival keywords in ≥50% of summarized conversations on Day≥2 (56% on `vote` alone across 300 convo prompts on `20260428-3`). 100% focal-pt selection rate. Alliance state populated bidirectionally — 8 mutual commitments on `20260428-3` (Day 2 alliances), 4 mutual pairs on `20260429-1` (Day 1 alliances — first sim with Day-1 alliances, suggesting chat framing is now sensitive enough to catch verbal commitments earlier in the game).

**Deferred (still gated on Day-2+ smoke evidence):**
- *Reflection-skip for survival-tagged memories.* If smoke shows reflections collapsing into game-strategy monoculture, exclude `keywords contains "survival"` from the importance pool feeding reflection.
- *Survival-memory importance decay curve.* If smoke shows Day-1 grudges crowding out Day-N+ retrievals, introduce a per-memory decay (e.g., `effective_importance = base_poignancy * 0.9 ** days_since_creation`).

**Rollback:** revert the Stage 4 commits; Stage 0–3 + Stage 5 unaffected. Each carryover lands as a separate commit when it ships.

### ✅ Stage 5 — Post-game decay + cleanup  *(shipped 2026-04-28, Option A — minimal archive)*

**Goal:** eliminated personas and end-of-season survivors gracefully exit the worldview without dropping memories or duplicating storage.

**What shipped:**

- **Helper `SurvivalController._clear_survival_mode(persona, archive_state=True)`** is the single source of truth for clearing the flag and marking the agent's state as archived. Behavior:
  1. Flips `persona.survival_mode = False`.
  2. If `archive_state=True`, stamps `state.archived = True` + `state.archived_at = <sim datetime>` and persists via the existing `state.save_to_supabase` path.
  3. Idempotent: a second call (e.g., a persona eliminated and then game-over) skips re-stamping.

- **SurvivalState fields** `archived: bool` and `archived_at: Optional[str]` round-trip through `__init__`, `to_dict`, `from_dict`. Storage uses the existing `survival_agent_state` row — no new table, no `survival/eliminated/<name>.json` file (per Option A — Supabase is SOT, no duplicate state).

- **Two inline clearings replaced** with helper calls:
  - `_execute_elimination` — clears AFTER `_broadcast_elimination` (so the final-statement LLM call still sees full survival context).
  - `_nightly_recalibration` (game-over branch) — clears every still-flagged persona.

- **Baseline-template fallback is automatic.** Once `survival_mode=False`, the prompt resolver picks baseline templates next morning with zero further logic — no fallback path needed.

- **Tests:** state field round-trip ×2; helper flips flag + archives ×1; helper respects `archive_state=False` ×1; idempotent on second call ×1. All passing.

**Acceptance:** zero survival-template prompt selections for eliminated personas after the next morning step. Verified mechanically through tests; observed at the next acceptance smoke.

**Rollback:** revert the helper + the two replaced clearings; previous behavior (inline `survival_mode = False` with no archive marker) is harmless because there is no further game logic for the eliminated persona.

### ✅ Stage 6 - fixes

#### *Fix 1 — _extract_agent_id per-persona scoping (P0)*

File: reverie/backend_server/persona/cognitive_modules/retrieve_double.py
Change: dropped the persona.agent_id early-return that was producing a single shared UUID across every persona. The function now always resolves via get_agent_id_by_name, with a process-wide cache keyed by persona name (so it stays cheap — one RPC per name per process) and INFO-level logging on first resolution. 
Why this works: the 20260428-3 audit showed all 50 survival rows landed under the same user_id, meaning the early-return branch was returning a stale/shared sentinel.   
Forcing every call through name-based RPC with a name-keyed cache guarantees distinct names → distinct UUIDs (or surfaces a broken RPC loud and clear via the new INFO log).

#### *Fix 2 — Alliance trigger over-firing (P1)*

File: reverie/backend_server/survival/controller.py

Change: record_alliance_from_chat now short-circuits before calling the summarize LLM when both sides already record an alliance with each other for current_day.
Collapses ~10× duplicates into 1 write per pair per day.


---

## 4. Identity Overlay schema (Stage 1)

Inserted into survival-aware prompt templates at the `!<INPUT identity_overlay>!` slot:

```
SURVIVAL CONTEXT (read first, this shapes everything you do today):
- You are {name}. Day {days_survived} of {total_days}.
- Eliminated so far: {names or "none"}.
- Today's challenge: {challenge_name} — {brief}.
- Hard deadlines: challenge by {challenge_deadline}, voting by {vote_deadline}.
- Gathering location: {gathering_location} (you must be there for both).
- Alliances: {alliance_summary or "none"}.
- Top threats (perceived): {top_3_threats or "none yet"}.
- Active rewards / immunity: {rewards_summary or "none"}.
- Reputation: {reputation_label}. Social capital: {social_capital_label}.
```

Numeric values rendered as labels ("low / medium / high") to keep the overlay LLM-friendly. Built once per step in `SurvivalController`, cached per persona for the day, regenerated after challenge resolution and voting.

---

## 5. SOT / PRD / Playbook revisions

| Doc | Section | Status |
|---|---|---|
| `sot_survival.md` | Overview (worldview framing) | Done 2026-04-16 |
| `sot_survival.md` | New Cognitive Integration section | Done 2026-04-16 |
| `sot_survival.md` | Conflicts bullet under Guardrails | Done 2026-04-16 |
| `prd_survival_mode.md` | §6.1 Morning, deprecation notes, post-game decay | This PR |
| `survival_playbook.md` | §1 thesis, §3 day loop, §4 Game Director, §9 architecture, §10 prompts | This PR |

---

## 6. Testing plan

- **Per-stage smoke:** 3 agents × 1 day with `SURVIVAL_MODE_ENABLED=true`, fresh fork.
- **Regression gate (every stage):** 3 agents × 1 day with `SURVIVAL_MODE_ENABLED=false`. Step JSON diff must be empty.
- **Stage 2 acceptance:** rerun the `20260415-5` config (5 agents from `base_family_sim`, 700 steps). Compare voting-phase outcomes day-over-day: spatial gate fires vs. deadline timeout.
- **End-to-end:** after Stage 5, full season smoke (5 agents × 5 days). Targets:
  - Spatial gate fires on ≥60% of voting phases
  - Survival memories appear in ≥80% of vote_decision prompts
  - Survival keywords in ≥50% of conversation summaries
  - Eliminated agents revert to baseline templates next morning
- **Unit tests:** `tests/test_survival_mode_flag.py`, `tests/test_identity_overlay.py`, `tests/test_template_resolver.py`, `tests/test_survival_memory_tagging.py`. All flag-gated; should pass in both modes.

---

## 7. Risks

- **Prompt cost:** survival variants add the Identity Overlay (~150-250 tokens) to every flagged prompt. Estimated +12% Tier B tokens per survival agent-day. Acceptable.
- **Variant drift:** survival templates can diverge from baseline over time. Mitigation: every survival template references the baseline as `# Source: <name>_v1.txt — keep I/O contract stable`.
- **Eliminated persona regression:** if `_clear_survival_mode` runs before final-statement generation, statement loses context. Mitigation: clear flag *after* final statement is produced (Stage 5 ordering test).
- **Hidden coupling to text injection:** other modules may rely on `daily_plan_req` containing the directive (e.g., logging, exports). Audit in Stage 2 PR description.

---

## 8. Open questions

1. Should the Identity Overlay surface to the FE for subtitle rendering? (Out of scope here; tracked separately under PRD §"Frontend subtitle overlay".)
2. Do we want Tier A "personality seeding" of survival traits (currently default 0.5) before this lands, or after? Recommendation: after — Stage 0–5 should not depend on it.
3. ~~Should `survival_mode` propagate through scratch serialization (Supabase) so a restart resumes correctly without recomputing?~~ ✅ **Resolved 2026-04-22:** `survival_season_state` + `survival_agent_state` tables + 5 RPCs shipped; `fork_simulation` copies both; `survival_mode` round-trips through scratch via `scratch.survival["mode"]`.

---

## 9. Sequencing summary

```
Stage 0 (flag + loader)                                     ✅ done 2026-04-16
   ↓
Stage 1 (daily plan variant + Identity Overlay)             ✅ done 2026-04-16
   ↓
Stage 2 (hourly + task decomp variants; remove band-aids)   ✅ done 2026-04-26
   ├─ 2d interim acceptance (4 agents × 900-step on 20260426-1)  ✅ done 2026-04-26
   ├─ 2d-followup challenge-side end-to-end                  deferred (needs ≥1 agent at gather zone before 11:00)
   └─ 2d-formal 5-agent × 5-day stress (20260415-5 config)   deferred
   ↓
Stage 3 (memory poignancy + attention bias)                 🟢 code complete 2026-04-27; write side fully verified 2026-04-29
   ├─ Fix 1 unique node_id                                   ✅ verified at runtime on 20260428-1
   ├─ Fix 2 deterministic simulation_id binding              ✅ verified at runtime on 20260428-3 + 20260429-1
   ├─ Per-persona agent_id scoping                           ✅ verified on 20260429-1 (4 distinct UUIDs, row counts match)
   ├─ Day-1 retrieval at sanity floor (≤5%)                  ✅ verified on 20260429-1 (0/4 = 0%)
   └─ Day-2+ acceptance smoke (≥50% / ≥80% gradient)         owed — needs ≥2 400-step run to cross Day-2 voting gate
   ↓
Stage 4 (conversation + reflect variants + alliance trigger) ✅ primary scope done 2026-04-28; over-firing fix 2026-04-29
   ├─ survival_generate_conversation_batch_v1 / summarize / focal_pt templates
   ├─ loader two-speaker dispatch (resolve_template secondary_persona)
   ├─ alliance_formed tag_event trigger end-to-end (post-chat survival summarize)
   ├─ same-day duplicate guard ✅ verified on 20260429-1 (8 rows for 4 pairs vs. ~40 on 20260428-3)
   ├─ reflection-skip for survival memories                  deferred (gated on Day-2+ smoke)
   └─ survival-memory importance decay curve                 deferred (gated on Day-2+ smoke)
   ↓
Stage 5 (post-game decay + cleanup)                         ✅ done 2026-04-28
   ├─ _clear_survival_mode helper (flip + archive marker, idempotent)
   ├─ SurvivalState.archived / archived_at fields (round-trip)
   └─ replaces inline clearings in _execute_elimination + game-over branch
```

Each stage ships behind the existing `SURVIVAL_MODE_ENABLED` flag. Non-survival runs are unaffected throughout.