# Video SOT — Doubland Trailer System

> **Archived 2026-08-28.** Live video SOT is `video/daily/SOT-new-daily.md`. Do not brief from this file. Opener WIP remains `video/opening/TODOs-opening-trailer.md` (old scene map §10 here).

> **Nav:** [Opener WIP](opening/TODOs-opening-trailer.md) · [Opener implementation](opening/opening-15person/20260617_vertical-trailer-automation.md) · [Opener visual timing](opening/opening-15person/teadown/) · [**Daily SOT — Tonight’s Scar (DEV)**](daily/SOT-new-daily.md) · [Survival daily WIP (legacy encyclopedia)](TODO_video.md) · [2D↔3D blend](daily/daily-2D-3D-blend.md) · [Video playbook](video_playbook.md) · [Prompts](prompts.md) · [Archive history](archive/sot-video-history.md) · Engineering PRD: `video/video_PRD.md`

Authoritative source of truth for Doubland's **three trailer types**. Part I is shared creative grammar (all types inherit). Part II is per-type contracts. Part III is locked production status and recent changelog — not active task lists.

| Part | Contents |
|---|---|
| **I** | Shared grammar — quality bar, motion system, pipeline, text/transitions/audio, assets, validation |
| **II** | Type contracts — [A] opener · [B] `day_normal` · [C] `day_survival` |
| **III** | Production status + pipeline changelog |

---

## Trailer briefs (in production)

One-line product briefs for the three trailer types. Craft contracts, scene maps, and laws live in §0–§12 below. Older hero/playbook beats that conflict with this taxonomy are guidance only — **this SOT wins**.

### [A] Opening trailer — viral season intro

| | |
|---|---|
| **Conveys** | What Doubland is and what a Double is; that a real cohort’s Doubles are already alive in a season; Survival Mode exists and starts soon. Lean: concept → group cast at a glance → close tease. No per-Double spoken intros, no survival mechanics in the body. |
| **Audience** | Cold social traffic and share loops first (growth asset). Secondary: the masked cohort (e.g. L-Talks) who should recognize “this is us” without the video becoming an inside joke. |
| **Walk away with** | A personal *What if…?* within ~10s; “I want my own Double”; know a season/cast exists and where to go (`doubland.ai`); itch to watch Episode 1 — close hook: *what would MY Double do?* |

### [B] Normal-day daily (`day_normal`) — meet the cast as people - **DO WE ACTUALLY NEED THIS TYPE oF TRAILERS?**

| | |
|---|---|
| **Conveys** | Brief Doubland reminder, then **every** cast member in their simulation habitat: who they are (role + spoken trait/want line), how a normal day feels before elimination pressure owns the story. Close tease toward the season/Survival. |
| **Audience** | Viewers who already saw the opener (or need a cast primer) — especially people who will follow dailies and need faces, jobs, and places before Survival Day 1. Not the primary cold-viral asset. |
| **Walk away with** | Can name several Doubles as people (not vote pieces); knows where they “live” in the sim; feels ready to care when the season turns competitive; still wants their own Double / to invite their circle. |

### [C] Survival-day daily (`day_survival`) — today’s episode of the show

| | |
|---|---|
| **Conveys** | A moment-driven recap of one Survival day: who mattered, what the challenge meant, what turned, who paid the cost, and what hangs open tomorrow. First features get full job + place + **want** stamps so cold watchers can meet people; returnees get short recall. Cliff + `doubland.ai`. |
| **Audience** | Day-to-day season followers (primary). Must still work for a cold viewer dropping into a single episode — stamps and one clear arc beat do that work. |
| **Walk away with** | Can say who the leads were, what the challenge decided, who went home (or who’s exposed), and tomorrow’s open question; feels real pressure without needing the full season; clicks through to watch/chat live — and optionally pictures *their* Double on a night like this. |

---

## Open questions for expert review

> For scenario writers, video producers, reality-TV format experts, and psychologists. These are **not locked**. Suggest a way forward; do not treat current VO lines as doctrine.

### Product capabilities we may need to teach (or not)

Public product promise at **doubland.ai** (landing / brand triad — what trailers may eventually need to make *felt*, not just listed):

| Capability | Plain meaning | Trailer risk if over-taught |
|---|---|---|
| **Watch live 24/7** | The village keeps running; trailers are highlights, not the whole show | Sounds like a stream, not a living world |
| **Follow any Double** | Pick a person and stay with them | Cast becomes a menu, not a cast |
| **Replay every moment** | Rewind / scrub any beat of the day | Feels like VOD UI, kills drama |
| **Zoom into any event** | Drop into a specific chat, vote, challenge beat | Explainer tone; runtime bloat |
| **Chat with any Double** | Talk to a persona (user ↔ Double) | Can read as chatbot, not social sim |
| **Create your Double + invite your group** | Primary conversion — your people, your village | Competes with “watch this season” CTA |

**Current trailer placement (as of 2026-07):**

| Type | Mechanics / interaction today | Notes |
|---|---|---|
| **[A] Opener** | Close: *Watch live 24/7. Follow any Double.* + Survival tease + *what would MY Double do?* + `doubland.ai` | Locked L1: **no Survival rules in the body** — rules only as close tease. Feature triad is abbreviated (no explicit “replay / zoom / chat” in L-Talks locked VO). |
| **[B] `day_normal`** | Stub only — concept reminder + per-Double habitat intros planned | No interaction-reminder pattern locked yet. |
| **[C] `day_survival`** | Story first; CTA often *watch today’s chats / challenge / ballots at doubland.ai* + optional *picture your Double there with your people* | Interaction is mostly **end CTA**, not mid-story teaching. Runtime already tight under L10; **clarity rewrite in flight** on Day-1 package (V0 rejected 2026-07-16). |

**Tension we feel:** every daily that re-explains the product dilutes the episode; every daily that *never* reminds risks cold viewers treating Doubland as “just another reality clip” with nowhere to go.

---

### Q1 — Where (and how often) do we introduce simulation mechanics & interaction?

**Ask:** Where should we introduce *how the simulation works* and *what a user can do at doubland.ai* (chat with any Double, replay any moment, zoom into any event of the day, follow anyone live)? Does it make sense to **remind** viewers of this across the course of daily trailers ([B]/[C]), or should that job stay almost entirely in [A] / landing?

**Context experts should use:**

1. **Three trailer jobs differ.** [A] sells the concept + season itch. [B] sells the cast as people. [C] sells *today’s* pressure. Mechanics that fit one may hurt another.
2. **Survival format vs product UI.** Survival rules (eliminate until one remains, challenges, votes) are *show* mechanics. Follow / replay / chat / zoom are *product* mechanics. Experts: keep them separate, braid them, or never mix?
3. **Runtime tax.** [C] already spends seconds on first-feature stamps (job + place + want) so cold viewers meet people. Adding a recurring “here’s what you can do on the site” beat competes with challenge → turn → cost → cliff.
4. **Habituation.** If every daily ends with the same feature triad, does it become invisible — or is repetition the brand (like a network bumper)?
5. **Truthfulness.** Trailers should not promise UI the live product cannot deliver that week. Prefer recommending *which* interactions to teach first vs a full feature dump.

**What a useful answer looks like:** proposed placement by type ([A]/[B]/[C]), frequency (every episode / every N days / only when story needs it / never in VO — visual only), sample beat length, and what *not* to say.

---

### Q2 — Cold viewer lands on a random episode — still convert?

**Ask:** How do we ensure that even if a cold viewer sees a **random** simulation episode ([C] mid-season, or [B] out of order), they still: (1) get the idea of Doubland, (2) feel motivated to open **doubland.ai**, (3) get curious for the *next* trailer, and (4) become willing to **create their own Double and play with their group**?

**Context experts should use:**

1. **Distribution reality.** Dailies will be clipped and shared alone. We cannot assume the viewer saw [A] first. L11 first-feature stamps exist so mid-season [C] still introduces people as humans — but stamps alone do not teach “this is a product you can run with *your* friends.”
2. **Two conversion targets compete.** *Watch this season* (follow L-Talks / Press Play) vs *start your own Doubland* (create + invite). Landing primary CTA is **Create your Double**. Trailers currently lean season-watch + personal mirror question. Experts: sequence, dual CTA, or one primary per type?
3. **What “get the idea” must include (minimum viable literacy).** Candidate checklist — mark which are mandatory in a cold [C]:
   - Doubles = AI versions of real people, choosing on their own  
   - You can watch the living sim (not only the trailer)  
   - You can start the same kind of world with *your* people  
   - Survival / day’s stakes (only if the episode is Survival)  
   - Specific UI verbs (chat / replay / zoom) — optional vs required?
4. **Psychology of the close.** Current hooks lean *what would MY Double do?* and *picture your Double there — with your people — on a night like this.* Is that enough for ownership desire, or do we need a clearer “you are the founder of your village” beat (playbook hero Concept 1.3)?
5. **Return loop.** Curiosity for *tomorrow’s* trailer vs one-time site visit — different creative jobs. Scar / cliff (L13) serves return; CTA serves explore; personal mirror serves create. Experts: which must appear in every cold-safe [C]?

**What a useful answer looks like:** a cold-viewer minimum for each trailer type; a recommended CTA ladder (curiosity → explore site → create Double); and which story beats are sacred vs which can flex when runtime is short.

---

### Constraints experts should not break without calling it out

- Taxonomy L1–L13 in §0.2 (lean [A]; per-Double intros in [B]; [C] story-first + first-feature stamps + spicy coverage + scar continuity).
- Shared craft: warm narrator who never mocks Doubles; 9:16 same-show grammar; end card pattern with `doubland.ai`.
- Temporary terminology exception (L5): first-touch “AI version of you” OK if it resolves into brand voice.
- Do not invent facts about a day’s challenge, votes, or chat — daily VO is fact-locked to the simulation ledger.

---

## 0. Trailer-type taxonomy & locked decisions

### 0.1 Trailer types

| Type | Name | Job | Duration | Scene map |
|---|---|---|---:|---|
| **[A]** | **Opening trailer** | Introduce Doubland + season cast at a glance; **shareable viral growth asset**. Lean — no per-Double intros, no survival mechanics in the body. | **~60s** | §10 |
| **[B]** | **Normal-day daily** (`day_normal`) | Brief concept reminder + **introduce every cast member in their simulation habitat** (role + normal-day beat) + close tease. Per-Double intros and spoken trait lines live here. | **60–90s** | §11 (TBD) |
| **[C]** | **Survival-day daily** (`day_survival`) | Moment-driven survival recap — pressure, stakes, cliffhanger close. | **<120s** | §12 · active WIP `TODO_video.md` |

**Same show, next episode.** All three share format, motion system, voice, end-card pattern, and validators. Type differences are **content and scene map**, not craft.

### 0.2 Locked decisions (2026-07-02)

| # | Decision | Rationale |
|---|---|---|
| L1 | Opener [A] is **lean**: concept intro + group cast overview + survival tease at close. No per-Double spoken intros, no survival mechanics in the body. | Viral growth asset, not a cast reveal. Per-Double intros → [B]. |
| L2 | Per-Double intros + spoken trait lines → **[B] `day_normal`**. | Natural home for 15 locked trait lines and habitat beats. |
| L3 | Two daily modes: `day_normal` [B] and `day_survival` [C], each with its own contract. | Pre-survival vs survival days have different story jobs. |
| L4 | Playbook **6-emotion sequence is guidance**, not a separate deliverable. Opener [A] absorbs those principles. | One primary viral asset. |
| L5 | **Terminology exception (temporary, global).** "AI version of you", "AI Doubles of real people", "AI twin of your personality" permitted for first-touch clarity until Doubland is self-evident; then drop. | Supersedes forbidden-terms in older daily brand notes (now rolled into `TODO_video.md`) for now. |
| L6 | Opener [A] **~60s** (lean, no per-Double block). | Viral-share length; tighter than Anya reference cut. |
| L7 | **Season masking:** cohort display names masked externally. Pilot: `soul15_seed_20260224` → **L-Talks** · season **Press Play**. | Cohort recognizes itself; asset stays shareable. |
| L8 | **Simulation literacy:** Doubles read as pixelated in the interface; lived moments may resolve into cinematic reality. Trailers train viewers to **watch Phaser and see real life** — 2D is the system, 3D punctuates truth. Opener [A] establishes the duality (matrix, cinematic tease); dailies [B]/[C] execute it per `daily/daily-2D-3D-blend.md` (summary also in `TODO_video.md`). | Product north-star; brand philosophy in [video playbook](video_playbook.md) §Core 2D↔Cinematic. |
| L9 | **[B] `day_normal` 60–90s.** | Room for per-Double habitat intros; still under a minute at the short end. |
| L10 | **[C] `day_survival` default ship <120s** (`length_mode=short`: target 45–60s / soft warn >90s / hard 120s per daily SOT). **Experimental `long` lane** may exceed 120s under an explicit flag for user-feedback A/B (strawman warn >150 / hard 180 until founder locks) — never silently overrun the short lane. | Survival recaps need more story beats than normal-day dailies; long cut tests deeper bonding. |
| L11 | **First-feature intro memory (F1, 2026-07-10; VO stamp clarified 2026-07-15; day-projection want 2026-07-16; role clause reaffirmed 2026-07-29).** Per `sim_code`, the first time a Double is **featured** or gets a **named farewell**, spoken VO uses a full stamp: **job + place + day-projection want**. The **job+place** clause is required spoken (one kid-plain line) and should sit on habitat picture. The want is **not** a durable bio/scratch desire — it is a kid-plain projection of that Double’s personality onto **this day’s** events and dynamics (omit if evidence is too thin; never clinical trait labels; never silent role fallbacks as if bio-sourced). Cast cards may still show a short trait line; **VO stamp want is day-projection**. Later appearances → short recall. **Survival Day 1** (engine day 2) always forces full stamps. History written only on script **lock** (`lock_day_script`), never on draft generate. Challenge teach VO/visuals: `sot_challenges.md` §5 teach packs. | Cold viewers meet people under tonight’s pressure, not vote pieces or fixed personality labels; returnees don’t burn runtime re-introducing. |
| L12 | **Spicy cast ranking + coverage (2026-07-10).** Featured leads sort by drama-gap `rank_score` (amplify vs day median); locations lightly weighted; soft story-role bonuses (elim +2, immunity +3, top vote-receivers +3). **Never** restore elim +50. Last of top-N prefers highest-spicy **alive never-featured** (F1 history: featured\|farewell). Farewell still covers boots who never led. | Viewers can’t guess the boot from cast order alone; every Double gets screen time at least once. |
| L13 | **Prior-day scar cards (F3, 2026-07-10).** On lock, write compact continuity (`scar.json` + `double.trailer_day_scar`): thesis, featured, elim, status deltas — not full VO. Engine day ≥3 loads last 1–2 scars into producer/writer. Prior-day “Previously on” uses season-day indexing (not raw engine−1). Operator locks Day N before generating Day N+1. | Day N+1 continues yesterday’s arc without inventing continuity. |

### 0.3 Voice, tone & brand (shared)

**Voice:** warm omniscient narrator — see [video playbook](video_playbook.md) for full register. **Never mocks the Doubles.** ElevenLabs `eleven_v3` warm @ **1.2×** locked (opener + daily; API max).

**Terminology (L5):** first-touch override lines permitted; must immediately resolve into brand voice ("your Double", "personality twin", "the version of you that…").

**Emotion arc (opener guidance, L4):**

| Beat | Emotion | What lands it |
|---|---|---|
| Cold open | Intrigue + "What if?" | Eye, loading iris, frozen moment |
| Concept | Recognition | Device controls, identity card |
| Cast overview | Discovery | Group photo + matrix + season reveal |
| Close / tease | Participation | "Pressed play" → URL → survival tease |

**Success criteria (all types):** viewer forms "What if ___?" within 10s; Double recognition in first 15s (opener) or per-Double in [B]; ends wanting their own Double; every transition reveals a deeper layer.

**Duration policy:** exact runtime is not a hard gate. Targets by type (L6, L9, L10): **[A] ~60s** · **[B] 60–90s** · **[C] <120s**. Section timings and validator bands are pacing guidance, not pass/fail on total seconds alone.

---

## 1. Doc map

| Document | Role |
|---|---|
| **This doc** | Shared grammar (Part I) + type contracts (Part II) + status (Part III) |
| **`opening/TODOs-opening-trailer.md`** | Active opener [A] WIP — archive when done, then update §10 + §13 here |
| **`TODO_video.md`** | Active [C] survival-daily WIP (picture pass + gates) |
| **`opening/opening-15person/teadown/`** | Opener visual timing — ~50 sub-moments, timecodes, text/SFX logs |
| **`opening/opening-15person/20260617_vertical-trailer-automation.md`** | Opener engineering — built state, Phase 6 backlog |
| **`daily/daily-2D-3D-blend.md`** | Simulation literacy execution — when/how Phaser/sketch resolves into cinematic life ([B]/[C]; especially [C] arc beats) |
| **`prompts.md`** | AI asset-generation prompts catalog |
| **`generative_agents/.../scripts-prompts/!prompts.md`** | Codegen script templates (engineering repo) |
| **`archive/sot-video-history.md`** | Pre-Remotion diagnostic, commission tracker, implementation phases |

On **visual timing, sub-moments, on-screen copy, SFX sync** → `opening/opening-15person/teadown/` CSVs. On **asset policy, cast scale, mix, validation** → Part I below. On **2D↔3D blend rules** → `daily/daily-2D-3D-blend.md`. On **daily implementation backlog** → `TODO_video.md`.

---

# Part I — Shared grammar

## 2. Quality bar

Hand-edited reference: `DOUBLAND1.mov` — **76.6s**, native 2160×3840, **~23.5 visual changes/min**, integrated loudness ~**-13.1 LUFS**. Automation targets 1080×1920; compare using master-derived grabs from `teadown/`.

**Primary gap:** automation still maps VO segments to static scenes (~9 visual changes/min on early builds). The reference is a **continuous visual journey** — one idea transforms into the next via motion, scale, light, shape, or position — not slide-per-narration-line.

**Required system behaviour (summary):**

- Decouple visual timeline from narration (2–4 micro-beats per VO line; sequences span multiple lines).
- Motivated handoffs, not bare crossfades (shared shape/position/color/subject).
- 3+ depth planes on important beats (atmosphere + environment + subject + UI + caption + accent).
- Transform repeated assets (matrix scan, crop, graph) — never wallpaper.
- Text: animate into readability, then hold still ≥0.8s.
- Audio punctuation on structural transitions, not every text animation.

Full opener&005/006 diagnostic tables → `archive/sot-video-history.md`. Remaining automation gaps → automation doc Phase 6A–6D.

---

## 3. Creative grammar

### 3.1 Macro rhythm

Typical opener **[A] target ~60s**; flexible for larger casts but should stay near viral-share length. Producer-measured boundaries in Anya's **76.6s** reference (`teadown/20260624_doubland_timecode_index.csv`) inform **pacing structure**, not target runtime.

| Section | Typical duration | Energy purpose |
|---|---:|---|
| Hook | 0–11s *(producer: ~0–10.8)* | Curiosity; abstract buildup |
| Product concept | 11–19s *(~10.8–19.5)* | What a Double is |
| World + relationships | 19–32s | Scale; simulation life |
| Season premise | 32–41s | Stakes framing; mode shift |
| Cast | 41–53s | Personality; panel → character → panel |
| Pressure + transformation | 53–61s | Gauge peak; mid-trailer URL ~59.4s |
| Live / replay + reflective turn | 61–72s | Feature montage |
| End card | final ~4.9s *(~71.7–76.6)* | `questionToUrlTakeover` — not a long static tail |

### 3.2 Micro rhythm

Meaningful visual development every **1.0–2.5s**: new subject, camera push, UI reveal, text swap, lighting change, relationship edge, crop, motivated handoff, or SFX-synced accent. Pattern: **enter → develop → transform → hand off**.

### 3.3 Visual richness budget

Per major beat: one focal subject + one information layer + one ambient layer + two depth planes + one development + one connection to the next beat. Reject beats that are static background + caption for >1.5–2s.

### 3.4 Motion hierarchy

One primary motion, ≤2 secondary, ambient motion subordinate to text, clear settle point. No default continuous pulsing, floating, or glitching.

| Beat | Primary | Secondary |
|---|---|---|
| Hook | camera push into ring | slow particles |
| Conversation | chat panels building | scan line |
| World | map drift | nodes illuminating |
| Cast | subject reveal | trait line typing |
| Pressure | gauge sweep | one light pulse |
| End card | logo resolve | restrained particles |

---

## 4. Pipeline architecture

Spec-driven trailer compiler:

```text
Simulation data → cast/conflict selector → showrunner script → narration timing
  → visual beat planner → asset resolver → TrailerSpec JSON
  → Remotion motion system → audio mix + SFX → validator → MP4 + poster + QA
```

### 4.1 Cast and conflict selector

Balance story importance, relationship centrality, personality contrast, conflict potential, asset quality, cast diversity. Use maximal-marginal-relevance so featured Doubles are not redundant.

### 4.2 Visual beat planner

Inputs: script segments, word-level timing, producer sub-moment index (`teadown/timecode_index.csv`), `text_log.csv`, `sfx_log.csv`, semantic tags, cast size, assets, relationships, season mode, runtime, style profile.

Outputs: **~40–60 visual sub-moments** (not one per VO segment), each naming a transition primitive (§6) where applicable.

### 4.3 Asset resolver

Pick best valid asset per role from manifest metadata (§8). Never silently use another cohort's portraits. On missing required asset: generate, branded fallback, or fail with clear report.

### 4.4 TrailerSpec

Single JSON describes the edit before render. Renderer executes the spec — it does not make editorial decisions. See `archive/sot-video-history.md` for full example schema.

---

## 5. Text-motion system

```ts
type TextMotionMode =
  | "type-then-hold" | "fade-up-then-hold" | "word-swap" | "impact-once" | "static";
```

**`type-then-hold`:** type while spoken → remove cursor within 4–8 frames → remove glitch copies → hold still ≥0.8s → exit on beat transition.

**`impact-once`:** single emphasis on `DOUBLE`, `SURVIVAL`, `LOW`, `MY` — no infinite pulse.

**Legibility:** max two copy levels; safe areas for social UI; contrast pass; vertical line length; no unfinished lines at scene exit.

---

## 6. Transition system

**Required Remotion primitives:**

| Primitive | Use |
|---|---|
| `sharedCenterReplace` | WHAT IF / answer / DOUBLE / captions swap on one axis |
| `persistentLayerSwap` | Lower figures stay; upper layer changes |
| `cardSelectZoom` | ACTIVE DOUBLES panel → selected card expands |
| `radialObjectMatch` | Circle/blur resolves into next subject (e.g. portrait → gauge) |
| `textHoldAcrossBackgroundCut` | Headline frozen; background hard-cuts |
| `questionToUrlTakeover` | End card: setup → question → URL overlap → short hold |

**Preferred handoffs:** match-scale, shared-position, parallax push, light sweep, UI expansion, shape morph, foreground wipe, audio-led cut.

**Crossfades only when:** time passing, tone softening, similar environments blending, or another moving layer prevents flat dissolve.

**Acceptance:** every major transition must answer *what outgoing element motivates the incoming shot?* If "nothing; it just fades" — replan.

---

## 7. Audio

### 7.1 Voice

ElevenLabs **`eleven_v3`**, warm stability **0.60**, speed **1.2×** (API max; do not send 1.5) — locked for opener and daily. Pronunciation: `Doubland` / `doubland.ai` → fused `Dubland` / `dubland` via `TTS_PRONUNCIATION_OVERRIDES` in `tts.py` (**no hyphen** — hyphenated `Dub-land` made TTS say “dash”).

### 7.2 Mix targets

| Target | Value |
|---|---|
| Integrated loudness | ~**-14 LUFS** |
| True peak | ≤ **-1 dBTP** |
| Music under speech | duck **3–5 dB** |
| Music rise | visual-only transitions + pressure peak |

### 7.3 SFX

Tagged library: `whoosh_soft`, `whoosh_fast`, `digital_reveal`, `typing`, `scan`, `connection_pulse`, `impact_low`, `riser_short`, `logo_resolve`, `ambient_village`, `pressure_alert`.

**Rules:** SFX on structural transitions and character intros, not every text animation; begin 2–6 frames before visual event when appropriate; align with `sfx_log.csv` for opener producer pass (±0.2s).

---

## 8. Asset & component system

### 8.1 Asset roots

| Alias | Path (engineering repo) |
|---|---|
| `anya-motion/` | `generative_agents/video/opening-anya/Anya_animated/` |
| `anya-png/` | `generative_agents/video/opening-anya/Anya_PNG_assets/` |

**Render policies:** `direct-motion` · `direct-overlay` · `dynamic-component-template` · `current-cast-example` · `reference-only`

**Data rule:** simulation data and persona IDs are always truth. Never parse identity, traits, or values from reference-board pixels or filenames.

### 8.2 Asset manifest (key entries)

| assetId | Source | Policy | Primary role |
|---|---|---|---|
| `talk_motion` | `anya-motion/Talk.mp4` | direct-motion | Hard-conversation hook; "talking like you" |
| `family_motion` | `anya-motion/Family.mp4` | direct-motion | Cohort reveal — **use once** per trailer |
| `village_motion` | `anya-motion/Village.mp4` | direct-motion | World-entry bridge into map HUD |
| `pressure_motion` | `anya-motion/Pressure.mp4` | direct-motion | Pressure peak ([C]); one gauge sweep |
| `light_line` | `anya-png/Asset4.png` | direct-overlay | Ignition / chapter wipe |
| `double_wordmark` | `anya-png/Double.png` | direct-overlay | Concept wordmark |
| `logo_active` | `anya-png/DOUBLAND.png` | direct-overlay | Simulation active / end logo |
| `url_endcard` | `anya-png/DOUBLAND2.png` | direct-overlay | Final URL — ≥1.5s readable |
| `replay_control` | `anya-png/F1714AC2-….png` | direct-overlay | Only on "Replay every moment" |
| `group_cutout` | cohort-generated | direct-overlay | Foreground layer — per cohort |
| `group_photo` | cohort-generated | direct-overlay | Concept/poster frame — per cohort |

**Reference-only (never direct-render):** `Asset.png`, `Cards1.png`, `Cards4.png`, `Cards5.png`, `Connections.png`, `Connections2.png`, `Profile.png`, `Map.png`, `Cards2.png`, `Cards3.png`, `Survival.png`, low-res identity-card examples. Rebuild as dynamic components.

**Motion-clip rules:** no visible looping; don't slow to static; if beat exceeds clip duration, transition to still/component.

**Generation prompts for new cohorts:** `prompts.md` (catalog) · engineering templates in `generative_agents/.../scripts-prompts/`. **Resolver rejections:** wrong cohort; reference-only in final render; baked text mismatch; below min resolution; landscape full-screen without approved crop; same hero asset in neighboring beats.

### 8.3 Component library

Each component exposes lifecycle: `enter` → `develop` → `settle` → `handoff`.

| Component | Use | Key rules |
|---|---|---|
| `HookProfileRing` | Hook; abstract → profile | Ring draws once; becomes initializer or scanner |
| `ConversationHero` | Hard conversation; "talking like you" | `talk_motion` at ≥75% prominence; animated bubbles |
| `DoubleInitializer` | "AI version of you"; cast transition | Categories activate sequentially; not a settings tutorial |
| `DoubleIdentityCard` | Per-Double intro **[B]/[C]** | Vector frame + hi-res cutout; hold still ≥0.8s after settle |
| `WorldMapHUD` | World + relationships | 2–6 nodes; clusters for 9–15 cast |
| `SurvivalDashboard` | Season / pressure context **[C]** | Three editorial crops in 2.5–4s total — never static poster |
| `PersonalityTraitCard` | Trait lines **[B]/[C]** | ≤3 short traits; data from showrunner |
| `RelationshipGraph` | Alliances, rivalry | ≤4 labeled edges; pulse changed edge once |
| `RelationshipDeltaToast` | Post-choice consequence | 0.8–1.5s; real or explicit fictional data |
| `DecisionTree` | "Making choices like you" | Branch → highlight → exit before tutorial feel |
| `SeasonModeBanner` | Mode activation | First red/orange accent; hand off to dashboard or pressure |
| `ReplayControl` | "Replay every moment" only | Not final CTA |

**`DoubleIdentityCard` props:** `personaId`, `displayName`, `portraitSrc`, `status`, optional `role`/`featuredTrait`, `entryDirection`, `accentState`.

### 8.4 Brand tokens

```ts
const doublandStyle = {
  background: "#02070D", panel: "rgba(3, 18, 31, 0.86)",
  cyan: "#27D7FF", blue: "#168BFF", white: "#F3FAFF",
  green: "#00F29A", warning: "#FF5A42",
  borderWidth: 2, cornerRadius: 18, gridOpacity: 0.12,
};
```

Cyan/blue default; green = online/positive; orange/red = Survival/conflict/loss only; uppercase UI type; one strong glow at a time; warm human imagery vs cold UI.

### 8.5 Per-simulation / per-cast requirements

**Reusable:** brand type, logo, particles, HUD components, transitions, SFX, music, color grade.

**Per simulation:** establishing shot/loop, map/world, night/pressure variant, conversation loop, mode visual, group motion, relationship data.

**Per cast:** clean cutout per Double, name + trait, group photo, relationship metadata, quality score + safe crop regions.

### 8.6 Cast layout by size

| Cast | [A] Opener (group overview) | [B]/[C] (per-Double beats) |
|---|---|---|
| **1–4** | Group frame or rapid paired montage; season reveal; **no spoken traits** | Hero `DoubleIdentityCard` each ~2.0–2.8s; trait card optional |
| **5–8** | Group or 2–3 row matrix; all visible; **no spoken traits** | 3–4 hero cards; paired layouts for rest; trait summary panel |
| **9–15** | Full matrix ~8–12s; cohort reveal (e.g. L-Talks → "pressed play"); **no spoken traits** | 3 hero cards; 3 clusters; matrix 1.5–2.5s; **no 15 narrated intros**; cast block ≤~20s |

Opener [A]: all Doubles visible; trait lines and `fifteen_spotlight_montage` → **[B]**. Total runtime may grow with cast size — expected.

### 8.7 Beat-to-asset map (four-person baseline)

Timings shift with narration; roles stay stable. Producer timecodes in `teadown/` supersede.

| Beat | Timing | Primary | Handoff |
|---|---:|---|---|
| Q1 second chance | 0:00–0:03 | `light_line` → `HookProfileRing` | line → ring |
| Q2 hard conversation | 0:03–0:08 | `talk_motion` / `ConversationHero` | chat → network |
| Q3 What if Double? | 0:08–0:14 | network → `double_wordmark` | ring → DOUBLE |
| Concept | 0:14–0:20 | `family_motion` + group photo | scan → identity cards |
| Talking/choosing | 0:20–0:27 | `DoubleIdentityCard`, `DecisionTree` | card → world |
| World | 0:27–0:35 | `village_motion` → `WorldMapHUD` | node → season alert |
| Season / mode | 0:35–0:42 | `SeasonModeBanner` + `SurvivalDashboard` | → cast ([C]); tease only in [A] |
| Featured cast | 0:42–0:58 | `DoubleIdentityCard` × featured | trait → gauge marker |
| Pressure | 0:58–1:07 | `pressure_motion` + `RelationshipGraph` | gauge → world node |
| Learn / change | 1:07–1:14 | `WorldMapHUD`, relationship updates | → one Double / question |
| Replay | within turn | `ReplayControl` | → logo line |
| End card | final ~5s | `logo_active` + `url_endcard` | `questionToUrlTakeover` |

**Editorial principle:** one hero + one support + one ambient + one transition per beat — one Doubland interface in motion, not a folder of graphics.

---

## 9. Validation checklist

### 9.1 Technical

1080×1920 · 9:16 · ≥30fps · duration within type bounds (**[A]** ~50–75s · **[B]** 60–90s · **[C]** 60–120s) · audio present · ~-14 LUFS · true peak ≤-1 dBTP · no corrupt assets · no unintentional black tail · poster exported.

### 9.2 Editorial motion

| Check | Threshold |
|---|---|
| Visual-change rate | ≥16/min (target ~23.5) |
| Low-motion frame ratio | <30% |
| Longest unplanned static run | <2.5s |
| End card duration | 3.5–5s |
| Same background unchanged | <6s |
| Hook developments | ≥3 in first 14s |
| Cast block | ≤20s; all Doubles visible when ≤15 |

Warnings first; promote to blocking after golden-set calibration.

### 9.3 Text, asset, repetition

- Text: finished before exit; safe areas; no ghost/glitch after typing; no infinite pulse; min readable hold.
- Assets: cohort IDs match; featured cast approved; no silent promotion of low-quality assets to hero.
- Repetition: flag same image held with minimal change; same group portrait in neighboring beats; duplicated card layouts; empty final tail.

### 9.4 Asset-mapped failures (review)

Fails when: hard-conversation line lacks `talk_motion` (or approved replacement); Double introduced outside identity-card frame; reference board as full shot; stale baked values on map/dashboard; wrong cohort group image; group held unchanged across sections; pressure peak lacks `pressure_motion` ([C]); mid-trailer URL missing when spec applies; end URL before question resolves; replay art as final CTA; end card long static hold instead of `questionToUrlTakeover`; semantic color rules violated.

### 9.5 Definition of done (system)

New sim + cast renders without manual Remotion edits; 4/8/15-Double layouts succeed; continuous hook + motivated transitions + short end card; text settles; audio passes gates; poster auto-exported; editorial validator catches slideshow output; producer golden-set rating near hand reference on smoothness, richness, clarity, energy, brand.

---

# Part II — Type contracts

## 10. [A] Opening trailer — scene map

**Shape (L1, L6):** lean **~60s** · 9:16 · concept intro → **group cast overview** → survival tease close. No per-Double spoken intros. No pressure mechanics in body.

**2D↔3D (L8):** opener establishes simulation-vs-life duality via matrix filter, cinematic flyovers, and photo cutouts — not daily arc clips (camera dive / pixel fracture). See [video playbook](video_playbook.md) §Core 2D↔Cinematic; daily execution rules → `daily/daily-2D-3D-blend.md`.

**Active WIP:** `opening/TODOs-opening-trailer.md` (L-Talks / Press Play manual production).

### 10.1 Hook (0–~14s)

One continuous Remotion sequence — not separate scenes per VO line:

1. black + particles → 2. eclipse ring → 3. "WHAT IF" types once, holds → 4. ring → conversation outlines → 5. nodes → silhouette → 6. core → `DOUBLE` accent.

Rules: no full opacity reset between three "What if" lines; no post-completion glitch; `talk_motion` hero on hard-conversation line; SFX on largest transforms.

### 10.2 Concept card + poster

Split layout: matrix-treated group top · black band (`DOUBLE` + concept line) · clean group bottom. Export still from settled midpoint.

### 10.3 World + relationships

Village entrance → dive to map → nodes → 2–3 relationship edges → one status change → day/night or neutral/pressure shift. Radial layout 2–8; clusters 9–15; 5–8 highlighted edges max.

### 10.4 Season premise (tease-only)

State change, not pressure sequence (L1). Color shift · season badge (**Press Play** for pilot) · group portrait · brief survival tease hand-off. `family_motion` or group loop — not one still through entire block.

### 10.5 Cast — group overview

All Doubles visible at a glance; cohort/season reveal (L-Talks pilot: **~300-member alumni chat → year analyzed → top 15 → message-derived profiles → "pressed play"**); **no spoken trait lines**; block ~8–12s for 15 cast. Character-card design may appear without VO traits.

### 10.6 Pressure — not in [A]

§8.7 pressure beats apply to **[C]** only. Opener survival content = **close tease** (§10.8).

### 10.7 Reflective turn

Reduce speed after any intensity: wide view → overlays fade → one Double → question with restrained "MY" emphasis → logo.

### 10.8 End card (3.5–5s)

1. final question / survival-season tease → 2. logo → 3. URL → 4. still hold → 5. music resolve. `questionToUrlTakeover` required.

---

## 11. [B] `day_normal` — contract stub

**Job (L2):** remind viewer of Doubland concept · **introduce every cast member in their simulation habitat** (role + normal-day beat) · spoken trait lines (15 locked lines live here) · close tease.

**Inherits:** Part I grammar, voice, end-card pattern, validators.

**Duration (L9):** **60–90s.**

**Scene map:** **TBD.** Per-Double `DoubleIdentityCard` + habitat visuals + trait VO per §8.6.

**2D↔3D (L8):** establishing layer (concept reset, cast intro) stays **permanently 2D** — sketch portrait is the brand language for "this is a Double." Habitat beats may use selective cinematic punctuation per `daily/daily-2D-3D-blend.md` §6 (when contract is written).

**WIP doc:** none yet. When created, follow opener TODO pattern; promote contract here when archived.

---

## 12. [C] `day_survival` — contract summary

**Job (L3):** moment-driven survival-day recap — 1–3 impactful moments, 2–4 featured Doubles, flexible 3–6 beat plan, cliffhanger close. Pressure, alliances, stakes per §8.7 / §10.6 patterns in daily form.

**Duration (L10):** Default **`short`:** <120s hard (validator band 60–120s); working target ~100–115s when first-feature stamps need room (L11). Daily SOT also allows a labeled **`long`** experiment lane (strawman warn >150 / hard 180) for deeper character/drama — not the silent default.

**Character intro (L11):** `intro_mode` full|recall from Supabase `trailer_featured_history`. Full spoken stamp = **job + place + day-projection want** (personality × **this day’s** stakes/dynamics; kid-plain; no clinical trait labels; no durable bio/`scratch.want` required; omit want if thin). **Job+place is one spoken clause** on habitat picture — not a directory wall. Cast cards may show a short trait line; VO stamp want is day-projection. Recall = first name + short place reminder. Survival Day 1 always full. Named farewell outside the featured cast still consumes a first-feature slot. Challenge teach: `double-docs/sot/sot_challenges.md` §5. Operator lock: `python -m video.lock_day_script <sim> --day N --script …`.

**Cast selection (L12):** spicy `rank_score` (drama-gap vs day median) + reserved last top-N slot for never-featured alive Doubles. Soft elim +2 only — never +50 auto-#1. Digest shows full spicy order + coverage candidate.

**Prior-day continuity (L13):** lock writes `scar.json` + `trailer_day_scar`; Day N+1 producer/writer get compact prior scars. “Previously on” maps prior engine day → survival season day. Lock Day N before generating Day N+1. Do not backfill chat-probe locks into history/scars.

**Day indexing note:** CLI `--day` is **engine** calendar day. Survival Day 1 = engine **day 2** (day 1 = grace/premiere). Do not treat engine day 1 as the first competitive daily.

**VO spine (working, `narration_v12`):** concept → survival_frame → stamp×N → challenge_teach → mid_turn → cost → cliff → cta_sim → itch?

**Clarity bar (2026-07-16):** cold first-listen for a **12-year-old** — challenge rules, cast scale (featured among full village), and stakes must not require inference. **Day 1 gold VO process:** long → approve → compress (V1 craft pass may lift runtime; **L10 &lt;120s stays the ship cap**). Live package `20260713-1` / `overview_day2&001`: **V0 VO clarity-rejected**; do not Remotion/TTS/`lock_day_script` on V0. Details: package `VO_LOCKED.md` · COS `agents/screenwriter/kb/wiki/decision/vo-long-then-compress.md`.

**Inherits:** Part I grammar. Same show as opener — Remotion 9:16, shared asset registry, `eleven_v3` @ 1.2×, `questionToUrlTakeover` end card with day-episode copy.

**2D↔3D blend (L8):** primary execution home for simulation literacy — clip-eligible arc beats, camera dive / pixel fracture transitions, continuity rules, clip sourcing. Working summary → **`TODO_video.md`** + stub `daily/daily-2D-3D-blend.md` (long-form not restored). Playbook north-star → `video_playbook.md` §Core 2D↔Cinematic.

**Active implementation status / picture pass:** `TODO_video.md` · village P0 plates plan `../20260716_video_assets.md`.

---

# Part III — Status & changelog

## 13. Production status (2026-07-16)

| Area | Status |
|---|---|
| **Taxonomy [A]/[B]/[C]** | Locked L1–L13 (§0.2) |
| **Remotion opener pipeline** | Shipped v3.0 — vertical 9:16, photo-real cutouts, `eleven_v3` @ 1.2× |
| **Automated opener quality** | Functional; visual grammar gap remains — Phase 6 in automation doc |
| **Opener [A] L-Talks manual** | **Script + VO locked** (~83s @ 1.2×); CapCut handoff ready — Anya edit next — `opening/TODOs-opening-trailer.md` · `l-talk/HANDOFF.md` |
| **[B] `day_normal`** | Contract stub only (§11); out of scope until [C] picture loop ships once |
| **[C] `day_survival`** | Story plumbing shipped (L11–L13). Live package `20260713-1` / `overview_day2&001`: **V0 VO clarity-rejected 2026-07-16** (V1 long-form → V2 runtime); picture pass + P0 village plates in flight — `TODO_video.md` · `../20260716_video_assets.md` |
| **Legacy / history** | `archive/sot-video-history.md` |

---

## 14. Pipeline changelog

### 2026-07-16 — SOT freshness pass

- Living links fixed: `daily/daily-2D-3D-blend.md`, `prompts.md`, `opening/opening-15person/` (removed dead `done/video/` paths).
- §12: documented `narration_v12` spine + 12-year-old clarity bar; Day-1 V0 rejected / V1→V2 path.
- §13 status brought current for opener CapCut + [C] VO rewrite + asset day.

### 2026-07-16 — L11 day-projection want (not durable bio want)

- **Product correction:** featured `[C]` stamp want = personality projected onto **today’s** events/dynamics, not a lifelong `scratch.want`. Durable soul want schema not required for this intro use case.
- Ban unchanged: clinical traits in VO; silent role-fallback wants treated as bio fact.
- Live Day-1 package: draft day-projection stamps for Irene / Ivan / Vince awaiting founder sign-off in `overview_day2&001/VO_LOCKED.md`.

### 2026-07-15 — Screenwriter Phase B: spoken stamp = want

- **L11 / §12:** full spoken VO stamp clarified as **job + place + want** (from bio/scratch). Cast-card trait lines unchanged; clinical Big Five labels banned in spoken VO.
- COS `agents/screenwriter/` Phase B doctrine cites this SOT; gold VO specimens already used want-shaped stamps.
- **Superseded in part 2026-07-16:** want source for `[C]` stamps → day-projection (see entry above); bio/scratch not required.

### 2026-07-10 — Expert VO → auto-gen (challenge teach + thin tallies)

- Fact ledger: plain challenge fields; winners from season only; `safe_vo` / `do_not_say` for thin tallies.
- Soft-default `challenge_job` (first type → teach; repeat → one clause); `exposed_leads` + ≤5 soft-signal bullets.
- Writer teach contract + Survival CTA (`doubland.ai`); full-intro budget 210–250; cache `story_v8` / `narration_v11`.
- Craft SOT: `COS/tasks/2026-07-10-001/final.md` (pipeline only — no chat-probe VO lock this round).

### 2026-07-10 — Spicy ranking + coverage + F3 scar cards

- **Laws:** **L12** (spicy + coverage), **L13** (scar cards).
- **Spicy ranking:** drama-gap amplify vs day median (`DRAMA_GAP_K=1.75`); locations weight 0.05; story-role bonuses (elim +2 / immunity +3 / top votes +3). Soft elim never restored to +50.
- **Coverage:** last featured slot prefers highest-spicy alive Double not yet in F1 history (featured|farewell).
- **F3 scars:** lock writes `scar.json` + `double.trailer_day_scar`; Day N+1 producer/writer get compact prior scars; prior-day summary day-index fixed (season vs engine); cache later `story_v8` / `narration_v11` (was v7/v10).
- Operator: lock Day N before generating Day N+1. No chat-probe history/scar backfill. Migration applied on double-openrouter.

### 2026-07-10 — F1 first-feature intro memory (L11)

- **Product:** first feature (or named farewell) → full job/place/want stamp (VO; clarified 2026-07-15); returnees → short recall. Survival Day 1 always full.
- **Storage:** `double.trailer_featured_history` keyed by `sim_code`; write only via `python -m video.lock_day_script` (draft generate is read-only).
- **Pipeline:** showrunner `intro_mode` + stamp facts from scratch/bio; establishing cards full ~6s / recall ~3s; cache `day_overview_story_v6` / `day_overview_narration_v9` (superseded by spicy/F3 → v7/v10).
- **Day-index fix:** Survival Day 1 = engine `--day 2` (not engine day 1 grace).
- **No backfill** of `20260707-chat-probe-v3` human lock — F1 starts clean on the next sim.

### 2026-07-09 — Character care + ranking/continuity follow-ups

- Survival daily working target **~100–115s** (hard cap still <120s) when first-feature stamps need room.
- Locked chat-probe Day 2 plain-text VO in `video/todo_script_draft.md` (Vincent / Max / Olivia stamps + want/turn).
- Ranking F2 (2026-07-09): no elimination +50; farewell close when boot ∉ top-3; soft +2 (F2b).
- F1 first-feature intro memory shipped 2026-07-10 (see above).

### 2026-07-09 — Challenge card available; story-first VO

- Fact ledger `today.challenge`: plain-language name + brief + winners (not raw id only).
- Showrunner prompts: expand challenge only if it strengthens the day’s arc under the <120s cap; cache keys `day_overview_story_v4` / `day_overview_narration_v7`.

### 2026-07-09 — Cast digest ranks chat *content*, not count

- Day-overview ranker / cast digest: `chat_impact` from top movement.chat transcripts (depth + vote/alliance keywords); Moments include chat beats.
- Chat count remains a diagnostic signal only. Engine memory chat-row cleanup stays post-MVP (`PM-MEM-*`).

### 2026-07-06 — L-Talks manual opener script + VO locked

- **Script:** `l-talk/script/script_cos.md` (v2) supersedes v1 `script.md`.
- **VO:** `l-talk/audio/experiments/script_cos_oneshot_speed12/narration_cos.mp3` — `eleven_v3` warm @ **1.2×** one-shot, **~83.4s** (Ivan + Anya).
- **Close hook:** *"what would MY Double do?"* · decisions D10–D12 in `opening/TODOs-opening-trailer.md`.

### 2026-07-02 — Duration benchmarks by trailer type

- **[A] ~60s** · **[B] 60–90s** · **[C] <120s** — locked as L6, L9, L10; taxonomy table, duration policy, §9.1 validator bands, and type contracts updated.

### 2026-07-02 — Simulation literacy (L8) + blend doc wiring

- Locked **L8 simulation literacy** in §0.2; cross-links in §10–§12 and doc map.
- Renamed blend spec → `daily/daily-2D-3D-blend.md` (execution rules for [B]/[C]; north-star stays in SOT + playbook).

### 2026-07-02 — Three-type SOT compression

- Single SOT for [A]/[B]/[C]; historical diagnostic, commission tracker, and implementation phases → `archive/sot-video-history.md`.
- Asset-generation prompts → `video/prompts.md`.
- Locked lean opener shape (L1–L7); per-Double intros assigned to [B].

### v3.0 — Remotion vertical pipeline (2026-06-17)

Anya's `DOUBLAND1.mov` (~77s, 9:16) is the quality bar. Python orchestration + **Remotion** renders opener; vertical-only; photo-real cutouts.

```
persona_ranker → showrunner (+narration_cache) → tts
  → build_opener_remotion_props → render_opener_remotion → validate_trailer
```

Opener no longer uses FFmpeg `compose_opener_trailer`, Phaser capture, or 16:9. Day modes unchanged.

**Locked narration:** `eleven_v3` warm @ 1.2× · minimal pauses (~2.75s total) · drop "sometimes… you never noticed" line · ~76.7s VO reference.

**Command:**

```bash
python -m video.generate_trailer base_family_sim opener --mode opener --top 4 --cohort-name "Pistsov family"
```

**Residual gaps:** continuous 0–15s hook montage, full SFX log, Supabase relationship labels — see automation doc §4.

Older changelog (v2.4 concept-script rewrite, pre-Remotion phases) → `archive/sot-video-history.md`.