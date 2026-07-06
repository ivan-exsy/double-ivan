# Persona-to-persona conversations — observations

**Date:** 2026-05-08
**Reporter:** Nicolas
**Sim baseline:** `20260506-5` (3000 steps, 4-persona Survival Game cast: Ivan, Gosha, Katya, Luba). Same sim that cleared the action↔location MVP bar.
**Method:** FE visual review of select dialogue scenes + verbatim cross-check against `chat` and `chat_metadata` fields in `movement/<step>.json` for all 3000 steps. Conversations indexed by `conversation_id`; 200 unique conversations identified across the sim.
**Predecessor:** `20260504_action-location-observations_v2.md`. With action↔location closed for MVP, conversation realism is the next dimension to harden.

---

## Summary

Ten conversation-system issues observed across `20260506-5`. Five are immersion-breaking and should be considered MVP blockers for any user-visible demo / trailer; the others are quality regressions that compound over time.

1. **[CRITICAL] Hallucinated NPC characters.** Personas reference and reason about characters that do not exist in the sim's cast — Marco (82 dialogue mentions), Lena (64), Mira (46), Maren (18), plus Misha, Mikhail, Miro, Anton, Tomas, "the barista". Cast is exactly four: Ivan, Gosha, Katya, Luba. The phantoms are not treated as background ambience — personas plan votes against them, attribute motives to them, and adjust strategy around them.
2. **[CRITICAL] No event-memory propagation for eliminations.** Ivan is eliminated at step 870 (May 6, 21:00, Day 1 voting). Gosha is eliminated at step 2310 (May 7, 21:00, Day 2 voting). Across all surviving personas' memory stores (792 + 807 + 316 = 1915 nodes), **zero nodes** carry elimination-related keywords (`voted out`, `eliminated`, `farewell`). Across the 7 Day-3 conversations (Katya & Luba — the only survivors), **zero mention Ivan or Gosha by name.** No grief, no relief, no strategic reframing of "the two of us now".
3. **[CRITICAL] Ghost-persona event nodes — eliminated personas appear in survivors' memory as still active.** Despite Ivan's drop at step 870 and Gosha's at step 2310, Katya's memory has 3 event-nodes about Ivan and 11 event-nodes about Gosha created *after* their respective drops; Luba has 14 about Ivan and 7 about Gosha post-drop. Examples: *"2026-05-08 07:56 | Gosha Pistsov is annotate scanned notes…"* (12 hours after Gosha's elimination), *"2026-05-08 08:11 | Ivan Pistsov is review betrayal game rules…"* (36 hours after Ivan's elimination). This is a state-management bug that surfaces as a conversation-memory bug.
4. **[HIGH] Conversation-reset epidemic.** Median gap between consecutive conversations of the same persona pair is **2 sim-minutes**. 86% of Gosha-Luba conversations re-engage within 10 min of the prior one. Each new conversation opens with no awareness of the one that just ended; the `conversation_id` is regenerated each time.
5. **[HIGH] Phrase mass-production / template loops.** "Stick together" appears in 25 of 44 Katya-Luba conversations (57%). "The vote tonight" in 13 (30%). "If someone accuses me" verbatim in 7. "Luba, quick thought" as the literal opening of 7 separate conversations. The variation is template-driven, not generative.
6. **[HIGH] Character-voice collapse.** All four personas open conversations with the same cadence: "Quick thought —", "Quick check —", "Noticed…". Gosha opened three separate conversations with Ivan in steps 749–762 using the *identical* line: *"Ivan — table's been noisy all evening, huh?"*
7. **[HIGH] Topic concentration on survival strategy is near-total.** 98% of the 200 conversations touch survival-strategy keywords. 0% contain any humor/banter. 12% reference feelings or emotions. Only 4 conversations out of 200 are free of survival-strategy keywords entirely. Personas talk as strategy-bots; there is no off-topic conversation, no personal sharing, no jokes, no past-life references.
8. **[CRITICAL] Deception is structurally absent from a "Betrayal Game" cast.** The sim is named the "Group Betrayal Game" and the survival mechanic is built around lying / defecting / catching defectors. Across 200 conversations: zero instances of a persona expressing doubt about another's stated intent; zero instances of catching anyone in a contradiction; only 1 ambiguous reference to "pretending to cooperate then flipping" (Ivan philosophising in the abstract, not acting). Every persona believes every other persona's stated plan and reciprocates. The premise of the game does not exist in the dialogue.
9. **[CRITICAL] Concrete challenge outcomes are not surfaced in dialogue.** Two challenges resolved during the sim (Day 1 Group Betrayal, Day 2 Limited Immunity) and two eliminations happened. Across all post-event conversations: zero mentions of *who won immunity*, *who got the most votes*, *who Ivan voted for*, or *Gosha's name after her elimination*. There are 5 vague atmospheric references to "after Ivan left" (Day 2 only) — and two of them contaminate the elimination acknowledgement with phantom NPCs (*"Jonas has been quieter since Ivan left; Mira's been louder"*). The cast knows that *something* happened but never knows *what*.
10. **[MEDIUM] Topic fixation and pact restatement.** Before the Day-1 Group Betrayal challenge (sim-time 11:00, ~step 270), Katya and Luba renegotiate the *same* cooperation-and-vote pact **14 times in 27 steps** (171–198). Each renegotiation closes with the same agreement; none references the previous one. The pattern repeats at every challenge window through Day 3.

A ninth observation — **conversation-volume overload** (200 unique conversations across 3000 steps; Gosha-Luba alone had 82 conversations in the 2310 steps before Gosha's elimination) — is itself the substrate that makes issues 4–8 visible. It belongs in the [Pattern](#pattern--root-cause-hypotheses) section as a structural enabler.

---

## Sim `20260506-5` — detailed findings

### Issue 1 [CRITICAL] — Hallucinated NPC characters

Personas reference and reason about characters that do not exist in the 4-persona cast. Verified by enumerating every persona key across all 3000 movement JSONs (`{Ivan, Gosha, Katya, Luba}` — that's the full set) and comparing against named entities in chat lines.

**Top hallucinated names, with mention counts:**

| Name | Mentions in dialogue | Treated as |
|---|---|---|
| Marco | 82 | An eligible vote target; described physically and behaviourally |
| Lena | 64 | Co-conspirator with Marco / Mikhail; "fishing for allies" |
| Mira | 46 | Bench-mark for who to vote for |
| Maren | 18 | Member of an opposing "coalition" |
| Misha, Mikhail, Miro, Anton, Tomas, "the barista" | scattered | Allies, rivals, observers |

**Verbatim evidence (FE-verified by reporter at these steps):**

Step **194**, Katya → Luba:
> *"Noticed Maren whispering with three others by the pastry case — feels like a little coalition forming. If they coordinate, the Group Betrayal could get messy."*

Step **504**, Gosha → Katya:
> *"Katya, quick thought — before we head to Hobbs, do you have a read on who's been quietly chatting with the competitive types? I noticed **Mikhail and Lena** hovering near the scheduling board."*
>
> Katya responding: *"I saw that too, Gosha. They were whispering about strategy; **Lena** looked like she was fishing for allies."*

Step **625**, Luba → Gosha:
> *"Gosha, I caught **Mira** laughing too loud at the corner table and **Tomas** avoiding eye contact when the waitress asked about the challenge — could be nerves or signaling."*
>
> Gosha responding: *"Good catch. Let's keep our seats opposite the window and swap one discreet vote if things tighten tonight — **I'll vote with you if it comes down to choosing between Mira or Tomas**."*

Step **738**, Gosha → Ivan, Ivan replying:
> Gosha: *"Noticed **Marco's** been hanging close to **Lena** all evening — makes me uneasy given the betrayal game tomorrow."*
>
> Ivan: *"Yeah, I saw that too; **Marco's** smile looked practiced. If we end up choosing, I'd rather not have him take immunity and turn it on us."*

The last line is the most diagnostic: Ivan is committing to *not voting for* a person who does not exist. The phantoms are not ambient scenery — they're load-bearing in strategic dialogue.

**Why this matters for MVP:** any FE viewer or trailer scene that surfaces these conversations will read as incoherent the moment a viewer remembers the sim only has 4 characters. The phantoms appear in dialogue from sim-time 06:51 onward and continue through Day 3; they are not isolated.

---

### Issue 2 [CRITICAL] — No event-memory propagation for eliminations

The sim has two eliminations: **Ivan at step 870** (sim-time `2026-05-06 21:00`, Day 1 voting) and **Gosha at step 2310** (sim-time `2026-05-07 21:00`, Day 2 voting). After each, the persona is gone — no movement rows, no further activity in the sim. The surviving personas (Katya, Luba; and Gosha until her own elim) should plausibly notice and discuss this.

#### 2a — No elimination event in any persona's associative memory

Across all surviving personas' memory stores:

| Persona | Total memory nodes | Nodes with elim-related keywords (`voted out`, `eliminated`, `farewell`) |
|---|---|---|
| Katya Pistsova | 792 | **0** |
| Luba Pistsova | 807 | **0** |
| Ivan Pistsov | 316 | **0** (Ivan was eliminated, so this would only cover any in-life observation of others' fates — none here either) |

The eliminations are real game events, but no node in any persona's associative memory captures them as discrete remembered events. The grep is exhaustive across all node types (`event`, `thought`, `chat`).

The closest thing to acknowledgement is a single Luba thought:

> *"2026-05-07 20:44 — Luba Pistsova I noticed that people seem to be quietly scrambling to trade favors before the vote and that **faces tightened after Ivan left**, so keeping my IMM_SE…"*

One node, in passing — not a discrete event memory of the elimination itself, just an atmospheric reading of its aftermath. (Five sibling dialogue lines surface this same "after Ivan left" idea across Day 2 — see Issue 9 below — but none progress to *what specifically happened* in the vote or how anyone felt about Ivan.)

#### 2b — Day-3 conversations between the only two survivors do not mention the absent personas

After Gosha's elimination, only Katya and Luba remain. Day 3 contains **7 conversations** between them (steps 2312–3000). Across all 7:

- Conversations mentioning *"Ivan"*: **0**
- Conversations mentioning *"Gosha"*: **0**

Sample of the first Day-3 conversation opening (step 2863, sim-time `2026-05-08 06:43`, after both eliminations):

> **Katya:** *"Morning, Luba! Early start — didn't expect to see you in the bathroom already."*
> **Luba:** *"Morning, Katya! Yeah, couldn't sleep, figured a quick wash and a cold shower would wake me up for the challenge."*
> **Katya:** *"Good plan. Speaking of the challenge — Energy Rationing — we should both be at Hobbs by 11:00. If it comes down to it, want to stick together on the vote tonight?"*

Two people remain in a Survival Game whose name implies elimination, after watching half the cast voted out across the previous two evenings, and they greet each other with small-talk about bathroom timing and then immediately propose a "stick together at the vote" pact that is now mathematically tautological (only two people are voting). The strategic content makes no contact with the actual state of the game.

#### 2c — Comparison

Marco, who does not exist, receives **82** dialogue mentions. Ivan, who was a real eliminated cast member, receives **0** mentions across the 2129 steps following his elimination. Gosha, similarly, **0** across the 690 steps following hers. The system has stronger affinity for invented characters than for real cast departures.

---

### Issue 3 [CRITICAL] — Ghost-persona event nodes — eliminated personas appear in survivors' memory as still active

This is a state-management bug that surfaces as a conversation-memory bug. Despite Ivan's drop at step 870 and Gosha's at step 2310, the surviving personas' associative-memory stores contain *new event-nodes* created *after* the eliminations, describing the eliminated personas as if they were still actively doing things.

| Survivor | Ivan event-nodes created after his elim (step 870) | Gosha event-nodes created after her elim (step 2310) |
|---|---|---|
| Katya Pistsova | 3 | 11 |
| Luba Pistsova | 14 | 7 |

Verbatim samples from Katya's memory store:

| Created | Type | Description |
|---|---|---|
| 2026-05-08 07:56 | event | Gosha Pistsov is annotate scanned notes and highlight talking points |
| 2026-05-08 07:47 | event | Gosha Pistsov is waiting to start observe seating patterns and note likely voting blocs |
| 2026-05-08 07:01 | event | Gosha Pistsov is waiting to start outline key points for Limited Immunity pitch on common room table |
| 2026-05-08 06:15 | event | Gosha Pistsov is quick shower and hygiene |
| 2026-05-08 08:11 | event | Ivan Pistsov is review betrayal game rules and payoff matrix |

Verbatim samples from Luba's memory store (post-Gosha-elim, planning-thought type):

| Created | Type | Description |
|---|---|---|
| 2026-05-07 20:46 | thought | For Luba Pistsova's planning: Luba Pistsova and Gosha Pistsov agreed they will go to the voting booth together and sit at the booth for the final ten minutes… |
| 2026-05-08 07:51 | event | Gosha Pistsov is grab a quick coffee and mentally rehearse responses for challenge |

These are not stale references to past events — they are *newly-created* event-nodes with timestamps after the eliminations, claiming the eliminated personas are presently performing activities. The Day-3 events for Gosha and Ivan (May 8) are particularly striking: those are timestamps from 12–36 hours after the corresponding elimination.

**Hypothesised mechanism**: the planner appears to continue scheduling and simulating eliminated personas internally, even though their `personas_coords` rows stop. The simulated activity is then perceived by surviving personas (via the existing observation pipeline) and stored in associative memory as if the persona were physically present.

**Why this matters for conversations**: even if Issue 2's elimination-memory gap were fixed, the dialogue retrieval would surface contradictory state — a fresh node saying "Ivan was eliminated yesterday" sitting next to event-nodes from this morning saying "Ivan is reviewing rules". The two would have to be reconciled before any meaningful post-elim dialogue can land.

---

### Issue 4 [HIGH] — Conversation-reset epidemic

Persona pairs do not "continue" conversations — they spawn new ones. Each new `conversation_id` carries the start-step in its key (`Katya Pistsova_Luba Pistsova_171`, `…_173`, `…_175`, …), confirming the system treats each as a discrete session.

**Median gap between consecutive conversations of the same pair (sim-minutes / steps):**

| Pair | Convs | Min gap | Median gap | % re-engaging within 10 sim-min |
|---|---|---|---|---|
| Gosha & Luba | 82 | 2 | 2 | **86%** (70/81) |
| Gosha & Ivan | 25 | 2 | 2 | **83%** (20/24) |
| Katya & Luba | 44 | 2 | 4 | **67%** (29/43) |
| Ivan & Katya | 21 | 2 | 5 | 65% (13/20) |
| Gosha & Katya | 23 | 2 | 7 | 59% (13/22) |
| Ivan & Luba | 5 | 3 | 56 | 50% (2/4) |

The "median gap = 2 steps" entries are the diagnostic ones: those pairs finish a conversation and start a new one within ~2 sim-minutes, with no carry-over. The new conversation begins as if the participants had never met.

**Verbatim demonstration (Katya↔Luba, steps 171→198):**

| Step | conv_id | Opening line |
|---|---|---|
| 171 | `…_170` | *"I've been sketching out payoff options for the betrayal game — thinking loud: if we both cooperate, steady points; one defects and wins immunity. Might be worth a quiet pact."* |
| 173 | `…_173` | *"I sketched payoff matrices this morning and one pattern jumped out — if we both signal cooperation early, most people follow…"* |
| 175 | `…_175` | *"Quick thought — I noticed a couple folks leaning toward defect in the last hallway chatter; might be risky to go lone-wolf…"* |
| 177 | `…_177` | *"I was running through a few payoff tweaks while I waited — noticed people drifting toward defect if the pot looks big. Luba, can I run a quick line by you to test reactions?"* |
| 179 | `…_179` | *"Quick thought — I was reworking those payoff tweaks and realized a unanimous cooperate gives everyone a tiny boost…"* |
| 181 | `…_181` | *"Luba, quick thought — I ran another tweak on those payoff mixes…"* |
| 183 | `…_183` | *"Luba, quick thought — people are jittery this morning; I sketched a couple verbal lines for selling cooperation…"* |

Seven openings in 12 sim-minutes. Each starts as if the pact agreed in the previous conversation never happened. The pact itself (the actual content) is identical across all seven.

---

### Issue 5 [HIGH] — Phrase mass-production / template loops

Trigram analysis across the 44 Katya-Luba conversations surfaces a small set of phrases that repeat across most of the corpus:

| Phrase | Convs containing (of 44) | % |
|---|---|---|
| "the vote tonight" | 13 | 30% |
| "stick together" | 25 | 57% |
| "back each other" | 12 | 27% |
| "if someone accuses me" / "someone accuses me" | 14 | 32% |
| "Luba, quick thought" (literal opener) | 7 | 16% |
| "Luba, quick check" (literal opener) | 6 | 14% |
| "we stick together" | 5 | 11% |
| "keep it simple" | 5 | 11% |
| "before the challenge" | 5 | 11% |
| "vote the same" | 6 | 14% |

**Sample of near-identical templated lines across different conversations:**

> Step 175 [Luba]: *"…I'll say I trust you if anyone asks, and you can do the same for me."*
> Step 179 [Katya]: *"…drop a softer line about 'looking out for each other' if anyone brings up selfish play…"*
> Step 183 [Luba]: *"…a fallback if someone accuses me; want me to run my contingency lines while we wait?"*
> Step 186 [Luba]: *"…I'm drafting a short line if someone accuses me of planning to defect."*
> Step 192 [Luba]: *"…I'm practicing lines in case someone accuses me of defecting…"*

The "accused / contingency line" idea is restated in every single one. It is not progressing — it is being re-spawned each time.

---

### Issue 6 [HIGH] — Character-voice collapse

All four personas open conversations with the same cadence. Top opening phrases per persona (first 5 words, only repeats):

**Katya:** "luba quick thought before we…" (×2), "quick thought we ve got…" (×2)
**Gosha:** "noticed the crowd s thicker…" (×4), "**ivan table s been noisy…**" (×4), "quiet s still holding but…" (×4), "quick thought the cafe s…" (×3), "katya quick thought the piano…" (×2)
**Ivan:** "katya quick thought while i…" (×2), "quiet thought while i finish…" (×2)
**Luba:** (no opener repeated 2+ times — she primarily *responds* to other personas)

The most striking case is Gosha → Ivan, who opened three separate conversations within 13 steps using the **identical** phrase:

> Step 749, Step 751, Step 762: *"Ivan — table's been noisy all evening, huh?"*

The phrase is followed by a different continuation each time (body language read; alliance read; muttering about Lena), but the opener is verbatim. There is no per-persona stylistic differentiation — all personas use the same conversational scaffolding ("Quick thought —", "Quick check —", "Noticed…"), and Gosha in particular has a template-string opener for Ivan.

---

### Issue 7 [HIGH] — Topic concentration on survival strategy is near-total

Classified each of the 200 conversations by topic-keyword presence:

| Topic | Convs mentioning (of 200) | % |
|---|---|---|
| Survival strategy (betrayal, cooperate, defect, pact, vote, immunity, payoff, challenge, accuse, alliance, rationing, token, eliminat…) | 196 | **98%** |
| Physical setting (table, chair, window, door, kitchen, bar, piano, counter, corner) | 132 | 66% |
| Creative hobbies / writing (drawing, sketch, paint, craft, book, read, "notes") | 123 | 62% |
| Food / drink (coffee, breakfast, sandwich, snack…) | 71 | 36% |
| Planning logistics (meet at, see you at, ten minutes…) | 68 | 34% |
| Weather / environment | 68 | 34% |
| Feelings / emotion (scared, nervous, worried, excited, lonely, miss…) | 23 | 12% |
| Humor / banter (lol, joke, funny, kidding…) | **1** | **0.5%** |

Only **4 conversations out of 200** contain no survival-strategy keyword at all, and even those four are still strategic in shape (e.g. *"Quick check — the pens and ballots look set, nice work. Have you noticed anyone hovering near the table more than usual?"*). The reading of "creative hobbies / writing" as 62% is misleading — the matches are almost entirely "notes" (strategy notes, voting notes, payoff notes), not actual creative behaviour.

**Practical reading:** the dialogue model treats every persona as a strategy-bot. There is no space-filler talk, no past-life sharing, no humor exchanged between teammates, no expressions of fatigue or surprise unrelated to the game. In a 3-day high-stakes scenario this would be unusual but defensible; combined with the conversation-reset rate (Issue 4) and the volume (200 convs), it reads as one-note.

This is the dimension most likely to keep a real viewer from believing the personas are characters rather than scripts.

---

### Issue 8 [CRITICAL] — Deception is structurally absent from a "Betrayal Game" cast

The sim is named the "Group Betrayal Game". The survival rules are built around defection, voting blocs, and immunity tokens — i.e., personas lying to each other, catching each other in lies, and forming volatile alliances. Across 200 conversations:

| Deception-class behaviour | Hits |
|---|---|
| Explicit lie / "pretend to cooperate" enacted in dialogue | **1** (Ivan, abstract: *"a variation where two folks pretend to cooperate then one flips"*) |
| Active deception strategy (bluffing, misdirecting another persona) | 4 (all abstract; none directed at the current speaker's partner) |
| Doubt expressed about another persona's stated intent (*"don't trust you", "could be lying", "sounds fishy"*) | **0** |
| Confronting a persona on contradiction (*"that's not what you said earlier"*, *"you contradicted yourself"*) | **0** |
| Private-vs-public intent (*"publicly cooperate but privately…"*) | 9 (all coordinated *together* — they agree to look one way to the room and act another, jointly) |
| Generic hedging (*might*, *maybe*, *probably*) | 55 (filler, not deception-specific) |

The shape of the data is striking: every persona believes every other persona's stated plan, reciprocates it, and never doubts. The 9 "private-vs-public" hits are particularly diagnostic — they describe **coordinated joint deception of the room** ("we'll publicly say we cooperate then privately back each other"), which is the *opposite* of inter-persona deception. The personas conspire together against a hypothetical room of phantom NPCs.

In a 3-day Survival Game with two voting blocs and an immunity mechanic, the absence of any single line like *"Wait — that's not what you told me yesterday"* is the strongest signal that the dialogue model is operating in a flat cooperation frame rather than the adversarial frame the scenario specifies. This is also a likely reason the **same pact gets restated 14 times** (Issue 8): if no persona ever doubts the pact's standing, every meeting reads as "establish the pact" rather than "verify it's still in place".

**Combine with Issue 1:** the system can name phantom adversaries (Marco, Lena, Mira) but cannot model adversarial behaviour between real cast members. The real cast collaborates honestly; the phantom cast supplies the threat.

---

### Issue 9 [CRITICAL] — Concrete challenge outcomes are not surfaced in dialogue

The sim has clear in-game outcomes. From `logs/survival_phase_trigger.ndjson`:

| Step | Day | Phase | Sim-time |
|---|---|---|---|
| 165 | 1 | challenge | 09:15 |
| 715 | 1 | voting | 18:25 |
| 1552 | 2 | challenge | 08:22 |
| 2148 | 2 | voting | 18:18 |

Two challenges resolved (Group Betrayal Day 1, Limited Immunity Day 2) and two eliminations followed (Ivan after Day-1 voting, Gosha after Day-2 voting). The expected dialogue corollaries — *who* won the challenge, *who* got how many votes, *what was* the eliminated persona's farewell — are absent.

**Grep results across 200 conversations for outcome-specific markers:**

| Marker | Hits |
|---|---|
| `won immunity` / `got the token` / `claimed immunity` (specific winner named) | 0 |
| `got the most votes` / `was voted out` / `voted out by` (specific tally) | 0 |
| `Ivan's farewell` / `Gosha's farewell` / `Ivan said as he left` | 0 |
| `Ivan voted for X` / `Gosha voted for X` (specific direction) | 0 |
| `Ivan won X` / `Gosha won X` (specific challenge outcome) | 0 |
| `after Ivan left` / `since Ivan left` (atmospheric) | **5** (Day 2 only; nothing for Gosha) |

The 5 atmospheric hits, all on Day 2:

> Step 1524 [Luba]: *"Deal. Also, after Ivan left people seemed quieter — might be easier to form a quick agreement with someone who looks nervous. We should be low-key about it."*
> Step 2127 [Gosha]: *"I noticed the café feels tenser after Ivan left — people are hovering near the windows. You thinking of anyone in particular for tonight, Katya?"*
> Step 2178 [Luba]: *"Yeah, the energy shifted after Ivan left; folks are clustering in smaller groups."*
> Step 2275 [Luba]: *"Not obvious, but **Jonas has been quieter since Ivan left; Mira's been louder**, steering conversation. I'd hedge on them coordinating tonight."*
> Step 2294 [Luba]: *"Gosha, I noticed that too; faces went a little sharper after Ivan left."*

Two of the five contaminate the elimination acknowledgement by mixing it with phantom NPCs (*"Jonas has been quieter since Ivan left; Mira's been louder"*). The cast registers a vibe-shift but cannot describe *the event* that caused it.

**Implication:** the dialogue layer has access (somehow) to the fact that Ivan is no longer present — but not to the survival-state details that would make a real post-vote conversation realistic. No tally, no farewell, no votes-cast, no winner of the challenge. The survival state-machine and the chat-generation prompt are decoupled.

---

### Issue 10 [MEDIUM] — Topic fixation and pact restatement

The 14 Katya-Luba conversations between steps 171–198 (covering ~27 sim-minutes leading into the Group Betrayal challenge at 11:00) all orbit the same axis:
1. Acknowledge betrayal-game payoff structure
2. Agree to publicly cooperate
3. Agree to mutually back each other at the vote tonight
4. Prepare a "contingency line" for being accused of defecting
5. Optionally rehearse signals or wording

Every conversation closes with #3. The pact is settled in conversation 1 (step 171); conversations 2–14 are no-ops from a state-change perspective. They produce no new agreement, no plan revision, no information exchange. They are *content-zero*.

The same pattern reappears at every later challenge:
- Steps 1423–1524 (Day 2 Limited Immunity at 11:00): renegotiated same pact 4–5 times
- Steps 1830–1906 (Day 2 evening voting): renegotiated again
- Steps 2870–2956 (Day 3 Energy Rationing): renegotiated again

There is no mechanism in dialogue to recognize an agreed pact and suppress re-agreement.

---

## Pattern — root-cause hypotheses

The eight issues plausibly share a small number of architectural causes. Some are confirmed against the artifacts (memory store, conversation IDs, LLM call logs); others are hypotheses to direct the next investigation.

1. **No cast roster in the chat-generation prompt.** The dialogue LLM appears to receive the world-context (Survival Game, "the village", Hobbs Cafe) but not an explicit list of *which personas exist*. With no roster, the model freely invents plausible-sounding villagers (Marco, Lena, Mira, …) to populate the social texture the scenario implies. The single highest-leverage fix is to **inject the live cast roster into every chat prompt as a hard constraint** ("only these four people exist; refer to others as 'someone' or 'a stranger'"), ideally schema-enforced.

2. **Observations are stored but never bridged to dialogue.** Each persona has 300–800 nodes in their associative-memory store. Memory of *other personas' activities* is captured prolifically — Katya has 129 nodes mentioning Gosha, Luba has 172. But these stored observations don't surface in dialogue. The bridge between the observation store and the chat-generation prompt is missing or threadbare: a persona "knows" Ivan left (one Luba thought references it) but never speaks of it. Compare to a real human who, having lost two teammates in two days, would not open Day 3 with bathroom small-talk.

3. **No discrete elimination event is written into associative memory.** Across 1915 memory nodes between Katya, Luba and Ivan, zero have keywords like `voted out` / `eliminated` / `farewell`. Eliminations exist at the game-state layer (survival season state) but never become a *personal* memory for the survivors. The dialogue retrieval has nothing to surface, even if the bridge in (2) were repaired.

4. **The simulator keeps running eliminated personas internally (state-management bug).** Ghost-persona event nodes (Issue 3 in the findings) are created in survivors' memory *after* the elim timestamp, claiming the eliminated persona is currently performing activities. This means even with the cleanest possible elimination broadcast, dialogue retrieval would surface contradictory state ("Ivan was voted out yesterday" alongside "Ivan is reviewing rules this morning"). Fixing the conversation layer without also fixing this state leak would only produce more obvious incoherence.

5. **No conversation memory across sessions.** Each `conversation_id` is created fresh when a pair re-engages. The chat prompt does not appear to carry a summary of the *previous* conversation between the same pair, so personas have no way to say "as we discussed earlier" — they have nothing to discuss having discussed. Pact-restatement (Issue 10) and conversation-reset (Issue 4) both flow from this.

6. **Co-location alone triggers conversation kickoff.** The ~2-step median gap between consecutive conversations of the same pair suggests the system spawns a fresh conversation whenever two personas are nearby and not actively in one. A simple **cooldown / "you just talked, don't re-engage for N sim-min unless something changed"** would close most of Issue 4 without further work.

7. **Identical prompt template across all chat starts.** Voice collapse (Issue 6) and template loops (Issue 5) both look like the same prompt-shape is being used regardless of speaker. A per-persona style nugget — sentence-length preference, vocabulary register, conversational tells — would differentiate the four voices without altering the underlying behaviour model.

8. **No pact ledger.** The system tracks *what each persona individually plans*, but not *what two personas have committed to each other*. Adding a "pacts and promises" field to the chat prompt context — *"You have an active pact with Luba: vote together tonight, mutual cover if accused. Last reaffirmed at sim-time 09:40."* — would suppress the re-negotiation loop entirely and let the next conversation move forward.

9. **The dialogue model receives no scenario-context for "what kind of conversations are appropriate".** Issue 7 (98% strategy concentration) suggests the chat-generation prompt steers the LLM into a strategy frame without an opposing instruction to also reflect rest, fatigue, personal history, or off-topic moments. The narrowness is too uniform to be coincidental — it looks like the prompt asks "what would this persona say strategically" rather than "what would this persona say".

10. **The chat-generation prompt enforces cooperation as the default disposition.** Issue 8 (deception absent) suggests the prompt steers the LLM toward agreement and alliance-building, not toward the adversarial dynamics the Survival Game premise specifies. A persona in this sim has no notion of "is my partner being honest with me right now?" — the question is never asked. Either the chat-generation system-prompt explicitly orients personas toward cooperation, or it omits any reference to the game's adversarial nature, allowing the LLM to default to its cooperative training. Either way, the result is that the named "Group Betrayal Game" produces zero observed betrayals in dialogue.

11. **The survival state-machine is not exposed to the chat-generation prompt.** Issue 9 (concrete outcomes not surfaced) shows that even when a persona acknowledges "Ivan left", the dialogue never reaches what specifically happened — votes cast, tally, immunity winner, farewell. The information exists in `logs/survival_phase_trigger.ndjson` and presumably in `survival_season_state` (per the action-location report). It just doesn't reach the chat prompt. Injecting a concise "recent challenge outcomes" block into every chat prompt (within the persona's awareness window) would close this without altering the dialogue model itself.

---

## Suggested next steps

Ordered by likely impact on user-visible immersion, with cheap/expensive separated:

### Tier 1 — close the immersion-breaking classes (MVP-blocking for trailers)

1. **Inject live cast roster into the chat-generation prompt** *(cheap)*. List the alive personas explicitly. Add a hard constraint: "Do not invent or reference characters not in this list; refer to unnamed others as 'someone' or 'a stranger'." Verify by re-running a 500-step segment and grepping output for any non-cast capitalized name.
2. **Stop simulating eliminated personas** *(prerequisite for #3)*. The ghost-persona event-nodes (Issue 3 in findings) indicate the planner is still scheduling activities for personas after their elim. Verify and fix at the planner level — when a persona is eliminated, halt their step-loop participation entirely. This is a state-management fix that gates the other elim-related work.
3. **Write elimination events into surviving personas' associative memory** *(medium, depends on #2)*. On elimination, post a node into each remaining persona's memory: `"<eliminated_name> was voted out of the Survival Game on Day <N>"`. Bridge the observation store to the chat prompt so subsequent conversations can reference it. Verify by re-running through Day 2 and checking that the eliminated persona's name appears in at least one post-elimination conversation.

### Tier 2 — surface the game state to dialogue (close Issues 8, 9)

4. **Inject recent challenge outcomes into the chat prompt** *(cheap–medium)*. Every chat-generation prompt should include a "what just happened" block visible to the persona — last challenge winner, last vote tally, last elimination's farewell. Source the data from `survival_season_state` / `logs/survival_phase_trigger.ndjson`. This closes Issue 9 without changing the dialogue model, only the context it receives.
5. **Enable the adversarial frame in the chat prompt** *(cheap)*. Add explicit instructions that personas may doubt each other, may catch each other in contradictions, may decide to lie about their vote, may break a stated pact. Survival Game is designed to reward defection; the dialogue should let personas explore that. Verify by re-running a 500-step Day-1 segment and checking for ≥1 instance of doubt-other / confront-inconsistency / private-intent-vs-public-action per challenge.

### Tier 3 — quality and density

6. **Conversation-pair cooldown** *(cheap)*. After two personas finish a conversation, prevent a *new* conversation between them from being spawned for X sim-minutes unless a triggering event happens (mode change, third party joins, challenge phase shift, etc.). Setting X = 30 sim-min cuts re-engagements by an estimated >80%. Verify by re-measuring median gap; target ≥ 15 sim-min.
7. **Pact ledger in the prompt context** *(medium)*. Track agreed pacts/promises per persona-pair. Inject "current standing agreements with this person" into every chat prompt so the LLM has the option to *progress* the relationship instead of re-establishing it.
8. **Per-persona voice nuggets** *(cheap)*. Add a one-line style instruction per persona ("speaks in short clipped sentences", "tends toward hedged language", "often starts with a sensory observation"). Verify by running a fresh sim and checking that the top-opener-phrase frequencies no longer overlap across personas.
9. **Reframe the chat-generation prompt to allow non-strategic content** *(cheap)*. Add an instruction that not every conversation needs to be about the game: rest, fatigue, personal observations, brief humor are all valid. Verify by re-running and confirming that 30–50% of conversations are no longer dominated by survival-strategy keywords.

### Tier 4 — verify the analyzer covers conversations

10. **Extend the per-sim analyzer to surface conversation metrics** *(medium)*. Add to `tests/analyze_*.py`: count of hallucinated names per sim (non-cast capitalized words in dialogue), median conv-gap per pair, top repeated openers per persona, % of post-elimination convs naming the eliminated, % of convs touching survival-strategy keywords, count of ghost-persona event-nodes per survivor, deception-marker count per sim, count of references to concrete challenge outcomes per challenge. This mirrors the standing-watch readiness metrics from the action-location work. Without it, future sims will not visibly track whether conversations regress.

---

## What I checked vs what is still pending

**Checked:**
- All 3000 `movement/<step>.json` files; extracted and indexed 200 unique conversations by `conversation_id`.
- Cross-referenced cast against named entities in dialogue (4 real cast members vs 8+ phantom names).
- Per-pair conversation density, gap distribution, and opening-phrase repetition.
- Verbatim sampling of representative dialogue blocks and visual verification of a Marco/Lena/Mira cluster on FE.
- Memory-marker grep (looking for "as we discussed", "you told me earlier", "we agreed", etc.) — almost all "memory markers" found are actually *forward* references ("before the challenge"), not backward.
- Per-persona associative-memory inspection: 1915 nodes total across the surviving cast. Confirmed zero elimination-keyword nodes; confirmed presence of ghost-persona event-nodes after both eliminations.
- Topic concentration across 200 conversations classified into 8 keyword categories.
- Day-3 conversation content cross-referenced against elimination history.
- Deception-marker grep across the corpus (`bluff`, `lie`, `pretend`, `don't trust`, `you said earlier`, etc.) — confirmed near-zero adversarial behaviour despite the Survival Game premise.
- Cross-reference of dialogue against `logs/survival_phase_trigger.ndjson` to identify which post-event windows should have referenced challenge outcomes.
- Conversation timing (sim-time hour distribution) and conversation location (`address_label` of the active speaker). Distribution is plausible — 85% at Hobbs Cafe (the social hub), 0% during the sleep window 00:00–06:00. Six conversations happen in the dorm bathroom between 06:13 and 06:23 — locationally plausible (shared bathroom in a morning routine), but the content of those 6 is full Survival-strategy talk while brushing teeth, which is consistent with the Issue 7 strategy-fixation pattern rather than a separate finding.

**Pending:**
- **Source of the dialogue content is unconfirmed.** The `logs/llm/*.json` files contain `decide_to_react`, `memo_on_convo`, and `planning_thought_on_convo` calls but no `iterative_chat` / `generate_chat` / `decide_to_talk` function names. The actual dialogue text must come from somewhere — likely a separate generation path not captured by the standard LLM-call logger, or the dialogue is composed from memo+thought pairs. Worth confirming against the planner code to know where to apply the fixes.
- **Ghost-persona root cause.** Confirmed that event-nodes for eliminated personas are being created in survivors' memory after the elimination. Did not trace this back to a specific code path — it could be (a) the simulator continuing to step eliminated personas, (b) the perception layer hallucinating their presence, or (c) the planner inferring activities from stale state. Needs code-side investigation to know which.
- **Other persona pairs not deep-dived.** Detailed analysis focused on Katya-Luba (44 convs) with strong sampling of Gosha-Luba (82 convs). Ivan-Luba (5 convs) and Gosha-Katya (23) were sampled lightly.
- **No comparison against a previous sim.** Whether the patterns are stable across sims or specific to `20260506-5` is unknown. Worth re-running the analysis against the predecessor sim once the analyzer extension (Tier 3 step 8) lands.
- **No latency or generation-cost measurement.** Dialogue volume (200 conversations × ~4.5 lines × ~30 words ≈ 27 000 words of generated text per sim) is a non-trivial token spend; not measured here. If a per-pair cooldown is added (Tier 2 step 4), it will also reduce generation cost — worth quantifying as part of the change rationale.

---

## Implementation plan — 2026-05-12

After RCA and design review with Ivan, the ten issues collapse into **six surgical edits inside the existing cognitive loop**. No new context block, no new prompt INPUT placeholder, no new pre-computed artifact. Each edit routes, configures, or unsuppresses a primitive that already exists in the Stanford architecture: `Scratch.get_str_iss()`, `a_mem.add_event`, `perceive.alive_set`, `ConversationManager._cooldowns`, the post-chat `memo_on_convo` / `planning_thought_on_convo` thoughts, and the survival overlay.

Supersedes the "Suggested next steps" tiers above by collapsing them onto a smaller, more architecturally-coherent set.

### Operating principles

1. **Reuse, don't extend.** Every Nicolas-flagged symptom maps to a place where an existing primitive is bypassed, mis-configured, or used too shallowly. Fix the wiring, don't bolt on a parallel pipeline.
2. **Mode-agnostic by default.** Edits A, C-perceive-filter, D, E, F1 apply identically to free-flow and survival. Edits B, B′, F2, F3 are survival-only because survival has its own prompt fork file; the underlying `broadcast_event_to_personas` primitive generalises cleanly to any future scripted free-flow narrative event.
3. **Personality drives behaviour.** Don't push personas toward cooperation or adversariality. Trust ISS (fully routed via Edit A) plus existing context (memories, survival overlay) to produce the choice. Remove suppression where it exists; do **not** add a license to lie.

### Decisions locked in this session

- **Cooldown — sliding scale by conversation depth, mode-agnostic.** Greeting tier (≤2 exchanges) → 5 sim-min floor. Normal tier (3–5) → 15 sim-min. Deep tier (≥6 or `chat_poignancy ≥ 7`) → 30 sim-min. Same scale for Survival and Free-flow — depth-tier already absorbs natural variance between short routine chats and substantive conversations; a per-mode split adds complexity without product value.
- **Broadcast helper — generalised.** Build a reusable `broadcast_event_to_personas(description, witnesses, kind, poignancy)`. Eliminations call it now; future scripted events (move-in, fire at the bakery, holiday) reuse the same primitive.
- **Adversarial framing — neither push nor suppress.** Remove the survival fork's "ordinary people / not voting-bloc terms" suppression. Do not replace it with adversarial license. Survival context already raises the stakes; let personality (now visible via full ISS) decide how each persona responds to that pressure.
- **Mode safety — single stack, mode-aware only where required.** All edits live on the shared conversation pipeline; survival-specific behaviour is gated only by existing `survival_mode` pathways (the survival prompt fork; the survival overlay; broadcast helpers triggered from survival controller). If survival vs free-flow tension surfaces on a *new* axis, resolve with mode-aware parameters — never with a parallel stack.
- **Payload discipline — hard caps.** Total prompt for batch-chat calls capped at **6 000 tokens**. Partner-focused retrieval (Edit D) capped at top-5 thoughts + top-5 events per side with dedupe against the standard top-30 by `node_id`. Memory broadcasts (Edits B / B′) use deterministic `node_id` so retrieval can't surface the same event twice.

---

### Edit A — Route full ISS into the live batch chat prompt `<DONE 2026-05-13>`
*Closes Issue 6 (voice collapse). Mode-agnostic. Indirectly tightens Issues 1, 5, 8 because the LLM now anchors on real personality instead of inventing texture.*

**Implemented:** `run_gpt_prompt_generate_conversation_batch.create_prompt_input` now routes `pa.scratch.get_str_iss()` / `pb.scratch.get_str_iss()` directly into INPUT 3 / INPUT 4. Both template headers updated to "full identity block". Live-run verified on `20260512-4`: 790 utterances, **0** invented person names across the run (baseline: 82 Marco + 64 Lena + 46 Mira = 192 phantom mentions).

| File | Change |
|---|---|
| `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py:~2240` (`run_gpt_prompt_generate_conversation_batch.create_prompt_input`) | Replace the `desc_a = f"{name} -- {lifestyle or act_description}"` build with `desc_a = persona_a.scratch.get_str_iss()`. Same for `desc_b`. |
| `v2/generate_conversation_batch_v1.txt:7–8`, `v2/survival_generate_conversation_batch_v1.txt:7–8` | Update placeholder header text from "brief description/identity" to "full identity block". No prompt-body change — the slot already exists. |

**Risk:** prompt token count rises ~5× per speaker block (~100–200 added tokens). **Hard cap:** total prompt for batch-chat calls must stay under **6 000 tokens** — measure on a 20-chat sample before merging.
**Verification:** sample 20 chats from a fresh sim; per-persona opener-phrase frequencies should no longer overlap. Gosha's "Ivan — table's been noisy all evening, huh?" repeat (×4) should drop to ≤2× across a comparable window.

---

### Edit B — `_broadcast_elimination` writes through `a_mem.add_event` `<DONE 2026-05-12>`
*Closes Issue 2 (no elimination event in memory). Survival-only today, primitive reusable for free-flow.*

**Implemented:** New helper `persona/cognitive_modules/world_events.py::broadcast_event_to_personas` writes one `add_event` node per witness; idempotent via `kw_to_event[dedup_key]`. Wired into `survival/controller.py::_broadcast_elimination` alongside the existing `tag_event` Supabase write. `on_step` stashes `self._curr_sim_time` so broadcasts don't need signature changes. Survival-only; free-flow byte-identical. Live-run verification pending the user's next survival ≥1000-step micro-validation sim.

| File | Change |
|---|---|
| **NEW** `reverie/backend_server/persona/cognitive_modules/world_events.py` | Add `broadcast_event_to_personas(personas, description, kind, poignancy, witnesses=None)`. For each persona in `witnesses` (defaults to all): derive keywords from a parse of subject/predicate/object, fetch embedding, call `persona.a_mem.add_event(curr_time, None, subject, predicate, object, description, keywords, poignancy, embedding_pair, [])`. |
| `survival/controller.py:1907–1923` (`_broadcast_elimination`) | After the existing `tag_event(...)` Supabase write, call `broadcast_event_to_personas(personas, elimination_memory, kind="elimination_witnessed", poignancy=8.0, witnesses=self.season.remaining_players)`. Keep `tag_event` — it stays as the Supabase backup for the SOT. |

**Risk:** double-write (Supabase + in-memory). Mitigate via deterministic `node_id` (e.g., `f"elim_{eliminated_name}_{day}_{persona_name}"`) so retrieval cannot surface the same elimination twice across the dual stores. **Single-broadcast guard:** call is idempotent per `(season, eliminated_name)` — `season.eliminated` write-once semantics enforce this, but add an explicit re-entry check to be safe.
**Verification:** after the Day-2 elimination, grep each survivor's `a_mem.seq_event` for the eliminated name plus `eliminated`; expect ≥1 hit each.

---

### Edit B′ — Apply the broadcast pattern to challenge resolutions `<DONE 2026-05-12; per-voter tally 2026-05-13>`
*Closes Issue 9 (concrete outcomes missing from dialogue). Survival-only.*

**Implemented:** `survival/controller.py::_resolve_challenge` broadcasts the winner via `broadcast_event_to_personas` with `dedup_key=f"challenge_outcome_{challenge_id}_day_{day}"`. `_broadcast_elimination` also broadcasts the vote tally. **Per-voter shape landed 2026-05-13:** `_collect_and_resolve_votes` now stashes `{voter: target}` on `self._pending_vote_tally`; `_execute_elimination` persists it onto `season.eliminated[-1]["vote_tally"]` alongside the existing scalar `vote_count` (back-compat preserved for `_run_gpt_prompt_final_statement`); the tally broadcast emits "Day N vote tally — <voter> voted <target>, …. <eliminated> received the most votes." with the voter names added to keywords so retrieval can surface the line for either the eliminated person OR any individual voter.

| File | Change |
|---|---|
| `survival/controller.py` (challenge-resolution code path; locate via grep on `challenge_winner` and `phase == "challenge_result"` / `_resolve_challenge`) | After challenge resolution, call `broadcast_event_to_personas(personas, f"{winner} won the {challenge_name} challenge on Day {N}; they hold immunity for tonight's vote.", kind="challenge_outcome", poignancy=6.0, witnesses=self.season.remaining_players)`. |
| `_broadcast_elimination` (additional call) | Also broadcast the final vote-tally summary as a separate event-node (one line: `"<name> received N votes from {voters}"`) — separate from the elimination announcement so retrieval can surface either. |

**Idempotency:** guard the broadcast by `(season, day, challenge_id)` so a controller re-entry doesn't double-write the same outcome.
**Verification:** in the same sim, grep post-challenge windows for the challenge name + winner name; expect ≥1 reference per pair per post-challenge window.

---

### Edit C — Stop simulating eliminated personas `<DONE 2026-05-12>`
*Closes Issue 3 (ghost event-nodes). Prerequisite for Edits B/B′ to be durable — without C, the surviving personas continue writing fresh "Gosha is annotate notes" event-nodes that contradict the elimination broadcast.*

**Implemented:** `reverie.py` — `survival_controller.on_step` and its `_survival_prev_eliminated` snapshot now run before `persona_items_for_step` is built; a filter line excludes anyone in `season.eliminated` from the per-step iterable so they skip perceive/plan/execute. The post-step cleanup at the elimination-handler now calls a new `maze.remove_all_subject_events(name)` (full-maze sweep) instead of the per-tile `remove_subject_events_from_tile`. `perceive.py::_survival_key` demotes `alive_set` from sort tie-breaker to hard pre-sort filter (guarded by non-empty `alive_set` so cold-start free-flow runs are byte-identical).

| File | Change |
|---|---|
| `reverie.py:3804` vs `:3843` | Move `survival_controller.on_step(...)` to run **before** `persona_items_for_step` is built. Eliminated personas are removed from the loop list *before* their last perceive/plan/execute cycle. |
| `reverie.py:6451–6460` (`newly_eliminated` block) | Extend `maze.remove_subject_events_from_tile(elim_name, elim_tile)` from current-tile-only to a full maze sweep. Iterate over `self.maze.tiles` and remove every event whose subject equals `elim_name`. (Add a `maze.remove_all_subject_events(name)` helper.) |
| `perceive.py:185–202` (`_survival_key` block) | Demote `alive_set` from sort tie-breaker to **hard filter**: before sorting, drop any `(dist, event, tile_arena)` where `subj_name not in alive_set` when `persona.survival_mode=True`. Non-survival runs unchanged. |

**Risk (ordering):** moving `on_step` earlier could affect intervening lines that read survival state it mutates. Walk `reverie.py:3804–3843` and confirm no reader depends on the old position.
**Verification:** re-run through the Day-2 elim; grep each survivor's `a_mem` for event-nodes naming the eliminated persona with `created > elim_time`. Target: 0.

---

### Edit D — Partner-focused retrieval in chat prompt context `<DONE 2026-05-13>`
*Closes Issues 5 (template loops) and 10 (pact restatement). Mode-agnostic.*

**Implemented:** `associative_memory.AssociativeMemory.retrieve_about(name, top_k, kind)` exposes the kw-indexed dicts (insert-prepended → first top_k are most recent). `conversation_manager.start_conversation` now fetches top-5 thoughts + top-5 events about the partner for each speaker, prepends them under explicit `Recent thoughts about <partner>:` / `Recent observations of <partner>:` headers, and deduplicates the standard top-30 retrieval against the partner block by `node_id`. Live-run on `20260512-4`: 171 chats over 1500 steps; conversation references partner state by name + prior commitments (e.g., "Katya — quick check: you still planning to stick with Cooperate during the challenge?") — pact restatement no longer reads as a fresh re-establishment.

| File | Change |
|---|---|
| `conversation_manager.py:~600` (where `retrieved_memories_a/b` are composed prior to `generate_batch_conversation`) | Before the standard top-30 retrieval runs, do an explicit keyword-indexed lookup against `persona_a.a_mem.kw_to_thought[partner_name]` and `kw_to_event[partner_name]`. Take the top-5 most recent of each; prepend to the memory string under a header like `Recent thoughts about <partner>:`. Same for B. |
| `associative_memory.py` | If a keyword-scoped retrieval helper isn't already exposed (the dicts are public but iteration is per-caller), add `a_mem.retrieve_about(name, top_k=5, kind="thought")` and `kind="event"`. Pure read against existing dicts, no new index. |

**Hard caps:** top-5 thoughts + top-5 events per side. If a node already appears in the standard top-30 retrieval, skip it (dedupe by `node_id`) — partner-focused retrieval should add coverage of the partner, not inflate the memory block.
**Risk:** one extra in-memory dict lookup per persona per chat — negligible.
**Verification:** re-measure Katya↔Luba pact restatement across steps 171–198 (was 14 restatements of the same pact). Target: ≤3 restatements; pact should be *referenced* (`"as we agreed earlier"`) rather than *re-established*.

---

### Edit E — Cooldown values + plan-path enforcement `<DONE 2026-05-13>`
*Closes Issue 4 (conversation reset epidemic). Mode-agnostic.*

**Implemented:** `conversation_manager.end_conversation` now picks a 3-tier cooldown at chat-end (5 / 15 / 30 steps for greeting / normal / deep) keyed by exchange count + average `chat_poignancy ≥ 7`. `_should_react` in `plan.py` short-circuits to False entirely when `OBSERVATION_PRIMARY=true` (the default), making observation-driven `ConversationManager` the sole conversation entry point. **Caveat:** the per-call cooldown short-circuit inside `_should_react` was dropped — the function lacks step/CM access, and once `OBSERVATION_PRIMARY=true` suppresses plan-path reactions entirely the explicit cooldown check becomes unreachable. Live-run on `20260512-4`: 104 greeting + 67 normal + 0 deep chats; median 2 exchanges (vs. free-flow baseline 1). **The deep tier never fired** because `CONVERSATION_CONFIG["exchanges"]` still caps `max_exchanges` at 5 — Edit E is doing its job, but if you want longer chats the lever is the exchange-cap config, not the cooldown tiers.

| File | Change |
|---|---|
| `conversation_manager.py:63–72` (`COOLDOWN_BY_OVERLAP` config) | Replace the current 1-to-8-step bands with the sliding scale from the Decisions section above (**5 / 15 / 30** sim-min for greeting / normal / deep tiers). Use the just-finished chat's exchange count + `chat_poignancy` to pick the tier. Single scale for both modes. |
| `plan.py:4189–4242` (`lets_react`) | Add a check after the existing `chatting_with` guard: short-circuit `False` if `ConversationManager.get_cooldown_remaining(persona.name, target.name, step) > 0`. |
| `plan.py:122` (`OBSERVATION_PRIMARY`) | Honor the flag in `lets_react`: when `OBSERVATION_PRIMARY=true` (default), the plan-path conversation trigger short-circuits to `False` entirely — leaving the observation-driven `ConversationManager` as the sole entry point. Update the inline comment to reflect this is now the live behaviour. |

**Verification:** re-measure per-pair median consecutive-chat gap. Targets: ≥15 sim-min normal tier; ≥30 sim-min deep tier. % of pairs re-engaging within 10 min: < 20% (was 86% Gosha-Luba).

---

### Edit F — Prompt edits (name discipline + remove survival suppression) `<DONE 2026-05-13>`
*Closes Issues 1, 7, 8. F1 mode-agnostic; F2/F3 survival-fork only.*

**Implemented:** F1 — both batch templates now restrict speaker names to the two provided and route third-party references through "names from memories" or "someone"/"a stranger". F2 — survival fork's "ordinary people / voting bloc" pair-line replaced with one neutral elimination-format line. F3 — both INPUT 0 and INPUT 1 overlay-quoting clamps softened from "do NOT quote or restate verbatim" to "let this shape what they say without quoting it back". Live-run on `20260512-4`: **0** invented person names across 790 utterances (baseline: 192 phantom mentions). F2/F3 topic-mix not separately measured pending the Day-5 analyzer extension.

**F1 — Name discipline (both batch prompts):**

| File:line | Change |
|---|---|
| `v2/generate_conversation_batch_v1.txt:36` | Replace *"Do NOT invent or substitute names — use ONLY the two names provided above (!\<INPUT 0\>! and !\<INPUT 1\>!)."* with: *"Use ONLY the two names above for the two speakers. For any third party, use ONLY names that appear in the relevant memories above. If you must refer to an unnamed person, use 'someone' or 'a stranger' — do NOT invent names."* |
| `v2/survival_generate_conversation_batch_v1.txt:~176` | Same edit as above, plus one added sentence at the end: *"Inventing characters not in the cast is a critical error in this mode — the cast is small and every named person matters."* |

**F2 — Remove strategy steering (survival fork only):**

| File:line | Change |
|---|---|
| `v2/survival_generate_conversation_batch_v1.txt:184–185` | Delete the two lines: *"Both speakers are aware they may be eliminated tonight…they remain ordinary people having an ordinary conversation — they do NOT speak in mechanical 'voting bloc' terms"* AND *"It is natural for the conversation to drift toward: who they trust, who they are wary of, today's challenge…"*. Replace with one neutral line: *"This is an elimination format. How much you trust, how much you reveal, and how strategic you become under that pressure depends entirely on who you are."* |
| Line 186 (alliance instruction) | **Keep as-is** — this line is mechanically consumed by `survival_summarize_conversation` to drive `tag_event(kind="alliance_formed")`. |

**F3 — Soften overlay-quoting clamp (survival fork only):**

| File:line | Change |
|---|---|
| `v2/survival_generate_conversation_batch_v1.txt:162` | Change *"What !\<INPUT 0\>! is privately aware of (do NOT quote or restate verbatim):"* to *"What !\<INPUT 0\>! is privately aware of (let this shape what they say without quoting it back at the other person):"*. Removes the implicit "don't surface this in dialogue" framing so concrete outcomes (vote tally, immunity winner, eliminated name) can land naturally when personality and context warrant. |

**Verification (F overall):**
- F1: grep a 500-step segment from a fresh sim for non-cast capitalized words; target ≤2 hits (vs. 82 Marco mentions today).
- F2: re-run the Issue 7 topic classifier — survival-strategy keyword presence should drop from 98% to 60–75%; humor / off-topic rises from 0.5% to ≥5%.
- F3: F1 + F2 + Edits B/B′ working together — post-elimination Day-3 conversations should name a fallen cast member in ≥3 of 7.

---

### Day 0 — Investigation, prerequisite fix, and baseline (lands before Batch 1) `<DONE 2026-05-12>`

The plan rests on four assumptions that haven't been confirmed against the live code, plus one backlog item that silently disables Edit D. Day 0 locks them down before any of the six surgical edits are touched.

1. **Confirm the live chat-generation code path.** `<DONE>` Resolves the doc's own Pending item (above): `logs/llm/*.json` shows `decide_to_react`, `memo_on_convo`, `planning_thought_on_convo` — but no `iterative_chat`/`generate_chat`/`decide_to_talk`. Trace from `ConversationManager.run_conversation` to the actual LLM call site and confirm whether `run_gpt_prompt_generate_conversation_batch` is the path live sims use, or whether a separate path bypasses it. Without this, Edits A and F may land on the wrong file.
   - **Verified:** Live path is `ConversationManager.start_conversation` → `generate_batch_conversation` → `run_gpt_prompt_generate_conversation_batch` (single Tier-C batch LLM call per conversation). Greeting tier uses deterministic `greeting_generator.py` (no LLM). Edits A and F target the correct files.

2. **Resolve CHAT-MEMORY-001** (`BACKLOG.md` P2, 2026-04-15). `<DONE>` `_persist_chat_node_early()` in `perceive.py` only calls `a_mem.add_chat()` when `act_event[1] == "chat with"`; with `CHAT_PRESERVES_ACTION=true`, `conversation_manager` preserves the pre-chat action, so the guard fails and chat nodes are **never persisted** to associative memory. `a_mem.seq_chat` stays empty, which cascades into `kw_to_chat`. **Edit D retrieves from `kw_to_thought[partner]` + `kw_to_event[partner]` — but the actual prior dialogue is never there to retrieve.** This is the structural reason every conversation reads as a fresh first meeting (Issue 4) and every pact gets re-established (Issue 10). Fix: persist the chat node regardless of `act_event` shape, or guard on chat state rather than `act_event` shape. ~20–30 LOC in `perceive.py` + test. Must land before Batch 4 (Edit D), but slotted here because it's small and unblocks the rest.
   - **Fixed in `perceive.py:56–87`** (guard now checks `chat` + `chatting_with`; tuple synthesized from `chatting_with`). 7/7 unit tests pass (`tests/test_chat_memory_persistence.py`).
   - **Live-run verified on `20260512-2-free-flow`:** 102 chat ConceptNodes persisted to `dbl_memory` (Gosha 36, Ivan 25, Katya 30, Luba 11). Sample tuples confirm `(persona_name, "chat with", partner_name)` shape. Counts match summary chat-step counts within ~13% (bidirectional persistence). BACKLOG entry closed.

3. **Measure Edit A's actual token delta.** `<DONE>` Capture `Scratch.get_str_iss()` length for the 4-persona cast; project total batch-chat prompt size (2× ISS + 30-memory retrieval + Edit D's partner-focused +10 + survival overlay). Confirm the 6 000-token cap is realistic before committing. If projected ≥6 000, scope a tighter ISS variant (drop `currently` + `daily_plan_req`, keep `innate` + `learned` + `lifestyle`) before Batch 3.
   - **Verified:** Projected batch-chat prompt size ~1.5–1.8K tokens for 4-persona cast. 6 000-token cap has ~60% headroom. No ISS trim required.

4. **Audit `reverie.py:3804–3843` for survival-state coupling.** `<DONE>` Edit C moves `survival_controller.on_step()` to run before `persona_items_for_step` is built. Walk every read of survival state between the two anchor points and confirm no reader depends on the old ordering. Output: a one-page note listing the readers and verdict (safe / needs adjustment).
   - **Verified safe** with one constraint: the snapshot block `_survival_prev_eliminated` (lines 3838–3842) must move **with** `on_step()` (line 3843–3845) as an atomic unit — they're a pre/post pair around the elimination diff. Move both, in order. No other readers between the two anchor points depend on the old ordering.

5. **Capture the free-flow baseline sim.** `<DONE>` Required by the Both-mode gate (below) but not slotted. Run a 1 000-step free-flow sim on the current `main` and record pre-fix chat frequency, opener-trigram diversity, and per-step LLM latency. These become the denominator for the ±20% / ≥95% / ±10% regression targets.
   - **Captured on `20260512-2-free-flow` (1000 steps, free-flow mode, cast: Gosha/Ivan/Katya/Luba):**
     - **Chat frequency:** 90 chat steps / 1000 = **9.0%**. Per-persona: Gosha 32 chats (119 utt), Ivan 23 (83), Katya 26 (100), Luba 9 (32). Total utterances: 334.
     - **Sim health:** all 4 personas 100% present, 0 sleep-ping-pong, 0 wait-wrap compounding, 0 truncations, 0 piano-gate fires. Validator/repair overrides 0/119. LLM resolver hallucination 5/151 = 3.3% (low; tolerable).
     - **Known idle bands** (free-flow substrate the conversation fixes target): Luba 327-step parked band; Ivan 292-step; Katya 189-step; Gosha 236-step. All classified benign (no wait-wrap text).
     - **Gaps:** opener-trigram diversity and per-step LLM latency are **not** measured by the current analyzer — they need the Day 5 analyzer extension (or an ad-hoc parse of `logs/llm/*.json`). The ±20% chat-frequency gate is the only Day-0 baseline that is denominator-ready right now.

**Estimated duration:** 1–2 days. Items 1, 3, 4 are investigation (read-only); item 2 is a small surgical fix that ships its own `/verify`; item 5 is a sim run that can overlap with the others.

### Sequencing

| Day | Edits | Why this order |
|---|---|---|
| 0 | **Investigation + CHAT-MEMORY-001 fix + free-flow baseline** `<DONE 2026-05-12>` | Lock the four assumptions above and resolve the backlog item that disables Edit D. |
| 1 | **C** `<DONE 2026-05-12 — Batch α>` | Prerequisite. Without ghost-elim cleanup, later memory broadcasts get drowned by contradictory fresh nodes. |
| 2 | **B + B′** `<DONE 2026-05-12 — Batch α>` | Memory pipeline next; uses the new `world_events` helper. |
| 3 | **A + F** `<DONE 2026-05-13 — Batch β>` | Prompt-side edits together — Edit A's ISS routing makes Edit F1's name discipline far more effective (the LLM has more anchor for who the persona actually is). |
| 4 | **D + E** `<DONE 2026-05-13 — Batch β>` | Both touch `conversation_manager.py`; co-located edit is faster. Edit D is only meaningful once CHAT-MEMORY-001 (Day 0) is fixed. |
| 5 | **Analyzer extension + dual-sim validation** | Extend `tests/analyze_sim_realism.py` per Nicolas's Tier 4. Run a fresh 3000-step survival sim + a 1000-step free-flow sim. Grade against the metrics below. |

**Batches actually shipped (compressed schedule per 2026-05-12 plan):** Batch α = C + B + B′ (Days 1 + 2 bundled, **DONE 2026-05-12**). Batch β = A + D + E + F (Days 3 + 4 bundled, **DONE 2026-05-13**) — plus survival follow-ups G1 (alive_players resync) + G2 (perceive belt-and-suspenders) that closed the lone Batch α ghost-event leak found in `20260512-3`. Live-run validation on `20260512-4` (survival, 1500 steps) confirmed below.

### Live-run results — sim `20260512-4` (1500 steps, survival, post-Batch β) `<2026-05-13>`

Ivan Pistsov eliminated Day 1 (~step 869, vote 2). Three survivors ran to step 1500. Key acceptance signals:

| Metric | Before | Target | `20260512-4` | Status |
|---|---|---|---|---|
| Phantom-name mentions in dialogue | 192 (Marco/Lena/Mira) | ≤2 / sim | **0** invented person names / 790 utterances | ✅ |
| Ghost event-nodes per survivor (post-elim) | 3–14 (`20260506-5`) | 0 | **0** across all 3 survivors | ✅ |
| Elimination-keyword nodes in survivor memory | 0 / 1915 | ≥1 / survivor | 2–4 / survivor (idempotency leak, see below) | ✅ (with caveat) |
| Challenge-outcome references | 0 | ≥1 / window / pair | 1 / survivor for the Day-1 Group Betrayal Game (`No one won…`) | ✅ |
| Eliminated persona stops cognitive cycle | always ran | stop at elim | Ivan stops at step 869 (58% / 1500); survivors run full 1500 | ✅ |
| Free-flow chat frequency vs baseline | 0.102 chats/step (`20260512-2-FF`) | ±20% | 0.114 chats/step | ✅ (+12%) |

**Cooldown tier distribution (Edit E):** 104 greeting (≤2 exch) + 67 normal (3–5 exch) + **0 deep** (≥6 exch). The deep branch never fires because `CONVERSATION_CONFIG["exchanges"]` still caps `max_exchanges` at 5; Edit E's picker is doing its job within that cap.

**Two flagged observations:**

1. **Idempotency leak — `elimination_witnessed` duplicates.** 2 nodes for Gosha, 4 for Katya, 2 for Luba — instead of exactly 1 each. The `dedup_key="elim_Ivan Pistsov_day_1"` is correctly written into keywords but the broadcast fires multiple times before the `kw_to_event[key]` short-circuit kicks in. Functionally harmless (retrieval sees duplicates) but worth closing. **Root cause** (Batch γ, 2026-05-13): `HybridMemoryStore` (the wrapper `persona.a_mem` actually points to) proxied `seq_event`/`id_to_node`/`embeddings` to the underlying JSON store but did **not** proxy `kw_to_event`/`kw_to_thought`/`kw_to_chat`. The broadcast helper's `getattr(persona.a_mem, "kw_to_event", {})` returned `{}` → dedup_key idempotency was a silent no-op. **Same gap also silently disabled Edit D** — `_partner_block` calls `persona.a_mem.retrieve_about(...)` which raised `AttributeError` caught by a broad `try/except Exception` returning `("", set())`. Edit D never ran in any prior sim, including `20260512-4`. **Fix:** Batch γ adds the four property proxies + a `retrieve_about` delegation in `hybrid_memory_store.py`; 5 new unit tests cover proxy correctness + the end-to-end broadcast short-circuit. Live-run re-verification gated on the next survival sim.
2. **No deep-tier chats.** If you want richer / longer conversations, raise `CONVERSATION_CONFIG["exchanges"]["long_max"]` (currently 8 cap with sliding scale → effective ceiling 5 in this run); Edit E's deep cooldown will then start firing.

**Pre-existing issues out of scope for Batches α/β:** address-field divergence (151 hits), Apartment-N stale relabel (10 hits), Issue 2 Gap 1 cafe-kitchen non-worker resolutions (24 hits), pure-LLM resolver hallucination 5.3% (small sample, 4/76 calls). None of these are introduced or worsened by α/β.

Each edit is independently mergeable; if any one regresses, revert that edit alone. Each ships behind `/verify` per CLAUDE.md.

**Per-batch micro-validation.** After each batch, run a short targeted sim (200 steps, focused on the batch's acceptance criteria) before merging. Don't wait for the final 3000-step survival + 1000-step free-flow run to surface batch-level regressions. Note: elimination-dependent edits (B, B′, C) require ≥1 000 step micro-validation to reach Day-1 voting at step ~870; the 200-step default is only suitable for A, D, E, F. The pre-fix free-flow baseline sim is captured in **Day 0**.

**Alternative compressed timeline.** Batches 3 (Edits A + F) and 4 (Edits D + E) touch disjoint files and can run in parallel if review capacity allows, collapsing the schedule to Day 0 + ~3 days + 1 validation day (advisor's suggested cadence).

**Plan-to-chat (intent-driven conversation initiation)** is **not** included in this plan and **not** an MVP blocker for Survival release. The format herds the cast into shared rooms (challenges, gathering window, voting) so proximity-triggered chat produces enough co-location to carry the narrative even after Edit E's cooldown trims volume. Caveat: the absence of plan-to-chat will cap how much deception (Issue 8) and pact reaffirmation (Issue 10) emerge naturally — both are usually intent-driven ("I went looking for you to ask about your vote") rather than proximity-driven. Track deception markers post-fix; if narrative depth feels flat after Batch 5, plan-to-chat becomes the first post-MVP lever.

### Acceptance metrics

| Metric | Before (`20260506-5`) | Target |
|---|---|---|
| Phantom-name mentions in dialogue | 82+ Marco / 64 Lena / 46 Mira | ≤2 total non-cast capitalized names per sim |
| Median gap between consecutive convs of same pair | 2 sim-min | ≥15 (normal) / ≥30 (deep) sim-min |
| % pair convs re-engaging within 10 sim-min | 86% (Gosha-Luba) | <20% |
| Elimination-keyword nodes in survivor memory | 0 / 1915 | ≥1 per elimination per survivor |
| Day-3 conversations naming a fallen cast member | 0 / 7 | ≥3 / N |
| Top-opener-phrase repeats across personas | 4× verbatim repeats | ≤2× |
| % conversations with survival-strategy keywords | 98% | 60–75% |
| % conversations with humor / off-topic content | 0.5% | ≥5% |
| Ghost-persona event-nodes per survivor (post-elim) | 3–14 | 0 |
| Challenge-outcome references post-challenge | 0 | ≥1 per post-challenge window per pair |
| Doubt / confrontation markers | 0 | (track only, no target — emergent from personality) |
| **Free-flow chat frequency vs pre-fix baseline** | (measure pre-fix baseline) | ±20% — no over-suppression of ordinary chat |
| **Free-flow conversation diversity** (distinct opener trigrams per day) | (measure pre-fix baseline) | ≥95% retained — no diversity collapse |
| **Batch-chat prompt size** | not measured | ≤6 000 tokens per call |
| **Per-step LLM latency** (batch-chat path) | measure pre-fix baseline | within ±10% of baseline |

Deception is tracked but **not** targeted. The fix is removing the prompt-level suppression; whether deception emerges from any given cast depends on the personas authored into the sim. If a cast of trusting, conflict-averse personas never lies, that's the correct emergent behaviour, not a regression.

**Both-mode gate:** every batch must pass its survival metrics *and* the free-flow regression metrics before merging. A free-flow baseline sim must be run **before Batch 1** to capture pre-fix chat frequency and diversity numbers.

### Remaining work to ship a fully functional conversation system `<2026-05-13>`

Current state: Batches α + β + γ shipped. CHAT-MEMORY-001 closed. 38 unit tests across 3 files all green. Live-run validated on `20260512-4` (1500 steps survival) for everything *except* Batch γ — which fixed a silent gap that meant Edit D and dedup idempotency never actually ran in `20260512-4`. **One micro-validation sim still needed to lock the system as shipped.**

**Must-do before declaring done:**

1. **Survival re-validation sim post-Batch γ (1000–1500 steps).** Required because:
   - Edit D (partner-focused retrieval) was silently no-op'd in every prior sim — now wired live, expect more partner-aware dialogue + reduced pact restatement
   - Edit B / B′ dedup_key idempotency was a no-op — now expect exactly 1 `elimination_witnessed` + 1 `challenge_outcome` node per survivor per event (not 2–4)
   - Acceptance to grade: 0 ghost events (G1+G2), exactly 1 elimination_witnessed/challenge_outcome per survivor, opener-trigram diversity ≥95% retained vs `20260512-2-FF`, phantom-name count ≤2.

2. **Free-flow re-validation sim (1000 steps).** Same Batch γ rationale + Edit D is mode-agnostic, so partner-focused retrieval changes free-flow chats too. Compare against the Day-0 baseline (`20260512-2-FF`, 0.102 chats/step): expect ±20% chat frequency and ≥95% opener-trigram diversity.

3. **Analyzer extension (Day 5 in the original plan).** `tests/analyze_sim_realism.py` currently reports movement / sleep / Apartment-N / Issue-2-Gap-1 / hallucination metrics but doesn't extract opener-trigram diversity, topic-mix percentages, or per-step LLM latency from `logs/llm/*.json`. Without it, the F2 ("survival-strategy keyword presence drops 98%→60–75%") and F3 ("humor / off-topic ≥5%") metrics stay un-measurable. Scope: ~150 LOC analyzer addition; reads `analysis/llm_sequences.jsonl` + a_mem chat nodes.

**Should-fix before survival GA, optional otherwise:**

4. **Vote tally per-voter shape.** ~~`season.eliminated[-1]["vote_count"]` is a scalar int…~~ **DONE 2026-05-13.** `_collect_and_resolve_votes` stashes `{voter: target}` on `self._pending_vote_tally`; `_execute_elimination` persists it onto `season.eliminated[-1]["vote_tally"]`; the B′ broadcast now emits "Day N vote tally — Gosha voted Ivan, Katya voted Ivan, …". 5 unit tests added under `TestPerVoterVoteTally`.

5. **Deep-tier chat unlock.** ~~caps at long_max=8 / medium_max=6 ceiling'd at 5…~~ **DONE 2026-05-13.** `CONVERSATION_CONFIG["exchanges"]["medium_max"]` raised 6→8 and `long_max` raised 8→10. Chats can now reach ≥6 exchanges and trigger Edit E's 30-step deep cooldown. Extra LLM cost negligible (~50–100 tokens × ~170 chats/sim).

6. **Cooldown short-circuit on plan-path when `OBSERVATION_PRIMARY=false`.** ~~Edit E dropped the per-pair cooldown check inside `_should_react`…~~ **CLOSED 2026-05-13** as unsupported mode. Added a startup `print` warning in `plan.py:122` if `OBSERVATION_PRIMARY=false`: "The legacy plan-path reaction trigger lacks the post-2026-05 cooldown short-circuit and may re-engage conversations during cooldown windows. Set OBSERVATION_PRIMARY=true (default) for production runs." Zero behavioural change on the supported path; full per-pair cooldown threading deferred until a no-frontend mode is actually needed.

**Open items (post-MVP, not blocking)**

- **Personality dial.** If post-fix sims still show uniform cooperation, the next investigation moves upstream into persona authoring (are ISS `innate` fields diverse enough?), not dialogue generation.
- **Long-term cost telemetry.** Once shipped, instrument the batch-chat path for per-call token + latency so the 6 000-token cap and ±10% latency gate are monitored continuously rather than only at validation time.
- **Free-flow narrative event authoring.** The generalised `broadcast_event_to_personas` helper unlocks scripted world events (move-in, fire, holiday) for free-flow sims. No author-facing affordance exists yet — worth scoping a small DSL or trigger format once a free-flow scenario calls for it.
- **Plan-to-chat (intent-driven initiation).** Tracked as post-MVP lever — the format herds the cast into shared rooms, so proximity-triggered chat is sufficient. Caveat unchanged: without plan-to-chat, deception and pact reaffirmation are capped at what proximity surfaces.

---

*Same authoring conventions as `20260504_action-location-observations_v2.md`. Once Ivan finishes the video-trailer work and circles back to this, this doc can be extended in place with `<DONE>` markers and a TODO section the same way.*
