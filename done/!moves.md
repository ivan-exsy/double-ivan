## Movement Generation Pipeline (Supabase SOT)

### 1) Intent generation (backend)
- `reverie.py` runs each step and produces a movement intent per persona.
- Intent includes: `target_zone` (bbox), `planned_pos` (tiles), `speed_multiplier`,
  `estimated_duration`, and `final_destination` (multi-step journeys).
- Speed is capped at 6 tiles per step; `planned_pos` is clamped to a reachable tile.
- Backend writes the planned position to Supabase `personas_coords` with
  `movement` JSONB. In intent-only mode (`BACKEND_INTENT_ONLY_PATH=true`),
  `path[]` is empty and serves as a hint for headless A*.

### 2) Path calculation + execution (headless frontend)
- `reverie/backend_server/headless_visualization.py` launches Playwright and
  loads `/simulations/{sim}?step=N&headless=true`.
- Frontend exposes `window.__executeMovementsForStep(stepData)` and disables
  realtime/polling so it runs only the injected step.
- `AnimationManager` computes an A* path on the collision layer (via
  `CollisionChunkManager` loading Supabase `maze_tiles` chunks), then runs
  the tween animation.
- Headless collects `actual_path[]` and `actual_pos` from
  `window.__headlessReports` and submits a `movement_report` to
  `POST /api/simulations/{sim}/observations` (idempotent by `step + persona`).

### 3) End-of-step coordinate authority (backend)
- Backend processes the `movement_report` and UPDATEs Supabase:
  `x, y = actual_pos`, `movement.path = actual_path`.
- `scratch.last_actual_pos` is updated for continuity.
- Supabase now holds the authoritative ground truth for replay and validation.

### 4) Next-step intent uses actual coords
- Step N+1 start position priority is:
  `scratch.last_actual_pos` -> Supabase latest -> JSON fallback.
- If `final_destination` not reached, the backend regenerates a new
  `target_zone` and `planned_pos` toward it, respecting speed caps and
  reachability checks.
- The cycle repeats each step, keeping intent based on the last verified
  (headless) actual position.

### Replay note (browser)
- Browser playback does not run A*; it reuses stored `actual_path[]` from
  Supabase via `get_step_positions()` for lightweight, deterministic replay.



---

## 2026-02-09 Movement Pipeline Investigation (Oscillation + Zone Drift)

### Context

Movement stability remains **partially improved** after recent chat fixes. Analysis of
`20260209-1` steps 3-9 reveals **three distinct failure modes** that isolate different
parts of the pipeline:

| Failure Mode | Persona(s) | Symptom | Proximate Cause |
|---|---|---|---|
| **Y-axis zone drift** | Luba | Position stays at y~976 while target zone y is 624-752; x converges correctly | Planning / A* pathing (no interrupts involved) |
| **Chat-driven oscillation** | Ivan | 0 net x-progress over 7 steps; left-right flips every step | Proximity interrupts + replan cooldown bypass |
| **Group clustering lock** | Ivan+Gosha+Katya | All three stuck within 32-128 px, mutual chats every step | Positive feedback loop: proximity -> chat -> path clamp -> stay close -> repeat |

Because Luba has **zero chats and zero proximity events**, her case cleanly isolates
the planning/pathing pipeline from interrupts. Ivan's case isolates the interrupt
pipeline. The group case is emergent -- fixing individual interrupt handling should
dissolve it, but a per-pair conversation cooldown is the structural fix.

---

### Goals

1. **Pinpoint the first checkpoint** where each failure mode diverges from the design.
2. Confirm whether oscillation is caused by **planning, `remaining_path` invalidation,
   proximity interrupts, chat damping, `pre_interrupt_pos` blend-back, or headless A*
   routing**.
3. Produce a concrete fix list: which file, which function, what change, expected
   before/after behavior.

---

### Required Walkthrough (8 Pipeline Checkpoints)

Trace **both Luba and Ivan** over steps 3-9 (`20260209-1`). Include logs/artifacts at
each checkpoint. Code locations given for reference.

---

#### CP-1) Intent & Planning Inputs
`plan.py:1591-1716`, `reverie.py:2790-2910`

- `act_description`, `act_address`, `target_zone` (bbox)
- `zone_anchor` -- computed at `plan.py:1657-1701` (center tile, walkable fallback)
- `planned_pos` -- after reachability check (`reverie.py:2832-2859`)
- `speed_multiplier` -- from action keywords (`plan.py:1703-1713`)
- `replan_cooldown_steps` value and whether replan was **skipped** this step
- Whether `act_address` changed (resets cooldown to 0 at `reverie.py:2830`)

**Artifacts:** log `zone_anchor`, `planned_pos`, `replan_cooldown_steps`,
`last_replan_step`, replan decision (kept previous / recomputed).

**Luba-specific:** Is `zone_anchor.y` correct (~20 tiles)? Does `planned_pos`
ever have a y-component pointing toward the zone, or is it always horizontal?

---

#### CP-2a) Backend Path Estimate (intent-only mode)
`reverie.py:2130-2600`

- `planned_pos` after **speed clamping** (`clamp_position_to_max_distance`,
  `reverie.py:282-325`, cap = `MAX_TILES_PER_STEP=6`)
- Whether `was_clamped=True` -> `final_destination` stored
- **Zone snap** -- if `planned_pos` drifts 1-2 tiles outside zone, it snaps to
  `zone_anchor` (`reverie.py:2861-2874`)
- Intent hysteresis -- if cooldown active and distance <=2, keeps previous
  `planned_pos` (`reverie.py:2893-2902`)

**Artifacts:** log `planned_pos` before/after clamping, `was_clamped`,
`final_destination`, hysteresis decision.

**Luba-specific:** Is the 6-tile speed cap consuming the full budget on x-movement,
leaving zero budget for y-correction? If target is ~18 tiles south and ~30 tiles west,
does `clamp_position_to_max_distance` produce a mostly-horizontal intermediate?

---

#### CP-2b) Headless Frontend A* Execution
`AnimationManager.ts` (A*: lines 3071-3145; zone pathing: lines 3204-3262),
`CollisionChunkManager.ts`

- Raw A* path tiles from `findPathToZoneWithTarget()` -- preferred target, then
  zone center, then random points (up to 10 attempts), then BFS fallback
- Which collision chunks were loaded; whether `hasCollisionDataReady()` was true
  before A* ran
- Whether there is a **collision barrier** between Luba's y~30 and target y~20
  that forces horizontal routing
- Path length vs 6-tile budget -- does the headless enforce a tile cap or run full A*?

**Artifacts:** add `console.log` in `AnimationManager.ts` for: preferred target
tile, A* result (full path), collision chunk load status. Capture via Playwright
`page.on('console')` in `headless_visualization.py`.

**Luba-specific:** This is the most likely breakpoint for y-drift. If A* routes
around a wall horizontally, the 6-tile budget gets spent on x, and y never
converges. Log the full A* path to confirm.

---

#### CP-3) `remaining_path` Continuation
`reverie.py:2146-2184, 2507-2509, 2569-2579`

- Was `persona.scratch.remaining_path` non-empty from the previous step?
- Does `remaining_path[0]` match the current actual position?
  If not, it resets to `[]` (`reverie.py:2507-2509`) -- **this forces a full
  recompute and is a likely oscillation source**.
- How many tiles were consumed vs carried forward?
- For long paths (>10 tiles), was the path subdivided into 5-tile segments?

**Artifacts:** log `remaining_path` length at step start, whether it was
invalidated (position mismatch), consumed count, new `remaining_path_for_write`.

**Key question:** Is `remaining_path` being invalidated *every step* because
`actual_pos` from the headless report doesn't exactly match the expected next
tile? If so, no path is ever continued -- every step is a fresh recompute, which
explains directionality changes.

---

#### CP-4a) Proximity Interrupt Handling
`reverie.py:2545-2564`

- Was `pending_observations` processed inline during movement generation?
- Distance threshold check (< 100 tiles)
- `interrupted = True` flag set
- Path clamped to `output_path[:2]` (first two tiles only)
- `replan_cooldown_steps` set to `max(current, 2)`

**Artifacts:** log `interrupted`, distance to triggering agent, path length
before/after clamping, cooldown value set.

**Ivan-specific:** In steps 4-9, chats occur in 5/7 steps with proximities
32-128px (1-4 tiles). Each triggers path clamping to 2 tiles. With cooldown=2
but new proximity events every step, is the cooldown effectively bypassed?

---

#### CP-4b) Chat Proximity Damping (separate from interrupts)
`reverie.py:2533-2543`

- When `chatting_with` is set AND distance to partner < 2 tiles:
  - `speed_multiplier` drops to 0.1
  - Path clamped to `[output_path[0], output_path[-1]]`
- This is **distinct** from CP-4a proximity interrupts and applies even when
  no new proximity observation fires

**Artifacts:** log when chat damping activates, distance to chat partner,
path before/after clamping, effective speed_multiplier.

**Ivan-specific:** Ivan is chatting with Gosha at 32px (1 tile) in steps 5-9.
This means chat damping fires *in addition to* proximity interrupts, double-
clamping the path. Is this double application intended?

---

#### CP-5) `pre_interrupt_pos` Blend-Back
`persona.py:640-641` (storage), `execute.py:1014-1029` (resumption)

- When `trigger_conversation()` fires, both agents store their current tile as
  `pre_interrupt_pos`
- When chat ends, `execute()` checks if current position differs from
  `pre_interrupt_pos` by >1 tile -> generates a blend step *back* toward it
- If the blend target is stale or misaligned with the current zone/plan, this
  produces a **backtracking step** that reverses the previous step's progress

**Artifacts:** log `pre_interrupt_pos` when stored, and when consumed (blend
target, current pos, direction of blend step).

**Ivan-specific:** Ivan's step-8 rightward flip (+64x, +96y) may be a blend-back
toward a `pre_interrupt_pos` set during the step-4 Katya chat. Is the stored
position from 4 steps ago still valid?

---

#### CP-6) Movement Serialization
`reverie.py:3073-3117`

- Final `start_pos`, `movement` JSONB, `path` as written to Supabase
- `remaining_path_for_write` persisted to `persona.scratch.remaining_path`
- `partial_state.remaining_path` and `partial_state.pre_interrupt_pos` serialized

**Artifacts:** log the complete emitted `movement` object and the next step's
expected `start_pos`.

---

#### CP-7) Position Resolution / SOT
`reverie.py:2033-2119`, `_handle_movement_report()` at lines 4774-4929

- Position resolution priority:
  1. `scratch.last_actual_pos` (from previous headless report)
  2. Supabase SOT (step-1 row)
  3. Environment JSON fallback
- Was a deviation >2 tiles detected? Did it trigger a forced replan?
- Does `scratch.curr_tile` match `last_actual_pos` match Supabase?

**Artifacts:** log which source was chosen, all three values, deviation check
result.

**Luba-specific:** `last_actual_pos` tiles go [114,37]->[85,30] -- y drops from 37
to 30 over 7 steps, but target is y~20. Does the position resolution correctly
reflect the headless-reported actual position, or is there a lag/mismatch?

---

#### CP-8) Headless Report Timing
`headless_visualization.py:393-436`, `simulations.py:930-1079`

- When does the headless report arrive relative to the next step's start?
- Is `pending.json` read *before* the report is written? (Would leave
  `last_actual_pos` stale for one step.)
- Deduplication: is a longer-path report ever replaced by a shorter one?

**Artifacts:** log timestamps of report submission vs next-step
`process_pending_observations()` call. Verify `pending.json` read/write ordering.

---

### Critical Questions to Answer

1. **Where does Luba's y-drift originate?**
   - Is `zone_anchor.y` correct? (CP-1)
   - Does speed clamping consume the full 6-tile budget on x? (CP-2a)
   - Does A* find a direct south route, or does a collision barrier force horizontal
     routing? (CP-2b)
   - Is `remaining_path` invalidated every step, forcing fresh recomputation? (CP-3)

2. **Why does Ivan oscillate despite being in-zone?**
   - Is replan cooldown (2 steps) being bypassed by new proximity events every step?
     (CP-4a)
   - Is chat damping *and* proximity interruption double-clamping paths? (CP-4b)
   - Is `pre_interrupt_pos` from a stale chat causing backtracking? (CP-5)
   - Is `remaining_path` invalidated by position mismatch after each interrupt? (CP-3)

3. **Why does the Ivan-Gosha-Katya cluster persist?**
   - Is there any per-pair conversation cooldown preventing re-chat within N steps?
   - After a chat ends, does any logic push agents apart, or do they stay at 1-2 tiles?

4. **Is `remaining_path` functional at all?**
   - Across all personas over 7 steps, is `remaining_path` ever successfully continued,
     or is it invalidated (position mismatch) every single step?

5. **Is the headless report arriving in time?**
   - Does step N+1 always have the report from step N when it resolves positions? (CP-8)

---

### Suggested Traces

| Persona | Steps | Isolates | Why |
|---|---|---|---|
| **Luba** | 3-9 | Planning + A* pathing | Zero chats, zero proximity -> pure pipeline test. Y-drift is unexplained. |
| **Ivan** | 3-9 | Interrupt + replan pipeline | 5 chats in 7 steps, 0 net x-progress -> interrupt handling dominates. |

Trace **both** -- they test complementary parts of the pipeline.

---

### Deliverables

1. **Annotated checkpoint log** for Luba steps 3-9 (all 8 checkpoints, focus on CP-1,
   CP-2a, CP-2b, CP-3).
2. **Annotated checkpoint log** for Ivan steps 3-9 (all 8 checkpoints, focus on CP-3,
   CP-4a, CP-4b, CP-5).
3. **Answer to each of the 5 critical questions** with evidence from the logs.
4. **Collision map excerpt** around Luba's path (tiles y:20-37, x:75-115) -- are there
   walls blocking the direct south route?
5. **Concrete fix list** -- which file, which function, what change, expected effect.

---

### Prioritized Fix Recommendations — Implementation Specs

Decisions finalized. Data from diagnostic sim `20260209-3` (8 steps, 4 personas).
All 8 CPs fired correctly (CP-1:4, CP-2a:32, CP-2b:67, CP-3:33, CP-5:5,
CP-6:32, CP-7:32, CP-8:85). CP-4a/4b: 0.

---

#### Fix 1: Remove Deviation-Based Replan (INTENT_ONLY mode)

**Problem:** In INTENT_ONLY mode (`BACKEND_INTENT_ONLY_PATH=true`), backend
`planned_pos` is a straight-line estimate the frontend ignores. Deviation
check compares this garbage estimate against the frontend's real A* position.
Result: deviation=5-6 every step, forced replan every step, cooldown=0 always.

**Decision:** Remove deviation-based replan entirely. Only replan on `blocked=True`
or action change/expiry. Trust the frontend A*.

**What to change:**

**File: `reverie.py` — `_handle_movement_report()` (line ~5005)**

Current code:
```python
# Replan on blocked or significant deviation (>2 tiles)
if blocked or deviation > 2:
  self._trigger_replan(persona, report, deviation)
  result['action_taken'] = 'replan'
  print(f"🔄 REPLAN: {persona_name} deviation={deviation}, blocked={blocked}")
```

Replace with:
```python
# Replan ONLY on blocked pathfinding (INTENT_ONLY: frontend A* is authoritative)
if blocked:
  self._trigger_replan(persona, report, deviation)
  result['action_taken'] = 'replan'
  print(f"🔄 REPLAN: {persona_name} blocked={blocked}")
```

**File: `reverie.py` — `process_pending_observations()` (line ~3898)**

Current code:
```python
# Track personas with significant deviation for movement regeneration
deviation = result.get('deviation', 0)
if deviation > DEVIATION_TOLERANCE:
    persona_name = result.get('persona')
    actual_pos = result.get('actual_pos')
    if persona_name and actual_pos:
        positions_to_update[persona_name] = actual_pos
        print(f"📍 Will regenerate movement for {persona_name}: deviation={deviation} > {DEVIATION_TOLERANCE}")
```

Replace with:
```python
# Track blocked personas for movement regeneration (INTENT_ONLY: deviation is structural, not a bug)
if result.get('action_taken') == 'replan':
    persona_name = result.get('persona')
    actual_pos = result.get('actual_pos')
    if persona_name and actual_pos:
        positions_to_update[persona_name] = actual_pos
        print(f"📍 Will regenerate movement for {persona_name}: blocked")
```

Also remove or comment out the `DEVIATION_TOLERANCE = 2` constant on line ~3875
(no longer used).

**Keep unchanged:**
- `deviation` calculation in `_handle_movement_report()` — still useful for logging/monitoring
- CP-2a logging — still reports deviation for diagnostics
- Position update from actual_pos — always update persona position from report

**Acceptance criteria:**
- Run sim: `deviation=` lines still appear in logs (monitoring) but `🔄 REPLAN:` only
  appears for `blocked=True` events
- CP-2a shows `cooldown` values > 0 on subsequent steps (no longer reset every step)
- Personas with long journeys (like Luba) show smooth zone_dist decrease without
  forced replans every step

---

#### Fix 2: Per-Pair Conversation Cooldown

**Problem:** Same pairs chat every 1-2 steps. Gosha-Ivan: 3 chats in 4 steps.
Only existing guard is "agent already in active chat" — no per-pair memory.

**Decision:** In-memory dict on `ReverieServer`. 10-step minimum gap.

**What to change:**

**File: `reverie.py` — `__init__()` (line ~468, after `self.observation_history`)**

Add:
```python
# Per-pair chat cooldown: {("Agent1", "Agent2"): last_step} — sorted tuple key
self.pair_chat_cooldowns = {}
PAIR_CHAT_COOLDOWN_STEPS = 10  # minimum steps between same-pair conversations
```

**File: `reverie.py` — `process_pending_observations()` proximity section (line ~3997)**

Current code:
```python
                          # Classify and trigger conversation
                          tier = classify_chat_tier(obs, agent1, agent2)
                          if tier:
                              if tier == "full" and (
```

Insert cooldown check BEFORE the tier classification:
```python
                          # Per-pair cooldown check
                          pair_key = tuple(sorted([agent1_name, agent2_name]))
                          last_chat_step = self.pair_chat_cooldowns.get(pair_key, -999)
                          if self.step - last_chat_step < PAIR_CHAT_COOLDOWN_STEPS:
                              print(f"📊 Tiered Chat: Skipped {agent1_name} & {agent2_name} "
                                    f"(pair cooldown: last chat step {last_chat_step}, "
                                    f"current step {self.step}, "
                                    f"need {PAIR_CHAT_COOLDOWN_STEPS} gap)")
                              stats['proximity']['skipped_sparsity'] += 1
                              continue

                          # Classify and trigger conversation
                          tier = classify_chat_tier(obs, agent1, agent2)
                          if tier:
                              if tier == "full" and (
```

**File: `reverie.py` — after `trigger_conversation()` call (line ~4018)**

After the existing `trigger_conversation(...)` call, add:
```python
                              # Record pair cooldown
                              self.pair_chat_cooldowns[pair_key] = self.step
```

Note: `PAIR_CHAT_COOLDOWN_STEPS` should be a module-level constant or class
attribute (alongside existing `DEVIATION_TOLERANCE`). Value: `10`.

**Acceptance criteria:**
- Run sim 15+ steps: same pair never chats within 10 steps of each other
- Log shows `(pair cooldown: ...)` skip messages for repeat proximity events
- Different pairs can still chat independently (Ivan-Katya at step 3, Gosha-Ivan
  at step 4 is fine — different pairs)
- Stats show `skipped_sparsity` count > 0

---

#### Fix 3: Remove `remaining_path` Dead Code

**Problem:** In INTENT_ONLY mode, backend never computes A* paths. `remaining_path`
is a relic of pre-Phase-10.8 when backend computed paths. `prev_act` is never stored,
so the continuation check always fails. All 33 CP-3 entries: `remaining_path_len=0`.

**Decision:** Remove as dead code. Frontend computes A* fresh each step, which is
the designed INTENT_ONLY architecture.

**What to change:**

**File: `reverie.py` — movement generation (lines ~2133-2206)**

The entire block from `# Attempt server-side continuation first using previous remaining_path`
through the continuation logic (including CP-3 logging) should be simplified.

Replace lines ~2133-2206 with:
```python
            # PHASE 10.8: In INTENT_ONLY mode, frontend computes A* fresh each step.
            # No server-side path continuation (remaining_path removed as dead code).
            used_continuation = False
            output_path = []
            remaining_path_for_write = []
            pronunciatio = getattr(persona.scratch, 'act_pronunciatio', None)
            description = f"{persona.scratch.act_description}"
```

**Throughout the rest of the movement generation function**, all assignments to
`remaining_path_for_write` can be replaced with `remaining_path_for_write = []`
or the variable can be set once at the top and never reassigned. The key locations:
- Line ~2270: `remaining_path_for_write = subdivided[6:] ...` → `[]`
- Line ~2279: `persona.scratch.remaining_path = remaining_path_for_write` → remove
- Line ~2292: `persona.scratch.planned_path = remaining_path_for_write` → remove
- Line ~2384: `remaining_path_for_write = []` → already correct
- Line ~2458: `remaining_path_for_write = [...]` → `[]`
- Line ~2475: `remaining_path_for_write = [...]` → `[]`
- Line ~2487: `remaining_path_for_write = []` → already correct
- Line ~2525-2531: remaining_path reconciliation block → remove entirely
- Line ~2614: `remaining_path_for_write = [...]` → `[]`
- Line ~2639: `persona.scratch.remaining_path = remaining_path_for_write` → remove

**Also remove:**
- CP-3 logging (lines ~2155-2204) — no longer needed
- `remaining_path` field still written to movement JSON (line ~3054) — set to `[]`

**Keep unchanged:**
- The `remaining_path` field in the movement JSON output (always `[]`) for backward
  compatibility with any frontend code that reads it

**Acceptance criteria:**
- Sim runs identically to before (remaining_path was always empty anyway)
- No `[CP-3]` lines in output
- Movement JSON `remaining_path` field is always `[]`
- Code is ~80 lines shorter in movement generation

---

#### Fix 4: Fix `pre_interrupt_pos` Blend-Back

**Problem:** `pre_interrupt_pos` is stored correctly (CP-5 fires) but never consumed.
The blend-back code in `execute.py:1014` checks `not chatting_with`, but chatting
personas are stationary so `execute.py` never runs its movement consumption path.
When chat ends (line ~3083: `chatting_with = None`), the next step's movement
generation doesn't check for pre_interrupt_pos.

**Decision:** Detect chat end via state transition (`chatting_with` was set last step,
now None). Expire when action address changes.

**What to change:**

**File: `reverie.py` — movement generation, BEFORE path planning starts (~line 2131)**

The pre-step chat snapshot already captures `pre_step_chatting_with` (line ~1995).
After position resolution and before path planning, add blend-back check:

```python
            # === Blend-back after chat end ===
            # If persona was chatting last step but is no longer chatting,
            # and pre_interrupt_pos exists, attempt a 1-step blend toward it.
            prev_chatting = pre_step_chatting_with.get(persona_name)
            curr_chatting = getattr(persona.scratch, 'chatting_with', None)
            pre_int = getattr(persona.scratch, 'pre_interrupt_pos', None)

            if prev_chatting and not curr_chatting and pre_int:
                # Expire if action changed since storage
                pre_int_act = getattr(persona.scratch, 'pre_interrupt_act_address', None)
                curr_act = getattr(persona.scratch, 'act_address', None)
                if pre_int_act and curr_act and pre_int_act != curr_act:
                    print(f"🔄 BLEND-BACK EXPIRED: {persona_name} action changed "
                          f"({pre_int_act} → {curr_act}), clearing pre_interrupt_pos")
                    persona.scratch.pre_interrupt_pos = None
                else:
                    pre_pos = tuple(pre_int)
                    dist = abs(current_pos[0] - pre_pos[0]) + abs(current_pos[1] - pre_pos[1])
                    if dist > 1 and dist <= 6:
                        # Generate blend-back as this step's movement target
                        print(f"🔄 BLEND-BACK: {persona_name} returning toward "
                              f"pre_interrupt_pos {pre_pos} (dist={dist})")
                        output_path = [current_pos, pre_pos]
                        next_tile = pre_pos
                        used_continuation = True  # skip normal path planning
                    else:
                        print(f"🔄 BLEND-BACK SKIP: {persona_name} dist={dist} "
                              f"(too close or too far)")
                    persona.scratch.pre_interrupt_pos = None
```

**File: `reverie/backend_server/persona/persona.py` — `trigger_conversation()` (where CP-5 stores)**

When storing `pre_interrupt_pos`, also store the current action address:
```python
# Existing CP-5 storage:
persona.scratch.pre_interrupt_pos = list(persona.scratch.curr_tile)
# Add action address for expiry check:
persona.scratch.pre_interrupt_act_address = getattr(persona.scratch, 'act_address', None)
```
Do this for both agents in the conversation.

**File: `execute.py` — blend-back code (lines 1014-1040)**

Remove or disable the existing blend-back code block. It's now handled in
`reverie.py` movement generation where it has access to the chat state transition.
Replace with:
```python
    # Blend-back logic moved to reverie.py movement generation (chat state transition check)
    # pre_interrupt_pos is consumed there, not here.
```

**Acceptance criteria:**
- Run sim with chats: after a chat ends, the persona's next step shows movement
  toward their pre-interrupt position (if same action, dist 2-6)
- CP-5 STORE logs appear, followed 1-2 steps later by `🔄 BLEND-BACK:` logs
- If persona starts a new action after chat, blend-back is skipped with
  `BLEND-BACK EXPIRED` message
- No backtracking to stale positions from 10+ steps ago

---

#### Tech Debt (no implementation needed now)

**Chat Damping (CP-4a/4b):** Dead code — chatting personas are already stationary
via `planned_pos=start_pos`. Speed damping and path clamping never fire. Keep as-is;
revisit if future changes make chatting personas move.

**Luba Y-Drift:** Disproven — frontend A* routes correctly through corridors.
Zone_dist converges steadily. No fix needed.

---

### Summary: Fix Priority Order

| # | Fix | Impact | Effort | Key File(s) |
|---|-----|--------|--------|-------------|
| 1 | **Remove deviation replan** | Critical | Small | `reverie.py:5005, 3898` |
| 2 | **Per-pair chat cooldown** (10 steps, in-memory) | High | Small | `reverie.py:468, 3997, 4018` |
| 3 | **Remove remaining_path** dead code | High | Medium | `reverie.py:2133-2639` (~80 lines) |
| 4 | **Fix pre_interrupt_pos** blend-back trigger | Medium | Medium | `reverie.py:2131`, `persona.py`, `execute.py:1014` |
| — | Chat damping — tech debt | Low | — | — |
| — | Luba Y-drift — not a bug | None | — | — |

---

### Appendix A: Raw Sim Data (20260209-1 Steps 3-9)

<details>
<summary>Luba Pistsova -- Y-Drift Trace (original sim)</summary>

- **Action**: "working as paralegal @ Hobbs Cafe:cafe customer seating" (consistent)
- **Target Zone** (px): x:2384-2544, y:624-752 -> narrows to x:2384-2480, y:624-720
- **Tile equiv**: x:74-77, y:19-22. Luba never enters y<976 (drift >250px outside zone).
- **Speed**: 1.0. **Chats**: None. **Proximities**: >385px (irrelevant).

| Step | Start (px) | End (px) | Path | Net | y vs Zone |
|------|-----------|---------|------|-----|-----------|
| 3 | 3664,1200 | 3472,1200 | horiz left, 7 tiles | -192x, 0y | 1200 >> 752 |
| 4 | 3472,1200 | 3440,1040 | down then left, 7 tiles | -32x, -160y | 1040 >> 720 |
| 5 | 3440,1040 | 3312,976 | left then down, 7 tiles | -128x, -64y | 976 >> 720 |
| 6 | 3312,976 | 3120,976 | horiz left, 7 tiles | -192x, 0y | 976 >> 720 |
| 7 | 3120,976 | 2928,976 | horiz left, 7 tiles | -192x, 0y | 976 >> 720 |
| 8 | 2928,976 | 2736,976 | horiz left, 7 tiles | -192x, 0y | 976 >> 720 |
| 9 | 2736,976 | 2544,976 | horiz left, 7 tiles | -192x, 0y | x in zone, y still 976 |

- **`last_actual_pos`** (tiles): [114,37] -> [85,30]. x converges; y: 37->30 (needs ~20).
- **Diagnosed (20260209-3):** Horizontal segments are corridor-forced. A* is correct.

</details>

<details>
<summary>Ivan Pistsov -- Chat Oscillation Trace (original sim)</summary>

- **Action**: "Reviewing goals @ Dorm:common room table" (consistent)
- **Target Zone** (px): x:3600-3984 -> 3664-3792; y:1264-1680 -> 1328-1488
- **Tile equiv**: x:112-118, y:41-46. Ivan starts in-zone but net progress is ~0.
- **Speed**: 1.0. **Chats**: 5 of 7 steps (Katya step 4; Gosha steps 5-9).

| Step | Start (px) | End (px) | Path tiles | Net | Chat | Prox (px) |
|------|-----------|---------|-----------|-----|------|-----------|
| 3 | 3856,1488 | 3792,1456 | 4 (down-left) | -64x, -32y | -- | -- |
| 4 | 3792,1456 | 3760,1456 | 2 (left) | -32x, 0y | Katya | 32 |
| 5 | 3760,1456 | 3760,1328 | 7 (L-D-R flip) | 0x, -128y | Gosha | 71 |
| 6 | 3760,1328 | 3728,1392 | 4 (backtrack) | -32x, +64y | Gosha | cont. |
| 7 | 3728,1392 | 3728,1424 | 2 (up) | 0x, +32y | -- | -- |
| 8 | 3728,1424 | 3792,1520 | 6 (right-up) | +64x, +96y | Gosha | 192 |
| 9 | 3792,1520 | 3728,1392 | 7 (down-left flip) | -64x, -128y | Gosha | 32 |

- **`last_actual_pos`** (tiles): [120,46] -> [118,47]. Net movement: ~2 tiles in 7 steps.
- **Diagnosed (20260209-3):** Per-pair chat spam (Priority 3) + forced replan (Priority 2)
  cause oscillation. Chat makes persona stationary, then post-chat forced replan
  redirects them, triggering new proximity → new chat → repeat.

</details>

<details>
<summary>Group Cluster: Gosha + Katya (original sim context)</summary>

- **Gosha**: "Waking/stretching to library @ hallway". Targets narrow to x:3664-3824,
  y:1328-1520. Paths oscillate 2-6 tiles. Chats w/Ivan (steps 5-9) & Katya (step 7).
  Net: ~-128x, +32y (jitter). `last_actual_pos`: [123,48]->[118,41].
- **Katya**: "Heading to library @ library table". Targets narrow to x:3664-3856,
  y:1328-1552. Paths 2-7 tiles, oscillatory. Chats w/Ivan (step 4) & Gosha (step 7).
  Net: ~-64x, 0y (stuck). `last_actual_pos`: [117,51]->[114,42].
- **Group note**: All three within 32-128px throughout. Mutual chats every 1-2 steps
  keep them clamped. This is a **positive feedback loop** — fixing per-pair cooldown
  (Priority 3) should break it.

</details>

### Appendix B: Diagnostic Sim Data (20260209-3, 8 steps)

<details>
<summary>Checkpoint Coverage Summary</summary>

| CP | Count | Notes |
|----|-------|-------|
| CP-1 (Intent) | 4 | Fires once per persona at step 0 (new action planning) |
| CP-2a (Backend) | 32 | 4 personas × 8 steps, all `speed_clamped=False` |
| CP-2b (Frontend A*) | 67 | Includes multiple targets per step |
| CP-3 (remaining_path) | 33 | ALL show `remaining_path_len=0`, `prev_act=None` |
| CP-4a (Proximity clamp) | 0 | Never fires — chatting personas already stationary |
| CP-4b (Chat damping) | 0 | Never fires — no path to damp |
| CP-5 (pre_interrupt_pos) | 5 | Stored correctly, never consumed |
| CP-6 (Serialization) | 32 | 8 entries show `chat=yes` with proper chatting_with |
| CP-7 (Position/SOT) | 32 | All `source=supabase` — SOT working correctly |
| CP-8 (Report timing) | 85 | All reports accepted, no timing issues |

</details>

<details>
<summary>Luba Pistsova -- Full CP-2a Trace (zone_dist convergence)</summary>

| Step | start | planned_pos | zone_dist | hysteresis | Notes |
|------|-------|-------------|-----------|------------|-------|
| 0 | (123,46) | (123,46) | 60 | — | First step, stationary |
| 1 | (118,45) | (114,43) | 51 | False | Teleport-capped |
| 2 | (116,41) | (112,39) | 47 | False | Teleport-capped |
| 3 | (114,37) | (110,35) | 43 | False | Teleport-capped |
| 4 | (108,37) | (104,35) | 39 | False | Teleport-capped |
| 5 | (107,32) | (107,32) | 40 | False | Zone_dist +1 (corridor detour) |
| 6 | (103,30) | (100,29) | 30 | False | Good progress |
| 7 | (97,30) | (97,30) | 28 | False | Corridor continues west |

Zone target: {min_x:72, max_x:83, min_y:19, max_y:26}. Steady convergence despite
constant deviation=6 and forced replan. Proves deviation is false-positive.

</details>

<details>
<summary>Chat Cluster — Full Conversation Chain</summary>

```
Step 3: Proximity Ivan-Katya → trigger_conversation()
        CP-5: pre_interrupt_pos Ivan=[118,45], Katya=[117,45]

Step 4: CP-6: Ivan chat=yes w/Katya, stationary at (118,45)
              Katya chat=yes w/Ivan, stationary at (117,45)
        Proximity: Gosha-Ivan, Ivan-Katya, Gosha-Katya (3 pairs detected)
        → Gosha-Ivan chat triggered
        → Ivan-Katya SKIPPED (active chat)
        → Gosha-Katya SKIPPED (active chat)
        CP-5: pre_interrupt_pos Gosha=[116,44], Ivan=[117,45]

Step 5: CP-6: Ivan chat=yes w/Gosha (switched partner!), pre_interrupt_pos=[117,45]
              Gosha chat=yes w/Ivan, pre_interrupt_pos=[116,44]
        Proximity: same 3 pairs → Gosha-Ivan triggered AGAIN
        CP-5: pre_interrupt_pos Gosha=[116,43], Ivan=[113,43]

Step 6: CP-6: Ivan chat=yes w/Gosha, pre_interrupt_pos=[113,43]
              Gosha chat=yes w/Ivan, pre_interrupt_pos=[116,43]
        Proximity: 3 pairs → Gosha-Katya triggered
        CP-5: pre_interrupt_pos Gosha=[116,44], Katya=[116,40]

Step 7: CP-6: Katya chat=yes w/Gosha, pre_interrupt_pos=[116,40]
              Gosha chat=yes w/Katya, pre_interrupt_pos=[116,44]
        Proximity: 3 pairs → Gosha-Ivan triggered AGAIN
        CP-5: pre_interrupt_pos Gosha=[116,43], Ivan=[116,44]
```

5 conversations in 5 steps. Gosha-Ivan: 3 chats. Zero per-pair cooldown.
All chatting personas stationary (path_len=1). Blend-back never consumed.

</details>
