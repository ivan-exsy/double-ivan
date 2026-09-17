# Technical Assessment: Structural Limitations & Proposed Path

**Date:** 2026-04-01  
**Updated:** 2026-04-03 (post-Checkpoint 1 status review)  
**Branch:** `integration/20260330-local-hardening-rebuild`  
**Context:** This document captures the structural issues found during diagnostic work on the 4 reported bugs. It's not part of the committed scope — it exists to inform decisions about next steps after Checkpoint 1.

---

## TODO (approved 2026-04-04, validated against 15-persona sim `20260404-2-15person`)

### 0. Ivan bootstrap data fix — <0.5h
Update `scratch.json` to remove impossible activities ("drives for Uber", "family dinner"). Runtime should handle unresolvable activities gracefully instead of desk-trapping.
- [ ] Fix bootstrap data
- [ ] Acceptance: Ivan completes a full daily cycle (100+ steps) without getting stuck in a loop

### 1. Phase 1 — Unified location system — 5-7h
Consolidate 12 resolution steps / 6 fallbacks / 2 repair passes into single `LocationResolver`. See section 3 for design.
- [ ] Single deterministic → typed scorer → LLM → fail-loudly pipeline
- [ ] Distance-aware candidate ranking (fixes "kitchen" for coworking, bathroom 130 tiles away)
- [ ] Post-LLM game_object validation against `maze.address_tiles`
- [ ] Gender field (Phase 3, ~1h, batch here)
- [ ] Update `sot_chats.md` cooldown values to match code (B.1) before any cooldown work
- [ ] Acceptance: 200-step 15-persona sim with zero silent fallback degradations, all resolutions traceable to source

### 2. Phase 2 — Activity State Machine — ~8h (after Phase 1 validated)
Replace 6 competing behavior mechanisms with 4 explicit states (IN_PLACE / TRAVELING / BREAK / REROUTE). See section 3 for design.
- [ ] State machine replaces intent-hold, healthy-persistence, stall-breaker, proactive-refresh
- [ ] `_compute_chat_params()` with overlap-time awareness (Appendix A)
- [ ] Dynamic cooldown proportional to co-location time
- [ ] Socialization triggers on proximity independent of novelty budget
- [ ] Update `sot_chats.md` (B.1) and `sot_prompts.md` (B.3) in same PR
- [ ] Acceptance: 200-step 15-persona sim where no persona is frozen >30 steps without a BREAK transition, and co-located pairs converse more than once per 20-step window

---

## 1. Checkpoint 1 status (updated 2026-04-03)

Checkpoint 1 delivered 6 fixes (4 scoped + 2 additional). Validation sim `20260403-3` (200 steps, 4 personas) confirms all 4 original regressions are resolved. Code verified on remote branch `origin/integration/20260330-local-hardening-rebuild` (12 commits, April 2-3).

| Fix | Status | What was done | What it doesn't address |
|-----|--------|---------------|------------------------|
| A — Greeting escalation | **Done** | Counter-based promotion in `reverie.py`: after 1 greeting, next trigger promotes to full chat | Chat state still fragmented across 3 files with no single owner |
| B — Wrong bed | **Done** | `_is_private_room` / `_is_private_sector` propagated to all 3 resolution paths + action contract rejection | Multiple competing resolution paths still exist — no single authority |
| C — Duration overflow | **Done** | Travel feasibility cap to maze physical limits in `_determine_action` | Cap is targeted (travel branch only), not a universal post-condition on all decomp paths |
| D — Social descriptions | **Done** | Two-layer: prompt rules across 4 templates + runtime `_strip_social_refs()` at planning layer | No emit-point guard in `reverie.py` — if something slips past planning filter, no last-line defense |
| E — Object relocation (bonus) | **Done** | Settlement override + zero padding for object-level zones + stationary recovery | N/A — was out of original scope |
| F — Greeting bubble (bonus) | **Done** | `per_message_duration` for greetings with 6s floor in `persona.py` | N/A — was out of original scope |

These fixes hold for the current sim configuration (4 personas, 200 steps, this baseline). They become fragile when:
- Runs get longer or more complex (state pollution accumulates)
- More personas are added (more competing state, more proximity edge cases)
- Prompts or LLM providers change (different fallback paths activate)
- The codebase evolves (patches depend on current code paths remaining stable)

---

## 2. The root cause: competing subsystems (PENDING — not addressed by Checkpoint 1)

The backend has two structural problems that produce most of the bugs. Checkpoint 1 patched symptoms within these systems but did not simplify them.

### Problem A — Location resolution has no single authority (PENDING)

There are currently 12 resolution steps with 6 fallbacks and 2 repair passes in the location pipeline. Each fallback produces slightly different output shapes, durations, and label quality. When the primary path fails, the system silently degrades through cascading fallbacks instead of failing cleanly.

| Sub-issue | Status | Notes |
|-----------|--------|-------|
| Ivan wakes up in someone else's bed | **Fixed** (Checkpoint 1, Item B) | Privacy filter propagated to all 3 paths |
| Duration overflows to 1000+ minutes | **Fixed** (Checkpoint 1, Item C) | Travel feasibility cap — targeted, not universal |
| "blackboard" resolves for wrong room | **Pending** | No post-LLM game_object validation against `maze.address_tiles` |
| "garden" wins over "Johnson Park" for running | **Pending** | Distance-blind candidate ranking — same root cause as Luba→Studio Bathroom in 20260403-3 |
| 12 steps / 6 fallbacks / 2 repair passes | **Pending** | Structural complexity unchanged |

### Problem B — 6 behavior mechanisms contradict each other (PENDING)

**Entirely pending.** Checkpoint 1 did not touch this area.

| Mechanism | Purpose | Side effect |
|-----------|---------|-------------|
| P2 novelty budget | Save LLM calls on routine steps | Suppresses reaction evaluation on 94-97% of steps |
| Action extension | Keep actions coherent without LLM calls | Actions that never expire (start_time resets on each extension) |
| Proactive refresh | Force-expire after 20 steps | LLM returns same action → noop loop |
| Stall breaker | Detect stuck personas, force replan | Bypassed by "healthy persistence" in almost all cases |
| Intent hold | Prevent 1-2 tile jitter between steps | Infinite hold that freezes position for 40+ steps |
| Healthy persistence | Protect legitimate stationary work | Protects everything, including real stalls |

Each is reasonable in isolation. Together they create emergent deadlocks. A persona studying at a desk can get stuck for 50+ steps because intent hold freezes position, healthy persistence blocks the stall breaker, and the novelty budget suppresses any social evaluation.

This is why the system degrades over long runs: the mechanisms accumulate stale state and eventually deadlock each other.

---

## 3. Proposed path (if you want to go deeper)

### Phase 1 — Unified system (5–7 hours) — NOT STARTED

Consolidate location resolution, decomp, and proximity detection into a single coherent system:

| Current state | Unified system |
|---------------|---------------|
| 12 resolution steps with 6 fallbacks | Single `LocationResolver`: deterministic → typed scorer → LLM → fail loudly |
| Decomp fallback cascade that silently degrades | One decomp path that succeeds or emits a clear error |
| Social labels generated speculatively, proximity checked after emission | Proximity pre-computed before emission; labels assigned only when confirmed |

Design principles:
- **Single authority per decision.** One code path for location, duration, and social labels. No cascading.
- **Fail loudly.** Structured errors instead of silent degradation. Same philosophy as FE.
- **Full traceability.** Every resolved value logs its source.

Think of it like the `AnimationManager` on the FE side: hard work upfront, but once it exists, every decision flows through one coherent system instead of multiple competing handlers.

This phase would also naturally absorb the **distance-aware candidate ranking** gap identified in Checkpoint 1 (Luba→Studio Bathroom instead of Dorm bathroom).

### Phase 2 — Activity State Machine (~8 hours) — NOT STARTED

Replace the 6 competing behavior mechanisms with 4 explicit states:

```
                  action requires          
    IN_PLACE ──── new destination ────► TRAVELING
   (sitting,  ◄── arrived at target ──  (walking
    cooking,                             toward
    studying)                            destination)
        │                                    │
        │ 30+ steps                          │ blocked > 3 steps
        │ without break                      │
        ▼                                    ▼
      BREAK                              REROUTE
   (2-5 steps:                          (recalculate
    stand up,                            path)
    stretch)
```

`SOCIALIZING` is orthogonal — triggers on proximity in any state, independent of novelty budgets.

Key decisions:
- `IN_PLACE` is stationary by definition — no intent hold needed
- `BREAK` is deterministic, not LLM-driven (2-5 steps, small movement)
- Socialization triggers on proximity, not novelty budget
- `TRAVELING` computes next tile from A* path each step — no intent hold

Phase 1 is a prerequisite: it stabilizes the data flow that the state machine depends on.

This phase would also naturally absorb the **conversation temporal context** and **dynamic cooldown** gaps identified in Checkpoint 1.

### Phase 3 — Gender field in persona specs — NOT STARTED

Ivan approved adding an explicit `gender` field to replace the current name-based heuristic (`_infer_persona_gender`). This is deferred to after Phase 1 because the current codebase has multiple resolution paths — adding gender now means threading it through each path independently. After Phase 1, it's one field in one resolver.

---

## 4. Investigation axes (PENDING)

Open questions that would be answered during Phase 1:

- **Game object validation inconsistency.** Why does "desk" resolve correctly for Dorm Room 2 but "blackboard" doesn't? Both come from the LLM, neither is validated against `maze.address_tiles` post-resolution.

- **Location candidate ranking.** When multiple locations match semantically (garden vs. Johnson Park for running), how should the system rank them? Distance, specificity, persona preference, action-type affinity?

---

## 5. New issues surfaced during Checkpoint 1

These were not in the original assessment but emerged from the `20260403-3` validation sim:

| Issue | Severity | Where it fits | Fix direction |
|-------|----------|---------------|---------------|
| **Ivan's bootstrap data** — `scratch.json` references impossible activities ("drives for Uber", "family dinner") causing desk-trap loop | High (1/4 personas broken) | Quick fix (independent) | Update `scratch.json` to map-valid activities; runtime should handle unresolvable activities gracefully |
| **Distance-blind location ranking** — Luba sent to Studio Bathroom (~130 tiles) instead of Dorm bathroom (~5 tiles) | Medium | Phase 1 (`LocationResolver`) | Distance-aware candidate ranking |
| **Conversation temporal context** — chats don't know how long personas will overlap | Medium (bumped, see Appendix B.5) | Phase 2 (State Machine) | `_compute_chat_params()` with overlap-time awareness. See Appendix A. Requires sot_prompts.md update (Appendix B.3). |
| **Arbitrary 20-step cooldown** — personas in same space 50+ steps converse only once | Medium (bumped, see Appendix B.5) | Phase 2 (State Machine) | Dynamic cooldown proportional to co-location time. See Appendix A. Requires sot_chats.md update first (Appendix B.1). |

---

## 6. Estimates summary

Each phase is a checkpoint. No phase starts without your approval.

| Phase | Hours | Prerequisite | Status |
|-------|-------|-------------|--------|
| Checkpoint 1 (committed) | ~5h | None | **Done** (6/6 items, validated in 20260403-3) |
| Ivan bootstrap data fix | <0.5h | None | **Pending** — quick win, immediate impact |
| Phase 1 — Unified system | 5–7h | Checkpoint 1 | **Not started** |
| Phase 2 — Activity State Machine | ~8h | Phase 1 | **Not started** |
| Phase 3 — Gender field | ~1h | Phase 1 | **Not started** |
| **Remaining if all phases approved** | **~15h** | | |

---

## Appendix A — Conversation temporal context gap (detail)

**Suggestion: consider bumping severity to Medium.** This is the most visible gap for the end user — conversations sound natural in isolation but don't match the situation.

### What happens now

When two personas are in proximity (≤3 tiles), the system triggers a conversation with zero context about:
- How long they'll be together (overlap steps remaining)
- What they're doing (current activity, next planned activity)
- Their distance (exact tiles apart)
- Shared location context (same room, same arena)

### Observable symptoms (from sim 20260403-3)

- **Step 15:** Gosha and Katya have a full conversation at the library. The LLM generates dialogue where they propose going to Hobbs Cafe together and Gosha says he'll "lead the way." Then both stand in silence for 8 steps because neither persona's schedule includes going to the cafe.
- **Step 94+:** Personas at Hobbs Cafe converse once then sit in silence for 20+ steps due to the fixed cooldown, even though they're sharing the same table.

### What data is available but not passed to the LLM

All of this is deterministic and available at trigger time from `persona.scratch`:

```json
{
  "persona_a": "Katya Pistsova",
  "persona_b": "Gosha Pistsov",
  "distance_tiles": 1,
  "shared_location": "the Ville:Oak Hill College:library",
  "persona_a_remaining_steps": 18,
  "persona_b_remaining_steps": 22,
  "overlap_steps": 18,
  "persona_a_next_action": "order brunch at Hobbs Cafe",
  "persona_b_next_action": "continue studying"
}
```

With this context the LLM could generate: "Nice sketches! I need to keep studying, but enjoy your brunch later" instead of "Let's go to the cafe together!"

### Design direction

A `_compute_chat_params(p1, p2, distance)` function that computes `(should_chat, max_exchanges, cooldown)` from deterministic data. Overlap of 18 steps → longer conversation, shorter cooldown. Overlap of 2 steps → brief exchange, longer cooldown. Design documented but not implemented — needs integration with `_attempt_pair_chat()`, testing across multiple sims, and parameter calibration. Estimated 3-4 hours including validation.

### Recommended timing

After Phase 1 (unified system). Implementing on top of a single location authority is cleaner than threading through the current 12-path pipeline. This would add ~3-4 hours to the total estimate (not included in the ~15h table above, which bundles it into Phase 2).

---

## Appendix B — SOT alignment review (added 2026-04-03)

Cross-check of Appendix A proposals and structural findings against normative SOT documents.

### B.1 — Cooldown value discrepancy (sot_chats.md vs code)

`sot_chats.md` (v1.2, updated 2026-04-01) lists:
```
PAIR_CHAT_COOLDOWN_STEPS=15
GREETING_BUFFER_COOLDOWN_MIN=15
```

Actual code (on `integration/20260330-local-hardening-rebuild`):
```
PAIR_CHAT_COOLDOWN_STEPS=20   (reverie.py:382)
GREETING_BUFFER_COOLDOWN_MIN=3 (persona.py:57)
GREETING_COOLDOWN_STEPS=3      (reverie.py:386)
```

The 20260331 hardening pass changed these values (handoff doc explicitly states "Greeting → 3 steps cooldown, Full chat → 20 steps cooldown, GREETING_BUFFER_COOLDOWN_MIN reduced from 20 to 3"). **The SOT was not updated.** Appendix A's reference to "20-step cooldown" matches the code, not the SOT.

**Action required:** Update `sot_chats.md` section 2 env flags to match current code defaults before any further cooldown work.

### B.2 — `_compute_chat_params` alignment

The proposal to compute `(should_chat, max_exchanges, cooldown)` from overlap time is **compatible** with sot_chats.md architecture. The SOT already defines classification inputs as proximity **duration** + **RIR score** (section 3). Adding overlap-step awareness extends the existing classification, it doesn't replace it.

If implemented, `sot_chats.md` section 3 ("Classification inputs") would need updating to include overlap context as a third input alongside duration and RIR.

### B.3 — Context injection into conversation prompts

Appendix A proposes passing `overlap_steps`, `next_action`, and `shared_location` to the conversation LLM. This would affect:
- `run_gpt_prompt_create_conversation` (Tier B)
- `run_gpt_prompt_agent_chat` (Tier B)

`sot_prompts.md` governance rule: _"Any PR that changes prompt flow code must update this SOT in the same PR."_ Neither prompt currently includes temporal context in its input contract. Implementation would require new INPUT slots in the prompt templates and an updated entry in sot_prompts.md with re-verification evidence.

The data Nicolas proposes passing IS available from `persona.scratch` at trigger time — confirmed in code. No new data collection required, only wiring.

### B.4 — Hardcoded greetings observation

The checkpoint update's structural findings state: _"Greeting tier uses hardcoded templates — redundant, the LLM naturally greets in full conversations."_

`sot_chats.md` Appendix A ("Hardcoded Greeting System") explicitly justifies these as a cost optimization: 100% token savings for greetings (~350 tokens/greeting, ~3,500 tokens/hour for 10 greetings). The system is documented as intentional, not accidental.

However, with Checkpoint 1's greeting escalation (promote to full chat after 1 greeting), most encounters now quickly bypass the greeting tier. This reduces the cost savings since the hardcoded path fires at most once per pair before escalation. The token economics argument still holds for first encounters, but is weaker than when the SOT was written. **Not a conflict — the observation is valid context for future simplification, but removing hardcoded greetings is not justified yet.**

### B.5 — Severity bump rationale

Appendix A suggests bumping "Conversation temporal context" and "Arbitrary cooldown" from Low to Medium. `sot_realism.md` section B.4 treats interaction synthesis as a core realism mechanism: _"Conversations are mostly observation-driven... tiered into greeting vs full chat using duration + relevance gates and cooldowns."_ If triggered conversations produce dialogue that contradicts the situation (proposing joint plans neither persona can execute), that's a visible quality gap in a core mechanism. **The bump is justified** — these are user-facing quality issues, not internal plumbing.
