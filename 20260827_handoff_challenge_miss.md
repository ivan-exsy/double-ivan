# Investigation handoff — 11:00 challenge miss (`20260827-1`)

**Date:** 2026-08-27  
**From:** CoS / village score  
**To:** Investigation team  
**Sim still running.** Do not stop it. Do not deploy. Do not patch. This pass is **evidence**, then **RCA**. Fix comes after the RCA is accepted.

---

## 1. Mission

The 11:00 challenge on `20260827-1` had **3 of 15** people on Hobbs tiles. The bar is **12 of 15**. The board still ran.

Collect a complete evidence pack for **why** the room was empty at the declared clock. Then RCA: compare this miss to prior sims and to the fixes we already shipped. Do **not** conclude from the mid-run score alone — several numbers are coarse, and one classifier window may mis-label H3.

**Done when:** a dated evidence pack exists (tables + log greps + per-person trails), plus an RCA that names a root cause class, what we already tried, and what we will **not** try (founder band-aids).

---

## 2. Hard rules

- **Leave the runner up.** PID **533153** on Hetzner `62.238.113.45`. Unit `api-gateway`. Do not restart it. Do not `git pull` / deploy onto this box while 533153 is alive.
- Score **tiles**, not “heading to Hobbs.” Occupancy = `curr_tile` / movement JSON on Hobbs Cafe (any cafe tile, including piano / counter / stand).
- **Do not** dest-rewrite never-sits (H3), fail-closed if sit < 80%, lengthen the pin, or fire the challenge early when 12 sit. Founder lock 2026-08-27.
- **Do not** rewrite `sot_be-fe.md` §4.7 or `sot_survival.md` gather windows on this pass.
- **Do not** treat vote as scored. Clock at mid-run was ~12:12; vote is **20:00**.
- Spoken fourth-wall and start-jump are **not** this ticket except as “held / not the cause.”

---

## 3. What already happened (facts)

| Item | Value |
|---|---|
| Sim | `20260827-1` |
| Tip | `origin/railway` @ **`266aa54f`** (Pass 1 on top of stay-pin `4ab4f5be`) |
| Fork | `soul15_seed_20260224` · `copy_memories=true` · `copy_coords=false` |
| Start | `skip_premiere: true` · `diagnostic_mode: false` · `max_steps: 4000` · sprint |
| UUID | `a31712bf-8b45-46fa-8fd8-56ba7c3d6058` · maze `f61c750d-…` |
| Clock | engine jumped `2026-08-27 06:30` → **`2026-08-28 05:55`** (engine day **2**). `start_date` still Aug 27. Step stays 0. |
| Mid-run | ~step **377** · `curr_time` **2026-08-28 12:12** · Survival Season Day 1 · still generating |
| Challenge fire | step **305** = **11:00** · reason **`deadline`** (not `spatial_gate`) |
| Occupancy | **3/15** tiles. Present: **Alex Shepard, Dean Sanford, Irene Dove** |
| NDJSON absent | matches the 12 tile-absentees (confirm in the pack) |
| At 10:30 lock | only **~4** on cafe (coarse; re-count) |
| Health | TRACEBACK 0 · HEADLESS_STRICT_ABORT 0 · persist >6 = **0/5700** · TELEPORT 0 |
| Honest-text scan | **534** off-cafe ritual/Hobbs lines in 5700 persona-steps; **11/12** absentees still “heading to Hobbs…” at fire |
| Spoken fourth wall | **0/2678** utterances named simulation / Doubland / backend / “as an AI” |

**H2 / H3 from the mid-run scorer** (treat as *provisional* — see E2):

- **H2** (on Hobbs in the scorer window, off at fire) **7:** Alexis Reed, Andrew Abrams, Diana Ogden, Max Shoemaker, Olivia King, Vince Vale, Vincent Slater  
- **H3** (never on Hobbs in that window) **5:** Alex Butcher, Ivan Pitts, Mike Hooks, Nick Miller, Owen Logan  

The mid-run H2/H3 scan started at **lock − 60 min = 09:30**, not dawn. Anyone who sat 08:00–09:20 and never came back was labelled **H3**. Reclassify before using H3 as “never came.”

Clock map (skip-Premiere: **step 0 = 05:55**):

| Clock | Step |
|---|---|
| 05:55 | 0 |
| 08:00 | 125 |
| 09:00 | 185 |
| 10:00 | 245 |
| **10:30 lock** | **275** |
| **11:00 fire** | **305** |
| 12:12 mid-run | 377 |

---

## 4. What we were trying to fix

Same miss class for three scored mornings: **they sit at Hobbs, wait, then the daily plan wins, and they walk to college / pub / pharmacy / library. The board still fires at 11:00.**

Labels (keep these; do not invent new ones):

- **H2** — on a Hobbs tile during the morning / lock window, **off at fire**. Stay-pin / short pin is supposed to stop this.
- **H3** — **never** on a Hobbs tile that morning. Not in Pass 1 scope (founder: no dest-yank).
- Action text “heading to Hobbs” is **not** occupancy.

### Attempts already shipped

| When | Tip | What it did | Challenge result | Read |
|---|---|---|---|---|
| Gather lock (Jul 14–15) | (on mainline) | Force-walk last **hour** before deadline (SOT still says 10:00–11:00 / 19:00–20:00) | historically still misses | Walk-in exists; does not keep the room |
| `20260823-2` | `53ace4c5` | persist 6-tile reject; gather lock still ~1 h | Day-1 chal **8/15** `deadline`; day-2 **11/14** | H2 was already the class (5 of 7 day-1 absentees had sat) |
| Stay-pin | `4ab4f5be` · sim `20260825-1` | On cafe, reject a **leave dest** until that event fires; in-cafe sit/stand/piano allowed; vote lock **18:00**; morning lock releases on `challenge_resolved_date` | Day-1 **9/15**; day-2 **6/14** (worse than 23-2’s 11/14) | Pin walked people **in**. Did not **keep** them. Votes still hit 80% (dinner-leave with 11 staying — tolerated) |
| **Pass 1** (this sim) | `266aa54f` · `20260827-1` | Lock **30 min** only (10:30→11:00); fire at **declared 11:00** (no pull-forward when 12 sit); vote lock 19:30→20:00; honest dest text; thin town talk; skip-Premiere | **3/15** first competitive 11:00 | Short window + no early fire. First score is **worse**, not better |

**Founder product bet (2026-08-27):** the wait *is* the bug. Do not pin harder or yank librarians. Shorten the hang to ~30 min and fire at the advertised clock. Naturalness first.

**Out (band-aids):** H3 dest-rewrite, fail-closed, longer pins, fire-when-12.

Pass 1 also shipped honest text + thin talk + skip-Premiere. Those are **confounders** for occupancy, not the occupancy fix itself. Skip-Premiere means this first 11:00 had **no Premiere day** of village settling.

SOT note: `sot_survival.md` still describes last-**hour** lock and a challenge spatial gate that can fire before 11:00. **Live code on this tip is Desired, not that SOT.** Cite code + this paper for what ran.

---

## 5. Fair comparison (do not mix days)

`20260827-1` skipped Premiere. The 11:00 we scored is **first competitive morning** = Survival Season Day 1 = engine day 2.

| Sim | First competitive 11:00 | Second competitive 11:00 |
|---|---|---|
| `20260823-2` | **8/15** (engine day 2) | **11/14** (engine day 3) |
| `20260825-1` stay-pin | **9/15** (engine day 2) | **6/14** (engine day 3) |
| `20260827-1` Pass 1 | **3/15** (engine day 2, skip-Premiere) | not yet |

**Primary compare:** 8/15 → 9/15 → **3/15** on the **first** competitive 11:00.  
**Do not** headline “worse than 25-1’s 6/14” as the main line — that 6/14 was a **second** morning. Use it only as “morning challenge has been failing and got worse on day 2 of 25-1.”

Other deltas vs 25-1 day-1:

| | 25-1 first 11:00 | 27-1 first 11:00 |
|---|---|---|
| Lock starts | 10:00 | **10:30** |
| Fire | 11:00 `deadline` | 11:00 `deadline` (spatial pull-forward **off**) |
| Sit | 9/15 | 3/15 |
| H3 (their papers) | Shepard only | **5** in the coarse scan — **reclassify** |
| Premiere day before | yes (grace) | **no** |

---

## 6. Evidence to collect (this is the job)

Run on the VPS. Read-only against storage + logs. Script: `COS/tasks/2026-08-27-003/collect_challenge_miss.py` (scp to `/tmp/`). Mid-run scorer (same box): `/tmp/score_pass1.py` or `COS/tasks/2026-08-27-002/score_pass1.py`.

Storage root:

`/var/www/generative_agents/environment/frontend_server/storage/20260827-1/`

### E1 — Confirm the fire

From `logs/survival_phase_trigger.ndjson`:

- phase, reason, step, sim_time, `absent` list, any occupancy fields  
- Prove reason is `deadline` at 11:00 and **no** earlier `spatial_gate` for challenge  
- Alive count 15 (no elim yet — skip-Premiere Survival Day 1)

### E2 — Reclassify H2 / H3 with a full morning window

For each of 15 people, from **step 0 (05:55) through 305 (11:00)**:

- first Hobbs tile, last Hobbs tile, on-count  
- every **leave** (step, dest, act, loc, intent)  
- state at **10:00, 10:30, 11:00** (tile, dest, act, loc)

Then two labels:

1. **Full morning** (05:55–11:00) — true never-sit vs sat-then-left  
2. **Lock window only** (10:30–11:00) — did the 30-min pin ever see them on cafe?

Report how many “H3” from the mid-run scorer **flip to H2** when the window opens to dawn.

### E3 — Occupancy curve, not two clocks

Count on-cafe **every 5 sim-minutes from 08:00 to 11:15** (steps 125–320). Table: clock, n/15, names.

We need to see:

- Did the room **fill before 10:30** then empty (short lock arrived late)?  
- Was the room **never full** (walk-in too short / skip-Premiere)?  
- Did it fill **after 10:30** then empty (pin failed in-window)?

The mid-run note “~4 on cafe at lock” is the most important coarse number. Recreate it exactly.

### E4 — Pin vs plan: did stay-pin fire?

Code under test (`plan.py`):

- Prewindow: `[deadline − 0.5, deadline)` → 10:30–11:00  
- On cafe + dest already names Hobbs → **no-op** (in-cafe sit/piano)  
- On cafe + dest does **not** name Hobbs → rewrite dest to cafe, text “waiting at Hobbs…” (`GATHER_LOCK:STAY`)  
- Off cafe → dest = cafe, text “heading to Hobbs Cafe for the survival appointment” (`GATHER_LOCK:WALK` / `WAKE`)  
- Skip if `chatting_with` is set  

Collect:

- Grep runner stdout / journal for `[GATHER_LOCK:` between ~10:20–11:05. Counts of STAY / WALK / WAKE by person.  
- If prints are missing: at each leave after 10:30, was dest already a Hobbs string (no-op) or college/pub (STAY should have run)?  
- Any H2 leave at **10:31** (step 276–277) — pin’s first minute.

**Hypothesis this answers:** pin no-ops because dest still “names” Hobbs while the body walks off, **or** pin never runs because they left **before** 10:30, **or** `chatting_with` skips the lock.

### E5 — Daily plan at 10:30

For the 12 absentees: what was the **hourly / decompose** task at 10:30–11:00 (lecture, shift, pharmacy, “waiting”)? Did lifestyle already send them off-cafe **before** lock, so 30 min was a chase, not a hold?

Compare 2–3 named people to the same names on `20260825-1` day-1 trails in `double-ivan/20260825_checklist.md` §12 (Ivan, Nick, Owen, Diana, Shepard).

### E6 — H3 walk time (only after E2)

If true never-sits remain: at 10:30, how far (Manhattan) from Hobbs? Could they physically arrive by 11:00 under `MAX_TILES_PER_STEP=6` (max ~30 tiles in 30 steps)? If not, the short window **created** an H3 class that the 10:00 lock used to walk in.

### E7 — Honest text (secondary, but coupled)

At fire, 11/12 absentees still said “heading to Hobbs Cafe for the survival appointment” while loc was college / pub / pharmacy.

Strip (`action_contract_v1.strip_offsite_survival_ritual`) keys off **dest**, and when travelling it uses **planned** dest. Gather lock **sets planned dest to Hobbs**. So the sentence can be “true” to dest and **false** to the body.

For 3 absentees at step 305, dump: `description`, `intent`, `final_destination` / `act_address`, `address_label`, start vs end tile. Say whether dest still named Hobbs.

This is **not** the occupancy miss, but it is why the viewer still sees a lie, and it may explain why dest-based pin no-ops.

### E8 — Skip-Premiere confounder

- Confirm Survival Directive ran at ~06:00 engine day 2 (log + overlay).  
- Note: no engine day 1 village day. First jobs / first Hobbs visit may be colder than 25-1’s first competitive morning.  
- Do **not** blame skip-Premiere without E3 (if they *did* sit 09:00–10:20, skip-Premiere is not “they never found the cafe”).

### E9 — Held bars (one paragraph)

Reconfirm persist 0 over-6 through the challenge window, 15/15 people every movement file 0–305, no traceback. If start-jump is still green, occupancy is not a teleport bug.

### E10 — Prior artifacts to attach (do not re-score 25-1 unless a number is disputed)

- `double-ivan/20260825_checklist.md` — stay-pin FAIL, §2 H2/H3, §12 trails  
- `double-ivan/20260827_checklist.md` — this sim’s mid-run table  
- `double-ivan/20260901_launch.md` — Pass 1 cut  
- `COS/tasks/2026-08-27-002/mvp-cut.md`  
- `COS/tasks/2026-08-27-001/final.md` — 25-1 score  
- Code: `plan.py` `_SURVIVAL_GATHER_LEAD_HOURS = 0.5`, `_maybe_apply_gather_lock`; `survival/controller.py` challenge `gate_open_hour=self.challenge_deadline_hour`; `action_contract_v1.strip_offsite_survival_ritual`  
- Launch map says `20260821_checklist.md` — **not in `double-ivan` root** at handoff time; 23-2 numbers live inside the 25-1 paper. Do not block on finding the 21 file.

---

## 7. Hypotheses to test (not conclusions)

Test these against E1–E8. Rank after evidence. It can be **more than one**.

| ID | Hypothesis | What would confirm | What would kill it |
|---|---|---|---|
| **A** | Shortening lock 10:00→10:30 **unpinned** the morning: they sat ~09:00–10:20, left, lock arrived to an empty cafe | Occupancy high before 10:30, **~4 at 10:30**, H2 last_on before step 275 | Room was empty all morning until 10:30 |
| **B** | Stay-pin still does not hold **inside** 10:30–11:00 (same 25-1 failure, shorter window) | last_on at or after 275, leave dest off-cafe, few `GATHER_LOCK:STAY` | All H2 last_on before 275 |
| **C** | Pin no-ops because dest still **names Hobbs** while the body leaves | Leave rows with dest containing Hobbs / cafe bbox | Leaves show college dest and STAY prints |
| **D** | `chatting_with` skipped the lock | Chat flag set on leavers 10:30–11:00 | No chat on those steps |
| **E** | 30 min walk-in is too short from jobs (new H3) | True never-sits; Manhattan from 10:30 tile > ~30 | All absentees had sat earlier (A/B) |
| **F** | Skip-Premiere (no grace day) changed the first morning | First Hobbs visit much later than 25-1 day-1 trails | Same sit-then-leave curve as 25-1, just unpinned (A) |
| **G** | Honest-text strip never sees off-cafe **bodies** because dest is forced to Hobbs | Fire dest names Hobbs, loc does not | Fire dest is college and description still Hobbs (strip not on emit path) |
| **H** | Challenge `deadline` at 11:00 with spatial pull-forward **off** did not change occupancy (room was never at 12) | No spatial_gate row; occupancy never ≥12 that morning | Occupancy hit 12 before 11:00 and we still waited (then the *declared-time* choice cost a full room that would have counted under old fire-when-12 — **still do not recommend pulling fire forward**; just record it) |

---

## 8. RCA shape (after the pack)

Write the RCA as a short paper (dated, `double-ivan/`), not a chat. Include:

1. **One-sentence product read** (what a viewer would see at 11:00).  
2. **Root cause class** — A/B/C/… with evidence. If mixed (e.g. 7 pre-lock leaves + 2 pin failures), say the mix with counts.  
3. **Comparison table** — 23-2 / 25-1 / 27-1 first competitive 11:00 only.  
4. **What we already tried** and why Pass 1 did not move the needle (or made it worse).  
5. **What not to do** — restated founder band-aids.  
6. **Recommended next experiment** — one bet, naturalness-first, testable on the **next** sim. Not a patch on `20260827-1`. Vote at 20:00 on this run is still worth scoring when it fires.  
7. **Open questions** the evidence could not answer.

Do not ship gather. Do not call stay-pin or Pass 1 green.

---

## 9. Ops crumbs (VPS)

- Host: `root@62.238.113.45` · key `%USERPROFILE%\.ssh\id_ed25519_vps`  
- Repo: `/var/www/generative_agents` · branch `railway` · tip `266aa54f`  
- Gateway: HTTP `127.0.0.1:8001` · unit **`api-gateway`** (not `double-api`)  
- Status: `curl -s http://127.0.0.1:8001/api/simulations/20260827-1/status/current`  
- Headless: `HEADLESS_TAB_REUSE=false` already  
- PowerShell: do not nest `&&` and mixed quotes; scp the collector, run with a single-quoted remote command  
- Supabase project `kkjhsozszgoorwehhsdg` schema `double` — optional for season_state / challenge_results; tiles in movement JSON are SOT for occupancy. `simulations` uses `status_id`, not `status`. Season row may key by simulation UUID, not `sim_name`.

---

## 10. Evidence pack checklist

- [ ] E1 NDJSON fire row  
- [ ] E2 full-morning H2/H3 vs lock-window H2/H3 (15 rows)  
- [ ] E3 occupancy every 5 min 08:00–11:15  
- [ ] E4 `GATHER_LOCK` grep + leave dests after 10:30  
- [ ] E5 daily-plan snippet for absentees  
- [ ] E6 distance for remaining true H3  
- [ ] E7 dest vs loc vs act at fire (sample 3 + summary)  
- [ ] E8 directive / skip-Premiere note  
- [ ] E9 persist + 15/15 through step 305  
- [ ] Attach 25-1 §12 trails for the same names  

**Then** RCA (§8). Not before.
