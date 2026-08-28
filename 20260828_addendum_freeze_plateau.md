# Addendum — the lock is an arrival blocker, not just a caption

**Date:** 2026-08-28
**From:** CTO review
**On:** `20260828_verdict_authority_hypothesis.md` + `20260828_verify_pack/`
**Status:** verdict **accepted**. One new finding that changes the recommended fix. One gap that must close before anyone acts.

Runner untouched (~step 1800). Nothing deployed, patched or SOT-rewritten.

---

## 1. Verdict on the verdict

Accepted. I re-derived the vote and day-2 curves from `v2_vote_curve.json` and `v3_d2_curve.json` and they match the paper exactly: **8/15 at 20:00** (bar 12), **12/15 at 20:15**, **6/14 at 11:00 day 2** (bar 11), **10/14 at 11:05**. V4's 11% and the V6 anchor list check out. H-B stands.

Cross-check that validates the whole occupancy instrument: the eight people on cafe tiles at 20:00 are **exactly** the eight who cast real votes in `v1_agent_state.json`. Tiles and the vote mechanic agree persona-for-persona.

**My P4 was wrong.** I predicted a `speed_multiplier` 0.0 spike; it is 1.0 on 567 of 589 steps. I was reading the wrong marker. The miss makes the case **stronger**, not weaker: these agents were free to walk at full speed and still did not move. That removes the competing explanation ("they were speed-gated as stationary") and leaves the destination as the only thing holding them. The real marker is `movement_mode` — **301 of 380** day-1 steps are `stationary` or `in_zone`, i.e. the runtime believed they had already arrived. Please use `movement_mode`, not speed, as the fingerprint from here on.

---

## 2. The finding neither pass called: the room freezes inside the lock

The paper reads the shape as *"a usable room before the short lock, a thin room at the clock, a surge after it lets go."* That describes a **drain**. The curves show something different and much more actionable.

**Day-1 vote, roster by name:**

| Clock | n | Roster |
|---|---|---|
| 19:00–19:30 | 8→9→10→9→9→8→9 | changes at almost every reading |
| **19:40** | **8** | Butcher, Diana, Irene, Ivan, Max, Mike, Olivia, Vince |
| **19:45** | **8** | *identical* |
| **19:50** | **8** | *identical* |
| **19:55** | **8** | *identical* |
| **20:00 deadline** | **8** | *identical* |
| **20:05** | **8** | *identical* |
| 20:10 | 11 | +Dean, +Owen, +Vincent |
| 20:15 | 12 | +Alexis, +Andrew |

**Day-2 challenge:**

| Clock | n | Roster |
|---|---|---|
| 10:00–10:25 | 3→4→7→9→9→8 | changes at every reading |
| **10:30 lock** | **5** | Andrew, Irene, Max, Nick, Olivia |
| **10:35** | **5** | *identical* |
| **10:40** | **5** | *identical* |
| **10:45** | **5** | *identical* |
| **10:50** | **5** | *identical* |
| 10:55–11:00 | 6 | +Ivan, +Vince, −Andrew |
| 11:05 | 10 | +Alexis, +Dean, +Owen, +Vincent |

Six identical readings across 25 minutes, then five identical readings across 20 minutes — **in a village of fifteen autonomous agents, bounded exactly by the lock window, twice.** Outside the window the roster turns over at every single five-minute sample. Inside it, nothing happens at all. Then **+4 within 5–10 minutes of release, both times.**

Autonomous agents do not produce flat plateaus with unchanged rosters. Something is suppressing state change.

**Candidate mechanism, already visible in the code:** `_apply_gather_lock_action` (`plan.py:685`) resets `act_start_time = curr_time` and `act_duration` **on every step**, because the off-cafe early-return at `plan.py:740` requires `curr_tile is None` and so never fires on a live persona. `act_check_finished()` therefore never returns True while the lock holds, `_determine_action()` never runs, and the daily schedule cannot advance. Whatever block you were in at lock onset is the block you are still in at the deadline.

This flips the reading of the lock from **inert** to **actively harmful**. An inert lock would leave the pre-lock fill rate alone and the room would keep filling toward the deadline — which is exactly what it does *before* the lock engages. Instead the fill stops dead. **The lock is not failing to hold people in. It is stopping people from arriving.**

### The consequence, in one sentence

Five of the seven agents who lost their vote to `absent_from_gathering` — Dean, Owen, Vincent, Alexis, Andrew — **walked into the room within fifteen minutes of being disenfranchised.** Dean was sitting in that cafe at 19:20.

---

## 3. Where the pack's own data contradicts the pack's recommendation

The paper recommends *"put the planner invitation back to 'be there from 10:00'"*. **Day 2 already ran that experiment for us, and it did not work.**

From `v5b_learning.json`, day-2 first cafe block: **13 of 15 agents scheduled it at or before 10:05**, unprompted. Owen went 11:00 → **07:00**. Nick 11:00 → **08:00**. Ivan 11:00 → **09:00**. Diana → 08:00, Vince → 07:40. Only Butcher (11:00, since eliminated) and Mike (11:00) failed to move.

The invitation problem substantially self-corrected overnight. **Day 2 still scored 6/14.**

The arithmetic from V5 is the part to put in front of the founder. Of the 8 agents with a block actually *covering* 10:30–11:00, **5 sat — a 62.5% hold rate.** Push coverage to 14/14 and you get ~9/14. **The bar is 11.** Restoring the invitation is necessary and cannot on its own reach the bar; the freeze channel is worth roughly the same +4 and the two together are what clears it.

One measurement note for the next pass: V5b's "first cafe block" is not the right predictor. A 07:00 coffee does not keep Owen in the room at 11:00. The predictive variable is V5's **block covering the deadline slot**, and the two should not be reported as if they measure the same thing.

---

## 4. Gap that must close before anyone acts

`v4_rows_d2_chal.json` is **an empty array (2 bytes)** and `v4_summary.d2_chal.heading_offcafe_n` is **0**. The decisive 11% therefore rests on **two windows, not three** — and the missing one is the day-2 morning, which has the cleanest freeze plateau in the pack. The headline should read "two windows measured, day 2 not measured," not "589 steps."

It is not a simple fetch failure: `v7_chat_leaves.json` contains a day-2 row at step 1739, so day-2 coords were pulled for other stages. And that row's caption is *"at The Rose and Crown Pub @ the Ville"* — **not** a lock caption — for Andrew, who was on a cafe tile from 10:25 and left at 10:54, i.e. exactly the on-cafe leaver the STAY path should have rewritten.

So there are two live possibilities and they point to opposite fixes:

- **(a)** The lock fired on day 2 and the v4 stage has a filter/window bug → the freeze mechanism in §2 holds, and deleting the lock is the top-priority change.
- **(b)** The lock genuinely did **not** fire on day 2 — e.g. `challenge_resolved_date` or `post_vote_date` still matching, since `_in_survival_gather_prewindow` returns False for *both* windows whenever `_is_post_vote_active` is true → then the day-2 freeze has some other cause, §2 is wrong for day 2, and we need to find what else stops the churn.

**One query settles it:** count emitted descriptions containing `survival appointment` per step across 1715–1745, and dump `scratch.survival.challenge_resolved_date` / `post_vote_date` as of day 2. Re-run the v4 stage for that window only. Nothing else in the pack needs redoing.

---

## 5. Recommended change to the next-fork plan

Keep both of the team's items; add the removal first, because it is the only one that is *less* code and *less* coercion.

1. **Delete the gather lock** (or gate it to a no-op) for one fork. It is the cheapest possible experiment, it removes a viewer-facing lie, and on §2 it is worth roughly +4 at every deadline. This is the opposite of a pin — nobody has proposed removing coercion before.
2. **Restore the planner invitation to 10:00**, decoupled from the (now absent) lock constant.
3. **Fix travel-anchor inheritance** — `v6_travel_anchor.json` lists twelve day-2 cases of "walking to Hobbs Cafe" anchored to a closet, a park garden, a dorm garden, a desk.

Hold the line on: no dest-yank, no fail-closed, no longer pins, no fire-when-12. Item 1 is not a pin by any reading — it deletes one.

Gate on all three: `target_zone` and `movement_mode` join the gather-lock test contract, or whatever replaces it. Fifteen tests currently pass without either.

---

## 6. Noticed, not in scope — flagging only

The first elimination in the show's history was decided by **8 real voters out of 15**, on a **3-vote plurality**, with 7 phantom votes applied. The three votes that removed Alex Butcher were cast by Irene ("the person I know least"), Ivan ("highest trust with Alex... a clean baseline") and Vince ("a low-risk probe"). Every recorded reason is an experiment rather than a judgement.

That is a narrative-quality question, not an occupancy one, and it is not this ticket. But it is worth knowing before the Sept 1 launch call that the vote mechanic currently produces an elimination that no viewer could follow.
