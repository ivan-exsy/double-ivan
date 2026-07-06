## **Research Request: FE/Headless Movement Realism Failure After 20260308-4**

<ref. sim analysis - "D:\Coding\double-docs\realism-runs\20260308-4">

### Objective
We need a fresh end-to-end investigation of the frontend/headless movement pipeline.

The latest proof run, `20260308-4`, failed to validate our previous RCA and fix direction. We need to determine:

1. whether our earlier root-cause analysis was incomplete or wrong,
2. whether the intended FE fix was not actually active in the runtime path used by the simulation,
3. or whether another upstream/downstream layer is still collapsing backend movement intent before FE path execution.

### Expected Behavior
For a non-stationary backend step:

- backend emits a meaningful next-step target,
- FE/headless should path toward that target for the current step,
- FE should report actual end-of-step movement truthfully,
- backend should use that actual end-of-step position for the next step.

If FE cannot execute the move, it should report an explicitly degraded or blocked-style outcome, not silently return a same-tile no-op as non-blocked success.

### Observed Behavior
In `20260308-4`, realism and naturalness are still poor.

From `double-docs/realism-runs/20260308-4/analyze-api.md`:
- `Movement issues: 194`
- `DUPLICATE_DATA=169`
- `REACHABILITY_OVERRIDE=22`
- `LONG_STATIONARY_STREAK=4`
- `EXCESS_JITTER=4`

Movement rhythm remains unacceptable:
- `Gosha Pistsov`: moving `5`, stationary `40`
- `Ivan Pistsov`: moving `1`, stationary `44`
- `Katya Pistsova`: moving `1`, stationary `44`
- `Luba Pistsova`: moving `0`, stationary `45`

This is not high realism.

### Most Important Failure Signature
The same FE/headless failure pattern is still present:

- backend emits real non-stationary movement,
- FE raw report returns:
  - unchanged `actual_pos`
  - `actual_path=[[same_tile]]`
  - `blocked=false`

Concrete example from `20260308-4`:

- `Ivan Pistsov`, step `1`
  - backend emit:
    - `start_pos=[131,53]`
    - `planned_pos=[130,51]`
    - `movement=[130,51]`
    - `stationary_emission=false`
  - raw FE report:
    - `actual_pos=[131,53]`
    - `actual_path=[[131,53]]`
    - `blocked=false`
  - FE debug payload:
    - `debug_method="zone_anchor"`
    - `movement_target_tile=[131,53]`
    - `start_in_zone=true`
    - `has_net_destination_change=false`

- `Katya Pistsova`, step `1`
  - backend emit:
    - `start_pos=[120,49]`
    - `planned_pos=[119,48]`
    - `movement=[120,48]`
    - `stationary_emission=false`
  - raw FE report:
    - `actual_pos=[120,49]`
    - `actual_path=[[120,49]]`
    - `blocked=false`
  - FE debug payload:
    - `debug_method="zone_anchor"`
    - `movement_target_tile=[120,49]`
    - `start_in_zone=true`
    - `has_net_destination_change=false`

This means FE is still behaving as if the movement target equals the current tile, even when backend emitted a real move.

### What We Previously Did
Per `double-docs/20260227_interesting.md`, we previously concluded:

- FE runtime normalization was converting missing backend path data into fake stationary fallback semantics.
- FE was dropping or overwriting backend step intent fields such as `movement` / `planned_pos`.
- That could cause headless execution to conclude “no destination change” and enter `zone_anchor`.

We then implemented a code-level fix intended to:
- preserve backend next-step intent as first-class FE runtime data,
- stop fabricating `path=[[start]]` when backend did not send a path,
- make FE execution prefer preserved backend step intent over synthetic stationary fallback.

We also added richer FE/headless diagnostics and improved no-move reporting semantics.

### Why We Need A New Investigation
Despite that work, `20260308-4` still failed in a way that looks materially similar to earlier bad runs.

That means at least one of the following is true:

1. our RCA was incomplete or wrong,
2. the fix was not active in the runtime path actually used by the proof run,
3. another normalization layer still rewrites movement intent before FE execution,
4. FE path selection is still collapsing valid intra-zone moves into `zone_anchor`,
5. or the backend-to-FE contract is still too ambiguous for the current FE logic.

### What We Need Investigated
Please investigate the full FE/headless runtime pipeline for `20260308-4`, not just code statically.

#### 1. Verify the actual runtime payload FE executed
For the failing personas/steps, determine exactly what object reached `AnimationManager.executeStepWithAnimation(...)`.

For each failing step, capture:
- `start_pos`
- `planned_pos`
- `movement`
- `path`
- `target_zone`
- `coordinate_system`
- `speed_multiplier`
- any intent/hold-related fields

We need to know whether FE truly received preserved `movement` / `planned_pos`, or whether they were lost before execution.

#### 2. Determine where `movement_target_tile` becomes the current tile
The critical question is:

How does backend `movement=[130,51]` become FE `movement_target_tile=[131,53]` for Ivan step `1`?

Please identify the exact transformation stage where this happens:
- API response transform
- Redux/state normalization
- playback/cache layer
- canvas stepData construction
- headless execution wrapper
- AnimationManager target selection

#### 3. Determine whether the new fix was actually active in the proof run
Please verify whether `20260308-4` was produced with:
- the latest FE source,
- the latest built frontend bundle,
- the correct headless runtime path,
- and no stale cached bundle / stale browser context / stale deployed assets.

We need runtime proof, not just code inspection.

#### 4. Re-evaluate `zone_anchor`
We previously treated `zone_anchor` as the dominant FE branch. Please verify:
- whether `zone_anchor` is truly the first incorrect decision,
- or whether it is only the final symptom after the movement target was already rewritten upstream.

#### 5. Check for remaining runtime path fabrication or intent loss
Even if some code paths were fixed, investigate whether any alternative path still does one of the following:
- creates synthetic one-point paths,
- rewrites `movement` to current coordinates,
- discards `planned_pos`,
- prefers stale `pathEnd` over current backend step intent,
- or reconstructs persona step payloads from state in a way that loses the intended target.

#### 6. Explain why realism did not improve
We need a plain causal answer to:
- what worked,
- what failed,
- and why the proof run still showed frozen / duplicate movement despite the FE update work.

### Required Deliverables
Please return:

1. a stage-by-stage failure map:
   - backend emit
   - FE normalized payload
   - FE execution decision
   - FE raw movement report
   - backend feedback application

2. one concrete root cause statement with confidence level

3. explicit answer to this question:
   - “Was our previous RCA wrong, incomplete, or correctly scoped but not actually active in runtime?”

4. a corrected remediation plan:
   - minimal fix
   - robust fix
   - verification steps

### Artifacts To Use
Please use these artifacts as primary evidence:
- `double-docs/realism-runs/20260308-4/analyze-api.md`
- `double-docs/realism-runs/20260308-4/analyze-supabase.md`
- `double-docs/realism-runs/20260308-4/analyze-compare.md`
- `double-docs/realism-runs/20260308-4/movement-pipeline.ndjson`
- `double-docs/realism-runs/20260308-4/movement-pipeline-summary.md`

Please also compare against:
- `double-docs/20260227_interesting.md`
- `double-docs/realism-runs/20260308-1`
- `double-docs/realism-runs/20260308-2`

### Success Criteria For This Investigation
This investigation is only complete if it can answer, with evidence:

- exactly where backend next-step movement intent is lost or rewritten,
- why FE still ends up with `movement_target_tile == current tile`,
- and why `zone_anchor` still fires on clearly non-stationary backend steps.
