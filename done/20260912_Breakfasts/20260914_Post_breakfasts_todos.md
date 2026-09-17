# Archive — Breakfasts investigation (through 15 Sep)

**Closed 15 Sep.** Do not add new tickets here. Open work lives in [`20260915_TODOs.md`](20260915_TODOs.md).

This file keeps **what we already proved** and the **Wave 2 post-mortem** (score table). The **RCA** (why V2/V3 failed) lives in [`20260915_TODOs.md`](20260915_TODOs.md) — do not rediscover it here. Saturday clicks / Start / allowlist stay in [`20260912_breakfasts_run.md`](20260912_breakfasts_run.md). Talk spec: [`20260913_E1E2_hello_design.md`](20260913_E1E2_hello_design.md).

| Wave | Status |
|---|---|
| **0** | Shipped — Watch chat Tier B, caps 50/50, empty-roster seed |
| **1** | Shipped — portal name + Watch FE (`d7a351e`) + skip-premiere date stamp |
| **1.5** | Shipped — planning stall + pager (`sim_code` fills on next Start) |
| **2** | **Partial (15 Sep)** — live on product; R1 `20260915-1` @300 **completed**. Hello-once **PASS**. Planted sit → real talk **FAIL**. Plant fixture missed. T-E6 / resume / Watch lore **not scored** |

### Closed (keep so we do not re-open)

| ID | Done |
|---|---|
| **T-P1 / T-P2 / T-P3 / T-P6 thin / T-P7** | Portal 14 Sep (`0076a45` on www) |
| **T-W1 / T-W2 / T-W7** | Watch map, first-run tour, talk lines on the card |
| **T-W3** | New Joins use the typed name. Saturday’s 3 email-names = manual rename only |
| **T-W8 UX** | Staged wait copy. Engine latency still open |
| **T-W4 / T-W5 / T-W6** | **Code** shipped. Field-verify on a **running** Start still open |
| **T-W9** | HUD date **15 Sep** on `20260915-1` |
| **T-E3 / T-E4** | Watch chat Tier B; caps 50/50 |
| **T-E2 spam** | `20260915-1`: one hello per pair, 0 repeats (V1) |
| **D1 / D2** | LIVE default 6×; Breakfasts uses gateway after `live.json` 404 |
| **W1.5** | Empty/timeout planning = miss; pager names the sim |

### Still open (board = 15 Sep TODOs)

Use the tickets **below** as investigation, not as the to-do list.

| ID | Miss | What in this file helps a fix that will stick |
|---|---|---|
| **T-E1** | Hello never becomes a conversation | Saturday park (Luba↔Yevgenia nod then quiet). Wave 2: 0 full talks; Gosha↔Luba 240 touches after 07:09. RCA (15 Sep TODOs): C1 schedule[0] `sleeping` hard-stop; C2 same-cafe then too-far. Do not walk-to-person. Do not resume `20260915-1` |
| **T-E8** | Status early / sticky / person-name dest | 15 Sep Watch: closet + “walking to Gosha”; street + “finishing breakfast at Hobbs”; behind the bar, still walking to Gosha. Options A+B only. That line is **not** a hunt |
| **First-sight hello** | Dorm pass-bys silent except Katya↔Luba 06:57 | Not T0–T7 until you say so. Current bar is same room, not “first sight today” |
| **Plant fixture** | Gosha+Katya captions said cafe; bodies in dorm until Katya 10:14 | Next score must plant **tiles**. Caption-only plant is how V2 got a dirty fail |
| **T-E7** | Sleep on bed | Paired with T-W10 snaps. Do not FE-lerp 1-point hops |
| **T-E6 / T-E5 / V8** | Shipped, not scored | Need 05:55 dawn log; a Watch Chat; a real stop+resume |
| **T-W4/5/6 field** | Need a running sim | Completed `20260915-1` correctly stayed replay |
| **T-P4 / T-P8 / S1** | Correct the Double after done | S1 already locked (retake vs ISS edit). Build list is in T-P4 below |
| **T-P5 / T-P6 leftover / T-P9 / T-W8 latency / S2 / S3 / B1 / B2** | Later | Research locks stay in the Behavior / Shared sections |

**How this file was used:** portal vs watch vs engine vs behavior. Items marked **Shipped** are done. **Saturday evidence** is what testers actually hit.

---

## Wave 2 post-mortem — `20260915-1` (15 Sep)

R1 score slice. Spec: [`20260913_E1E2_hello_design.md`](20260913_E1E2_hello_design.md) §5. **Do not treat this as a green Wave 2.** Do not resume this sim as a talk score. **Why V2/V3 failed:** [`20260915_TODOs.md`](20260915_TODOs.md) §Wave 2 RCA.

**Verdict: partial.** The Friday hello mill is gone. The Saturday “they stand there and only nod” miss is still on. The planted pair never actually sat together at breakfast, so V2 is also a **fixture miss**, not only an engine miss.

### What we ran

4 Doubles (Gosha, Katya, Ivan, Luba), village / Hobbs, Survival day 1, sprint, diagnostic off. First slice **300 steps then completed** (not stopped for resume). Clock **15 Sep 06:30 → 11:29**. Tip `railway` @ `896ab1eb`. Plant target was Gosha+Katya at Hobbs as strangers.

Spec wanted skip-premiere dawn (05:55), ≥900 steps, plant at 06:00, **stop+resume at ~300**. This slice started at **06:30**, ended **completed** at 300, and the plant did not stick.

### Score vs design

| # | Check | This slice | Note |
|---|---|---|---|
| **V1** | One hello per sit; no re-greet | **PASS** | 6 pairs, 6 hellos, 0 repeats. Encounter rows exist |
| **V2** | Planted strangers ≥ 1 real talk | **FAIL** | Pair never co-sat at Hobbs until 10:14; 0 full talks all run |
| **V3** | Long sits talk 30–85% of the time | **FAIL** | 0 talks. Gosha↔Luba close at Hobbs ~70 min after 07:09, still only the nod |
| **V5** | Hello ≤ 2 lines, no topic carry | **PASS** (hellos) | All six are 2-line mornings. No full-talk row to score |
| **V6** | 11:00 occupancy 4/4 | **PASS** | Hold for the Shield; all four on Hobbs tiles. 20:00 not reached |
| **V7** | No leftover on a hello | **PASS** (hellos) | Leftover mint / stance need a full sit — N/A |
| **V8** | Remember the sit after resume | **N/A** | Sim **completed** at 300; no stop+resume |
| **V9** | Affinity from one talk, not four hellos | **FAIL** | No talk |
| **V10** | Cap 6 | **PASS** | 0 jumps over 6 |
| **V4, V11–V15** | Cost hour / replay / initiator / intent topic | **N/A** | No full talk; not R3; no resume |

Hellos on the clock (Watch should show these; founder confirmed the cards):

| HUD | Pair | Where the bodies were |
|---|---|---|
| 06:57 | Katya ↔ Luba | Dorm (not Hobbs) |
| 07:09 | Gosha ↔ Luba | Hobbs |
| 10:14 | Gosha ↔ Katya | Hobbs (first time the planted pair share the cafe) |
| 10:15 | Ivan ↔ Luba | Hobbs |
| 10:16 | Gosha ↔ Ivan, Ivan ↔ Katya | Hobbs |

### What Watch showed (founder walk, same run)

Checks **1, 2, 4, 5, 6** from the score handoff matched the data: hellos that exist show on the person card; completed run does not go LIVE; 11:00 all four at Hobbs; HUD date is **15 Sep**; no long cafe conversation to play.

**Failed on this sim (locked):**

1. **Plant did not land.** 06:30 Gosha and Katya are in the dorm. Captions already say sitting at a cafe table. Gosha at Hobbs by ~06:50 and stays. Katya wanders college/dorm until **10:14**.
2. **Hello does not become a conversation.** Gosha and Luba nod at 07:09, then stay on that nod. Later they sit close for a long stretch and still never start a real talk. **T-E1 still open.**
3. **Status is early and sticky (T-E8, not Wave 2).** 06:40 Luba: “walking to Gosha” while in Room 3 closet. 06:45 Gosha: “finishing breakfast at Hobbs” while still on the street. 07:18 Luba: still “walking to Gosha” while already behind the bar.
4. **Almost no first-sight hellos.** 06:30–07:00 only Katya↔Luba (06:57). Gosha↔Ivan were 4 tiles apart at 06:30; Ivan↔Katya 3 tiles at 06:32; no nod. Ivan is asleep from 06:40 (later silence is fair).
5. **“Walking to Gosha” was not a hunt.** Same lying caption as (3). Luba’s real job was open the cafe / stand behind the bar. Wave 2 also does not walk someone to a person (PM-VIL-1). Do not read that line as failed seek.

07:08 on Watch looked like Luba greeted Ivan at the cafe. **It was Gosha at 07:09.** Ivan was still in bed.

### Not scored on this slice

| Item | Why |
|---|---|
| **T-E6** 90s first planning try | No engine log. Clock started 06:30, not a 05:55 dawn freeze |
| **V8** resume remembers the sit | Completed at 300, did not stop+resume |
| **T-W4 / T-W5 / T-W6** LIVE catch-up, scrub stays LIVE, `?double=` camera | Needs a **running** sim. Completed playback correctly stayed replay |
| **T-E5** secret-pair Watch lore | No owner Chat thread on this sim |
| **T7** SOT | Still waits on a green 4-person talk score |

### What to do next

- **Do not resume `20260915-1` to “finish” Wave 2 talks.** The plant already missed; 11:00 gather also refuses new talks from 10:30. A continuation will not repair V2.
- Next talk score: new 4-person fork, plant that **sticks on tiles** (not only in the caption), both free in the same cafe from wake, run **through lunch** (not only 11:00). Then stop+resume once for V8.
- **Do not tune the talk chance** to hide this. V1 already passed. V2/V3 failed because they never talked, and the plant never sat.
- Caption / “walking to *person*” / first-sight nod stay **T-E8** (+ a first-sight hello bar if you want it). Do not fold them into T0–T7.
- Watch LIVE catch-up (**D5**) still needs a Start on an already-open tab.

---

## Tech — portal (Login → Double → Join)

### T-P1. Quiz on mobile

**Shipped 14 Sep (landing `0076a45` on www):** 40px quiz knobs. Welcome uses the RQ-T-P1 honesty + any-language lines. Quiz chrome no longer says `English`. Chat still shows `any language`.

Finger navigation is cramped. Larger tap targets and larger text.

**Also copy (can ship without research):** before the first quiz, tell people that honest answers plus a real “why” make a better Double and better predictions. In Chat, make it obvious they may answer in **any language**.

**Behavior recommendation RQ-T-P1 — Honesty chrome (copy, 12 Sep):** one screen before the first item: “Answer how you **usually** act, not how you wish you’d act. Honest answers + a real ‘why’ in chat make a better rehearsal partner — not a diagnosis or a fortune teller. You can answer the chat in **any language**.” No “scientifically proven” language. Ties to consent already in the portal report.

### T-P2. Look: photo + sprite are required, and the first action is the photo

**Shipped 14 Sep (landing `0076a45` on www):** Take photo glows until a still is chosen. Next stays clickable; missing photo, sprite, or consent shows an error and stays on Look.

Highlight **Take photo**. If they try to continue without photo *and* sprite, stop them and say both are required.

### T-P3. Look can freeze *after* a successful save — **bug**

**Shipped 14 Sep (landing `0076a45` on www):** wait sites `try/finally` `endWait`; network throws return `{ ok: false }` via `portalTry`; a failed compile is dropped from cache so retry is not stuck. Field verify: airplane-mode mid-save should show an error with working retry, no stuck spinner.

Not “they forgot the photo.” Saturday: Yevgenia’s quiz (10), chat (4), photo, and sprite were already in Supabase; the Look screen never advanced.

**Workaround (do not start over):** leave the stuck page → `https://www.doubland.ai/account`. Distinct from Meet “takes forever” — backend was done, UI did not move.

**Diagnosis 12 Sep (code-read):** prime suspect is an **uncaught network throw wedging the spinner on**. The save helpers (`saveAvatarPick`, `uploadLookPhoto`, `completeOnboard`) `await fetch` with no try/catch, and the callers (`persistLookAfterDone` ← `saveLookAndGoAccount` / `finishMeet`) call `beginWait()` with no try/finally. Any transient throw after partial saves — e.g. a mobile blip where the POST reached the server but the response never arrived — leaves `busy` stuck true forever: every button disabled, wait line on, **no error shown**. That is exactly “backend done, UI did not move,” and the /account workaround works because the data is saved. Sticky variant: a rejected compile promise stays cached, so “auto” callers re-throw it on every retry until something invalidates. Same missing-try class at `saveQuizReview`, `saveReview`, `goChatReviewBack`, and account `startJoin`/`finishJoin`/`saveLook` (`startChat`/`goChatNext` already have try/finally — the safe pattern). Ruled out: dead Next button (consent box renders, gate wired), unwired photo file (wired), backend-shaped failure (those show an error, not a freeze). **Hotfix shape:** try/finally `endWait` at every wait site + clear the cached compile on rejection.

### T-P4. Meet Your Double: verify, then correct, without losing answers

Ask them to verify the profile below. If they dislike something, they should be able to change it.

Two correction paths to choose later (see **S1**): go back to the quiz and edit original answers, *or* edit raw profile records directly.

If they go back, previous answers must still be there. Nothing lost.

**Design scope 12 Sep (S1 locks already decided — this is the build list, no code yet):** what exists today is in-flow only — editable quiz sliders + save, chat-review edit, a display-only Meet card (quiz traits, no life-chapter text), and saved-slider restore. Gaps: (1) **Post-done review entry is a loop** — account “Review your Double” → /onboard bounces ready users back to /account; need a review mode that does not bounce, showing both layers labeled (“Disposition snapshot (from quiz)” vs “Your words (editable)” per RQ-S1a). (2) **Life-chapter direct edit UI** (`learned` / `currently` / `lifestyle` / `goals`) with previous answers preserved — no endpoint exists; needs a new PATCH on soul fields with `innate` hard-locked. (3) **Retake entry after done** (re-answer mini10 → save → recompile). (4) **Backend retake semantics not built** — quiz submit overwrites the active row in place (no history rows) and `done` early-returns for ready users without regenerating `innate`; need insert-new + deactivate-old with instrument/completed_at, plus done detecting a newer quiz and regenerating portal `innate` only (ISS/chat untouched, village BFM-25 still wins). (5) **Post-Join refresh path** — define and build how a retake/ISS edit reaches an already-joined Double (persona + agent config on next load; home/role/memories kept). (6) Account photo/sprite update when Look is already complete (`saveLook` exists but only behind the `needLook` gate). Acceptance: retake keeps history, regenerates innate only, never touches ISS; village-25 users unaffected; joined Double reflects on next load; Meet shows both layers labeled.

### T-P5. Submit / Meet wait is too long

Investigate speeding it up. Possible product move: advance to the next screen without waiting for the previous step to succeed; if it never succeeds, ask them to review / resubmit.

Do not confuse this with **T-P3** (Look stuck after a save that already worked).

### T-P6. Choose home & role — explain, then fewer real choices

**Shipped 14 Sep thin (landing `0076a45` on www):** short home/role notes; 3 open homes; hide taken roles. No map picker. No suggested-for-you LLM.

Still later: role pictures; map picker; **S2** ranking.

Short note: what this screen is and why.

Homes: **3 is enough**; only **open** homes. Ideal later: pick on a map, or at least show 3 plans.

Roles: add pictures; **3 is enough**; hide roles already taken.

Suggested roles that fit the person: see **S2** (postpone LLM).

### T-P7. Sprite card

**Shipped 14 Sep (landing `0076a45` on www):** disclaimer wording removed; spacer kept.

Remove disclaimer wording; keep the space.

### T-P8. After Login: My Account (correct the Double) **or** go to the sim

Let people review / correct account, retake the test, update photo / sprite — without hunting. Also a clear way back to the sim.

### T-P9. Accidental leave

People can leave the sim page by accident and not know how to get back. Can we block / warn exit from the sim page, and always show a return path?

---

## Tech — watch / map

### T-W1. iPhone map is inconsistent (Android was fine)

Watch: `https://www.doubland.ai/pittsburgh-business-breakfasts`

Sequence testers saw:

1. Map did not fit the screen. Center / − / + were hidden. Pinch zoom worked; **one-finger drag did not**.
2. Then the **right** side (including map controls) appeared; **left** (date & time) disappeared.
3. Then the map filled the screen and both zoom and one-finger drag worked.

Reproduce on iPhone first; Android is not the bug.

**Shipped 12 Sep (FE `d7a351e`, deployed):** `touch-action: none` on game container/canvas + no sideways page pan.

**Walk 13 Sep (Block 3 pass):** founder cold-loaded Saturday Watch on BrowserStack Live **iPhone 15 Safari**, portrait. Map fit, one-finger drag, HUD sides. Chrome/Edge “iPhone” mode is still not a close.

### T-W2. First-time map tour

On first reveal, a short tour of the few things that matter (center-on, chat with your Double). Let them discover the rest.

Prompt: have fun chatting with your Double, test what it knows about you, help improve it.

**Shipped 12 Sep (FE `d7a351e`, deployed):** two-card first-run coach (Find → Chat), once per browser, never headless.

### T-W3. Sticker names are email local-parts, not the name they chose

Not the account display name. This run: `Yevgeniapritchard`, `Lubaistomina`, `Ipistsov+20260908`.

**Portal fix shipped 12 Sep:** Meet Continue drops the cached compile and re-posts the typed name (`3b7b891` on `ivan/w1-portal-funnel`, promoted to www). Backend rename on repeat `done` is live (`railway` `c2919c4c`). Typed Saturday names were never stored — nothing to recover.

**Walk 13 Sep (Block 1 closed):** Join on stopped Breakfasts after wipe. Fourth Double `Ivan App` (`ipistsov+202260913-11@gmail.com`) on roster + step 0 sticker. Founder: onboard/Join looks good. Saturday's 3 still need founder-supplied strings for a manual rename (`personas.name` + agent config + roster). Watch confirm-only (stickers render roster `name` as-is) never replied — low urgency, no FE work.

### T-W4. Open Watch on the empty world, then Start — spinner / wrong LIVE

**Desired:** tab stays open; Start happens; map stays; then **LIVE 6×** with **no reload**.

**What happened:** Watch was already open on the **empty stopped** world. After Start, the first minutes take a few minutes to exist. Embed sat on loading. Autoplays had already marked itself “done,” so it never flipped to LIVE 6×.

Brief **LIVE 1×** = sitting on the live tip with only a few minutes generated. Hard reload started catch-up from step 0 → LIVE 6×.

At one point playback was **LIVE 1×** and speed could not be changed even though generation was far ahead of the map.

(Related shipped item: **D1**. Related desired: **T-W5**.)

**Shipped 12 Sep (FE `d7a351e`, deployed):** idle watch no longer burns the one-shot; re-arms on Start; no spinner at 0 steps. **Full close:** scratch sim, tab already open on the empty stopped world, then Start — not Breakfasts.

**Ops 13 Sep evening:** Breakfasts generated minutes wiped; status **stopped**; step 0; hidden `start_date` **2026-09-12** (skip-premiere HUD = Pittsburgh 13 Sep). Three Doubles kept at home (Yevgenia restored after Saturday elim). Survival season deleted so Start seeds the roster **after** the new Join. Allowlist still the original 3 — founder inserts the 4th row (no PUT replace). **Do not Start until that Join lands.**

**Walk 13 Sep Block 4 (open tab):** engine **step 71**, `curr_time` **2026-09-13 07:07**, generating. Watch tab still **00:00 · Sep 12** + **LIVE 15×**, bodies at homes. **T-W4 fail** (did not catch up). **T-W9 fail on this tab** (hidden start_date midnight, not Sep 13 morning). Do not reload that tab (that is the miss). Second tab cold load still needed for T-W9.

**RCA 13 Sep (reload tab 06:51 / step ~74):** not leftover extra Doubles on this Start. Slow clock = `run_gpt_prompt_task_decomp_contextual` 90–123s with empty `out=0` (77 calls); LIVE 6× cannot outrun generation. Breakfast-in-chat vs bedroom tiles = caption vs body: Yevgenia `eating breakfast at Hobbs Cafe before the challenge (settle in)` @ `the Ville:House 5:Main Bedroom:closet`. First-run old names (`Ivan Double`, `Ip+20260809 3`, …) are absent from the current log slice.

**Shipped 14 Sep (FE `4336105` on `vercel`):** idle tab seeks the LIVE cushion from polled `total_steps` (not Redux 0); gateway WS connects on stopped→running; skip-on-sleep restores the user speed (no leftover 15×). See **D5**. **Field verify:** tab already open on the empty stopped world, then Start — LIVE 6×, no reload.

### T-W5. Scrubbing should not kick you out of LIVE

Today, dragging the timeline leaves LIVE and plays as replay.

**Desired:** if the sim is still running, release the scrubber → stay **LIVE** at the speed they already picked (default 6×). Do not drop to 1× just because they grabbed the bar.

**Shipped 12 Sep (FE `d7a351e`, deployed):** release inside the live cushion re-enters LIVE at current speed; completed/stopped sims never enter LIVE.

### T-W6. Camera always on *this* user’s Double

Including while they drag the scrubber through the timeline.

**Shipped 12 Sep (FE `d7a351e`, deployed):** with a `?double=` pin, scrub/JTL focus queues the pinned Double, not the scene primary.

### T-W7. Watch chat under-reports village talks — testers think nobody spoke

Friday: three Hobbs talks were on the map; click-a-person Chat / Doubles said nobody spoke.

Spoken lines live in the **talk transcript**. Watch pastes the **activity caption**; recent-memory fallback **skips chat**.

This is a display/data bug on Watch. Village talk *quality* is **T-E1 / T-E2**.

**Shipped 12 Sep (FE `d7a351e`, deployed):** card unions live-watched lines with the backend transcript; excerpt uses the latest talk with lines.

### T-W8. First owner-chat reply takes forever

After the first message, the first reply is very slow. Shorten the wait **or** make the wait feel like something (progress, copy, a beat) — not a dead screen.

Personality *use* of that chat is **B1**. Faster reply is tech.

**Shipped 12 Sep — UX half (FE `d7a351e`, deployed):** staged wait copy (4s/10s/25s) on Talk page + Watch chat. Actual latency still engine (Wave 2+). **Walk 13 Sep:** Block 2 closed (one Chat line on Saturday Watch). Wait-copy not separately scored.

### T-W9. Watch date on the HUD

Friday pre-run showed **Sep 8**. Skip-premiere jumps **one calendar day past** the hidden start day. Saturday ops stamped Pittsburgh-yesterday so the HUD read Sep 12 (`20260912_breakfasts_run.md` §4).

**Product (drop the minus-one stamp):** Start day = Pittsburgh day you Start; keep Survival that morning; do not leave leftover create/fork dates on the HUD.

**Backend live 12 Sep (`railway` @ `c2919c4c`, VPS deployed):** Start auto-stamps on fresh sims. FE verifies the HUD on the next live Start (same gate as **D5** / T-W4). Confirm-only on a **cold** load.

### T-W10. Morning wake: 15× then bed snap + “walking” while standing (14 Sep)

Completed Saturday Watch on PC. Opens **15×**, Luba **snaps** off the bed ~06:00 and speed returns **6×**, Ivan **snaps** ~06:06 with HUD “walking to Ivan App” while standing, then a real bedroom walk ~06:10.

**FE 14 Sep:** 15×/6× is skip-on-sleep (expected). Snaps are **recorded 1-point `actual_path`** at room center, not Watch dropping a walk. Mid-morning Hobbs walk (Yevgenia 73–78) **does** follow `actual_path` tile-by-tile at 6×.

**Waiting on BE:** **T-E7** (sleep on the bed) and **T-E8** (caption matches this step’s body). Do not FE-lerp 1-point hops until Ivan says go.

---

## Tech — engine / village talk

### T-E1. Planted face-to-face should become a real conversation, not only a hello

**Saturday ~09:50, Johnson Park.** Luba and Yevgenia stood ~3 tiles apart in `the Ville:Johnson Park:park:park garden`. Looked like they should talk; at 09:50 they were silent.

They **did** exchange a one-minute hardcoded hello at **09:37**:

- `Good morning! Ready for the day?`
- `Hey, morning to you too.`

Then 09:38–~09:52 the engine skipped more talk (`sofa_greeting_quiet`). Easy to miss at 6× (~10s wall).

**Current:** hello, then silence until someone leaves.  
**Desired:** a planted face-to-face becomes a **real sit / conversation**, not only a morning hello.

**Design locked 13 Sep** ([`20260913_E1E2_hello_design.md`](20260913_E1E2_hello_design.md) — Wave 2 implementer spec): encounter keyed on bodies + DB table `pair_encounters`; per-side chance to talk; one-sided intent (A starts, topic carries, B need not want it); no new walking (PM-VIL-1 later). Tickets **T0–T7** and score bars live in that file.

**Score 15 Sep (`20260915-1` @300):** shipped, **FAIL** V2/V3. Six one-hello sits, **0** real talks. Planted Gosha+Katya never sat at Hobbs until 10:14. Gosha↔Luba nod at 07:09 then silence. See Wave 2 post-mortem above. Do not resume that sim as a talk score.

### T-E2. Two hello failure modes — keep both in the fix

**Friday cafe (hello-spam):** Doublandai ↔ `Ip+20260809 3` re-said one-line hellos minutes apart as if they had not just spoken: 09:12, 09:28, 09:33, 09:38, then again after 11:00. Catch on 1× at those HUD times (steps **197 / 213 / 218 / 223**). The 11:01 burst may also be from the chat-cap API restart wiping “already said hi.” After the first hello, same pair / same room stays quiet until they leave — **and** do not re-greet after a restart.

**Saturday park:** quiet-after-hello **worked**.

**Fine-tune:** no hello-spam, **and** a real sit when they plant in front of each other (**T-E1**).

**Score 15 Sep (`20260915-1`):** hello-spam **PASS** (V1 — one hello per pair, no repeats). Real sit still **FAIL** (**T-E1**). First-sight nods in the dorm were also thin (only Katya↔Luba at 06:57); that is not the Friday mill, and it is not T0–T7.

### T-E3. User Chat model (click a person on Watch)

Should use global **Tier B** (`LLM_MODEL_TIER_B` — production DeepSeek V4 Flash). Today it is wired to **Tier C** (`LLM_MODEL_TIER_C` — DeepSeek V4 Pro). Confirm after the demo and switch if you still want B.

**Locked 12 Sep:** Tier B for all Watch chats. Post-chat assessor stays Tier C. Shipped on `ivan/wave0-chat-tier-b-caps-50`.

**Walk 13 Sep (Block 2 closed):** founder sent one line to `Ipistsov+20260908` on Saturday Watch — reply arrived. See **T-E5** for the “double” lore miss (content, not the model path).

### T-E4. Chat caps were raised for this demo

New chats per hour **and** messages per thread are both **100** (were 2 / 25). Decide whether that stays.

**Locked 12 Sep:** **50 / 50** — 50 new chats/hour + 50 messages/thread. Shipped on `ivan/wave0-chat-tier-b-caps-50`.

### T-E5. Watch chat invents “double” as a secret pair (13 Sep walk)

**Saturday Watch, Block 2.** Anonymous chat with `Ipistsov+20260908`. Vote facts looked real (voted Yevgenia; she voted him; Luba voted her; Yevgenia left). Then: `turns out she was my double` → on follow-up, a **secret in-game pair / mirror / shared fate**. That is not the product.

**Product:** a Double is one real person’s rehearsal in the village. Other people on the map are other people’s Doubles. Survival has no “your double” pairing on day 1. Silent Pact (`You are secretly paired`) is a **day-3** challenge and was not this.

**Cause (code-read, no patch):** stranger Watch prompt never defines the word. It says `You are {name}` and `Never mention that you are a simulation`. Owner path says “Speak as their Double / rehearsal mirror”; this thread was **Anonymous**, so that line never ran. The model filled the gap with Big Brother lore. Vote memories are honest (`I voted against {name} on Day {n}`); the pairing sentence is extra.

Prompt ban shipped with Wave 2 BE. **Not scored** on `20260915-1` (no owner Chat thread). Still not T0–T7. Ties to **B1** / **B2**.

**Walk when you next Chat on Watch:** they must not invent a secret in-game pair. Owner may hear the product meaning of Double; anyone else stays a person in the town.

### T-E6. Hard 90s cut on the first planning try (Wave 2)

**Wave 2 — not T0–T7.** Shipped with the encounter work. **Not scored** on `20260915-1` (no engine log; clock started 06:30, not a 05:55 dawn freeze).

W1.5 already treats a **blank** daily-plan / decompose as a miss (same model 135s, then backup, then 5 min pause). A **slow but real** answer still wins: this morning’s decompose ran 3–4 minutes with real text, so Watch sat on step 0. The 90s mark never fired.

**Change:** cut only the **first** try at 90 seconds even if the model is still thinking. Then still allow the 135s try to finish. Then backup + pause as today. Fast enough that one stuck call cannot freeze the first minute; late plans can still land on the second try.

Do not hard-kill the whole plan at 90s with no 135s wait.

### T-E7. Sleep on the bed, not the room center (14 Sep)

Watch **T-W10**. Breakfasts completed run: Luba step **5** (06:00), Ipistsov steps **11–14** (06:06–06:09).

**Current:** Join plants the Double in the house **room center**, not on `:bed`. Sleep uses the whole `main room` box, so they never start on the bed. At wake the plan is the bed (5–6 tiles, inside cap 6) but the stored path stays **1 tile** at room center. Default is **stand still**, not a walk and not a teleport. Caption still says `in bed` / `(heading to House 1)` — if Watch parks them on the bed from the sentence, playback looks like a snap off the bed.

**Desired:** they sleep on the bed. Wake stand is one adjacent tile. Leaving the room is a real walk (`actual_path` more than one tile).

**Recommendation (locked unless founder picks otherwise):** **plant sleep on the bed.** Do not lead with “walk to the bed after wake” (extra slow minutes) and do not leave the room-center plant. Do not FE-lerp 1-point hops (**T-W10**).

**Do not implement until founder says go.**

### T-E8. Caption must match this step’s body dest (14 Sep)

Watch **T-W10**. Ipistsov steps **11–14**: planner act `Making the bed and tidying the sleep area`; dest still `the Ville:House 3:main room:bed`; body stayed `[36, 60]` (`actual_path` length 1, `stationary`). Emit honesty (`premature_inplace`) rewrote the sentence to `walking to <persona>Ivan App`. Four minutes of a false walk. Luba step 5: already in House 1, sentence says `(heading to House 1)` because the short name of the bed address is `House 1`.

**Current:** two writers on purpose — **body** = frontend path / occupancy tile (the score); **sentence** = backend emit (so “in bed” / “casting a vote” would not show while still elsewhere). Extra emit rewrites now lie.

**Desired:** keep those two writers. Cut the extra sentence writer. If path length is 1, do not say walking. A person name in the sentence only if that person is this step’s dest.

**Recommendation:**

| Option | What | Verdict |
|---|---|---|
| **A. Sync** | Sentence dest = this step’s body dest. Path length 1 → no “walking to …” | **Do** |
| **B. Drop the rewrite** | Show the planner act (`Making the bed…`) even if they are not on the bed yet | **Do** (with A) |
| **C. One writer for both** | Caption from tiles only | **No** — kills real “heading to X” walks; fights FE/BE split |
| **D. More honesty layers** | New special cases | **No** — this is how `Ivan App` happened |

Do not merge frontend and backend into one writer. Spatial vs intent stays split.

**Score 15 Sep (`20260915-1` Watch):** still the lie. 06:40 Luba “walking to Gosha” in Room 3 closet; 06:45 Gosha “finishing breakfast at Hobbs” while on the street; 07:18 Luba still “walking to Gosha” behind the bar. That line is **not** a seek. **Do not implement until founder says go.**

---

## Shipped / do not re-open as “new”

### D4. Saturday portal pain (14 Sep, `0076a45` on www)

**Shipped + on www:** **T-P3** (Look wait clears, error + retry), **T-P1** (40px knobs + honesty / any-language copy), **T-P2** (Take photo glow; Next errors until photo + sprite + consent), **T-P7** (sprite disclaimer gone, space kept), **T-P6 thin** (3 open homes, hide taken roles, no map, no LLM). PR [#5](https://github.com/ivan-exsy/double-landing-page/pull/5).

Still open on portal: **T-P4 / T-P8** (correct / retake), **T-P5** (skip-ahead while Meet runs), **T-P6 leftover** (role pictures / map), **S2**. **T-P9** is Watch.

### D1. LIVE speed (12 Sep)

LIVE defaults to **6×**. The LIVE pill opens 1× / 6× / 15×. REST fetch still skips the last 2 proven steps. Hard-refresh Watch once to pick it up.

### D2. Breakfasts has no CDN `live.json`

Watch used to treat it like a CDN sim (no Realtime, slow/cached status). Clock froze while generation ran.

**Shipped:** after 404, use the gateway, poll every 10s, no cache. Hard-refresh Watch once after that deploy.

Open-tab-then-Start spinner (**T-W4**) is a **separate** leftover — autoplay re-arm is **D3**; catch-up jump is **D5**.

### D3. Wave 1 FE (12 Sep, `d7a351e` on `vercel`)

**Shipped + verified on prod:** **T-W7** (unwatched talks show transcript lines — checked Lubaistomina ↔ Yevgeniapritchard excerpt on the completed run), **T-W2** (two-card first-run tour, once per browser), **T-W1** (13 Sep: BrowserStack iPhone 15 Safari cold load — map fit, drag, HUD sides).

**Shipped, field verify pending:** **T-W5/T-W6** (scrub stays LIVE, camera keeps the `?double=` pin — needs a running sim), **T-W8-UX** (staged wait copy on Talk page + Watch chat).

**T-W4** catch-up is **D5** (`4336105`). Hard-refresh Watch once to pick it up.

### D5. T-W4 open-tab catch-up (14 Sep, `4336105` on `vercel`)

**Shipped:** idle Watch tab seeks the LIVE cushion after Start (polled `total_steps`, not Redux 0). Gateway WS connects on stopped→running. Skip-on-sleep restores the user speed (do not leave 15×).

**Field verify 15 Sep (`20260915-1` completed @300):** **T-W7** hellos that exist show on the person card. HUD date **15 Sep**. Completed run stays replay (does not enter LIVE). **T-W4 / T-W5 / T-W6** still pending — need a **running** Start, not this slice.

Hard-refresh Watch once to pick it up.

---

## Behavior science (ground rules before we over-build chat)

These are research questions. Eng can prototype, but the **rule** should come from this lane.

### B1. Double’s role depends on *who* it is talking to

**A. With the owner**

- Treat every owner chat as a chance to learn more: ask, read answers, update the Double (personality, values, beliefs).
- Keep a clear line between the owner’s **real** life and the Double’s **sim** life. The Double should help the owner see that line.
- Owners want to **influence** how their Double behaves.
- Keep a **what-if** mode: owner gives guidance / settings / strategy; Double plays that role to see how it lands — without silently rewriting the “real” Double forever.
- The Double may steer the conversation, but the owner’s desire is top priority.

**B. With others (balance to find)**

- Do not reveal personal / private / sensitive information.
- Other people should still **recognize** the owner in how the Double talks.
- Some owners will want to **choose** what can be revealed about them.

**Behavior recommendations (12 Sep):**

**RQ-B1a — Audience-conditional disclosure.** Ship **three interlocutor classes** in prompt + retrieval filter — **owner**, **known peer** (same sim / named acquaintance), **stranger** — not a free-form “be careful” line. **Owner:** full ISS (`innate` / `learned` / `currently` / `lifestyle` / `goals`) + sim action context; may ask to learn; still bans clinical / third-party secrets (Week 3). **Known peer:** trait-consistent *style* + **sim-public** facts only (role, home, recent village acts); no owner free-text friction/aim details, no contact/employer/GPS, no owner-chat “secrets” unless the owner toggled that field **shareable**. **Stranger:** thinner still — manner + high-level aims, refuse personal biography. Default all life-chapter fields to **private**; owner opt-in per field (or coarse Public / Friends / Private). Label as product privacy policy enforced in prompt+retrieval — not a claim of real social cognition. Eng: branch system prompt + memory allowlist by `interlocutor_class`; hold personality rewrite for RQ-B1b / S3.

**RQ-B1b — Stable soul vs session what-if.** Keep **three layers**, not one influence bucket. (1) **Durable soul** — instrument means / `innate` + confirmed ISS life-chapter fields; only quiz retake or explicit confirmed edit may change temperament (Week 3 / portal A6 lock). (2) **Working memory** — gateway `chat` nodes stay as episodic “owner said X today,” feeding schedule reactions, **not** rewriting `innate`. (3) **Session what-if** — separate time-boxed overlay (`guidance[]` / strategy flags on thread or scratch) read as “for this conversation / scene, try Y,” cleared on thread end or owner Reset; never promoted to durable soul without the S3 confirm UI. Do **not** ship v5 “parse directives → permanently change personality” until that confirm path exists.

**RQ-B1c — Owner-chat learning / write-back bans.** Treat owner chat as **structured intake**, not free personality surgery. **Allowed to ask:** concrete behavior, values, aims, sim strategy, corrections of life-chapter facts. **Hard refuse / never store as soul:** clinical/medical/illegal/sexual history, third-party secrets, “diagnose me,” politics-as-identity tests (Week 3 §A6). **Write-back tiers:** (A) episodic `chat` memory only — already OK; (B) proposed ISS patches (`learned` / `currently` / `goals` / `lifestyle`) → **S3 confirm UI**, never silent; (C) `innate` / Big Five means — **never** from chat (retake only). Max one curious question per turn when gaps are large; owner desire still tops agenda.

### B2. Watch yourself vs secrets vs control

People mostly want to watch **themselves**. They also want to learn “secrets” about others — and get upset if someone learns something they consider private.

How you see yourself is not how others see you.

Find the line between:

- Double is **recognizable** (owner + people who know the owner), and
- owner still **feels in control** of actions and behavior.

If the owner sets something very unlike them, the Double can check: e.g. “Are you sure? This does not sound like you.” Consider **temporary** settings for one situation vs permanently wiring it.

**Behavior recommendations (12 Sep):**

**RQ-B2a — Minimum recognizability signal set.** Recognizability = **style + a few concrete anchors**, not a full person-model. Minimum: (1) Big Five **bands** (or portal coarse prior) as manner constraints; (2) 3–6 **concrete nouns/verbs** from ISS (`learned` / `goals` / `currently`) the owner would endorse; (3) **recent sim acts** (what they just did in-village). Explicitly **exclude** from “sounds like them”: percentiles, diagnosis, private owner-chat secrets, any claim of accurate prediction. Validation: owner + one acquaintance rate 5 short Double replies blind — bar is “more like them than a generic NPC,” not “indistinguishable.” Public wording stays founder `pending_approval`.

**RQ-B2b — Unlike-you challenge vs temporary vs refuse.** If owner guidance **conflicts with durable soul** (e.g. high-A owner orders cruel sabotage), run a **one-beat check**: “That doesn’t match how you’ve described yourself — use for this scene only, or change your snapshot?” **Temporary** → session what-if overlay (RQ-B1b), expires with scene/thread. **Permanent** → only via S1 retake / confirmed ISS edit, never from a chat directive. **Refuse** only rare hard harms already banned (illegal / clinical targeting of real people). Measure felt-control with a post-chat micro-ask (“Did your Double stay yours?”) — research metric, not KPI.

---

## Shared (research stance, then a ticket)

### S1. How should owners correct the soul?

Meet (**T-P4**): edit via **quiz again**, or edit **raw profile records**?

Need a behavior/product call (which source stays source of truth; what a retake does to an already-joined Double) before eng picks a path.

**Locked 12 Sep:** split — temperament via quiz retake only; life-chapter text direct edit. Post-Join retake updates the snapshot on next load, keeps home/role/memories; village 25 still wins if both exist.

**Behavior recommendation (12 Sep) — split by field class:**

**RQ-S1a — Quiz retake vs raw profile edit.** **Temperament (`innate` / Big Five means):** only via **re-answering the instrument** (portal mini10 or village BFM-25) — raw JSON edit of means invites self-idealization and breaks psychometric meaning. **Life-chapter ISS** (`learned` / `lifestyle` / `goals` / `currently`): allow **direct text edit** on Meet/Account with previous answers preserved (**T-P4**), because those were never a scored test. Meet “verify” shows both layers labeled: “Disposition snapshot (from quiz)” vs “Your words (editable).”

**RQ-S1b — Post-Join retake effects + copy.** After Join, a portal retake **supersedes portal means + regenerates portal `innate` only**; if village IPIP-BFM-25 exists it **still wins** for temperament. Keep historical rows (`instrument`, `completed_at`); do not average. Chat/ISS edits do not reset Join. Already-joined Double: next load picks new `innate` template; no silent wipe of homes/roles. User copy: “Updating the short quiz refreshes your coarse disposition prior. It doesn’t erase your chat notes. If you took the longer village questionnaire, that fuller snapshot still leads.”

### S2. Suggest homes/roles that fit the person

Wanted; **avoid an extra LLM call** for now. Postpone. When we do it, behavior should say what “fits” means; eng should say how without a new model hop.

**Behavior recommendation RQ-S2 (12 Sep) — no new LLM:** rank the **already-feasible** open homes/roles with a transparent score from Big Five bands + one ISS keyword list — e.g. higher E → denser/social pads; higher C → quieter/private-room preference; Openness → novel/edge locations; role tags matched to `goals` / `currently` tokens. Show top 3 (**T-P6**); label “Suggested from your snapshot — not a test result.” Prefer deterministic reuse of `onboarding_home_matcher`-style rules over a new portal LLM hop.

### S3. After owner chat: review and update the Double

Enable a post-chat review (after talking with the owner) that can enhance personality / facts.

Behavior: what is allowed to change, what needs confirmation (**B1 / B2**).  
Tech: the review UI and the write-back (**T-W8** is wait time only).

**Behavior recommendations (12 Sep):**

**RQ-S3a — Post-chat claim tiers.** After an owner thread, extractor sorts into three buckets — **Auto-episodic** (keep as chat memory only: what was said); **Propose-ISS** (concrete facts/aims/lifestyle lines → confirm UI); **Never** (`innate`/means, clinical labels, third-party private data, illegal content). Default until UI exists: Auto-episodic only (matches RQ-B1c tier A).

**RQ-S3b — Review UI contract / innate lock.** Ship a **diff card**: “Proposed updates to your Double” with Accept / Edit / Reject per bullet; empty state if nothing Propose-ISS. Hard lock: no control may alter Big Five / `innate` from chat (point to Retake quiz). Copy: “Chat teaches your Double stories and plans. Disposition scores only change if you retake the quiz.” Matches Week 3.3 chat≠temperament.

### S4. Village talk that *looks* like a scene

Engine can make them sit and speak (**T-E1 / T-E2**). Watch must **show** the lines (**T-W7**). Behavior should say when a planted meet is “a conversation” vs a nod in the park — so we do not ship either hello-spam or eerie silence as the product.

**Locked 12 Sep:** hello = ≤2 exchanges, no topic carry. Conversation = ≥3 exchanges + still co-located. Watch must show transcript lines or users will rate either spam or silence.

**Behavior recommendation RQ-S4 (12 Sep) — tier, not vibes.** **Nod/hello:** greeting tier, ≤2 exchanges, no topic carry. **Conversation scene:** full tier — mutual proximity held, ≥3 exchanges or duration/RIR gate already used for `full`, both still co-located. Watch must show transcript lines (**T-W7**) or users will rate either spam or eerie silence. Do not invent a third “almost talk” state for MVP.
