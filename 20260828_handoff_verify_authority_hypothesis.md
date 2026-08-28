# Handoff — verification pull (`20260827-1`), destination-authority hypothesis

**Date:** 2026-08-28
**From:** CTO review
**To:** Investigation team
**Ask:** one read-only data pull against the live sim, then a short verdict paper. **No new run needed.**

Sim **still running** (~step 1791). Do not stop it. Do not deploy. Do not patch. Do not rewrite SOT.

Reviews this against: `20260828_second_opinion_rca_challenge_miss.md` · `20260827_RCA_challenge_miss.md` · `20260827_challenge_miss_evidence.md`

---

## 1. Why now

The runner has passed **two more scored gathering events** since the pack was collected:

- **Day-1 vote** — 20:00 Aug 28 — step **845**
- **Day-2 challenge** — 11:00 Aug 29 — step **1745**

Both are already on disk. That is two independent replications of the 11:00 miss, free, with no fork and no deploy. We do not need a new sim to settle the disagreement about root cause.

---

## 2. The disagreement we are settling

| | **H-A** (first-pass RCA) | **H-B** (second opinion) |
|---|---|---|
| Primary cause | The 30-min gather lock started *after* the morning sit and unpinned it | The lock writes the **sentence**, the schedule owns the **body**; occupancy tracks the daily plan, not the lock |
| Mechanism | Pin leaked (chat skip, dest not held) | `_apply_gather_lock_action` writes `act_address` but never `target_zone` / `speed_multiplier` / `movement_mode`; movement is zone-authoritative |
| Why 9/15 → 3/15 | Lock window moved 10:00 → 10:30 | Pass 1 also halved the **planner prompt's** presence block (`lead_hours` 1.0 → 0.5), so 5 of 15 scheduled the cafe for 11:00+ |
| Fix | Make the pin hold dest and move job bodies | Restore the invitation window; fix travel-anchor inheritance; then give the lock zone authority **or delete it** |

Both stories fit the day-1 challenge. They make **different predictions** about the vote and the day-2 morning. That is what this pull is for.

---

## 3. Hard rules

Unchanged from the investigation, plus one new one:

- Leave the runner up. PID **533153**, Hetzner `62.238.113.45`, unit `api-gateway`. No `git pull` / deploy while it is alive.
- Read-only Supabase (`personas_coords`, `survival_season_state`, `persona_scratch`). Print-only collectors under `COS/tasks/`, never imported into the runner.
- Score **tiles**, not "heading to Hobbs."
- Founder band-aids stay out: H3 dest-rewrite, fail-closed, longer pins, fire-when-12.
- Do not rewrite `sot_be-fe.md` §4.7 or `sot_survival.md`.
- **NEW — snapshot `persona_scratch` today.** `f_daily_schedule` is regenerated at each engine-day rollover. **Day-1's schedule is already gone** (overwritten at step 1085). Day-2's dies at the next rollover, **step 2525** (~Aug 30 00:00). Pull it now or lose the day-2 evidence too.

---

## 4. Clock map (step 0 = Aug 28 05:55, 1 step = 1 sim-minute)

| Event | Clock | Step |
|---|---|---|
| Challenge day 1 (already scored **3/15**) | Aug 28 11:00 | 305 |
| Vote lock opens (`lead_hours` 0.5) | Aug 28 19:30 | 815 |
| **Vote day 1 — deadline** | **Aug 28 20:00** | **845** |
| Engine-day rollover (day-1 schedule lost) | Aug 29 00:00 | 1085 |
| Challenge lock opens | Aug 29 10:30 | 1715 |
| **Challenge day 2 — deadline** | **Aug 29 11:00** | **1745** |
| Now | Aug 29 11:46 | 1791 |
| Vote day 2 | Aug 29 20:00 | 2285 |
| Next rollover (day-2 schedule lost) | Aug 30 00:00 | 2525 |
| `max_steps` 4000 ends | Aug 31 00:35 | 4000 |

Denominator note: if the day-1 vote eliminated someone, day 2 is **/14**, and the 80% bar is 11 (per `20260823-2` precedent). State the denominator you used.

---

## 5. What to collect — V1–V8

### V1 — Vote day 1: did it fire, and how

From `survival_season_state` (and NDJSON only if the season row is ambiguous):

- Fire step, clock, **reason** (`deadline` vs `spatial_gate`), tally, who was eliminated, alive count after.
- Whether `post_vote_date` was stamped and the vote prewindow released.
- Confirm day 2 re-armed: new `active_challenge_id`, `current_day` = 2.

`spatial_gate` vs `deadline` matters: a spatial fire means occupancy hit the bar before 20:00 and H-B's "empty at the deadline" prediction is dead on arrival.

### V2 — Vote occupancy curve (the shape, not just the number)

Every 5 sim-minutes, steps **785 → 875** (19:00 → 20:30). Clock, n/15, names.

Report the deadline number **and the time-to-fill after it**. The shape is the discriminator, not the level.

### V3 — Challenge day 2: fire + curve

- Fire row as V1.
- Occupancy every 5 min, steps **1685 → 1775** (10:00 → 11:30). Clock, n/denominator, names.
- Per-person first-on / last-on / on-count for the morning window (steps 1445 → 1745, i.e. 05:55 → 11:00 Aug 29).

This is the second competitive morning — compare to `20260825-1` **6/14** and `20260823-2` **11/14**, not to day 1.

### V4 — Movement authority fields (**the decisive item**)

The prior pack captured `target_zone` as "dest" and never captured the fields that decide whether a body moves. They are already in the emitted `movement` dict — no code change, same Supabase read:

`speed_multiplier` · `stationary_intent` · `movement_mode` + `movement_mode_source` · `realism_trace.zone_resolution` · `target_zone` · `address_label` · `start_pos` · actual `x,y`

Dump every persona-step inside the three lock windows: **275–305**, **815–845**, **1715–1745**.

Then compute the one number that settles this:

> Of all persona-steps where the emitted description says **"heading to Hobbs Cafe for the survival appointment"** and the body is **off-cafe**, what fraction moved **≥1 tile toward the cafe** on that step?
>
> Break out alongside it: median per-step displacement, and the distribution of `speed_multiplier` (expect a spike at exactly 0.0 under H-B) and `movement_mode`.

### V5 — Schedule vs presence, day-2 challenge

Using the `persona_scratch` snapshot you take **today**, per persona:

- Start time of the first cafe/Hobbs block in `f_daily_schedule`.
- What block covers 10:30 and what covers 11:00, with the `[mode=… anchor=…]` tags intact.
- A 2×2: **has a cafe block covering 10:30–11:00** × **on a cafe tile at 11:00**.

Under H-B the schedule column predicts presence and the lock column does not. Under H-A the lock should rescue people whose schedule failed.

### V5b — Did they learn? (new question, possibly the most important)

Compare each agent's **day-2** first cafe block against their **day-1** block (day-1 values are in `20260828_second_opinion_rca_challenge_miss.md` §2 — reuse them, do not re-derive).

Specifically: Butcher, Ivan, Nick, Owen scheduled 11:00 on day 1 and Mike 11:18. **Did any of them move earlier on day 2 after living through a challenge they arrived at ten minutes late?**

If yes, agents self-correct with one day of experience — which means **skip-Premiere removed the learning day**, and that reconciles H-B with the skip-Premiere confounder. If no, the planner needs the wider invitation window and will not fix itself.

### V6 — Travel-anchor audit

Across the day-2 schedules, count entries where the **task text names a place** ("walking to Hobbs Cafe", "arriving at Hobbs Cafe") but the **`anchor=` names a different place**. List them.

Day-1 examples to match against: Alexis 10:20–10:26 *"walking to Hobbs Cafe from library" `anchor=library`*; Alexis 10:26–10:32 *"walking to Hobbs Cafe" `anchor=library table`*; Olivia 10:20–10:32 *"sipping a warm drink…" `anchor=bar customer seating`* while seated at the cafe.

### V7 — Chat contagion

For every leave inside the three lock windows: `chatting_with`, and whether that partner left within the **3 steps before**. Day 1 showed a chain — Vincent (own schedule) → Diana (chatting with Vincent) → Alexis (chatting with Diana), all inside 10:30–10:32. Report whether the vote and day-2 morning show the same shape.

### V8 — Health bars

Through step 1791: rows complete every step, `start→end` >6 count, consecutive-step >6 count, TRACEBACK / TELEPORT. One paragraph. This is a "still not a teleport bug" check, nothing more.

---

## 6. Pre-registered predictions — write the verdict against these

Fill these in **before** interpreting anything else.

| # | Prediction (H-B) | Confirms H-B | Falsifies H-B → H-A stands |
|---|---|---|---|
| P1 | Day-1 vote misses the 80% bar at 20:00 | n at step 845 below bar | Vote hits 80% at the deadline |
| P2 | Vote room fills **10–15 min after** 20:00 | n jumps by ≥3 between 20:05 and 20:15 | Flat after the deadline, or full before it |
| P3 | Lock-window "heading to Hobbs" steps mostly do **not** move | <25% of those steps move ≥1 tile toward cafe | Majority move toward the cafe |
| P4 | Frozen job bodies show `speed_multiplier` 0.0 / `movement_mode` stationary / `target_zone` = their job | Clear 0.0 spike | Non-zero speed and travel mode → the walk failed downstream, not here |
| P5 | Day-2 11:00 presence is predicted by the schedule block, not by the lock | Schedule column separates presence; lock rescues ~nobody | Lock-window agents stay while their schedule says otherwise |
| P6 | Day-2 challenge lands in the same band as day 1, not near 11/14 | Materially below the 80% bar | Day 2 ≥ 80% with no code change → something other than the lock and the prompt is driving this |

P6 has an important caveat: if V5b shows the agents rescheduled themselves earlier, a good day-2 number **supports** H-B (planning drives occupancy) rather than refuting it. Read P6 together with V5b, never alone.

---

## 7. Optional — needs founder OK before anyone touches the box

`journalctl -u api-gateway --since "2026-08-28 19:20" | grep '\[GATHER_LOCK:'` would give the definitive STAY/WALK/WAKE counts per person. It is read-only and touches neither the repo nor the process, but the standing rule is **no SSH while 533153 is alive**, so ask first. Only worth it if V4 leaves "did the lock actually fire for X" open — it probably will not.

---

## 8. Reply shape

Short dated paper in `double-ivan/`, plus a raw pack folder (`20260828_verify_pack/`) with the JSON.

The paper needs, in this order:

1. **The prediction table from §6 with verdicts filled in.** One line each, no prose.
2. Vote curve and day-2 curve as tables.
3. The V4 number, stated plainly.
4. The V5 2×2 and the V5b learning answer.
5. Any count in §5 you would not sign, with the table and why.
6. Verdict: H-A, H-B, or a named mix with counts.

Do not ship gather. Do not call Pass 1 green. No fix in this pass — this is evidence.

---

## 9. What we do with each outcome

- **H-B confirmed** → next fork changes two things and nothing else: prompt `lead_hours` back to 1.0 (decoupled from the lock's 0.5), and the travel-anchor inheritance rule in `task_decomp_contextual_v1.txt`. The lock is then either given zone authority — argued openly as a dest-yank — or deleted. Either way, `target_zone` goes into the gather-lock test contract, because today all 15 tests pass without it.
- **H-A confirmed** → the pin gets debugged as the RCA proposed, and we take the founder question head-on that this is a dest-yank for all fifteen rather than three.
- **Mixed** → give the split with counts; do not average the two stories into one vague fix.

---

## 10. Ops crumbs

- Reuse `COS/tasks/2026-08-27-003/collect_from_supabase.py`. Changes needed: new step ranges (§4), extra `movement` keys (V4), and `f_daily_schedule` snapshot with anchors preserved.
- Two bugs in that collector to fix while you are in there: `dest_of()` returns a **bbox dict**, so E7's `dest_names_hobbs` string check is structurally always `False` and carries no information — classify bboxes by zone instead. And `loc` is the **body's** address (presence), not the destination; label the column accordingly so nobody re-reads it as dest.
- Supabase project `kkjhsozszgoorwehhsdg`, schema `double`. Season row keys by simulation UUID `a31712bf-8b45-46fa-8fd8-56ba7c3d6058`.
- PowerShell: do not nest `&&` with mixed quotes; put the collector in a file and run it, do not inline it.
