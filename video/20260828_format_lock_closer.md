# Format lock [A] — daily closer

**Date:** 2026-08-28  
**Status:** Brief for council. Not a locked format until you return a rec. Do not treat this file as shipped SOT.  
**For:** Screenwriter, Reality TV, Engagement, Video Producer.  
**Reply to:** COS inquiry 2026-08-28 (format lock [A], not episode recut [B]).  
**Language:** plain.

**Lock the daily closer format. Episode 1 is an example night, not the episode we are locking.**

---

## 1. What this brief is

Lock a **repeating nightly closer**: same shape every Survival night, filled from that night’s picker + ledger + picture kit. A new night must run **without a new strategy memo**.

Episode 1 (Ivan Pitts / Alex Butcher, sim `20260823-2`) is the **specimen** of version 1 — what the current framework looks like when filled. It is not the cut to rewrite. Do not return a new Ivan/Alex voiceover.

**Pass:** a stranger can run any Survival night through this framework and get a closer with drama, character, an unexpected turn, and an inner dilemma **when the board has one** — without a new brief.

**Fail:** the output only works for Ivan / Alex. Fail: 60–90s treated as a hard cap. Fail: encyclopedia. Fail: invented inner life.

---

## 2. Already locked vs open vs not this pass

| Item | In / out | One line |
|------|----------|----------|
| Locked daily tape | **In — locked** | **Closer tonight** (`--sku closer`). Short Scar is a sibling SKU. Share clip is not the daily. |
| Picker (Peak, Cost, open question, Door) | **In — locked** | Who is featured any night. Schema: `video/daily/SOT-new-daily.md` §8.3. |
| `fact_ledger` + `safe_vo` / `do_not_say` | **In — locked** | What voiceover may say. Writer may not invent past these fields. |
| Picture kit G1–G8 | **In — locked as roles** | Repeating jobs (habitat, table, win, ballots, leave, census, namecards). Do not redesign 2D↔cinematic this pass. |
| SOT-new-daily.md | **In — live engineering contract** | Pipeline, bins, kit, fact-lock, later-night literacy as **code runs today**. Do not invent a second outline that fights §9. You may **extend** §9 with skip-if-empty story beats. |
| Six-beat story overlay (doing / weather / inner / named Door) | **Open — this pass** | Confirm, replace, or extend. This is the hole version 1 does not fill every night. |
| Runtime | **Open — this pass** | Length follows story. No 60–90s cap. No pad. No village recap. SOT’s 90–140 / hard 180 is the **version 1 historical band**, not this lock. |
| Door thread when `unfinished_thread` is null | **Open — this pass** | Named unfinished thread on a featured person. Pick order below; machine does not yet enforce the name. |
| 2D mapping / blend notes | **Out** | `daily-2D-3D-blend.md` and `20260827_viral_video.md` §§1–13. Keep for later. |
| Share clip (Spark) | **Out** | SOT D2 exists on paper. Render **not built**. Not the daily. |
| Timestamp end card / tap-to-2D | **Out** | **Not built.** |
| Paid personal / D3 Edge | **Out** | Not the group daily. |
| Encyclopedia / `[B] day_normal` | **Out** | Kill. |
| New Ivan/Alex VO | **Do not send** | Specimen only. |

---

## 3. Reproducible framework

For each row: **locked** (every night, machine or contract already does it) · **skip-if-empty** (omit the clause; do not invent) · **open this pass** (council must lock the rule) · **not this pass**.

### 3.1 Shape

| Rule | Status |
|------|--------|
| Locked daily = **closer**. Same Peak + Cost + Door as short Scar would use. Not a third show. | **Locked** |
| Short Scar (`--sku scar`) | **Not this pass** — keep as sibling; do not make it the pin. |
| Share clip | **Not this pass** |
| One night, one scar. Not breakfast-to-bed. Not 15 people. | **Locked** |
| Spoken cast: **Peak + Cost + at most one causal satellite**. Hollow third name = picture-only or omit. | **Locked** |
| Runtime: length follows story. No pad. No extra rules-teach to fill a clock. No freeze-frames as duration. **No hard cap this pass.** Encyclopedia still fails at 3 minutes. | **Open this pass** (founder already set this; council may name a *soft* band if useful, not a fail-under-90) |
| Tuesday auto-cut fills the framework from picker + ledger + kit. Gold CapCut is **once per new type** (new challenge look, new HUD), not each night. | **Locked** |

### 3.2 Beat order every night

Mute hook first. Then spoken closer. **Required** beats must appear. **Skip-if-empty** beats drop when the board has nothing — the night still ships.

| # | Beat | Required? | Episode 1 (literacy) | Later nights | Picture role (kit, not filenames) |
|---|------|-----------|----------------------|--------------|-----------------------------------|
| 0 | Mute hook | Required | Face/move, no VO | Same | Peak or Cost face (G4/G5 still ok) |
| 1 | Stake | Required | Doubles clause + Survival primer (fifteen entered… one leaves until one remains) | Doubles clause + `{N} still in Survival mode. Someone is voted out every night.` (N = `15 −` prior boots, same math as G7). **No** “fifteen entered until one remains.” | Phaser plant already in recipe — **do not redesign** |
| 2 | Follow | Day 1 required; later skip | “Today we are following two of them.” | Skip that line. Peak then Cost directly. | G8 namecards |
| 3 | Body in a place | Required per featured | Job + place, Peak then Cost | Same every night (returnee included). Never `{Name} is back.` | G8 then G1 (Peak habitat) / G2 (Cost habitat) — clip under the line, not still→clip freeze |
| 4 | Why-tonight (personality) | Skip-if-empty after fallbacks | ≤1 clause each: personality that showed up **today**, not the card rank / Shield. | Same. Motive: `choice_reason_plain` if it is a human who-clause; else `roles.trait`; Cost leftover heat last. Skip only if none of those exist. | Same habitat window; want HUD stamps that line |
| 5 | **One doing** | **Skip-if-empty** | Work or ritual that is *this* person (hands at the job). Not “I held a 5.” | Same. **Machine does not yet emit this clause.** Council: what ledger/board field counts as a doing, or skip. | Habitat clip / G1–G2. No new rooms this pass. |
| 6 | **Relationship weather** | **Skip-if-empty** | Leftover heat, a lock, unreadability. Board / `alliances.confirmed` / `public_board` only. | Same. Episode 1 often empty — **skip**, do not invent a grudge. | Optional hold on habitat. No extra Phaser redesign. |
| 7 | Pressure / challenge | Required | Name + kid-plain fork + tonight consequence. Teach pack, not invented rules. | `Tonight's game is {name}.` + `steps_board` order. Shorter if type already taught. | G3 challenge bodies |
| 8 | Tonight’s turn (Peak) | Required | Winner / power, tonight-only. | Same | G4 Peak hold |
| 9 | Mid (alliances → votes) | Day 1 only; later skip | Teach: conversations → alliances → votes; then “every Double casts a ballot.” | **Skip** leftover lecture. Last-night heat belongs in Cost why-tonight (beat 4/6), not a recap. | G6 ballots under the vote line |
| 10 | Cost / leave | Required | Tally in `safe_vo` form; Peak’s ballot if true; “{Cost} is gone.” Dignity. | Same | G6 then G5 leave. Phaser leave still already in recipe — **do not redesign** |
| 11 | Inner life — vote why | **Skip-if-empty** | Peak’s stated why they named Cost (`vote_reasons`). Spoken English. No mind-read. | Same | G5 / G6 |
| 12 | Inner life — last words | **Skip-if-empty** | Cost `final_statement` cut for speech. Skip engine-clone essays. Sit on the leave walk. | Same | G5 loop |
| 13 | Census | Required | Fifteen become fourteen | `{N} become {N−1}` | G7 identity-card grid |
| 14 | Cliff — named thread | Required | Unfinished thread on a **featured** Double, not “someone else leaves.” | Same. Pick order in §3.3. | World bed / habitat of the named person |
| 15 | Door | Required | Catalog line until a deep link exists. | Same | End lockup + existing Door flyover — **do not redesign** |

Beats **5, 6, 11, 12** are the story overlay version 1 mostly skips. That is what this pass must make **repeatable**, including skip rules.

Sacred spine (every night, even when story beats skip): **want → pressure → turn → cost → honest open question → one Door.**

### 3.3 Door / unfinished thread

Spoken **Door** (CTA) and **cliff** (the itch) are different.

**Door (CTA) — locked**

- `artifact_id` null → catalog: *Watch every conversation, challenge, and vote live at doubland.ai.*
- Do not fake a deep link. Do not dual-CTA (watch + create).

**Cliff (named thread) — open this pass; pick order to lock**

When `unfinished_thread` is null, do **not** default to “another Double will leave” on later nights. Pick the first that **names Peak or Cost**:

1. `picker.unfinished_thread` if it names a featured person.  
2. Else `picker.open_question` if it names a featured person.  
3. Else board-true leftover on **Cost** (unreadability, last night’s mix) or power spent on **Peak** (Shield gone tomorrow *and* what that does to a named featured person).  
4. Else skip the generic season poster. Writer still owes a Cost-named itch from elim (example shape, not copy: *Who does the room trust now that {Cost} is gone?*).  
5. **Not built:** a validator that fails a cliff which names nobody featured.

Episode 1 specimen used a season poster (“New alliances… another Double will leave”). That is **version 1 filling badly**. Version 2 format should not copy that as the later-night default.

### 3.4 Fact-lock — fields the writer may use

**Authority order (locked)**

1. `fact_ledger.json`  
2. Challenge `public_board` / winners / `choice_reason_plain`  
3. `today.eliminated` (`vote_count`, tally, `final_statement`, `vote_reasons`)  
4. Peak/Cost chats from `extract_day_log` — **only after a contradiction pass vs 1–3**. **Not this pass** as a nightly auto source. Until that pass is a gate, keep **board-true + texture** (place, hands, walk-out).

**Writer may use (locked)**

| Field | Use |
|-------|-----|
| `today_facts` / `yesterday_facts` / `writer_rules` | Prose safety list. Do not contradict. |
| `today.challenge` (`name`, `effect_plain`, `how_to_compete_plain`, `winners`, `steps_board`, `id`) | Pressure + Peak turn. No invented rules. |
| `today.challenge.public_board` / decisions `choice_reason_plain` | Why-tonight personality; pairs/locks when present. |
| `today.votes.safe_vo` | `tie_then_tiebreak` · `split/messy` · or clean count. |
| `today.votes.do_not_say` | Banlist. Obey. |
| `today.eliminated` + inbound name-count | Cost tally. Prefer “Tonight {N} people name {Cost}.” Never empty “the vote splits.” |
| Peak row in `vote_reasons` when target is Cost | Inner vote-why. Skip-if-empty. |
| `final_statement` | Last words. Skip-if-empty / skip engine-clone. |
| `roles.{Peak\|Cost}` job, place, `trait` | Body in a place; trait fallback. |
| `alliances.confirmed` | Relationship weather only if listed. No invented blocs. |
| Picker `peak_id` `cost_id` `satellite_ids` `share_peak` `open_question` `door` `unfinished_thread` | Featured + cliff + Door. |

**Writer must not use**

- Reflections / “this is blank” day-log.  
- Chat as a deal log.  
- Narrator mind-read (`felt / realized / in my heart`).  
- RNG / “dice decided” as thesis.  
- Challenge-slug slogans that would repeat every Silent Pact night.

### 3.5 Skip rules (do not invent)

| Missing | Do |
|---------|----|
| No `vote_reasons` for Peak→Cost | Omit vote-why. |
| No usable `final_statement` | Omit last words. |
| No `alliances.confirmed` / no board pair / no leftover | Omit relationship weather. |
| No ledger-true doing | Omit doing. Habitat job+place still runs. |
| `choice_reason_plain` is `absent` | Do not say Cost “played and lost.” |
| No human why-tonight after fallbacks | Omit the personality clause. Keep job+place. |
| `safe_vo` = split/messy | Do not invent a clean pile-on. |
| `safe_vo` = tie_then_tiebreak | Speak the tie + that a tiebreak sent Cost home. Do not invent cascade step. |
| No Cost elim tonight | **Not a closer night.** Need a finished Survival-day vote (Peak + Cost). Challenge-only is not this SKU. |
| Chats fail contradiction | Texture only, or skip. |

Empty weather is legal. A thin night stays thin. Do not pad.

### 3.6 Picture (this pass includes kit **roles**, not a redesign)

**Already good enough — must not redesign this pass:** Phaser plant, Cost leave still → cinematic leave, Door flyover, 2D↔cinematic blend grammar.

**Repeating kit → beats (roles, not Episode 1 files)**

| Role | Kit | Beat |
|------|-----|------|
| Namecards | G8 | Follow / body |
| Peak habitat | G1 (job+place clip) | Body, doing, why-tonight |
| Cost habitat | G2 | Same for Cost |
| Challenge table | G3 | Pressure |
| Peak win | G4 | Turn |
| Ballots | G6 (seeded clip; split overlay when `safe_vo` needs it) | Vote |
| Cost leave | G5 | Cost / last words |
| Census | G7 pre/post identity grid | Census |
| Door lockup | End card `doubland.ai` | Door |

**Tuesday auto-cut:** generate/reuse G1–G8 for *this* Peak/Cost/challenge; bake Remotion from locked VO. **Gold human cut:** once when a **new type** needs a higher picture bar (new challenge teach look). Not Tuesday.

No new village rooms this pass. If VO points at a doing the habitat clip already shows, sit it there.

---

## 4. Inputs (so a later night is reproducible)

| Input | Where | Status |
|-------|--------|--------|
| Picker / scar schema | [`daily/SOT-new-daily.md`](daily/SOT-new-daily.md) §8.3 · code `tonight_scar_schema.py` | **Built.** Required: `peak_id`, `cost_id`, `share_peak`, `open_question`, `door`. Optional: `satellite_ids`, `unfinished_thread` (often **null**), `scar_chip`. |
| `scar.json` | Written on lock from picker (`day_scar.py`) | **Built.** Feeds Day N+1 chip. |
| `fact_ledger.json` | `build_fact_ledger.py` | **Built.** Includes `today_facts`, `writer_rules`, `today.votes.safe_vo`, `do_not_say`, `roles`, challenge card. |
| Picture kit G1–G8 | SOT §10.1 · `picture_kit_jobs.py` / `auto_picture_kit.py` | **Built.** Jobs from picker + ledger. |
| Closer VO writer | `draft_closer_tonight_vo.py` → `vo_locked_long.txt` | **Built** for version 1 beats. **Not built:** auto clauses for doing / weather / named-featured cliff. |
| Contradiction pass on chats | — | **Not built** as a nightly gate. |
| Share Spark export | SOT §6 | **Not built** (kit may point at a Peak clip only). |
| Timestamp card / deep link | — | **Not built.** |

---

## 5. Specimen only — Episode 1 (do not recut)

This is **what version 1 looks like when the current framework is filled**. Use it to see gaps (no doing, no weather, no vote-why, no last words, generic cliff). Do not lock Ivan and Alex as the format.

| | |
|--|--|
| Sim / night | `20260823-2` · Survival Episode 1 · engine day 2 |
| Peak / Cost | Ivan Pitts (Hold for the Shield) / Alex Butcher (six name him; leaves) |
| Package | `double-video/data/20260823-2/trailer_ready_day2` |
| Master | `output/trailer_9x16_closer.mp4` · copy `output/trailer_9x16_closer_autogen_benchmark.mp4` |
| VO | `vo_locked_long_accepted.txt` (also `vo_locked_long.txt`) |
| Runtime | ~84–90s **starting length of version 1**, not a cap for the format |

Accepted VO (specimen, not the deliverable):

> These are Doubles — AI versions of real people, making choices no one wrote for them.  
> Fifteen of them entered Survival mode: someone is voted out every night until one remains.  
> Today we are following two of them.  
> Ivan Pitts is a pharmacy technician at The Willows Market and Pharmacy.  
> Ivan tests what he believes against the real world.  
> Alex Butcher is a logistics coordinator at Harvey Oak Supply Store.  
> Alex prototypes fast — he wants to see what the room actually does.  
> At the daily challenge — Hold for the Shield — Choose HOLD or FOLD with your secret card. The highest held card wins immunity tonight.  
> Ivan Pitts won Hold for the Shield.  
> As the day continues, conversations turn into alliances. Alliances turn into votes.  
> At the end of the day, every Double casts a ballot.  
> Tonight Six people name Alex.  
> Ivan's stronger ballot is one of them.  
> Alex is gone.  
> Just like that, fifteen become fourteen.  
> Tomorrow, the Shield is gone. New alliances will form. New targets will emerge.  
> And another Double will leave the game.  
> The village is still running.  
> Watch every conversation, challenge, and vote live at doubland.ai.

A later night (pairs, leftover heat, last words) is a **better fill test** of beats 5–6 and 11–12. You may paper that as a **worked example of the format**, still not as a one-off recut.

---

## 6. Docs in / out (one line)

| Doc | This lock |
|-----|-----------|
| [`daily/SOT-new-daily.md`](daily/SOT-new-daily.md) | **In** — live engineering contract. Extend §9; do not replace it. |
| This file | **In** — format lock [A] brief. |
| [`20260820_longer_daily.md`](../20260820_longer_daily.md) | **In as grammar source** — doing / weather / inner / named Door. Runtime cap in that file is **overridden** (length follows story). |
| [`20260827_viral_video.md`](20260827_viral_video.md) §§1–13 | **Out** — travel / 2D mapping. |
| Founder addendum on that file | **Superseded as council brief** by this file. Intent (expand closer for “that’s them”) **kept**. |
| [`daily/daily-2D-3D-blend.md`](daily/daily-2D-3D-blend.md) | **Out** this pass. Plant / dive / Door slots already exist; do not redesign. |
| Share clip / timestamps | **Out.** Not built. |
| Anya CapCut Day 1 | Craft north star for picture, not the VO template to clone. |

---

## 7. What we need from this council

Return a **format**, not an episode.

| Seat | Ask |
|------|-----|
| **Screenwriter** | Confirm or rewrite §3.2 beat order. For skip-if-empty beats (doing, weather, vote-why, last words), write the fill rule in one sentence each so a later night does not need you. Draft **example lines as templates** (`{Peak}`, `{Cost}`, `{N}`), not Ivan/Alex copy. |
| **Reality TV** | Which event types earn doing / weather / turn / dilemma (talk, look, walk-out, table). Dignity on the boot. How a thin night still ships. |
| **Engagement** | Cliff pick order (§3.3). Itch = tomorrow’s group tape for a **named** featured thread. Catalog Door stays until deep link exists. |
| **Video Producer** | Sit new story beats on **existing kit roles**. List extra shot *types* only if G1–G8 cannot hold them. No 2D grammar pass. Runtime follows story; fail pad. |

**Do not send:** a new Ivan/Alex voiceover; a 60s travel tape; a 15-person recap; mapping as the job; pad.

**Viewer pass (any night):** can name Peak and Cost as people; felt one relationship or one fork **if the board had one**; can say why the room moved as a move, not only a tally; someone who knows that person thinks “that’s them.”
