# Second opinion — RCA on the 11:00 miss (`20260827-1`)

**Date:** 2026-08-28
**From:** CTO review
**Reviewing:** `20260827_RCA_challenge_miss.md` + `20260827_challenge_miss_evidence.md`
**Method:** re-derived E3 and E2 from the raw pack; read the gather-lock, movement and emit paths on tip `266aa54f`; read `git show 266aa54f`.

Runner untouched. Nothing deployed, patched or SOT-rewritten.

---

## 0. Verdict in one paragraph

**Disagree on the primary.** The evidence collection is good and the counts are almost all right, but the RCA stops one layer above the cause. **A ("shortening the lock unpinned the morning") describes the occupancy curve; it does not explain it.** The gather lock has never been able to move a body, in this sim or in `20260825-1` or `20260823-2`. It writes `act_address` and the action sentence; the movement layer obeys `target_zone`, which the lock never writes. So the lock is a caption generator. Occupancy on all three sims tracked one thing: **what the daily planner scheduled** — and Pass 1 changed the planner's instruction from "be at Hobbs 10:00–11:00" to "be at Hobbs 10:30–11:00" in the *same commit*, which the RCA never mentions. Five of fifteen agents responded by scheduling their first cafe block at 11:00 or later, and the room went from 3 at 11:00 to **8 at 11:10**. The room was not unpinned. It was **invited late**.

---

## 1. The mechanism the RCA did not reach

### 1.1 Two destinations, one of them decorative

`_apply_gather_lock_action` (`plan.py:685`) writes exactly six fields:

```
act_address, act_description, intent, act_path_set=False, planned_path=[], act_start_time, act_duration
```

It does **not** write `target_zone`, `zone_anchor`, `movement_mode`, `speed_multiplier`, `stationary_intent`, or `subactivity_mode`.

Those are written in one place only — inside `_determine_action` (`plan.py:5278`), under the banner *"BACKEND-PHASER MOVEMENT PLANNING: Set target_zone and speed_multiplier. These fields are used by the frontend Phaser to compute local A\* paths."*

And the movement layer is zone-authoritative:

- `execute.py:1492` — `if hasattr(persona.scratch, 'target_zone') and persona.scratch.target_zone:` → zone branch.
- `execute.py:1757` — the legacy address-based branch is `elif not hasattr(persona.scratch, 'target_zone')`. After any persona's first action, that attribute always exists. **The address-based movement path is dead code from step 1 onward.**
- Inside the zone branch, if the body is already inside the (stale, job) zone and the sub-mode is `in_place`, the result is `ZONE REACHED … staying at curr_tile`.

So: lock says cafe on `act_address`, body obeys `target_zone` = the pharmacy, and the emitted sentence says "heading to Hobbs Cafe for the survival appointment."

### 1.2 It is worse than inert — it is self-sealing

Two compounding effects:

1. **Arrival is judged against the stale zone.** `act_check_finished` (`scratch.py:1035`) does arrival detection via `_is_in_target_zone()`. Ivan, told to go to the cafe, is standing in his `target_zone`, so the runtime marks him **arrived**. No travel timeout, no stall-breaker, no reachability override ever fires, because by the only spatial authority the runtime consults he is already there.
2. **The lock blocks the only path that could fix it.** For an off-cafe body the early-return at `plan.py:740` requires `curr_tile is None`, so it never triggers on a live persona. The lock therefore re-mints every step, resetting `act_start_time` and `act_duration` each time. `_determine_action` — the sole writer of `target_zone` — cannot run while the lock holds. The longer the lock, the longer the wrong zone is frozen in place.

### 1.3 Why this shipped green three times

`tests/test_survival_gather_lock.py` has 17 assertions across 15 tests. Every one of them asserts `act_address`, `act_description`, `intent`, `act_path_set`, `planned_path`, `act_duration` or `act_start_time`. **Not one asserts `target_zone`, `zone_anchor`, `movement_mode` or `speed_multiplier`.** The lock is fully green against a contract the body does not read. That is the real reason this survived Jul gather-lock, `4ab4f5be` stay-pin and Pass 1.

### 1.4 The fingerprint in the RCA's own data

E3 line 11:10 — "8 | walk-back after fire — too late" — is filed as a sad footnote. It is the proof.

| Clock | n | Note |
|---|---|---|
| 11:00 fire | 3 | lock still on |
| 11:05 | 3 | |
| **11:10** | **8** | includes **Ivan Pitts** |
| 11:15 | 8 | includes **Owen Logan** |

Ivan and Owen are two of the three "true never-sit, reachable, did not walk" E-class agents. They walked within 10–15 minutes of the lock releasing, from ~29 and ~25 tiles out. The bodies were never stuck. **The walk the lock was supposed to cause happened as soon as the lock let go.**

---

## 2. What the daily plans actually say (all 15, not the 5 sampled)

Recomputed from `e5_scratch_current.json` by accumulating `f_daily_schedule` durations from 00:00. Caveat: snapshot is 12:38, so 10:00–11:00 entries include post-hoc re-decomposition; the 11:00+ pattern is consistent across the whole cast and matches observed tiles.

| First cafe block starts | n | Who |
|---|---|---|
| 07:00–09:05 | 4 | Dean, Max, Olivia, Irene |
| 10:00–10:05 | 6 | Shepard, Alexis, Andrew, Diana, Vince, Vincent |
| **11:00** | **4** | **Butcher, Ivan, Nick, Owen** |
| **11:18** | **1** | **Mike** |

Every one of the fifteen has a cafe/challenge block. Nobody "never found the cafe" — the RCA is right to kill that. But **a third of the cast scheduled arrival for the event hour itself**, and their 11:00 blocks read: *"Finding a seat at the cafe and settling in"*, *"ordering a coffee at the counter"*, *"settling into the cafe seating area"*, *"Reviewing the challenge instructions"*. Travel plus settling takes ~10 minutes. The room filling at 11:10 is not a failure of those five agents; it is their plan executing correctly.

This matters for a headline the RCA got backwards (see §3.1).

### 2.1 The in-window leavers are a decompose-anchor bug plus a chat chain, not a pin leak

Schedule blocks carry `[mode=… anchor=…]`. The anchor drives `target_zone`. For travel sub-tasks the anchor is inherited from the *previous* location instead of the named destination:

| Who | Block | Text | Anchor |
|---|---|---|---|
| Alexis | 10:20–10:26 | "walking to Hobbs Cafe from library" | **library** |
| Alexis | 10:26–10:32 | "walking to Hobbs Cafe" | **library table** |
| Vincent | 10:30–10:35 | "packing up belongings at library table" | **library table** |
| Olivia | 10:20–10:32 | "sipping a warm drink and staring out the window" | **bar customer seating** (the pub) |

Alexis was seated on the cafe from 10:09 and was sent to the college library by a block whose *text* says Hobbs Cafe. Olivia was seated on the cafe and was sent to the pub by a generic in-place activity that a cafe anchor would have satisfied. `task_decomp_contextual_v1.txt` has nine `inherits_parent_location` examples and **not one covers a travel or transition sub-task**, which is exactly the case that breaks.

Then the chat chain, from E4's own `chatting_with` column:

- **Vincent** leaves 10:30 — no chat — his own schedule sends him back to the library.
- **Diana** leaves 10:32 — `chatting_with: Vincent Slater` — her plan was *perfect* (10:10 settle, 10:25 review notes, 10:45 wait for challenge, all anchored cafe customer seating).
- **Alexis** leaves 10:32 — `chatting_with: Diana Ogden`.

One stale block removed three people, two of whom had compliant plans. The RCA reads this as "D — chat skips the lock (3/5)." The load-bearing fact is the opposite direction: **chat propagated a departure.** That changes the fix. Making the lock ignore `chatting_with` would break conversations and would not have saved Diana, because the thing that moved her was her partner walking, not a missing dest rewrite.

---

## 3. Counts I would change

### 3.1 The "mid-run H3 was 5, true never-sit is 3" correction

Right on tiles, **wrong on class**, and it is the RCA's most quoted line. The mid-run scorer's five were Butcher, Ivan, Mike, Nick, Owen. Those are exactly the five whose first cafe block is 11:00 or 11:18. Mike's 07:29–07:47 and Nick's 07:49–07:59 are morning coffee, not challenge attendance. The scorer accidentally had the right cohort. "Do not treat this miss as five librarians to yank" is a good instinct about the *remedy* and a bad correction to the *count* — there are five late-by-plan agents, not three.

### 3.2 `B` is 4, not 5

RCA §2 table says 4 in-window leavers; the hypothesis score says "B Hit (5 people)." E4 lists 5 rows because Vincent's leave is stamped at step 275 = 10:30, the boundary. His `class_lock_window` is H3 — the pin never saw him on cafe. **4** is correct; the hypothesis table should match.

### 3.3 Peak 9 needs a staff/resident asterisk

Verified exact from raw (E3 reconciles perfectly: `n == len(present)` and `n + len(absent) == 15` on all 40 rows). But the peak of 9 at 10:15 includes **Irene Dove** (cafe staff, on shift behind the counter, `on_count` 103 unbroken from 09:18) and **Dean Sanford** (`on_count` 101, effectively resident). Contestant arrivals peaked at 7. At the fire, 3/15 is 2 contestants plus the barista. Report both numbers or the 80% bar quietly counts the staff.

### 3.4 `dest_names_hobbs` in E7 is a dead column

The collector computes `"hobbs" in str(dest)` where `dest` resolves to a `target_zone` **bbox dict**. It is structurally `False` for all 15 rows and carries no information. The RCA's "dest bbox is the job for 9 of them" is nonetheless **correct** — I reclassified the bboxes by hand: cafe zone `{72–82, 21–25}` for Diana, Vince, Vincent; job zones for the other nine. Keep the claim, drop the column.

### 3.5 The headline comparison is confounded, and the confound is unnamed

`git show 266aa54f` — the scored tip — changed 27 files. Inside `plan.py`:

```
- ("challenge_deadline_hour", 1.0, …)      →  0.5
- ("vote_deadline_hour",      2.0, …)      →  0.5
```

and, in the same commit, `run_gpt_prompt.py` `lead_hours = 0.5  # keep in sync with plan._SURVIVAL_GATHER_LEAD_HOURS`, which feeds this into the hourly planner prompt:

> "For the daily challenge at 11:00 am: persona MUST be physically AT Hobbs Cafe during the **10:30 – 11:00** slot. The walk must finish BEFORE 10:30."

On `20260825-1` that same sentence read **10:00 – 11:00**. So Pass 1 did not only shorten a lock. **It halved the presence block the daily planner is instructed to schedule**, and cut the vote's from two hours to thirty minutes. The RCA discusses the lock window at length and never mentions the prompt window. Given §1 (the lock cannot move bodies) and §2 (occupancy tracks the schedule), the prompt change is the leading candidate for 9/15 → 3/15, ahead of both A and skip-Premiere.

I would not sign **"8/15 → 9/15 → 3/15 on the first competitive 11:00"** as a clean primary line. Three variables moved at once: instructed presence window (60→30 min), no Premiere day, and honest-text/thin-talk. The handoff's rule "primary compare is first competitive 11:00 only" is what creates the confound it forbids questioning.

---

## 4. Is the recommended experiment naturalness-first?

**No. Items 1 and 2 are the banned dest-yank, renamed.**

RCA §6.1 — *"rewrite dest **and** the FE target zone"* — is a forcible destination override applied to every seated agent. RCA §6.2 — *"WALK actually moves the job"* — is the same override applied to every working agent. The founder banned "H3 dest-rewrite / yank librarians." Debugging the pin so it seizes `target_zone` is that ban, generalised from 3 people to 15. It is **more** coercive than what it replaced, not less.

RCA §6.3 (hourly plan owns 10:30–11:00) is directionally right but is partly falsified by the RCA's own E5: **Diana's plan already owned 10:00–11:00 with cafe anchors throughout, and she still left.** A correct block is necessary and not sufficient while the anchor and chat paths can override it.

### What I would run instead — in this order

1. **Restore the invitation, not the pin.** Decouple the two constants that Pass 1 fused. Set the *prompt* lead back to `1.0` (agents are told to be seated from 10:00) and leave the *lock* lead at 0.5 — or switch the lock off entirely for one run. This is strictly **less** coercion than today and, on the §1 mechanism, should recover most of 25-1's 9/15. It is also the naturalistic reading: people invited to a televised event at 11:00 turn up early and hang around. Pass 1's premise — "the wait is the bug, shorten the hang" — is the thing that removed the room. The wait was never the bug; the empty room was. Making the wait *watchable* is a content problem, and it is not solved by deleting the wait.
2. **Fix the travel-anchor inheritance in decompose.** A sub-task naming a destination must anchor to that destination. Add the missing negative example to `task_decomp_contextual_v1.txt`. This is what sent Alexis to the library while her task said "walking to Hobbs Cafe", and Olivia to the pub while she was already seated at the cafe.
3. **Then, and only then, decide the lock's fate.** Either give `_apply_gather_lock_action` authority over `target_zone` / `zone_anchor` / `movement_mode` / `speed_multiplier` — accepting that this *is* a dest-yank and should be argued as one — or delete it. What must not continue is a lock that is green in tests, writes a truthful-looking caption, and cannot move a body. That is the state that produced three consecutive misses and a viewer-facing lie.

Whatever ships, **add `target_zone` to the gather-lock test contract.** Any future assertion that the lock "walked someone in" is unfalsifiable without it.

---

## 5. One free discriminating test — tonight's vote, no new run needed

Pass 1 cut the **vote** lead from `2.0` to `0.5` in the same commit. Tonight's planner instruction is "be at Hobbs 19:30–20:00" where `20260825-1`'s was "18:00–20:00" — a four-fold cut, larger than the challenge's.

**Pre-registered prediction under my mechanism:** the 20:00 vote on `20260827-1` misses the 80% bar, materially below 25-1's day-1 result, and — the discriminating signal — occupancy **surges within 10–15 minutes after 20:00**, the same shape as 11:00 → 11:10. Score the curve at 19:45 / 19:55 / 20:00 / 20:10 / 20:15, not just the deadline.

**If the vote hits 80% at 20:00, I am wrong and A deserves more weight.** Under the RCA's model the vote outcome carries no particular signal about the challenge; under mine it is the same defect firing twice in one day. It costs nothing to check.

---

## 6. Cheap additions to the next collector pass (read-only, no SSH, no deploy)

The pack captured `target_zone` (as "dest") and then interpreted it as a symptom. It never captured the fields that decide whether a body moves. Same Supabase read, four more keys off the `movement` dict:

`speed_multiplier` · `stationary_intent` · `movement_mode` (+ `movement_mode_source`) · `realism_trace.zone_resolution`

Predicted values for Butcher / Ivan / Nick / Owen at 10:30–11:00: `speed_multiplier = 0.0`, `stationary_intent = true`, `movement_mode = stationary`. If those come back non-zero and travelling, §1 is wrong and the walk failed somewhere downstream instead.

---

## 7. What I agree with

E1 (deadline fire, no spatial gate), E3 (exact — I recomputed all 40 rows), E9 (persist and start-jump held; not a teleport bug), the kill on "they never found the cafe", the kill on "30 minutes is unreachable", the refusal to recommend fire-when-12, and the call that gather is **FAIL** and Pass 1 is **FAIL**. The classification work in E2 is sound; my objections are to the causal ranking built on top of it, not to the trails.

**Call:** the mix is right in its parts and wrong in its ordering. Primary is not A. Primary is a **destination-authority split** — the lock owns the sentence, the schedule owns the body — with Pass 1's unremarked halving of the *instructed* presence window as the proximate reason this morning scored 3 instead of 9.
