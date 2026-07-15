# Follow-up — Final VO polish + framework capture for auto pipeline

**To:** Reality-TV / screenwriter expert (+ Engagement if CTA itch needs a line)  
**From:** Product (Ivan)  
**Date:** 2026-07-15  
**Parent inquiry:** `d:\Coding\double-ivan\video\daily\20260715_script.md`  
**Sim / package:** `20260713-1` · `d:\Coding\generative_agents\data\20260713-1\overview_day2&001\`  
**Status:** Draft VO **accepted in spine** — light polish only, then lock. Separately: **capture your craft framework** so we can productize it into the automated Narration Writer.

---

## 1. Product verdict on your draft

**Approve the spine.** This draft fixes the auto VO’s failure modes (caption cards, repeated stamps, jargon, under-taught challenge). Cold-viewer clarity and stakes mostly land. Runtime ~232 words ≈ **~110s** @ warm 1.5× — inside target.

### Accepted draft (working text)

```
These are Doubles — AI versions of real people, making choices no one wrote for them.

It is the first night of Survival Mode. Every day, one Double gets eliminated — until only one remains.

Ivan Pitts is a pharmacy technician at The Willows Market and Pharmacy. He wants to read the room before the vote finds him.

Irene Dove is a barista at Hobbs Cafe. She wants cover when the board lights up.

Vince Vale is a guest lecturer at Oak Hill College. He watches how the room shifts, and talks it through with Irene at the cafe.

Today they play Hold for the Shield. Everyone gets a secret card: keep it to stay in the fight, or fold and sit out. Highest still in wins the Shield — safe from tonight's vote. Irene keeps hers for the cover she wanted, and she wins. She's safe tonight.

Ivan never gets that safety. All night he reads faces, hunting to keep the vote off him. Vince keeps talking it through with Irene, but the room never settles on one plan. When the votes come in, they scatter — and six find Ivan. Irene's ballot is one of them. He goes home.

Irene still has the Shield. The Double who tried to read the room is gone — so who does the room trust tomorrow?
Watch today's chats, challenge, and ballots at doubland.ai.
```

---

## 2. Ask A — Final polish (return a locked VO)

Please return **one final plain-text VO** (no `[SCENE]` markers) incorporating these polish notes. Keep the throughline; do not reopen cast or facts.

### Polish checklist

| # | Issue | Suggestion |
|---|--------|------------|
| **P1** | Insider words on Irene’s want | Replace “cover” / “board lights up” with kid-plain, e.g. *“She wants protection when tonight’s vote starts.”* Echo the same plain word in the challenge payoff (“keeps hers for the protection she wanted”). |
| **P2** | Vince still thin vs Ivan/Irene | Give Vince one concrete **want** (still ledger-safe) so the trio balances — e.g. find who to trust / stay off the wrong list — without inventing a locked alliance. |
| **P3** | Slightly writerly phrase | Soften “hunting to keep the vote off him” → simpler (“trying to keep votes off him” or equivalent). |
| **P4** | Participation itch (optional but preferred) | After the trust cliffhanger (or as a final breath before/after doubland.ai), one soft line that makes a cold viewer imagine **their** Double with **their** friends/co-workers — without a hard sell or killing the cliff. |
| **P5** | Keep what already works | Concept → Survival frame → stamp once per lead → challenge section → want→turn→cost → cliff + doubland.ai CTA. No re-bio. No invented clean voting bloc. Irene voted Ivan is OK (ledger). |

### Deliverable for Ask A

1. **Final locked VO** (full text)  
2. **Diff notes** — 3–6 bullets: what you changed and why  
3. Confirm cold-viewer quiz still passes (Doubles / Survival / challenge+Irene safe / who went home / why doubland.ai or tomorrow)

---

## 3. Ask B — Framework capture (for productizing the auto Narration Writer)

We want the **next** Survival daily auto draft to sound like *your* accepted VO — not the rejected caption-card draft. Please document the **framework / method** you used so engineering can encode it into prompts, validators, and (if needed) stitch order.

Be as concrete as you can. We would rather have too much detail than a vague “write better stories.”

### B1. Mental model & order of work

1. What did you decide **first** (before any sentence): thesis? featured wants? challenge teach? cliff?  
2. What is your fixed **block order** (if any), and which blocks are optional?  
3. How do you choose **which 1–3 moments** earn screen time when the digest has many chats?  
4. How do you allocate **runtime budget** across blocks (concept / frame / stamps / challenge / middle / farewell / CTA)? Rough % or word ranges?

### B2. Character stamps (F1 / “who they are”)

5. Exact rule for **stamp once** — what goes in the stamp line (job / place / want), and what is banned on later mentions?  
6. How do you turn dry bio traits (“epistemic integrity”) into a **want** that serves tonight’s plot?  
7. How do you balance **2–4 leads** so the third (coverage) doesn’t feel like a cameo?  
8. First-name vs full-name policy after stamps?

### B3. Challenge teach (kid-plain)

9. Template for teaching a **new** challenge type in ≤N sentences: name → how to play → what you win → who won → what that means for the vote.  
10. What do you **never** say (rules dump, jargon, assuming prior knowledge)?  
11. How do you tie challenge outcome to a featured Double’s **want** (Irene “protection” ↔ Shield) without sounding cute?

### B4. Glue / prose craft (anti-caption)

12. How do you avoid **fragmenting** one person across multiple caption-like lines?  
13. Sentence-level rules: cause→effect, max ideas per sentence, banned shapes (label lists, “X’s plan: …”, repeated job clauses).  
14. Jargon blacklist you actually used (or mental filter) for this draft?  
15. When is it OK to re-mention a Double in a **challenge/vote section** vs when is it noise?

### B5. Facts & honesty

16. How do you stay inside a **fact ledger** while still sounding dramatic (split board, soft signals, no invented bloc)?  
17. When do you name a **specific ballot** (e.g. Irene voted Ivan) vs stay aggregate (“six find Ivan”)?  
18. What do you do when digest Moments are ops-speak / meta-game heavy?

### B6. Close / conversion

19. Recipe for **cliffhanger** (trust vacuum, imbalance, tomorrow) — one question, not a bow.  
20. Recipe for **doubland.ai** CTA — what concrete nouns pull someone into the sim (chats / challenge / ballots)?  
21. Recipe for soft **“my Double / my people”** itch without killing the cliff.  
22. How do concept-reset + Survival frame interact with the opener (rhyme vs repeat)?

### B7. QA you ran on yourself

23. Your personal **acceptance checklist** before handing a draft to product.  
24. The **5 cold-viewer questions** you optimized for on this piece.  
25. What would make you **reject your own draft** on a second pass?

### B8. Artifacts we can encode

Please return, if possible:

| Artifact | Format | Use in pipeline |
|----------|--------|-----------------|
| **Block schema** | Ordered list of blocks + purpose + max words | Prompt + stitch |
| **Stamp schema** | Fields + examples (good/bad) | F1 validator + writer |
| **Challenge teach template** | Fill-in slots from fact ledger challenge card | Writer + fact gate |
| **Banned phrases / shapes** | List | Soft lint / retry feedback |
| **Few-shot** | This accepted VO (+ 1–2 short bad→good contrasts) | Narration Writer few-shot |
| **Rubric** | Scored criteria (1–5) for cohesive / kid-plain / stakes / CTA | Human + later auto eval |
| **Decision tree** | If elimination day / if challenge teach / if coverage lead… | Producer + Writer branching |

### B9. Inputs you actually used

26. Which files did you lean on hardest for this draft (`fact_ledger`, `cast_digest`, stamps, day_reasoning, prior gold VO)? Rank them.  
27. What did you **ignore** on purpose (and why)?  
28. If you could change one **upstream** input (digest / ledger / stamp traits), what would it be?

---

## 4. Why Ask B matters (engineering context — for your framing)

Today’s auto path roughly does: cast digest → fact ledger → Story Producer → Narration Writer → TTS. The rejected draft failed on **glue and teach**, not on missing facts. We already fixed workplace stamps and softened word-count gates. What we still lack is your **editorial method** as enforceable writer contract + few-shot + validators.

Parent inquiry + raw paths remain in:

- `d:\Coding\double-ivan\video\daily\20260715_script.md` §9  
- Package: `d:\Coding\generative_agents\data\20260713-1\overview_day2&001\`

Gold-shape reference (different cast; craft only):  
`d:\Coding\double-ivan\video\TODO_script_draft.md`

---

## 5. Return format (please)

### Part 1 — Final VO
- Locked narration text  
- Short change log (polish only)

### Part 2 — Framework pack
- Answers to B1–B9 (bullet or numbered is fine)  
- Block schema + stamp schema + challenge template + banned shapes  
- Few-shot: accepted VO + at least one “bad caption → good glue” mini example from this same day  
- Rubric (even a rough 5-axis scorecard)

**Risk:** low (creative). **Next step after your return:** product locks VO → re-TTS → Remotion; eng turns Part 2 into Narration Writer prompt/validator updates.

---

## 6. One-line ask

**Polish the accepted draft per P1–P5 into a final lock, then teach us the exact framework you used — block order, stamp/challenge/CTA recipes, anti-caption rules, and QA — in enough detail that we can encode it into the automated daily VO writer.**

---

## 7. Expert response (COS · screenwriter) — 2026-07-15

**From:** COS / `agents/screenwriter` (method-informed craft; prior chain + founder close preserved)  
**Task trail:** `COS/tasks/2026-07-15-001` → `COS/tasks/2026-07-15-003` → this polish  
**Risk:** low · **Status:** Part 1 ready to lock · Part 2 for eng Narration Writer encode

---

### Part 1 — Final locked VO (Ask A · P1–P5)

```
These are Doubles — AI versions of real people, making choices no one wrote for them.

It is the first night of Survival Mode. Every day, one Double gets eliminated — until only one remains.

Ivan Pitts is a pharmacy technician at The Willows Market and Pharmacy. He wants to read the room before the vote finds him.

Irene Dove is a barista at Hobbs Cafe. She wants protection when tonight's vote starts.

Vince Vale is a guest lecturer at Oak Hill College. He wants to see who he can trust before the room picks a target.

Today they play Hold for the Shield. Everyone gets a secret card: keep it to stay in the fight, or fold and sit out. Highest still in wins the Shield — safe from tonight's vote. Irene keeps hers for the protection she wanted, and she wins. She's safe tonight.

Ivan never gets that safety. All night he reads faces, trying to keep votes off him. Vince keeps talking it through with Irene, but the room never settles on one plan. When the votes come in, they scatter — and six find Ivan. Irene's ballot is one of them. He goes home.

Irene still has the Shield. The Double who tried to read the room is gone — so who does the room trust tomorrow?
Watch today's chats, challenge, and ballots at doubland.ai. Then picture your Double there — with your people — on a night like this.
```

**Word count:** ~244 · **Est. @ ~2.1 wps (warm 1.5×):** ~116s · inside [C] `<120s` / ~100–115 target band.

#### Diff notes (polish only)

1. **P1** — Irene want: “cover / board lights up” → **“protection when tonight's vote starts.”** Challenge payoff echoes the same plain word: “keeps hers for the **protection** she wanted.”
2. **P2** — Vince stamp now has an explicit want: **“see who he can trust before the room picks a target”** (ledger-safe; cafe talk with Irene stays in mid as behavior, not a locked alliance).
3. **P3** — “hunting to keep the vote off him” → **“trying to keep votes off him.”**
4. **P4** — Soft itch after doubland.ai: **“Then picture your Double there — with your people — on a night like this.”** Cliff stays first; itch is a final breath, not a hard sell.
5. **P5** — Spine/facts unchanged: stamp once · Irene sole Shield · messy six · Irene→Ivan ballot · no re-bio · no invented bloc.

#### Cold-viewer quiz (still pass)

| Q | Expected |
|---|----------|
| What is a Double? | AI version of a real person, making their own choices |
| What is Survival tonight? | First night; every day one Double can be eliminated until one remains |
| Challenge + who safe? | Hold for the Shield (keep/fold; highest still in = safe); **Irene** |
| Who went home / cost? | **Ivan** on six; votes scattered; Irene’s ballot among them |
| Why doubland.ai / tomorrow? | Watch chats, challenge, ballots; open question: who does the room trust tomorrow? Soft: picture your Double with your people |

**Handoff:** Product may lock this text into package `script.json` / `script_used.txt` → re-TTS → Remotion. Do not `lock_day_script` until product decides.

---

### Part 2 — Framework pack (Ask B) — encode into Narration Writer

*Method: Fact-Locked Five-Beat Spine (`want → pressure → turn → cost → honest open question`). COS screenwriter doctrine: `COS/agents/screenwriter/` (A0–A8, REGRESSION.md, wiki decisions). Project SOT wins for facts; this pack wins for spoken craft.*

#### B1. Mental model & order of work

1. **Decide first (before sentences):** (a) audience anchor = elim Double if present; (b) spine sentence: `[Name] wants X, but [pressure]. When [turn], [cost], leaving [open question].`; (c) challenge must be teachable in kid-plain; (d) cliff = honest open (never withhold a known ledger answer).
2. **Fixed block order ([C] Survival Day 1):**  
   `Concept → Survival frame → Stamp×N (≤3) → Challenge teach + winner → Mid want→turn → Cost/farewell → Cliff → CTA (+ optional itch)`  
   Optional: prior-day scar (not on Day 1); named secondary vote color (e.g. Vincent Slater 4) only if it doesn’t steal farewell; participation itch.
3. **Which moments earn screen time:** Prefer beats that (i) change vote pressure, (ii) land a featured want, (iii) are ledger-backed. Digest chat color is seasoning — one soft re-mention max (Vince↔Irene talk). Ignore ops-speak / meta timestamps unless they translate to a human action.
4. **Runtime budget ([C] ~210–250 words / ~100–115s; hard &lt;120s):**

| Block | Target words | ~% |
|-------|-------------:|---:|
| Concept + Survival frame | 35–45 | 15% |
| Stamps (≤3) | 55–70 | 28% |
| Challenge teach + winner | 45–55 | 22% |
| Mid (want→turn) | 40–55 | 20% |
| Cost / farewell | 25–35 | 12% |
| Cliff + CTA (+ itch) | 25–40 | 12% |

Prefer completeness of turn/cost over cutting; if over hard cap, trim frame/CTA/itch first — never cut elim cost or Shield teach.

#### B2. Character stamps (F1)

5. **Stamp once:** `[Full Name] is a [job] at [place]. [He/She] wants [plain outcome tonight].`  
   After that: **first name + action only**. Banned later: full job+place refrain; clinical traits; re-intro “X, a pharmacy technician…”
6. **Trait → want:** Ask “what were they trying to get or avoid *tonight*?” Use digest Moments / schedule / elim role. Bad: “epistemic integrity.” Good: “read the room before the vote finds him.” Want must pay off in turn or cost (Irene protection ↔ Shield; Ivan read-the-room ↔ cliff).
7. **Balance 2–4 leads:** One anchor (usually boot). Each stamp needs a **want verb**. Coverage lead (Vince) must have want + one mid re-mention that serves plot (talk / watch), not a third stamp.
8. **Names:** Full name on stamp line; **first names after**. Full name OK once on farewell if clarity needs it — don’t re-bio.

#### B3. Challenge teach (kid-plain)

9. **Template (≤4–5 sentences):**  
   `Today they play [Name]. [How to play in one breath]. [What you win] — [what that means for tonight’s vote]. [Winner] [ties to their want], and [outcome]. [She's/He's] safe tonight.`  
   Fill slots from ledger: `challenge.name`, `how_to_compete_plain`, `effect_plain`, `winners` only.
10. **Never say:** strategy jargon; “data-gathering”; assuming viewer saw opener mechanics; second winner not in `winners`; “survived Day 1” on Day 1; raw RNG “the card decided” as the whole story.
11. **Want ↔ outcome:** Echo the stamp’s plain noun (protection → “protection she wanted”). Personality main line; chance seasons (keep/fold), character owns the landing.

#### B4. Glue / prose craft (anti-caption)

12. **Anti-fragment:** Introduce once, then continue the story. Never three caption cards for the same person.
13. **Sentence rules:** Each sentence should **cause** the next. Max ~1–2 new ideas per sentence. Banned shapes: `X's plan: …`; trait label stacks; duplicated paragraphs; “X, a [job] at [place], …” after stamp; parallel “Name is… Trait.” lists.
14. **Jargon blacklist (this day + general):** behavioral map, data alliance, data-driven approach, fractured map, epistemic integrity, systems-minded analyst, coalition (unless `alliances.confirmed`), epistemic / psych jargon, “sharpest watcher” as narrator epithet (pay off the want instead).
15. **Re-mention OK** in challenge/vote when it moves plot (who safe, who hunted, who cast). Noise if it only re-labels them.

#### B5. Facts & honesty

16. **Ledger drama:** Use `safe_vo` language (“scatter / messy / split”). Soft signals = behavior only (“talking it through,” “room never settles”). Never invent N-person sides unless `alliances.confirmed`.
17. **Named ballot:** OK when (a) voter is already featured, (b) ballot is in `votes_cast`, (c) it sharpens cost without implying a pile-on. Pattern: “six find Ivan. Irene’s ballot is one of them.” Aggregate-only if naming would invent motive.
18. **Ops-speak Moments:** Translate to human verbs (reads faces, talks it through) or drop. Never paste “timestamp / fold-signal / behavioral map” into VO.

#### B6. Close / conversion

19. **Cliff:** One open question that rides the wound (trust vacuum after the reader-of-the-room goes home). Not a bow; not a withheld known fact.
20. **doubland.ai CTA:** Concrete nouns — **chats, challenge, ballots** (or “today’s day”). Prefer “Watch…” / “Dig into…” over generic “follow live.”
21. **Itch:** After cliff (+ CTA), one soft picture line: your Double + your people + tonight’s situation (no Shield / night like this). No FOMO, streaks, or hard sell.
22. **Opener rhyme:** Reuse Survival Mode one-liner energy (“every day one Double gets eliminated — until only one remains”) without pasting opener body. Concept line stands alone for cold daily viewers.

#### B7. QA (self-accept)

23. **Checklist before handoff:** REGRESSION.md 7 rows; spine sentence writable; each stamp has want; challenge 12-year-old plain; no re-bio; no invented bloc; cliff honest; word count ≤~250 / flag if &gt;120s est.; dignity pass.
24. **Five questions optimized:** Double? Survival tonight? Challenge + who safe? Who wanted what / who went home? Why open doubland.ai or care about tomorrow?
25. **Reject own draft if:** caption-card ear test fails; challenge needs mental math; third lead has no want; cliff is an epithet not a want payoff; any fact not in ledger; humiliation-as-hook.

#### B8. Encode-ready artifacts

**Block schema**

| Order | Block ID | Purpose | Max words | Required |
|------:|----------|---------|----------:|:--------:|
| 1 | `concept` | What Doubles are | 25 | Y |
| 2 | `survival_frame` | Day-1 stakes / elim loop | 30 | Y ([C]) |
| 3 | `stamp` × ≤3 | job+place+want once | 25 each | Y |
| 4 | `challenge_teach` | name→play→win→winner→safe | 55 | Y if challenge day |
| 5 | `mid_turn` | unprotected hunt / room pressure | 55 | Y |
| 6 | `cost` | messy board + elim (+ optional named ballot) | 40 | Y if elim |
| 7 | `cliff` | honest open question | 25 | Y |
| 8 | `cta_sim` | doubland.ai + concrete nouns | 20 | Y |
| 9 | `itch` | soft own-Double picture | 20 | Optional |

**Stamp schema**

```
stamp:
  full_name: string
  job: string          # from stamp_facts
  place: string        # from stamp_facts
  want: string         # plain tonight-outcome; NOT clinical trait
  role: anchor|immunity|coverage
spoken: "{full_name} is a {job} at {place}. {He|She} wants {want}."
after: first_name + action only
```

Good: `She wants protection when tonight's vote starts.`  
Bad: `Socially engaged, intellectually curious commentator.`

**Challenge teach template (fill from ledger)**

```
Today they play {name}. {how_to_compete_plain_kid}. {effect_plain} — safe from tonight's vote.
{winner_first} keeps/claims for the {want_echo} they wanted, and {he|she} wins. {He|She}'s safe tonight.
```

**Banned phrases / shapes (lint)**

- Clinical traits as stamps; `X's plan:`; duplicated paragraphs  
- Re-bio job+place after first stamp  
- `data alliance`, `behavioral map`, `fractured map`, `epistemic`, `systems-minded`  
- Clean pile-on language when `safe_vo=split/messy`  
- Second immunity winner; “survived Day 1” on Survival Day 1  
- `[SCENE]`, pause/camera markers in spoken draft  

**Few-shot — bad caption → good glue (same day)**

| Bad (rejected auto) | Good (locked craft) |
|---------------------|---------------------|
| `Irene is a barista at Hobbs Cafe. Socially engaged, intellectually curious commentator.` | `Irene Dove is a barista at Hobbs Cafe. She wants protection when tonight's vote starts.` |
| `Ivan's plan: use the challenge as a data-gathering exercise, build a behavioral map…` | `All night he reads faces, trying to keep votes off him.` |
| `Vince Vale, a guest lecturer…` (re-bio) + invented “data-driven” partnership ×2 | Stamp Vince once with trust-want; mid: `Vince keeps talking it through with Irene, but the room never settles on one plan.` |
| `Irene has the Shield and a growing data alliance.` | `Irene still has the Shield.` + honest trust cliff (no invented bloc) |

**Full few-shot positive:** use Part 1 locked VO above.  
**Full few-shot negative:** parent inquiry §6 / `anti-patterns/20260715_auto-draft-reject.md`.

**Rubric (1–5 each; ship ≥4 avg; hard-fail any 1 on fact/dignity)**

| Axis | 1 | 3 | 5 |
|------|---|---|---|
| Fact fidelity | Invents bloc/winner | Soft overclaim | Ledger-true only |
| First-listen clarity | Mental math / glue fail | Mostly clear | 12-year-old passes quiz |
| Cohesive spine | Caption list | Partial arc | Want→pressure→turn→cost→open |
| Kid-plain challenge | Rules dump / jargon | Teach OK, no want tie | Teach + want echo |
| CTA / cliff | Bow or vague URL | Cliff or CTA only | Honest cliff + concrete sim CTA (+ soft itch OK) |

**Decision tree (writer branching)**

```
if video_type != day_survival: use [A]/[B] contracts (out of scope here)
if survival_day == 1: no scar; full stamps (L11)
if challenge present: insert challenge_teach from ledger card only
if eliminated set: audience_anchor = eliminated; cost beat required
if votes.safe_vo == split/messy: forbid clean pile-on language
if featured voter ballot in votes_cast: optional "X's ballot is one of them"
if alliances.confirmed empty: no alliance/contract claims
if runtime_est > 120s: trim itch → CTA adjectives → frame; never cut cost/teach
```

#### B9. Inputs used / ignored / upstream wish

26. **Ranked inputs for this draft:**  
   (1) `fact_ledger.json` · (2) `stamp_facts.md` · (3) `cast_digest.md` (wants/moments) · (4) gold shape `TODO_script_draft.md` · (5) Video SOT L10–L13 · (6) opener Survival one-liner (rhyme) · (7) rejected `script.json` as anti-pattern only.
27. **Ignored on purpose:** `day_reasoning.json` hold/fold internals (too meta); spicy rank reorder (cast already editorial-locked); clinical stamp traits; inventing Vince–Irene voting bloc from cafe chat.
28. **Upstream wish:** Stamp pipeline should emit **want candidates** (plain tonight-outcome) instead of dry trait labels — so Narration Writer never sees “epistemic integrity” as a stamp field.

---

### Encode pointer (eng)

Primary craft owner going forward: **`screenwriter → engagement (CTA/itch) → videoproducer`**. Do not primary-route Survival VO through `realitytv` unless mechanics are open.

Canonical doctrine paths:

- `d:\Coding\COS\agents\screenwriter\agent.md`  
- `d:\Coding\COS\agents\screenwriter\REGRESSION.md`  
- `d:\Coding\COS\agents\screenwriter\kb\wiki\decision\*`  
- Gold: `kb/raw/task-deliverables/` · Anti: `kb/raw/anti-patterns/20260715_auto-draft-reject.md`

**Next:** Product locks Part 1 → TTS/Remotion. Eng turns Part 2 block/stamp/challenge schemas + banned list + few-shot into Narration Writer prompt + validators.
