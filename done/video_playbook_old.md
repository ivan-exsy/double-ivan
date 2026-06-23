# Video Playbook — Producer's Guide

> **Audience:** producer / director / product owner. The "why" and "what" of every Double trailer.
> **Engineering reference:** see `D:\Coding\double-ivan\video\video_PRD.md` for the "how" — module map, env flags, validators, retry logic.
> **Last Updated:** 2026-05-04
> **Status:** Day-in-life + sim-day-overview + sim-opening shipped (MVP). Sim-announce planned.

---

## Intro

*Double*
Double is an AI-powered social simulation app that lets users create a digital twin—called a "Double"—of themselves through a quick personality quiz, then drop it into shared virtual worlds with real-life friends or groups. These avatars interact autonomously in fun, unpredictable scenarios like peer drama or triumphs, delivering binge-worthy entertainment while sparking self-reflection and stronger group bonds.


*Survival mode*
Villages can run in a **RealityTV** mode (think *Survival*): a simulation director sets daily challenges all Doubles must go through, and each night the group gathers to vote someone out—until one Double remains for recognition (and potentially prizes). 
This mode is designed to surface character under pressure and let coalitions, social strategy, and recognizable behavior patterns emerge naturally.

## 0. North Star

Every Double trailer is surveillance footage of AI personas, narrated by someone who knows everything. Truman Show meets prestige documentary. The viewer should feel like they're watching real people whose inner lives are being narrated by a warm, omniscient voice — part nature documentary, part novel narrator.

Four trailer types serve four different jobs:

| Type | Length | When | Job |
|---|---|---|---|
| **Day-in-Life** (§2) | 60s | Any sim-day, single protagonist | "Here's what one persona's day felt like." |
| **Sim-Day-Overview** (§3) | 2:30-3:00 | Each sim-day, ensemble | "Here's what happened today across the cohort." |
| **Sim-Opening** (§4) | 2:30-3:00 | Day 0 of a sim | "Meet the cast — here's the season ahead." |
| **Sim-Announce** (§5) | 45-60s | Pre-sim hype | "A new season is coming." |

**Audience:** the cohort's friend group + their broader social graph + investor-level prospects. Mobile-first viewing surface (vertical 9:16 master derived from 16:9). Subtitle-on-by-default assumption.

**Brand voice:** warm, observational, slightly amused, never cold or mocking. The narrator *likes* these people.

---

## 1. Shared Foundations

These principles cut across all trailer types. Each per-type section (§2-§5) names which beats and rules carry over and which are type-specific.

### 1.1 Storytelling weight model

The visual medium is top-down 2D sprites — no faces, no body language, limited animation. Storytelling load shifts dramatically toward audio + text:

| Channel | Weight | Role |
|---|---|---|
| Narration (VO) | 35% | Carries emotional arc, reveals motives, creates dramatic irony |
| Text overlays / subtitles / cards | 20% | Contextualizes action, surfaces dialogue, marks rhythm |
| Camera work (zoom, pan, speed) | 25% | Creates focus, pacing, scene structure, spatial storytelling |
| Music + sound design | 15% | Sets mood, marks transitions, builds tension and release |
| Sprite movement (visual) | 5% | Spatial grounding — "proof" that it happened |

**Core principle:** sprites are *evidence*; narrator is the *storyteller*. The viewer should feel like they're watching surveillance footage narrated by someone who knows everything.

### 1.2 Narrator voice

**Warm omniscient.** The narrator knows everything — what happened, what will happen, what each persona is thinking. Tone is gentle, curious, slightly amused. Never mocking. Never cold. The narrator *likes* these people.

| Quality | Target | Avoid |
|---|---|---|
| Pacing | Deliberate, ~2.0-2.7 words/sec | Rushed, breathless, podcast-speed |
| Register | Warm baritone or warm alto | Raspy, breathy, nasal |
| Emotion | Genuine curiosity, quiet delight | Sarcastic, deadpan, over-enthusiastic |
| Age feel | 40-60 (experienced, trustworthy) | Young/casual or elderly/frail |
| Accent | Neutral / slight British warmth | Strong regional, exaggerated |

**The Double voice = Attenborough's cadence + Jim Dale's omniscient playfulness + Freeman's warmth.** See Appendix B for reference voices and calibration.

**Narration writing rules:**

1. **Omniscient third person only.** "Katya had no idea..." not "Watch what happens..."
2. **Name the protagonist in the first line.** Always.
3. **Create dramatic irony.** Reveal what the character doesn't know.
4. **One devastating observation per trailer.** Save it for the turn beat.
5. **End on a question or unresolved image.** Never resolve the story fully.
6. **Short sentences for impact, longer for flow.** Mix them.
7. **`[PAUSE Ns]` markers** indicate where the narrator goes silent and visuals carry the moment.

### 1.3 Mood modes

The showrunner picks one mood per trailer based on the day's dominant emotional arc. Each mood affects music, narration tone, pacing, and transition preferences.

| Mode | Trigger | Narrator tone | Music | Transitions | Card text style |
|---|---|---|---|---|---|
| **Intrigue** (default) | Mystery, hidden motives, social maneuvering, quiet revelation | Curious, slightly conspiratorial | Sparse piano, electronic pulse | Focus shift, card break, slow fly-over | Questions: "Who knew?" / "A quiet lie." |
| **Drama** | Conflict, confrontation, rupture, high-stakes decision | Urgent, empathetic, unflinching | Building strings, percussion, tension | Hard scene cut, silence drop, fade to black | Statements: "Trust broken." / "No going back." |
| **Wholesome** | Friendship, kindness, small victories, community warmth | Warmest, genuine affection | Acoustic guitar, warm piano, light glockenspiel | Fly-over, time-lapse, gentle fades | Observations: "Small things." / "Tuesday." |

Survival-mode trailers append a fourth tone — `survival_anthem` (kinetic, big-stakes orchestral) — used by sim-opening and sim-announce.

### 1.4 Music strategy

Three pre-rendered 75s mood tracks ship in `video/audio/`: `music_intrigue.mp3`, `music_drama.mp3`, `music_wholesome.mp3`. A fourth `music_anthem.mp3` is on the open-asset list (§4.5). All tracks normalized to −16 LUFS, MP3 192kbps, 1.5s fade-out tail.

**Energy arc** (60s day-in-life baseline; longer trailers scale proportionally):

```
0:00-0:08  HOOK        Atmospheric. Single instrument. Space.
0:08-0:20  SETUP       Rhythm enters. Light percussion. Foundation.
0:20-0:38  DEVELOPMENT Melody joins. Steady build. Layers add.
0:38-0:42  STOP-DOWN   Near-silence. One sustained note or nothing.
0:42-0:50  TURN        Swell. Emotional peak. Full arrangement.
0:50-0:58  CLOSE       Resolve. Strip back to single instrument.
0:58-0:60  END CARD    Final note sustain or fade to silence.
```

**Music editing rules:**

- **Never let music compete with narration.** Duck music 6-9 dB under VO.
- **Stop-down is sacred.** At the turn (~0:38-0:42 in 60s; ~2:00-2:10 in 3-min), music drops to near-silence. This is the most powerful moment in the trailer.
- **No lyrics.** Instrumental only. Wordless "ooh/aah" acceptable only in wholesome track.
- **One signature motif per trailer.** Tick / heartbeat / lullaby — threaded 3-4× through the cut for sonic cohesion. (Post-MVP polish; not yet wired into the pipeline.)

See Appendix A for Suno/Udio generation prompts.

### 1.5 SFX library

A minimal set of 12 SFX for transitions and emphasis. Source from Freesound.org, Pixabay Audio, or generate via ElevenLabs SFX. **(Open — see PRD TODO-7.)**

| # | SFX | Use case | Duration |
|---|---|---|---|
| 1 | Soft whoosh | Scene cut transition | 0.3-0.5s |
| 2 | Slow whoosh | Fly-over transition | 0.8-1.2s |
| 3 | Clock tick (single) | Time passage, anticipation | 0.2s |
| 4 | Clock tick (sequence) | Time-lapse transition | 2-3s |
| 5 | Soft impact / thud | Dramatic beat, revelation | 0.3s |
| 6 | Sub-bass drop | Turn moment, stop-down | 0.5-0.8s |
| 7 | Silence drop (hard cut) | Before the turn | 0.1s |
| 8 | Gentle rise (reversed cymbal) | Building toward a moment | 1.5-2s |
| 9 | Typing / keyboard clicks | Text card appearance | 0.5s |
| 10 | Ambient village hum | Establishing shots, background | Loop |
| 11 | Footsteps (soft) | Walking sequences | Loop |
| 12 | Door / transition chime | Location change | 0.3s |

### 1.6 Transition library

Six transition types. The showrunner specifies one between each pair of scenes.

| ID | Type | When to use | Camera | Audio | Duration |
|---|---|---|---|---|---|
| T1 | Scene cut | Workhorse — between any scenes | Instant reposition + zoom change | Optional soft whoosh | 0 frames |
| T2 | Fly-over | Major location change. **Max 1× per trailer.** | Zoom out → bird's-eye pan → zoom in | Slow whoosh + ambient hum | 3-4s |
| T3 | Time lapse | Compressing routine / transit | Medium zoom, follow protag, 10-25× speed | Clock tick sequence | 3-6s real time |
| T4 | Focus shift | Two characters in same location, revealing co-presence | Smooth zoom/pan from sprite A to sprite B | Let narration carry it | 1-2s |
| T5 | Card break | Time jumps, context cards, dramatic emphasis | Full-screen card | Typing SFX | 1.5-2.5s |
| T6 | Fade to black | Act breaks, before/after the turn, opening, closing | Fade out → hold → fade in | Music continues or stop-down | 1.5-2.5s |

### 1.7 Subtitle & card style

**Text cards (card-break transitions):**
- Font: Inter, Helvetica Neue, or similar clean sans-serif
- Size: large (fills ~40% of frame width)
- Color: white text on transparent or semi-transparent dark overlay
- Animation: fade in 0.3s → hold 1.5-2s → fade out 0.3s
- Maximum 5 words. Sentence case (not ALL CAPS — too aggressive).

**Dialogue subtitles:**
- Same font family, ~60% of card size
- Position: lower third (bottom 20% of frame)
- White text + thin black outline (2px) for readability over any background
- Speaker name in slightly dimmer color above the line
- Quotation marks present — distinguishes dialogue from narration

**End card:**
- Centered. Day number large; village or cohort name smaller below.
- Duration: 2s (day-in-life), 5s (sim-opening earns the lingering close)
- Background: fade to black, then text fades in

### 1.8 Quality checklist (shared)

Run through before exporting. Per-type checklists in §2-§5 add type-specific items.

**Story:**
- [ ] Hook is the most surprising/loaded moment, shown without context
- [ ] Protagonist (or the trailer's emotional anchor) is named in the first line
- [ ] Dramatic irony present (viewer knows something character doesn't)
- [ ] Story does NOT fully resolve — ends on open question or quiet image
- [ ] One "devastating observation" line from the narrator
- [ ] Logline would make someone curious in one sentence

**Technical:**
- [ ] Total duration within type-specific bounds
- [ ] At least one 2-3s silence beat
- [ ] Music ducked under narration (voice always clearly audible)
- [ ] No clipping or audio distortion
- [ ] End card present and readable

**Pacing:**
- [ ] No scene longer than 18s (day-in-life) / 25s (longer trailers)
- [ ] Speed ramps only during transit/routine, never during emotional moments
- [ ] Fly-over transition used max 1×
- [ ] Stop-down at the turn beat
- [ ] Energy builds setup → development, drops at turn, resolves at close

**Social readiness:**
- [ ] 9:16 vertical crop exists; key elements visible
- [ ] Subtitles readable at mobile size
- [ ] First 3s would stop a thumb-scroller

---

## 2. Day-in-Life Trailer

> **60 seconds · 1 protagonist · 1 sim-day · single LLM call · ~5 minutes end-to-end**

### 2.1 Purpose

Tell one persona's day as a single dramatic arc. The smallest unit of the show. Use this when there's a strong single-character throughline worth a deep dive — first day of a meaningful arc, an elimination day for a beloved persona, a quiet day with one revelation that lands hard.

### 2.2 Beat sheet (60s)

```
0:00 ─── HOOK (5-8s) ──────────────────────────────────────────
│  Most surprising or emotionally loaded moment. No context.
│  Camera: tight zoom (1.5-2.0×). Music: first note of mood track.
│
0:08 ─── SETUP (10-12s) ──────────────────────────────────────
│  Rewind to the morning. Establish routine and normalcy.
│  Camera: bird's-eye (0.5-0.7×) → zoom in. Speed: 5-10× during transit.
│  Subtitle card: protagonist name + one-line identity.
│
0:20 ─── DEVELOPMENT (15-18s) ────────────────────────────────
│  Main thread unfolds. Key interaction or event.
│  Camera: medium zoom (1.0-1.2×), follow protagonist.
│  Pull 1-2 dialogue lines as text overlays.
│  Narrator reveals context the protagonist doesn't have.
│
0:38 ─── TURN (10-12s) ───────────────────────────────────────
│  Something shifts. A realization, a contradiction, an arrival.
│  Camera: pause or slow push-in. 2-3s silence.
│  Narrator delivers the most loaded line of the trailer.
│  Music: brief stop-down → swell.
│
0:50 ─── CLOSE (8-10s) ───────────────────────────────────────
│  Don't resolve. Show aftermath or the question.
│  Camera: slow zoom out to bird's-eye.
│  Narrator: final line — open-ended, reflective.
│
0:58 ─── END CARD (2s) ───────────────────────────────────────
│  "DAY {N} — THE VILLE"     Fade to black.
└─────────────────────────────────────────────────────────────
```

### 2.3 Pacing rules

- 140-170 words narration target (100-200 hard bounds), ~2.7 words/sec
- ≥1 silence of 2-3 seconds (let the visual breathe)
- ≤2 dialogue excerpts as text overlay
- ≤3 subtitle cards (including end card)
- 2-4 scenes total; consecutive `key_steps` per scene (no teleporting)

### 2.4 Survival-mode addendum

When the sim is running Survival mode and the trailer's day had a vote, narration must:

- **Surface the vote outcome.** Day-of-vote narration names who was voted out (and margin if known) unless a non-Survival event scores meaningfully higher on poignancy.
- **Quote eliminated-persona farewells verbatim.** When the protagonist is themselves eliminated on the trailer's day, the closing scene quotes their `final_statement` close-to-verbatim. No paraphrasing — these lines are gold.
- **Default to elimination as the day's spine** unless another event scores >1.5× higher.

### 2.5 Acceptance

- 58-62s duration · 140-170 words · ≥1 silence beat · ≤2 dialogue excerpts · ≤3 cards
- Protagonist named in first line · dramatic irony present · unresolved close · one devastating line
- 9:16 crop with key elements visible · subtitles readable at mobile size · first 3s thumb-stop

---

## **3. Sim-Day-Overview Trailer**

> **2:30-3:00 · 1-3 protagonists · 1 sim-day · two-stage LLM (spine + per-scene) · ensemble recap**

> **⚠️ Spec pivot (2026-05-14).** Sections §3.3–§3.13 below describe an **8-beat creative target** (cold hook, Today's Pressure, variable inserts, cafe ceremony, etc.) that was rewritten in flight after a Reality-TV expert consult. The shipped v2 on branch `ivan/day-overview-v2` instead uses a **two-stage Day Story Producer → Narration Writer** with a fixed **6-beat template** (`yesterday_scar → today_pressure → apparent_plan → countermove → vote_reveal → new_imbalance`) at **~60–75 s runtime**. Treat the content below as **aspirational v3 vision**, not the v2 build. Live spec + remaining work: **`D:\Coding\double-ivan\20260514_trailer_day_overview.md`**.

### *3.1 Purpose*

Recap the day's most intriguing events from the perspective of 1-3 characters who drove, misunderstood, or were pressured by the day.

The Sim-Day-Overview is not a neutral digest. It is the daily episode trailer: a fast, emotionally legible account of how the village moved through challenge pressure, social strategy, and, when applicable, vote-out consequence.

The viewer should leave with three things:

1. A clear sense of **today's pressure**.
2. A memorable social turn: loyalty, suspicion, alliance, betrayal, exclusion, or unexpected kindness.
3. A reason to come back tomorrow.

3 minutes is the sweet spot — long enough for a real arc, short enough to stay fast-paced. Avoid 5-min: TikTok / Reels engagement drops past 3.

### *3.2 Opening rule: pressure before explanation*

Do not open with a full cast introduction every day. Cast introduction and survival concept belong primarily in the Sim-Opening trailer.

For Sim-Day-Overview, use a **micro-reset** only. Day 1 carries a slightly larger reminder; Day 2+ uses only a standalone 3–5s product cue at end-card or overlay (e.g. “Scroll back to the first promise”).

**Day 1 micro-reset (immediately after cold hook):**
```text
These are AI Doubles of real people. Today is their first test.
```

**Day 2+ cue (standalone, rotate one per day):**
- “Scroll back to the first promise.”
- “Replay yesterday’s vote from the start.”
- “Zoom into any scene.”
- “Follow this Double tomorrow.”
- “Watch live before tomorrow’s trailer.”

Replace “overview of today’s plan” with **Today’s Pressure**.

Weak:

```text
Today the Doubles will complete a group cooking task, then attend council.
```

Better:

```text
Today’s pressure: choose a partner before lunch.
By sunset, one of those choices will become evidence.
```

The opening should create a question, not explain a schedule.

### *3.3 Beat sheet*

| Beat                      |      Time | Content                                                                              |
| ------------------------- | --------: | ------------------------------------------------------------------------------------ |
| Cold hook                 | 0:00-0:05 | The day’s most loaded, surprising, or socially unstable moment. No full context yet. |
| Previously on…            | 0:05-0:15 | Bridge card + 8-10s recap of prior day. **Skipped on Day 1.**                        |
| Today’s Pressure          | 0:15-0:25 | One card or narrator line that frames the challenge/social pressure of the day.      |
| Spine narration           | 0:25-0:35 | Narrator declares today’s narrative arc.                                             |
| Protagonist arcs          | 0:35-2:15 | 4-5 scenes × ~20-25s, interleaved across 1-3 protagonists.                           |
| POV / omniscient insert   |  Variable | 1-2 short inserts that explain a player’s perspective or reveal dramatic irony.      |
| Cafe ceremony / vote beat | 2:15-2:45 | If any council / vote / elimination fired today, use dedicated visual treatment.     |
| Cliffhanger + end card    | 2:45-3:00 | Unresolved tension → “Tomorrow…”                                                     |

### *3.4 Cold hook*

The first 3-5 seconds must stop the viewer.

Use one of:

* a Double standing alone after a conflict
* a group gathered in the cafe before a vote
* a loaded dialogue subtitle
* a narrator line that reveals impending consequence
* a silent aftermath shot after the day’s turning point

Examples:

```text
NARRATOR:
Lena thought the alliance still held.

[PAUSE 1s]

It did not.
```

```text
CARD:
Three promises.
One vote.
```

```text
SUBTITLE:
“I never said I trusted him.”
```

Do not start with the logo as the primary hook. If the Doubland.ai logo is used at the opening, keep it to a fast 0.5-1.0s branded flash or corner bug after the hook has already landed.

### 3.5 Today’s Pressure module

Every Sim-Day-Overview should contain one clear pressure statement.

This can be based on:

* the daily challenge
* the social constraint created by the challenge
* a hidden consequence players do not yet know
* a vote-out risk
* a coalition dilemma
* a previous-day unresolved conflict

Format:

```text
Today’s pressure: {simple action or constraint}.
But {hidden consequence / emotional risk / social cost}.
```

Examples:

```text
Today’s pressure: pick one person to protect.
But protection, in this village, also names a target.
```

```text
Today’s pressure: work in pairs.
For three Doubles, that meant choosing between loyalty and safety.
```

```text
Today’s pressure: tell the truth.
No one had agreed on what the truth was.
```

This module should be 5-10 seconds max.

### *3.6 Variable inserts*

Variable inserts are optional short modules used when they increase clarity, suspense, or emotional payoff.

Use no more than **two** per trailer.

#### 3.6.1 Player POV insert

A Player POV insert explains how one Double understood the day while events were unfolding.

Use when:

* a Double misreads the room
* an alliance decision depends on one person’s belief
* the viewer needs emotional alignment with a protagonist
* the day has too many events and needs a human anchor

Format:

```text
From {Double}'s point of view, {interpretation}.
What {Double} could not see was {missing context}.
```

Examples:

```text
From Oleg’s point of view, this looked like loyalty.
What he could not see was that Lena had already made the same promise twice.
```

```text
From Katya’s point of view, the challenge was about speed.
For everyone watching from the cafe, it had become a test of trust.
```

Rules:

* Keep it third-person, not direct confession, unless quoting actual dialogue.
* Do not explain every motivation.
* Use POV to create empathy or irony, not to flatten mystery.
* Prefer one character’s misunderstanding over a neutral summary.

#### 3.6.2 Omniscient context insert

An omniscient insert is narrator analysis that reveals something the players do not yet know.

Use when:

* the audience needs to understand a hidden dilemma
* past drama affects today’s behavior
* one coalition’s plan is invisible to another
* tomorrow’s stakes are being planted today

Format:

```text
What no one knew yet was {hidden scenario}.
By nightfall, {consequence}.
```

Examples:

```text
What no one knew yet was that the challenge had already divided the village into two voting blocs.
By nightfall, both would claim they had never chosen sides.
```

```text
The day looked like a routine task.
It was actually the first time the old alliance had to prove it still existed.
```

Rules:

* Use dramatic irony sparingly.
* Do not reveal so much that tomorrow becomes predictable.
* Preserve at least one unanswered motive for the cliffhanger.
* The narrator may know everything, but should not sound cruel or smug.

### 3.7 Protagonist selection

**Top 1-3 personas** ranked by storyline potential (`video/persona_ranker.py`, see PRD §5.8):

* Top-5 poignancy sum from today's memories, bounded so eliminated personas with one big moment are not drowned by ambient-event mass
* Conversation count × 0.5
* Unique locations visited × 0.2
* Trigger-event bonus +50 for elimination, council, or vote
* Relationship-extreme bonus +10 for top-10% or bottom-10% affinity in cohort
* Pressure-relevance bonus +15 if the persona directly affected today’s challenge outcome
* Vote-relevance bonus +15 if the persona received votes, influenced votes, or changed coalition position

**Quiet-day fallback:** if top-bottom score spread is tight (< 1.5× delta), surface only the top-1 protagonist so the trailer stays focused.

**Vote-day override:** if a vote-out fired, include either:

* the eliminated Double,
* the deciding voter,
* or the Double whose social position changed most because of the vote.

Do not let a vote-out happen entirely offscreen in the daily overview.

### 3.8 Cafe ceremony / vote visual treatment

If a vote, council, or elimination fired today, the Sim-Day-Overview should include a dedicated vote beat.

The default setting is the **cafe**.

The cafe works as the repeatable social stage: a single place where private strategy becomes public consequence.

#### V1: ceremony snapshot

For MVP / near-term implementation, use a compact ceremony snapshot.

Sequence:

1. Slow push or flyover into cafe.
2. All remaining Doubles visible if possible.
3. Red-push color grade applied.
4. Narrator names the social consequence.
5. Show 2-3 selected vote explanations.
6. Announce the selected Double.
7. Quote the leaving Double’s farewell line if available.
8. End on silence, reaction, or empty-chair image.

Example narration:

```text
By evening, the village gathered in the cafe.

All day, the choices had looked private.
Here, they became public.

Two votes were about trust.
One was about fear.
And one was about yesterday.

When the final vote was counted, Misha was selected.

His farewell was brief.

“I knew someone would flip. I just thought it would be me.”
```

#### Post-MVP: full ceremony

A full ceremony may be added post-MVP, but should not replace the trailer’s pacing.

Post-MVP ceremony features:

* all Doubles gathered in the cafe
* fixed announcement order
* every Double has a recorded vote reason
* selected vote reasons appear in the trailer
* all vote reasons can be inspected in playback UI or detail cards
* eliminated Double gets a final farewell line
* cafe becomes a recognizable recurring ritual

Do **not** include every vote explanation in the 3-minute trailer by default. It will become repetitive and over-explain the politics.

Trailer rule:

```text
Show the vote result.
Show 2-3 reasons.
Hide enough motive to make tomorrow interesting.
```

#### Visual treatment

Scenes tagged with `trigger_event ∈ {vote, elimination, council}` get a red-push color grade applied before concat:

```text
colorchannelmixer=rr=1.05:gg=0.85:bb=0.82,eq=brightness=-0.06
```

This gives those beats signature visual weight and teaches viewers that the cafe ceremony is where the village’s social order changes.

### 3.9 Use of flyover and logo assets

#### Village flyover video

Use the village flyover as a major transition, not as decorative filler.

Best uses:

* cold open into Today’s Pressure
* transition from daytime challenge to evening strategy
* transition into cafe ceremony
* closing pullback after vote-out

Rule:

```text
Max 1 flyover per Sim-Day-Overview trailer.
```

Exception: a second flyover is allowed only for finale, premiere, or unusually high-stakes vote-out.

#### Doubland.ai logo

Use the Doubland.ai logo at the closing end card.

Optional opening use:

* 0.5-1.0s logo flash after the cold hook
* small corner bug during the first card
* not a slow branded intro

Do not spend the first seconds on branding if a story hook is available.

Closing end card format:

```text
DAY {N} — {VILLAGE_NAME}

Tomorrow:
{unresolved question}

Doubland.ai
```

Example:

```text
DAY 6 — THE VILLE

Tomorrow:
Who knew before the vote?

Doubland.ai
```

### 3.10 “Previously on…” bridge card

Skipped on Day 1.

On subsequent days, use a 6-10s bridge card with text recap of the prior day’s pivotal events.

The recap should be driven by active threads, not a generic day summary.

Format:

```text
Previously in the village:
{one unresolved social fact}
{one consequence still active today}
```

Examples:

```text
Previously in the village:
Lena promised safety to two people.
Only one believed her.
```

```text
Previously in the village:
Misha survived the vote.
His alliance did not.
```

Image keyframes from the prior trailer are post-MVP polish — text-only ships now.

### 3.11 Pacing rules

* Target duration: 2:30-3:00
* Narration target: 300-470 words
* 1-3 protagonists
* 4-5 main scenes
* ≤4 dialogue excerpts total
* ≤6 subtitle cards total, including bridge card and end card
* ≤2 variable inserts total
* ≤1 flyover transition
* At least one 2-3s silence beat
* No scene longer than 25s
* Speed ramps only during transit or routine, never during emotional moments
* Council / vote beat present iff a vote fired today
* Each scene's `key_steps` must intersect the protagonist's actual position rows, so defensive validators catch blank-video scenes

### 3.12 Acceptance

* 2:30-3:00 duration, 148-180s validator window
* 1-3 protagonists
* ≥1 scene per protagonist
* Cold hook lands in first 5s
* Today’s Pressure module present
* Spine sentence present in narration
* “Previously on…” skipped iff Day 1
* 1-2 variable inserts used only when they add suspense, clarity, or emotional payoff
* Council / vote beat present iff a vote fired today
* Cafe ceremony snapshot used for vote-out days
* Vote explanation limited to 2-3 selected reasons in trailer
* Eliminated Double’s farewell line quoted if available
* Council / vote color grade applied iff trigger event fired today
* Cliffhanger not resolved
* End card readable and includes Day number / village name
* Doubland.ai logo appears at close
* 9:16 crop viable
* Subtitles readable at mobile size
* First 3s would stop a thumb-scroller

### 3.13 Editorial vision v2

The shipped Sim-Day-Overview is **protagonist-driven**: rank personas → spine LLM → scenes.

A more ambitious **thread-driven** model is on the roadmap. The pieces below are creative direction for v2, not yet fully wired.

#### Event-level scoring

Per-event composite:

```text
salience
+ |sentiment|
+ arousal
+ novelty
+ impact
+ conflict
+ virality_pred
+ progress_delta
+ reaction_quality
+ coverage_gap_bonus
```

This captures the editorial reasoning behind which moments deserve screen time. Today's persona-ranker scores personas; this scores events themselves.

#### Multi-day threads + season arcs

A thread spans 2-5 days:

* study group forms
* roommate tension
* secret voting bloc
* repeated challenge rivalry
* public promise that keeps getting tested

A season arc spans 10-30 days:

* alliance breakup
* rivalry turning into respect
* quiet player becoming power broker
* repeated survivor becoming social threat

Each event tags `thread_id[]`.

Nightly, each thread updates:

```text
progress_delta
heat
who_is_involved
who_knows
who_misunderstands
```

Trailers should advance threads, not just spotlight days.

#### 3-beat mini-arcs per thread

Each thread should cut as:

1. Setup — want / problem / pressure
2. Complication — reversal / escalation / misunderstanding
3. Tease — unresolved moment

Threads become micro-stories within the daily cut.

#### “Previously on…” per thread

Instead of a generic prior-day summary, use a 1-line memory string per active thread.

Example:

```text
Yesterday, Sasha protected Dima.
Today, Dima has to vote first.
```

Surface as a 2s card when the thread re-enters.

#### Spice moments

Include 1-2 off-thread injections with high arousal or novelty:

* humor
* surprise
* wholesome generosity
* awkward silence
* strange routine
* unexpected coalition contact

These moments should not spoil resolutions. Their job is to keep the cut from feeling monotone.

#### Coverage diversity

Aim for 6-10 unique faces across the cut unless a single thread dominates the day.

Rule:

```text
If one thread owns >70% ThreadScore, let it dominate.
Otherwise, diversify coverage.
```

#### Personalization

Per-viewer Character Affinity Vector can reorder the three mini-arcs to lead with the viewer’s top-affinity character.

Same global event set, different sequencing.

#### Safety / tone guardrails

Filter or blur:

* personal identifiers
* harassment
* NSFW material
* humiliating or cruelty-forward moments

Down-rank scenes where toxicity > 0.6 unless explicitly tagged as consensual drama.

Narrator tone stays warm, observational, and slightly amused. The narrator may reveal social truth, but should not mock the Doubles.

---

## **4. Sim-Opening Trailer**

> **2:30-3:00 · ensemble (6 cast slots) · Day-0 only · two-pass LLM (per-persona + wrapper) · season premiere + how-to-watch CTA**

### *4.1 Purpose*

The season title sequence. Survivor's "16 strangers, 39 days." The Bachelor first-night arrival. Big Brother house tour.

For a cohort product where the social graph is the product, the opening has one job above all others: **make every friend feel like the lead character of their own arc** — even the ones who will get voted out Day 1. If your Aunt Maria sees the opening and doesn't lean forward when she sees herself, the whole pitch breaks.

The Sim-Opening has a second job in v2: **make the viewing loop immediately legible**. Viewers should understand that Double is not just a rendered trailer. It is a 24/7 live social simulation they can enter, scroll back through, inspect, and return to every day.

The opening should answer five questions without becoming an explainer video:

1. Who is in this village?
2. What is the Survival premise?
3. What kinds of moments will happen here?
4. How can I watch the simulation?
5. When do new trailers drop?

**v2.1 update (2026-05-26):** Opening Trailer now carries the primary concept load for virality. It introduces the Double concept early (after cold hook) and ends with a participation bridge that converts “I want to know what happens to them” into “I want to see what would happen to me.” Daily trailers stay pressure-first with only micro-doses. Terminology exception for trailers: use “AI Doubles of real people” and “AI versions of real people” (approved override of brand vocabulary discipline).

### *4.2 The six emotions, in order*

| Beat | Emotion | What lands it |
|---|---|---|
| Cold open | Intrigue + grandeur | World pan, gold lettering, narrator names the stakes: "Eight Doubles. One village. One survives." |
| Cast intros | Recognition ("that's me / that's Sasha") | Sketch portrait → name → one-line identity → sprite cameo |
| Stakes montage | Drama ("this is going to be intense") | Fast cuts: challenge pressure, alliances, routines, strategy, vote-outs |
| Access reveal | Discovery ("I can actually watch this") | Product promise: the village runs 24/7 and can be watched from the beginning |
| Trailer cadence | Habit ("I should come back tomorrow") | New recap trailer every day at 6:30 PM |
| End card | Action ("sign up / watch now") | `www.doubland.ai` + notification CTA |

The Relationship Reveal beat remains dropped in v1; pairs are hinted via cast-intro adjacency and stakes-montage cuts instead.

### *4.3 Beat sheet*

| Beat | Time | Content |
|---|---:|---|
| Cold open | 0:00-0:12 | Establish the world and Survival premise. Example: "Eight Doubles. One village. One survives." |
| Cast intros | 0:12-1:42 | Six featured Doubles, ~15s each. Recognition is the priority. |
| Stakes montage | 1:42-2:20 | Challenge pressure, daily routines, casual conversations, dramatic strategy, council/vote imagery. |
| How to watch | 2:20-2:40 | Explain that the simulation runs 24/7, viewers can scroll back to Day 1, and every Double can be followed. |
| CTA end card | 2:40-2:50 | "New trailer daily at 6:30 PM. Sign up at www.doubland.ai." |

Target duration remains 2:30-3:00. The added "How to watch" module should replace dead air or overly long montage time, not reduce cast recognition.

### *4.4 Cast intros (the ~90s that matter most)*

Each persona gets ~15s. Structure:

| Time | Beat | Role |
|---|---|---|
| 0.0s | **Sketch portrait** full-screen on trading-card frame (1.5s) | Recognition |
| 1.5s | Crossfade into their sim home | Bridge: sketch → game |
| 2.5s | Sprite walks out / turns / waves (2-3s, generated micro-video) | Life: not a static card |
| 5.0s | Name card + one-line bio overlay (3s) | Verbal identity |
| 8.0s | **Trait moment as on-screen text** over silent sprite footage (4s) | Personality without voice |
| 12.0s | Persona sting + cut to next persona (3s overlap with anthem) | Rhythm |

Six personas × 15s ≈ 90s of cast. **No spoken VO during cast intros** — the anthem carries rhythm, on-screen text carries personality, the per-persona sting punctuates each card. ElevenLabs TTS in someone else's voice for the persona's "I'm here to play" line undercuts the recognition beat; silent trait moments work better.

### *4.5 Stakes montage*

The stakes montage should show what Survival mode will generate, not explain every rule.

Use fast, legible glimpses of:

- daily routines
- casual conversations
- challenge pressure
- private strategy
- visible alliance formation
- dramatic discussions
- council / vote-out imagery
- quiet aftermath

Narration should stay high-level and emotionally loaded:

> "Every day, the village keeps moving. Routines become patterns. Conversations become alliances. And sooner or later, every Double has to choose who they trust."

Do not over-explain scoring, immunity, or exact mechanics in the opening. The viewer only needs to understand the promise: social life under pressure, repeated daily, with consequences.

### *4.6 How-to-watch module*

The final 12-18 seconds before the CTA should make the product loop clear.

Use one clean card sequence, not a long feature list.

Recommended copy:

```text
The village runs 24/7.
Watch from the very first day.
Follow every Double — routines, conversations, alliances, and vote-outs.
New trailer daily at 6:30 PM.
````

Alternate shorter version for tighter cuts:

```text
Watch the village live.
Scroll back to Day 1.
New trailer daily at 6:30 PM.
```

Tone rule: frame access as following AI Doubles inside a shared simulation, not spying on real friends. Avoid language like "look into every action." Prefer "follow every Double" or "watch the village unfold."

### *4.7 CTA end card*

End card resolves to:

```text
DAY 1 STARTS NOW
{cohort_name} — {season_title}

Watch live. Scroll back. Follow every Double.
New trailer daily at 6:30 PM.

www.doubland.ai
```

### 4.8 Cast selection

Not all personas. Feature **6** (configurable 1-6 via `--top` CLI arg) ranked by storyline-potential score from the same `persona_ranker` used in §3.3. Top-6 typically captures: strongest affinity extremes (highest + lowest in `relationship_affinities`), most distinct personality traits vs. group mean, explicit role markers in soul file.

**Archetype assignment** (drives trading-card frame + intro sting): `champion` / `wildcard` / `observer` / `connector`. Classified by Tier-B LLM call (`_classify_archetype` in `video/showrunner.py`). Champion = alliance leader, decisive. Wildcard = chaotic, unpredictable. Observer = quiet strategist. Connector = social glue, looks out for the quiet ones.

### 4.9 Asset commission inventory

v0 ships working with placeholders; commissioned drops upgrade quality with ~1h of code wiring once assets land. Full prompts and acceptance criteria in `d:\Coding\double-ivan\20260501_opening-trailer.md`.

| Asset | Tool | State | Drop-in path |
| Sprite walk-out micro-videos (6 × 2.5s) | Grok Imagine | Native Phaser fallback running; commission MP4s for polish | `video/assets/users/sprite-walkouts/{agent_id}.mp4` (`.webm` fallback at `video/assets/phaser/sprite_walkout_{agent_id}.webm`) |
| Anthem music track (~165s, 6 stings)    | Suno or Udio            | Using `music_drama.mp3` placeholder | `video/audio/music_anthem.mp3`                                    |
| Trading-card frame PNGs (3 archetypes)  | Figma or Midjourney     | FFmpeg `drawbox` placeholder borders running | `video/assets/archetypes/card_frame_{archetype}.png`     |
| Archetype intro stings (4 × WAV)        | Suno or Freesound       | Classification shipped; playback not wired   | `video/assets/archetypes/sting_{archetype}.wav`          |
| Cinematic atmospheric MP4s (4-6)        | Grok Imagine            | 5 flyovers shipped 2026-05-04; Phaser establishing shots remain as fallbacks | `video/fly-over/cinematic_flyover_*.mp4` (Phaser PNG fallbacks at `video/assets/phaser/establish_*.png`) |
| How-to-watch card templates             | Figma / FFmpeg drawtext | New v2 requirement                            | `video/assets/cohort/how_to_watch_card_*.png`           |

**Sketch portraits** (recognition anchor) — at `video/assets/users/sketches/{agent_id}.{png|jpg}` (regenerated 2026-05-07; original photos at `video/assets/users/headshots/{agent_id}.png`; generation prompt at `video/assets/scripts-prompts/prompt-photo-sketch.md`). Privacy-safe; enables open social sharing. Real-photo path was dropped from v1.

### 4.10 Cohort name + season title

Locked per cohort. End card resolves to:

```text
DAY 1 STARTS NOW
{cohort_name} — {season_title}
www.doubland.ai
```

For v2 openings, include the viewing-loop CTA before or after the URL:

```text
Watch live. Scroll back. Follow every Double.
New trailer daily at 6:30 PM.
```

### 4.11 Acceptance

* 150-180s target duration; 95-180s validator window allowed for asset variability
* 60-220 words narration; cold open, stakes montage, and how-to-watch module only
* 6 cast scenes, or configurable 1-6
* Cold open lands in first 3s
* Cast intros prioritize recognition over explanation
* No spoken VO during cast intros
* Stakes montage includes at least three of: routines, conversations, challenge pressure, alliances, dramatic discussions, vote-out imagery
* How-to-watch module present
* CTA includes `www.doubland.ai`
* CTA mentions daily trailer release time: 6:30 PM
* Notification signup prompt present
* 9:16 crop viable
* Subtitles and cards readable at mobile size
* Final language frames access as following AI Doubles in a shared simulation, not spying on real friends

---

## **5. Sim-Announce Trailer**

> **45-60s · ensemble · pre-sim hype · vertical-first (9:16 master)**

### *5.1 Purpose*

Build excitement before Episode 1 drops. Introduce the Survival format, the setting, the cast — but no sim has run yet, so there's no event footage to draw from. Most different from the existing pipeline (no sim footage; world flyover + cast cameos at idle Day-0 spawn positions).

### *5.2 Beat sheet*

| Beat | Time | Content |
|---|---|---|
| Hook | 0:00-0:10 | World pan over The Ville; narrator opens with a loaded question |
| Rules card | 0:10-0:15 | Survival format: goal, elimination mechanic (one kinetic title card) |
| Cast montage | 0:15-0:45 | Sprite cameos at their assigned homes, 2-3s each, name overlays |
| Drop card | 0:45-0:60 | Episode 1 drop date + CTA |

### *5.3 New assets needed*

- Survival format brief (one-time copy: rules, goal, elimination mechanic, tagline)
- `music_reveal.mp3` (75s, big drums + kinetic pulse, reveal/hype arc)
- Cast portrait frames (overlap with §4 — reusable)
- Kinetic title-card templates (extend FFmpeg drawtext from end-card logic)

### *5.4 Acceptance*

- 45-60s · vertical-first (9:16 master) · all featured personas appear once
- Survival rules card present · drop-date end card · no memory-stream data used (Day-0 spawn positions only)

---

## **6. Shared Craft Principles**

Cross-cutting editorial rules ported from pro trailer-house theory. Apply to every trailer type unless overridden by a per-type beat sheet.

### 6.1 Cause → effect pairs

Prefer setup-shot → immediate-reaction-shot pairs over disconnected moments. Creates story logic even when shots are pulled out of order.

### 6.2 Faces early, spectacle later

Lead with character recognition; save the wide-angle spectacle for payoff later in the cut. Faces sell jokes, terror, awe. Spectacle without faces is decoration.

### 6.3 Stop-downs as power moves

A 250-600ms drop to near-silence amplifies whatever lands next. The turn beat in every Double trailer uses this. Don't waste it elsewhere.

### 6.4 J-cuts and L-cuts

Run audio across cuts: VO bleeds into the next visual (J-cut) or trails from the previous (L-cut). Glues otherwise discontinuous moments. Especially useful at scene transitions where narration crosses the boundary.

### 6.5 Match cuts (optional polish, post-MVP)

1-2 per trailer when an action / shape / motion match presents itself. Auto-detect via SSIM or optical flow. Polish only — if there's no natural match, don't force one.

### 6.6 Signature recurring motif

One sonic motif (heartbeat, ticking clock, single piano note) threaded 3-4 times through the cut. Sells continuity across scenes that otherwise feel episodic. Currently un-wired in the pipeline; tracked as post-MVP polish.

### 6.7 Pacing law: a new question every 3-5 seconds

Every 3-5s the viewer should get a new question, twist, or sensory jolt. Kills the second a trailer feels static. Tied directly to shot length: 25-30 shots per minute is the rhythmic envelope.

### 6.8 Speed ramps — only during transit

Speed-ramp during routine / walking / time-passing scenes. Never during emotional moments. Time compression should feel mundane, not dramatic.

### 6.9 Alt hooks and alt buttons (post-MVP)

For high-stakes trailers (sim-opening, season finale): produce 2-3 alternate hooks and 2 alternate buttons. A/B-test which lands. Not built into the pipeline yet.

---

## 7. Per-Trailer Quality Gates

Run the §1.8 shared checklist plus the type-specific items below before exporting.

### Day-in-Life
- [ ] 58-62s duration · 140-170 words narration · 2-4 scenes · ≤2 dialogue excerpts
- [ ] First narrator line names protagonist · stop-down lands 0:38-0:42

### Sim-Day-Overview
- [ ] 148-180s duration · 300-470 words narration · 1-3 protagonists
- [ ] Spine sentence present in narration · "Previously on…" skipped iff Day 1
- [ ] Council/vote color grade applied iff trigger event fired today
- [ ] Cliffhanger end card unresolved

### Sim-Opening
- [ ] 95-180s duration · 60-220 words narration (cold open + stakes only)
- [ ] All featured personas get a cast-intro beat · cold open lands in first 3s
- [ ] End card includes cohort + season + watch-live framing + `www.doubland.ai` (per §4.7)
- [ ] No spoken VO during cast intros

### Sim-Announce (when shipped)
- [ ] 45-60s · vertical-first 9:16 · Survival rules card present
- [ ] All featured personas appear once · drop-date end card

---

## Appendix A — Suno/Udio Music Prompts

### Mood track 1 — Intrigue

```
Minimalist cinematic underscore, 80 BPM, C minor.
Sparse solo piano with reverb, joined by soft sustained strings at 0:15.
Subtle electronic pulse enters at 0:30, like a distant heartbeat.
Gentle build to 0:45 with added cello. Brief silence at 0:50.
Resolve with single piano note fading into reverb tail.
75 seconds total. No drums until 0:20, then only soft brushed percussion.
Inspired by: Philip Glass, Thomas Newman, The Truman Show soundtrack.
Mood: curiosity, surveillance, quiet wonder, voyeuristic intimacy.
No vocals. No lyrics. Instrumental only.
```

### Mood track 2 — Drama

```
Emotional cinematic score, 105 BPM, D minor.
Opens with solo cello playing a simple ascending phrase.
Strings section enters at 0:15 with sustained tension chords.
Percussion builds from 0:25 — timpani heartbeat rhythm.
Full orchestral swell at 0:40-0:45. Hard silence at 0:48 (2 seconds).
Returns with piano and strings for final resolve, fading gently.
75 seconds total. Dark but empathetic. Weight without melodrama.
Inspired by: Hans Zimmer (Interstellar quiet moments), Max Richter.
Mood: consequence, truth revealed, emotional weight, empathy.
No vocals. No lyrics. Instrumental only.
```

### Mood track 3 — Wholesome

```
Warm acoustic cinematic underscore, 95 BPM, G major.
Opens with fingerpicked acoustic guitar, simple repeating pattern.
Warm piano joins at 0:15 with gentle chords.
Soft glockenspiel/marimba melody enters at 0:25.
Light brushed drums from 0:30. Gentle build to warm peak at 0:45.
Strips back to guitar + piano for final 15 seconds, fading warmly.
75 seconds total. Like a Sunday morning. Unhurried.
Inspired by: Explosions in the Sky (gentle tracks), Ólafur Arnalds.
Mood: kindness, small victories, gentle humor, community, good day.
Wordless female vocal "ooh" permitted in peak section only.
```

### Sim-opening anthem (open commission — see §4.5)

```
Cinematic anthemic orchestral hybrid — reality TV grand premiere
Tempo 110 BPM. Length 165 seconds. Fully instrumental.
Big, hopeful, slightly tense; reverent but kinetic.
Reference: Survivor S43 main theme; Big Brother UK 2023 intro;
"Heroes" (David Bowie) cinematic-orchestral cover.
Cinematic strings, light electronic percussion, brass swells, sub-bass,
sparse piano. 6 musical "stings" at 15s intervals (0:30, 0:45, 1:00,
1:15, 1:30, 1:45) — each a 0.5s harmonic accent punctuating a name-card
reveal. 1.5s fade-out tail.
```

### Post-generation

1. Trim to exact target length
2. Normalize loudness to −16 LUFS (broadcast standard)
3. Export stems if the platform supports it (drums, melody, pads separately) — enables custom escalations in future polish passes
4. Sanity test: play the track while reading the narrator script aloud. Does the energy arc match? Does the stop-down land at the right moment?

---

## Appendix B — Narrator Reference Voices

### Primary references

**1. David Attenborough.** Cadence target. Every sentence has weight. Pauses are intentional. Treats the mundane as extraordinary. *Listen to:* Planet Earth. *Borrow:* pacing, word emphasis, reverence for subject. *Avoid:* the very slow pace — Double trailers need slightly more energy.

**2. Jim Dale (Pushing Daisies narrator).** Personality target. Omniscient narrator who knows every character's secrets and reveals them with a storyteller's instinct. Warm, whimsical, precise. *Listen to:* Pushing Daisies S1E1 opening narration. *Borrow:* the omniscient reveal technique, playfulness. *Avoid:* the storybook register may be too whimsical for drama mode — calibrate per mood.

**3. Morgan Freeman (March of the Penguins / Shawshank narration).** Trust target. Warmth without condescension. *Borrow:* simplicity of language, listener-immediately-feels-safe quality. *Avoid:* don't try to imitate Freeman directly; borrow the *quality*.

### Secondary references

**4. Ron Howard (Arrested Development).** Deadpan omniscient narration with comic timing. Borrow for wholesome mode — humor through understatement.

**5. Werner Herzog (documentaries).** Philosophical weight. Makes the ordinary feel cosmically significant. Borrow for intrigue mode — the feeling that something profound is happening beneath the surface.

### Calibration per mood

- **Intrigue:** more Attenborough + Herzog. Measured. Observational.
- **Drama:** more Freeman. Empathetic. Direct. Simple words, heavy meaning.
- **Wholesome:** more Jim Dale + Ron Howard. Warmer. A smile in the voice. Gentle wit.

### TTS voice ID (current)

ElevenLabs voice `cIO62fcmCSQhE0DE2WS2` — stability 0.65, clarity 0.75, style 0.40 (slightly expressive, not flat). OpenAI `tts-1-hd`/`onyx` is the engine fallback.

**Calibration line** — test new voice candidates against:

> *"Katya had planned a quiet afternoon at the library. But the library, it turned out, had other plans for Katya."*

---

## Appendix C — Example Showrunner Output (Day-in-Life)

```json
{
  "title": "Day 17 — The Empty Chair",
  "mood": "intrigue",
  "protagonist": "Katya",
  "logline": "Katya spent the day looking for a quiet place to study, never noticing that someone had been looking for her.",

  "narrator_script": "Katya had a plan. [SCENE 1] A simple one — find a quiet corner, finish the assignment, go home. [PAUSE 1s] But in the Ville, quiet corners have a way of filling up. [SCENE 2] She left the dorm at seven thirty. The same route she always took. Past the bakery, through the square, straight to the library. [SCENE 3] What Katya did not know was that Gosha had arrived at the library an hour earlier. He had chosen the chair next to hers. And then he had waited. [PAUSE 2s] [SCENE 4] By the time Katya walked in, Gosha was gone. The chair was empty. A folded note sat on the desk. [PAUSE 1.5s] She picked it up, read it once, and put it in her pocket without expression. [SCENE 5] [PAUSE 2s] Katya finished her assignment that afternoon. She did not mention the note to anyone. But she took the long way home.",

  "scenes": [
    {
      "scene_id": 1,
      "label": "hook",
      "time_range_sec": [0, 8],
      "step_range": [67, 70],
      "focus_persona": "Katya",
      "location": "Library, study area",
      "camera": {"start_zoom": 1.5, "end_zoom": 1.5, "follow": "Katya", "playback_speed": 1},
      "transition_in": "fade_from_black",
      "transition_out": "card_break",
      "narrator_lines": [
        "Katya had a plan.",
        "A simple one — find a quiet corner, finish the assignment, go home.",
        "But in the Ville, quiet corners have a way of filling up."
      ],
      "visual_note": "Katya sitting alone at a library desk, slightly zoomed in"
    }
  ],

  "end_card": {"text": "DAY 17 — THE VILLE", "subtitle": "What did the note say?"}
}
```

**Why this works:**
- Hook is the *consequence* (Katya alone in library), not the beginning
- Dramatic irony: viewer sees Gosha wait and leave before Katya arrives
- The note is never revealed — open loop drives curiosity
- Devastating line: *"He had chosen the chair next to hers. And then he had waited."*
- Final image: *"she took the long way home"* — behavior change implies the note mattered
- 138 words narration (~2.3 words/sec) — fits the 60s window with pauses

For sim-day-overview and sim-opening example outputs, see PRD §3 and §4 (engineering reference).

---

*This playbook is a living document. Update after each trailer production with lessons learned.*
