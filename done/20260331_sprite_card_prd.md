# Product Requirements Document — Sprite Detail Cards

**Product:** Double
**Feature:** Sprite Detail Cards
**Version:** v1.1
**Status:** Draft for implementation
**Audience:** Product, Design, Frontend, Backend, AI/Simulation, QA, Analytics
**Last updated:** 2026-03-31

---

## 1) Summary

Sprite Detail Cards are the primary in-playback deep-dive surface for understanding an individual sprite.

For the launch version, Double is starting in **simple simulation mode**. The card should optimize for **slice-of-life legibility, social readability, and attachment**, not survival-style stakes.

They are **not** intended to expose the full internal simulation state. Their job is to act as a **story explainer at the sprite level**: helping viewers quickly understand:

1. **What this sprite is doing right now, and where**
2. **Why they are doing it, and what is likely to happen next**
3. **Who this sprite is as a person**
4. **How they relate to other sprites**
5. **Why they are worth following for the next minute**
6. **How a curious viewer can go deeper without overwhelming the main viewing experience**

The card should make any sprite feel like a potential protagonist.

The card is opened by clicking the sprite’s always-visible **Pronunciato** status bar, and only one card may be open at a time.

This PRD defines the **simple simulation default presentation** while keeping the same shell extensible for a later reality-format mode.

---

## 2) Problem Statement

The current Sprite Detail Card is overloaded and exposes too much raw simulation structure through tabs like Info, Actions, Memory, Chats, and Plan. This makes the card feel more like a database or debugging panel than a compelling audience-facing character interface.

Current problems:

* Duplicate or near-duplicate information across Actions and Plan
* Too many tabs for casual viewers
* Low prioritization of story meaning vs raw state
* Important social and narrative information is buried
* Chat logs and memory notes are not editorialized
* The first screen does not reliably answer the viewer’s core questions fast enough
* The language leans too easily toward “game state” even when launch mode is not yet challenge-heavy

As Double evolves toward more structured challenge pressure, strategy, vote-outs, and recap trailers, the card must support **narrative legibility**, **character attachment**, and **selective depth** without forcing high-drama framing too early.

---

## 3) Product Goals

### Primary goal

Turn the Sprite Detail Card into a fast, engaging **character close-up** that explains the sprite’s current story role and encourages deeper viewing in simple simulation mode.

### Secondary goals

* Increase viewer understanding of on-screen events
* Increase attachment to individual sprites
* Increase card-open-to-continued-watch behavior
* Reduce cognitive overload during playback
* Create a consistent template that can work across all sprites and scenarios
* Teach viewers how to read social behavior before stronger reality-format mechanics are introduced

### Tertiary goals

* Preserve a clean migration path toward a future reality-mode card with stronger pressure and stakes
* Support future trailer workflows by making each sprite’s arc legible
* Provide a foundation for future direct interaction ("Talk")
* Create clean surfaces for analytics and iterative tuning

---

## 4) Non-Goals

The Sprite Detail Card v1 is **not** intended to:
- Serve as a full simulation inspector
- Expose every internal planner state or model variable
- Replace global playback subtitles or narrator systems
- Become a full social graph explorer
- Serve as the primary interface for chatting with sprites
- Display exhaustive chat transcripts by default
- Display a raw memory database by default

---

## 5) Product Principles

1. **Story first, internals second**
   Show what helps the viewer read the story. Hide what only proves the engine is running.

2. **Orientation before exploration**
   The viewer must understand the current moment before choosing a deeper tab.

3. **One sprite, one close-up**
   The card is a focused lens. Only one can be open at a time.

4. **Compression over exhaustiveness**
   Summaries, signals, and curated highlights beat raw dumps.

5. **Legibility in under 8 seconds**
   A viewer arriving from live playback should grasp the sprite quickly.

6. **Progressive disclosure**
   The top layer answers universal questions; deeper layers support curiosity.

7. **Viewer mode and power mode must stay separate**
   "Talk with Sprite" is meaningfully different from watching and interpreting a sprite.

8. **One shell, multiple emphasis modes**
   The launch card should work in simple simulation mode now and support stronger pressure/stakes later without a full redesign.

9. **Curiosity without fake drama**
   The card should create interest through routine, motivation, and social delicacy before it creates interest through competition or elimination.

---

## 6) User Context

### Core viewing contexts
1. **Live playback**  
   The viewer watches the simulation and clicks a sprite to understand a current moment.

2. **Post-trailer curiosity**  
   A trailer surfaces a sprite as interesting; the viewer opens the card to learn more.

3. **Favorite sprite following**  
   The viewer repeatedly checks one sprite to track their arc.

4. **Group context disambiguation**  
   The viewer wants to understand why a sprite is relevant within a broader social scene.

---

## 7) Jobs To Be Done

When I am watching a scene and click a sprite, help me:
- understand what they are doing and where
- understand why they are doing it
- understand what may happen next
- understand who they are
- understand how they relate to the people around them
- decide whether I want to keep following them

When I open a card after seeing a trailer, help me:
- remember why this sprite seemed interesting
- connect their current action to a broader arc
- form attachment to them within seconds

---

## 8) Target Users

### Primary
- Players watching their own Double or favorite sprites during playback
- Participants watching their group simulation

### Secondary
- Viewers consuming group recap content or highlight-driven playback

### Future
- Power users who want deeper interaction or direct chat
- Editors / internal review teams validating story legibility

---

## 9) Success Metrics

### Core metrics

* Card open rate per active playback session
* Average dwell time on card
* Percent of card opens that result in continued playback beyond 30 seconds
* Percent of users who open the same sprite card more than once in a session
* Tab distribution: Overview / Story / Social / Day / Talk
* Return rate to a sprite after first card open
* Card-to-followed-story behavior (e.g. watch next beat involving same sprite)
* Multi-card chain rate: percent of users who open a second related sprite card after viewing the first

### Quality metrics

* Time to first comprehension (qualitative usability test)
* % of users who can correctly answer:

  * what the sprite is doing
  * why they are doing it
  * what they may do next
  * who matters most to them right now
* Qualitative "felt overloaded" score
* Qualitative "I care more about this sprite now" score
* Qualitative "I know why I’d keep watching this sprite" score

### Guardrail metrics

* Card open causing playback abandonment
* Talk mode misuse or accidental entry
* High bounce from Story/Social because of low clarity
* Overuse of dramatic labels that users perceive as misleading
* Performance regressions on playback scene load

---

## 10) Card Architecture

### Final tab structure for launch

1. **Overview** (default)
2. **Story**
3. **Social**
4. **Day**
5. **Talk** (advanced / gated / optional)

### Tab hierarchy by importance

`Overview >>> Story / Social >>> Day >>> Talk`

### Rationale

* Overview provides fast orientation and must do the heaviest lifting
* Story and Social are the main depth surfaces
* Day is supporting context and should feel viewer-friendly rather than mechanical
* Talk is a mode shift and should be visually and behaviorally distinct

### Future mode note

In a later reality-format mode, **Day** may evolve into or be replaced by **Stakes** without changing the rest of the card shell.

---

## 11) Entry Points and Navigation

### Entry
- User clicks the sprite’s Pronunciato status bar
- Card opens as an overlay / side panel / anchored modal (implementation depends on current UI shell)
- If another card is already open, opening a new card closes the prior card first

### Exit
- Close button (`X`)
- Clicking another sprite closes current card and opens new one
- Optional click-off close behavior if it does not conflict with playback usability

### Navigation rules
- Overview always opens first
- Tab state does not persist across different sprites
- Optional: tab state may persist for the same sprite during the same session (design decision; default recommend **no** for v1)
- Only one Talk session can be active at a time

---

## 12) Core UI Shell

The following elements are persistent across all tabs:

### Header
- Sprite avatar/photo
- Sprite full display name
- Current sub-action (1-line live subtitle)
- Readable current location
- Close button
- Tabs row

### Header requirements
- Must remain visible while switching tabs
- Must update live if the sprite’s current action or location changes while card is open
- Changes should be visually calm and not jarring

### Example header content
- `Gosha Pistsov`
- `📚🤸 Quick stretch and bookshelf lookup`
- `Oak Hill College · Library Reference Shelf`

---

## 13) Overview Tab (Default)

### Purpose

Fast orientation and immediate attachment.

### Viewer questions answered

* What is happening now?
* Where is it happening?
* Why is it happening?
* What will likely happen next?
* Who is this person?
* What feels delicate right now?
* Who matters most right now?
* Why should I keep following them?

### Overview content blocks

#### A. NOW

Required fields:

* Current action title
* Readable location
* Start time (or started X min ago)
* Duration

#### B. WHY NOW

Editorialized short explanation:

* Why the current action is happening
* Should be a viewer-friendly summary, not raw planner logic

#### C. LIKELY NEXT

* Up to 2 predicted next actions / outcomes
* Predictions should be phrased as likely possibilities, not certainty
* In simple mode, predictions should emphasize near-future routine or social behavior rather than strategic outcomes

#### D. WHO THEY ARE

* 2–3 trait chips
* Social role line
* Core belief / motivation line

#### E. WHAT’S DELICATE RIGHT NOW

* One-line statement of the contradiction, hesitation, or social delicacy that makes this sprite interesting in the current moment
* Preferred framing is social/emotional, not game-theoretic

#### F. CLOSEST CONNECTION

* Current most relevant linked sprite / relationship
* One-line explanation of why that relationship matters now

#### G. WHY FOLLOW THEM NOW

* One-line explanation of why this sprite is worth watching in the next beat

### Example field rendering

* Traits: `Dependable`, `Helpful`, `Conflict-avoidant`
* Social role: `Steady teammate`
* Core belief: `Being useful earns belonging`
* What’s delicate right now: `Wants to help Katya, but hesitates to insert himself too early.`
* Closest connection: `Katya — the person most likely to pull him back into the scene`
* Why follow them now: `He is hovering at the edge of re-entry and may either step forward or stay peripheral.`

### Functional requirements

* All Overview fields must be available without scrolling in the standard desktop card height target whenever possible
* If space is constrained, order of compression:

  1. Why follow them now
  2. Core belief
  3. Secondary predicted next item
* Overview must never show full chat logs, full day plans, or raw memory dumps

---

## 14) Story Tab

### Purpose
Explain the sprite’s recent arc through causal beats, not storage-style memory.

### Viewer questions answered
- What just happened to this sprite?
- How did they interpret it?
- What changed because of it?
- What is unresolved?

### Content structure

#### A. TODAY’S STORY / RECENT STORY
A sequence of 2–4 recent beats, ordered by narrative relevance

Each beat contains:
- **What happened**
- **What it meant to them**
- **What it changed**

#### B. KEY THOUGHT
- One short surfaced internal thought or summary line

#### C. UNRESOLVED THREAD
- One active unresolved tension, desire, or uncertainty

#### D. STORY SO FAR
- One-line arc summary

### Functional requirements
- Default to showing the most relevant 3 beats
- Each beat may be collapsible/expandable
- Story should prefer interpretive summaries over raw note logs
- Time filters may be supported in future (`Today`, `Last 3 days`, `All time`) but are not required for v1
- If insufficient story data exists, show a graceful fallback:
  - `This sprite has not accumulated enough meaningful recent beats yet.`

### Data transformation requirements
Raw memory / event data should be transformed into:
- event summary
- inferred meaning
- resulting change

Backend/AI/system requirement:
- Must support generation of concise, stable beat summaries
- Must not expose sensitive or raw hidden reasoning not intended for viewers

---

## 15) Social Tab

### Purpose

Make the sprite’s social world legible.

### Viewer questions answered

* Who matters to this sprite right now?
* Who do they seek out or avoid?
* What relationships are changing?
* What role do they occupy in the group?
* What recent interaction explains current behavior?

### Content structure

#### A. ACTIVE CONNECTION

* Current most relevant linked sprite
* Relationship status summary
* Why this person matters right now
* Latest interaction summary

#### B. RELATIONSHIPS

List of top 3–5 relevant people with:

* Name
* Relationship summary
* Optional direction/trend indicator:

  * warming ↑
  * worsening ↓
  * stable →
  * distant -
* Optional relationship tags:

  * trust
  * attraction
  * rivalry
  * obligation
  * teamwork
  * avoidance

#### C. GROUP POSITION

* One-line role in group / group self-concept
* Suggested style: `central`, `included`, `peripheral`, `bridge`, `drifting`

#### D. CURRENT SOCIAL DELICACY

* One-line social tension or hesitation in the current moment

#### E. RECENT CONVERSATION

* One summarized latest conversation
* Optional expandable excerpt
* Full transcript should not be shown by default

### Functional requirements

* Show a maximum of 5 relationship rows in v1
* Order by current relevance, not by absolute relationship score
* Relationship rows must be scannable in under 3 seconds
* Full transcript view is out of scope for v1 unless already available as an existing component and can be cleanly hidden behind expand
* Social should explain **motivation and social position**, not just historical relationship score

### Empty state

If the sprite lacks meaningful social data:

* `This sprite has limited recent social activity.`

---

## 16) Day Tab

### Purpose

Explain the sprite’s trajectory through the day in a viewer-friendly way.

### Viewer questions answered

* What are they doing now?
* What comes next?
* What shape does the rest of the day have?
* What obligations or routines are still guiding them?

### Content structure

#### A. NOW

* Current time block
* Current action
* Location

#### B. NEXT

* Up to the next 2 actions/time blocks

#### C. LATER TODAY

* Compact summary of the remainder of the day

#### D. CURRENT OBLIGATIONS

* Up to 3 current relevant requirements or obligations
* Only display obligations that have behavioral relevance

#### E. FULL DAY

* Expandable full day view (optional for v1 depending on existing data model and UI complexity)

### Functional requirements

* By default, do not show a full spreadsheet-like day plan
* Must prioritize `Now / Next / Later`
* Remove duplication with old Plan tab
* If the full day exists, it must live only here, not in Overview
* Label should be **Day** in the UI even if underlying implementation still uses schedule data structures

### Empty state

* `The rest of the day is still forming. Check back after more activity.`

---

## 17) Talk Tab

### Purpose
Provide direct interaction with the sprite as a distinct advanced mode.

### Important note
Talk is **not** part of the core casual viewing flow. It is a deliberate boundary crossing from observing a sprite to interacting with them.

### Viewer questions answered
- Can I ask this sprite directly what they are doing or thinking?
- Can I interact with this sprite beyond passive viewing?

### UX rules
- Talk must look and feel distinct from the other tabs
- Talk should be gated, separated, or visually marked as advanced/private
- Entering Talk should not be accidental

### Recommended v1 behavior
#### State 1: Intro / gated state
- Short explanation of what Talk is
- CTA: `Open Private Chat`

#### State 2: Active Talk
- Suggested prompts:
  - What are you doing?
  - Why are you here?
  - What happens next?
  - How do you feel about [name]?
  - What do you want today?
- Chat input box
- Responses from sprite

### Functional requirements
- Talk is optional in v1 if backend/agent infrastructure is not ready
- If not ready, show disabled state:
  - `Talk with Sprite is coming soon.`
- Must not expose raw internal chain-of-thought or hidden system internals
- Must respect permissions / privacy / entitlement rules if applicable
- Must not auto-persist into all future cards

---

## 18) Field Dictionary

Below is the recommended field set by tab.

### Header fields

* `sprite_id`
* `display_name`
* `avatar_url`
* `current_action_title`
* `current_action_icon_set`
* `current_location_readable`
* `is_card_open`

### Overview fields

* `current_action_title`
* `current_location_readable`
* `action_start_time`
* `action_duration`
* `why_now_summary`
* `likely_next_items[]`
* `traits[]`
* `social_role_summary`
* `core_belief_summary`
* `current_delicacy_summary`
* `closest_connection_summary`
* `closest_connection_sprite_name`
* `why_follow_now_summary`

### Story fields

* `story_beats[]`

  * `event_summary`
  * `meaning_summary`
  * `effect_summary`
  * `timestamp`
* `key_thought_summary`
* `unresolved_thread_summary`
* `story_so_far_summary`

### Social fields

* `active_connection`

  * `linked_sprite_id`
  * `linked_sprite_name`
  * `relationship_status_summary`
  * `why_it_matters_now_summary`
  * `latest_interaction_summary`
* `relationships[]`

  * `linked_sprite_name`
  * `relationship_state_summary`
  * `trend`
  * `tags[]`
* `group_position_summary`
* `current_social_delicacy_summary`
* `recent_conversation_summary`
* `recent_conversation_excerpt` (optional expanded)

### Day fields

* `current_schedule_block`
* `next_schedule_blocks[]`
* `later_today_summary[]`
* `daily_requirements[]`
* `full_day_schedule[]` (optional expanded)

### Talk fields

* `talk_enabled`
* `talk_entry_state`
* `suggested_prompts[]`
* `chat_thread[]`
* `permissions_state`

---

## 19) Information Prioritization Rules

### First screen, no-scroll priority order

1. Current action
2. Readable location
3. Why now
4. Likely next
5. Trait chips
6. What’s delicate right now
7. Closest connection
8. Why follow them now

### Rules

* If information is missing, preserve the structure and degrade gracefully
* Do not insert lower-priority data above higher-priority data just because it is available
* If there is a conflict between completeness and clarity, prefer clarity
* In simple simulation mode, prefer **social meaning** over **mechanical state**

---

## 20) Content Strategy / Tone

### Content style

* Brief
* Readable
* Human
* Specific
* Non-technical
* Low-jargon
* Story-oriented
* Lightly editorialized

### Avoid

* Planner jargon
* Mechanical simulation labels
* Internal ontology names
* Overly clinical personality descriptions
* Long paragraphs
* Overconfident predictions stated as facts
* Faux-survival wording when the mode is not actually high-stakes

### Preferred writing style

* Present tense for live state
* Short explanatory sentences
* Lightweight, editorialized summaries
* Curiosity-driven, not melodramatic

### Good example

`Looking for reference material after the group work discussion. Trying to stay useful without interrupting Katya too early.`

### Bad example

`Planner selected resource acquisition subroutine based on task relevance score.`

### Also bad for launch mode

`At risk if alliance shifts.`

---

## 21) Data & Systems Requirements

### Required system capabilities

1. Real-time or near-real-time current action and location
2. Story beat summarization from recent events
3. Lightweight inference for "why now"
4. Lightweight inference for "likely next"
5. Relationship relevance ranking
6. Compact day extraction
7. Optional direct chat interface for Talk

### Source-of-truth guidance

* Action/location comes from simulation state
* Story/Social summaries may be generated from event/memory data
* Relationship ordering should be based on current relevance, not just historical closeness
* Predicted next actions should come from planner/state inference, but displayed as viewer-friendly summaries
* Day data may continue to use existing schedule/planner structures internally as long as the viewer-facing label remains simple

### Stability requirement

Summaries should not flicker excessively while the card is open.

Recommended update cadence:

* Header action/location: live or near-live
* Overview summaries: update on meaningful beat change, not every tick
* Story/Social summaries: update on event boundaries or scene changes
* Day summaries: update on time-block changes or meaningful reroutes

---

## 22) Permissions & Privacy

### General
The card is viewer-facing and must respect whatever privacy model exists for the simulation.

### Rules
- No hidden internal reasoning should be displayed unless explicitly intended for viewer surfaces
- Talk may require additional permissions, ownership, or private mode access
- If any content is sensitive or restricted, fallback summaries must be used instead of blanks where possible

### Talk-specific
- Talk may expose more personal content than passive tabs
- Talk should be treated as a separate permissions surface

---

## 23) Live Update Behavior

### Card open behavior

The card may remain open while playback continues.

### Live update rules

* Header action/location may update
* Overview "Now" block may update
* Story/Social/Day should not reorder aggressively while user is reading
* If a major scene shift occurs, the card may show a subtle `Updated` indicator rather than hard-reflowing content

### Recommended approach

* Soft update for changed values
* No tab auto-switching
* No scroll position reset while card remains open

---

## 24) Visual Design Guidance

### General

* Clean hierarchy
* Limited color dependency
* Strong typography contrast between section labels and content
* Chip-based traits
* Compact relationship status indicators
* Avoid dense table layouts except optional expanded full day view

### Important visual cues

* Current action should feel “live”
* What’s delicate right now should feel highlighted
* Active connection should stand out in Social
* Day should feel calm and readable, not spreadsheet-like
* Talk should feel visually distinct from passive tabs

---

## 25) Empty States and Fallbacks

### General rule

Every tab must have a graceful empty state.

### Examples

* Overview: `This sprite is between clear actions right now.`
* Story: `This sprite has not accumulated enough meaningful recent beats yet.`
* Social: `This sprite has limited recent social activity.`
* Day: `The rest of the day is still forming.`
* Talk disabled: `Talk with Sprite is coming soon.`

### Missing data handling

* Missing belief or delicacy should not collapse the card
* If predictions are unavailable, omit Likely Next block rather than inventing content
* If relationship list is sparse, show fewer rows cleanly

---

## 26) Performance Requirements

### Targets

* Card open should feel instant or near-instant
* Tab switch should be instant after data load
* Live playback should not noticeably hitch when opening card
* Lazy-load deeper tab data if needed, but Overview should prioritize fast availability

### Suggested loading strategy

* Load header + Overview first
* Load Story/Social/Day in background if not already present
* Talk initializes only when tab opened

---

## 27) Accessibility Requirements

- Keyboard navigable tabs
- Visible focus states
- Text contrast meeting accessibility standards
- Screen-reader-friendly tab labels and section headings
- Icon-only content must include text equivalents
- Status chips must not rely on color alone

---

## 28) Analytics Events

Recommended event instrumentation:

### Open/close

* `sprite_card_opened`
* `sprite_card_closed`

Properties:

* `sprite_id`
* `tab_default`
* `entry_context` (`live_playback`, `post_trailer`, `other`)
* `scene_id`
* `simulation_id`
* `mode` (`simple_simulation`, `reality_mode_future`)

### Tab events

* `sprite_card_tab_viewed`

Properties:

* `tab_name`
* `sprite_id`
* `time_since_open_ms`
* `mode`

### Interaction events

* `sprite_card_relationship_expanded`
* `sprite_card_story_beat_expanded`
* `sprite_card_full_day_expanded`
* `sprite_card_talk_opened`
* `sprite_card_talk_prompt_clicked`
* `sprite_card_talk_message_sent`
* `sprite_card_open_related_sprite`

### Outcome events

* `sprite_card_followed_sprite_again`
* `sprite_card_return_open_same_sprite`
* `sprite_card_open_then_abandon_playback`

---

## 29) QA Test Matrix

### Functional

* Opening a card shows Overview first
* Opening a second sprite closes the first card
* Each tab renders correct content
* Empty states render correctly
* Talk disabled/enabled states behave correctly
* Expanded sections open and close correctly
* Header updates when action/location change

### UX

* First screen answers what/where/why/next clearly
* No duplicate day info outside Day
* Story reads as causal beats, not raw notes
* Social surfaces relationship relevance and group position clearly
* Talk is visually distinct and not easy to trigger accidentally
* Launch labels do not imply competition mechanics that are not actually active

### Data integrity

* Wrong sprite data does not bleed between cards
* Relationship relevance ordering behaves as expected
* Timing/duration displays correctly
* Story beat summaries map to recent events correctly

### Performance

* Card open during playback does not cause noticeable frame drop
* Tab switching remains smooth
* Secondary tab loading does not block Overview

---

## 30) Rollout Plan

### Phase 1 — Structural redesign for simple simulation mode

* New tab architecture
* New Overview
* Story/Social/Day shell
* Empty states
* Analytics instrumentation
* Language pass to remove faux-competition framing

### Phase 2 — Better summarization

* Improved why/next generation
* Better story beat editorialization
* Better relationship ranking and group-position summaries

### Phase 3 — Talk mode

* Gated Talk intro state
* Prompt-based chat
* Permissions model
* Safety / privacy tuning

### Phase 4 — Reality-mode emphasis shift (future)

* Evaluate whether Day should become Stakes in a stronger challenge/vote format
* Add mode-aware labels and higher-pressure summaries only when the product loop actually supports them

---

## 31) Migration from Current Card

### Current -> New mapping

* `Info` -> folded into `Overview`
* `Actions` -> folded into `Day`
* `Plan` -> folded into `Day`
* `Memory` -> becomes `Story`
* `Chats` -> partial summaries move into `Social`
* `Chat` -> becomes `Talk`

### Removal guidance

* Remove duplicate day overview from Plan
* Remove database-like duplication between Info/Actions/Plan
* Hide full chat logs behind expansion or omit in v1
* Do not expose raw note dumps as primary content

---

## 32) Open Questions

1. Should the card be a side panel or modal at current screen sizes?
2. Should the same card have compact and expanded sizes?
3. How much persistence should there be for the currently selected tab on reopen?
4. How stable are generated "why now" and "likely next" summaries across rapid state changes?
5. What exact permissions or ownership rules apply to Talk?
6. Should Social support mini relationship portraits in v1?
7. Should Story default to "today" only in v1?
8. When reality-mode mechanics become primary, should **Day** remain, coexist with **Stakes**, or be replaced by **Stakes**?

---

## 33) Final Recommendation

Implement the Sprite Detail Card as a **single reusable shell with a simple-simulation-first default**:

* A standardized **story stack** at the top layer (Overview) for universal orientation
* A set of deeper tabs for user-driven curiosity (Story, Social, Day)
* A separate advanced boundary-crossing mode for direct interaction (Talk)

This preserves fast readability while still supporting depth and repeat engagement.

The launch card should make a viewer feel:

* `I get what this sprite is doing`
* `I understand why it matters to them`
* `I know who matters around them`
* `I want to keep following them`

The later reality-mode card can raise pressure and stakes without forcing a redesign.

---

## 34) Appendix — Example Content Snapshot

### Example sprite

**Gosha Pistsov**

### Header

* `📚🤸 Quick stretch and bookshelf lookup`
* `Oak Hill College · Library Reference Shelf`

### Overview

* **Why now:** Looking for reference material after group work discussion. Trying to stay useful without interrupting Katya too early.
* **Likely next:** Return to table with materials; rejoin Katya
* **Traits:** Dependable, Helpful, Conflict-avoidant
* **Social role:** Steady teammate
* **Core belief:** Being useful earns belonging
* **What’s delicate right now:** Wants to help Katya, but hesitates to insert himself too early.
* **Closest connection:** Katya — the person most likely to pull him back into the scene
* **Why follow them now:** He is close enough to matter, but not yet committed enough to step in.

### Story

* Katya asked for help sorting materials
* Meaning: Gosha read it as trust
* Effect: He stayed nearby and started searching for useful materials
* Unresolved thread: Wants recognition, avoids direct ask

### Social

* Katya — warming ↑ — trust growing
* Misha — distant -
* Teacher — neutral →
* Group position: included, but not central
* Latest interaction: Katya asked Gosha for help with materials

### Day

* Now: bookshelf lookup
* Next: return to table
* Later: class activity, lunch, homework block

### Talk

* Suggested prompts:

  * What are you doing?
  * Why are you here?
  * What happens next?
  * How do you feel about Katya?

---

## 35) Backend Endpoint Specification

This section defines the API contract the backend team must implement to power the redesigned Sprite Detail Card. The frontend will consume this endpoint alongside the existing `/details` endpoint and degrade gracefully when it is unavailable.

### Endpoint

`GET /api/simulations/{sim_code}/personas/{persona_name}/card-summary`

**Path parameters:**
- `sim_code` (string, required) — simulation identifier
- `persona_name` (string, required) — URL-encoded persona display name (same convention as existing `/details` endpoint)

**Query parameters:**
- `step` (integer, optional) — simulation step to generate summary for. If omitted, uses current/latest step. Required for playback-mode cards at historical steps.

### Response — `200 OK`

All field names use **snake_case**. Fields marked **LLM** require language-model generation. Fields marked **derived** can be computed from existing simulation state without an LLM call. Fields marked **passthrough** are direct copies from existing data.

```jsonc
{
  // ── Envelope ──────────────────────────────────────────────
  "persona_name": "string (required)",
  "generated_at_step": 15,                    // step this summary was generated for
  "generation_timestamp": "2026-03-31T...",   // ISO 8601

  // ── Header (always populated, no LLM) ────────────────────
  "header": {
    "display_name":              "string (required)",
    "avatar_url":                "string | null",       // derived — from sprite manifest
    "current_action_title":      "string (required)",   // passthrough — actionDescription
    "current_action_emoji":      "string (required)",   // passthrough — actionPronunciatio
    "current_location_readable": "string (required)"    // derived — see Location Formatting
  },

  // ── Overview ──────────────────────────────────────────────
  "overview": {
    "action_start_time":         "string",   // derived — human-readable, e.g. "10:15 AM"
    "action_duration_minutes":   10,          // derived — parse actionDuration
    "why_now_summary":           "string | null",   // LLM
    "likely_next_items": [                          // LLM — max 2 items
      { "action_summary": "string", "confidence": "likely | possible" }
    ],
    "traits":                    ["string"],  // derived — split innate on commas, first 3
    "social_role_summary":       "string | null",   // LLM
    "core_belief_summary":       "string | null",   // LLM
    "current_delicacy_summary":  "string | null",   // LLM
    "closest_connection": {                         // LLM + relationship data
      "sprite_name": "string | null",
      "summary":     "string | null"
    },
    "why_follow_now_summary":    "string | null"    // LLM
  },

  // ── Story ─────────────────────────────────────────────────
  "story": {
    "beats": [                                      // LLM — 2-4 items, from memoryEvents + thoughts
      {
        "event_summary":   "string (required)",
        "meaning_summary": "string (required)",
        "effect_summary":  "string (required)",
        "timestamp":       "string (required)"      // ISO 8601
      }
    ],
    "key_thought_summary":        "string | null",  // LLM — from highest-depth thought
    "unresolved_thread_summary":  "string | null",  // LLM
    "story_so_far_summary":       "string | null"   // LLM
  },

  // ── Social ────────────────────────────────────────────────
  "social": {
    "active_connection": {                          // LLM — most relevant current relationship
      "linked_sprite_name":          "string",
      "relationship_status_summary": "string",
      "why_it_matters_now_summary":  "string",
      "latest_interaction_summary":  "string"
    } | null,
    "relationships": [                              // LLM — max 5, ordered by current relevance
      {
        "linked_sprite_name":        "string (required)",
        "relationship_state_summary":"string (required)",
        "trend":                     "warming | worsening | stable | distant",
        "tags":                      ["trust | attraction | rivalry | obligation | teamwork | avoidance"]
      }
    ],
    "group_position_summary":         "string | null",  // LLM — e.g. "included, but not central"
    "current_social_delicacy_summary":"string | null",  // LLM
    "recent_conversation_summary":    "string | null",  // LLM — from latest conversationHistory
    "recent_conversation_excerpt":    [["speaker", "utterance"]]  // passthrough — first 3 lines of filling
  },

  // ── Day (no LLM required) ────────────────────────────────
  "day": {
    "current_block": {                              // derived — from dailySchedule + currentTime
      "time":     "string",
      "activity": "string",
      "location": "string | null"
    } | null,
    "next_blocks": [                                // derived — up to 2 upcoming items
      { "time": "string", "activity": "string" }
    ],
    "later_today_summary": ["string"],              // derived — remaining schedule items
    "daily_requirements":  ["string"],              // passthrough
    "full_day_schedule": [                          // passthrough
      { "activity": "string", "duration_minutes": 10 }
    ]
  },

  // ── Talk ──────────────────────────────────────────────────
  "talk": {
    "enabled": false,                               // feature flag — false for v1
    "suggested_prompts": [
      "What are you doing?",
      "Why are you here?",
      "What happens next?",
      "How do you feel about [closest connection]?",
      "What do you want today?"
    ]
  }
}
```

### Location formatting

`current_location_readable` is derived from `actionAddress` by:
1. Stripping the world prefix (e.g. `the Ville:`)
2. Replacing `:` separators with ` · ` (middle dot with spaces)
3. Example: `the Ville:Oak Hill College:library:reference shelf` → `Oak Hill College · Library · Reference Shelf`
4. Title-case each segment

### Field source guidance

| Field | Source | LLM Input Context |
|-------|--------|-------------------|
| `header.*` | Existing state + sprite manifest | N/A |
| `overview.action_start_time` | `actionStartTime` reformat | N/A |
| `overview.action_duration_minutes` | Parse `actionDuration` | N/A |
| `overview.traits` | Split `innate` on commas, trim, first 3 | N/A |
| `overview.why_now_summary` | **LLM** | Current action + recent memory + schedule context |
| `overview.likely_next_items` | **LLM** | Current action + schedule + planner state |
| `overview.social_role_summary` | **LLM** | Relationship data + recent group interactions |
| `overview.core_belief_summary` | **LLM** | `innate` + `learned` + `lifestyle` + recent thoughts |
| `overview.current_delicacy_summary` | **LLM** | Recent events + current social context |
| `overview.closest_connection` | **LLM** + relationship data | Pick highest-relevance relationship |
| `overview.why_follow_now_summary` | **LLM** | Current tension/delicacy + predicted next |
| `story.beats[]` | **LLM** from `memoryEvents` + `thoughts` | Transform raw events into causal beats |
| `story.key_thought_summary` | **LLM** from `thoughts` | Highest-depth recent thought, rephrased for viewer |
| `story.unresolved_thread_summary` | **LLM** | Events + incomplete goals |
| `story.story_so_far_summary` | **LLM** | Full arc summary |
| `social.active_connection` | **LLM** + conversation data | Most relevant current connection |
| `social.relationships[]` | **LLM** + `conversationHistory` + memory | Trend/tags from conversation + memory analysis |
| `social.group_position_summary` | **LLM** | Relationship graph analysis |
| `social.current_social_delicacy_summary` | **LLM** | Current social tensions |
| `social.recent_conversation_summary` | **LLM** from `conversationHistory[0]` | Summarize latest conversation |
| `social.recent_conversation_excerpt` | Passthrough `conversationHistory[0].filling` | First 3 lines |
| `day.*` | Existing `dailySchedule`, `dailyRequirements`, `currentTime` | N/A |
| `talk.*` | Config/feature flag | N/A |

### LLM prompt guidance

All LLM-generated fields should follow these content rules (from PRD Section 20):
- **Present tense** for live state
- **Brief, readable, human, specific, non-technical** language
- **No planner jargon**, internal ontology names, or mechanical simulation labels
- **Curiosity-driven** framing, not melodramatic
- **Short explanatory sentences** — one to two sentences max per field
- **Lightly editorialized summaries** that help a viewer read the story
- Example good: `"Looking for reference material after the group discussion. Trying to stay useful without interrupting Katya too early."`
- Example bad: `"Planner selected resource acquisition subroutine based on task relevance score."`

### Update cadence

| Section | Regenerate When | Cache Duration |
|---------|----------------|----------------|
| `header` | Live / near-live (every request) | No cache |
| `overview` summaries | Action changes (new `actionDescription`) or every 5 steps | 10 steps |
| `story` / `social` | Event boundaries (conversation completed, new memory with depth >= 2, scene change) | 10 steps |
| `day` | Time-block transitions | 5 steps |
| `talk` | Feature flag change only | Long |

### Caching

Response header: `Cache-Control: max-age=10, stale-while-revalidate=30`

Include an `etag` field in the response envelope so the frontend can skip re-renders when summaries haven't changed between requests.

### Error responses

**Partial data (LLM unavailable for some fields):**
Return `200 OK` with `null` for unavailable LLM fields. The `header` and `day` sections must always be fully populated since they require no LLM. The frontend detects null summary fields and renders fallback UI from existing `/details` data.

**Persona not found:**
```json
{ "error": "persona_not_found", "message": "No persona 'X' found in simulation 'Y'" }
```
Status: `404`

**LLM service entirely unavailable:**
```json
{ "error": "summarization_unavailable", "message": "Summary generation is temporarily unavailable" }
```
Status: `503` — frontend falls back entirely to existing `/details` endpoint data.

### Backward compatibility

The existing `GET /api/simulations/{sim_code}/personas/{persona_name}/details` endpoint remains **unchanged**. The new `/card-summary` endpoint is **additive**. The frontend calls both in parallel during the transition period and degrades gracefully when `/card-summary` returns 404, 503, or partial data.