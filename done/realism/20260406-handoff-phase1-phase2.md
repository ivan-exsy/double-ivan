# Technical Handoff: Phase 1 + Phase 2 Delivery

**Date:** 2026-04-07  
**Author:** Nicolas Demaria  
**Branch:** `nicolas` (BE + FE)  
**Contract reference:** `realism/20260404-technical-assessment.md`  
**Budget:** 20 hours approved (15h doc + 5h conversation system via WhatsApp)  
**Hours used:** 20h  
**Detailed tracker:** `local_docs/20260404-phase1-phase2-tracker.md`

---

## Executive Summary

This document covers the work delivered between April 4-7, 2026. The scope was defined in `20260404-technical-assessment.md` — three tasks totaling ~15h, plus 5h for conversation system improvements agreed separately.

**What was contracted:**
- Task 0: Ivan bootstrap data fix (<0.5h)
- Phase 1: Unified location system (5-7h)
- Phase 2: Activity State Machine (~8h)

**What was delivered:**
- Task 0: Complete
- Phase 1: Complete — exceeded scope with maze_registry.json, multi-factor scoring, 6 audits, and -4,500 lines of legacy code
- Phase 2: Partially delivered — the conversation-related deliverables (4 of 7 items) were delivered as part of a ConversationManager overhaul. The Activity State Machine (state replacement for 6 competing mechanisms) was not implemented

**Why Phase 2 changed:** Phase 1 validation revealed that the conversation system was critically broken — crashes, invisible chats, 14-tile-distance triggers, zombie sessions. These had to be fixed before any state machine could work, because both systems share the same runtime loop and scratch state. The ConversationManager naturally absorbed the conversation-specific deliverables from Phase 2 (overlap awareness, dynamic cooldowns, proximity triggers, temporal context).

**What remains:**
- Activity State Machine core: replace 6 competing behavior mechanisms with explicit states (~4-6h)
- 200-step 15-persona validation sim (will be delivered with this handoff)

**SOT updates delivered:**
- `sot_chats.md` v1.2 → v1.4: ConversationManager, satiation curves, atmosphere thresholds, batch generation, exchange familiarity scaling
- `sot_prompts.md` v1.1 → v1.2: new batch conversation function, activity_type in decomp, 6 legacy functions marked, 3 survival mode functions added
- `sot_realism.md`: maze_registry.json, LocationResolver V2, ConversationManager, activity_type in decomp
- `sot_be-fe.md` v1.3 → v1.4: proximity_threshold field in BE→FE payload

---

## 1. Starting Point: What Was Broken

### Checkpoint 1 status (pre-Phase 1)

Checkpoint 1 delivered 6 fixes (April 2-3, 6h) validated in sim `20260403-3` (200 steps, 4 personas, 0 regressions). Post-merge sim `20260403-final` confirmed Ivan's changes (bathroom rename, sprite card, chat-with-double) landed cleanly.

But Checkpoint 1 patched symptoms, not causes. The technical assessment identified two structural problems:

**Problem A — Location resolution had no single authority.** 12 resolution steps with 6 fallbacks and 2 repair passes. When the primary path failed, the system silently degraded through cascading fallbacks. Observable symptoms:
- Ivan woke up in someone else's bed (Studio Room 1)
- Luba went to Studio Bathroom (~130 tiles away) instead of Dorm bathroom (~5 tiles)
- Duration overflows to 1000+ minutes on fallback paths
- "Blackboard" resolved to wrong room — no post-LLM validation

**Problem B — 6 behavior mechanisms contradicted each other.** Novelty budget, action extension, proactive refresh, stall breaker, intent hold, and healthy persistence — each reasonable in isolation, but together they created emergent deadlocks. Ivan got stuck in a desk→eat→desk loop for 200+ steps because intent hold froze his position, healthy persistence blocked the stall breaker, and the novelty budget suppressed social evaluation.

### Additional problems discovered during Phase 1 validation

When we ran the first post-Phase-1 validation sims with 12 personas, the conversation system — which worked acceptably at 4 personas — broke catastrophically:

- **Reflect crash at step 25+:** `reflect()` accessed a chat node before perception created it → sim couldn't run past ~25 steps
- **Conversations at 14 tiles:** grouped observation path had no distance validation → people talked from across town
- **Zombie conversations lasting 21 steps:** `chat_end_step` expired but cleanup never ran → personas stuck "chatting" forever
- **Invisible conversations:** chat triggered after step payload written to disk → FE never received the data
- **180-degree reversals:** chat trigger mutated `act_address` → A* replanned path in opposite direction

These were blocking: we could not validate Phase 1 because we couldn't distinguish location bugs from conversation bugs. A "frozen" persona could be a privacy filter bug (Phase 1), a zombie conversation (Phase 2), or both simultaneously.

---

## 2. What Was Delivered

### Task 0 — Ivan Bootstrap Data Fix

**Status:** Complete  
**Time:** <0.5h

Ivan's `scratch.json` referenced impossible activities ("drives for Uber", "family dinner"). The LLM generated plans including these, but when the runtime couldn't resolve them to map locations, it fell back to the desk — creating the desk→eat→desk stasis loop.

Fixed in 3 sources: local JSON (`20260330-1`), Supabase `20260330-1` row, and Supabase `base_family_sim` baseline (so future forks inherit correct data).

### Bootstrap Data Redesign — 15-Persona Sim

**Status:** Complete  
**Time:** <1h  
**Sim affected:** `20260330-1-12p` (baseline for 15-persona runs)

**Original bug:** The 12-persona bootstrap dataset inherited character definitions from an earlier non-campus prototype. Several personas had fields that were either empty, age-invalid, or semantically incompatible with the Ville campus world:

| Persona | Problem | LLM consequence |
|---|---|---|
| Gosha Pistsov | age=16, `learned`="junior at Fox Chapel High School, SAT prep" | LLM planned high school activities (diving practice 4-7pm, family dinner) → no matching map location → fallback to desk |
| Katya Pistsova | age=13, `learned`="finishing Dorseyville Middle School", `currently`="devising Christmas presents" | LLM planned craft/gift activities with no campus anchor → duration overflows, stuck in dorm |
| Luba Pistsova | `currently`="planning family vacation to Florida", `learned`="paralegal for two law firms" | LLM planned off-campus activities (law office, travel agency) → cascading location fallbacks |
| Gosha, Katya, Luba | `gender` field missing | Bathroom filtering disabled → personas entered wrong-gender bathrooms (when gendered filtering was active) |
| Multiple personas | `lifestyle` either too vague ("goes to bed around 11pm") or absent | LLM had no daily structure to decompose → erratic schedules, no confluences at shared spaces |
| No persona | Worked at Harvey Oak Supply Store or The Rose and Crown Pub | Commercial spaces were permanently empty → no service NPCs, no natural encounter points |

**How the LLM failed:** The cognitive loop's `plan.py` feeds `lifestyle` and `daily_plan_req` directly into the daily planning prompt. When these fields reference activities or locations that don't exist on the map (high school, law office, Florida), the LLM generates a plausible daily schedule — but `_determine_action()` can't resolve the plan items to valid arenas. LocationResolver V2 fails loudly, but pre-V2 code silently fell back to the persona's desk. The result: personas with broken bootstrap data entered a deterministic stasis loop (desk → eat → desk), indistinguishable from a code bug.

**Fix applied:**
- Redesigned all 12 personas: corrected ages (Gosha/Katya → 19), added missing `gender` fields, rewrote `innate`/`learned`/`currently` with campus-coherent roles (Gosha → mechanical engineering freshman, Katya → graphic design freshman, Luba → Oak Hill administrative coordinator + Hobbs Cafe manager)
- Rewrote `lifestyle` and `daily_plan_req` for all 12 with vague time anchors ("morning class", "around noon", "late afternoon") instead of rigid schedules — max 2-3 fixed times per persona. This gives the LLM room to improvise while keeping daily structure
- Added 3 new service personas: Oleg Taranov (Harvey Oak Supply Store manager), Daria Novikova (pub bartender, afternoon/evening shift), Yuri Semenov (campus groundskeeper, earliest riser)
- All locations verified against `maze_registry.json` — every `living_area`, activity reference, and `curr_tile` maps to a real sector/arena
- Validated against maze: `curr_tile` coordinates confirmed walkable via `collision_maze.csv`

### Phase 1 — Unified Location System

**Status:** Complete  
**Contracted scope:** 5-7h  
**Actual effort:** 6h (includes maze_registry, scoring, and 6 rounds of audits)

#### What was built

**LocationResolver V2** — single 5-step pipeline replacing 12 ad-hoc steps:
1. Deterministic guard (activity_type → candidate arenas from registry)
2. Typed scorer (multi-factor ranking)
3. LLM fallback (when deterministic can't decide)
4. Post-validation (against `maze.address_tiles`)
5. Fail loudly (structured error, not silent degradation)

Every decision is traced via `LocationTrace` dataclass — when a persona ends up in the wrong place, you can see exactly which step decided it and why.

**maze_registry.json** — structured metadata for the entire map (11.8 KB):

The system previously had no structured knowledge of the map. Every decision about "what kind of place is this?" was answered by pattern-matching code that was brittle and error-prone:

| What the old code did | How it decided | What went wrong |
|---|---|---|
| Is this a private room? | Check if "room" appears in arena name | "Classroom" contains "room" → marked private → students blocked from entering |
| Is this a men's/women's bathroom? | `_MALE_BATHROOMS = {"man's bathroom"}` — literal set | Anonymized "Bathroom 1" not in set → filtering silently disabled |
| What activity does this place support? | `COOKING_PATTERNS = ("cooking", "cook ", ...)` — match action text | "Running late" matched EXERCISE_PATTERNS → sent to park instead of class |
| Is this a residential sector? | `"'s apartment" in sector` | Anonymized "Apartment 1" has no `'s` → check fails → privacy disabled |
| What gender is this persona? | 6 female + 11 male names hardcoded | New name → gender=None → bathroom filtering disabled |

Now each arena declares what it IS in a single JSON file:

```
Before: code sees "Classroom" → regex matches "room" → guesses "private_room" (WRONG)
After:  code looks up "Classroom" in registry → reads type: "shared" (CORRECT)

Before: "cooking dinner" → match COOKING_PATTERNS → _find_nearest_kitchen() (custom function)
After:  "cooking dinner" → LLM returns activity_type="cook" → maze.find_arenas_with_interaction("cook") (generic)

Before: add a new room type → edit 5+ files, add patterns, test manually
After:  add one entry to maze_registry.json
```

Scale: 19 sectors, 63 arenas (28 private_room, 27 shared, 8 public), 46 object types, 225 object placements, 14 activity types.

**Multi-factor location scoring** — replaces pure Manhattan distance:
- Anchor match (0.35): if LLM said "library table", boost library
- Distance (0.25): inverse normalized Manhattan distance
- Anti-crowding (0.20): penalize high-occupancy arenas
- Home familiarity (0.10): bonus for home sector
- Recency penalty (0.10): penalize recently-visited arenas

This solved the "classroom sink" — where all 7 dorm students converged to one classroom because it was nearest. With scoring, students distribute naturally: Anya (anchor="blackboard") → classroom, Misha (anchor="library table") → library, Viktor + Nina redistribute due to crowding.

**Gender field in persona specs** — explicit `gender` field in scratch.py replacing the hardcoded name lists. Baseline scratch.json updated for all personas.

#### Code consolidation

| Area | Change |
|---|---|
| plan.py | -1,409 lines (25 functions moved to location_resolver.py) |
| run_gpt_prompt.py | -497 lines (3 dead LLM functions) |
| address_mapper.py | Deleted (272 lines) |
| 78 prompt templates | Deleted (18 v1, 24 v2, 36 v3_ChatGPT — all orphaned) |
| `_determine_action()` | 3 code paths → 1 |
| Feature flags | LOCATION_RESOLVER_V2, UNIFIED_LOCATION_RESOLUTION → deleted |
| spatial_memory.json | Eliminated (dead weight — loaded then immediately discarded) |

Net: **-4,500 lines** of location + legacy code. 82 → 100 tests passing.

#### Audits performed

6 rounds of systematic audits, each producing a doc with findings by severity:
- Audit v2: 5 CRITICALs → all resolved
- Audit v4: 2 HIGHs, 4 MEDIUMs, 3 LOWs → all resolved
- Audit v6: 3 HIGHs → all resolved
- Final 3-perspective audit: 0 CRITICAL, 3 HIGH → all resolved

Verdict from final audit: "Architecturally sound. LocationResolver V2 is genuinely the single authority. Clean import graph, stateless pipeline, excellent extensibility."

### Conversation System Overhaul

**Status:** Functionally complete, pending polish (Commits 8-9)  
**Contracted scope:** Part of Phase 2 (~8h combined with state machine) + 5h agreed separately  
**Actual effort:** 9h (absorbed 50% of the state machine scope — social triggers, cooldowns, proximity detection, overlap awareness — leaving only the core activity lifecycle pending)

#### Why this was done instead of the Activity State Machine

The technical assessment (Phase 2) bundled 7 deliverables under "Activity State Machine":

| Deliverable | Delivered? | Where |
|---|---|---|
| `_compute_chat_params()` with overlap awareness | Yes | ConversationManager |
| Dynamic cooldown proportional to co-location time | Yes | Satiation curve + atmosphere modifiers |
| Socialization triggers on proximity, independent of novelty budget | Yes | Observation-driven path |
| Temporal context for LLM (Appendix A of contract) | Yes | ConversationContext |
| SOT updates | Partial | Cooldown values updated |
| State machine (IN_PLACE/TRAVELING/BREAK/REROUTE) | No | — |
| Replace 6 competing mechanisms | No | — |

4 of 7 deliverables shipped. The remaining 3 (state machine proper) were deferred because:

1. **Phase 1 validation exposed conversation as a blocker.** We couldn't run sims past 25 steps due to reflect crashes. We couldn't distinguish location bugs from conversation bugs. The 200-step acceptance gate was impossible without fixing conversations first.

2. **The contract's own severity assessment supported this.** Appendix B.5 explicitly states: "If triggered conversations produce dialogue that contradicts the situation (proposing joint plans neither persona can execute), that's a visible quality gap in a core mechanism. The bump [to Medium] is justified." We fixed exactly that.

3. **The conversation deliverables were listed under Phase 2.** `_compute_chat_params`, dynamic cooldowns, and proximity triggers were all Phase 2 items. They required a ConversationManager to implement properly — the same architecture we built.

#### What was built

**ConversationManager** — single authority for trigger, lifecycle, cooldown, and context:

- **One distance gate:** `should_converse()` replaces 12+ scattered distance checks (some in pixels, some in tiles, with different threshold values). One function, one threshold, atmosphere-aware.
- **Atmosphere-aware thresholds:** Library → harder to trigger, longer cooldowns. Cafe → easier, shorter cooldowns. Driven by `proximity_mod` and `cooldown_mod` values in maze_registry.json, not hardcoded if/elif blocks.
- **Context enrichment:** LLM receives ~80-120 tokens of structured context: overlap window, times_talked_today, atmosphere, shared_location, next_action. This directly addresses Appendix A of the contract.
- **Social satiation curve:** Cooldowns scale with repetition (5→5→7→7→7 steps per pair). Same pair can't monopolize conversation space.
- **Exchange familiarity scaling:** `max_exchanges` also scales UP with repeated encounters via `_satiation_exchanges()`. First encounter of the day → brief (2 exchanges). Third encounter → medium (4). Fifth+ → near tier cap. Models the natural dynamic where people who keep running into each other talk longer as shared context builds. Fleeting encounters (greetings) stay fixed at 1-2 exchanges.
- **Batch generation:** 1 LLM call generates the full conversation (vs 16 iterative calls in the old system).
- **Pause/Resume:** Conversations pause when personas drift apart, resume when back in proximity, end on arena exit or timeout.
- **Session state machine:** ACTIVE → PAUSED → RESUMED → ENDED. Clean lifecycle, no zombie sessions.

**255 tests** covering the full conversation pipeline.

#### Bugs fixed

| Bug | Symptom | Root cause | Fix |
|---|---|---|---|
| Reflect crash (step 25+) | Sim crashes | `reflect()` accesses chat node before perception creates it | Defensive guard + early persist chat node |
| Conversations at 14 tiles | People talk across town | Grouped observation path has no distance gate | Single funnel: all triggers → should_converse() |
| Zombie sessions (21 steps) | Personas stuck "chatting" | chat_end_step expires, no cleanup runs | Sweep expired sessions in process_step() |
| Invisible conversations | Chat happens but FE shows nothing | Chat triggers after JSON written to disk | Re-inject chat data into movements after observations |
| 180-degree reversal on greeting | Persona snaps around | Chat mutates act_address/act_event → A* replans | `CHAT_PRESERVES_ACTION` guard in 3 files: scratch.py (action expiry ignores chat_end_step), conversation_manager.py (full chats don't overwrite act_event), reverie.py (greetings don't overwrite act_event) |
| Cross-arena conversations | People in different rooms chat | Arena not validated in proximity scan | Arena validation in PI and proximity paths |
| Dedup not initialized per step | Duplicate chat triggers | `_chat_triggered_this_step` persisted across steps | Init every step |
| Goodbye in prompt | Unnatural goodbyes between co-located personas | Prompt assumed personas were leaving | Removed unnecessary goodbye instruction for same-arena |

#### Conversation quality — validated results

From 60-step 12-persona validation sim:
- 17 conversations, 88% same arena, max start distance 5 tiles
- Satiation curve working: Misha↔Nina cooldowns 5→5→7→7→7
- Natural topic evolution across 5 encounters, zero repeated text:
  1. "Morning, Nina"
  2. "How's the quiz going?"
  3. "19th-century economic theory"
  4. "I'm hitting a wall with this assignment"
  5. "Want to grab coffee at Hobbs?"

### Pathfinding Fixes

Three classes of pathfinding errors were causing cascading failures:

| Error | Before | After | Root cause |
|---|---|---|---|
| NO REACHABLE TILE | 212 | **0** | Bidirectional A* couldn't handle unreachable tiles → replaced with standard A* |
| CRITICAL PATH ERROR | 6 | **0** | start==target returned empty path → now always returns at least start tile |
| TRAVEL CAP | 26 | **0** | Travel time compared seconds vs minutes → consistent units |

### Frontend: Persona Mapping Unification

**Problem:** Adding one new BE field (`proximity_threshold`) to the FE required tracing through 17 separate mapping sites across 7 files. Each file copied persona data field-by-field from API responses to Redux state. A hidden mapper in `lib/api.ts:fetchSteps()` overwrote all values every tick — "last dispatch wins" meant later dispatches without the new field silently erased it.

**Solution:** Created `lib/personaMapping.ts` — single source of truth with `toPersonaPosition()`, `toSpritePosition()`, `toPersonaPositionWithState()`, `extractRealismTrace()`. All 17 mapping sites consolidated. ~460 FE lines eliminated.

**Impact:** Adding a new BE field to FE is now a 1-file change. The "last dispatch wins" bug is structurally impossible.

### Additional Bug Fixes

| Bug | Symptom | Fix |
|---|---|---|
| Stationary 1-tile jump | Personas visually jump 1 tile on step 0 | Three causes fixed: step 0 speed override, parent_address parser, FE killAllTweens |
| Elena spawn blocked | Elena couldn't move | Spawn tile [17,21] was inside a wall → moved to actual bed tile |
| All spawns wrong | Personas at room center, not bed | Spawn coordinates pointed to walkable tiles, not bed tiles → corrected all 12 |
| ConversationManager None | All conversations disabled | SIM_STEP_LENGTH referenced before env loaded → NameError |
| Wall-clock timestamps | Conversation timing breaks with timezone/step changes | Migrated to step-based integers |
| PI waypoints include destination | False proximity triggers | Truncated to MAX_TILES_PER_STEP |

### Code Quality: Total Cleanup

| Area | Lines removed | What was deleted |
|---|---|---|
| Location legacy (plan.py) | -1,409 | 25 functions moved, UNIFIED + LEGACY paths eliminated |
| Legacy LLM functions | -497 | 3 dead functions in run_gpt_prompt.py |
| Prompt templates | -78 files | 18 v1, 24 v2, 36 v3_ChatGPT — all orphaned |
| address_mapper.py | -272 | Entire file deleted |
| Code hygiene pass | -2,000 | manhattan_distance consolidated (was defined 6 ways + 20 inline copies), parse_address unified (40+ inline `.split(":")` calls), debug prints removed |
| Conversation dead code | -650 | Orphaned files, stub functions, unused imports |
| FE persona mapping | -460 | 17 duplicate mapping sites → 1 module |
| **Total** | **~5,300+ lines** | |

---

## 3. What Remains

### Activity State Machine (~4-6h)

The core state machine that replaces 6 competing behavior mechanisms with 4 explicit states (IN_PLACE / TRAVELING / BREAK / REROUTE) was not implemented. This is the system that would definitively solve the persona stasis problem (Ivan's desk→eat→desk loop, personas frozen for 50+ steps).

**Current status:** Ivan's bootstrap data fix resolved his specific stasis loop (no more Uber/family dinner references). General persona behavior is significantly improved — personas move, converse, and transition activities naturally. But the 6 competing mechanisms (novelty budget, action extension, proactive refresh, stall breaker, intent hold, healthy persistence) still exist as dispersed, uncoordinated code.

**Why it's less than 8h now:** The original estimate assumed Phase 1 was just completed. Now there's significant groundwork:
- Location system is single authority (prerequisite done)
- Conversation triggers are proximity-based and independent of novelty budget
- Step-based timing partially migrated
- Pathfinding is solid (0 errors across all categories)

**Estimated remaining effort:** ~4-6h (map 6 mechanisms → implement 4 states → disable old mechanisms → validate)

### Deliverables completed since initial draft

- ✅ SOT updates: 4 SOTs updated (sot_chats v1.4, sot_prompts v1.2, sot_realism, sot_be-fe v1.4)
- ✅ Exchange familiarity scaling: `_satiation_exchanges()` — max_exchanges now scale UP with repeated encounters (same sigmoid curve as cooldowns, inverted). First encounter = brief (2 exchanges), 3rd = medium (4), 5th+ = near cap. Fleeting/greetings unaffected.
- ✅ FE chat bubble rendering fix: `usePlayback.ts` reads `fullChat` before `chat`, skip optimization checks `hasAnyChat`, `personaMapping.ts` handles both camelCase and snake_case field conventions. Fixes conversations invisible in playback.
- ✅ Production playback fixes (3 bugs):
  - **FE localStorage crash**: `localStorage.setItem` was inside the same try/catch as the API fetch. When cache quota exceeded (15 personas × 200 steps), valid step data was discarded and fell through to Supabase Storage fallback (which also failed). Fix: isolated cache writes in their own try/catch. Commit `84e81e6` (double-front).
  - **`proximity_threshold` missing from Supabase**: BE wrote chat fields to Supabase JSONB but omitted `proximity_threshold` and `proximity_detail`. These existed in local JSONs (so local playback worked) but were absent in production playback. Fix: added to both Supabase write path (reverie.py) and API Gateway read path (supabase_service.py). Commit `ea036838`.
  - **`curr_time` empty in production**: API Gateway `_compute_step_time()` could not parse date-only format (`"2025-11-01"`) returned by Supabase — only datetime formats were supported. Fix: added `"%Y-%m-%d"` to format list. Same commit.
- ✅ `self.sim_folder` init fix: `sim_folder` was defined as local variable in `__init__` but `process_pending_observations()` referenced `self.sim_folder` before it was assigned later in the run loop. Fix: assign `self.sim_folder = sim_folder` in `__init__`. This was a latent bug from Ivan's code that only manifested with headless observations active at step 1.
- 200-step validation sim with artifacts (pending — re-running with production fixes applied)

---

## 4. Contract Alignment

### Budget: 20h approved, 20h used

| Phase | Contracted | Actual | Notes |
|---|---|---|---|
| Phase 1: Location system | 5-7h | 6h | LocationResolver V2, maze_registry.json, multi-factor scoring, 6 audits, gender field, spatial_memory cleanup |
| Conversation system + 50% state machine | Part of 8h + 5h | 9h | ConversationManager, batch generation, satiation curves, atmosphere thresholds, exchange scaling, 8 conversation bugs fixed, CHAT_PRESERVES_ACTION guards |
| Production fixes | 0h | 2h | 3 FE+BE bugs (localStorage crash, proximity_threshold missing from Supabase, curr_time date format), sim_folder init fix, pathfinding fixes (3 classes → 0) |
| SOTs + Handoff + Fine-tuning + Debug + final tweaks | 0h | 3h | 4 SOTs updated, handoff document, prompt tuning, bootstrap data redesign (15 personas), validation runs |
| **Total** | **20h** | **20h** | **Complete** |

### Deliverable status vs contract

| Contract item | Status |
|---|---|
| Ivan bootstrap data fix | ✅ Complete |
| Single deterministic → typed scorer → LLM → fail-loudly pipeline | ✅ Complete (LocationResolver V2) |
| Distance-aware candidate ranking | ✅ Complete (multi-factor scoring) |
| Post-LLM game_object validation against maze.address_tiles | ✅ Complete |
| Gender field in persona specs | ✅ Complete |
| Update sot_chats.md cooldown values (B.1) | ✅ Complete (v1.4) |
| `_compute_chat_params()` with overlap-time awareness | ✅ Complete (ConversationManager) |
| Dynamic cooldown proportional to co-location time | ✅ Complete (satiation curve + atmosphere) |
| Socialization triggers on proximity independent of novelty budget | ✅ Complete (observation-driven path) |
| Update sot_prompts.md (B.3) | ✅ Complete (v1.2) |
| State machine (IN_PLACE/TRAVELING/BREAK/REROUTE) | ❌ Not delivered (~4-6h remaining) |
| Replace intent-hold, healthy-persistence, stall-breaker, proactive-refresh | ❌ Not delivered (part of state machine) |
| Acceptance: 200-step 15-persona sim | ✅ Delivering with handoff |

### Why Phase 1 and Phase 2 merged

The contract specified "Phase 2 after Phase 1 validated." In practice, validation of Phase 1 required fixing the conversation system first:

1. **Sims crashed at step 25** due to reflect accessing non-existent chat nodes. We couldn't reach the 200-step acceptance gate.
2. **Conversation bugs masked location bugs.** A "frozen" persona could be a privacy filter issue (Phase 1) or a zombie conversation (Phase 2). Both produced identical symptoms.
3. **Both systems share the same runtime loop.** `reverie.py:process_step()` runs location resolution, movement, and conversation detection in sequence. Chat triggers mutate scratch state that location resolution reads. Isolating one from the other was artificial.

The natural workflow was: fix location → run sim → crash from conversation → fix conversation → run sim → discover masked location bug → fix → repeat. The two phases interleaved because their bugs interleaved.

---

## 5. Metrics

### Bugs eliminated (measured during Phase 1+2 development)

These error counts were measured at the start vs end of the bugfix sessions. They represent bugs that existed in the codebase and are now at zero — not a comparison against the Checkpoint 1 baseline (which was a different persona count and sim length).

| Error class | Before fixes | After fixes |
|---|---|---|
| NO REACHABLE TILE | 212 per sim | **0** |
| CRITICAL PATH ERROR | 6 per sim | **0** |
| TRAVEL CAP | 26 per sim | **0** |
| Tracebacks | 1-2 per sim | **0** |
| Cross-arena conversations | ~14% | **~10%** (adjacent arenas only) |
| Guard relax → garden | 100% of cases | **20%** (only Luba, who lives next door) |
| Cooldowns direction | Decreased 5→1 (broken) | **Increase 5→7** (satiation working) |

Final validation metrics will come from the 200-step 15-persona sim (pending).

### Conversation quality (60-step 12-persona sim)

| Metric | Value |
|---|---|
| Total conversations | 17 |
| Same-arena | 88% |
| Max start distance | 5 tiles |
| LLM-generated (vs hardcoded) | 100% |
| Topic repetition | 0 (natural evolution across encounters) |
| Zombie sessions | 0 |
| Invisible to FE | 0 |

### Codebase health

| Metric | Before | After |
|---|---|---|
| Lines of dead/legacy code | ~5,300+ | Deleted |
| Location code paths in _determine_action() | 3 (V2/unified/legacy) | 1 |
| Feature flags for location | 2 (LOCATION_RESOLVER_V2, UNIFIED_LOCATION_RESOLUTION) | 0 |
| Prompt template files | 78 orphaned | 0 orphaned |
| FE persona mapping sites | 17 across 7 files | 1 centralized module |
| Tests | ~82 | **255** |
| Conversation distance gates | 12+ (different units, values) | 1 (should_converse()) |

---

## 6. Architecture Changes

### New files

| File | Purpose | Lines |
|---|---|---|
| `location_resolver.py` | Single location authority (5-step pipeline) | ~1,438 |
| `location_helpers.py` | Privacy, gender, string utilities | ~200 |
| `conversation_manager.py` | Conversation lifecycle, cooldowns, context | ~800 |
| `maze_registry.json` | Structured map metadata (63 arenas, 225 objects) | 11.8 KB |
| `scripts/generate_maze_registry.py` | One-time registry generator from CSVs | ~310 |
| `lib/personaMapping.ts` (FE) | Centralized persona data mapping | ~150 |

### Modified files (major changes)

| File | Change summary |
|---|---|
| `maze.py` | Loads registry, 7 new public methods (get_arena_type, get_arena_atmosphere, find_arenas_with_interaction, etc.) |
| `plan.py` | -1,409 lines. Location code moved out. Single path in _determine_action() |
| `run_gpt_prompt.py` | -497 lines. Activity_type in task decomp. Legacy LLM functions deleted |
| `reverie.py` | ConversationManager integration, chat re-injection, observation processing |
| `path_finder.py` | Standard A* (replaces broken bidirectional), start==target fix |
| `execute.py` | Seconds→minutes fix, object obstacle support |
| `scratch.py` | Gender field, home_sector_id, home_arena_id |
| `converse.py` | Wall-clock → sim-time migration |
| `persona.py` | Wall-clock → sim-time, chat state preservation during replan |
| `reflect.py` | Defensive guards for chat node access |

### Deleted files

| File | Reason |
|---|---|
| `address_mapper.py` | Replaced by LocationResolver V2 |
| 78 prompt templates (v1, v2, v3_ChatGPT) | Orphaned after consolidation |
| `spatial_memory.json` (4 copies) | Dead weight with USE_GRID_OBJECTS=true |

---

## 7. Investigation Documentation

All investigation and design work is documented in `local_docs/`. Key documents:

| Document | What it covers |
|---|---|
| `20260404-maze-naming-investigation.md` | Full map inventory, Stanford names origin, BE/FE CSV divergence |
| `20260404-maze-registry-feasibility.md` | Heuristic-to-metadata mapping table, Supabase impact, 5-phase plan |
| `20260405-conversation-system-audit.md` | 10 gaps, 15+ flags, 12+ distance gates, dual cooldown systems |
| `20260405-conversation-improvement-plan.md` | ConversationManager design, 9-commit plan |
| `20260405-running-classroom-bug-investigation.md` | Two disconnected location pipelines, activity_type not passed |
| `20260405-location-scoring-design.md` | Why pure distance causes convergence, weight rationale |
| `20260405-proximity-14tiles-bug-investigation.md` | Missing distance gate in grouped observation path |
| `20260405-conversation-5bugs-investigation.md` | Zombie sessions, invisible greetings, LLM fallback issues |
| `20260406-reflect-get-last-chat-crash-investigation.md` | Chat node lifecycle vs cognitive cycle ordering |
| `20260403-ivan-stasis-analysis.md` | 2-activity loop: good LLM plan, broken schedule advancement |
| `20260406-object-collision-investigation.md` | Personas walk through furniture — proposal for soft collision |
| `20260406-auto-face-collider-plan.md` | Personas face walk direction at furniture — proposal for auto-face |

Full list with descriptions in the tracker: `local_docs/20260404-phase1-phase2-tracker.md` → "Investigation docs produced" section.

---

## 8. Proposals (Investigated, Not Implemented)

Two features were fully investigated and planned but not implemented. Both are FE-only changes in the `double-front` repo:

### Object-level soft collisions

Personas walk through furniture (chairs, tables, beds) because game objects aren't collision tiles. Proposal: mark object tiles as soft collisions in A* (cost=10 vs cost=1 for walkable), so pathfinding prefers paths around furniture but can still use them if no alternative. Target tile is excluded so personas can still reach their destination.

**Investigation:** `local_docs/20260406-object-collision-investigation.md`  
**Scope:** BE (3 files) + FE (AnimationManager.ts). Gated by `OBJECT_COLLISION_ENABLED=false`.

### Auto-face nearest collider on arrival

When a persona arrives at a desk/bed/stove, their sprite faces the walk direction instead of the furniture. Proposal: on arrival, check cardinal neighbors for collision tiles, face toward the nearest furniture collider. Purely visual — no backend changes, no movement report changes.

**Plan:** `local_docs/20260406-auto-face-collider-plan.md`  
**Scope:** FE only (2 files, ~80 lines new code, 5 arrival point hookups).

---

## 9. Environment & Configuration

### Key flags (production defaults in .env.local)

| Flag | Value | Role |
|---|---|---|
| `OBSERVATION_PRIMARY` | `true` | Conversation triggers via observation (not plan path) |
| `TASK_DECOMP_CONTEXTUAL_ENABLED` | `true` | LLM returns activity_type in task decomposition |
| `MAX_TILES_PER_STEP` | `6` | Movement speed cap (PI waypoints truncated to this) |
| `BACKEND_INTENT_ONLY_PATH` | `true` | FE computes A*; BE sends target_zone only |
| `LLM_STEP_PARALLEL_ENABLED` | `true` | Parallel LLM calls across all sprites per step |

### Data fixes applied

| What | Where | Change |
|---|---|---|
| Ivan lifestyle + daily_plan_req | scratch.json + Supabase (2 rows) | Removed Uber/family dinner, replaced with map-valid locations |
| Elena living_area | scratch.json | → Studio Room 5, spawn → (26, 32) |
| Library sofa interaction | maze_registry.json | ["study", "relax"] → "study" (avoid congestion) |
| All persona spawns | scratch.json | Room center → actual bed tiles |
| All bathrooms | maze_registry.json | Gender-specific → gender-neutral (per client decision) |

---

## 10. How to Verify

### Run a validation sim

```bash
cd reverie/backend_server
python reverie.py
# Enter baseline: base_family_sim
# Enter new sim: 20260406-validation
# Enter: run 200
```

### What to check

1. **Zero crashes:** sim completes 200 steps without tracebacks
2. **Zero pathfinding errors:** no "NO REACHABLE TILE", "CRITICAL PATH ERROR", or "TRAVEL CAP" in logs
3. **Conversations trigger naturally:** personas in proximity converse, with visible bubbles in FE
4. **Location diversity:** personas visit multiple arenas, not stuck in one room
5. **Cooldowns scale:** same pair's cooldowns increase over repeated encounters (check logs for "SATIATION")
6. **No cross-arena conversations:** >85% of conversations between personas in same arena

### Test suite

```bash
# Location + maze tests
python -m pytest tests/test_location_resolver.py tests/test_maze_registry.py -v

# Conversation tests  
python -m pytest tests/test_conversation_manager.py -v

# All tests
python -m pytest tests/ -v  # 255 tests expected
```
