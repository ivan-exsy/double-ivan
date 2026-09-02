# 20260831-1 — Checklist: Pass 2 talk score

**Purpose:** Score **cafe talk** on a new skip-Premiere fork. One sofa = one talk; full talk only if both want it; linger +10 min once. Occupancy at **11:00** and **20:00** is a **hold**, not a second bet.

**Prior:** `20260829-1` 1-B **PASS occupancy** — day-1 11:00 **15/15**, 20:00 **14/15**; day-2 11:00 **12/14**, 20:00 **12/14**. Persist over-6 **0**. Whitelist relocates **0**. Sofa was **not** on that run. Paper: `20260831_pass_2.md`. 1-B card: `done/20260829-1_checklist.md`.

**This tip:** `railway` / `ivan/pass-2-talk` @ **`2f5f7269`** (1-B line `273e1f55` + greeting-sit persist + suite hygiene). Deployed 2026-08-31. A start off `273e1f55` would be a second 1-B, not Pass 2.

**Score sim:** `20260831-1`  
**Match 1-B exactly:** `soul15_seed_20260224` · `copy_memories=true` · `copy_coords=false` · sprint · **`skip_premiere: true`** · `max_steps: 2400` · **`diagnostic_mode: false`** · `HEADLESS_TAB_REUSE=false` · `TASK_DECOMP_CONTEXTUAL_ENABLED=true`

**Diagnostic stays off.** Chat ids, first lines, occupancy, and persist are already on disk. Diagnostic filled the box last time we left it on.

**Score at tiles, not labels.** Cafe box **x 72–83, y 19–30**. Day 1 **/15**; day 2 **/14**. Occupancy bar **12** then **11**.

**Primary bet:** talk. Compare to Pass 1 (`20260827-1` through step 1850): **917** distinct chat opens; **72** greeting re-opens within **30** steps of the last talk (many gap = **1** minute). Irene–Olivia **54** opens; Shepard–Alexis **45**. Example: Irene–Max steps **1456–1460** — five separate `Morning, Irene` / `Morning, Max` opens, one per minute, without leaving.

**Not this pass:** seek, sit-and-read list widening, leftover cafe walks, overlay “you played / you were absent”, drain/continue, FE home-snap, RLS/disk, Shepard sleep booking. Suite hygiene is **already green locally** (1780 passed / 81 skipped) — not a sim gate.

**Out (unchanged):** H3 dest-rewrite, fail-closed, longer pins, fire-when-12, restore the lock.

---

## What you would miss if you only did stop → pull → start

1. **Confirm the box is on `2f5f7269` after pull**, before fork. `273e1f55` has will + linger + full-talk gate, but **hello-only sits still re-greet**. That is the Pass 1 mill.
2. **Seek stays off.** Walking toward a named person moves bodies. If occupancy dips, you cannot tell linger (kept people) from seek (walked them out).
3. **Do not add `study` to the cafe list.** Mixing list widening in makes an occupancy miss unreadable.
4. **Disable `apt-daily-upgrade` auto-restart of `api-gateway`.** Killed `20260822-1`.
5. **Do not resume `20260829-1`.** It completed at step **2399**. Stopping a leftover PID is not a data loss.
6. **First read is re-greets**, not the 11:00 count. Occupancy is a hold. If the mill is still 72-in-30, more steps will not save it — **stop**.
7. **If occupancy dips below bar:** stop and split. Do not guess linger vs something else. Do not restore the lock.

---

### When to look — checkpoint ladder

Step 0 = day-2 05:55. One step = one minute. Pace ~50–80 steps/h. Track the **step**, not the wall clock.

Quote `conversation_id`, first line, `act_address`, and names **verbatim**. Do not shorten to “they said hi again.”

| # | Step | Clock | What you read | If it's wrong |
|---|---|---|---|---|
| 1 | **~5** | 06:00 d1 | Engine jumped; Survival on; no premiere / “full cohort of fifteen”. Tip is `2f5f7269` | **PASS** @246. Tip `2f5f7269`. Log: `Skip premiere: clock 2026-08-31 06:30:00 → 2026-09-01 05:55:00 (engine day 2 05:55)`. `full cohort of fifteen` = **0**. `premiere day` = **0**. Status: `is_survival=true`, `current_day_label=Survival Season Day 1`. Known leftover: `Currently: On day 1 in Doubland with 15 players remaining` (same class as 1-B) |
| 2 | **~60** | 07:00 d1 | No crash. Persist over-6 = **0**. Seek logs still quiet | **PASS persist / crash. Seek not quiet.** `Rejecting movement_report` = **0**. `Traceback` = **0**. `TELEPORT FIX` is the 6-tile cap (e.g. dist `5.10` / `6.00`), not over-6. `SOCIAL_SEEK` = **63** lines — morning hunt of `Alex Butcher` (`[SOCIAL_SEEK:ARM] Max Shoemaker → Alex Butcher until_step=36`, `act_address=<persona>Alex Butcher`). That is the old Survival once-a-day seek, not a new everyday ship. **Not the mill.** Occupancy hold was never reached (stopped @260) |
| 3 | **First cafe sits** (often **~120–240**, do not wait for 11:00) | morning | **Re-greet count.** Same pair, same room, still sitting: one `conversation_id`. Log `SOFA PERSIST`. No new `Morning!` / `Hey!` a minute later | **FAIL mill — stopped @260.** Through **260** steps: **180** `👋 GREETING TRIGGERED` / `👋 Hardcoded greeting`; **77** same-pair re-opens inside **30** steps (Pass 1 needed **1850** steps to hit **72**). At `the Ville:Hobbs Cafe:cafe` alone: **140** hellos, **54** re-opens inside 30. `tier=greeting` on `CM.START` = **0**. See §8 |
| 4 | **240–305** | 10:00–11:00 d1 | Occupancy **hold** (bar 12/15) + talk still one-id. Linger only on **full** talks | **Not scored.** Stopped **10:16** (step **260**), before the **11:00 / step 305** bar. @10:00 (step 245): **6/15** tiles — Alexis Reed `(72, 23)`, Irene Dove `(77, 22)`, Ivan Pitts `(74, 23)`, Nick Miller `(72, 25)`, Olivia King `(79, 19)`, Owen Logan `(76, 23)`. 1-B was **5** at 10:00 then **15/15** at 11:00. Do not read 6/15 as an occupancy miss |
| 5 | **785–845** | 19:00–20:00 d1 | Vote hold (bar 12/15). Evening sofa still one talk until leave | Not reached |
| 6 | **~1445** | 05:55 d2 | Headcount **14**. Premiere string still gone | Not reached |
| 7 | **1745** | 11:00 d2 | Occupancy **hold** (bar **11/14**) | Not reached |
| 8 | **2285** | 20:00 d2 | Occupancy **hold** (bar 11/14). Then **stop** | Not reached |

**Three places to walk away:** step 5 (wrong tip / premiere), step 60 (box sick), first cafe sits (re-greet mill still on). Walked away at checkpoint 3.

---

### 0. Preflight

- [x] `20260829-1` **not running**; PID gone. Do not resume. (status `completed`, step 2399)
- [x] Local `ivan/pass-2-talk` @ **`2f5f7269`** pushed; `railway` fast-forwarded to that tip (never rebase / force-push `railway`)
- [x] VPS `git pull` in `/var/www/generative_agents` → tip **`2f5f7269`**
- [x] `sudo systemctl restart api-gateway` (only after the PID is gone)
- [x] Unattended-upgrades will not restart that unit mid-run (`apt-daily-upgrade.timer` disabled / inactive)
- [x] Env unchanged vs 1-B: `HEADLESS_TAB_REUSE=false` · `TASK_DECOMP_CONTEXTUAL_ENABLED=true` · `MAX_TILES_PER_STEP=6` · `SURVIVAL_MODE_ENABLED=true`
- [x] Seek **off** (no everyday / multi-seek ship on this tip)
- [x] Hobbs cafe whitelist still **no** `study` (verbatim `` `["eat", "social", "serve", "relax"]` ``)
- [x] Fork + start `20260831-1`: sprint, `skip_premiere: true`, `max_steps: 2400`, **`diagnostic_mode: false`**
- [x] Engine clock jumped to day 2 ~05:55; step **0** (log: `2026-08-31 06:30:00 → 2026-09-01 05:55:00`)

**Record here:** fork `2026-08-31T18:18:47Z` · UUID `1e1ce8ec-a49e-43bf-acf7-44d009e38644` · PID `945175` · tip `2f5f7269` · sim `20260831-1` · maze `4b87de62-ab03-4691-9a02-23a457407b7b`  
**Stop:** force-stop `2026-08-31` · status `stopped` · step **260** · `curr_time` `2026-09-01T10:16:00+00:00` · `backend_process_pid` null. **Do not resume.** New skip-Premiere only after a named fix.

---

### Clock map (same as 1-B)

| Event | Clock | Step |
|---|---|---|
| Day-1 challenge | 11:00 | **305** |
| Day-1 vote | 20:00 | **845** |
| Day-2 05:55 | — | **1440** |
| Day-2 challenge | 11:00 | **1745** |
| Day-2 vote | 20:00 | **2285** |
| Day-3 replan overwrites day-2 | midnight | 2525 |

**Minimum useful run: 2285** for the occupancy hold. Talk can fail earlier — stop then. Then stop; do not run to 4000.

---

### 1. One sofa = one talk (the gate)

Bar: same pair, same seat: they do **not** greet again after a pause. Leave the room (or a next act that cannot include talking) ends it. A real leave then a new hello is fine.

Count the same way as Pass 1 (through a comparable window; write the step you stopped at):

| Signal | Pass 1 (`20260827-1` @1850) | This run (`20260831-1` **@260**) |
|---|---|---|
| Distinct chat opens (new first-line clock) | **917** | **199** — **180** `greeting_{step}_…` ids + **19** ConversationManager session ids |
| Opens that start with Hey / Morning / What’s up | **218** | **97** of the 180 hardcoded hellos (the rest are kitchen / shared-activity lines like `` `Smells good in here!` ``) |
| Greeting re-open within **30** steps of the last talk | **72** (many gap = **1**) | **77** (Hobbs cafe: **54**). Already worse than Pass 1’s whole run, in **14%** of the steps |
| Same pair, many opens (worst pair) | Irene–Olivia **54**; Shepard–Alexis **45** | Not comparable at 260. Worst in this window: Andrew Abrams + Vincent Slater **5** hellos, **4** re-opens inside 30 (library then `the Ville:Hobbs Cafe:cafe`). Six-hello pairs already: Mike–Nick, Alex–Dean, Owen–Vince |

Quote at least one continued sit: same `conversation_id`, two bursts, first lines are **not** a fresh `Morning!` / `Hey! What’s up?`.

**Did not hold for hellos.** Village hellos never create a ConversationManager session, so `🛋️ SOFA PERSIST` never saw them. Example, still in `the Ville:artist's co-living space:common room`:

- `👋 GREETING TRIGGERED: Alex Butcher ↔ Alexis Reed step=128 cooldown=1 reason=medium_overlap_no_will`
- `👋 Hardcoded greeting: Alex → Alexis (morning): "Hey, good morning."`
- Same pair **129** (`Hey, good morning.` again), **134**, **139** (`Morning! Sleep well?`)

Cafe example, both already at `the Ville:Hobbs Cafe:cafe`:

- `👋 GREETING TRIGGERED: Owen Logan ↔ Vince Vale step=75 cooldown=3 reason=first_daily_fleeting`
- then **78**, **83** — `👋 Hardcoded greeting: Owen → Vince (morning): "Morning! Sleep well?"` / `"Morning! How are you?"` / `"Good morning! Ready for the day?"`

Irene–Olivia (Pass 1’s worst pair) already **4** hellos at steps **162, 165, 176, 181** (`Getting some coffee?` / `Hey, good morning.` / `Good morning! Ready for the day?` / `Smells good in here!`) then two **separate** full-talk ids `Irene Dove_Olivia King_187` and `Irene Dove_Olivia King_226`.

Log watch: `🛋️ SOFA PERSIST` on greeting **and** full sits that stay in-room. `🧹 GREETING EXPIRED` must not mint a new hello for a pair that never left.

**`🛋️ SOFA PERSIST` = 15**, all on **full** talks, `overlap=2` (one at 3). **`tier=greeting` on `CM.START` = 0.** **`🧹 GREETING EXPIRED` = 0** (hellos are cleared by the one-minute sit + emit wipe before that sweep). Persist **did** hold a `session=` across a couple of minutes for people who already qualified for a long talk — then Writer 2 killed those ids (below).

**Pass talk** = greeting re-opens inside 30 steps **fall hard** vs 72, and the worst same-pair mill is gone. **FAIL.** Do not require 917 → 0 opens — strangers may still say hello **once**. `first_daily_fleeting` (**42** of 180) is that once. The mill is everything after.

---

### 2. Full talk only if both want it

Strangers still say hello. A long sit is for people who already know each other (or Survival allies / trust).

| # | Signal | Pass? |
|---|---|---|
| 1 | Long overlap + no will (new / low-familiar pair) → **greeting only**, not a 3–10 exchange | [x] **as coded, and that is the mill.** **104 / 180** hellos are `short_overlap_no_will` (**56**), `medium_overlap_no_will` (**46**), `long_overlap_no_will` (**2**). The gate refused the long talk, then the hello path minted a new `greeting_{step}_…` every few minutes |
| 2 | Long overlap + will (affinity / ally / trust / already talked today) → **full** talk | [x] **happened** — **60** `CM.START` lines, all `tier=full`, **19** unique `session=` ids. Viewer still heard a mill because those ids died `desync_scratch_cleared` and restarted (Ivan–Owen `_132` → `_192` → `_231`, all at `the Ville:Hobbs Cafe:cafe`) |
| 3 | Linger does **not** fire on a greeting-only sit | [x] Linger helper **never ran** (`linger_used` = **0**, no `SOFA LINGER`). All persist lines had leftover overlap **2**, so the +10 branch (overlap ≤ 0) did not fire. Nick’s `` `lingering over a second cup of coffee` `` is a **planner** line, not the helper |

Quote `conversation_type` / tier and the pair. Do not paraphrase “they seemed close.”

Will means affinity ≥ **0.2**, or a Survival ally / trust, or they already had a full talk today. Most morning cafe pairs have none of those, so a sit that would have been a conversation became another `` `Hey, good morning.` ``

---

### 3. Linger +10 min, once (full talks only)

If both still want it and the next act can include talking, they stay put **once**. Sleep, another job, or gather hour still ends it.

| # | Signal | Pass? |
|---|---|---|
| 1 | At least one full sit: both `act_duration` stretch **+10**, **same** `act_address` | [ ] **Not seen.** Helper did not run. Stopped before 11:00 |
| 2 | Same `conversation_id`: second linger does **not** fire (`linger_used_for_conversation_id` already set) | [ ] Not reached |
| 3 | Next act sleep / other workplace / gather hour → **no** extend | [ ] Not reached |

Linger without the will gate would pin people who never wanted a long talk. If (2) in §2 fails, do not call linger a pass. **Unscored** — not why talk failed.

---

### 4. Occupancy hold (not the bet)

Same bar as 1-B. If it dips, **stop and split** — do not patch on this tip.

| Fire | Bar | 1-B | This run |
|---|---|---|---|
| Day-1 challenge 11:00 | 12/15 | **15/15** | **Not scored** (stopped @260 / 10:16). 10:00 was **6/15** — same shape as 1-B’s 10:00 (**5**), not a miss |
| Day-1 vote 20:00 | 12/15 | **14/15** | Not reached |
| Day-2 challenge 11:00 | **11/14** | **12/14** | Not reached |
| Day-2 vote 20:00 | 11/14 | **12/14** | Not reached |

Curve at 10:00 / 10:15 / 10:30 / 11:00 — 10:00 only (above). Do not invent 11:00.

**Accepted leftovers (not a Pass 2 fail, same as 1-B):** Shepard at the pub; late bodies whose dest is still Hobbs; Vince breakfast-at-home; pub `relax`/`eat`. Four-room dests that **return** by fire are not the 1-A stay-gone pile.

---

### 5. Hold from 1-B / Pass 1 (regression watch)

- [x] Start-jump persist over-6 = 0 (`Rejecting movement_report` = 0 through stop)
- [ ] Honest caption: no standing-still “heading to Hobbs” while the body is elsewhere. (1-B leftover: two **late** bodies at day-2 11:00 said `at Hobbs Cafe` while still walking — watch, not this bet.) **Not scored** — stopped before challenge fire
- [ ] Off-cafe ritual verbs ≈ 0 — not scored
- [ ] Fourth wall stays **0** spoken lines that name Doubland / simulation / backend / “as an AI”. Survival may still talk vote, alliance, challenge, who left last night — not re-opened (hardcoded templates only; no new chat templates this tip)
- [ ] Present-only / overlay still matches tiles — not reached
- [x] Lock log lines still **0**; `[whitelist]` relocates still **0**
- [x] Seek not walking people out of Hobbs as the **talk** fail. 63 `SOCIAL_SEEK` lines are the old once-a-day hunt of `Alex Butcher`, then `seek_window_expired`. Occupancy hold never reached, so seek is a **watch**, not this abort

---

### 6. After the score — next steps

**If talk is green and occupancy holds**

Public MVP village gate is clear. Then, in order, and **not** on a mixed occupancy bet:

1. Optional paperwork: stamp gather SOT Desired → Current (`sot_action-location.md` whitelist = search; `sot_survival.md` lock already Current). Talk SOT (`sot_chats.md`) only after this score.
2. Seek (everyday + multi, satiation) — own run; occupancy is now **that** bet.
3. Sit-and-read list widening / leftover location / Shepard sleep — one leftover at a time.
4. Overlay spoken “you played / you were absent” (1-B harvest: exact phrases **0** in memory; last-elim broadcast is there).
5. Drain / continue, FE home-snap, RLS/disk — ops, not village UX.

**If the mill is still on (72-like re-opens)** — **this is where we are**

The greeting persist did not hold in the village. **Stopped.** Do not turn on seek. Do not lengthen linger to hide it. Do not restore the lock. Do not resume `20260831-1`. Named writers are in §8. Next skip-Premiere only after a named fix. Founder chooses the fix; do not code until **go**.

**If talk is green and occupancy dips**

Split. Linger is the first suspect only if people **stay** who used to leave; a dip means something else moved bodies. Do not restore the lock.

**If the box is wrong (wrong tip, seek on, or `study` already on the cafe)**

Not a Pass 2 score. Tear down and restart.

---

### 7. Start payload (VPS, after pull)

```bash
curl -s -X POST http://127.0.0.1:8001/api/simulations/fork \
  -H "Content-Type: application/json" \
  -d '{"sim_code":"20260831-1","baseline":"soul15_seed_20260224","description":"Pass 2: sofa persist + will + linger","copy_memories":true,"copy_coords":false}'

curl -s -X POST http://127.0.0.1:8001/api/simulations/20260831-1/start \
  -H "Content-Type: application/json" \
  -d '{"action":"start","parameters":{"max_steps":2400,"generation_mode":"sprint","skip_premiere":true,"diagnostic_mode":false}}'
```

---

## Decision

**Talk FAIL.** Stopped at step **260** (`2026-09-01T10:16:00+00:00`). Occupancy hold **not scored** (11:00 is step **305**). Persist over-6 **0**. Whitelist relocates **0**.

The sofa-persist patch only runs on ConversationManager sessions. Village hellos use a **parallel** 1-minute path (`👋 Hardcoded greeting`, new `greeting_{step}_…` id). Tests never exercised that path. Full talks that did persist then died `desync_scratch_cleared` and reopened under a new id at the same cafe.

---

## 8. RCA — why the Pass 2 talk fix failed

**Product lie:** people on the same sofa keep saying hello. Viewer should hear one talk until they leave. They heard a new `` `Hey, good morning.` `` every few minutes.

**Cheap falsification for the next score (read before 11:00):** same pair, still at `the Ville:Hobbs Cafe:cafe`, a second `👋 GREETING TRIGGERED` inside **30** steps → **0** (or near-zero). `CM.START` `tier=greeting` only if hellos are routed through persist. `reason=desync_scratch_cleared` should die if Writer 2 is fixed. If those signatures are unchanged at first cafe sits, stop — the diagnosis is wrong.

**Out (unchanged):** H3 dest-rewrite, fail-closed, longer pins, fire-when-12, restore the lock, add `study` to the cafe list, turn seek on, lengthen linger to hide the mill.

### Writer 1 — primary. Hellos never sit as one talk

`should_converse` may return `conversation_type == "greeting"`. Production then **does not** call `start_conversation` / `try_persist_or_linger`. It:

1. Prints `👋 Hardcoded greeting` from `GREETING_TEMPLATES` (`morning`, `close`, `kitchen`, `common_room`, `shared_activity`, …)
2. Mints **`greeting_{effective_step}_{sorted names}`** — a new id every minute
3. Sets `chat_end_step = effective_step + 1` (one-minute sit)
4. Prints `👋 GREETING TRIGGERED: … reason=…`

That branch also sets a pair cooldown and increments daily encounters. Cooldown is **1–6** steps (102 of 180 were `cooldown=5`; **12** were `cooldown=1`). The Pass 1 mill bar is re-open inside **30** steps. A 5-minute pause is still a mill.

**Why this run minted 180 hellos:**

| `reason=` (verbatim) | Count | What the viewer heard |
|---|---|---|
| `short_overlap_no_will` | **56** | Sit was long enough for a conversation; will said no; **hello anyway** |
| `medium_overlap_no_will` | **46** | Same, longer leftover sit |
| `first_daily_fleeting` | **42** | First hello of the day — this is the one we want to keep |
| `fleeting_same_arena` | **34** | Leftover sit time **< 3** minutes, so a sofa looks like a passing wave. Every `🛋️ SOFA PERSIST` logged `overlap=2` |
| `long_overlap_no_will` | **2** | Long sit, still hello |

Will-fail (**104 / 180**) is the Pass 2 packing working as coded (“full talk only if both want it”) and then falling into the Pass 1 mill (“strangers still say hello”) **on a loop**, not once.

`first_daily` skips the cooldown check. First hello can land with `cooldown=1`. Then:

- `👋 GREETING TRIGGERED: Alex Butcher ↔ Alexis Reed step=128 cooldown=1 reason=medium_overlap_no_will arena_a=the Ville:artist's co-living space:common room arena_b=the Ville:artist's co-living space:common room`
- Same pair **129** `cooldown=5 reason=medium_overlap_no_will`

Cafe liveliness still subtracts cooldown (`cooldown_mod=-2` on Hobbs). The pair floor then lifts it to **5** after the first meet (`🕐 pair CD floor: 3 → 5 (times_today=1 type=greeting)` — **150** of those floor lines). Five minutes later they hello again on the same sofa.

**Why tests were green:** `test_greeting_same_arena_does_not_regreet` calls `start_conversation(..., conversation_type="greeting")` then `try_persist_or_linger`. Village hellos never create that session. `CM.START` `tier=greeting` on this run = **0**.

### Writer 2 — full talks that did persist still mint a new id

ConversationManager **did** persist full talks: **15** `🛋️ SOFA PERSIST`, **19** unique `session=` ids, **60** `CM.START` (bursts of the same id), all `tier=full`.

Then **15 / 18** `CM.END` were `reason=desync_scratch_cleared` after **2–9** minutes, still in-room. New id, same cafe:

- `Ivan Pitts_Owen Logan_132` → `_192` → `_231` at `the Ville:Hobbs Cafe:cafe`
- `Irene Dove_Olivia King_187` → `_226`
- `Owen Logan_Vincent Slater_157` → `_250`

Verbatim:

- `🛋️ SOFA PERSIST: ['Ivan Pitts', 'Owen Logan'] session=Ivan Pitts_Owen Logan_132 step=134 overlap=2`
- `📋 CLEAR: Ivan Pitts chatting_with=Owen Logan cm_session=active step=134` (persist kept the session)
- `⚠️ DESYNC REPAIR: CM session Ivan Pitts_Owen Logan_132 for Ivan Pitts but scratch.chatting_with is None — ending session`

**Writer that cleared `chatting_with`:** persist **empties** `chat_queue` on purpose (wait for the next burst). The movement-emit path then treats “chat this step, no remaining queue” as a **one-shot hello** and sets `chatting_with` to none. Next housekeeping sees an active session with no scratch partner → `desync_scratch_cleared` → `reset_chat_state` (also clears `sofa_persist`). Every persist line has a matching `📋 CLEAR: … cm_session=active` at the **same** step; desync is **1–2** steps later. `📋 CLEAR: … cm_session=none` = **0** on this run. `🧹 GREETING EXPIRED` = **0**.

`sofa_no_will` skips (**16** CONV MANAGER) correctly refused to continue a full talk without will — then Writer 1 said hello instead.

### Not the mill

- **Seek.** 63 `SOCIAL_SEEK` lines; morning hunt of `Alex Butcher`. Old Survival once-a-day seek on the 1-B tip. Pass 2 packing said do not ship everyday/multi-seek. Occupancy never reached the bar.
- **Linger.** Helper **0**. Planner copy `` `lingering over a second cup of coffee` `` is not +10.
- **Whitelist / lock.** `[whitelist]` = **0**. Do not re-add the cafe-list veto. Do not add `study` to `["eat", "social", "serve", "relax"]`.
- **Walk persist.** `Rejecting movement_report` = **0**.
- **Gather pre-window** (10:30–11:00) is **not** why dawn/morning mill happened. Stopped at **10:16**.

### What a later fix must change (founder chooses; no code this paper)

The sofa product is **one sit = one talk until they leave**. Packing asked for two things that collided: “hello if they don’t want a long talk” and “do not greet again after a pause.” Today, will-fail **is** a new hello every 1–5 minutes.

Any of these would kill Writer 1’s signature (same pair, same `the Ville:Hobbs Cafe:cafe`, new `greeting_{step}_…` inside 30). Pick one; do not mix with occupancy work:

1. After the first hello (or a will-fail), **stay quiet** until they leave the room — not another `Morning!`.
2. Route hellos through ConversationManager persist so one hello sits until leave (what the unit test already thought was production).
3. Stop minting `greeting_{step}_…` / 1-step end for a pair that never left.

Writer 2 is separate: persist must not look like “chat is over” to the emit wipe, or the emit wipe must not clear `chatting_with` while a session is still meant to sit.

Do not hide either writer with a longer linger, a longer pin, or seek.
