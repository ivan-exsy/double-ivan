# Format lock [A] — daily closer

**Date:** 2026-08-28  
**Status:** **Archived.** Live closer contract is `video/daily/SOT-new-daily.md` §9.0–§9.5 (promoted 2026-08-28). Do not brief from this file.  
**For:** video / sim team implementing the nightly closer.  
**Language:** plain.

**Lock the daily closer format. Episode 1 is an example night, not the episode we are locking.**

---

## 0. Implementation lock (read this first)

Hybrid job, every night: **teach the show and a person.** Not a tutorial-only recap. Not a quiet movie with almost no voice.

- **Show framework:** a short Doubles line **every night** (first-time viewers will land on a random episode); someone is voted out every night; tonight’s game in one breath; a vote happened; someone left; one-breath census; a Door to the live village.
- **Personal touch:** two people at work, hands if we have it, one real choice, a dignified leave, a last line about someone still in tomorrow.
- **Voice on pictures:** every picture in the body of the tape has spoken words under it. Do not ship a montage with no voice. The only planned silence is the **first few seconds** (a face moving, no talking) so a clip autoplaying in Telegram still makes sense. That silent open is also what people forward. After that, voice stays on.

Night one vs later nights (stake only):

- **Every night, keep:** `These are Doubles — AI versions of real people, making choices no one wrote for them.` Founder lock: that last clause is the product differentiator (unscripted; no one knows how it ends). Say it once in the Doubles line. Do not say it again later.
- **Episode 1 / first Survival night, then:** Survival primer (`{N} entered. Someone is voted out every night until one remains.`). Short challenge how-to. One “talk becomes votes” line. Then people.
- **Later nights, then:** `{N} still in. Someone is voted out every night.` Then jobs. Do **not** replay the alliances sermon. Shorter game line if this challenge type was already taught.

Beat order for speech (swap locked): Doubles line → Survival stake → body in a place → hands at the job if we have it → personality that showed up today if we have it → tonight’s game → one choice → leave → one-breath census (`{N} become {N−1}`) under the identity-card grid (G7) → last line → Door. Empty beats skip. Do not invent. Do not pad. Do not drop G7. Census is show-framework, not the feeling.

Prove the new writer on a **copy** of a later night (Episode 2+ with a finished vote). Do not overwrite the Episode 1 Ivan/Alex master.

Do **not** say later in the tape: “this was unscripted,” “no one knows how it ends,” or a second “no one wrote this.” The Doubles line already named it. The choice in the night has to prove it.

Last line (after the leave):

- Name someone **still in** tomorrow. Default: tonight’s winner, walking in without tonight-only power (the Shield does not go with them).
- If the person who left left a true leftover that **points at someone living** (they named a person still there; last words name someone still there), use that leftover in the past tense, and the name you come back for is the living one.
- Never: “someone else leaves,” “new alliances will form,” “we’ll miss them,” come-back-for-the-person-who-already-left.

What they send: the closer itself. A separate short share clip is not built and is not a ship gate. The sendable moment is tonight’s real choice (or a naming look, or a dignified walk). Not the vote count as a joke. Not the census. Not the Door line.

Pictures: same eight jobs we already have. New story is a longer hold or a tighter crop inside those clips, not a new room. Do not redesign 2D-to-cinematic this pass.

Length: follows the night. Not longer on purpose. A quiet night can match or undershoot the old ~90s tape. A loud night (last words, a real tie between people, hands at work) can run longer. Fail = pad, village recap, or no real choice. Do not treat under 90 seconds as a fail.

**Required emotional hooks:** at least **2** of: one real choice (tonight’s reason, kid-plain, no rank), last words, inner vote why, living last line. The last line is always one of them. Hold-for-Shield Peak: `{Name} would rather …` then `She/He wins the Shield.` Quiet nights still need two hooks — do not ship choice-only or last-line-only.

**Ship gate (new trailers / new sims):** missing `vo_locked_long.txt` auto-locks from `draft_closer_tonight_vo`. Bake fails if `check_closer_vo_facts` does not see Doubles, the living last line, ≥2 hooks, Day-1 vs later alliances, and Peak choice/win when the ledger has them. Do not `--replace-vo-lock` the Episode 1 Ivan/Alex master. Prove on other sims.

Pass: a stranger can name the two people; they got the show (vote-out, tonight’s game, someone left); they felt one choice; they would send it; they want tomorrow for a named living person.

Do not: recut Ivan/Alex as the deliverable; write a new 60-second travel tape; add “please share.”

---

## 1. What this brief was (council packet — superseded by §0 where they conflict)

Lock a **repeating nightly closer**: same shape every Survival night, filled from that night’s picker + ledger + picture kit. A new night must run **without a new strategy memo**.

Episode 1 (Ivan Pitts / Alex Butcher, sim `20260823-2`) is the **specimen** of version 1 — what the current framework looks like when filled. It is not the cut to rewrite. Do not return a new Ivan/Alex voiceover.

**Pass:** a stranger can run any Survival night through this framework and get a closer with drama, character, an unexpected turn, and an inner dilemma **when the board has one** — without a new brief. A first-time viewer gets excited and wants to **send it**. They want tomorrow's tape.

**Fail:** the output only works for Ivan / Alex. Fail: 60–90s treated as a hard cap. Fail: encyclopedia. Fail: invented inner life. Fail: people respect it but do not share. Fail: they only learned the tally. Fail: they feel done.

### Viewer job (founder, 2026-08-28)

The big job of these trailers is to **start a share loop**: watch, get excited, feel the urge to send it, new people watch, they want the next episode.

This pass the **closer itself** is the thing they send. A separate short share clip (Spark) is out until it is built. Do not wait for it. Do not add a second "please share" ask.

Aftertaste we want in their head. **Do not write these as voiceover.** Show them.

- Can you imagine — this was completely unscripted!
- Who would think there is so much drama in simulated life!
- It's just like real life!

"Unscripted" is a specific choice nobody wrote, not the narrator saying unscripted. "Simulated life" is Doubles doing human things, not a lecture on the sim. "Just like real life" is one true fork, not a village tour.

They should **crave the next episode**. That is the named unfinished thread (cliff), not a generic "someone else leaves."

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
| Founder addendum on that file | **Superseded as council brief** by this file. Intent (expand closer for “that’s them,” share-loop, unscripted / sim-drama / real-life aftertaste) **kept**. |
| [`daily/daily-2D-3D-blend.md`](daily/daily-2D-3D-blend.md) | **Out** this pass. Plant / dive / Door slots already exist; do not redesign. |
| Share clip / timestamps | **Out.** Not built. |
| Anya CapCut Day 1 | Craft north star for picture, not the VO template to clone. |

---

## 7. What we need from this council

Return a **format**, not an episode.

| Seat | Ask |
|------|-----|
| **Screenwriter** | Confirm or rewrite §3.2 beat order. Skip-if-empty fill rules in one sentence each. Templates (`{Peak}`, `{Cost}`, `{N}`), not Ivan/Alex copy. Write so the three aftertastes happen **without saying them**. One sendable turn per night (the a-ha). Cliff line that makes tomorrow feel unfinished. |
| **Reality TV** | Drama of unscripted simulated life is the product. Which event types (talk, look, walk-out, table) make someone say they have to send this. Dignity on the boot so a share is not cruelty. How a thin night still has **one sendable turn** — or it is not a closer night. |
| **Engagement** | Share-loop owner this pass. The closer is what people send (Spark is out). Cliff pick order (§3.3) so they crave the next episode for a **named** featured thread. What makes a night get forwarded vs watched-and-closed. Catalog Door stays. No second CTA. |
| **Video Producer** | Sit new story beats on **existing kit roles**. Picture that makes a thumb hit share: one peak that can travel even if they only catch ~12 seconds. Extra shot *types* only if G1–G8 cannot hold them. No 2D grammar pass. Runtime follows story; fail pad; fail a pretty recap with no send moment. |

**Do not send:** a new Ivan/Alex voiceover; a 60s travel tape; a 15-person recap; mapping as the job; pad; “this is unscripted” as a slogan.

**Viewer pass (any night):** can name Peak and Cost as people; felt one relationship or one fork **if the board had one**; can say why the room moved as a move, not only a tally; someone who knows that person thinks “that’s them.” They got excited and would send it. They want tomorrow.
