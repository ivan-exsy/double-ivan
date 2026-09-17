# Pass 2: Checkpoint 1 Scope

**Date:** 2026-04-01  
**Branch:** `integration/20260330-local-hardening-rebuild`  
**Baseline:** sim `20260330-1` (180 steps, 4 personas, zero location errors)  
**Budget:** 5 hours, checkpoint before crossing 5h

---

## 1. Items in Scope

### Item A — Greeting → full chat escalation (issue #3)
**Problem:** Proximity-triggered chat works, but escalation from greeting to full conversation doesn't consistently advance. Repeated short greetings between the same pair instead of deeper exchanges.  
**Root cause:** The cooldown system was already fixed in the previous pass (tier-aware cooldowns: greeting → 3 steps, full chat → 20 steps). The remaining issue is in the tier escalation logic itself — after a greeting exchange completes, the next proximity trigger should evaluate at the full-chat tier, but the state that tracks "this pair already greeted" isn't propagating correctly to the chat tier classifier (`classify_chat_tier` in `reverie.py`). The pair re-enters the greeting path instead of advancing. This was working before the cooldown refactor, so the regression point is known.  
**Fix:** Trace the greeting→full chat state transition and ensure the tier classifier sees prior greetings. A state flag that's not being read or is being cleared prematurely.  
**Risk:** Low for the targeted fix — the regression point is known and it doesn't depend on LLM behavior. The underlying chat state fragmentation across multiple files is documented separately.  
**Files:** `converse.py`, `plan.py` (chat evaluation path), `reverie.py` (`classify_chat_tier`)  
**Estimate:** 1–2 hours

### Item B — First-action seed / wrong bed (issue #1)
**Problem:** Ivan's "wake up" resolved to Studio Room 1 (someone else's bed). The `first_action_seeded` code path commits an address before the deterministic guard runs.  
**Root cause:** The first-action seed bypasses the resolution cascade and commits a raw address that may come from stale spatial memory or wrong persona context.  
**Fix:**
- Ensure first-action seed goes through the deterministic guard (sleep → own bed, not arbitrary bed).
- Add observability logging at each location resolution step so we can trace exactly why a value was chosen.
- Make sure the right persona context (living_area, home sector) is available at the point where the first action resolves.

**Files:** `plan.py` (first-action seed path, `_determine_action`), `execute.py` (movement origin)  
**Estimate:** 1–2 hours

### Item C — Duration overflow on decomp failure (issue #2)
**Problem:** When contextual decomposition fails with a ValueError, the fallback path can produce durations of 1000+ minutes.  
**Root cause:** The smart duration cap (commit `ba9a31f`) covers normal paths but not all downgrade/fallback paths. The fallback cascade has multiple exit points and not all of them apply the cap.  
**Fix:** Apply the duration cap as a post-condition — any action emitted by the decomp pipeline gets capped before commit, regardless of which path produced it. Single enforcement point.  
**Files:** `plan.py` (decomp output path)  
**Estimate:** 0.5 hours

### Item D — Social descriptions detached from reality (issue #4)
**Problem:** "chatting with Luba" appears in descriptions when no active `chatting_with` is set.  

**Root cause (two distinct sources):**

1. **Speculative planning** — The LLM generates descriptions like "chatting with Luba" during decomp/planning, before any proximity has been confirmed. The description is set, the persona moves, and the label gets emitted as-is — even if the two personas never end up near each other.

2. **Orphaned chat state** — After a real chat ends, `chatting_with` gets cleared but `act_description` still says "exchanging greetings with X". The description persists after the chat state that justified it is gone.

**Fix:** Add a guard at the emit point (`reverie.py`): if description references chatting/social interaction but `chatting_with` is None, downgrade to a neutral description.  
**Files:** `reverie.py` (emit point), `plan.py` (description generation)  
**Estimate:** 0.5 hours

---

## 2. Explicitly Out of Scope

- Architectural refactors beyond what's strictly required to close the 4 issues above
- Performance optimization (page reuse, LLM call reduction, sim speed)
- New features or behavioral redesigns
- Test porting beyond what's needed to validate the 4 fixes
- Prompt tuning for daily plan quality

---

## 3. Hour Estimates

| Item | Hours |
|------|-------|
| A — Greeting → full chat | 1–2h |
| B — Wrong bed fix + observability | 1–2h |
| C — Duration overflow post-condition cap | 0.5h |
| D — Social description emit guard | 0.5h |
| Validation sim (180 steps) + comparison | included |
| **Total** | **~5h** |

The validation sim runs while I work on the remaining items — it's not a separate time block. If items trend toward the upper range, I'll flag at the 4h mark so we decide together how to handle the remaining time.

**Overrun policy:** If any item trends significantly past its estimate, I'll flag it before investing more time.

---

## 4. Validation Criteria (vs 20260330-1 baseline)

A validation sim of 180 steps on the same baseline fork, compared against `20260330-1`:

| Criteria | 20260330-1 baseline | Target |
|----------|--------------------|--------------------|
| First-action location | Ivan → wrong bed (Studio Room 1) | Ivan → own bed (correct room) |
| Max action duration | 1000+ min overflow observed | No action > 300 min (hard cap enforced on all paths) |
| Greeting → full chat | Stuck at greeting tier | Tier escalation regression addressed, with evidence of greeting→full chat progression in validation sim |
| Social description accuracy | "chatting with X" without active chat | Social descriptions only when `chatting_with` is set |
| Location errors (total) | 1 / 760 actions (0.13%) | ≤ 1 / 760 (no regression) |
| Cross-gender bathroom | 0 | 0 (no regression) |
| Fictional anchors | 0 | 0 (no regression) |
| Conversation triggering | Personas in shared spaces don't always converse | Proximity triggers conversation evaluation consistently |

### Validation scope

This checkpoint validates against `20260330-1`. The goal is to close the 4 regressions identified in the `20260331-3` comparative assessment. The fixes are validated against a 190-step sim with 4 personas on the same baseline fork (matching 20260330-1). This checkpoint does not cover: stability on runs >100 steps, scalability beyond 4 personas, or consistency across sims with different configurations. These dimensions require structural work that I've documented separately.

---

## 5. Deliverable

At the 5-hour checkpoint:
- Items A, B, C, D — addressed and validated
- Validation sim (180 steps) with results compared against baseline
- Summary of what was fixed, what was observed during the fixes, and any structural limitations encountered

---

## 6. Additional Issues Identified

During the previous pass I identified two additional issues not in the original 4:

- **Two personas on the same tile** — no global enforcement against stacking. The previous pass added per-arena fallback but not a system-wide rule.
- **Greeting bubble duration** — the `len(text)/15` formula from the previous pass gives ~3.2s for greetings, still too fast. The full duration chain to the frontend hasn't been validated end-to-end.

These are not part of the committed scope. If you want them included, I can add them — estimate ~0.5h each, in addition to the 5-hour checkpoint budget.

