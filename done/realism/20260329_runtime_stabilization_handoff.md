# 2026-03-29 Runtime Stabilization Handoff

## Status of this document

This document is a technical, detailed, handoff/troubleshooting-oriented view of the work preserved in branch `stabilization/20260329-simulation-runtime-hardening` at commit `ced1571`.

This copy lives in `double-docs` for shared review and handoff.

This file is intended to be the shared technical source of truth for this stabilization pass. It is written to be readable on its own by another engineer or by an AI, without assuming access to unpublished local artifacts. The canonical source of truth remains the complete backend repo dossier: `20260329-preclean-unified-dossier.md`.

It preserves the substantive technical history of:

- what problems existed
- what was investigated
- what was fixed
- which validations actually support the work
- which claims had to be corrected later
- what technical debt remained
- which troubleshooting tasks are still open

## Purpose

This handoff exists so that an AI or a new engineer can quickly answer these questions:

1. What was broken at the start of this stabilization pass?
2. What changed architecturally, and why?
3. Which improvements were real and defensible with evidence?
4. Which problems are still open?
5. Which parts of the system should be touched first if the work continues?
6. How should the system be run, validated, and diagnosed without losing historical context?

## Scope

This document covers the March 29, 2026 technical pass on branch:
- `stabilization/20260329-simulation-runtime-hardening`

Final preserved checkpoint:

- `ced1571`
- message: `Stabilize live movement authority and monitoring feedback`

Previous important checkpoint:
- `ba64421`
- message: `Checkpoint typed grounding and movement-origin investigation`

Most important runs and evidence in this pass:
- `20260329-25-local-live-deepseek-step0-log400-nosupabase`
- `20260329-28-local-live-deepseek-step0-log120-groundingfix-v3`
- `20260329-29-local-live-deepseek-step0-log120-originfix-v1`
- `20260329-30-local-live-deepseek-step0-log40-intentexport-v1`
- `20260329-42-local-live-deepseek-step0-log40-systemicfix-live-v2check`
- `20260329-43-local-live-deepseek-step0-log40-systemicfix-live-v3`
- `20260329-44-local-live-deepseek-step0-log40-systemicfix-live-v4`
- `20260329-53-local-live-deepseek-step0-log40-systemicfix-live-v13`

Intermediate runs used for isolation rather than final closing evidence:

- `-39`
- `-40`
- `-41`
- `-50`
- `-51`
- `-52`

## Executive summary

This stabilization pass was real backend stabilization work, not a cosmetic change. The system was coming from serious failures in spatial authority, semantic grounding, movement export, monitoring, and headless lifecycle. The pass did not finish the system, but it did move it from a clearly broken and hard-to-debug state into a partially stabilized, tested, and instrumented state.

What improved in a defensible way:

- stronger local object/occupancy authority inside zones
- reduction of visible short ping-pong behavior
- elimination of absurd grounding such as `door/lights -> refrigerator`
- reconciliation of `movement`, `environment`, and `monitoring` based on real FE feedback
- mitigation of `same_action_skip` traps and pathological stationary persistence
- improved headless lifecycle with explicit cleanup and lower process churn
- introduction of explicit, testable subsystems where previously there had been mixed logic that was hard to reason about

What did not get finished:

- the system never fully unified the source of truth for the final emitted tile
- complex override layers remained in the final part of movement
- the final `-53` run still showed a serious exclusivity bug: Katya and Gosha shared tile `[122,24]` in steps `34-38`
- DeepSeek embedding routing remained incomplete and still emitted `404`
- `reverie.py` remained an excessively large orchestrator overloaded with responsibilities

Honest conclusion:

- significant technical progress
- real visible improvements
- real architectural improvements
- still-high technical debt
- one serious residual bug still open at the end

## Independent comparative validation against `local`

A later technical audit, comparing `stabilization/20260329-simulation-runtime-hardening` against branch `local` as two separate snapshots of the system, confirmed something important:

- `stabilization/20260329-simulation-runtime-hardening` is better than `local`
- the difference is not marginal
- the improvement is not only visible behavior; it is also in how the system models grounding, occupancy, movement authority, observability, and headless runtime

The most defensible improvements relative to `local` are these:

- grounding stops depending so heavily on scattered heuristics and gains an explicit typed pipeline with intent, candidates, and unresolved reasons
- occupancy logic stops being buried inside `execute.py` and moves into its own module, making it more auditable and testable
- movement authority becomes more explicit by unifying the real movement origin better and avoiding already-claimed tiles more consistently
- intent-only export and semantic projection become more coherent, which explains part of the visible improvement between runs such as `-42` and `-53`
- `monitoring.actual_pos` stops drifting away from `movement_report` and `actual_placement` in the revalidated cases
- headless runtime moves to a more serious persistent-worker model with signal-based cleanup instead of a more fragile launch/drag cycle

That same audit also confirmed the real limits of the pass:

- the global architecture did not become simple or clean
- `plan.py` and `reverie.py` remained too large
- part of the new grounding became fairly dependent on the current map
- occupancy did not become fully hardened, as shown by the Katya/Gosha overlap in `-53`
- monitoring improved materially, but did not become semantically perfect in every field

The correct conclusion for using this document is:

- this stabilization branch was not “the perfect branch”
- but it was a meaningfully better technical base than `local` for this problem
- the improvements were real at the system level, not just cosmetic adjustments

## Original architecture of the problem

Before this stabilization pass, the system had an architecture with these structural problems:

### 1. Implicit and scattered spatial authority

The system did not have a simple, explicit contract to answer:

- what the semantic target was
- what the occupancy target was
- what the resolved tile for the step was
- what the final `planned_pos` was
- what the real `actual_pos` observed by the FE was

In practice, that authority was distributed among:
- `target_tile`
- `planned_path[-1]`
- `authoritative_target_tile`
- export prefixes
- `intent_hold`
- `occupancy_anchor_pending`
- FE feedback

That meant a run could look “more or less okay” and still contain internal contradictions between intent, path, and final position.

### 2. Fragile semantic grounding

There was too much dependence on strings, partial hints, and soft validations. This generated bugs like:
- `door/lights -> refrigerator`
- correct venues with absurd objects
- downgrade of useful objects into overly generic labels
- loss of semantic continuity between planner and executor

### 3. Occupancy logic mixed into execution

The decision of “which exact tile inside the arena this agent should end up on” was too mixed into the general movement logic. That prevented:

- testing occupancy in isolation
- reasoning cleanly about penalties for an already-occupied tile
- distinguishing arrival to the zone from settling on an object
- preserving local authority once inside the arena

### 4. Inconsistent observability

`movement/*.json`, `environment/*.json`, and `monitoring/step_*.json` could tell different stories about the same step. In particular:

- `actual_pos` could remain `null` or stale
- `environment/<step>.json` could fail to reflect real FE feedback
- `monitoring` could keep showing old positions even when `movement` had already been patched with real feedback

### 5. Runtime/headless operational debt

Local headless mode worked, but it had problems involving:

- dependence on Supabase for some spatial bootstrapping
- Playwright/Chromium process churn
- insufficient cleanup on interruptions
- difficulty trusting long runs because of operational noise

## Goals of this stabilization pass

The pass got reoriented several times as new evidence appeared, but it eventually pursued these stable goals:

1. fix freezes and stationary traps after reaching destination
2. fix absurd semantic grounding
3. give explicit authority to the local target/object inside the arena
4. reconcile observability with real FE feedback
5. make the system more testable
6. make local sims possible without depending so heavily on Supabase
7. reduce operational noise in headless runtime

## Main architectural changes

### 1. Typed grounding

Main file introduced:
- `reverie/backend_server/persona/cognitive_modules/spatial_grounding_typed.py`

What it added:

- explicit contracts such as `IntentSpec`
- typed grounding results such as `GroundingResult`
- candidates with richer semantics instead of loose strings
- more explicit bridges, hints, and contextual repairs

Problems it attacked:

- weak matches being accepted as valid
- loss of venue continuity
- generic labels beating useful hints
- the emblematic `door/lights -> refrigerator` case

Design value:

- grounding stops being a textual black box
- failures become classifiable
- the pipeline becomes much more testable

Limit:

- it coexisted with legacy flow in `plan.py`
- there was no full guarantee of parity between the two paths

### 2. Occupancy and local object authority

Main file introduced:
- `reverie/backend_server/persona/cognitive_modules/spatial_occupancy.py`

What it added:

- separate tile scoring
- explicit derivation of occupancy target address/tile
- readiness-to-settle separated from the rest of movement
- explicit policy for choosing where to remain inside an arena

Problems it attacked:

- freeze after reaching the area
- premature stationary mode
- reuse of the single already-claimed target
- loss of local target authority when entering the zone
- oscillation from rescoring generic arena candidates

Design value:

- for the first time there was an “occupancy” domain with its own identity
- this enabled isolated and more observable tests

Limit:

- it did not fully solve final tile exclusivity
- in `-53` there was still divergence between `selected_tile`, `resolved_step_target`, `path`, `planned_pos`, and `actual_pos`

### 3. Explicit export/replay contract

Main file introduced:
- `reverie/backend_server/replay_step_contract.py`

What it added:

- an explicit source of truth for deciding how to export paths across bootstrap, replay, and active contract

Problems it addressed:
- intent-only export clobbering execute prefixes
- mixing incompatible prefixes
- ambiguity between the initial snapshot and the active step

Design value:

- it moves a critical part of the system into a smaller, purer contract

Limit:

- `reverie.py` still retained too much logic around the edge of that contract

### 4. Reconciliation of monitoring and real FE feedback

Main focus:
- `location_monitor.py`
- `reverie.py`

What changed:

- `monitoring/step_*.json` started promoting reconciled `actual_pos` based on feedback
- `movement`, `environment`, and monitoring align better

Problems it addressed:
- `actual_pos=null`
- stale `environment/<step>.json`
- divergence between the planner narrative and real execution

Design value:

- strong improvement in postmortem reliability

### 5. Stronger local headless runtime

Relevant files:
- `reverie/backend_server/headless_visualization.py`
- `_build_headless_local_simulation_context(...)` in `reverie.py`

What changed:

- persistent worker with more explicit cleanup
- better collision-grid serialization for the local worker
- less need to depend on Supabase UUID-backed bootstrapping in local runs

Problems it attacked:

- process churn
- weak cleanup
- fragility in local-only mode

## Explicit operational bugs and evidence limits

This pass did not only fix semantic and movement bugs. It also attacked operational runtime problems. It is important to distinguish between:

- operational problems that were actually observed and preserved
- exact metrics that were not ultimately instrumented in the canonical source

### 1. Playwright/Chromium churn and 100% CPU

This was documented as a real problem.

Preserved symptoms:

- too many `Playwright/Chromium` processes
- `CPU at 100%`
- difficulty trusting long runs because there was worker/browser churn

Documented later state:

- the persistent worker reuses a single browser/service
- explicit `SIGINT`/`SIGTERM` cleanup was added, not just `atexit`
- the final `-53` run recorded only a single active Playwright/Chromium group
- after shutdown there were no relevant leftover processes

Correct reading:

- there really was a serious operational headless lifecycle problem
- there really was meaningful improvement during this stabilization pass
- what was preserved is qualitative and end-state evidence, not a full historical time series of PIDs by step

### 2. Step 0 as an operational hotspot

There is also evidence that `step 0` was a particularly sensitive point in the system:

- the `startup_step0_typed_grounding_v1` resolution is visible in movement/monitoring for the final run
- several hypotheses and fixes in the pass concentrated on bootstrap, startup bridge, and initial grounding
- a meaningful part of the work went into stabilizing this first section of the pipeline

But there is an important limitation:

- the preserved canonical source does not contain a reliable per-step latency metric
- so it should not be stated as exact fact that `step 0 took 10 minutes` unless an additional log with concrete timestamps appears

### 3. Exact LLM call count

The evidence limit is even clearer here.

What we do know:

- there was real routing/model/provider debt in live runs
- there were replay problems caused by `prompt_hash` drift
- there were embedding `404`s in DeepSeek-compatible runs

What was not preserved as hard fact:

- a canonical per-step counter of how many LLM calls were made
- a stable breakdown such as “step 0 had 50 calls”

Important fact:

- in the preserved final `-53` run artifacts, the `llm_logs` family appears with `present.count = 0`
- that means the preserved final run did not leave per-step LLM logs that would allow an exact count to be reconstructed later

Operational conclusion:

- it is valid to say there was LLM-side operational noise/cost and bootstrap overhead
- it is not valid to fix an exact number of calls in the handoff without an additional source

### 4. Embeddings 404

This issue was clearly preserved:

- live runs using the OpenAI-compatible surface over DeepSeek still showed `404` when requesting embeddings

That implies:

- the system could still keep running thanks to existing fallbacks
- but provider-specific routing remained incomplete
- the problem is operational and architectural, not just cosmetic

### 5. What needed better instrumentation

The canonical source preserves behavior bugs and several operational bugs well, but it did not leave sufficiently fine-grained metrics for some numerical claims.

What was missing from canonical preservation:

- real per-step latency
- per-step and per-persona LLM call counts
- detailed headless process lifecycle per step
- direct correlation between step, LLM calls, and CPU saturation

That is why this handoff should be explicit in the following way:

- yes, there was CPU saturation and headless churn
- yes, there were real bootstrap/runtime problems
- yes, there were embedding errors
- no, the canonical evidence does not preserve exact numbers such as `50 calls` or `10 minutes` per step

## Condensed technical chronology

The pass was not linear. Several hypotheses appeared correct and were later invalidated by new runs. That history matters because it explains why the system ended with real improvements but also accumulated debt.

### Phase 1: confirmation that the problem was not only FE

Early evidence showed:

- visible freezes in Ivan and Katya
- real short-step oscillation in Gosha
- contradictions between movement and monitoring
- FE without strong signs of real blocking in several cases

This moved the focus toward backend/planner/runtime/export rather than a frontend fix.

### Phase 2: typed grounding and semantic authority

The typed pipeline was introduced and several absurd grounding cases were fixed. This improved:

- Luba in cafe-related actions
- Gosha in the library
- venue continuity
- rejection of weak matches

### Phase 3: occupancy and local source of truth

The occupancy module was created so the system could answer more cleanly:

- “which specific tile should this agent occupy”
- “when is the agent ready to settle”
- “when should the agent stop chasing a tile that is already taken”

### Phase 4: `same_action_skip` and stationary traps

It was discovered that some agents were getting frozen because:

- the action had already expired
- but `same_action_skip` was still protecting persistence
- and the stall breaker could still consider a pathological state “healthy”

This particularly affected:
- Ivan
- Katya

Symptom:

- the system preserved a stationary continuation even when the action had expired or was no longer healthy

Status:

- corrected to a significant extent
- covered by tests
- but still a delicate area of the system because of the number of branches and overrides

### Phase 5: intent-only export and loss of valid prefixes

It was confirmed that there were steps where the final export destroyed or replaced a valid prefix coming from `execute()`. That generated:

- incorrect planned positions
- apparent immobility
- contradiction between the selected target and the emitted path

### Phase 6: reconciliation of monitoring and real runtime

The `actual_pos` backfill was fixed so that monitoring reflected real execution rather than preserving stale planner state.

### Phase 7: live fixes on `-42` and partial close in `-53`

A real visible improvement was achieved:

- Luba stops the initial short ping-pong and reaches `behind the cafe counter`
- Gosha stops the sustained short alternation in the library
- `door/lights -> refrigerator` disappears
- monitoring and movement become reconciled
- headless churn drops

But a serious residual issue appears:

- Katya and Gosha end up sharing `[122,24]` in `steps 34-38`

## Problems found, by severity

### How to read the problem list

The issues listed below are not all of the same type.

They include:

- pre-existing baseline problems already present in `local`
- root causes identified during the stabilization pass
- and secondary regressions or contract mismatches that became visible only after parts of the new architecture were introduced

This distinction matters. The pass did not simply “create new bugs.” In many cases, it exposed, isolated, or reclassified failures that already existed in a more implicit form.

### Critical

#### 1. Personas sharing the same physical tile

Residual case confirmed in `-53`:

- Katya and Gosha shared `[122,24]` in `steps 34-38`

Why it matters:

- it breaks the physical exclusivity of the world
- it invalidates part of the final authority of the movement contract
- it proves that the final chain `selected_tile -> resolved_step_target -> path -> planned_pos -> actual_pos` did not fully close

Status:

- not fixed by the end of the pass

#### 2. Stationary traps through `same_action_skip`

Most notorious cases:
- Ivan
- Katya

Symptom:

- the system preserved a stationary continuation even when the action had expired or was no longer healthy

Status:

- corrected to a significant extent
- covered by tests
- but still a delicate area of the system because of the number of branches and overrides

### High

#### 3. Absurd semantic grounding

Emblematic case:
- `unlocking the cafe door and turning on the lights`

- resolved incorrectly to `refrigerator`

Impact:

- this was not just an ugly label; it altered movement, export, and diagnosis

Status:

- fixed in the final live run `-53`
- residual limitation: the map does not contain explicit usable `door/light/open-sign` objects, so the final fallback is a coherent local cafe target, not a literal door

#### 4. Loss of local authority when entering the arena

Visible cases:
- Luba
- Gosha

Symptom:

- the general semantic target remained stable
- but once inside the arena the system fell back to roaming/generic area candidates
- that produced short ping-pong and unrealistic movement

Status:

- materially improved in `-53`
- not fully finished in the general system

#### 5. Divergence between movement and monitoring

Symptom:

- movement showed a realistic position
- monitoring still showed old positions or `null`

Status:

- fixed for the revalidated cases
- covered by specific tests

### Medium

#### 6. Claimed singleton occupancy target reuse

Case:

- a single semantic target could already be claimed
- the system would still end up returning to that tile

Impact:

- pursuit of occupied tiles
- unrealistic behavior degradation

Status:

- fixed in the intermediate policy
- but final exclusivity still did not fully close by the end of the pass

#### 7. Export projection overwriting an explicit occupancy target

Typical case:

- the planner was still pointing to `behind the cafe counter`
- the export could derive `occupancy_target_label` into a current object such as `kitchen sink`

Status:

- fixed

#### 8. Headless/browser churn

Symptom:

- too many Playwright/Chromium processes
- CPU at 100%
- difficulty trusting long runs

Status:

- improved
- cleanup is stronger
- a single persistent group remained during the final run

### Lower but still relevant

#### 9. Replay as imperfect truth

Problem:

- once the backend genuinely improves, the old cassette stops being end-to-end truth

Status:

- this became understood and documented
- replay is useful for locating divergence, not by itself for proving complete final correctness

#### 10. Telemetry richer than linear

Residual symptom:

- in some stationary steps, the internal trace can still show exploratory `selected_tile` or `resolved_step_target` different from `planned_pos`

Status:

- this does not break movement or monitoring in the validated cases
- but it complicates automatic reading if the reader does not know which field is more trustworthy

## What was actually fixed

### A. Luba stops short ping-pong in the cafe

Problematic `-42` baseline:

- repeated `76,22 <-> 77,19` in the early window

`-53` result:

- step `14`: reaches `[81,19]`
- steps `15-16`: remains settled there

Interpretation:

- the local target is preserved better
- the final export stops breaking the definitive short path

### B. Gosha stops sustained short alternation in the library

Problematic `-42` baseline:

- alternation `120,27 <-> 122,27`

`-53` result:

- the sustained alternation disappears
- early movement stabilizes more quickly

### C. Luba no longer resolves `door/lights` to `refrigerator`

In `-53` step `25`:

- intent: `unlocking the cafe door and turning on the lights`
- final fallback: coherent local cafe target
- it no longer falls into `refrigerator`

### D. Monitoring and movement become reconciled

In `-53`:

- `monitoring/step_20.json`
- `monitoring/step_25.json`

The fields:
- `actual_pos`
- `movement_report.actual_pos`
- `actual_placement.coordinates`

become aligned for the revalidated cases.

### E. Headless cleanup improves

In the final run:

- a single Playwright/Chromium group
- no visible orphan processes at shutdown

## What was not fixed or remained ambiguous

### 1. Final tile exclusivity

This is the most important open bug. Occupancy architecture improved, but the system did not guarantee final exclusivity by the end of the pass.

This means any claim of “movement fully fixed” should be treated as too optimistic.

### 2. Final source of truth for movement

It got better, but not completely unified. Correct runtime reading still requires understanding several fields:
- `selected_tile`
- `resolved_step_target`
- `path`
- `planned_pos`
- `actual_pos`

### 3. Incomplete architectural cleanup

Even though good subsystems emerged, orchestration remained too concentrated in `reverie.py`.

### 4. Partial dependence on defaults and flags

Part of the correct behavior depended on flags/context being set properly. That makes the system sensitive to the environment if it is moved between branches or shells without care.

### 5. Structural comparison: better base, not a clean base

Compared with `local`, the correct reading is not “this branch became tidy,” but rather:

- the stabilization branch became stronger in contracts, source-of-truth, and traceability
- `local` became simpler on the surface, but weaker for this specific domain

In other words:

- `local` may appear lighter
- the stabilization branch is heavier
- but for movement realism, typed grounding, occupancy, and serious debugging, the stabilization branch left a clearly stronger base

## LLM, DeepSeek, replay, and Supabase configuration

## DeepSeek

In this stabilization branch, provider routing was resolved from:
- `LLM_PROVIDER`
- or fallback from `OPENAI_BASE_URL`

If the base URL contained `deepseek`, the provider resolved as:
- `deepseek`

Documented defaults:
- API style: `chat_completions`
- tier A: `deepseek-chat`
- tier B: `deepseek-chat`
- tier C: `deepseek-chat`
- embedding model default still: `text-embedding-3-small`

Important implication:

- live DeepSeek runs used an OpenAI-compatible surface
- but embedding routing was not fully adapted to the real provider

Explicit residual issue:

- live runs with DeepSeek-compatible routing still showed `404` when requesting embeddings

Impact:

- it did not necessarily abort the simulation
- but it left clear technical debt in provider-specific routing

## Replay

`scripts/replay/launch_replay_smoke.py` sets:
- `LLM_REPLAY_MODE=true`
- `LLM_CASSETTE_PATH=...`

It can also infer flags such as:
- `TASK_DECOMP_CONTEXTUAL_ENABLED=true`

Important operating rule:

- replay is useful for isolating divergences and reproducing bugs
- replay is not a complete final proof once the backend has changed the real graph of LLM calls

## Supabase and local-only mode

What became clarified:

- the backend still contained Supabase bootstrap/SOT paths
- but `BACKEND_LOCAL_ONLY` and `_build_headless_local_simulation_context(...)` strengthened local runs without depending so heavily on Supabase

Correct interpretation:

- this stabilization branch did not remove Supabase from the system
- it did improve the ability to validate movement locally without going through the full external dependency

## LLM calls: what is known and what is not

What did become clear:

- the pass changed the LLM call graph enough to invalidate strict replay against old cassettes
- `task_decomp_contextual` and optional social blocks affected replay divergence
- the typed pipeline and planner fixes changed the legitimate prompt sequence

What did not close as a separate line item:

- a systematic and quantified reduction of “unnecessary LLM calls”

The correct conclusion is:

- there were changes that modified how the backend calls the LLM
- there were robustness improvements and less need to depend on Supabase for local validation
- but the March 29 work did not leave a definitive quantitative audit of cost per call or global prompt minimization

## Tests added or extended

Main families:
- `tests/replay/test_spatial_occupancy_policy.py`
- `tests/replay/test_stall_breaker_policy.py`
- `tests/replay/test_location_monitor.py`
- `tests/replay/test_headless_readiness_contract.py`
- `tests/replay/test_llm_replay_utils.py`
- `tests/test_reverie_intent_only_export_regressions.py`
- `tests/test_spatial_grounding_regressions.py`
- `tests/test_spatial_grounding_typed_pipeline.py`

Covered invariants:

- workstation hop must not collapse to stationary
- absurd or weak grounding must be rejected or remapped correctly
- meaningful semantic hints must rank above absurd matches
- incompatible or non-walkable intent-only prefixes must not be exported
- expired `same_action_skip` must not preserve unhealthy stationary behavior
- a claimed singleton occupancy target must not be reused
- an explicit occupancy target must survive export projection
- monitoring backfill must promote reconciled positions into `actual_pos`
- headless signal handlers must clean up the persistent worker

Documented milestones:

- typed grounding pipeline: `32` and later `38` tests passing
- occupancy policy: `33` and later `35` tests passing
- spatial grounding regressions: `72 passed, 14 skipped`
- advanced focused suite: `185 passed, 14 skipped`
- related replay/stall suites: `40 passed`

Later comparative validation on the preserved snapshot:

- an independent audit reran the focused suites on the preserved branch and reported `191 passed, 15 skipped`

Correct interpretation:

- that later figure does not replace the earlier historical milestones
- it serves as additional confirmation that the preserved branch still sustained strong coverage and was not just a set of unsupported changes

Practical note:

- several tests used `OPENAI_API_KEY=test-key` only to satisfy import-time env requirements
- some replay tests required extra care with `import-mode`

## Consolidated technical debt

### Architectural debt

- `reverie.py` as an orchestration monolith
- too many responsibilities in the same file:
  - planner orchestration
  - executor handoff
  - export
  - monitoring
  - replay gating
  - artifact index
  - headless runtime
  - feedback reconciliation
- coexistence of legacy and typed grounding
- duplicated helpers across modules

### Domain-model debt

- too much venue-specific logic pushed into `scratch.py`
- domain knowledge that should live in grounding/occupancy appears inside memory state

### Operational debt

- artifact index in the hot path with extra I/O
- replay dependent on fragile environment/import assumptions
- DeepSeek embeddings only half-migrated

### Movement debt still open

- final tile exclusivity unresolved
- there are still combinations where these diverge:
  - `selected_tile`
  - `resolved_step_target`
  - `path`
  - `planned_pos`
  - `actual_pos`

### Simplification debt still pending

- the pass improved architecture by extracting subsystems, but it did not complete a global simplification
- the system was left in a better-instrumented and more defensible state, but still with overlapping compatibility layers, overrides, and historical logic
- that means the next correct phase is not “reinvent the fixes,” but rather consolidate the source of truth and reduce accidental complexity without losing the contracts that did work

## How to read the state of the system if work resumes tomorrow

Recommended order:

1. read this handoff
2. review `past-sims-reports/20260329-1/20260329-1_report.md`
3. review `realism/6.llm+contract.md`
4. compare the branch directions before deciding what to keep from each
5. validate the residual issues in a fresh live run
6. only then decide whether to continue from `stabilization/20260329-simulation-runtime-hardening` or port selected pieces into another branch

## Priority artifacts to review

The references below are intentionally limited to artifacts that live in `double-docs` and are shareable from this repo.

### Main handoff

- `realism/20260329_runtime_stabilization_handoff.md`

### Parallel line of work and RCA

- `realism/6.llm+contract.md`

### Run reports available in this docs repo

- `past-sims-reports/20260329-1/20260329-1_report.md`
- `past-sims-reports/20260328-1/20260328-1_report.md`
- `past-sims-reports/20260327-2/20260327-2_report.md`
- `past-sims-reports/20260327-1/20260327-1_report.md`

## Troubleshooting Guide

### If the observed problem is “the agent reaches the place and freezes”

Review first:

Check first:
- stationary persistence
- `same_action_skip`
- `movement_mode_source`
- `settle_in_zone`
- `occupancy_anchor_pending`
- `intent_hold`

Most relevant tests:

- `tests/replay/test_stall_breaker_policy.py`
- `tests/replay/test_spatial_occupancy_policy.py`

### If the observed problem is “the agent bounces across two or three tiles”

Review first:

- local authority/occupancy inside the arena
- `selected_tile`
- `resolved_step_target`
- exported prefixes
- whether the final export is pushing the agent away from a nearby stable target

Most relevant tests:
- `tests/replay/test_spatial_occupancy_policy.py`
- `tests/test_reverie_intent_only_export_regressions.py`

### If the observed problem is “absurd grounding”

Review first:

Check first:
- `spatial_grounding_typed.py`
- venue hints/bridges
- compatibility between semantic intent and final object

Most relevant tests:
- `tests/test_spatial_grounding_typed_pipeline.py`
- `tests/test_spatial_grounding_regressions.py`

### If the observed problem is “movement and monitoring do not match”

Review first:

Check first:
- `location_monitor.py`
- feedback-based reconciliation
- promotion of `actual_pos`
- whether the run was a real live run or replay

Most relevant tests:
- `tests/replay/test_location_monitor.py`

### If the observed problem is “CPU at 100% / too many browsers”

Review first:

- headless worker lifecycle
- `SIGINT`/`SIGTERM` cleanup
- whether there is more than one simultaneous Playwright/Chromium group
- whether an old `reverie.py` process was left alive

Most relevant tests:
- `tests/replay/test_headless_readiness_contract.py`

### If the observed problem is “replay does not validate the fix”

Correct interpretation:

- this can be expected if the fix genuinely changed the backend call graph
- do not automatically assume the fix is false
- compare against the live run and against tested invariants

Most relevant tests:
- `tests/replay/test_llm_replay_utils.py`

## Operational recommendation for continuing the work

If the work resumes, the correct order is not “keep adding quick fixes.” The correct order is:

1. take `stabilization/20260329-simulation-runtime-hardening` as the reference base if the target is still this simulation system
2. preserve `spatial_grounding_typed.py`, `spatial_occupancy.py`, `replay_step_contract.py`, location-monitor fixes, and headless lifecycle improvements
3. attack final tile exclusivity first
4. then clean up the source of truth for final movement
5. only after that tackle `reverie.py` simplification/cleanup

If the decision is to compare bases before continuing:

- use `stabilization/20260329-simulation-runtime-hardening` as the technical reference superior to `local`
- do not assume the current `local` is “healthier” simply because it has less code
- evaluate any port or cleanup starting from contracts and invariants, not only LOC reduction

## Recommendation for external communication or AI handoff

The correct way to describe this pass is not:

- “everything was fixed”

The correct description is:

- a strong backend stabilization pass was completed
- new subsystems and real tests were introduced
- several severe and visible bugs were resolved
- a serious residual tile-exclusivity bug remained
- strong technical debt remained in the orchestration layer and in final movement emission

## Final conclusion

This stabilization pass genuinely improved the system base. It was not just superficial debugging, and not just prompt tuning. It introduced new architecture where there had previously been implicit logic that was hard to test. It also left real evidence of improvements in live runs. But it did not close the last mile of the system.

The correct reading for a future agent or engineer is:

- trust that there was real technical progress
- use this handoff as the operational map
- do not ignore the residual physical exclusivity bug
- do not represent the system as “finished” until that part is resolved

## 2026-03-30 Comparative Validation and Revised Integration Plan

### Context

On March 30 2026, after Ivan fixed LLM output for proper action-location matching (documented in `realism/6.llm+contract.md`), Nicolas's branch was pulled and tested with a live simulation run (`20260330-3`). The run was compared against Ivan's working simulation (`20260330-1`, branch `local`).

The bootstrap crash (perceive.py `NoneType` on `s.split(':')`) was fixed by aligning `_bootstrap_missing_fork_from_supabase()` with the `local` branch — removing `act_address`, `act_description`, `act_start_time`, `act_duration` from the Supabase scratch query and bootstrap scratch.json. Nicolas's bootstrap wrote `act_address` (non-None from Supabase) without writing the corresponding `act_event` tuple, causing `get_curr_event_and_desc()` to return `(None, None, None, None)` instead of `(self.name, None, None, None)`.

### Comparative results: 20260330-1 (local) vs 20260330-3 (stabilization branch)

| Metric | 20260330-1 (`local`) | 20260330-3 (stabilization) | Assessment |
|---|---|---|---|
| Steps / duration | 190 steps / 3h10m | 75 steps / 1h14m | — |
| Location errors | 1 / 760 actions (0.13%) | 0 explicit, but 19 `destination_unresolved` | **Regression** |
| Fictional anchor triggers | 0 | Not measured | — |
| Anchor correction triggers | 0 | Not measured | — |
| LLM location resolution | 493 `llm_location_v1` (64.9%) | Unknown — Ivan's 19 unresolved steps indicate failures | **Regression** |
| Conversations | 7 (Katya-Gosha x6, Katya-Luba x1) | 0 | **Severe regression** |
| Ivan activity range | sleep → shower → snack → email → run → cool down (65 positions) | sleep → check phone, bounce bug (28 tiles) | **Regression** |
| Katya activity range | dorm → library → Hobbs Cafe (27 positions) | dorm → library, stuck on gift list | **Regression** |
| Gosha decomposition | review → practice → check answers | review → practice → check answers | Neutral |
| Movement pipeline integrity | 49 `outside_zone` fallbacks | 0 fallbacks, perfect path continuity | **Improved** |
| Tile bounce / oscillation | None | Ivan steps 68-74 ping-pong | **Regression** |
| Position continuity | Good | Perfect | **Improved** |
| Overall realism score | Not formally scored, but strong | 4.7/10 | — |

Full reports:
- `environment/frontend_server/storage/20260330-1/20260330-1_report.md`
- `environment/frontend_server/storage/20260330-3/20260330-3_report.md`

### Revised assessment of branch relationship

The earlier section "Independent comparative validation against `local`" concluded that the stabilization branch was "better than `local`" and "not marginal." That assessment evaluated architectural qualities (typed grounding contracts, occupancy separation, observability) but did not include a comparative live simulation run with realism metrics.

The 20260330 comparative run reveals that the stabilization branch's **movement pipeline** is indeed stronger, but its **planning layer** has severely regressed:

1. **LLM location resolution regressed.** Ivan's `local` branch had zero fictional anchors, zero corrections needed, 64.9% clean `llm_location_v1` resolution. The stabilization branch produced 19 `destination_unresolved` events — the LLM anchor/location pipeline from `realism/6.llm+contract.md` (filtered tree, anchor validation, action-location contract) was not preserved in Nicolas's 6,337-line rewrite of `plan.py`.

2. **Social interactions regressed completely.** Two siblings sat 3 tiles apart for 64 minutes with zero interaction. The `local` branch produced 7 conversations in the same scenario.

3. **Activity variety and schedule quality regressed.** Ivan's rich daily arc (sleep → shower → run → cool down) collapsed to sleep → check phone with a bounce bug.

The correct revised reading is:

- The stabilization branch is architecturally superior for movement, occupancy, and observability
- The `local` branch is functionally superior for LLM planning, location resolution, and social behavior
- **Neither branch is the correct base alone** — the correct path is to integrate Nicolas's movement-layer wins into the working `local` branch

### Correction to operational recommendation

The earlier section "Operational recommendation for continuing the work" stated:

> take `stabilization/20260329-simulation-runtime-hardening` as the reference base

This is revised to:

> Take `local` branch as the working base (proven LLM pipeline), and cherry-pick Nicolas's movement/spatial/observability improvements into it.

---

## TODO: Integration Plan

### Guiding principle

Build on top of the working `local` branch. Port Nicolas's architectural improvements as additive modules. Do NOT port his `plan.py` rewrite — it overwrites the LLM location fixes that took the error rate from ~12 errors to 0.13%.

### Priority 1: Port movement-layer modules (no planning changes)

These are standalone modules that can be added to the `local` branch without touching the LLM pipeline:

#### 1A. `spatial_occupancy.py` — occupancy and local object authority

- **Source:** `reverie/backend_server/persona/cognitive_modules/spatial_occupancy.py` (new file, 567 lines)
- **Value:** Separates tile scoring, occupancy target derivation, and settle-readiness from general movement logic. Enables testing occupancy in isolation. Addresses freeze-after-arrival and premature stationary mode.
- **Integration:** Add as new module. Wire into `execute.py` where occupancy decisions are currently inline. Preserve existing `execute.py` LLM-facing interfaces.
- **Tests to port:** `tests/replay/test_spatial_occupancy_policy.py` (35 tests)

#### 1B. `replay_step_contract.py` — explicit export/replay contract

- **Source:** `reverie/backend_server/replay_step_contract.py` (new file, 69 lines)
- **Value:** Explicit source of truth for path export across bootstrap, replay, and active contract. Prevents intent-only export from clobbering execute prefixes.
- **Integration:** Add as new module. Wire into `reverie.py` export section.
- **Tests to port:** `tests/test_reverie_intent_only_export_regressions.py`

#### 1C. `cap_step_to_path_prefix` in `utils.py`

- **Source:** `reverie/backend_server/utils.py` (84-line diff)
- **Value:** Replaces the Euclidean distance cap with proper path-prefix clamping. Prevents synthetic straight-line tiles.
- **Integration:** Already partially present via `persona.py` diff. Port the utility function and update `persona.py:move()`.

#### 1D. Location monitor reconciliation

- **Source:** Changes in `persona/cognitive_modules/location_monitor.py` (445-line diff)
- **Value:** `actual_pos` backfill from FE feedback. Monitoring aligns with real movement.
- **Integration:** Port the reconciliation logic. Keep existing monitor interfaces.
- **Tests to port:** `tests/replay/test_location_monitor.py`

### Priority 2: Port observability and runtime improvements

#### 2A. Headless lifecycle hardening

- **Source:** `reverie/backend_server/headless_visualization.py` (1118-line diff)
- **Value:** Persistent worker model, SIGINT/SIGTERM cleanup, reduced Playwright/Chromium churn, CPU saturation fix.
- **Integration:** This is largely self-contained. Port the persistent worker and cleanup improvements.
- **Tests to port:** `tests/replay/test_headless_readiness_contract.py`

#### 2B. Monitoring step JSON improvements

- **Source:** Monitoring-related changes in `reverie.py`
- **Value:** `monitoring/step_*.json` promotes reconciled `actual_pos`. Movement, environment, and monitoring align.
- **Integration:** Port the monitoring write sections from `reverie.py`. These are separable from the planning changes.

### Priority 3: Evaluate and selectively port grounding improvements

#### 3A. `spatial_grounding_typed.py` — typed grounding pipeline

- **Source:** `reverie/backend_server/persona/cognitive_modules/spatial_grounding_typed.py` (new file, 684 lines)
- **Value:** Typed contracts (`IntentSpec`, `GroundingResult`), explicit candidate ranking, rejection of weak/absurd matches. Addresses `door/lights → refrigerator` class of bugs.
- **Integration:** **Evaluate carefully before porting.** The `local` branch's LLM anchor pipeline (filtered tree + anchor validation + action-location contract) already achieves 0 fictional anchors and 0.13% error rate. Nicolas's typed grounding may be complementary (better post-LLM validation) or redundant. Port only if it adds value without disrupting the working LLM pipeline.
- **Tests to port:** `tests/test_spatial_grounding_typed_pipeline.py` (38 tests), `tests/test_spatial_grounding_regressions.py` (72 tests)
- **Risk:** This module coexisted with legacy flow in Nicolas's `plan.py` without full parity guarantees. Integration into the `local` branch's `plan.py` requires careful mapping.

### Priority 4: Address open bugs from both branches

#### 4A. Tile exclusivity (from Nicolas's branch)

- Nicolas's most important unfixed bug: Katya and Gosha shared tile `[122,24]` in steps 34-38
- The `spatial_occupancy.py` module (Priority 1A) is the foundation for fixing this
- After porting, implement the final exclusivity guarantee

#### 4B. Transit stranding / distance-blind contracts (from `local` branch)

- 49 `outside_zone` fallbacks in 20260330-1
- Personas assigned to distant locations can't arrive within contract duration
- Requires coordinate math in the planning layer, not LLM changes
- Reference: `realism/6.llm+contract.md` section 5I

#### 4C. Social interaction tuning

- Both branches underperform on conversations (7 in `local`, 0 in stabilization)
- `P2_ROUTINE_SKIP_REACTION_EVAL` may over-suppress family/proximity conversations
- Review reaction evaluation thresholds for family members in close proximity

#### 4D. Activity variety and transitional behaviors

- Both branches show monotonous single-activity blocks (Luba: 190 steps at desk)
- Neither branch generates transitional micro-behaviors (stretching, bathroom, water)
- This is a planning-layer enhancement, not a movement fix

### Do NOT port

| Component | Reason |
|---|---|
| Nicolas's `plan.py` rewrite (6,337 lines changed) | Overwrites the LLM location fixes (filtered anchor tree, anchor validation, action-location contract). These fixes reduced location errors from ~12 to 1 in 760 actions. |
| Nicolas's `execute.py` rewrite (674 lines changed) | Tightly coupled to his `plan.py` changes. Port occupancy logic separately via `spatial_occupancy.py`. |
| Nicolas's `scratch.py` startup bootstrap additions (969 lines) | Contains `_STARTUP_BOOTSTRAP_TRAVEL_KEYWORDS`, destination pattern matching, and complex startup origin payloads. The `local` branch handles startup without this machinery. Port only `action_contract_v1` projection if needed. |
| `BACKEND_LOCAL_ONLY` mode | The `local` branch's Supabase integration is proven and works. Local-only mode was a debugging aid for Nicolas's branch, not a production feature. |

### Verification protocol

After each priority block is ported:

1. Fork a new simulation from `base_family_sim` baseline
2. Run at least 100 steps (covers ~1h40m of sim time)
3. Compare against 20260330-1 metrics:
   - Location errors must remain ≤ 1 per 760 actions
   - `destination_unresolved` must be 0
   - Conversations must occur (target: ≥ 5 in 100 steps with co-located personas)
   - No tile bounce / oscillation bugs
   - Position continuity must remain perfect
4. Run `tests/analyze_sim_realism.py <sim_code>` for automated metrics
5. If any regression is detected, revert the ported change and investigate before re-attempting

---

## Document status

This file is intended to be self-contained for shared review in `double-docs`.

If this handoff needs to evolve, it should be updated directly here alongside the relevant reports that are already present in this repo.

If inconsistencies appear between this handoff and older reports, the right next step is to reconcile them explicitly in this document rather than relying on unpublished local notes.
