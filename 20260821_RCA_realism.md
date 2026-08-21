# RCA brief — Survival realism (sim `20260724-2`)

**Date:** 2026-08-21  
**Audience:** Backend / simulation-engine (SurvivalController + cognition).  
**Status:** Evidence brief for RCA. Not a patch ticket. Not SOT.  
**Sim:** `20260724-2` (Soul-15 Survival, still running; season `current_day` = 4 as of extract).  
**Why now:** Daily trailers must peek into **featured Doubles’ day-in-life**. Paid reports will follow a **chosen** Double. Both products are only as honest as the engine. Video can fact-lock around some of this; it cannot invent a village that did not play.

**Do not** bake trailers, rewrite VO, or “fix” this in `edit_script.json`.

---

## 0. What we need from you

Four defects. They showed up on a live extract of this sim (season state + per-persona day logs). Please RCA **root causes**, not trailer copy.

| # | Defect | Trailer impact | Suggested severity |
|---|--------|----------------|--------------------|
| 2 | Challenge **ghosting** — majority marked `absent`; Cost often never played | Peak/Cost story is a lie if Cost sat the mechanic out | **P0** |
| 3 | Chat **fact-rot** — Doubles invent cards, locks, tallies, who left | Cannot quote village talk in VO without a contradiction pass | **P0** |
| 4 | **Same voice** — souls collapse into one analyst | Featured Doubles do not feel like distinct people | **P1** |
| 5 | **Empty social SOT** — no confirmed alliances, no daily narrative | Ledger cannot name a relationship; long daily has nothing durable to hang weather on | **P1** |

**Out of scope for this RCA:** picture kit, Remotion, VO wording, G7 census, Phaser capture. Those are video. **In scope:** who is at Hobbs when the gate fires, what the challenge LLM is allowed to decide, what conversation/vote prompts see, what gets persisted on `survival_season_state`.

---

## 1. How to reproduce the evidence (no new sim required)

Season state (authoritative board):

```text
# From eng clone, with .env.local SUPABASE_URL + SUPABASE_SERVICE_ROLE_KEY
python -c "..."  # RPC load_survival_season_state p_sim_name='20260724-2'
```

COS dump (already pulled):  
`D:\Coding\COS\tasks\2026-08-20-003\supabase_extract\season_state.json`  
`D:\Coding\COS\tasks\2026-08-20-003\supabase_extract\challenge_decisions.md`

Day-in-life chats (movement.chat on positions):

```text
cd D:\Coding\generative_agents-ivan-dev
python -m video.extract_day_log 20260724-2 "Irene Dove" --season-day 1 -o irene_sday1.json
python -m video.extract_day_log 20260724-2 "Alex Butcher" --season-day 1 -o butcher_sday1.json
# etc. Survival day N = --season-day N = engine day N+1
```

Also pull this sim’s `survival_phase_trigger.ndjson` (step, `reason=spatial_gate|deadline`, `absent=[]`). That file is the smoking gun for #2.

SOT for the gate: `double-docs/sot/sot_survival.md` §Runtime Integration (spatial 80%, challenge deadline 11:00, gather lock 10:00–11:00, vote time-box).

---

## 2. Challenge ghosting (P0)

### Symptom

`challenge_results[].decisions[].choice_reason_plain == "absent"` for most of the cast, most days. Default action is still written (`fold` / `protect` / empty `lock_with`) so the row looks like a play. It is not.

| Season day | Challenge | Present (real reason) | Absent | Winners |
|------------|-----------|------------------------|--------|---------|
| 1 | `hold_for_shield` | **7 / 15** | **8** | Alexis Reed |
| 2 | `silent_pact` | **6 / 14** | **8** | Irene, Nick, Olivia (loyalty lottery) |
| 3 | `alliance_lock_in` | **8 / 13** | **5** | Irene + Olivia (mutual) |
| 4 | `silent_pact` | **6 / 12** | **6** | Owen, Max, Olivia (Max sole-expose Shield) |

**Cost of the night was absent from the challenge on the nights that matter for trailers:**

- Day 1 Cost **Vincent Slater** — `absent` (job is curriculum / classroom).
- Day 2 Cost **Alex Butcher** — `absent` (job is Harvey Oak Supply).

Day 1 Peak Alexis **did** play (hold, high card). Day 2/3 Peak Irene **did** play. So the featured *winner* is often real; the featured *leaver* often never sat the test the VO treats as the day’s pressure.

Public board Day 1 holders (only three names): Irene, Alexis, Max. That matches “7 present, most folded or were defaulted,” not a 15-person card fight.

### What the engine actually does

Code: `reverie/backend_server/survival/controller.py`

1. Challenge resolves when **spatial quorum** (≥ `spatial_gate_threshold` default **0.8** of alive at `gathering_location` default **Hobbs Cafe**) **or** **deadline** (default **11:00**).
2. On either fire, `_get_absent_agents` = alive players whose `scratch.curr_tile` is **not** in the Hobbs `address_tiles` set.
3. `_collect_challenge_decisions` / paired collector: **no LLM** for absentees. They get `challenge.default_decision` (`reasoning: "absent"`).
4. `_sanitize_challenge_decisions` copies that into `choice_reason_plain`.
5. `tag_event(..., kind="challenge_participated")` writes `"outcome: absent"` — so the engine *knows*. Trailers and chats still talk as if everyone played.

For 15 alive, 80% quorum is **12** people at Hobbs (`int(15 * 0.8 + 0.5)`). Day 1 only **7** present → this almost certainly **deadline-fired with a minority**, not a full gather. Same pattern Days 2–4.

Gather lock (SOT, shipped 2026-07-14/15) is supposed to force `act_address` to Hobbs in **10:00–11:00**. It is not delivering a majority on this sim.

### RCA questions (please answer with logs, not guesses)

1. For Day 1 challenge trigger: `reason=spatial_gate` or `deadline`? Exact `sim_time`, `step`, `absent` list from NDJSON.
2. For each absentee: `curr_tile` + maze address at that step. **Were they at Hobbs but missing from `cafe_tiles`?** (tile-set mismatch) **Or still at job / in transit / asleep?** (lock failed)
3. Did `_maybe_apply_gather_lock` run for absentees in `[10:00, 11:00)`? Any skip (sleep, conversation, seek pause)?
4. After default `absent`, does `resolve_challenge` treat default `fold`/`protect` as a **real** action in scoring? (Silent Pact absentees still show `action=protect` — can they win a lottery they did not play?)
5. Should Cost/Peak picker be allowed to feature a Double whose `choice_reason_plain` is `absent`? (Video can refuse; engine should not make that the normal case.)

### Suggested acceptance tests (after fix)

- On a 15-person Survival day, **≥12** remaining players have a non-`absent` `choice_reason_plain` after challenge resolve (or the run **fails closed** and does not resolve a minority board).
- If a named player is later Peak or Cost, they **must** have a real decision row.
- Default `absent` rows must not be scorable as Protect/Hold wins.
- NDJSON `absent` length on deadline fire is a **logged incident**, not a quiet default.

### Non-fix

Do not “fill in” LLM decisions after the fact for people who were not there. Either **get them there**, or **delay resolve**, or **fail the day**. Inventing a card they never held is how defect #3 starts.

---

## 3. Chat fact-rot (P0)

### Symptom

Verbatim movement chats **contradict** `challenge_results.public_board` and `eliminated[]`.

| When | Speaker | Chat claim | Season-state fact |
|------|---------|------------|-------------------|
| D1 ~11:24 | Alex Butcher | “Cards are in. I held a 5.” | Butcher `choice_reason_plain: absent` — no card dealt (`private_info` only for non-absentees) |
| D1 ~20:51 | Irene | Vote landed “11-4” | Vincent boot **3.0**; scattered tally, not 11–4 |
| D3 ~11:18 | Irene to Mike | “Diana and I are shielded, you and Nick are shielded.” | Mutual lock is **Irene–Olivia**. Shepard / others are one-ways. Catalog: Lock-In is **WEIGHT_UP**, not a Shield vest |
| D3 evening | Dean / others | Vincent’s name on the board | Cost that night is **Alex Shepard** (Vincent already gone D1) |

Village texture around those lines is good (croissants, espresso, napkin cranes). The **game facts inside the same chats are false**. Trailer VO cannot quote them.

Reflections also bleed: Day 2–3 RIR pulls Day-1 memories; some rows are the literal string `this is blank`. Conversation prompt still says “Do NOT … reference the simulation” — reflections on this sim include “simulation’s non-reactors.”

### What the engine actually does

1. **Challenge broadcast** (`broadcast_event_to_personas`, kind `challenge_outcome`) is one sentence: *"{winners} won the {name} challenge on Day {day}."* It does **not** inject `public_board` (pairs, one-ways, sole exposers, card ranks).
2. Absentees get `challenge_participated` / `absent` — retrieval often loses to louder cafe talk.
3. `ConversationContext` (`conversation_manager.py`) has location, schedule, relationship, pressure. **No** `public_board`, **no** own `challenge_results` row, **no** live tally, **no** “you were absent.”
4. Survival chat prompt (`v2/survival_generate_conversation_batch_v1.txt`) asks for natural talk from **memory**. Memory is incomplete and sometimes invented in a prior utterance, then retrieved as fact.
5. Post-vote, SOT injects `vote_concluded` with the eliminated name. Chats **before** numbers land, and chats that retrieve the **wrong night**, still invent tallies (11-4) and recycle yesterday’s Cost (Vincent on Shepard’s night).

Win-path copy on Day 3 says “Mutual locks earned **reputation shields**” while catalog / Day 3 VO lock is **no Shield vest**. That narrative string is a second contamination source.

### RCA questions

1. At utterance time, did the speaker’s retrieved memories include `challenge_participated` / `absent` and `challenge_outcome`? Dump the actual retrieve set for Butcher D1 ~11:24 and Irene D3 ~11:18.
2. Why doesn’t `ConversationContext` (or the survival overlay) pass a **fact card**: own decision, public_board, last `eliminated[-1]`, remaining N?
3. Is there a write-path where a chat utterance becomes a memory **without** checking season state (so “I held a 5” persists)?
4. Day-index mix: engine day vs season day in `vote_concluded` / overlay. Are D3 evening chats retrieving D1 boot as “tonight”?
5. `get_last_resolve_narrative()` / `win_path_one_liner`: who consumes “reputation shields,” and can agents read it as a Shield vest?

### Suggested acceptance tests

- After challenge resolve, a speaker whose row is `absent` **must not** claim a private card / Protect / lock target in generated chat (fail the turn or rewrite from overlay).
- After resolve, chat may name **only** pairs/winners that appear in `public_board` / `winners`.
- After elimination, chats that name “who left tonight” must match `eliminated[-1].name` for that season day.
- No invented integer tallies unless they match `vote_tally` / `vote_count`.
- Overlay + `win_path_one_liner` must not say Shield when the catalog reward is WEIGHT_UP / stronger vote.

### Non-fix

Do not silence all game talk. The village *should* gossip. Gossip must be **wrong-about-read** (who to trust), not **wrong-about-the-board**.

---

## 4. Same voice (P1)

### Symptom

Souls on disk (`souls/*.json`) are distinct. Survival speech is not.

After one or two job-flavored turns (library loans, lesson plan, croissant lamination), almost everyone becomes the same amateur detective: pastry-case orbits, hesitation intervals, napkin tells, “unknown variable,” “second-order,” “incentives.”

Vote `reasoning` (persisted on `eliminated[].vote_reasons`) is the same essay with names swapped. Irene’s Day 1 and Day 2 votes against Butcher are near-copies (“early coordination and clear commitments” / “unpredictable variable”). Confidence clusters at **0.65**.

Vincent’s final statement is systems/data-point. Butcher’s is prototype/ship. Those are better. Day-to-day talk and votes are not.

Chat prompt already bans a *specific* war-room slang list (`pillar`, `refill`, `hardware pair`, …). The model switched to a **new shared register** the ban list does not cover.

### What the engine actually does

1. Survival chat prompt **leads** with “multi-day survival game / elimination format,” then says “do not force every exchange into strategy.” The lead wins.
2. Vote prompt (`v2/survival_vote_decision_v1.txt`) asks: biggest threat, betrayal, who allies want gone — **before** “cite a personal value.” Early days have thin betrayal data → “unknown = threat” is the cheap completion.
3. Identity overlay (SOT) injects deadlines, gathering, challenge brief, **not** job-hour texture. Soft daily plan still allows talking about the challenge. Together they starve “live as this person.”
4. This cohort (L-Talks / Soul-15) was written with overlapping analyst heuristics. Overlay + vote template **amplifies the overlap**.
5. Challenge `choice_reason_plain` when present *is* more personal (Alexis 7 / evidence; Olivia fold / not a gambler). The people who **play** sound like themselves. The people who **only talk** sound like the template.

### RCA questions

1. Ablate: same souls, **baseline** (non-survival) chat vs survival chat on the same morning — how much of the detective register is survival-prompt-only?
2. Does vote retrieval pass ISS / soul “do-not-do,” or only trust/grudge tables?
3. Can leftover-hour planning actually keep a Double at their job through 10:00, then gather — without the whole afternoon becoming vote-scan dialogue?
4. Are we over-calling the chat LLM (8-turn strategy scenes) when max_exchanges should stay 1–2 for job-floor talk?

### Suggested acceptance tests

- Blind read: 8 unlabeled vote `reasoning` strings from one night. A reviewer can match **≥6/8** to the correct soul in two tries (or we fail).
- Per featured Double, ≥1 chat turn in the day log that is **only** job/place/habit (no vote math).
- Ban-list is not enough: add a **shared-register classifier** (or a small eval set) for “unknown variable / second-order / scan the room” density.
- Peak/Cost `choice_reason_plain` stays required and soul-cited (already the direction of `sot_challenges.md` personality attraction).

---

## 5. Empty social SOT (P1)

### Symptom

On `load_survival_season_state` for this sim:

- `alliance_log`: **null** (not even `[]`)
- `daily_narratives`: **[]** (field exists; nothing is ever appended in controller code)
- Trailer `fact_ledger.json` `alliances.confirmed`: **[]** all three packaged nights
- Picker `satellite_ids` / `coverage_queue`: **[]**

Meanwhile **per-agent** `SurvivalState.alliance_commitments` can exist, chats talk like blocs exist, and Day 3 Lock-In `public_board` has a real mutual (Irene–Olivia) plus one-ways. The **season document** trailer/ledger reads is empty.

`alliance_log` is only appended in `_update_trust_from_votes` when someone **votes against an active ally** (a *break* record). Formation writes `alliance_commitments` + `alliance_formed` memories via `record_alliance_from_chat` — **not** `season.alliance_log`.

`daily_narratives` is initialized in `state.py` and persisted. **No writer** in `controller.py`. Dead column.

Chat-alliance formation is strict: summarize prompt requires explicit mutual “we’re a team / I’ll vote with you.” Cafe talk on this sim is almost all hint-and-scan, so `alliance_committed=false`. Result: no confirmed alliances for VO, even when Lock-In is a public mutual.

### RCA questions

1. Confirm `alliance_log` null vs `[]` on persist — schema default?
2. Should `record_alliance_from_chat` also append a **formed** row to `season.alliance_log` (members, formed_day, source=`chat`)?
3. Should Lock-In `public_board.mutual` promote into `alliances.confirmed` for that night (mechanic alliance ≠ chat alliance — label it)?
4. Is `daily_narratives` still desired? If yes, who writes the one-line day summary, and when (NIGHT)? If no, delete the column from the contract so video stops looking for it.
5. Trust 0.50 everywhere in Lock-In reasons — is the trust table uninitialized / capped, so “highest trust” is a many-way tie on Irene?

### Suggested acceptance tests

- After a verbal mutual (“I’ll vote with you” + yes), `alliance_log` has a **formed** row the same day; ledger `alliances.confirmed` non-empty.
- After Alliance Lock-In resolve, ledger can name the **mutual pair** from `public_board` even if chat-alliance never fired.
- `daily_narratives` either has one row per completed season day **or** is removed from SOT / RPC payload.

---

## 6. Suggested RCA order

1. **#2 logs first** — `survival_phase_trigger.ndjson` + tiles at trigger. If gather lock is broken, #3 gets easier (people talk at cafe after a resolve they missed).
2. **#3 fact card** — inject season-state slice into survival overlay / `ConversationContext`. Cheap compared to gathering 12 bodies; does not replace #2.
3. **#5 persist formed alliances + Lock-In mutual** — unblocks long-daily weather without waiting for souls to say the magic words.
4. **#4 prompt + eval** — after people actually play and the board is in context, re-measure voice. Fixing overlay before gathering will just make absentees narrate the board more fluently.

---

## 7. What video will do while you RCA

- Quote **ledger + `public_board` + `choice_reason_plain`**, never raw chat, unless the line survives a contradiction pass.
- Do not say Cost “lost the challenge” if they were `absent`.
- Do not wait on this RCA to ship **group** dailies (featured Peak/Cost peek). See `20260820_longer_daily.md` production section.
- Paid **chosen-Double** day-in-life reports should wait until #2–#3 are green for that persona. Otherwise we mail a fan a hallucinated day.

---

## 8. Pointers (eng)

| Item | Path |
|------|------|
| Gates, absent, collect, sanitize, broadcast | `generative_agents` `reverie/backend_server/survival/controller.py` (`_check_gate`, `_get_absent_agents`, `_collect_challenge_decisions`, `_sanitize_challenge_decisions`, `_resolve_challenge`) |
| Default `reasoning: absent` | `reverie/backend_server/survival/challenges.py` |
| Alliance form (chat) vs log (break only) | `record_alliance_from_chat` vs `_update_trust_from_votes` |
| `alliance_log` / `daily_narratives` fields | `reverie/backend_server/survival/state.py` |
| Chat context (no board) | `persona/cognitive_modules/conversation_manager.py` `ConversationContext` |
| Survival chat / vote / summarize | `persona/prompt_template/v2/survival_generate_conversation_batch_v1.txt`, `survival_vote_decision_v1.txt`, `survival_summarize_conversation_v1.txt` |
| Runtime SOT | `double-docs/sot/sot_survival.md` |
| Challenge catalog (Lock-In ≠ Shield vest) | `double-docs/sot/sot_challenges.md` |
| Evidence dump | `COS/tasks/2026-08-20-003/supabase_extract/` |

---

*End of RCA brief. Prefer a written root-cause per defect (#2 H1 tile-mismatch vs H2 lock-failed vs H3 deadline-by-design) before a patch.*
