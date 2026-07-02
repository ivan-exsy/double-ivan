# Scenario Writer Brief — Leadertalks Opening Trailer

**Simulation:** `20260628-4` (forked from `soul15_seed_20260224`)
**Cohort display name:** Leadertalks
**Cast size:** 15 Doubles
**Format:** 9:16 vertical, ~90–105 s total runtime
**Tone:** Intellectual thriller — quieter, tense, ideas have consequences
**Status:** Brief for an external scenario writer — not a code doc

---

## 1. Why this trailer exists

This trailer has three jobs, in priority order:

1. **A gift to the Leadertalks group itself** — 15 accomplished people see their AI Doubles introduced on screen. They should feel seen, not caricatured.
2. **A product demo for the Doubland MVP** — used in a VC raise and global distribution. A viewer who has never heard of Doubland must finish the trailer knowing what a Double is, what Doubland is, and why they would watch.
3. **A launch asset** — vertical, mobile-first, must work without sound (captions carry meaning) and with sound (narration + mix carry emotion).

The current auto-generated script (`data/20260628-4/opener&002/script.json`) hits job 2 in a generic way and misses jobs 1 and 3. Your job is to rewrite it so all three land.

---

## 2. The true story of Leadertalks — the hook

This is the narrative material the writer should build from. It is **not** in the current script and it is the strongest thing the trailer has going for it.

**Who they are:** An alumni group of a major US university. Fifteen people, 30–50 years old, scattered mostly across the United States, a few around the globe. Corporate leaders, software engineers, lawyers, VCs, startup founders. They have known each other for years. They stay in touch mostly through a long-running online group chat. They meet face-to-face once every few years. Their bond is conversation — different perspectives, shared network, mutual seriousness.

**What they did this season:** They took their **entire 2025 group chat** and ran an experiment.

1. Identified the **15 most active members** from a year of messages.
2. Ran a **proprietary personality assessment based solely on message content** — no surveys, no interviews, just what they actually said to each other.
3. **Anonymized everyone** — changed all names, gave each person a new identity in Doubland.
4. **Assigned roles in Doubland based on the assessed personalities.**
5. **Pressed PLAY.**

They did not know what would happen. They wanted to see what their AI selves would do when set loose in a world together, with no humans at the keyboard. This is a group of builders, investors, and argumentative professionals turning the camera on themselves — a witness-protection-for-fun premise where the original identities are real, the Doubles are derived from a year of real conversation, and the names are changed to protect the guilty.

**The emotional spine:** *We wanted to see what would happen. So we pressed play.*

---

## 3. The product concept — keep, sharpen

The current script's product explanation is functional and accurate. Keep the meaning, sharpen the language:

> *In Doubland, you create an AI Double based on your personality. Then you watch it live in a world with other Doubles. Every conversation. Every choice. Every relationship.*

This works. The writer may tighten or rephrase, but must not bury the product clarity — a VC watching cold must understand what Doubland is by the end of the concept block.

---

## 4. The cast — 15 equal Doubles

All 15 are introduced equally. **No subgroups, no featured-vs-background split, no rivalries or friendships to surface inside the trailer.** The writer's job is to make 15 introductions feel like one designed sequence, not 15 parallel slides.

### Cast list (anonymized names locked) with current trait lines

The trait lines below are the **current auto-generated version**. They are individually fine but stylistically uniform — almost all follow "X does Y, not Z" or "X sees Z in Y." The writer should **rewrite for contrast**: vary length, vary register (warm / cold / playful / threatening / quiet / declarative), let some lines be a fragment, let some be a question, let some land as a challenge.

| # | Name | Current trait line |
|---:|---|---|
| 1 | Max Shoemaker | Max turns ideas into momentum. |
| 2 | Alex Butcher | Alex prototypes before he explains. |
| 3 | Ivan Pitts | Ivan debates for clarity, not performance. |
| 4 | Olivia King | Olivia ships — then asks what's broken. |
| 5 | Diana Ogden | Diana reads the room behind the story. |
| 6 | Andrew Abrams | Andrew follows incentives, not headlines. |
| 7 | Irene Dove | Irene warms up the room — then stress-tests the logic. |
| 8 | Dean Sanford | Dean calls power when he sees it. |
| 9 | Alexis Reed | Alexis wants evidence before opinion. |
| 10 | Owen Logan | Owen treats the headline like a script. |
| 11 | Vince Vale | Vince measures claims against reality. |
| 12 | Mike Hooks | Mike argues in definitions, not slogans. |
| 13 | Nick Miller | Nick wants solutions that actually work. |
| 14 | Alex Shepard | Alex sees the gray zones others skip. |
| 15 | Vincent Slater | Vincent asks who benefits — every time. |

### Spotlight order is the writer's call

The current order is alphabetical-ish with Max first. The writer should **propose a new spotlight order with a narrative arc** — for example, open with the most kinetic energy, close with the most unsettling line; or open with the warmest, close with the coldest; or arrange so the cognitive postures build tension across the 15 beats. Include a one-sentence rationale for the chosen order.

### Source material the writer has for each persona

For each of the 15 names, a full **soul profile** exists at:

```
d:\Coding\generative_agents\souls\<persona-uuid>.md
```

UUID-to-name mapping:

| Name | Soul file |
|---|---|
| Max Shoemaker | `souls/bcf5fb65-6e7e-464a-83bb-51668f967f77.md` |
| Alex Butcher | `souls/0e8d6398-bfe5-40c7-9b6d-1eae2b0abc49.md` |
| Ivan Pitts | `souls/42c86639-8f93-4f97-a541-8cd5baf2fea8.md` |
| Olivia King | `souls/87daf41e-0237-4a55-a1ad-14007cefbefe.md` |
| Diana Ogden | `souls/021d4622-9b7e-4b73-9f94-322c4e5121da.md` |
| Andrew Abrams | `souls/be6de09c-91e4-42c7-a936-2193977dd17c.md` |
| Irene Dove | `souls/eac7be2a-b689-40be-a3a1-b4c4426ae9dc.md` |
| Dean Sanford | `souls/e8c1b20c-dff4-4ab3-836b-cf1d86a8b958.md` |
| Alexis Reed | `souls/0c7ff9b1-44bc-4afe-a189-52d88d2abd09.md` |
| Owen Logan | `souls/cc277da1-521b-4ba8-8f78-a7a1f09c3a32.md` |
| Vince Vale | `souls/69835d95-c543-48b1-85c0-f7d5351d845d.md` |
| Mike Hooks | `souls/77c2f157-64bb-4fa0-b451-3a644661d1a4.md` |
| Nick Miller | `souls/e473df98-8abb-44e9-a73f-f89771ec91d2.md` |
| Alex Shepard | `souls/f428ae04-975d-4163-b7e6-fbaea8befd24.md` |
| Vincent Slater | `souls/29f18c9f-3ec0-4dc2-89ee-2c9d7066b1ca.md` |

Each profile is ~200 lines, derived from a year of that person's actual messages. It includes identity in 3 lines, core drives, cognitive style, stress behavior, signature speech patterns, and predictive scenarios. **This is the primary source for the trait-line rewrites.** Sample (Max Shoemaker):

> *A high-energy builder + connector who turns abstract ideas into products, communities, and experiments. Default lens: incentives → outcomes. Vibe: optimistic, playful, fast ideation.*

The writer should read all 15 profiles before drafting.

A 15-node **relationship graph JSON** also exists in the cohort folder (`video/assets/cohort/soul15_seed_20260224/`). It is informational texture only — the writer should not surface specific relationships in the trailer, but may use it to sense the social topology.

---

## 5. Tone — intellectual thriller

Not premium documentary (too soft for this story), not reality-show pressure (too cheap for this audience). The reference is closer to an intellectual thriller:

- **Quiet but tense.** Ideas have consequences. A line like "Vincent asks who benefits — every time" should land like a chess move, not a caption.
- **Controlled escalation.** The cold open is calm and curious. The cast intros build pressure — 15 smart people with strong opinions, introduced one by one. The stakes montage is where the tension breaks into the open.
- **No melodrama.** These are accomplished adults in their 30s–50s. The trailer should respect that. No "will they survive?!?" energy. The stakes are intellectual and social: what happens when you set 15 versions of us loose with no adults at the keyboard.
- **The reveal is the engine.** The cast-selection process (chat → assess → anonymize → press play) is the slow-burn twist. It should land partway through, not in the first five seconds.

---

## 6. What the writer is being asked to produce

### 6.1 Rewrite the cold open (0–30 s)

Today the cold open is three blocks: hook → concept intro → season bridge. The writer should restructure to land the Leadertalks story and the cast-selection reveal. Proposed shape (writer may revise):

1. **Hook** (~0–11 s): the "What if you had a Double?" framing. Keep the spirit of the current hook; sharpen for tension.
2. **Product concept** (~11–19 s): what a Double is, what Doubland is. Keep the clarity.
3. **Season bridge + cast-selection reveal** (~19–30 s): introduce Leadertalks as a real alumni group, then reveal the process — a year of messages, 15 most active, personality assessment, anonymized, pressed play. This is the twist the current script is missing.

Fix the existing grammar bug: "Leadertalks enters," not "the Leadertalks enters."

### 6.2 Rewrite the 15 cast intro lines (30–70 s)

- Each line is one short spoken sentence per Double, played over a ~2.6 s full-screen spotlight beat.
- **No "X does Y, not Z" formula repeated 15 times.** Vary the rhetorical shape. Some lines can be a fragment. Some can be a question. Some can be a challenge. Some can be a quiet confession.
- Each line must be **evidence-based** from the soul profile — the writer's job is to find the most cinematic one-line distillation of that person's actual cognitive posture, not to invent character.
- Each line must read on screen at mobile caption size in ~2.6 s. Roughly 6–10 words.
- Together, the 15 lines should feel like a sequence with a curve — not 15 parallel monads.

### 6.3 Rewrite the stakes montage (70–90 s)

Today this block is generic Doubland product copy ("Watch live 24/7. Follow any Double. Replay every moment. They learn. They change. They surprise you."). The writer should re-ground it in **what's at stake when 15 versions of one real alumni group are left to interact with no humans at the keyboard** — the intellectual and social stakes, not the feature list. The closing line "And after a while... you ask — what would MY Double do?" is strong and can stay.

### 6.4 End card (90–98 s)

Lands on **"What if?"** → `doubland.ai` → "Episode 1 tomorrow · 18:30." Keep this. The writer may propose a single line of narration that carries into the end card if it strengthens the button.

### 6.5 Spotlight order rationale

A one-paragraph explanation of why the 15 beats are ordered the way they are.

---

## 7. Constraints

| Constraint | Detail |
|---|---|
| **Anonymization** | Real names are never revealed. The "names are changed" fact is part of the story and can be named in narration. The anonymized names in §4 are locked. |
| **Language** | English is the primary language of the trailer narration and on-screen copy. (Inside the simulation, users can chat with Doubles in any language — this fact does not need to appear in the opener.) |
| **Cast equality** | All 15 are introduced equally. No featured vs. background split. No subgroups, duos, or rivalries surfaced in the trailer. |
| **No forbidden topics** | The writer is not restricted from any subject area, but should treat the Doubles as the soul profiles describe them — no inventing biographical facts the profiles do not support. |
| **Format** | 9:16 vertical, mobile-first, must work silent (captions) and with sound. Total runtime ~90–105 s. |
| **Product clarity** | A cold viewer must understand what Doubland is by the end of the concept block. Do not sacrifice product clarity for atmosphere. |
| **Audience** | Leadertalks group themselves + Doubland product launch audience. Must work for a stranger who knows nothing about the group. |

---

## 8. Deliverables

1. **Final script** in the same JSON shape as `data/20260628-4/opener&002/script.json` — fields: `cold_open` (with `line`, `hook`, `concept_intro`, `season_bridge`), `scenes` (15 × `cast_intro` with `narration_line` per persona), `stakes_montage` (with `narration`), `end_card`. Keep all non-narration fields (camera, transitions, sketch paths) as-is.
2. **Spotlight order** — the 15 scenes in the writer's chosen order, with a one-paragraph rationale.
3. **A short writer's note** (≤ 300 words) on the chosen emotional arc: where the reveal lands, how the 15 intros build, what the trailer leaves the viewer feeling.

---

## 9. Reference materials

| Material | Path | Use |
|---|---|---|
| Current auto-gen script | `d:\Coding\generative_agents\data\20260628-4\opener&002\script.json` | What's there now; the JSON shape to match |
| 15 soul profiles | `d:\Coding\generative_agents\souls\<uuid>.md` | Primary source for each persona |
| Trailer workbook (pilot context, cast-intro gap analysis) | `d:\Coding\double-ivan\video\trailer-opening\20260625_trailer-workbook.md` | Why the current script is weak on cast framing |
| Opening trailer automation plan | `d:\Coding\double-ivan\video\trailer-opening\20260617_vertical-trailer-automation.md` | How the script becomes a video (Remotion, ~90–105 s target) |
| Opening trailer SOT (creative grammar) | `d:\Coding\double-ivan\video\trailer-opening\sot-opening-trailer.md` | Tone, macro rhythm, motion grammar reference |
| Relationship graph (informational only) | `d:\Coding\generative_agents\video\assets\cohort\soul15_seed_20260224\` | Social topology; do not surface in trailer |

---

## 10. Out of scope for the writer

- Visual / motion grammar (Remotion beat map is locked; writer does not specify animations)
- Music and SFX selection
- Voice casting / narration delivery direction (the TTS pipeline handles this; inline delivery cues like `[curious]`, `[warmly]`, `[excited]` are welcome in the script)
- The 15-node relationship graph as on-screen content
- Anything outside the four script blocks (cold open, cast intros, stakes montage, end card)

---

## 11. The one-sentence pitch for the writer

> Fifteen accomplished adults turned a year of their own group chat into 15 anonymized AI versions of themselves, pressed play, and watched to see what would happen — this is the trailer that introduces them and the world they stepped into.
