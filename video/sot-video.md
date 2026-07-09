# Video SOT — Doubland Trailer System

> **Nav:** [Opener WIP](opening/TODOs-opening-trailer.md) · [Opener implementation](opening-15person/20260617_vertical-trailer-automation.md) · [Opener visual timing](opening-15person/teadown/) · [Survival daily WIP](daily/TODO_daily_trailer.md) · [2D↔3D blend](daily/daily-2D-3D-blend.md) · [Video playbook](video_playbook.md) · [Prompts](prompts.md) · [Archive history](archive/sot-video-history.md) · Engineering PRD: `video/video_PRD.md`

Authoritative source of truth for Doubland's **three trailer types**. Part I is shared creative grammar (all types inherit). Part II is per-type contracts. Part III is locked production status and recent changelog — not active task lists.

| Part | Contents |
|---|---|
| **I** | Shared grammar — quality bar, motion system, pipeline, text/transitions/audio, assets, validation |
| **II** | Type contracts — [A] opener · [B] `day_normal` · [C] `day_survival` |
| **III** | Production status + pipeline changelog |

---

## 0. Trailer-type taxonomy & locked decisions

### 0.1 Trailer types

| Type | Name | Job | Duration | Scene map |
|---|---|---|---:|---|
| **[A]** | **Opening trailer** | Introduce Doubland + season cast at a glance; **shareable viral growth asset**. Lean — no per-Double intros, no survival mechanics in the body. | **~60s** | §10 |
| **[B]** | **Normal-day daily** (`day_normal`) | Brief concept reminder + **introduce every cast member in their simulation habitat** (role + normal-day beat) + close tease. Per-Double intros and spoken trait lines live here. | **60–90s** | §11 (TBD) |
| **[C]** | **Survival-day daily** (`day_survival`) | Moment-driven survival recap — pressure, stakes, cliffhanger close. | **<120s** | §12 · detail in `daily/TODO_daily_trailer.md` |

**Same show, next episode.** All three share format, motion system, voice, end-card pattern, and validators. Type differences are **content and scene map**, not craft.

### 0.2 Locked decisions (2026-07-02)

| # | Decision | Rationale |
|---|---|---|
| L1 | Opener [A] is **lean**: concept intro + group cast overview + survival tease at close. No per-Double spoken intros, no survival mechanics in the body. | Viral growth asset, not a cast reveal. Per-Double intros → [B]. |
| L2 | Per-Double intros + spoken trait lines → **[B] `day_normal`**. | Natural home for 15 locked trait lines and habitat beats. |
| L3 | Two daily modes: `day_normal` [B] and `day_survival` [C], each with its own contract. | Pre-survival vs survival days have different story jobs. |
| L4 | Playbook **6-emotion sequence is guidance**, not a separate deliverable. Opener [A] absorbs those principles. | One primary viral asset. |
| L5 | **Terminology exception (temporary, global).** "AI version of you", "AI Doubles of real people", "AI twin of your personality" permitted for first-touch clarity until Doubland is self-evident; then drop. | Supersedes forbidden-terms in `daily/TODO_daily_trailer.md` §Brand discipline for now. |
| L6 | Opener [A] **~60s** (lean, no per-Double block). | Viral-share length; tighter than Anya reference cut. |
| L7 | **Season masking:** cohort display names masked externally. Pilot: `soul15_seed_20260224` → **L-Talks** · season **Press Play**. | Cohort recognizes itself; asset stays shareable. |
| L8 | **Simulation literacy:** Doubles read as pixelated in the interface; lived moments may resolve into cinematic reality. Trailers train viewers to **watch Phaser and see real life** — 2D is the system, 3D punctuates truth. Opener [A] establishes the duality (matrix, cinematic tease); dailies [B]/[C] execute it per `daily/daily-2D-3D-blend.md`. | Product north-star; brand philosophy in [video playbook](video_playbook.md) §Core 2D↔Cinematic. |
| L9 | **[B] `day_normal` 60–90s.** | Room for per-Double habitat intros; still under a minute at the short end. |
| L10 | **[C] `day_survival` <120s.** | Survival recaps need more story beats than normal-day dailies. |

### 0.3 Voice, tone & brand (shared)

**Voice:** warm omniscient narrator — see [video playbook](video_playbook.md) for full register. **Never mocks the Doubles.** ElevenLabs `eleven_v3` warm @ **1.5×** locked (opener + daily).

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
| **`daily/TODO_daily_trailer.md`** | Active [C] survival-daily WIP + full scene map until promoted to §12 |
| **`opening-15person/teadown/`** | Opener visual timing — ~50 sub-moments, timecodes, text/SFX logs |
| **`opening-15person/20260617_vertical-trailer-automation.md`** | Opener engineering — built state, Phase 6 backlog |
| **`daily/daily-2D-3D-blend.md`** | Simulation literacy execution — when/how Phaser/sketch resolves into cinematic life ([B]/[C]; especially [C] arc beats) |
| **`video/prompts.md`** | AI asset-generation prompts (Grok/Midjourney catalog) |
| **`generative_agents/.../scripts-prompts/!prompts.md`** | Codegen script templates (engineering repo) |
| **`archive/sot-video-history.md`** | Pre-Remotion diagnostic, commission tracker, implementation phases |

On **visual timing, sub-moments, on-screen copy, SFX sync** → `teadown/` CSVs. On **asset policy, cast scale, mix, validation** → Part I below. On **2D↔3D blend rules** → `daily/daily-2D-3D-blend.md`. On **implementation backlog** → automation doc (not this SOT).

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

ElevenLabs **`eleven_v3`**, warm stability **0.60**, speed **1.5×** — locked for opener and daily. Pronunciation: `Doubland` → Dub-land via `TTS_PRONUNCIATION_OVERRIDES` in `tts.py`.

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

**Generation prompts for new cohorts:** `video/prompts.md`. **Resolver rejections:** wrong cohort; reference-only in final render; baked text mismatch; below min resolution; landscape full-screen without approved crop; same hero asset in neighboring beats.

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

**Duration (L10):** **<120s** (validator band 60–120s).

**Inherits:** Part I grammar. Same show as opener — Remotion 9:16, shared asset registry, `eleven_v3` @ 1.5×, `questionToUrlTakeover` end card with day-episode copy.

**2D↔3D blend (L8):** primary execution home for simulation literacy — clip-eligible arc beats, camera dive / pixel fracture transitions, continuity rules, clip sourcing. Full rules → **`daily/daily-2D-3D-blend.md`**.

**Full contract + scene map + implementation status:** `daily/TODO_daily_trailer.md` until stable, then summarize here and trim the TODO.

---

# Part III — Status & changelog

## 13. Production status (2026-07-02)

| Area | Status |
|---|---|
| **Taxonomy [A]/[B]/[C]** | Locked L1–L10 (§0.2) |
| **Remotion opener pipeline** | Shipped v3.0 — vertical 9:16, photo-real cutouts, `eleven_v3` @ 1.5× |
| **Automated opener quality** | Functional; visual grammar gap remains — Phase 6 in automation doc |
| **Opener [A] L-Talks manual** | **Script + VO locked** — `script_cos.md` + `script_cos_oneshot_speed12` (~83s @ 1.2×); Anya CapCut in flight — `opening/TODOs-opening-trailer.md` |
| **[B] `day_normal`** | Contract stub only (§11) |
| **[C] `day_survival`** | WIP — `daily/TODO_daily_trailer.md`; blend grammar in `daily/daily-2D-3D-blend.md` |
| **Legacy FFmpeg / commission tracker** | Archived — `archive/sot-video-history.md` |

---

## 14. Pipeline changelog

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

**Locked narration:** `eleven_v3` warm @ 1.5× · minimal pauses (~2.75s total) · drop "sometimes… you never noticed" line · ~76.7s VO reference.

**Command:**

```bash
python -m video.generate_trailer base_family_sim opener --mode opener --top 4 --cohort-name "Pistsov family"
```

**Residual gaps:** continuous 0–15s hook montage, full SFX log, Supabase relationship labels — see automation doc §4.

Older changelog (v2.4 concept-script rewrite, pre-Remotion phases) → `archive/sot-video-history.md`.