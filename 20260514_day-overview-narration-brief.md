# Brief: Day-Overview Trailer Narration — Reality-TV Expert Consult

> **Purpose:** Get expert input on how to make our automated daily-recap trailer narration feel like one continuous, dramatic story instead of a list of captions.
> **Audience:** External reality-TV / trailer-editorial consultants.
> **From:** Ivan (Doubland)
> **Date:** 2026-05-14

---

## 1. What we're building

Doubland runs a continuous social simulation: a small cast of characters lives, talks, plans, and — in "survival" seasons — votes each other out one per day. Every simulated day, we auto-generate a **~2-minute "day-overview" trailer**: a dramatic recap of that day's story, narrated over the day's actual footage.

The whole pipeline is automated. From the day's event data we:
1. Rank the cast and pick the **1–3 most story-relevant characters** for that day.
2. Plan a **6-beat spine**: previously-on → setup → developments → turning point → vote fallout → cliffhanger.
3. Generate **narration + camera** for each scene.
4. Record the footage, lay the voiceover over it, score it, and cut it.

We have a sibling format — the **opening trailer** (a pre-season cast-introduction trailer) — and we're happy with how its narration reads. The day-overview narration is not there yet. This brief is about closing that gap.

---

## 2. The problem (with real examples)

The day-overview narration currently feels **punctuated and uneven** — seven self-contained captions rather than one story. Here is a real generated output (Day 2, an elimination day, 3 characters: Gosha, Luba, Katya):

> 1. *Yesterday, Ivan Pistsov goes home — three votes. Gosha wakes alone in the dorm, planning the next move.*
> 2. *Gosha wakes at eight p.m., still in bed — plan notes unfinished. He should meet Luba by the cafe to swap final ballots. Can he hold the centre tonight?*
> 3. *Luba checks the laptop for challenge notes and the calendar. She types a reminder: meet Gosha in ten. She folds her plan into a compact promise — back him at the vote tonight. Can she keep that quiet?*
> 4. *Katya reviews the token plan at the table. She rehearses the pitch under her breath. She tells Luba they'll stick together if voting starts — steady, low, certain.*
> 5. *Luba rehearses a quiet negotiation pitch at the counter. She practices wording that keeps Gosha safe — and keeps her options open. At 11:00 she locks eyes with Gosha; the plan shifts in three words. Will their pact hold at the vote?*
> 6. *Gosha rehearses his negotiation points at the window, finalizing who he'll back. Twenty minutes later the vote lands — Gosha Pistsov is eliminated by two votes.*
> 7. *Katya studies her notes at the piano, mapping contingency moves. Her breath tightens. Luba waits nearby. The vote closes in.*

**What's wrong with it:**

- **Every beat is the same kind of statement** — "Character does a small action at a location." Seven of them in a row. No variety of rhetorical function.
- **No thesis, no payoff.** The day has a real arc (an alliance, a betrayal, an elimination) but the narration never *states* the stakes or *builds* to them — it just lists.
- **No connective tissue.** No "but," "meanwhile," "by nightfall," "what none of them knew." Each line is an island.
- **It narrates logistics, not drama.** "Checks the laptop for challenge notes," "types a reminder," "still in bed" — these are the literal event-log entries. A trailer narrator should be telling us what it *means*, not what was clicked.
- **The climax lands flat.** The elimination — the single biggest moment of the day — is delivered in the same even tone as "Luba checks the laptop."
- **Accidental repetition.** "Gosha wakes / Gosha wakes / Luba rehearses / Gosha rehearses / Katya studies" — same verbs, by accident.

**Root cause (technical, but worth knowing):** each scene's narration is written by a *separate* generation pass that sees only its own character's raw event log and nothing else — not the other scenes, not what was said before or after. So there is structurally no way for it to build an arc, thread transitions, or vary its rhetoric. It is, by construction, seven captions.

---

## 3. What the opening trailer got right

For contrast, here is the **opening-trailer** narration for the same cast — which we're happy with:

> *They're family. In Doubland, their Doubles have to survive each other.*
> *Four Doubles enter a village. Every day brings pressure and escalating stakes. Every night, they vote one of their own out.*
> *Gosha is reliably kind. That makes him the teammate everyone trusts; it also makes him the person others can quietly trade favors through — and betray when it counts.*
> *Ivan drills down on every flaw he sees. That makes him relentless… can single-handedly take control, or quietly crush someone who gets in the way.*
> *(…two more characters, same shape…)*
> *This is the moment family rules meet the format. The vote. Where loyalty becomes math and you must choose to outlast the brother or outlive the daughter you love.*
> *Who feels safest tonight, who is already alone enough to betray, and which mask will be exposed first?*
> *Day one begins now.*

**Why this one works — and what we think is transferable:**

1. **Each beat does a *different* job.** Premise → format explainer → character turns → the stakes statement → the question hook → the call to action. No two beats are the same kind of sentence.
2. **There's a thesis, and it pays off.** "They're family / have to survive each other" is planted in line 1 and cashed in later: "outlast the brother or outlive the daughter you love."
3. **Explicit dramatic connectors** thread the beats: "That makes him X; it also makes him Y," "But under pressure," "This is the moment."
4. **It's about essence and stakes, not logistics.** It tells us what the characters *are* and what's *at risk* — never what they literally clicked or where they sat.
5. **Repetition is a chosen device, not an accident.** The four character intros deliberately share a shape (trait → strength → hidden danger), which reads as rhythm, not monotony.

Our working hypothesis for the fix: **author the day-overview narration as one continuous piece with full story context** — one pass that sees the whole day (all characters, the alliance, the betrayal, the elimination) and writes a single throughline with setup → escalation → turn → payoff — instead of seven blind captions. And push the content from "what they did" toward "what it meant." But we want to pressure-test that against people who do this professionally before we build it.

---

## 4. Questions for you

Please answer in whatever depth is useful — even partial answers help. Where your answer differs for a *daily recap* vs. a *season promo*, call that out; almost all trailer craft advice we can find is about season promos, and we're not sure how much transfers.

### Structure & arc
1. For a **~2-minute recap of a single day** (not a season), what beat structure actually works? Is our 6-beat spine (previously-on → setup → developments → turning point → vote fallout → cliffhanger) sound, or is there a better daily-recap template?
2. A day with an elimination has a built-in climax. How should the narration **pace toward it** — how much runway before the vote, how do you *land* the elimination beat so it hits, and what (if anything) should come immediately after it?
3. Is **~2 minutes** even right for a daily-cadence recap, or is the industry norm tighter (60–75s) for something viewers are meant to watch every single day?

### Voice & content
4. Should a daily recap be **omnisciently narrated** (our current approach — "Gosha tries to hold the centre"), or should it lean on the cast's own words / confessional-style lines? What's the trade-off?
5. Our raw material is a **literal action log** ("checked the laptop," "rehearsed at the counter," "still in bed"). What's the rule top editors use for deciding what to **keep vs. cut**, and for converting a mundane logged action into a line about *stakes*?
6. What **connective devices** make a recap feel like one story — "meanwhile," cold callbacks, withheld information ("what none of them knew yet")? Which of these actually work, and which read as cheap or overused?

### Cast & cadence
7. With **3 characters in ~2 minutes**, how do you give each a thread without it fragmenting into three separate mini-stories? Do daily recaps usually pick **one lead per day** and let the others orbit?
8. We publish a **new trailer every single day** for the same cast. What makes a day-end **cliffhanger** that genuinely pulls viewers to tomorrow — without the device feeling formulaic by day 10, day 20, day 30?

### Craft guardrails
9. When is **repetition / parallel structure** a deliberate rhythmic device (as in our opener) versus just monotony?
10. What are the **most common amateur mistakes** in recap-style trailers — the things that immediately read as "not professional"?
11. If you were briefing a **writer who has only the day's structured event data** and must produce this narration in a single pass, what would you put in their brief? (This maps almost directly onto how we instruct our generation system.)

### React to the examples
12. Looking at the **Section 2** day-overview example and the **Section 3** opener example side by side — beyond what we've already flagged, what jumps out to you? If you could change only **three things** about the day-overview narration, what would they be?

---

## 5. What we'll do with your answers

Your input will shape the writing brief our generation system follows — concretely, the instructions and structure it uses to produce every daily trailer's narration. We'll send a follow-up with a revised sample for your reaction. Thank you.
