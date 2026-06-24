# Opening Trailer Bible (draft → sot-opening-trailer)

> **Nav:** [Implementation plan](20260617_vertical-trailer-automation.md) · [Visual timing SOT](teadown/) · Engineering PRD: `video/video_PRD.md`

| Part | Contents |
|---|---|
| **I** | Production playbook — creative grammar, asset map (§16), tickets, acceptance tests |
| **II** | Asset punch list and commission tracker |
| **III** | Pipeline changelog (v3.0, v2.4, pre-Remotion history) |

---
## Part I — Production Playbook

**Purpose:** Define the production system developers should automate so every new vertical Doubland simulation trailer approaches Anya’s hand-edited reference in smoothness, visual richness, pacing, and perceived production value. This edition also maps the supplied production assets to specific trailer beats and defines which assets may be rendered directly, which must be rebuilt as dynamic components, and which are reference boards only.

**How this doc relates to others**

| Document | Role |
|---|---|
| **`trailer-opening/teadown/`** | **Visual timing SOT** — ~50 sub-moments, timecodes, text/SFX logs, reference grabs |
| **This doc — Part I** | Creative grammar, asset map (§16), tickets (§13), acceptance tests (§14, §16.13) |
| **`20260617_vertical-trailer-automation.md`** | **Primary implementation plan** — built state, commands, Phase 6 todos |
| **This doc — Part II** | Asset commission punch list |

On **visual timing, sub-moments, on-screen copy, and SFX sync** → follow `teadown/` CSVs. On **asset policy, cast scale, mix targets, and acceptance framework** → follow Part I below.

**Duration policy:** Exact total runtime is **not a hard product requirement**. A few seconds difference from Anya’s hand cut is acceptable (e.g. **76.6s** reference vs **~82–84s** automated on opener&006). **Trailers for simulations with many Doubles are expected to run longer** — tiered cast layouts keep the *cast block* efficient (~15–20s), but total length may grow with cohort size. Section timings and validator bands below are **pacing guidance**, not pass/fail gates on total seconds.

**Reference files reviewed**

- `trailer-opening/teadown/` — **authoritative visual spec** (proxy 76.6s): `cross_cutting_summary.md`, `timecode_index.csv`, `text_log.csv`, `sfx_log.csv`, `scene_spec.md`, `reference_grabs/`
- `doubland_small.mp4` / `DOUBLAND1.mov` — hand-edited creative reference masters
- `opener&006` output — Phase 5 P0 baseline (`data/base_family_sim/opener&006/output/trailer_9x16.mp4`)
- `20260617_vertical-trailer-automation.md` — built state, commands, Phase 6 todos

---

## 1. Executive conclusion

The automated trailer is structurally functional, but it does not yet reproduce the reference trailer’s **visual grammar**.

The main gap is not the number of effects. The main gap is that the automated version treats each narration segment as a mostly self-contained scene. The reference treats the trailer as a **continuous visual journey** in which one visual idea transforms into the next.

The reference repeatedly does five things the automated version does not yet do consistently:

1. It introduces a visible change every 1–3 seconds without necessarily making a hard cut.
2. It passes visual elements from one beat into the next through motion, scale, light, shape, or position.
3. It alternates visual density and brightness, preventing the trailer from feeling uniformly dark or flat.
4. It uses several coordinated depth layers rather than a background with text placed over it.
5. It combines narration, music, transition sound effects, and visual movement into one rhythm.

The correct solution is therefore not “add more random motion.” It is to build a deterministic **Doubland motion-design system** and let automation populate that system with the correct cast, simulation, script, and relationship data.

---

## 2. What the measured comparison shows

The uploaded hand-edited file is a 1280×720 proxy containing the vertical composition in the center. The automated output is a native 1080×1920 vertical file. This prevents a fair pixel-resolution comparison, but it does not prevent comparison of pacing, composition, motion, sound, and visual structure.

| Measure | Hand-edited reference | Automated (opener&005) | Automated (opener&006) | Meaning |
|---|---:|---:|---:|---|
| Runtime | 76.6 sec | 83.6 sec | ~82.4 sec | ~6s longer on 006 — **acceptable** |
| Integrated loudness | -13.1 LUFS | -16.6 LUFS | **~-13.9 LUFS** | 006 mix target largely met |
| Visual-change rate | ~23.5/min | ~9.3/min | *(not re-measured)* | Still the primary quality gap — Phase 6 |
| Near-static intervals | 16% | 57% | *(not re-measured)* | Middle third (28–55s) still slide-like on 006 |

*Full motion metrics above are from the opener&005 review. opener&006 improved text settle, Talk hero, SFX, and loudness but did not yet implement ~50 producer sub-moments.*

### Most important static regions in the automated version

The automated version contains several prolonged low-motion regions:

- approximately 11.5–18 sec
- approximately 28–42 sec
- much of 43–55 sec
- approximately 70–83 sec

The 28–55 sec section is especially important because it contains the world, season setup, and cast introduction. This should be the richest middle section, but it behaves mostly like a sequence of static presentation slides.

---

## 3. Root-cause analysis

### 3.1 Visual timing is too closely coupled to narration segmentation

The current pipeline maps voiceover segments into visual beats. This encourages a pattern such as:

> narration line → one background → one caption → crossfade → next narration line

That is easy to automate, but it produces presentation slides rather than a cinematic trailer.

**Required change:** Separate the narration timeline from the visual timeline.

A narration segment may contain 2–4 visual micro-beats. A visual sequence may also continue across several narration segments.

The system must support:

- one continuous visual sequence spanning multiple voiceover lines;
- multiple visual developments during one voiceover line;
- transitions beginning before the narration line ends;
- visual anticipation, where the next idea appears 6–12 frames before the corresponding words;
- visual echoes, where one element remains briefly after narration has moved on.

### 3.2 The automated version uses crossfades where the reference uses handoffs

A crossfade is smooth in a technical sense, but it does not automatically feel designed.

The reference uses **motivated handoffs**, such as:

- a glowing circle becoming a face scanner;
- a network node becoming a relationship line;
- a portrait card expanding into the simulation map;
- a map light becoming a village window;
- a UI ring becoming the pressure gauge;
- a dark interface panel becoming the black end-card field.

The automated version needs transition logic based on shared shape, position, direction, color, or subject—not only opacity.

### 3.3 Many scenes have only two functional layers

A common automated composition is:

1. background image or video;
2. text/UI overlay.

The reference more often uses:

1. background atmosphere;
2. moving environment or texture;
3. main subject;
4. interface or graphical data;
5. headline/caption;
6. a small accent such as particles, cursor, scan line, light sweep, or relationship pulse.

Not every scene needs six layers, but most important beats need at least three independently moving depth planes.

### 3.4 The automated version repeats major assets without enough transformation

The group portrait remains visible through several consecutive conceptual and season beats. The repeated image becomes wallpaper rather than new information.

A repeated asset is acceptable only when its treatment changes meaningfully. Examples:

- clean portrait → matrix scan → isolated face boxes → relationship graph → cropped emotional close-up;
- daytime map → zoomed neighborhood → night map → pressure alert overlay;
- full group → paired relationships → single featured persona → full cast grid.

### 3.5 The middle cast block does not scale gracefully

A full-screen portrait card per person works for four Doubles, but it cannot simply be repeated for 15 people. Fifteen three-second cards would create a 45-second cast section before the rest of the trailer is complete.

The system needs tiered cast layouts rather than one repeated template. **Note:** constraining the *cast block* (~15–20s) is a layout goal; **total trailer length may still increase** for simulations with many Doubles (see Duration policy).

### 3.6 Text animation continues after the communication job is finished

The current glitch, glow, or pulse sometimes continues after the line is readable. This reduces clarity and makes text feel like a looping UI demo.

The desired rule is:

> animate into readability, then become still.

Readable copy should normally hold motionless for at least 0.8 seconds before it exits.

### 3.7 Audio is present but not producing editorial impact

The automated mix contains narration and music, but it lacks the reference’s sense of punctuation. The result is visually and sonically uniform.

Transition sound effects should not be decorative. They should clarify:

- a reveal;
- a direction change;
- a character introduction;
- a shift from observation to pressure;
- the final question and logo reveal.

---

## 4. Target creative grammar

Every trailer should feel like one designed piece rather than a set of interchangeable templates. The following grammar should be implemented as reusable rules.

### 4.1 Macro rhythm

A typical four-person opener is often **~72–84 seconds**, but total length is **flexible**. Use this energy curve as **guidance** — not a strict cap. **Producer-measured section boundaries** (proxy 76.6s) are in `teadown/20260624_doubland_timecode_index.csv`; they supersede the approximate durations below where they differ (e.g. **concept begins ~10.8s**, not ~14s).

| Section | Typical duration | Energy purpose |
|---|---:|---|
| Hook | 0–11 sec *(producer: ~0–10.8)* | Curiosity; abstract, controlled buildup |
| Product concept | 11–19 sec *(producer: ~10.8–19.5)* | Fast clarity; explain what a Double is |
| World and relationships | 19–32 sec | Expand scale and show simulation life |
| Season premise | 32–41 sec | Establish stakes and current mode |
| Cast | 41–53 sec | Personality, contrast; **panel → character → panel** rhythm |
| Pressure and transformation | 53–61 sec | Gauge peak + night dashboard + **mid-trailer URL plate @ ~59.4s** |
| Live / replay + reflective turn | 61–72 sec | Feature montage + dashboard evidence |
| End card | final ~4.9 sec *(producer: ~71.7–76.6)* | Fog setup → question → URL takeover → short hold |

The end card should follow the **`questionToUrlTakeover`** pattern (~2.1s setup → question → overlapping URL → ~0.6s URL-only), not a long static tail after VO ends.

### 4.2 Micro rhythm

The viewer should receive a meaningful visual development approximately every **1.0–2.5 seconds**.

A development may be:

- a new subject;
- a camera push;
- a new depth layer;
- a UI reveal;
- a text replacement;
- a lighting change;
- a relationship edge drawing;
- a crop or reframing;
- an object passing into the next scene;
- a meaningful SFX-synchronized accent.

This does not mean making a hard cut every two seconds. The preferred pattern is:

> enter → develop → transform → hand off

### 4.3 Visual richness budget

For each major beat, the renderer should attempt to provide:

- **one focal subject;**
- **one secondary information layer;**
- **one ambient motion layer;**
- **at least two depth planes;**
- **one visible development during the beat;**
- **one designed connection to the next beat.**

A beat should be rejected or enriched when it consists only of a static background and a caption for longer than 1.5–2 seconds.

### 4.4 Motion hierarchy

Each scene should have:

- one primary motion;
- no more than two secondary motions;
- ambient motion that does not compete with text;
- a clear point at which the composition settles.

Examples:

| Beat | Primary motion | Secondary motion |
|---|---|---|
| Hook | camera push into ring | particles orbiting slowly |
| Conversation | chat panels building | small scan line/light sweep |
| World | map camera drift | nodes or windows illuminating |
| Cast | subject reveal or slide | trait line typing |
| Pressure | gauge sweep | background light pulsing once |
| End card | logo resolve | restrained residual particles |

Continuous pulsing, random floating, or perpetual glitching should not be the default.

---

## 5. Recommended automated architecture

The current architecture should evolve from a voiceover-driven renderer into a **spec-driven trailer compiler**.

```text
Simulation data
    ↓
Cast and conflict selector
    ↓
Showrunner script
    ↓
Narration timing
    ↓
Visual beat planner
    ↓
Asset resolver + asset quality scorer
    ↓
TrailerSpec JSON
    ↓
Deterministic Remotion motion system
    ↓
Audio mix and SFX pass
    ↓
Technical + editorial validator
    ↓
MP4 + poster + QA report
```

### 5.1 Cast and conflict selector

Do not select featured people using importance alone. Selection should balance:

- simulation relevance;
- personality contrast;
- relationship centrality;
- likely conflict or alliance;
- visual asset quality;
- diversity of role and behavior;
- avoidance of redundant traits.

A practical formula:

```text
feature_score =
    0.30 × story_importance
  + 0.20 × relationship_centrality
  + 0.20 × personality_contrast
  + 0.15 × conflict_potential
  + 0.10 × asset_quality
  + 0.05 × cast_diversity_contribution
```

Use maximal-marginal-relevance selection so the chosen four are not all important for the same reason.

### 5.2 Visual beat planner

The visual beat planner should receive:

- script segments;
- word-level or phrase-level narration timing;
- **producer sub-moment index** (`teadown/20260624_doubland_timecode_index.csv`) as the style template for a four-person Pistsov opener;
- **`text_log.csv`** and **`sfx_log.csv`** for copy and audio punctuation targets;
- semantic tags;
- cast size;
- available assets;
- relationships;
- season mode;
- target runtime;
- target style profile.

It should output **~40–60 independent visual sub-moments** (not one beat per VO segment) plus micro-beats within continuous sequences. Each sub-moment should name a **transition primitive** where applicable (see §8).

### 5.3 Asset resolver

The resolver should pick the best valid asset for each role, not merely the first available filename.

Each asset needs metadata:

```json
{
  "id": "cohort_group_photo",
  "type": "image",
  "semanticTags": ["cast", "family", "group"],
  "people": ["gosha", "ivan", "katya", "luba"],
  "aspectRatio": 0.5625,
  "resolution": [2160, 3840],
  "hasTransparency": false,
  "faceClarity": 0.92,
  "backgroundQuality": 0.88,
  "motionPotential": 0.75,
  "qualityScore": 0.89,
  "approved": true
}
```

The resolver should never silently use another cohort’s portraits. If a required asset is missing, it should:

1. generate the asset;
2. use a branded generic fallback;
3. or fail the render with a clear missing-asset report.

### 5.4 TrailerSpec

A single JSON document should fully describe the intended edit before rendering.

Example:

```json
{
  "format": {
    "width": 1080,
    "height": 1920,
    "fps": 30,
    "targetDurationSec": 78
  },
  "style": "doubland_opener_v2",
  "castStrategy": "four_featured_plus_group",
  "audio": {
    "voiceProfile": "trailer_v3_x1.5",
    "musicTrack": "doubland_anthem",
    "targetLUFS": -14,
    "truePeakDbTP": -1
  },
  "beats": [
    {
      "id": "hook_continuous",
      "start": 0,
      "end": 14.2,
      "visualSequence": "hook_morph_v2",
      "narrationSegments": [0, 1, 2],
      "microBeats": [
        {"at": 0.0, "action": "ring_enter"},
        {"at": 2.0, "action": "headline_type"},
        {"at": 4.5, "action": "ring_to_chat"},
        {"at": 7.3, "action": "chat_to_network"},
        {"at": 10.1, "action": "network_to_human"},
        {"at": 13.2, "action": "human_to_double_wordmark"}
      ],
      "transitionOut": {
        "type": "match_scale",
        "sharedElement": "blue_core"
      }
    }
  ]
}
```

The renderer should not make important editorial decisions. It should execute the prepared spec consistently.

---

## 6. Scene-by-scene production rules

## 6.1 Hook: one continuous 0–14 second sequence

The current hook is split into separate scenes aligned to separate voiceover segments. Replace it with one stateful Remotion sequence.

Recommended progression:

1. black field with faint particles;
2. eclipse/core ring enters;
3. “WHAT IF” types once and becomes still;
4. ring stretches into conversation outlines;
5. conversation UI develops into relationship nodes;
6. nodes form a human or Double silhouette;
7. blue core becomes the `DOUBLE` wordmark accent.

Rules:

- no full-scene opacity reset between the three “What if” lines;
- no repeated glitch after headline completion;
- one continuous directional movement;
- at least four visible visual developments;
- use `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Talk.mp4` as the hero layer for the hard-conversation line;
- transition SFX at the two largest transformations.

## 6.2 Concept card and poster frame

Create the split-layout concept card described in the current teardown:

- upper section: cohort photo with matrix/scan treatment;
- central black band: `DOUBLE` and “AN AI VERSION OF YOU”;
- lower section: clean cohort photo;
- small face-tracking or relationship accents.

This frame should serve two purposes:

1. a strong trailer beat;
2. the exported poster/thumbnail.

Export a still from the settled midpoint, not the first frame of the video.

## 6.3 World and relationships

Avoid showing a map as a passive background.

Recommended sequence:

- cinematic village entrance;
- camera dives into the map;
- map labels or nodes appear;
- two or three relationships draw;
- one relationship changes status;
- the map transforms from day to night or from neutral to pressure mode.

Relationship logic should display only the most narratively useful edges.

For 2–8 people, use a radial or arc layout.  
For 9–15 people, use clusters and show only 5–8 highlighted edges at one time.

## 6.4 Season premise

The season mode must feel like a state change, not another caption.

Example sequence:

- color temperature shifts;
- mode badge appears;
- alert line or rule enters;
- group portrait separates into individuals;
- visual pressure rises;
- first cast intro begins before the season beat fully exits.

Use `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Family.mp4` or a generated group-motion loop rather than holding one still portrait through the entire season block.

## 6.5 Cast section

### Cast of 1–4

- each person may receive a 2.0–2.8 sec hero card;
- use distinct movement directions or framing;
- keep a shared visual system;
- trait appears after the person, not simultaneously;
- the next portrait begins entering before the current one fully leaves.

### Cast of 5–8

- 3–4 featured people receive hero cards;
- remaining people appear in paired or triplet montage cards;
- every person appears visually;
- only featured people require spoken trait lines.

### Cast of 9–15

- 3 featured people receive short hero cards;
- remaining people appear in three behavior/relationship clusters;
- finish with a full-cast matrix or group frame;
- do not narrate 15 individual traits;
- total cast block remains approximately 15–20 sec.

A trailer with 15 Doubles should represent all 15, but it should not treat all 15 as equal-length chapters.

### Character-card design

Prefer:

- transparent or clean full-body cutout;
- integrated neutral or environment background;
- subtle depth shadow;
- one data accent;
- name;
- one concise trait line;
- one entry move and one exit handoff.

Avoid a plain rectangular photo placed over an unrelated dark background unless it is an intentional UI-card design.

## 6.6 Pressure section

This should be the trailer’s visual peak.

Use:

- pressure gauge or risk indicator;
- faster map or village motion;
- relationship alerts;
- one short, stronger music rise;
- one or two impact SFX;
- higher visual contrast;
- faster micro-beat interval.

The gauge should make one purposeful sweep, settle, and hand off. It should not loop.

## 6.7 Reflective turn

After the pressure peak, briefly reduce visual speed.

Suggested progression:

- wide map or village view;
- data overlays disappear;
- one Double remains;
- the question appears;
- the word “MY” receives one restrained emphasis;
- move directly into the logo.

This contrast is important. The trailer should not remain at maximum intensity until the final frame.

## 6.8 End card

Target length: **3.5–5 seconds**.

Required order:

1. final question resolves;
2. logo enters;
3. URL appears;
4. all elements hold still long enough to read;
5. music resolves and fades.

Do not leave a nearly black screen or oversized partially cropped wordmark for ten seconds.

---

## 7. Text-motion system

Create shared text modes rather than configuring animation independently in every component.

### Required modes

```ts
type TextMotionMode =
  | "type-then-hold"
  | "fade-up-then-hold"
  | "word-swap"
  | "impact-once"
  | "static";
```

### `type-then-hold`

1. type characters while the phrase is spoken;
2. remove cursor within 4–8 frames of completion;
3. remove RGB/glitch copies;
4. set final transform and opacity;
5. hold completely still for at least 0.8 sec;
6. exit using the beat transition.

### `impact-once`

Use only for a word such as:

- `DOUBLE`;
- `SURVIVAL`;
- `LOW`;
- `MY`.

The emphasis may scale, glow, or displace once. It must not pulse indefinitely.

### Legibility rules

- maximum two levels of copy on screen;
- headline and support line should have clear size contrast;
- do not place important text in the bottom interface area of social platforms;
- no unfinished line should remain when the scene exits;
- line length should be optimized for vertical viewing;
- important text must pass contrast testing against every frame behind it.

---

## 8. Transition system

Build a small transition grammar rather than a large collection of unrelated effects. The producer pass names six **required Remotion primitives** (implement as reusable helpers, not one-off beat hacks):

| Primitive | Use |
|---|---|
| `sharedCenterReplace` | One center text axis; WHAT IF, answer lines, DOUBLE, captions swap in place |
| `persistentLayerSwap` | Lower figures/UI stay while upper layer changes (hook conversation, world UI) |
| `cardSelectZoom` | ACTIVE DOUBLES panel + cursor → selected card expands to full-body character |
| `radialObjectMatch` | Circle/blur from one subject resolves into next (e.g. Lyuba → pressure gauge) |
| `textHoldAcrossBackgroundCut` | Headline frozen while background hard-cuts (live/replay montage) |
| `questionToUrlTakeover` | End card: scenic setup → final question → URL overlaps question → short URL hold |

### Preferred transitions

| Transition | Use |
|---|---|
| Match-scale | A circle, face, node, portrait, or logo grows into the next scene |
| Shared-position | An object remains in the same screen location while its context changes |
| Parallax push | Camera moves through foreground into a new environment |
| Light sweep | Blue/gold light reveals the next layer |
| UI expansion | A small card or node expands to full frame |
| Shape morph | Ring → scanner → graph → gauge |
| Foreground wipe | A person, panel, building, or map element crosses frame and reveals the next scene |
| Audio-led cut | SFX begins just before the visual change |

### Use crossfades only when

- time is intentionally passing;
- emotional tone is softening;
- two similar environments are blending;
- the transition has another moving layer that prevents a flat dissolve.

### Transition acceptance rule

Every major transition should answer:

> What visual element from the outgoing shot causes or motivates the incoming shot?

If the answer is “nothing; it just fades,” the planner should choose a stronger handoff.

---

## 9. Audio automation

### 9.1 Voice

Run an A/B test between:

- current warm voice at 1.5×;
- trailer delivery at the same pace.

Judge:

- intelligibility;
- emotional authority;
- warmth;
- word stress;
- whether the cast traits sound distinct;
- whether the pace feels rushed.

Lock the winner only for opener trailers. Do not modify day-trailer voice settings automatically.

### 9.2 Final mix targets

Recommended delivery targets:

- integrated loudness: approximately **-14 LUFS**;
- true peak: **no higher than -1 dBTP**;
- narration consistently clear;
- music ducked approximately 3–5 dB under active speech;
- music allowed to rise during visual-only transitions and the pressure peak;
- no abrupt level changes between generated segments.

The hand-edited proxy is louder and more dynamic than the automated version, but its measured peak exceeds 0 dBTP. Match its energy, not its clipping risk.

### 9.3 SFX categories

Create a tagged library:

- `whoosh_soft`;
- `whoosh_fast`;
- `digital_reveal`;
- `typing`;
- `scan`;
- `connection_pulse`;
- `impact_low`;
- `riser_short`;
- `logo_resolve`;
- `ambient_village`;
- `pressure_alert`.

Each transition may request an SFX role. The audio planner chooses a specific file with controlled variation.

### 9.4 SFX rules

- no SFX on every text animation;
- large structural transitions receive stronger sounds;
- character cards use subtle directional whooshes;
- relationship lines use small pulses;
- pressure mode receives a low impact or short riser;
- logo receives one clean resolve sound;
- sounds should begin 2–6 frames before the visual event when appropriate.

---

## 10. Per-simulation and per-cast asset requirements

### Reusable style assets

- brand typography;
- logo treatments;
- particles;
- AI-core ring;
- relationship graph components;
- gauges;
- HUD panels;
- transitions;
- SFX;
- music;
- text components;
- color-grade presets;
- map and village UI systems.

### Required per simulation

- establishing environment shot or loop;
- map/world representation;
- night or pressure variation;
- one social-interaction or conversation loop;
- one mode-specific visual;
- one group/cast movement asset;
- simulation name, mode, rules, and relationship data.

### Required per cast

- one clean cutout per Double;
- name and one concise trait;
- group photo or generated group composition;
- relationship metadata;
- optional expression or pose variants;
- quality score and crop-safe regions.

### Minimum asset quality

- no visibly mismatched cast;
- no low-resolution face enlargement;
- no portrait with unintended background when transparency is expected;
- no stretched source;
- no major face or text inside unsafe crop areas;
- no generated hand/body defect in featured hero cards;
- no unapproved group image as the poster.

---

## 11. Automated quality gates

The validator must extend beyond resolution, duration, and loudness.

### 11.1 Technical gates

- 1080×1920 minimum;
- 9:16 aspect;
- 30 fps minimum;
- duration within configured bounds (**default 65–95 sec**; may extend for large casts — longer total runtime is expected, not a defect);
- audio stream present;
- final loudness near target;
- true peak ≤ -1 dBTP;
- no missing frames;
- no corrupt assets;
- no unintentional black tail;
- poster still exported.

### 11.2 Editorial-motion gates

Suggested initial thresholds:

- meaningful visual-change rate: at least 16 per minute;
- low-motion sampled-frame ratio: below 30%;
- no unplanned near-static interval longer than 2.5 sec;
- end card between 3.5 and 5 sec;
- no single repeated background treatment longer than 6 sec;
- at least one motivated transition in every major section;
- at least three visible developments in the hook;
- at least two visual treatments in the world/relationship section;
- cast block no longer than 20 sec;
- every Double represented when cast size is 15 or fewer.

These thresholds should create warnings first. After several approved trailers establish reliable ranges, the most important warnings can become blocking errors.

### 11.3 Text gates

- all lines finish before exit;
- no text outside safe areas;
- no collision between captions and names;
- no RGB ghost after typing completion;
- no infinite pulse on fixed copy;
- minimum on-screen readable hold;
- word count and font size remain within approved limits.

### 11.4 Asset gates

- cohort IDs match the simulation;
- all featured cast members have approved assets;
- group photo exists for poster generation;
- fallback asset is recorded in QA report;
- low-quality assets cannot be silently promoted to full-screen hero use.

### 11.5 Duplicate and repetition checks

Compute perceptual similarity across frames and flag:

- the same image held with minimal change;
- the same group portrait appearing in several neighboring beats;
- duplicated card layouts without directional or compositional variation;
- a visually empty final tail.

---

## 12. Implementation priorities

**Status (2026-06-24):** Playbook §12 P0 items **1–8 largely shipped on `opener&006`** (text settle, hook merge, Talk hero, poster, SFX/mix, Family.mp4 once, asset manifest). **Remaining P0 work** is Phase 6 in `20260617_…`: CSV-driven sub-moment planner, named transition primitives, producer-accurate timing, cast selection panels, mid-trailer URL, structured end card, full SFX log. See automation doc Phase 6A–6D.

## P0 — Highest impact; fix the current trailer language

1. Decouple visual beats from narration segments → **~50 sub-moments from producer CSV** *(partial on 006)*.
2. Rebuild the hook as one continuous sequence with motivated handoffs *(partial — `hookContinuous`)*.
3. Implement `type-then-hold`; remove persistent headline glitch. **✅ 006**
4. Promote `Talk.mp4` to a hero layer. **✅ 006**
5. Redesign end card as `questionToUrlTakeover` *(006 uses 4s static hold — open)*.
6. Add transition SFX from `sfx_log.csv` (~39 hits) and final mix normalization. **Partial — ~7 hits on 006; LUFS ✅**
7. Add the split-layout concept/poster frame. **✅ 006**
8. Export a poster still with every trailer. **✅ 006**

**Expected result:** `opener&007+` should approach Anya motion density (~23.5 visual changes/min), not just smoother slides.

## P1 — Make the system robust for new simulations

1. Add asset manifests and quality scoring.
2. Automatically generate and verify per-cast cutouts and group image.
3. Add per-simulation environment asset pack.
4. Generalize relationship layouts for 2–15 people.
5. Implement cast strategies for 1–4, 5–8, and 9–15.
6. Prevent wrong-cohort fallback assets.
7. Add editorial-motion validation.

**Expected result:** New simulations can be rendered without manual scene rebuilding and without collapsing into a repetitive slideshow.

## P2 — Improve consistency and creative variation

1. Add two or three approved transition paths per major beat.
2. Add approved composition variants selected using asset shape and cast size.
3. Build a golden test set of at least 10 simulations.
4. Compare automated metrics and producer ratings.
5. Tune thresholds based on approved outputs.
6. Add optional 60 fps delivery only after motion design is correct.
7. Add automated thumbnail scoring and variant export.

---

## 13. Recommended development tickets

### Ticket 1 — Visual timeline decoupling

**Goal:** Permit **~50 producer sub-moments** per four-person opener; multiple visual beats per narration segment and visuals spanning several narration segments.

**Acceptance criteria**

- Planner consumes `teadown/20260624_doubland_timecode_index.csv` (or cohort-adapted equivalent).
- Hook §1–3 render as one continuous sequence with sub-moment timestamps.
- Visual beat timestamps are stored independently of narration segment boundaries.
- Text and SFX props align with `text_log.csv` and `sfx_log.csv` within ±0.2s.
- Renderer supports overlaps, anticipatory transitions, and named primitives (§8).

### Ticket 2 — Shared text-settle behavior

**Goal:** All readable text stops moving after entry.

**Acceptance criteria**

- `GlitchText` removes ghost layers on completion.
- cursor disappears after typing;
- final copy holds still ≥0.8 sec;
- glow is entry-only;
- screenshots after completion show one clean text layer.

### Ticket 3 — Hook morph sequence

**Goal:** Create one continuous branded hook.

**Acceptance criteria**

- at least four developments in 14 sec;
- no full black reset between lines;
- Talk asset is prominent on the hard-conversation phrase;
- final hook element motivates the concept card;
- SFX align with major transformations.

### Ticket 4 — Poster/concept composition

**Goal:** Match the reference concept card and export a poster.

**Acceptance criteria**

- matrix-treated group image at top;
- clean group image at bottom;
- black information band;
- Double treatment and concept line;
- poster exported as PNG/JPEG;
- poster validated for correct cohort.

### Ticket 5 — Cast scaling

**Goal:** Support up to 15 Doubles without extending the **cast block** beyond approximately 20 sec (total trailer may run longer — expected for large casts).

**Acceptance criteria**

- CLI accepts 1–15;
- all cast sizes produce valid layouts;
- every Double is visible;
- no more than four receive long hero cards;
- cast block stays efficient; **total runtime may exceed four-person baseline** without failing QA;
- no exactly-four-person conditional remains in graph generation.

### Ticket 6 — Audio punctuation and mix

**Goal:** Match reference energy while preserving safe delivery levels.

**Acceptance criteria**

- SFX roles are stored in TrailerSpec;
- ducking responds to narration;
- final loudness approximately -14 LUFS;
- true peak ≤ -1 dBTP;
- no silent or very quiet tail;
- QA report lists mix values.

### Ticket 7 — Editorial validator

**Goal:** Detect slideshow-like output before review.

**Acceptance criteria**

- reports low-motion ratio;
- reports longest static run;
- reports visual-change rate;
- flags long end card;
- flags repeated background assets;
- flags unfinished or continuously animated text;
- produces machine-readable JSON and human-readable HTML/Markdown.

---

## 14. Definition of done

The automated system is ready for routine use when:

1. A new simulation with a new cast can be processed without manually editing the Remotion composition.
2. Every generated trailer uses correct cast and simulation assets.
3. Trailers with 4, 8, and 15 Doubles all render successfully with correct cast coverage (total duration may increase with cast size — expected).
4. All cast members appear, but only a limited set receives extended hero treatment.
5. The trailer contains a continuous hook, motivated transitions, layered depth, and a short resolved end card.
6. Text animates into place and then becomes stable.
7. Audio reaches the intended energy and passes loudness/peak gates.
8. A poster is exported automatically.
9. Editorial validation detects low-motion, repetition, and missing-richness failures.
10. A producer reviewing the golden test set rates the automated trailers close to the hand-edited reference in:
   - smoothness;
   - visual richness;
   - clarity;
   - emotional energy;
   - brand consistency.

---

## 15. Product assumption used in this playbook

For simulations containing up to 15 Doubles:

- every Double should appear visually;
- three or four may be featured individually;
- not every Double should receive a narrated trait line;
- **total trailer length may exceed a four-person baseline** — more participants → longer runtime is normal, within validator bounds.

Requiring 15 individually narrated introductions would force either a substantially longer trailer or extremely rushed pacing. If individual narration for all 15 is a product requirement, the system should generate a separate **cast reveal trailer** rather than forcing it into the standard opening trailer.

---

# 16. Asset-mapped production standard

This section is the operational source of truth for the supplied Anya asset package. It supersedes generic statements elsewhere in the playbook whenever a specific asset or component is named here.

**Asset roots on disk (all paths below are absolute):**

| Folder | Path |
|---|---|
| Motion clips | `D:\Coding\generative_agents\video\opening-anya\Anya_animated\` |
| PNG overlays & boards | `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\` |

> **Note:** The expert draft used `(1)` suffixes on some filenames (e.g. `Double(1).png`) from duplicate downloads. On disk the files are **`Double.png`**, **`Cards1.png`**, etc. — paths in this doc match the repo.

## 16.1 Core rule: use the assets as a design system, not as a slideshow

The package contains four different kinds of material:

1. **Motion clips** that can be placed directly in the timeline.
2. **Reusable visual overlays and brand elements** that can be composited directly.
3. **Examples of standard components** that developers must rebuild with dynamic data.
4. **Composite reference boards** that explain the visual language but must not appear directly in a production trailer.

The renderer must know the class of every asset. A reference board must never be selected as a production background simply because it matches a semantic keyword.

```ts
type RenderPolicy =
  | "direct-motion"
  | "direct-overlay"
  | "dynamic-component-template"
  | "current-cast-example"
  | "reference-only";
```

## 16.2 Critical data-consistency warning

Several supplied boards contain baked-in names, traits, percentages, labels, or counts. Some labels are inconsistent across boards. For example:

- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Dasha.png` visibly says **KATYA** and should not be addressed as “Dasha.”
- The cast/name assignments shown inside `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards1.png` are not fully consistent with the separate individual-card files.
- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Map.png` contains fixed names and fixed world values.
- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards2.png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards3.png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Profile.png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Connections.png`, and `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Survival.png` all contain fixed example data.
- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards4.png` and some composite boards contain malformed generated text and therefore cannot be treated as final copy.

**Production rule:** simulation data and canonical persona IDs are always the source of truth. Never parse identity, traits, or values from pixels. Never rely on a human-readable filename as the persona ID.

Recommended structure:

```text
assets/
  reusable/
    brand/
    hook/
    ui/
    transitions/
  simulations/<simulation_slug>/
    world/
    season/
  cohorts/<cohort_slug>/
    group/
    personas/<persona_id>/
      source_portrait.png
      cutout.png
      expression_variants/
```

Example manifest identity record:

```json
{
  "personaId": "persona_7f29",
  "displayName": "Katya",
  "cohortId": "pistsov_family",
  "portraitAssetId": "portrait_persona_7f29",
  "featuredTrait": "Social",
  "status": "ONLINE"
}
```

## 16.3 Asset classes

### A. Direct motion clips

These are the strongest production-ready assets in the package.

| Supplied asset | Technical shape | Standard trailer role | Required treatment |
|---|---|---|---|
| `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Talk.mp4` | 1848×1120, 24 fps, ~5.0 sec, landscape | Hard-conversation hook; “talking like you”; relationship rehearsal | Hero layer, not a faint texture. Crop for vertical using subject-aware positioning; keep both silhouettes visible. Add live chat bubble animation above the clip if needed. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Family.mp4` | 1764×1172, 24 fps, ~5.0 sec, landscape | Cohort reveal; “this season”; transition from real people to Doubles | Place inside a HUD frame or crop carefully. Use only once as the principal warm human moment. Do not repeat unchanged in later beats. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Pressure.mp4` | 1076×1928, 24 fps, ~3.0 sec, near-vertical | Pressure peak; threat rising; Survival escalation | Use as a full-height hero layer. Let the needle make one sweep from low to critical. Time an impact/riser to the red-zone entry. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Village.mp4` | 1264×720, 24 fps, ~3.0 sec, landscape top-down view | World-entry transition; map movement; simulation establishing texture | Use as a moving bridge into `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Map.png`, not as a long static hero. Apply slow vertical crop/push and layer map nodes or UI above it. |

**Motion-clip rule:** Do not slow these clips so much that they appear static. Do not loop them visibly. If a beat exceeds the source duration, transition to a complementary still or component rather than repeating the same motion.

### B. Direct overlays and brand elements

| Supplied asset | Standard role | Usage rule |
|---|---|---|
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset4.png` | Blue horizontal light ignition/wipe | Use at the start, between major chapters, or to resolve into a scanner line. Animate scale-X and glow once; do not pulse indefinitely. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Double.png` | **DOUBLE** concept wordmark | Use when narration first defines the Double. Full-screen black treatment is acceptable. Hold cleanly after entry. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\DOUBLAND.png` | Doubland “Simulation Active” mark | Use for simulation activation or the end-card logo. Maintain transparent/black presentation and generous safe area. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\DOUBLAND2.png` | `WWW.DOUBLAND.AI` URL treatment | Use only on the final end card. Render for at least 1.5 seconds at readable size. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\F1714AC2-78E4-434B-844C-30F0A03D4DD7.png` | **REPLAY** control | Use specifically with “Replay every moment,” not as generic decoration or the final CTA. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Photoroom_20260611_151820.png` | Transparent four-person cohort cutout | Use as a flexible foreground layer over the concept card, season card, or world interface. Replace with a newly generated cutout for every new cohort. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Survival.png` | Transparent Survival and season-title overlays | Split into separate assets before use: `survival_mode_banner` and `season_title_plate`. Replace mode and season text dynamically. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset2.png` | Chat-bubble composition | Use as a secondary conversation layer or fallback when `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Talk.mp4` is unavailable. Animate bubbles individually; do not leave the entire image static. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset3.png` | Static conversation/live-feed composition | Use as a fallback still for `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Talk.mp4` or as a freeze-frame at the end of that clip. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Family.png` | Warm group photo with room background | Use as the clean cohort photograph in the concept/poster frame. Replace per cohort. |

### C. Dynamic component templates

These assets define the standard Doubland interface. Their style should be reproduced in code using live simulation data. The original image is a design reference, not the final rendered component.

| Supplied asset | Component to build | Dynamic inputs |
|---|---|---|
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Dasha.png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Gosha .png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Iván.png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Luba.png` | `DoubleIdentityCard` | portrait/cutout, display name, status, optional role, accent state |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards3.png` | `PersonalityTraitCards` | selected cast members, 2–3 short traits, trait icons, feature color |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards4.png` | `PersonalityAnalysisPanel` and `DoubleInitializerRadial` | trait labels, scores, profile progress, enabled data domains |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Profile.png` | `CohortInitializationProgress` | persona names/IDs, current progress, initialization state |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Map.png` | `WorldMapHUD` | active Doubles, location nodes, current focus person, relationship graph, world metrics |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards2.png` | `SurvivalDashboard` | players remaining, alliances, conflicts, events, decisions, active Doubles, live feed, day progress |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Connections.png` | `RelationshipDeltaToast` | source/target personas, relationship type, signed delta, new value |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Connections2.png` | `ConversationPanel`, `RelationshipGraph`, and `DecisionTree` | participants, dialogue state, relationship labels, choices, outcomes |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards1.png` | `ConceptSequenceLayout` | cohort photo, scan state, individual Doubles, behavior examples |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards5.png` | `CastAssetLayoutReference` | clean group, scanned group, individual identity cards |

### D. Reference-only motif boards

| Supplied asset | Why it exists | Production restriction |
|---|---|---|
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset.png` | Hook motif board: glitch texture, profile ring, digital network, human silhouettes | Split into clean motif elements or recreate them. Do not render the labeled 2×2 board. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards1.png` | Storyboard/reference for group-to-Doubles reveal and behavior examples | Do not use directly because names and layout are baked in and it is landscape. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards5.png` | Asset-board reference showing clean group, scan, and identity cards | Do not render the white design-board background. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Connections2.png` | Reference board for conversation, chat, relationships, and decisions | Rebuild the four modules. Do not use the full 2×2 board in the trailer. |
| `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards4.png` | Reference for analysis/initialization components | Rebuild because some baked text is malformed and data is fixed. |

## 16.4 Standard `DoubleIdentityCard`

The individual portrait examples—`D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Dasha.png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Gosha .png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Iván.png`, and `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Luba.png`—define the mandatory identity-card style for individual Double introductions.

### Required appearance

- dark navy/black technological background;
- thin cyan border and corner brackets;
- portrait occupying approximately 70–80% of the card height;
- subtle cyan rim light around the person;
- lower-left display name in white uppercase;
- `AI DOUBLE` beneath the name in cyan;
- green status dot and `ONLINE` beneath that;
- short cyan loading/data bar along the bottom;
- no unnecessary paragraph text;
- no perpetual glow or movement after the card settles.

### Required implementation

Do **not** use the supplied 323–334 px-wide card images as full-screen production art. They are too small to be repeatedly enlarged to 1080×1920 and contain baked-in names.

Build the frame in Remotion as a vector/CSS component and inject a high-resolution per-person cutout.

```ts
type DoubleIdentityCardProps = {
  personaId: string;
  displayName: string;
  portraitSrc: string;
  status: "ONLINE" | "OFFLINE" | "INITIALIZING";
  role?: string;
  featuredTrait?: string;
  entryDirection: "left" | "right" | "up";
  accentState: "normal" | "alliance" | "conflict";
};
```

### Standard animation

1. card border draws in over 8–12 frames;
2. portrait resolves from scan/noise into clean image;
3. name and `AI DOUBLE` fade/slide in;
4. status dot turns on;
5. bottom data bar fills once;
6. card holds completely still for at least 0.8 seconds;
7. the next card begins entering before the current card fully exits.

The frame remains consistent across all simulations. The portrait, name, role, status, and selected trait are variable.

## 16.5 Standard component library

The following components should be implemented once and reused.

### `HookProfileRing`

Reference: upper-right motif in `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset.png`.

Use:

- opening seconds;
- transition from abstract question to a human profile;
- link between the light line and personality analysis.

Motion:

- ring draws once;
- scan ticks rotate no more than 30–45 degrees;
- central void resolves into a silhouette or portrait;
- ring then becomes another circular UI element, such as the Double initializer.

### `ConversationHero`

Primary source: `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Talk.mp4`.  
Fallbacks: `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset3.png`, then `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset2.png`.

Use:

- “practice that hard conversation”;
- “talking like you”;
- relationship rehearsal or live dialogue.

Required enhancements:

- chat dots animate;
- one bubble resolves into a short line or abstract text strokes;
- live-feed corners or a scan line appear;
- clip is presented at ≥75% visual prominence;
- no competing relationship diagram covering the faces.

### `DoubleInitializer`

References: `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards4.png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Profile.png`, and `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Double.png`.

Use:

- “an AI version of you”;
- explaining that the Double is based on personality, voice, decisions, behavior, relationships, and memories;
- transition into the cast.

Motion:

- categories activate one at a time;
- progress bars fill;
- central `DOUBLE` wordmark resolves;
- completion creates the identity-card frame.

Do not show six categories long enough for viewers to read every label. The component communicates construction, not a settings tutorial.

### `WorldMapHUD`

Reference: `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Map.png`.

Use:

- “watch it live in a world with other Doubles”;
- every conversation/choice/relationship;
- current world status;
- focus-person location.

Required dynamic layers:

- world image/environment;
- 2–6 visible location nodes at a time;
- top-left status module;
- top-right map or radar module;
- bottom relationship graph;
- bottom focused-person panel.

For casts above six, show clusters rather than all nodes simultaneously.

### `SurvivalDashboard`

Reference: `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards2.png`.

Use:

- season premise;
- one fast dashboard scan before pressure begins;
- live alliances/conflicts/activity.

This dashboard is information-dense. Never hold the entire board as a static poster for several seconds. Animate it as three editorial crops:

1. overview and world status;
2. active Doubles;
3. alliances/conflicts/feed.

Total screen time should normally remain 2.5–4 seconds.

### `PersonalityTraitCard`

Reference: `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards3.png`.

Use:

- supporting visual during each featured cast line;
- group comparison;
- transition from individual people to strategic dynamics.

Rules:

- maximum three one- or two-word traits;
- icons remain consistent by trait category;
- cyan for normal traits;
- orange/red only for risk, impulsivity, conflict, or Survival pressure;
- traits come from the showrunner, not the baked example image.

### `RelationshipGraph`

References: `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Connections2.png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Map.png`, and the lower-left section of `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards2.png`.

Use:

- relationships becoming part of the game;
- alliances, rivalry, trust, influence;
- learning and change.

Rules:

- draw only narratively useful edges;
- label no more than four edges at once;
- pulse the changed relationship once;
- use clusters for 9–15 cast members;
- never display an unreadable complete graph.

### `RelationshipDeltaToast`

Reference: `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Connections.png`.

Use:

- a quick consequence after a conversation, choice, alliance, or conflict.

Example generated copy:

```text
RELATIONSHIP UPDATED
+12 TRUST
```

Rules:

- appears for 0.8–1.5 seconds;
- generated value must be real simulation data or an explicitly fictional trailer example;
- use green/cyan for gains and orange/red for losses;
- names and icons are inserted dynamically;
- white background from the reference asset is not reproduced.

### `DecisionTree`

Reference: lower-right quadrant of `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Connections2.png`.

Use:

- “making choices like you”;
- showing that choices create outcomes;
- pressure/strategy montage.

Motion:

- decision node appears;
- two choices branch;
- one route highlights;
- outcome nodes appear;
- component exits before it becomes a tutorial diagram.

### `SeasonModeBanner`

Reference: upper element of `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Survival.png`.

Use:

- exact transition into Survival mode;
- first red/orange accent in an otherwise cyan trailer.

Motion:

- warning icon flashes once;
- red line sweeps across;
- `SURVIVAL MODE INITIATED` locks in;
- immediately hand off into `SurvivalDashboard` or `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Pressure.mp4`.

### `ReplayControl`

Reference: `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\F1714AC2-78E4-434B-844C-30F0A03D4DD7.png`.

Use only when narration says “Replay every moment.”

Motion:

- control appears;
- progress line scrubs backward briefly;
- one prior image flashes;
- control exits.

It is not the final CTA and should not imply a clickable control inside the rendered video.

## 16.6 Exact trailer-to-asset map

The following map uses a **~74–82 second four-person baseline** for beat timestamps. Timings shift with narration and **total runtime grows for larger casts** (expected); asset roles stay stable.

| Trailer part | Target timing | Primary standard assets/components | Supporting assets | Required handoff |
|---|---:|---|---|---|
| **Question 1: second chance** | 0:00–0:03 | `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset4.png` → `HookProfileRing` | glitch/network motifs recreated from `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset.png` | light line bends into the profile ring |
| **Question 2: hard conversation** | 0:03–0:08 | `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Talk.mp4` via `ConversationHero` | `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset2.png` chat bubbles; `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset3.png` as settled freeze | chat bubble/node grows into network |
| **Question 3: What if you had a Double?** | 0:08–0:14 | digital network/silhouette motifs → `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Double.png` | `DoubleInitializer` ring from `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards4.png` | central ring becomes the `DOUBLE` wordmark |
| **Concept: an AI version of you** | 0:14–0:20 | `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Family.mp4` + `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Family.png`/cohort photo + `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Profile.png` component | `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Photoroom_20260611_151820.png` for foreground separation | face scan breaks the group into identity cards |
| **Talking/reacting/choosing like you** | 0:20–0:27 | `DoubleIdentityCard`, `ConversationHero`, `DecisionTree` | layout direction from `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards1.png` | one portrait card expands into the world |
| **World with other Doubles** | 0:27–0:35 | `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Village.mp4` → `WorldMapHUD` based on `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Map.png` | relationship nodes, status panels | map node becomes season alert |
| **Season setup / Survival mode** | 0:35–0:42 | `SeasonModeBanner` from `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Survival.png` + `SurvivalDashboard` from `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards2.png` | `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Family.mp4` or cohort cutout for the cast transition | dashboard cards separate into individual cast cards |
| **Featured cast** | 0:42–0:58 | generated `DoubleIdentityCard` based on the four example portrait cards | `PersonalityTraitCard` from `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards3.png`; cohort cutout | last trait icon becomes pressure gauge marker |
| **Pressure, alliances, conflict** | 0:58–1:07 | `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Pressure.mp4` + `RelationshipGraph` | `RelationshipDeltaToast`; conflict crop from dashboard | gauge/radar circle becomes world node |
| **They learn, change, surprise you** | 1:07–1:14 | `WorldMapHUD`, `PersonalityAnalysisPanel`, relationship updates | `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Connections.png` component, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards4.png` style | overlays disappear, leaving one Double/question |
| **Watch/follow/replay** | place within world or turn section | map focus, identity card focus, `ReplayControl` | optional fast recap frames | replay progress resolves into logo line |
| **End card** | final 0:04–0:05 | `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\DOUBLAND.png` + `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\DOUBLAND2.png` | restrained particles; optional final `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Double.png` echo | no further transition; clean static hold |

## 16.7 Cast-size mapping

### 1–4 Doubles

- every person receives a standard `DoubleIdentityCard`;
- each featured card receives approximately 2.0–2.8 seconds;
- `Cards3`-style trait card may accompany each person;
- group photo and relationship graph show the complete cast.

### 5–8 Doubles

- 3–4 people receive hero identity cards;
- remaining people appear in paired card layouts;
- one `PersonalityTraitCards` panel summarizes the rest;
- `WorldMapHUD` shows all as nodes but highlights only the featured people.

### 9–15 Doubles

- three people receive hero identity cards;
- others appear in three visual clusters;
- use an identity-card matrix for 1.5–2.5 seconds;
- group/cluster relationship graph represents everyone;
- do not create 15 narrated introductions;
- total cast block remains under approximately 20 seconds.

The individual identity-card frame remains visually consistent at every cast size. Only the layout and screen time change. **Total trailer runtime may exceed a four-person baseline** as cast size grows — expected (Duration policy).

## 16.8 Direct-render restrictions

The following assets must not be used unchanged in final trailers:

- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset.png`
- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards1.png`
- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards4.png`
- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards5.png`
- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Connections.png`
- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Connections2.png`
- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Profile.png`
- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Map.png`
- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards2.png`
- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards3.png`
- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Survival.png`
- the four low-resolution individual identity-card examples

They contain one or more of:

- baked-in current-cast names;
- fixed statistics;
- fixed counts;
- stale or conflicting identity labels;
- malformed generated text;
- insufficient resolution;
- a landscape or design-board layout;
- white background not compatible with the trailer;
- too much information for mobile viewing.

They are visual specifications for components.

## 16.9 Asset-quality and resolver rules

Every asset manifest record must include:

```json
{
  "assetId": "talk_motion",
  "sourceFile": "D:\\Coding\\generative_agents\\video\\opening-anya\\Anya_animated\\Talk.mp4",
  "renderPolicy": "direct-motion",
  "sceneRoles": ["hard_conversation", "talking_like_you"],
  "cohortScope": "reusable",
  "containsBakedText": false,
  "containsBakedIdentity": false,
  "minimumDisplayWidthPx": 720,
  "preferredCrop": "center-subject-pair",
  "approved": true
}
```

Resolver rejection rules:

1. Reject a different cohort’s portrait or group photo.
2. Reject any `reference-only` asset from final rendering.
3. Reject a component-template image when dynamic values do not match.
4. Reject identity cards below the minimum effective resolution.
5. Reject a landscape asset used full-screen in vertical format without an approved crop.
6. Reject any baked name that differs from the selected persona.
7. Reject malformed or AI-generated text.
8. Reject repeated use of the same hero asset in neighboring beats.

## 16.10 Brand-style tokens inferred from the supplied package

The component library should centralize the following tokens.

```ts
const doublandStyle = {
  background: "#02070D",
  panel: "rgba(3, 18, 31, 0.86)",
  cyan: "#27D7FF",
  blue: "#168BFF",
  white: "#F3FAFF",
  green: "#00F29A",
  warning: "#FF5A42",
  borderWidth: 2,
  cornerRadius: 18,
  gridOpacity: 0.12,
  glowStrength: "controlled",
  typography: {
    case: "uppercase",
    headlineTracking: "wide",
    dataTracking: "normal"
  }
};
```

These are implementation directions, not exact sampled brand values. Developers should replace them with the project’s approved brand tokens if those already exist.

Style rules:

- cyan/blue is the default system color;
- green is reserved for online/positive status;
- orange/red appears only for Survival, conflict, loss, or critical pressure;
- text is mostly uppercase;
- panels use thin borders, corner brackets, sparse grid texture, and restrained glow;
- cinematic human imagery remains warm, creating contrast with the cold UI;
- the UI should frame the subject, not cover the subject;
- only one major element glows strongly at a time.

## 16.11 Motion rules for the standard asset system

Each standard component must expose the same lifecycle:

```ts
type ComponentPhase = "enter" | "develop" | "settle" | "handoff";
```

- **Enter:** draw, scan, reveal, or slide into place.
- **Develop:** update a value, connect nodes, fill a bar, or reveal a trait.
- **Settle:** stop moving and allow the viewer to read.
- **Handoff:** one element motivates the next component.

Examples:

- `DoubleIdentityCard`: scan → reveal portrait → show status → hold → card edge becomes map panel.
- `RelationshipGraph`: draw nodes → connect one edge → update trust → hold → highlighted node becomes map location.
- `PressureGauge`: enter at low → sweep once → critical impact → hold briefly → circular gauge becomes radar.
- `SeasonModeBanner`: warning line → title lock → hold → slide upward into dashboard header.

## 16.12 Updated development priority

**Phase 5 P0 (asset wiring on 006):** items 2–5, 8, 10 largely complete. **Phase 6 (visual grammar):** items 1, 6–7, 9 and all P1 component rebuilds remain open — see automation doc Phase 6A–6D.

### P0: wire the supplied assets correctly

1. Register every supplied file in an asset manifest with its render policy.
2. Make `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Talk.mp4` the hero visual for the hard-conversation line.
3. Make `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Family.mp4` the human/cast reveal and use it only once.
4. Use `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Village.mp4` as the moving bridge into a rebuilt `WorldMapHUD`.
5. Use `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Pressure.mp4` as the pressure peak.
6. Build `DoubleIdentityCard` from the portrait examples.
7. Split and rebuild `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Survival.png` as a dynamic mode banner and season plate.
8. Build the final brand card from `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\DOUBLAND.png` and `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\DOUBLAND2.png`.
9. Use the replay control only on “Replay every moment.”
10. Block all reference boards from direct rendering.

### P1: rebuild baked UI as live components

1. `CohortInitializationProgress`
2. `PersonalityAnalysisPanel`
3. `PersonalityTraitCards`
4. `WorldMapHUD`
5. `SurvivalDashboard`
6. `RelationshipGraph`
7. `RelationshipDeltaToast`
8. `DecisionTree`

### P2: scale and validate

1. Generate new high-resolution portraits and cutouts for each cohort.
2. Support 1–15 cast layouts.
3. Add identity-label and cohort validation.
4. Add automatic safe cropping for the four landscape motion clips.
5. Add visual-repetition and low-motion gates.
6. Test the standard asset system on at least one 4-, 8-, and 15-person simulation.

## 16.13 Asset-mapped acceptance test

A trailer fails review when any of the following is true:

- the hard-conversation line does not visibly feature `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Talk.mp4` or its approved replacement;
- an individual Double is introduced outside the standard identity-card frame;
- a card’s baked name does not match simulation data;
- a composite reference board appears as a full shot;
- `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Map.png` or the Survival dashboard shows stale example values;
- the group image belongs to the wrong cohort;
- the same group image is held unchanged through multiple sections;
- `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Pressure.mp4` is absent from the pressure peak without an approved replacement;
- a **mid-trailer URL plate** (`WWW.DOUBLAND.AI` ~59.4s) is missing when the producer spec applies to this template;
- the **final end-card URL** appears before the final question resolves, or is too small to read;
- replay artwork is used as the final CTA;
- the end card uses a long static hold instead of **`questionToUrlTakeover`** (structured ~4.9s, not 10s+ tail);
- text continues pulsing after it has become readable;
- the trailer uses cyan, red, green, and white without the semantic color rules above.

## 16.14 Final editorial principle

Anya’s production level comes from combining a **small number of consistent branded components** with continuous motion handoffs—not from placing every available asset into the video.

For each narration beat, the planner should select:

- one primary hero asset or component;
- one supporting information layer;
- one ambient layer;
- one transition element.

The package should feel like one operating Doubland interface that moves through human conversation, AI creation, the world, the cast, pressure, relationships, and the final question. It should never feel like a folder of unrelated graphics being shown one after another.

---

# 17. Generalizing current assets for new simulations and casts

This section converts the current Pistsov-family-specific asset package into a reusable asset-generation playbook. For each current asset, it defines:

1. **What the current asset is doing in the reference trailer**
2. **What generalized asset should exist in the reusable system**
3. **A prompt template** to use with an AI image or video generation tool to create the generalized version

These prompts are written so they can be filled with the new simulation’s data. Replace bracketed placeholders such as `[CAST_SIZE]`, `[COHORT_NAME]`, `[PERSONA_NAME]`, `[MODE_NAME]`, `[WORLD_STYLE]`, `[PRIMARY_TRAIT]`, and `[RELATIONSHIP_LABEL]` before generation.

## 17.1 General prompt rules

Use these rules for all generalized asset generation:

- generate assets in the **Doubland visual style** unless the prompt says otherwise;
- maintain a **dark black/navy background**, **cyan/blue neon interface accents**, **white uppercase typography**, **thin HUD borders**, **subtle scan/grid texture**, and **controlled glow**;
- keep cinematic human imagery warm and natural, contrasting against the colder UI;
- avoid clutter; every asset should have **one clear focal subject**;
- leave enough negative space for motion, text, cropping, and compositing in a vertical 9:16 trailer;
- when generating a still that will become a motion beat later, prefer a **clean layered composition** over a finished poster-like image;
- when generating a motion clip, favor **3–5 seconds**, clear movement, and a clean start/end state;
- avoid embedded names or values unless the asset is meant to be cohort-specific after prompt filling;
- when the asset is intended as a template component, the prompt should request a **clean frame/system** rather than fixed narrative content.

## 17.2 Hook and abstract UI assets

### 17.2.1 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset.png` → generalized hook motif pack

**Current role:** Reference board for four hook motifs: tiny glitch, profile loading ring, digital network, and human silhouettes.

**Generalized reusable asset:** A set of clean, separate hook motifs or one motif board used only as style reference.

**Prompt:**
```text
Create a futuristic Doubland-style hook motif pack on a black background with cyan-blue neon UI glow. Include four separate abstract motifs: 
1) a subtle digital glitch texture with horizontal scan interference,
2) a luminous circular profile-loading ring with technical HUD markings,
3) a glowing digital relationship network of nodes and lines,
4) soft human silhouettes emerging from blue light and digital haze.
The style should feel elegant, cinematic, minimal, and premium. Use thin interface lines, sparse particles, and restrained glow. Keep each motif visually isolated with clean negative space so the motifs can be split into individual assets later. No large titles or labels. High-resolution, crisp, dark sci-fi interface design.
```

### 17.2.2 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset2.png` → generalized chat-bubble overlay

**Current role:** Static chat-bubble composition used as a fallback or supporting overlay.

**Generalized reusable asset:** Clean conversation UI overlay not tied to a specific cast.

**Prompt:**
```text
Create a premium futuristic conversation UI overlay for Doubland on a black background. Show three glowing white and cyan chat bubbles of different sizes floating in a minimal HUD environment with dotted technical accents, thin brackets, and subtle scan-line details. The composition should feel like a clean communication interface, with no real text inside the bubbles, only abstract text lines or dots. Elegant neon glow, dark sci-fi look, minimal clutter, suitable as an overlay in a vertical trailer.
```

### 17.2.3 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset3.png` → generalized live-conversation still

**Current role:** Live-feed style conversation still with two digital people and chat bubbles.

**Generalized reusable asset:** Cast-agnostic conversation screen showing two people talking.

**Prompt:**
```text
Create a Doubland-style live conversation interface on a black background. Show two human figures in profile facing each other, rendered as luminous blue digital wireframe or point-cloud silhouettes, with glowing chat bubbles floating between them. Add subtle live-feed UI framing in the corners, tiny status text, dotted HUD accents, and a cinematic futuristic interface feel. Keep the scene clean, readable, and emotionally focused on conversation. No specific names. High-resolution, premium sci-fi visual language.
```

### 17.2.4 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset4.png` → generalized blue light ignition line

**Current role:** Horizontal blue light sweep used for ignition and transition.

**Generalized reusable asset:** Clean transition light-line overlay.

**Prompt:**
```text
Create a sleek horizontal blue energy line on a black background, centered across the frame, with a bright glowing core flare in the middle and soft cyan neon bloom extending outward. The line should feel precise, premium, and futuristic, suitable for use as a transition wipe or activation effect in a sci-fi interface trailer. Minimal composition, high contrast, no text.
```

## 17.3 Brand and CTA assets

### 17.3.1 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Double.png` → generalized DOUBLE concept wordmark

**Current role:** Concept wordmark used when the narration defines the Double.

**Generalized reusable asset:** Clean wordmark treatment for the term “DOUBLE”.

**Prompt:**
```text
Create a premium Doubland-style title card on a black background featuring the word “DOUBLE” in large futuristic uppercase lettering. Use a cyan-blue neon outline or glow, clean spacing, and elegant sci-fi branding. The composition should feel cinematic, minimal, and powerful, with subtle digital texture and restrained light bloom. No extra text unless very small ambient interface accents are needed.
```

### 17.3.2 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\DOUBLAND.png` → generalized Doubland active-logo plate

**Current role:** Simulation activation / end-card logo.

**Generalized reusable asset:** Reusable Doubland logo plate.

**Prompt:**
```text
Create a premium futuristic logo plate for DOUBLAND on a black background. Include a cyan-blue neon interface frame, a clean location-pin or simulation marker icon above or integrated with the wordmark, and a smaller subtitle area that can read “SIMULATION ACTIVE.” The style should be minimal, elegant, highly legible, and consistent with a premium sci-fi HUD system. Strong central alignment, controlled glow, and plenty of black negative space.
```

### 17.3.3 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\DOUBLAND2.png` → generalized URL end-card

**Current role:** Final URL treatment.

**Generalized reusable asset:** Website/URL end-card.

**Prompt:**
```text
Create a minimal futuristic end-card on a black background featuring the URL “WWW.DOUBLAND.AI” in large uppercase cyan-blue neon lettering. Make it crisp, highly legible, centered, and premium. Use restrained glow and subtle sci-fi interface atmosphere, but keep the URL as the dominant element. No unnecessary clutter.
```

### 17.3.4 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\F1714AC2-78E4-434B-844C-30F0A03D4DD7.png` → generalized replay-control overlay

**Current role:** Replay button used with “Replay every moment.”

**Generalized reusable asset:** Reusable replay interface element.

**Prompt:**
```text
Create a futuristic replay-control UI element on a black background. Show a rounded rectangular HUD-style button with a replay or fast-rewind icon and the word “REPLAY” in crisp uppercase lettering. Use cyan-blue neon borders, subtle glow, thin interface details, and a premium sci-fi dashboard feel. The element should be isolated and easy to composite over a trailer scene. No extra clutter.
```

## 17.4 Cohort and group assets

### 17.4.1 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Family.png` → generalized clean cohort photo

**Current role:** Clean warm group image of the current cast.

**Generalized reusable asset:** Cohort-specific group portrait for any new cast.

**Prompt:**
```text
Create a clean, cinematic group portrait of [CAST_SIZE] people representing the cohort “[COHORT_NAME]”. Show the group standing close together, facing camera naturally, with warm realistic lighting and a believable shared environment or softly blurred neutral interior background. The people should feel like a cohesive cast, visually distinct from one another, and emotionally grounded. Keep the composition centered and readable so it can be used in a trailer concept card and marketing collage. No text or UI overlay.
```

### 17.4.2 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Photoroom_20260611_151820.png` → generalized transparent group cutout

**Current role:** Transparent cutout of the full cast, used for layering over UI and backgrounds.

**Generalized reusable asset:** Transparent or isolated group cutout for any new cast.

**Prompt:**
```text
Create a clean isolated group cutout of [CAST_SIZE] people representing the cohort “[COHORT_NAME]”. The cast should be standing together in a natural staggered arrangement, fully visible from about thigh-up or waist-up, with realistic appearance, clean separation from the background, and subtle cinematic rim lighting. Output should look like a transparent-background cutout or black-background cutout suitable for compositing into a futuristic trailer. No text, no UI elements.
```

### 17.4.3 `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Family.mp4` → generalized group-reveal motion clip

**Current role:** Warm animated cast motion used in the concept and “this season” sections.

**Generalized reusable asset:** Short cohort-specific group motion clip.

**Prompt:**
```text
Create a 3 to 5 second cinematic motion clip showing the cohort “[COHORT_NAME]”, a cast of [CAST_SIZE] people, standing together in a warm realistic environment. Use subtle natural movement such as small head turns, breathing, eye contact, or slight posture shifts. The shot should feel emotionally grounded and premium, like a live-action hero moment before futuristic UI overlays appear. Keep the group clearly visible and centered, with clean framing that can crop vertically for a 9:16 trailer. No text.
```

## 17.5 Individual Double assets

### 17.5.1 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Dasha.png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Gosha .png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Iván.png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Luba.png` → generalized `DoubleIdentityCard` style reference

**Current role:** Example identity-card style for individual Doubles.

**Generalized reusable asset:** A reusable frame system plus cohort-specific individual cards.

**Prompt for the reusable frame style:**
```text
Create a premium futuristic identity-card frame for a character introduction in the Doubland trailer style. Use a dark navy-black HUD background, thin cyan border, corner brackets, subtle grid texture, and restrained neon glow. Leave space for a portrait in the upper and middle area. Reserve lower-left areas for a large uppercase character name, a smaller cyan line reading “AI DOUBLE”, and a small online-status row with a green dot and the word “ONLINE”. Include a thin glowing data bar near the bottom. The card should feel elegant, minimal, and modular. No specific character portrait or baked name.
```

**Prompt for a cohort-specific individual card image:**
```text
Create a premium Doubland-style individual character identity card for [PERSONA_NAME]. Show a realistic portrait of the character centered inside a dark futuristic HUD card with cyan-blue border accents, corner brackets, subtle digital texture, and soft rim lighting around the person. Include the large uppercase name “[PERSONA_NAME]”, the label “AI DOUBLE” beneath it, and a green online-status dot with the word “ONLINE”. Add a small glowing data bar near the bottom. The person should visually match the cohort “[COHORT_NAME]” and reflect traits such as [PRIMARY_TRAIT] and [SECONDARY_TRAIT]. High-resolution, vertical-friendly, clean and readable.
```

### 17.5.2 Clean isolated portrait / cutout for each persona

**Current role:** Needed to build new identity cards and cast sequences.

**Generalized reusable asset:** Per-person portrait cutout.

**Prompt:**
```text
Create a clean isolated portrait of [PERSONA_NAME] from the cohort “[COHORT_NAME]”. Show the character from chest-up or waist-up, facing camera with a natural confident expression, realistic lighting, and subtle rim light separation. The look should reflect traits such as [PRIMARY_TRAIT], [SECONDARY_TRAIT], and [TERTIARY_TRAIT]. Background should be transparent, pure black, or very clean and easy to remove so the portrait can be composited into a futuristic HUD card. No text.
```

## 17.6 World and simulation assets

### 17.6.1 `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Village.mp4` → generalized world-establishing aerial clip

**Current role:** World-entry motion, moving bridge into the map.

**Generalized reusable asset:** Short aerial/overview motion clip for the simulation world.

**Prompt:**
```text
Create a 3 to 5 second cinematic aerial motion clip of the simulation world “[WORLD_NAME]” in a [WORLD_STYLE] setting. Show a richly detailed environment from above or at a high angle, with a strong sense of place, subtle motion, and visual depth. The shot should feel like a premium fantasy-meets-digital simulation world that can support UI overlays. Include pathways, lights, buildings or landmarks, and a believable living environment. Composition should work for vertical cropping in a 9:16 trailer. No text.
```

### 17.6.2 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Map.png` → generalized `WorldMapHUD`

**Current role:** World status, location map, cast nodes, relationship panel, and focused-person panel.

**Generalized reusable asset:** A reusable world-map HUD component or one cohort-specific rendered map board.

**Prompt:**
```text
Create a futuristic world-status interface in the Doubland trailer style. Use a cinematic aerial view of the simulation world “[WORLD_NAME]” as the background and overlay elegant cyan-blue HUD panels. Include: a top-left world-status panel with live metrics, a top-right mini map or radar panel, several glowing location markers for selected cast members, a lower-left relationship-network panel, and a lower-right focused-person profile panel. Keep the interface clean, premium, and readable on mobile. The cast markers should correspond to [HIGHLIGHTED_PERSONAS], and the focused profile should be [FOCUSED_PERSONA]. Dark sci-fi UI, high detail, no clutter.
```

### 17.6.3 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Profile.png` → generalized cohort initialization progress board

**Current role:** Initialization progress bars for multiple cast members.

**Generalized reusable asset:** Live initialization board for current cohort.

**Prompt:**
```text
Create a futuristic cohort initialization progress board for Doubland on a black background. Show [CAST_SIZE] stacked progress rows, one for each cast member in [PERSONA_LIST]. Each row should include a circular user icon, the character name, the label “AI DOUBLE INITIALIZING”, a glowing horizontal progress bar, and a numeric completion percentage. Use a clean dark UI with cyan-blue glow, thin borders, and strong legibility. The board should feel like a live system status screen. No extra clutter.
```

## 17.7 Relationship and decision assets

### 17.7.1 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Connections.png` → generalized relationship-update toast

**Current role:** Small trust/relationship change card.

**Generalized reusable asset:** Reusable short-form relationship update overlay.

**Prompt:**
```text
Create a compact futuristic relationship-update UI card on a dark background. Show a small relationship network diagram or linked user icons near the top and a bold title such as “RELATIONSHIP UPDATED” in uppercase. Beneath it, show a large signed metric such as “[SIGNED_DELTA] [RELATIONSHIP_LABEL]”. Use cyan-blue glow for positive or neutral updates and orange-red glow for negative or conflict-based updates. Make it clean, legible, and easy to composite into a trailer.
```

### 17.7.2 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Connections2.png` → generalized conversation / relationship / decision component set

**Current role:** Reference board for four modules: conversation, chat bubbles, relationship graph, decision tree.

**Generalized reusable asset:** Split set of reusable component panels.

**Prompt:**
```text
Create a premium futuristic component board for a Doubland simulation trailer, showing four separate modular UI scenes on a black background: 
1) two people in a live digital conversation interface,
2) a clean chat-bubble communication overlay,
3) a relationship graph with character nodes and labeled edges such as alliance, trust, rivalry, or influence,
4) a decision tree showing one decision branching into two choices and multiple outcomes.
Use a consistent cyan-blue neon HUD language, thin lines, subtle grid texture, and clear negative space between the four modules. No unnecessary text beyond minimal interface labels.
```

### 17.7.3 Relationship graph as a standalone generalized asset

**Prompt:**
```text
Create a futuristic relationship graph interface for the Doubland trailer style. Show [NODE_COUNT] character nodes arranged in a clean readable network on a dark background, with glowing edges labeled by relationship types such as alliance, trust, rivalry, influence, or conflict. Highlight one important connection involving [FOCUSED_PERSONA]. Use cyan-blue neon lines, subtle node pulses, and a premium sci-fi interface feel. Keep the graph readable and uncluttered.
```

### 17.7.4 Decision tree as a standalone generalized asset

**Prompt:**
```text
Create a sleek futuristic decision-tree interface on a black background. Show a central decision node labeled “[DECISION_TOPIC]”, branching into two or three choice nodes, then into multiple outcome nodes. Use glowing cyan-blue HUD boxes, thin connection lines, and a premium sci-fi style. The composition should clearly communicate that choices lead to different outcomes. Keep it elegant, readable, and mobile-friendly.
```

## 17.8 Season, mode, and pressure assets

### 17.8.1 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards2.png` → generalized Survival dashboard

**Current role:** Full-season dashboard with players, alliances, conflicts, events, active Doubles, live feed, and day progress.

**Generalized reusable asset:** Any mode dashboard, not just the Pistsov-family version.

**Prompt:**
```text
Create a premium futuristic simulation dashboard for the mode “[MODE_NAME]” in the Doubland style. Use a dark blue-black interface with cyan-blue HUD borders and a small amount of warning-color accent where appropriate. Include: an overview panel with live counts, a main world-status section, an active Doubles section showing selected cast members, an alliances panel, a conflicts panel, a live activity feed, and a day-progress or time-progress strip. The cast should be [HIGHLIGHTED_PERSONAS]. The interface should feel like a powerful live-simulation control screen, readable on mobile, highly polished, and information-dense but organized.
```

### 17.8.2 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Survival.png` → generalized mode-banner / season-title set

**Current role:** Survival mode initiation banner and season-title plate.

**Generalized reusable asset:** Reusable banner system for any simulation mode and season title.

**Prompt for the mode banner:**
```text
Create a dramatic futuristic mode-activation banner on a black background for the mode “[MODE_NAME]”. Show a bold uppercase title such as “[MODE_NAME] MODE INITIATED” with a strong warning or activation icon, a sleek HUD-style frame, and a premium neon interface design. Use cyan-blue for standard mode changes or orange-red when the mode is dangerous, urgent, or high-pressure. Strong central alignment, elegant sci-fi styling, no clutter.
```

**Prompt for the season-title plate:**
```text
Create a premium futuristic title plate on a black background featuring the text “[SEASON_TITLE]” and a smaller subtitle such as “[SEASON_NUMBER]”. Use clean uppercase typography, thin cyan-blue HUD framing, subtle glow, and an elegant sci-fi title-card feel. Minimal, centered, readable, and suitable for compositing into a trailer.
```

### 17.8.3 `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Pressure.mp4` → generalized pressure / escalation motion clip

**Current role:** Pressure peak clip.

**Generalized reusable asset:** Short escalation motion clip for any tense moment.

**Prompt:**
```text
Create a 3 to 5 second futuristic pressure-escalation motion clip in the Doubland style. Show a large glowing circular gauge, radar, or pressure indicator on a dark background, starting calm and sweeping toward higher intensity. The visual should feel urgent and cinematic, with cyan-blue UI transitioning into orange-red or brighter intensity near the critical zone. Add subtle background world or village texture if helpful, but keep the gauge as the hero element. High-end sci-fi interface motion, clear rise in tension, no text unless minimal UI labels are needed.
```

## 17.9 Personality-analysis assets

### 17.9.1 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards3.png` → generalized trait-card set

**Current role:** Personality trait cards for current cast.

**Generalized reusable asset:** Reusable trait-card component system.

**Prompt:**
```text
Create a set of premium futuristic personality trait cards for a Doubland trailer. Show [CARD_COUNT] vertical cards on a dark background, one per selected character. Each card should include the character name, two to three concise personality traits, small trait icons, and a refined cyan-blue neon interface frame. The design should feel sleek, minimal, and premium, with readable typography and subtle glow. If a trait implies tension or risk, a small orange accent may be used. Keep the cards clean and modular.
```

### 17.9.2 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards4.png` → generalized personality-analysis panel and Double initializer

**Current role:** Personality analysis plus “Create Your Double” radial diagram.

**Generalized reusable asset:** Reusable analysis and creation system visuals.

**Prompt for the personality-analysis panel:**
```text
Create a premium futuristic personality-analysis panel for Doubland on a dark background. Include a simple luminous head or profile silhouette, several scored traits such as [TRAIT_1], [TRAIT_2], [TRAIT_3], [TRAIT_4], and a clean progress area showing “AI DOUBLE GENERATION” nearing completion. Use cyan-blue neon HUD styling, uppercase typography, thin interface lines, and high readability.
```

**Prompt for the Double initializer radial:**
```text
Create a futuristic radial interface for “CREATE YOUR DOUBLE” on a black background. Place the phrase “CREATE YOUR DOUBLE” in the center, surrounded by connected category nodes such as Personality, Voice, Decisions, Behavior Model, Relationships, and Memories. Use luminous cyan-blue circular UI rings, thin connector lines, soft interface glow, and a premium sci-fi look. The design should feel like a system actively assembling a digital personality.
```

## 17.10 Concept-layout assets

### 17.10.1 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards1.png` → generalized concept-sequence board

**Current role:** Group-to-scan-to-individual-Doubles reveal and behavior examples.

**Generalized reusable asset:** A reusable storyboard or rendered concept sequence for any new cohort.

**Prompt:**
```text
Create a clean concept-sequence board for a Doubland trailer. On a dark futuristic background, show a visual progression from left to right: 
1) a clean group portrait of the cohort “[COHORT_NAME]”,
2) the same group with digital scanning or face-detection overlays,
3) a row of individual AI Double identity cards for selected cast members,
4) a second row showing behavior examples such as talking like you, reacting like you, making choices like you, and living like you.
Use premium cyan-blue HUD styling, elegant spacing, and strong visual consistency. The board should work as a planning or design reference and may later be split into separate production assets.
```

### 17.10.2 `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards5.png` → generalized cast-asset board

**Current role:** White-background board showing group photo, scanned version, and individual cards.

**Generalized reusable asset:** Internal asset board for QC and workflow, not necessarily a trailer shot.

**Prompt:**
```text
Create a clean internal asset board showing the core visual package for the cohort “[COHORT_NAME]”. Include: a clean group portrait, a scanned-interface group version, and four individual AI Double identity cards. Use a simple neutral or white presentation-board background so the assets can be reviewed side by side by the production team. Keep the visuals premium and consistent with Doubland branding, but treat this as a design-board or QA board rather than a final trailer frame.
```

## 17.11 Asset-generation workflow recommendation

For each new simulation, generate assets in this order:

1. **Core people assets**
   - clean cohort group photo
   - transparent cohort cutout
   - one clean portrait/cutout per persona
   - one identity card per featured persona

2. **World assets**
   - world establishing aerial still or clip
   - world map HUD still or component base
   - location markers / world overlays

3. **Narrative UI assets**
   - conversation hero still/clip if a bespoke one is desired
   - relationship graph
   - decision tree
   - relationship-update toast

4. **Season/mode assets**
   - mode banner
   - season title plate
   - dashboard
   - pressure/escalation clip

5. **Brand assets**
   - DOUBLE card
   - DOUBLAND logo plate
   - URL end card
   - replay control

6. **Internal workflow boards**
   - concept-sequence board
   - cast-asset board

## 17.12 Naming convention for generalized generated assets

Recommended naming pattern:

```text
<simulation_slug>/
  cohort_group_clean.png
  cohort_group_cutout.png
  cohort_group_motion.mp4
  persona_<id>_portrait.png
  persona_<id>_cutout.png
  persona_<id>_identity_card.png
  world_establishing.mp4
  world_map_hud.png
  relationship_graph.png
  relationship_update_positive.png
  relationship_update_negative.png
  decision_tree.png
  mode_<mode_slug>_banner.png
  season_title.png
  pressure_peak.mp4
  double_wordmark.png
  doubland_active_logo.png
  doubland_url.png
  replay_control.png
  concept_board.png
  qa_asset_board.png
```

## 17.13 Final generalization principle

The current Pistsov-family assets should be treated as **visual prototypes**. The reusable system should preserve:

- the **composition logic**,
- the **HUD frame language**,
- the **color semantics**,
- the **motion behavior**,
- and the **editorial role** of each asset,

while replacing the cast, world, names, metrics, and relationships with simulation-specific content.

When in doubt, generate a new asset that matches the **function** of the current asset rather than trying to force the existing Pistsov-family asset into a new simulation.

---

# Part II — Asset punch list and commission tracker

> Original asset-commission punch list. Active opener engineering: [implementation plan](20260617_vertical-trailer-automation.md).
## Asset taxonomy

Every commissioned asset belongs to one bucket. The bucket determines when you produce it and when you can reuse it.

| Bucket | Replicate when | Items |
|---|---|---|
| **Per-village** | new village | M (style frame) · N (exteriors) · O (interiors) |
| **Per-cohort** | new cast | P (character sheets) · A (sprite walkouts) · Q (hero pairings) |
| **Per-cohort/season** | new season | C (anthem) |
| **Per-archetype** | once forever | D (stings) · E (card frames) |
| **Per-trailer / auto** | every render | B · F · G · H · I · J |

**Cross-cutting rules (apply to every commissioned asset):**

- **Lock aspect ratios first.** 1280×720 (16:9 master) + 1080×1920 (9:16 vertical). Generate references in both where they'll be cropped differently.
- **Batch within a bucket.** All exteriors in one Midjourney session with locked seeds; same for interiors; same for character sheets. Cross-session generations drift.
- **Reference saturation cap.** Feed any derivative the 2–3 strongest baseline refs — not all of them. More refs ≠ better.
- **Always cite §TODO-M.** Every other asset commission uses the style frame as primary look reference.

**Filesystem layout** (under `D:\Coding\generative_agents\`):

```
video/
├── assets/
│   ├── phaser/                          # Phaser auto-captures
│   │   ├── establish_*.png              # 6 establishing shots
│   │   ├── home_topdown_*.png           # per-persona home top-downs
│   │   └── sprite_walkout_*.webm        # native Phaser fallback (auto)
│   ├── users/                           # per-double assets
│   │   ├── headshots/                   # original photos (input to sketch gen)
│   │   ├── sketches/                    # generated sketches (front-neutral, .png or .jpg)
│   │   ├── character-sheets/{agent_id}/ # §TODO-P (8–10 views per double)
│   │   └── sprite-walkouts/             # §TODO-A polished MP4s
│   ├── scripts-prompts/                 # asset-generation tooling (universal + cohort)
│   ├── village/                         # per-village (currently: the_ville)
│   │   ├── _moodboard/                  # context crops + inspiration refs
│   │   ├── exterior/                    # §TODO-N ✓ DONE 2026-05-07
│   │   │   ├── _style_frame_master.png              # §TODO-M canonical style ref
│   │   │   ├── village_overhead_wide.png            # establisher / overhead layout
│   │   │   ├── hobbs_cafe_exterior_wide.png
│   │   │   ├── dorm_exterior_wide.png
│   │   │   ├── library_exterior_wide.png
│   │   │   └── _layout-reference_open-roofs.png    # alt: see-through-roof layout ref
│   │   └── interior/                    # §TODO-O ✓ DONE 2026-05-08 (9 files)
│   ├── cohort/                          # per-cohort
│   │   ├── hero/                        # §TODO-Q ✓ DONE 2026-05-09 (Pistsov: 4 stills in pistsov_family/)
│   │   └── how_to_watch_card_*.png      # §TODO-J
│   └── archetypes/                      # per-archetype (reusable forever)
│       ├── card_frame_{type}.png        # §TODO-E (champion / wildcard / observer)
│       └── sting_{archetype}.wav        # §TODO-D (4 archetypes)
├── audio/
│   ├── music_anthem.mp3                 # §TODO-C ✓ DONE 2026-05-11 (used by opener mode)
│   ├── music_drama.mp3                  # day-overview drama mood (one of 3 daily-recap variants)
│   ├── music_intrigue.mp3               # day-overview intrigue mood
│   ├── music_wholesome.mp3              # day-overview wholesome mood
│   ├── normalize.sh                     # two-pass loudnorm: --target sting (-12 LUFS) | --target music (-16 LUFS)
│   └── sfx/                             # general sound effects
└── fly-over/
    ├── cinematic_flyover_*.mp4          # §TODO-I (5 shipped 2026-05-04)
    ├── cinematic_village_aerial_tudor.mp4    # Phase 9 cinematic plate (2026-05-13); aerial Tudor village, on-brand storybook aesthetic, full cinematic — primary Phase 9 fusion-beat second half
    ├── cinematic_village_courtyard_dusk.mp4  # Phase 7 commission byproduct (2026-05-13); ground-level Tudor courtyard, dusk — stakes-montage atmospheric / end-card motion variant
    └── signature_flyover.mp4            # Phase 9 schematic plate (2026-05-13); pixel-art top-down village with animated sprites — Phase 9 fusion-beat first half / cold-open background / stakes-montage atmospheric
```

---

## Status snapshot

| TODO | Bucket | State | Note |
|---|---|---|---|
| §TODO-M Style frame | Per-village | **DONE 2026-05-08** | `_style_frame_master.png` is the canonical look reference; cite as primary style ref for all downstream commissions |
| §TODO-N Exteriors | Per-village | **DONE 2026-05-07** | 4 eye-level approach shots + 1 layout ref: village / cafe / dorm / library |
| §TODO-O Interiors | Per-village | **DONE 2026-05-08** | 9 Phaser-grounded interiors: cafe ×2, dorm common ×1 (+ vertical) + 4 numbered bedrooms, college library ×2. Cottages/pub/park/shops skipped — Pistsov family doesn't visit them. |
| §TODO-P Character sheets | Per-cohort | **DONE 2026-05-08** | 19 personas × 5 views = 95 PNGs in `users/character-sheets/{uuid}/`; automated via `scripts-prompts/generate_character_sheets.py` |
| §TODO-A Sprite walkouts | Per-cohort | **DONE 2026-05-08** | 19/19 MP4s in `users/sprite-walkouts/{uuid}.mp4` — Pistsov family ×4 + soul15 cohort ×15. Automated via `scripts-prompts/generate_sprite_walkouts.py` (xAI `grok-imagine-video`, async). |
| §TODO-Q Hero pairings | Per-cohort | **DONE 2026-05-09** | 4 stills in `cohort/hero/pistsov_family/` (Ivan kitchen late-morning, Luba cafe morning, Katya library afternoon, Gosha bedroom night). Automated via `scripts-prompts/generate_hero_pairings.py` (xAI multi-image-edit, up to 3 input images per call: room + persona front_neutral + style frame). Driven by external scene-config JSON (`hero_scenes_pistsov_family.json`) for cohort reuse. |
| §TODO-C Anthem track | Per-cohort/season | **DONE 2026-05-11** | 163.7s anthem at `video/audio/music_anthem.mp3`, normalized −16 LUFS / −5.4 dBTP via `normalize.sh --target music`. Opener script generator (`showrunner.py:1122`) now sets `mood="anthem"` so `_resolve_music()` picks the new file; daily-recap mood pool (drama/intrigue/wholesome) untouched. Stings ear-checked at 15s intervals: accepted as-is. |
| §TODO-D Archetype stings | Per-archetype | **DONE 2026-05-11** | 4 stings shipped at `archetypes/sting_{champion,wildcard,observer,connector}.wav`, normalized to −12 LUFS / −1 dBTP via new `video/audio/normalize.sh`. Compose path already wired (`_build_sting_overlays()` + `mix_audio(sting_overlays=...)`); files auto-overlay at name-card moment. Originals preserved in `archetypes/_raw/`. |
| §TODO-E Card frames | Per-archetype | **PARTIAL** | FFmpeg-drawn placeholders in use; commissioned PNGs slot in. Design brief drafted 2026-05-14: `20260514_trading-card-frames-brief.md` (3 frames, reusable across casts of 4–15 doubles). |
| §TODO-R Voice ref | Per-cohort | **DEFERRED** | No per-double VO in v1 |
| §TODO-B Bios | Auto | DONE | Tier-B LLM |
| §TODO-F Home / establishing shots | Auto | **REOPENED 2026-05-11** | `capture_static_assets.py` outputs (`establish_*.png`, `home_topdown_*.png`, `sprite_walkout_*.webm`) are stale and unfit — see Feedback & Corrections obs. #10 + suggestion #10. Being replaced by the two-tier capture system (cohort-agnostic bake + per-sim-day Tier B captures driven by showrunner LLM `atmospheric_key_steps`). |
| §TODO-G Archetypes | Auto | DONE | Tier-B LLM |
| §TODO-H Cold open | Auto | DONE | Templated + ElevenLabs |
| §TODO-I Flyovers + narration | Auto | DONE 2026-05-04 | 5 Grok flyovers + LLM narration. *Augmented 2026-05-13:* +3 Phase-7-commissioned assets — `signature_flyover.mp4` (pixel-art top-down with sprites), `cinematic_village_aerial_tudor.mp4` (aerial Tudor village, locked aesthetic), `cinematic_village_courtyard_dusk.mp4` (ground-level Tudor courtyard). The first two are Phase 9 fusion-beat plates; the third is a stakes-montage atmospheric. |
| §TODO-J End card | Auto | DONE | v2 spec: 5 lines, ~8s |
| §TODO-K Sketch normalization | Decided | DECIDED | Leave as-is for v0 |
| §TODO-L Cohort + season title | Decided | DECIDED | Pistsov family / Who will stay alive |

---

## Per-village specs

### §TODO-M. Style frame — DONE 2026-05-08

**Status:** `video/assets/village/exterior/_style_frame_master.png` is the canonical look reference for the_ville. Eye-level 3/4 view of the village square — half-timbered Tudor cottages with honey-amber timber, cream stone foundations, clay-tile roofs, golden-hour key light, warm interior glow, lanterns and string lights as cosy practicals. Every future per-village or per-cohort commission must cite it as primary style reference.

`village_overhead_wide.png` reverts to its proper role as a pure establisher / overhead layout reference — no longer the style anchor.

**For new villages:** commission the style frame *before* the exteriors, eye-level (not overhead), at the time-of-day and material palette you want every downstream asset to inherit. The establisher and the style frame are two different deliverables; don't conflate them again.

### §TODO-N. Exterior environment library — DONE 2026-05-07

**Status:** Five files commissioned for the_ville. Stored in `video/assets/village/exterior/`.

**Files:**

| File | Description |
|---|---|
| `village_overhead_wide.png` | Pure top-down aerial of the whole village, golden hour. Anchor / establisher / de facto style frame. |
| `hobbs_cafe_exterior_wide.png` | Eye-level approach POV (3/4 angle) of Hobbs Cafe with patio path. |
| `dorm_exterior_wide.png` | Eye-level approach POV of the communal dorm (entrance side; opposite face from what's visible in the village aerial). |
| `library_exterior_wide.png` | Eye-level approach POV of "Oak Hill Library" (two-wing stone-and-tile civic building). |
| `_layout-reference_open-roofs.png` | Alt take of the village overhead with see-through roofs; useful as a layout reference for commissioning interiors. |

**Approach used:**
- **Pure top-down** for the village establisher (matches the Phaser visual convention).
- **Eye-level approach POV** (3/4 angle, 35mm lens, ~1.6m camera height) for individual buildings — more cinematic and character-friendly for derivative scenes.
- **Two references per shot:** a context crop of `village_overhead_wide.png` (style anchor — saved per-building under `_moodboard/`) + the corresponding Phaser top-down ref from `video/assets/phaser/` (layout).
- **Golden hour** for all (decided 2026-05-07 to simplify; no dawn/dusk variants).

**Skipped vs original punchlist (intentionally):**
- Detail close-ups (door / window / corner shots) — not commissioned. Will revisit if hero pairings need them.
- Park exterior, village square, homes row — skipped. The four buildings above plus the village establisher cover what the trailer actually exercises.

**Reusability:** all five files are reusable for any new cast in the_ville. New villages need their own equivalent set.

**Prompt templates:** `video/assets/scripts-prompts/!prompts.md` (versioned in-repo) — use these as a starting point for new villages or re-runs.

### §TODO-O. Interior environment library — IN PROGRESS (16/57 covered as of 2026-05-09)

**Status:** Phaser-grounded interior shots commissioned for the_ville. Stored in `video/assets/village/interior/`. Coverage tracked in `_room_inventory.md`'s top-of-file dashboard (currently 16 DONE / 41 TODO / 6 N/A).

**Files (in generation order):**

| File | Subject | Arenas covered |
|---|---|---|
| `cafe_int_dining.png` | Hobbs Cafe dining hall — tables with red/yellow chairs, communal table, grand piano, kitchen pass to back | Hobbs Cafe / cafe |
| `cafe_int_counter.png` | Hobbs Cafe service counter — coffee grinder, cake stand, kitchen visible behind | Hobbs Cafe / cafe |
| `dorm_int_common.png` | Dorm common room + integrated kitchen — wood-burning stove, communal dining table | Dorm common room **+** dorm kitchen |
| `dorm_int_common_vertical.png` | 9:16 vertical companion to dorm common (for vertical trailer cuts) | Dorm common room |
| `dorm_int_bedroom_1.png` | Dorm Room 1 — Gosha (robotics workshop: mechanical device, file cabinets, post-note board, desk) | Dorm Room 1 |
| `dorm_int_bedroom_2.png` | Dorm Room 2 — Katya (whiteboard sketching: computer, whiteboard, gym bench, desk) | Dorm Room 2 |
| `dorm_int_bedroom_3.png` | Dorm Room 3 — Luba (paralegal home office: bookcase, desk, clothing rack) | Dorm Room 3 |
| `dorm_int_bedroom_4.png` | Dorm Room 4 — Ivan (gym + AI desk: multi-gym station, step mill, desk) | Dorm Room 4 |
| `library_int_reading.png` | Oak Hill College library reading room — small reading tables in rows, hanging lamps, bookshelf back wall | Oak Hill College / library |
| `library_int_stacks.png` | Oak Hill College study room — central study table, librarian's desk, chalkboard, bookshelves | Oak Hill College / library |
| `artist_int_common.png` | Artists' Co-Living combined common room + kitchen | Artists' Co-Living common room **+** kitchen |
| `house4_int_common.png` | House 4 combined common room + kitchen | House 4 common room **+** kitchen |
| `house5_int_common.png` | House 5 combined common room + kitchen | House 5 common room **+** kitchen |
| `house6_int_common.png` | House 6 combined common room + kitchen | House 6 common room **+** kitchen |

**Convention — combined common-room + kitchen shots.** When a sector's common room and kitchen are visually adjacent (small dwellings where the kitchen is in the corner of the common room), one image is commissioned with the `*_int_common.png` filename and `EXISTING_INTERIORS` maps both arenas to it. Originally a dorm-only pattern; now extended to artist co-living and houses 4–6.

**Approach used:**
- **Maze-grounded layouts.** Every interior's furniture inventory and positions came from the maze CSVs, not from eyeballed Phaser screenshots. Per-room inventory at `video/assets/village/interior/_room_inventory.md` (auto-generated by `video/assets/scripts-prompts/generate_room_inventory.py` from `arena_maze.csv` + `game_object_maze.csv`) — drop the relevant block straight into the LAYOUT line of the prompt. Phaser is now only consulted for windows/doors and visual signature (those aren't tagged in the maze).
- **Locked conventions across each batch:** time of day (late afternoon golden), wood/stone palette, beam style, plank floor, no people. Light direction locked per batch (cafe/library = camera right; dorm = camera left).
- **Reference stack:** `_style_frame_master.png` (weight 2) primary look + `hobbsCafe_outside_1.jpg` or earlier interior (weight 1) for cosy continuity.
- **Persona-room mapping** was reconciled after rendering: scratch.json + Supabase `persona_scratch.living_area` updated so each Pistsov sleeps in the room whose visual signature matches their profile (Gosha=robotics, Katya=sketching, Luba=paralegal, Ivan=gym/AI).

**Skipped intentionally for v1 trailer (Pistsov cohort):**
- Pistsov daily plans only touch dorm + cafe + library, so the v1 Pistsov trailer doesn't strictly require any other interiors. The post-v1 commissions (artist co-living + houses 4–6 combined kitchen/common rooms, plus the in-progress bathrooms / studio rooms / pub / supply store / market / classroom) are being commissioned now as a per-village baseline so future cohorts can be cast into any building without blocking on more interior generation. See `_room_inventory.md` for live coverage.

**For new villages or new cohorts:**
- **Step 1 — regenerate the room inventory.** Run `python video/assets/scripts-prompts/generate_room_inventory.py`. It reads the new village's maze CSVs and rewrites `_room_inventory.md` with every room's furniture, tile counts, positional descriptors (NW corner, against left wall, etc.) and a Status line per room (DONE / TODO / N/A). The file opens with a coverage dashboard + sector-grouped TODO list.
- **Step 2 — generate ready-to-paste prompts for the TODO rooms.** Run `python video/assets/scripts-prompts/generate_interior_prompts.py`. It emits `_interior_prompts_TODO.md` — one Grok Imagine prompt per TODO arena, grouped by archetype (bathrooms / kitchens / common rooms / studio living / bedrooms / pub / supply store / market+pharmacy / classroom) so each batch runs in a single Grok session with a locked STYLE block. Bedrooms are persona-neutral by default (literal furniture from the maze, no profession/character flavor) so the same village can host different casts without re-commissioning.
- **Step 3 — run the prompts.** Paste each block into Grok Imagine UI, save the file under the suggested name, then update `EXISTING_INTERIORS` in `generate_room_inventory.py` and re-run both scripts — the room flips to DONE and drops out of the TODO prompts file.
- **Tweaks happen in Grok UI, not in the script.** Window/door positions, persona-keyed bedroom flavor, and any room that needs special attention are easier to handle by editing the prompt manually in Grok Imagine UI than by re-templating. The script gets you to a 90% prompt; the UI does the last 10%.
- **New cohort in the_ville** (different cast) → if you want persona-keyed bedrooms (like the original Pistsov dorm rooms), hand-write those four prompts using the existing dorm bedroom prompts in `!prompts.md` as the template. Everything else stays.

**Reusability:** the persona-neutral commissions (cafe, library, dorm common+kitchen, artist+house combined kitchen/common rooms, all bathrooms, all bedrooms once filled in) are reusable for any new cohort. The original 4 dorm bedrooms (Pistsov-keyed) are persona-flavoured and would need re-commission if a future dorm cohort wants different visual signatures; new persona-neutral cohorts can also use them as-is.

**Prompt templates:** `video/assets/scripts-prompts/!prompts.md` (versioned in-repo).

---

## Per-cohort specs

### §TODO-P. Character sheets — per double — DONE 2026-05-08

**Status:** 19 personas × 5 views = 95 PNGs commissioned for the_ville (all sketches in `video/assets/users/sketches/`). Stored as `video/assets/users/character-sheets/{uuid}/{view}.png`.

**Five views per persona:**
- `front_neutral.png` — copy of the source sketch (zero drift)
- `front_smile.png` — warm closed-mouth smile, same framing
- `three_quarter_neutral.png` — body rotated 30° to camera-left, head facing camera
- `profile_neutral.png` — full side profile facing camera-right
- `full_body_standing.png` — pulled-back framing, full body, persona-specific bottoms

**Tooling:** `video/assets/scripts-prompts/generate_character_sheets.py` automates 4 of the 5 views via the xAI Imagine image-edit API (`/v1/images/edits`, model `grok-imagine-image-quality`) using the source sketch as image input + a transformation prompt that instructs the model to **preserve everything from the sketch and only change one specified attribute** (expression / body angle / framing). `front_neutral` is a free file copy. Run the script with `--skip-existing` to fill in any new persona's character sheet on demand.

**Prompt strategy** (the lesson learned): generic "describe the persona from scratch" prompts cause identity drift. The working pattern is image-to-image with explicit preservation language ("same face, same hair, same eye color, same skin tone, same age, same line weight, same colored-pencil shading style") + a single transformation directive. This is captured verbatim in `scripts-prompts/!prompts.md` and in the script's `VIEW_PROMPTS` dict.

**For new cohorts:** add new sketches to `users/sketches/{uuid}.png`, then run the script — no per-persona editing needed except optional `PERSONA_OUTFITS` overrides for full-body bottoms (default falls back to model's choice based on the sketch).

**Acceptance:** all 5 views for one persona side-by-side read as the same person. Validation by eye, re-roll any drift via `--persona <UUID> --view <view>` (omits `--skip-existing` so the bad take is overwritten).

### §TODO-A. Sprite walkouts — N × ~2.5s polished video — **DONE 2026-05-08**

**Deliverable:** `video/assets/users/sprite-walkouts/{agent_id}.mp4` per persona. 1280×720 H.264, 30fps, ~2.5s. Transparent or matching dark background. (Native Phaser fallback `.webm` lives in `video/assets/phaser/sprite_walkout_{agent_id}.webm`.)

**Inputs per persona:** front-neutral sketch + auto-captured top-down home shot (from §TODO-F).

**Tool:** Grok Imagine image-to-video API (`grok-imagine-video` model, `/v1/videos/generations` endpoint, async with polling per `/v1/videos/{request_id}`). Automated via `video/assets/scripts-prompts/generate_sprite_walkouts.py` — uses each persona's `full_body_standing.png` character sheet as the starting frame, animates a subtle action + ambient motion. Per-persona action/mood overrides live in the script's `PERSONA_CONFIG` dict (action verbs derived per-persona from the `souls/*.md` snapshots); UUIDs without an entry fall back to a generic confident-smile default. **Status: DONE 2026-05-08 — 19/19 MP4s shipped** (4 Pistsov family + 15 soul15 cohort).

**For new cohorts:** add a `name → UUID` lookup from `double.personas`, drop sketches into `users/sketches/{uuid}.png`, run `generate_character_sheets.py` (full-body view is the input to walkouts), add a `PERSONA_CONFIG` entry per UUID with action+mood pulled from the persona's profile, then run `generate_sprite_walkouts.py --skip-existing`.

**Prompt template:**

```
A friendly hand-drawn cartoon character in colored-pencil / hand-sketched
art style steps into the frame from the [LEFT|RIGHT|BACK], walks two or
three casual steps forward toward the camera, turns slightly to face the
viewer, gives a subtle [SMILE|WAVE|NOD], holds for the final beat.

Character must match the attached sketch reference exactly: same line
weight, same color palette, same shading, same hairstyle, same outfit.

Setting: [DESCRIBE THE ROOM FROM THE TOP-DOWN SCREENSHOT — ~20 words].
Background slightly out of focus. Camera locked / no pan.

Mood: [WARM | CONFIDENT | INTRIGUING | PLAYFUL — match psychological
archetype, see §TODO-G].

Duration: 2.5 seconds. Output: 1280×720, 30fps. Character fully on-frame
by 1.0s; hold final pose 2.0–2.5s.

Style: hand-drawn animation, light cel-shading, gentle ambient motion in
hair / clothing, no harsh perspective shifts.
```

**Per-persona placeholders:** alternate direction of entry per persona for visual variety; pick action from {SMILE, WAVE, NOD, TILT_HEAD, GLANCE_OVER_SHOULDER}; mood matches archetype.

**Acceptance:** character fully on-screen by 1.0s; final 0.5s holds steady (so the name-card overlay lands cleanly); no abrupt cuts inside.

**Drop-in:** composer prefers `.mp4` over `.webm` automatically. Native Phaser WebM keeps shipping until MP4s land.

### §TODO-Q. Hero pairings — 4–6 hero scene stills — **DONE 2026-05-09 (Pistsov)**

**Pistsov inventory:** 4 stills in `video/assets/cohort/hero/pistsov_family/`:
- `ivan_kitchen_late_morning.png` — dorm common kitchen, post-run, laptop on table (founder-athlete signature)
- `luba_cafe_morning.png` — Hobbs Cafe interior, behind the counter, owner-operator host energy
- `katya_library_afternoon.png` — Oak Hill Library, blue armchair, sketchbook on lap (creative absorbed)
- `gosha_bedroom_night.png` — Dorm Room 1 corner desk, lamp-lit, mechanical gears (quiet thinker)

**Tooling:** `video/assets/scripts-prompts/generate_hero_pairings.py`. Reads cohort scene-config JSON (e.g. `hero_scenes_pistsov_family.json`); for each scene calls xAI `grok-imagine-image-quality` `/v1/images/edits` with up to 3 input images: room interior + persona `front_neutral.png` + optional `_style_frame_master.png`. Idempotent via `--skip-existing`; per-scene retry via `--scene <id>`; `--dry-run` for prompt inspection.

**Workflow lessons (carry into next cohort):**
1. Pose must physically fit the locked source room — don't ask for "between stacks" if the room has a reading-table layout.
2. Interior anchoring needs to enumerate visible features and explicitly negate exteriors ("INSIDE the cafe; no sky, no exterior buildings").
3. For asymmetric rooms, anchor the camera position ("from the doorway perspective; bed in left foreground; desk in back-right corner") rather than describing what's in frame.
4. Multi-image input locks composition reasonably but leaves style fluid; color-grade in post if needed.
5. Plan one round of prompt iteration after the first calibration shot; budget ~2× ideal-case API cost.

**Deliverable:** `video/assets/cohort/hero/{scene_name}.png` × 4–6.

For the 4–6 scenes you know will appear in the final trailer (e.g. "Maria in cafe at dusk", "Ivan at council fire", "Luba in apartment morning light"), generate a single still that locks scale, lighting on face, framing, and pose. Becomes the reference input when the video version is generated downstream.

**Inputs per pairing:** §TODO-M style frame + relevant §TODO-N or §TODO-O environment shot + §TODO-P character-sheet front view of the relevant double.

**Acceptance:** held next to either component baseline (the empty cafe; the character front view), the pairing reads as recognizably both — same character, same room.

---

## Per-cohort/season specs

### §TODO-C. Anthem track — ~165s, 6 stings — **DONE 2026-05-11**

**Status:** 163.7s anthem at `video/audio/music_anthem.mp3`, normalized −16 LUFS / −5.4 dBTP via `video/audio/normalize.sh --target music`. Opener script generator (`showrunner.py:1122`) sets `mood="anthem"` so `_resolve_music()` picks the new file. Daily-recap mood pool (drama/intrigue/wholesome) intentionally untouched — `VALID_MOODS` not extended.

**Lessons (carry forward to future cohort anthems):**
1. Suno tends to overshoot the requested length — generated ~188s for a 165s request. Trim externally before normalizing.
2. The 6 stings at 15s intervals (0:30, 0:45, 1:00, 1:15, 1:30, 1:45) are hard for Suno to honor on-beat — ear-check before accepting; regenerate if they drift.
3. Apply `normalize.sh` after the trim (not before) so the final loudness target hits the trimmed asset, not the un-trimmed source.
4. Convert WAV → MP3 192 kbps as the LAST step — keep the lossless WAV in `audio/_raw/` for future re-encoding without quality loss.

**Deliverable (spec):** `video/audio/music_anthem.mp3`. ~165s, normalized −16 LUFS, MP3 192 kbps, 1.5s fade-out.

**Tool:** Suno v4 or Udio.

**Prompt:**

```
[Genre] Cinematic anthemic orchestral hybrid — reality TV grand premiere
[Tempo] 110 BPM | [Length] 165s | [Vocals] NONE
[Mood] Big, hopeful, slightly tense; reverent but kinetic
[Reference] Survivor S43; Big Brother UK 2023; "Heroes" cinematic cover
[Instrumentation] Cinematic strings, light electronic percussion, brass
                  swells for hooks, sub-bass, sparse piano

Structure:
  0:00–0:08  Cold open — sparse strings + low piano under VO
  0:08–0:16  Hook plant — drums kick in subtly under VO tail
  0:16–0:30  Stakes drop — full orchestra + percussion
  0:30–2:15  Cast intros — rhythmic motif, persistent driving beat,
             with 6 musical stings at 15s intervals (0:30, 0:45, 1:00,
             1:15, 1:30, 1:45) — each a 0.5s harmonic accent
  2:15–2:35  Build — tension rises, drums intensify
  2:35–2:50  Stakes montage — full ensemble, anthemic chorus
  2:50–2:55  Final hit + 5s tail to silence
```

**Acceptance:** generate 2–3; pick the one whose 6 stings hit cleanly at 15s intervals. Normalize via existing `video/audio/normalize.sh` to match other tracks.

**Drop-in:** drop into `video/audio/`; flip script's `mood` field to `"anthem"` (or rename file to `music_drama.mp3` for zero-config swap).

---

## Per-archetype specs (commission once forever, reusable across cohorts)

### §TODO-D. Archetype intro stings — 4 × 1.5–2.5s — **DONE 2026-05-11**

**Status:** 4 stings shipped at `video/assets/archetypes/sting_{champion,wildcard,observer,connector}.wav`. All normalized to −12 LUFS integrated / −1 dBTP peak via `video/audio/normalize.sh --target sting`. Originals backed up at `archetypes/_raw/`.

**Final specs:**

| Archetype | Duration | Peak | Mean | Source |
|---|---|---|---|---|
| Champion | 1.90s | −2.3 dBTP | −14.3 dB | Suno |
| Connector | 1.96s | −2.1 dBTP | −14.3 dB | Suno (2nd take after flat first attempt) |
| Observer | 2.71s | −1.0 dBTP | −16.7 dB | Suno (widest dynamic range — preserved on purpose) |
| Wildcard | 0.97s | −2.1 dBTP | −15.2 dB | Suno (under-spec on length but reads punchy/syncopated) |

**Lessons (carry forward):**
1. Suno is built for songs, not stingers — when generating, ask for a 6s logo/ident with explicit structure (bloom → hit → decay) rather than a long track to trim later. The "find a 2s moment in a 40s song" approach failed for Connector on the first try.
2. Pre-made libraries (Pixabay Music, Freesound, BBC Sound Effects Archive) are often faster than generative tools for short stingers — search "sting", "logo", "ident", "trailer hit".
3. Normalize last, not per-take — apply `normalize.sh --target sting` (−12 LUFS / −1 dBTP) after the full set is picked to keep relative loudness consistent.
4. Observer can stay long-tailed (2.7s) without breaking the mix because the FE compose path overlays at name-card-land; the tail decays under the next card's anthem bed.

**Deliverable:** `video/assets/archetypes/sting_{archetype}.wav` × 4. Normalized −12 LUFS peak (sits 4 dB above the ducked anthem).

Each persona maps to ONE archetype (auto-assigned by §TODO-G); matching sting plays at name-card-land.

- **Champion** (alliance leader). Cinematic sports / triumphant — brass hit + tom drum thud + cymbal crash tail. Mood: bold, decisive, victorious. Reference: NBA finals stinger, NFL opening hit. Output: 1.5–2.0s, sharp attack, tail to silence.
- **Wildcard** (chaotic, playful). Electronic / playful synth — synth zap + tape rewind + vinyl scratch. Mood: mischievous, surprising, off-kilter. Reference: Stranger Things accents, glitch-pop transitions. Output: 1.5s, syncopated, playful tail.
- **Observer** (quiet strategist). Ambient cinematic — low cello sustained note + soft cymbal swell + single piano note. Mood: pensive, deliberate, suspenseful. Reference: True Detective S1 transitions, Ozark scene-break stings. Output: 2.5s, soft attack, long tail.
- **Connector** (warm, social glue). Acoustic warm / folk-cinematic — warm piano chord + acoustic guitar pluck + gentle bell. Mood: inviting, sincere, warm. Reference: This Is Us scene transitions. Output: 2.0s, soft attack, sustaining tail.

**Acceptance:** all four sit cleanly under the anthem when ducked −6 dB; attack hits within 100ms of card-land moment.

### §TODO-E. Trading-card frames — 3 PNG overlays

**Deliverable:** `video/assets/archetypes/card_frame_{type}.png` × 3 (champion / wildcard / observer). 1280×720 transparent PNG. (Connector personas use the Champion frame in v1.)

**Common layout (all frames):**
- Sketch portrait cutout: 320×400 at (80, 160)
- Name text zone: 720×60 at (440, 200)
- Role tag zone: 200×40 at (440, 280)
- Bio text zone: 720×80 at (440, 340)
- Trait moment zone: 1100×120 at (90, 540)
- Right side (560–1280, 0–160): reserved for sprite-walkout video at 2.5s

**Frame 1 — Champion** (premium tournament aesthetic):
- 8px metallic gold/bronze border (`linear-gradient(135deg, #C8A86B, #8B6E2F)`); ornate filigree corners ~40px
- Warm radial bg #2A1810 → #0A0504
- Wax-seal role tag, "ALLIANCE LEADER" in bold serif white
- Name: bold serif (Cinzel/Trajan), white, 48pt, 0.05em tracking. Bio: italic serif #E8DCC4, 24pt. Trait: 36pt + 2px black drop-shadow.

**Frame 2 — Wildcard** (scrapbook, off-kilter):
- 6px hand-drawn line border, slight ink-bleed; whole frame rotated 1.5° clockwise
- Torn-paper / masking-tape rectangles at 2 corners; off-white #F4EBD8 paper-texture bg
- Hand-drawn rectangle role tag, "WILDCARD" in marker font, slight opposite tilt
- Name: Permanent Marker / Architects Daughter, black, 48pt. Bio: hand-drawn font, 24pt dark grey. Trait: marker, 36pt navy ink.

**Frame 3 — Observer** (minimalist editorial):
- 1px solid line border, neutral cream #E5DCC9, subtle shadow; soft gradient bg #F8F4ED → #E5DCC9
- "OBSERVER" small all-caps 14pt 0.2em tracking, lower-left corner
- Name: light sans (Inter Light / Helvetica Neue Light), charcoal #2A2A2A, 48pt. Bio: same family, 22pt mid-grey #6B6B6B. Trait: same, 32pt charcoal.
- Single 1px hairline 360px under name

**Tool options:** Figma (cleanest, ~1h/frame), Midjourney (faster, less precise on text zones), or FFmpeg drawtext + shapes (already shipped as v0 placeholder).

**Acceptance:** mock all three with one persona's sketch (use Luba's sketch — already on disk); the three frames must read as distinct personalities at 240px thumbnail width.

---

## Auto-generated each render (no commission)

| TODO | What it does | Auto-input |
|---|---|---|
| §TODO-B Bios | Tier-B LLM → 5–9 word bio | `souls/{name}.md` |
| §TODO-G Archetypes | Tier-B LLM → champion / wildcard / observer / connector | soul + scratch + relationships |
| §TODO-F Home / establishing shots | Playwright + Phaser camera screenshots | sim already running |
| §TODO-H Cold open | Templated `"{N} friends. {D} days. One survives."` + ElevenLabs TTS | cohort size, season length |
| §TODO-I Stakes-montage narration | Tier-B LLM → ~75–110 words | cohort + season |
| §TODO-J End card | FFmpeg drawtext, 5-line layout, ~8s | cohort_name, season_title |

**Your review windows (~5–10 min/cohort):** reject + regen any §TODO-B bio that reads generic; override §TODO-G archetype assignments that don't match your intuition; pick from 4 alternative §TODO-H cold-open lines if you want a different tone.

**End card v2 spec (8s, 5 lines):**

```
DAY 1 STARTS NOW                                (80pt white serif)
{cohort_name} — {season_title}                  (32pt off-white)
Watch live. Scroll back. Follow every Double.   (28pt off-white)
New trailer daily at 6:30 PM.                   (24pt off-white)
www.doubland.ai                                 (28pt gold #C8A86B)
```

---

## Decided / deferred

- **§TODO-K Sketch normalization** — DECIDED 2026-05-01: leave as-is for v0. If thumbnail consistency reads as a problem, revisit with a re-render via the redrafted `video/assets/scripts-prompts/prompt-photo-sketch.md`.
- **§TODO-L Cohort + season title** — DECIDED 2026-05-01: "Pistsov family" / "Who will stay alive".
- **§TODO-R Voice / audio reference** — DEFERRED. v1 has no per-double VO. Resume only if voice lines return to scope.

---

## Recipe — new cast in same village

When you onboard a new cohort in the_ville:

1. **Skip:** §TODO-M, §TODO-N, §TODO-O (per-village; locked once)
2. **Skip:** §TODO-D, §TODO-E (per-archetype; locked forever)
3. **Re-run per new cohort:** §TODO-P (character sheets) → §TODO-A (sprite walkouts) → §TODO-Q (hero pairings)
4. **Decide on §TODO-C:** new anthem only if season title changes; same anthem can ride multiple seasons of the same cohort
5. **Run the CLI** with new cohort name + season title; auto-generates §TODO-B, F, G, H, I, J

**Effort:** ~5–15h per cast (character sheets + sprite walkouts + hero pairings).

---

## Recipe — new village (post-MVP)

When you add a new village beyond the_ville:

1. **Re-run all per-village:** §TODO-M (style frame may carry over if you want a consistent aesthetic across villages), §TODO-N (new exteriors), §TODO-O (new interiors)
2. **Re-run all per-cohort** for the new village's first cohort (per the recipe above)
3. **Skip:** §TODO-D, §TODO-E (still reusable)

**Effort:** ~10–20h per new village (style frame + ~16 exterior shots + ~12 interior shots), then per-cohort effort on top.

---

## Feedback & Corrections

Revision queue accumulated from end-to-end render reviews. Each entry: dated observations from Ivan + concrete improvement plan. Promote a suggestion to a numbered §TODO-S/T/U… when scheduled for work.

### Trailer review — 2026-05-11 — `data/20260506-5/opener&001`

First end-to-end opener render against a real sim (Pistsov family, 4 doubles, 3000-step simulation). Pipeline succeeded after two compose-stage bug fixes (cast-intro xfade fps mismatch; `-loop` flag invalid on MP4 inputs in modern FFmpeg). Both 16x9 (130s, 20 MB) and 9x16 (130s, 44 MB) MP4s rendered.

**Ivan's observations (after watching both 16x9 and 9x16):**

1. **Drop 9x16 for now.** ✓ **DONE 2026-05-11.** A proper vertical edit needs different camera framing per beat (close-ups, vertical stacking) — not just a center-crop of the horizontal master. Out of scope for MVP. Ship 16x9 only.
2. **Stings misfire against the anthem.** ✓ **DONE 2026-05-11.** The 4 archetype stings don't land cleanly on name-card moments and clash tonally with the soundtrack's existing momentum. The anthem is dynamic enough to carry the cast-intro section on its own.
3. **Trailer is missing a brand identity opening.** Every opener should start from the same iconic intro — Doubland logo, signature establishing shot, and a fixed narrative template that explains the format to first-time viewers. The narrative is the key promotion engine: it should stick in viewers' heads and create demand for the next-day trailers, the live simulation, and eventually their own simulation with friends. Draft:
   > "[N] doubles, representing real people, met at AI simulation. Their goal: survival. Each day ends with a vote — one persona leaves. Watch alliances form, drama unfold, new bonds and betrayals — all unscripted. Follow your favorites first-hand at **doubland.ai**."
4. **Sprite walkouts loop unnecessarily.** Native walkout MP4s are 2–3s; the compose path loops them with `-stream_loop -1` to fill the longer cast-intro window. Should play once, not loop — looping reads as cheap and artificial.
5. **Archetype labels clutter the cast intros.** ✓ **DONE 2026-05-11.** "CONNECTOR" / "OBSERVER" / "CHAMPION" / "WILDCARD" badges on each persona's intro card read as game-show jargon. Drop them — the personas should speak for themselves.
6. **Cast intro flow: grid → zoom → grid → next.** Replace the current individual-cast-intro sequence with a grid-anchored flow that keeps the cohort visible throughout. Each persona's spotlight is bookended by a return to the group view:
   - Open the cast section with a full-screen grid (4-up for Pistsov; dynamic for larger cohorts): each cell shows a headshot + name badge.
   - When introducing a single double, expand their cell to full-screen: show name, character description (bio + trait moment — NOT the archetype label per #5), play the sprite walkout video **once** (per #4), then hold the walkout's final frame while narration about that double continues.
   - When that persona's narration ends, transition back to the full grid view.
   - Repeat for the next persona until all are introduced.
   This supersedes the older "cast-lineup beat" idea (a single static grid shot) — the grid becomes the home base of the cast section, not a one-off introduction.

7. **Phaser flyover captures show UI artifacts.** The green schematic map flyovers used in the stakes montage include the player UI in frame — at minimum the player timeline (bottom) and the top-right cross/close button. These need to be hidden during the Playwright capture pass so the schematic reads as a clean cinematic shot.

8. **Fuse Phaser-schematic visuals with rendered exteriors/interiors in the opening.** During the intro, transition between top-down Phaser map views and the commissioned exterior/interior renders (§TODO-N, §TODO-O) so viewers feel that real, lived-in scenes sit behind the schematic. The goal: when they later watch the live Phaser simulation, the schematic should evoke the real life it represents — the renders become the "remembered reality" the schematic stands in for. Concretely: crossfade or match-cut from a Phaser top-down of (e.g.) Hobbs Cafe to its rendered interior, then back to schematic.

9. **End cards are static and overlong.** Both end-card beats (1:36–1:51 and 1:52–2:10, ~33s combined) read as a wall of text rather than a finale. Make them dynamic by cycling a third line.

   **Current first end card (1:36–1:51):**
   ```
   The village runs 24/7.
   Watch from the very first day.
   Follow every Double — routines, conversations, alliances, vote-outs.
   New trailer daily at 6:30pm
   ```

   **Current second end card (1:52–2:10):**
   ```
   Pistsov family — Who will stay alive.
   Watch live. Scroll Back. Follow every Double.
   New trailer daily at 6:30 pm
   http://www.doubland.ai
   ```

   **Proposed dynamic end card (replaces both):**
   - Lines 1–2 appear together first:
     ```
     Survival in Doubland
     <Cohort name>            (e.g. "Pistsov Family")
     ```
   - Third line cycles every ~1 s, one phrase per beat:
     ```
     Living Drama
     Strategic Alliances
     Unexpected Bonds
     Insidious Betrayals
     Unscripted Life
     ```
   - Final beat (third line lands on):
     ```
     Watch live — at www.doubland.ai
     ```

10. **Phaser-derived assets are stale — rebuild with a sim-aware capture system.** Every auto-captured asset under `video/assets/phaser/` outside the four manually-curated reference snapshots (`1-village-birdeye.png`, `2-hobbs-cafe.png`, `3-dorm.png`, `4-oak-hill-library.png`) is unfit for the trailer:
    - `establish_*.png` (×6) — captured at fixed coordinates chosen before the Pistsov cohort was locked; views don't correspond to where the cast actually lives, works, or interacts.
    - `home_topdown_*.png` (×4) — captured but never actually composed into the opener path.
    - `sprite_walkout_*.webm` (×4) — superseded by §TODO-A polished MP4s; dead weight.

    Rebuild under a new **two-tier asset taxonomy**:

    - **Tier A — Cohort-agnostic Phaser assets** (bake once, locked forever, reused across every cohort's opener):
      Examples: signature village establishing flyover for the brand open (see §TODO-T); generic "this is the_ville" canvas recording used in the Phaser ↔ rendered fusion beat (obs. #8); reference shots that don't depend on which cast is in the sim. Stored at `video/assets/phaser/cohort-agnostic/` (new subfolder); generated once via a dedicated bake script; checked into the repo; reused unchanged across all future trailer renders.

    - **Tier B — Per-sim-day Phaser captures** (captured fresh per trailer render against the actual simulation):
      Driven by the showrunner LLM's `key_steps` selection — same logic already used in `day_overview` / `day_in_life` modes. The LLM ranks sim events (conversations, alliances, conflicts, vote-outs) and outputs N candidate step ranges; the Playwright capture pass then records both (a) canvas recordings spanning those step ranges and (b) static screenshots at the boundaries. Stored under `data/{sim}/opener&NNN/raw/` (per-render, not checked in).

    **Wall-clock pacing constraint:**
      - Playback rate: 1 sim minute = 10 s wall clock (6× sim acceleration).
      - Per-scene cap: max 3 consecutive sim steps per Tier-B capture → ~30 s wall clock per beat. Forces the LLM to pick the highest-impact moments rather than long sequences.

    **Capture-format split (asks both static + motion per beat):**
      - Some opener beats want **motion** (sprites moving, conversations bubbling) → canvas recording.
      - Some beats want a single **iconic frame** (e.g. a tense vote-out moment held on-screen) → static screenshot at the same step boundary.
      - The compose layer decides per beat whether to use the recording or the screenshot derived from the same capture pass.

    This reopens §TODO-F (currently DONE in the status table) for revision — see suggestion #10 below.

---

#### Improvement suggestions

Ordered to match the observations above. Each entry: scope, code-change estimate, risk, recommended sequencing.

**1. Drop 9x16, ship 16x9 only.** ✓ **DONE 2026-05-11.**
- *Change shipped:* Added `VERTICAL_9X16_ENABLED = False` module flag at top of `video/compose_trailer.py`; gated the `crop_vertical` call in `compose_opener_trailer` behind it. Opener-mode only — day_in_life / day_overview paths untouched. Flip the flag to `True` to re-enable.
- *Effort actual:* 6 lines (2-line constant block + 4-line if/else wrap).
- *Verified:* re-rendered opener against `data/20260506-5/opener&001/` — only `trailer_16x9.mp4` produced; no `trailer_9x16.mp4`.

**2. Drop archetype stings (disable, don't delete).** ✓ **DONE 2026-05-11.**
- *Change shipped:* Added `STINGS_ENABLED = False` module flag; `_build_sting_overlays()` early-returns `[]` when disabled. Sting WAVs preserved at `archetypes/sting_{champion,wildcard,observer,connector}.wav`. Flip the flag to re-enable.
- *Effort actual:* 2 lines.
- *Verified:* re-rendered opener — narration + anthem mix only; no sting overlays.

**3. Build the Doubland brand intro — promote to three new TODOs.**
Three sub-deliverables; commission separately to avoid bundling risk:

- **§TODO-S Doubland logo splash** *(per-app, locked forever)* — **WORDMARK LOCKED 2026-05-12.** Composite mark: `DOUBLAND — What if?` (H1 + H2 two-line lockup). Trademark cleared (see `20260512_trademark-research-request.md`). Remaining: design-team typography commission (3 positioning variants requested per `20260512_design-brand-intro-request.md` §3 Deliverable A) + 4-second motion treatment (slow zoom-out + wordmark fade-in per Option A in design brief). Brand sound (Deliverable D) deferred to v2.x — the anthem's opening note carries the audio bed for v2.1.
- **§TODO-T Iconic establishing flyover** *(per-app, locked forever)* — **STILL LOCKED 2026-05-12.** Background commissioned at `video/assets/production/brand/brand_opener_iconic_still.png` (post-prompt-1 iteration of `opening.png`: dusk village scene with cyan wireframe overlays on three foreground buildings, conveying the "real lives + simulation duality" core of the Doubland format). Remaining: 4–5 second motion treatment (slow zoom-out OR voxel→photoreal resolve, see design brief §3 Deliverable C; ship Option A for v2.1, defer Option C to v2.x).
- **§TODO-U Series narrative template** *(per-format, evolves with format)* — **EFFECTIVELY DONE via Round 3 narration cache.** The cohort-aware narration generators (cold_open, format_lock, persona_narration, pressure_event, vote_dread, habit_hook) automated in `showrunner.py` IS the narrative template implementation. The trailer no longer has a separate ~15–20s VO over the brand splash — the brand opening is text-only (wordmark + iconic still), and narration begins with the cold-open contradiction. Downgrading §TODO-U from "commission narrative copy" to "lock the system prompts as the franchise spec" — and those prompts are already locked.

All three plug in as a single new beat ("brand open") inserted before the existing cold open. Rough new structure: brand open (~20s, §TODO-S/T/U) → cold open (~5–10s) → Phaser-rendered fusion beat (~10s, per #8) → cast section as grid-zoom-grid flow (~50–60s total, per #6) → stakes montage (~25s) → dynamic end card (~9s, per #9) ≈ 120–135s total. May want to shave the existing cold open to ~5s since the brand open now carries the orientation work.

**4. One-shot sprite walkouts (no loop).**
- *Change:* Remove `-stream_loop -1` from the video-input branch of `_compose_cast_intro_subclip` (line 433–436). The walkout plays its native ~2.5s once, then the final frame freezes for the remainder of the persona's narration window.
- *Effort:* ~5 lines in compose. Note: if #6 (grid-anchored cast intro) ships in the same revision, the old `_compose_cast_intro_subclip` likely becomes dead code — this fix migrates into the new `compose_cast_grid_intros` function instead. Either way, the "play once + hold final frame" behaviour is required.
- *Risk:* low standalone; becomes part of #6 if shipped together.
- *Sequencing:* absorbed by #6 if #6 ships at the same time, otherwise can ship independently in pass 1.

**5. Drop archetype labels from cast intros.** ✓ **DONE 2026-05-11.**
- *Change shipped:* Removed the role_label drawtext block (4 lines) from `_compose_cast_intro_subclip` in `video/compose_trailer.py`. Cast intros now show name + bio + trait moment only — no `CONNECTOR` / `OBSERVER` / `CHAMPION` / `WILDCARD` badge.
- *Effort actual:* 4 lines deleted.
- *Side note (still open):* The §TODO-G archetype classification is now unused by the opener path (since #2 also shipped). §TODO-G could be skipped for opener-mode renders to save one LLM call per render — flagged as a follow-up cleanup, not part of pass 1.

**6. Grid-anchored cast intro (replaces existing individual-intro compose).**
- *Change:* Rewrite the cast-intros stage as a single composite beat instead of N independent 15s clips. New compose function `compose_cast_grid_intros(personas, narration_per_persona, output_path)`:
  1. Render a base grid layout (4-up for Pistsov; dynamic for larger cohorts): headshot/sketch + name badge per cell on a brand-tinted background.
  2. For each persona in turn: zoom/scale their cell to full-screen (~600 ms transition), overlay name + bio + trait moment (no archetype label), play walkout MP4 once at native ~2.5s, hold final frame while narration finishes (~3–4s), then zoom back to grid (~600 ms).
  3. Repeat for the next persona until all introduced. Final state: grid visible, ready to crossfade into the stakes montage.
- *Effort:* ~80–120 LOC for the new compose function — bigger than the prior "cast-lineup" idea but absorbs the existing per-persona compose entirely (so the old `compose_cast_intro` becomes dead code). Reuses existing sketch + walkout assets.
- *Risk:* medium — the zoom/grid math needs care, and the narration-timing handoff between personas must align with the walkout's natural 2.5s + a deterministic narration window. Easy to look janky if pacing isn't tight.
- *Design open questions:*
  - Headshot source — use existing `users/sketches/{uuid}.png` (already shipped) or a new tighter crop?
  - Grid cell layout for the 4-up — 2×2 (square cells, more breathing room) or 1×4 horizontal strip (more cinematic, but loses on vertical real estate)? Recommend 2×2 for Pistsov.
  - Final-frame hold — freeze the walkout's last frame, or crossfade to the persona's sketch as a "settled" portrait while narration continues? Recommend freeze-frame to preserve continuity.

**7. Strip Phaser player UI from flyover captures.**
- *Change:* In the Playwright capture step (`capture_static_assets.py` / scene-recording pipeline), inject CSS to hide the player chrome before recording: timeline scrubber, top-right close button, any HUD elements. Likely a single `page.addStyleTag({content: ".timeline, .close-button, .hud { display: none !important; }"})` call before `page.video()` starts — exact selectors to confirm from the `double-front` repo. Re-capture the affected flyovers (or all of them if simpler).
- *Effort:* ~5 LOC + asset re-capture pass.
- *Risk:* low — visual-only fix, no runtime/sim impact. If chrome selectors change in the frontend later, this fix may regress silently — worth a small visual-diff test against a clean reference capture.

**8. Phaser-schematic ↔ rendered-reality fusion beat.**
- *Change:* New 8–12s beat in the opening, after the brand intro (§TODO-S/T/U) and before the cold open. Pick 3–4 locations from §TODO-O interiors + §TODO-N exteriors and crossfade each from its rendered version to its Phaser top-down equivalent (or vice versa). Narration over: a short line like *"Real lives, rendered in a schematic world."* Output: a single MP4 clip slotted as a new stage.
- *Effort:* ~40–60 LOC for the compose function + crossfade timing tuning. Asset side: the rendered interiors/exteriors are already shipped (§TODO-N ✓, §TODO-O ✓); the Phaser top-downs are auto-captured via §TODO-F. No new commissioning. Will need new narration line via ElevenLabs (~1 min).
- *Risk:* low–medium — depends on whether the schematic-to-render contrast reads as artful or jarring. Recommend prototyping with 2–3 locations first before committing to 4.
- *Sequencing:* lands naturally after the brand intro is in place; needs the brand-intro framework to exist as a precursor stage.

**9. Dynamic cycling end card (replaces both current end cards).**
- *Change:* New compose function `compose_dynamic_end_card(cohort_name, cycle_lines, final_line, output_path)`:
  1. ~2s fade-in of the two static lines (`Survival in Doubland` + cohort name).
  2. For each of the cycling phrases (default 5), draw the phrase as the third line and hold for 1.0s before cutting to the next.
  3. Final phrase lands on the URL line (`Watch live — at www.doubland.ai`) and holds for 2s before fade-to-black.
  4. Total runtime: 2s fade-in + N×1s cycle + 2s URL hold ≈ 9s for 5 cycle phrases. ~24s shorter than the current 33s of stacked end cards.
- *Effort:* ~60–80 LOC for the compose function (FFmpeg drawtext with sequential `enable=` time-gating, or N sub-clips concatenated). Note: prior cast-intro work avoided `enable=`-with-output-label parser issues by splitting into static-overlay subclips — same approach applies here (one subclip per cycle beat, then concat).
- *Risk:* low — purely additive; doesn't break the existing end-card path until you swap it in.
- *Copy (locked 2026-05-11):* `Living Drama` → `Strategic Alliances` → `Unexpected Bonds` → `Insidious Betrayals` → `Unscripted Life` → final lands on `Watch live — at www.doubland.ai`.
- *Sequencing:* independent of cast/brand work; ready to implement.

**10. Two-tier Phaser capture system (replaces §TODO-F).** Sized as a foundational refactor — the rest of the suggestions (especially #6, #7, #8) sit on top of it, so this should land before they're finalized.

- *Change A — folder + nomenclature split:*
  - `video/assets/phaser/cohort-agnostic/` → Tier A bake outputs (committed; reused forever).
  - `video/assets/phaser/_moodboard/` → move the 4 hand-curated reference snapshots (`1-village-birdeye.png`, `2-hobbs-cafe.png`, `3-dorm.png`, `4-oak-hill-library.png`) and the existing `raw/` subfolder here. **Locked 2026-05-11:** keep them in the Phaser tree (they are Phaser captures, just human-curated) — the `_moodboard/` subfolder marks them clearly as reference-only, not pipeline inputs.
  - `data/{sim}/opener&NNN/raw/phaser/` → Tier B captures (per-render; not committed).
  - **Delete:** all current `establish_*.png`, `home_topdown_*.png`, `sprite_walkout_*.webm` files in `video/assets/phaser/` after the bake script's new outputs land.

- *Change B — new Tier A bake script:*
  - New script: `video/assets/scripts-prompts/bake_cohort_agnostic_phaser.py`.
  - Outputs: a small, deliberately curated set of "this is the_ville" Phaser visuals — village overhead, signature flyover (canvas recording), 2–4 landmark establishing frames. Run once per village (or when the_ville layout meaningfully changes).
  - Driven by Playwright against the frontend at `?recording=true`; uses `__panCameraTo` + `__setCameraZoom` + (new) `__hidePlayerChrome()` to strip the UI artifacts (per #7).
  - All paths checked into the repo; no per-sim regeneration.

- *Change C — Tier B capture: extend showrunner + capture pipeline:*
  - **Showrunner LLM:** extend the opener script schema to include an `atmospheric_key_steps` field — a list of {step_start, step_end, label, capture_kind: "video"|"frame"} entries. Mirrors the existing `key_steps` logic in `day_overview` / `day_in_life` modes. Constraint passed to the LLM in the prompt: `step_end - step_start ≤ 3` (max 3 consecutive sim steps per beat); pick highest-impact moments only.
  - **Playwright capture pass:** new function `capture_atmospheric_beats(sim_code, atmospheric_key_steps, output_dir)`. For each entry: seek the sim viewer to `step_start`, set playback speed to 6× (the 1 sim-min = 10 s wall-clock rule), record canvas for the `(step_end - step_start) × 10 s` window if `capture_kind="video"`, or screenshot at `step_start` if `capture_kind="frame"`. Hidden chrome throughout.
  - **Compose layer:** the stakes montage and any other "show me what's happening" beat pulls from `atmospheric_key_steps` outputs instead of the old `establish_*.png` filename list. Each beat references its label, not a hard-coded filename.

- *Effort:* large — roughly:
  - Tier A bake script: ~80–120 LOC (Playwright + camera control).
  - Showrunner schema extension + prompt edits: ~30–50 LOC.
  - Tier B capture pipeline: ~100–150 LOC (new Playwright function + integration into `generate_trailer.py` Step 4).
  - Compose-layer migration (stakes montage + cold open + #8 fusion beat to consume new outputs): ~40–60 LOC.
  - Total: ~250–380 LOC across 4 files. Plan for 2–3 days end-to-end.

- *Risk:* medium. The showrunner LLM may pick uninspired step ranges on the first iteration; budget one round of prompt iteration after the first end-to-end test render. Frontend `?recording=true` must support seeking + speed control reliably — if not, that's a `double-front` repo dependency that needs to land first.

- *Open question — playback rate flexibility:* 6× (1 sim-min = 10 s wall clock) is the working default; the LLM could in principle output a per-beat speed override (`playback_speed`) for moments that want a slower pace (e.g. a quiet vote-out scene at 3×). Recommend hold-firm on 6× for v1 and revisit only if a beat demands it.

- *Reopens:* §TODO-F (Home / establishing shots). Mark as **REOPENED** in the status table once this lands — current `capture_static_assets.py` becomes obsolete and is replaced by the Tier A bake + Tier B capture pair.

---

#### Implementation plan — opener trailer v2.x

> **Last status sweep: 2026-05-14.** Phases marked ✓ DONE are shipped on `ivan/video`; phases marked 🟡 IN FLIGHT have an external dependency (designer / advisor); phases marked ⬜ OPEN are not started. Phases 1–6 + 8 are DONE; Phases 7 and 9 remain open.

##### Phase 1 — Code-only revisions pass 1 ✓ **DONE 2026-05-11**

Three flag-gated changes in `video/compose_trailer.py` (commits `caa0b379`, `817e0943`):
- ✓ #1 — Drop 9x16 vertical render (`VERTICAL_9X16_ENABLED=False`)
- ✓ #2 — Disable archetype stings (`STINGS_ENABLED=False`)
- ✓ #5 — Remove archetype labels from cast intros

#7 (strip Phaser UI artifacts) was scoped here originally but was absorbed by Phase 7 (#10 two-tier Phaser capture) since the stale `establish_*.png` shots are slated for deletion.

##### Phase 2 — Narration overhaul + LLM cache ✓ **DONE 2026-05-12**

Four-file change (commits `553f88cd` + `132377cc` + `f21bd6f0` + `8e232e34`):
- ✓ Migration: `double.video_narration_cache` table (RLS-enabled, service-role only)
- ✓ `supabase/db_reference.md` updated
- ✓ `video/narration_cache.py` — `get_or_generate()` with hash-based invalidation + pinned overrides
- ✓ `video/showrunner.py` — 6 new Tier-B system prompts (cold_open, format_lock, persona_narration, pressure_event, vote_dread, habit_hook); all hardcoded copy removed; Burnett 6-beat structure auto-generated per cohort
- ✓ `OPENER_NARRATION_BOUNDS` aligned across `showrunner.py` and `validate_trailer.py`
- ✓ Cache-thrash fix on cold_open + pressure_event (commit `ba846a60`): user prompts now use deterministic `scratch_compact` fields, not the stochastic regenerated bio

##### Phase 3 — Audio fixes (A1, A2) ✓ **DONE 2026-05-12**

Commit `0f957757`:
- ✓ A1 — Narration head cutoff: `[PAUSE 0.8s]` prepended to assembled narrator_script → 1.3s of head silence eliminates first-phoneme clip
- ✓ A2 — Doubland pronunciation: `TTS_PRONUNCIATION_OVERRIDES` substitutes `Doubland → Dohbland` at the ElevenLabs boundary; canonical spelling preserved in cache + script.json

##### Phase 4 — Round 3 closing card (A3, C1, C2, F1) ✓ **DONE 2026-05-12**

Commit `ff7cf5a0`:
- ✓ A3 — Habit hook rewritten as ONE 3-6 word closing line ("Day 1 starts now")
- ✓ C1 — How-to-watch card retired (zero-duration block; compose gated to skip)
- ✓ C2 — New single end card with cohort-aware staged layout: cohort label (dynamic via `cohort_name.upper()`), question (dynamic via `season_title`; **superseded by Phase 4.5 — now bare "What if?"**), URL (`doubland.ai`), cadence (`New trailer daily · 6:30 PM`)
- ✓ F1 — Silent tail resolved: "Day 1 starts now" VO at ~t=112s, end-card visual + music carry to ~t=130s
- ✓ Background asset committed (council platform shot). **Relocated 2026-05-13:** moved from `video/assets/production/end_card_background.png` → `video/assets/production/brand/brand_end_card_background.png`. The selected end-card hero composition (card 2 from the 2026-05-12 typography pass) is locked at `video/assets/production/brand/brand_end_card.png`. **Engineering note:** ✓ DONE 2026-05-14 — `END_CARD_BACKGROUND_PATH` in `video/compose_trailer.py:701` now points to `video/assets/production/brand/brand_end_card_background.png` (repointed in commit `e7a06ab2`).
- ✓ `generate_opener_end_card` rewritten in `compose_trailer.py` to use background PNG + asymmetric Card-2 typography layout

##### Phase 4.5 — Brand-voice backport to v2.1 narration + end card ✓ **DONE 2026-05-12**

Lightweight pass after `concept/brand.md` ratification — pull brand Register A ("What if?") and vocabulary discipline into the v2.1 trailer without waiting for Phase 6 brand-asset delivery. Zero new visual assets; all changes are prompt-level or one-line config swaps.

`video/showrunner.py`:
- ✓ New module-level constant `OPENER_BRAND_DISCIPLINE` codifies the forbidden vocabulary list (*simulate*, *agent*, *AI twin*, *digital twin*, *virtual you*, *imagine*, *alternate reality*, *parallel life*) and the "intimate-conspiratorial / no urgency / no aspirational fluff" register from `concept/brand.md`.
- ✓ All 6 Burnett-beat system prompts append `OPENER_BRAND_DISCIPLINE` (cold_open, format_lock, persona_narration, pressure_event, vote_dread, habit_hook). Editing this single constant invalidates the prompt_hash on all six cached artifacts at once, forcing a regen on next render — the intended cache-invalidation pivot.
- ✓ `OPENER_PERSONA_NARRATION_SYSTEM` adds *"The version of [Name] that..."* as an optional pivot (brand signature phrase from Pillar 4 / Mirror). Available, never forced; capped at one use per script.
- ✓ `OPENER_COLD_OPEN_SYSTEM` constraint text fix: "their **AI** Doubles" → "their Doubles" — the "AI" qualifier is retired per brand vocab rules.
- ✓ `end_card_block.question` (and back-compat `subtitle` field) hardcoded to bare **`What if?`** — supersedes the Phase 4 `season_title`-derived "Who will stay alive?" question per `concept/brand.md` § "End card: Bare 'What if?' (A) on screen. Remove all 'Who will stay alive?' danger text from card." `season_title` retained as trailer metadata only; no longer surfaces visually.

`video/compose_trailer.py`:
- ✓ `generate_opener_end_card` docstring updated to reflect bare-"What if?" mapping (cosmetic — no rendering logic changed).

**Net behavior change for next render:** all 6 narration cache rows on `video/narration_cache` for `20260506-5` invalidate (hash mismatch); next opener render regenerates them under the new prompts, producing tighter, on-brand copy. End card visually reads `What if?` instead of `Who will stay alive?`.

**What this does NOT change:** wordmark commission (Phase 6 still in flight), Phase 6 brand-opener stage (still ⬜), Phase 7/8/9 (still ⬜). Phase 4.5 is purely an in-place v2.1 brand-voice tightening — it does not unblock or replace any deferred phase.

##### Phase 5 — Brand wordmark content lock ✓ **DONE 2026-05-12**

Doc-only:
- ✓ Locked composite mark: **`DOUBLAND — What if?`** (H1 + H2 two-line lockup)
- ✓ Trademark cleared by IP counsel (Marvel/Disney *"What If…?"* assessed as non-blocking — see `20260512_trademark-research-request.md`)
- ✓ Iconic background still locked at `video/assets/production/brand/brand_opener_iconic_still.png` (dusk village + cyan wireframe overlays, post-prompt-1 iteration of `opening.png`)
- ✓ Typeset wordmark composition locked 2026-05-13 at `video/assets/production/brand/opening_wordmark.png` (Editorial-centered variant — see Phase 6 §6a/6b)
- ✓ §TODO-U (narrative template) effectively DONE via Phase 2's narration cache (downgraded from "commission VO copy" to "system prompts ARE the franchise spec")

##### Brand visual narrative arc (locked 2026-05-13)

The trailer's brand-visual journey expresses the product premise: **the boundary between simulation and reality dissolves over the course of watching.**

- **Opener** carries the cyan-wireframe duality (real cottages + simulated overlays). This frames the viewer's expectations: "you are about to see a mix of simulation and real life."
- **Closer** is pure cinematic — no cyan, no overlays. By the end, the duality has dissolved; everything is perceived as real life. The Doubles, the village, the consequences — all reading as lived events.

Practical consequence for motion commissions: opener clips must preserve the cyan-wireframe motif; closer clips must contain zero cyan. This is the locked brand statement for the trailer pipeline. (Worth mirroring into `D:\Coding\double-ivan\concept\brand.md` § Visual & Tone Guardrails on next pass.)

##### Phase 6 — Brand wordmark commission + motion 🟡 **IN FLIGHT (design team)**

Sequenced asks, ~10–14 day total runway:

✓ **6a — Wordmark typography commission DONE 2026-05-13:** locked content `DOUBLAND` (H1) + `What if?` (H2). Winner: "Editorial centered" composition (large display serif `DOUBLAND` cream, thin gold rule, sentence-case `What if?` below). Brief used: `20260513_brand-wordmark-typography-brief.md` (now superseded — kept for archive). Background plate: `brand_opener_iconic_still.png` unaltered. **`.ai` suffix evaluated and rejected** — primary brand mark stays pure `DOUBLAND`; URL stays on end card. Parallel "URL lockup" variant (`DOUBLAND.ai` for social/ads) noted as future asset, not in trailer scope.

✓ **6b — Winner locked at** `video/assets/production/brand/opening_wordmark.png`. Minor nit-list deferred to 6c (cyan wireframe currently grazes the gold rule + descender of `What if?`; lockup sits dead-center, could nudge ~10% upward — both fixable in the motion treatment pass).

✓ **6c — Motion direction DONE 2026-05-13** (both bookend clips locked):
- ✓ **Opener motion** `brand_opener_motion.mp4` (1280×720, 24 fps, 6.04 s, silent). Slow push-in through dusk village; cyan-wireframe duality animates throughout; locked wordmark + gold rule baked in. Brand-bible "cyan never touches wordmark" rule explicitly bent here — the duality IS the brand, brief overlap during motion is on-brand.
- ✓ **End-card motion** `brand_end_card_motion.mp4` (1280×720, 24 fps, 6.04 s, silent). Slow push-in on lantern-lit council platform; fog drift + string-light flicker; **zero cyan, zero text** — pure cinematic per duality-arc principle (simulation/reality boundary has dissolved by close). Text-free canvas — `generate_opener_end_card()` overlays cohort label, bare `What if?` (per §4.5), URL, cadence via FFmpeg drawtext.

✓ **6d — Brand assets received and locked 2026-05-13:**
- ✓ Locked typeset still: `video/assets/production/brand/opening_wordmark.png` (1280×720, Editorial centered)
- ✓ Locked opener motion: `video/assets/production/brand/brand_opener_motion.mp4` (1280×720, h.264, 24 fps, 6.04 s, silent — wordmark + gold rule baked in)
- ✓ Locked end-card motion: `video/assets/production/brand/brand_end_card_motion.mp4` (1280×720, h.264, 24 fps, 6.04 s, silent — text-free, pure cinematic per duality-arc principle)
- ⬜ SVG wordmark (deferred — only needed for web/print, not the trailer)
- ⬜ `brand_iconic_flyover.mp4` (deferred — `brand_opener_motion.mp4` may serve double duty; revisit during 6e wiring)

✓ **6e — Engineering integration DONE 2026-05-13** (`video/compose_trailer.py`):
- ✓ New `compose_brand_open(output_path, duration_sec=None)` — stream-copies `brand_opener_motion.mp4` as Stage 0 of `compose_opener_trailer`. Returns False when asset is absent so the pipeline degrades gracefully to pre-Phase-6 behavior.
- ✓ New `_prepad_narration(narration_path, lead_sec, output_path)` — prepends silence so cold-open VO still lands on its script timestamp after the brand open shifts the video timeline.
- ✓ `generate_opener_end_card` background loader now 3-tier: `brand_end_card_motion.mp4` (preferred, freeze-frame extended to fill end-card window) → `brand_end_card_background.png` → `lavfi color` flat black.
- ✓ `compose_opener_trailer` extended: brand-open prepended; `target_duration += brand_open_dur` (~130s → ~136s, within 95–180s validator bounds); narration pre-padded; sting timestamps shifted by `brand_open_dur`; intermediates cleanup includes the new artifacts. Music timeline is unshifted — anthem's opening note rides under the brand-open frame as the audio bed.
- Smoke-tested: `compose_brand_open` produces 6.04s clip from the locked asset; `_prepad_narration` produces correct duration shift on a synthetic input.

⬜ **6f — Validation render:** kick a fresh pipeline run against `20260506-5`; verify brand opener plays before cold open; confirm narration cache still hits.

**Brand sound (Deliverable D from design brief) deferred to v2.x** — the anthem's opening note carries the audio bed for v2.1.

##### Phase 7 — Two-tier Phaser capture system (#10 + #7) ⬜ **OPEN**

Foundational refactor (~2–3 days; full design in §10 of Improvement Suggestions above):
- ⬜ Migration: split `video/assets/phaser/cohort-agnostic/` (Tier A, bake once) + `data/{sim}/opener&NNN/raw/phaser/` (Tier B, per-render)
- ⬜ New `video/assets/scripts-prompts/bake_cohort_agnostic_phaser.py` (Tier A bake)
- ⬜ Showrunner schema extension: `atmospheric_key_steps` field; LLM ranks 1–3 high-impact step ranges per sim
- ⬜ New `capture_atmospheric_beats()` Playwright function for Tier B captures
- ⬜ Compose-layer migration: stakes montage + #8 fusion beat consume new outputs
- ⬜ Strip Phaser player chrome (#7) from captures via CSS injection in Playwright pass

Reopens §TODO-F (was DONE; now flagged REOPENED 2026-05-11). Gates #8 (fusion beat) and the visual layer of cast-intro restructure.

##### Phase 8 — Grid-anchored cast intros (#6 + #4) ✓ **DONE 2026-05-14**

Shipped in `compose_trailer.py` (`compose_cast_grid_section` + helpers) plus `tts.py` / `generate_trailer.py` (narration timing map):
- ✓ Auto-sizing roster grid (`_render_roster_png` / `_roster_grid_dims`) — 2×2 for 4 doubles, scales toward 4×4 for ~15
- ✓ Per-persona card **animates out of its grid cell** (`_compose_zoom_transition` — per-frame `scale`/`overlay` with `eval=frame`) → holds full-screen for that double's narration line → collapses back into the cell
- ✓ Sprite walkout plays once, no loop (`loop_video=False` on the card's second-half subclip)
- ✓ Beat durations are narration-driven: `tts.render_narration` writes `narration_timing.json` (measured per-line start/end); compose derives every cast / cold-open / stakes / end-card duration from it, and trailer length is the real concatenated runtime
- ✓ Decided: 2×2 auto-sizing grid (not 1×4 strip); the walkout's last frame seeds the collapse transition

Did **not** end up depending on Phase 7 — a headshot + the commissioned walkout MP4 per cell was sufficient, so Phase 8 shipped ahead of the Phase 7 capture refactor. Card styling still uses the placeholder archetype frames (§TODO-E); commissioned frames slot into the same zones with no rework.

##### Phase 9 — Phaser↔rendered fusion beat (#8) ⬜ **OPEN** — assets locked 2026-05-13

New 8s beat in the opening, after the brand intro and before the cold open. **Scope simplified 2026-05-13:** rather than per-location crossfades (the original #8 spec), Phase 9 is now a **single 8s schematic→cinematic dissolve** using two locked Phase 7 commissioned assets. Implementation is ~20 LOC of FFmpeg `xfade` in `compose_trailer.py`.

**Architecture:**
```
[signature_flyover.mp4, 4s — schematic plate]
   ↓ xfade dissolve (2s overlap, transition=fade)
[cinematic_village_aerial_tudor.mp4, 4s — cinematic plate]
————————————————————————————————————————————————————
   = 8s Phase 9 fusion beat
```

**Compose stage (to add):**
- New function `compose_phaser_to_cinematic_fusion(schematic_path, cinematic_path, narration_path, output_path)`.
- FFmpeg filter graph: `[0:v][1:v]xfade=transition=fade:duration=2:offset=3[v]` (xfade starts 1s before halfway so the cinematic plate fully resolves by the end).
- Strip audio from both source clips with `-an`; narration overlay added at mix stage.
- Output: single MP4 clip slotted as new compose stage between brand-open and cold-open.

**Locked assets (2026-05-13):**
- *Schematic plate:* `video/fly-over/signature_flyover.mp4` — pixel-art top-down village with animated sprites walking the paths. Reads as "live simulation."
- *Cinematic plate:* `video/fly-over/cinematic_village_aerial_tudor.mp4` — aerial Tudor village in the locked Doubland storybook aesthetic (matches `_style_frame_master.png`). Reads as "real, lived-in world."

**Narration:** still TBD (short Tier-B LLM line, ~10 words, e.g. "Real lives. Rendered in a schematic world."). Adds via existing prepad-narration plumbing.

**What we tried but abandoned:** single-clip Grok schematic→cinematic morph (7+ Grok iterations 2026-05-13). Grok could deliver any 2 of {layout fidelity, schematic→cinematic morph, correct Tudor style} but never all 3 reliably. The FFmpeg-xfade approach above sidesteps the trade-off — both plates individually hit their goals, the xfade does the bridge.

**Original #8 per-location crossfade idea is deferred:** could revisit post-v2.1 as a v2.2 enhancement if the single-dissolve fusion beat reads as weaker than per-location crossfades in playback testing.

---

#### Critical path + sequencing

```
Phase 1 ✓
Phase 2 ✓
Phase 3 ✓
Phase 4 ✓
Phase 4.5 ✓ (brand-voice backport — supersedes Phase 4 end-card question)
Phase 5 ✓
Phase 6 ✓ (brand wordmark + motion + engineering integration; 6f satisfied by the 2026-05-14 validation renders)
Phase 8 ✓ (grid cast intros — shipped 2026-05-14; did not need Phase 7 after all)
Phase 7 ⬜ ──→ two-tier Phaser capture; now optional polish (feeds Phase 9 plates + cleaner stakes captures)
Phase 9 ⬜ ──→ Phaser↔cinematic fusion beat; ~20 LOC FFmpeg xfade, assets locked 2026-05-13
```

**v2.1 status:** SHIPPED — brand opener + narration-aligned grid cast intros + narration-driven runtime, validated 2026-05-14 on `data/20260513-1/opener&004`.

**v2.2+ remaining:** §TODO-E commissioned card frames (design brief drafted); Phase 7 two-tier Phaser capture; Phase 9 fusion beat. Phases 7 and 9 are ~3–4 days of engineering combined; §TODO-E is a design-team commission.

---

### MVP path — ship v1 today (1–1.5 h)

Three moves cherry-picked from the full plan above. Goal: a watchable v1 opener live today, with the cheapest wins. Everything skipped here is deferred to the full execution order — no commitments forfeit, just sequencing.

**Step 1 — Restore the stale `establish_*.png`.** ✓ **DONE 2026-05-11.**
- *Action shipped:* `git checkout 75aa01759^ -- video/assets/phaser/establish_*.png` — restored 6 establishing PNGs (cafe_exterior, council_zone, homes_row, village_dawn, village_dusk, village_overhead) from the commit just before they were deleted in `75aa01759` ("Update video assets and enhance interior prompt management").
- *Why:* unblocks `compose_opener_trailer` (cold open + stakes montage both require at least one `establish_*.png` in `PHASER_DIR`). These are placeholder-quality and will be nuked again when #10's Tier A/B capture system lands — restoration is **temporary**, just to ship today.

**Step 2 — Perfect the narration.** ✓ **DONE 2026-05-12 — shipped as a much bigger system than originally scoped.**

Original plan was to hand-edit `data/20260506-5/opener&001/script.json` and force a narration re-render. Replaced with an **automated cohort-aware LLM generator + Supabase cache** so the same quality lift propagates to every future cohort without manual editing. See "Round 3 milestone" subsection below for the architecture; the 4-file change is committed on `ivan/video` (commits `553f88cd`, `132377cc`, `f21bd6f0`, `8e232e34`).

Sample of what the new pipeline now produces for Pistsov (verbatim from `data/20260506-5/opener&002/script.json` `narrator_script`):

> *"They're family. In Doubland, their Doubles have to survive each other.* [PAUSE 1s] *Four Doubles enter the village. Every day brings pressure and escalating stakes. Every night, they vote one contestant out.* [PAUSE 2s] *Gosha keeps everyone organized and encouraged. But under pressure, the teammate who holds the group together can quietly steer decisions — and decide who stays.* [PAUSE 1s] *Ivan plans every move with obsessive discipline. That makes him reliable. It also makes him the person who quietly calculates who to cut when efficiency threatens the group's survival.* [PAUSE 1s] *Katya is relentless about turning ideas into plans. But under pressure, the kid who always finishes what she starts can steer everyone toward her solution — and lock out alternatives.* [PAUSE 1s] *Luba keeps everyone organized and encouraged. That makes her the glue of the group. It also makes her dangerous when she controls the schedule and the decisions.* [PAUSE 2s] *Now the house narrows and every promise counts. The vote. Where loyalty becomes math, where you decide to outlast the person you raised, loved, and trusted. Who will betray blood to survive?* [PAUSE 1s] *Who feels safest enough to betray first, and who will be exposed when they stand alone?* [PAUSE 2s] *Tonight, secrets blow up on camera and you'll want the morning explanation. Tomorrow at six-thirty, catch the fallout and join the recap — watch live at doubland dot ai."*

**Step 3 — Minimum-viable brand opening (30–60 min).** Pure typography over black; ships today.
- *Add `compose_brand_open(output_path, duration_sec=4.0)` to `video/compose_trailer.py`.* Same pattern as `generate_opener_end_card`: black background via `lavfi color`, two centered `drawtext` calls (wordmark + tagline), 0.5 s fade-in at start.
- *Visual structure (4 s total):*
  - `0.0–0.5 s` — fade in from black
  - `0.5–3.0 s` — `DOUBLAND` wordmark centered (bold, gold `#C8A86B`), tagline below in lighter weight (locked copy TBD — placeholder: "Survival, unscripted")
  - `3.0–4.0 s` — hold; anthem's first beat lands at 3.0 s carrying the emotional moment
  - `4.0 s` — crossfade into existing cold open
- *Slot:* insert as new first stage in `compose_opener_trailer`, before the cold open. Add to the final-concat list; bump the stakes-montage and cast-intro `time_range_sec` values by `+4 s` in `script.json` (so narration timings still align).
- *Effort:* ~40 LOC new compose function + ~10 LOC integration. No external assets, no Midjourney cycle, no chime — anthem carries the audio bed.
- *Acceptance:* the trailer opens with a deliberate, brand-anchored beat that imprints "DOUBLAND" before any sim content appears.

**Decisions needed to start Step 3:**
1. **Brand tagline copy** (≤4 words for legibility at 3 s). Placeholder: `Survival, unscripted`.
2. **Confirm Step 2 narration text** verbatim or with tweaks before re-rendering.

**What this MVP path explicitly defers:**
- §TODO-T iconic flyover commission (Grok-Imagine render cycle — won't finish today)
- §TODO-S commissioned logo art (text-only wordmark is fine for v1; replace with a PNG later without code change)
- §TODO-U narrative template formalization (narration is hand-written for this cohort; template generalization waits)
- #6 grid-zoom cast intro restructure (1 day of work)
- #8 Phaser-rendered fusion beat (depends on Tier A bake)
- #9 dynamic end card (3–5 h — fits if everything else flies, but not blocking)
- #10 two-tier capture system (multi-day foundational refactor)

Total: ~1–1.5 h of work + your iteration time on narration listening.

---

### Round 1 Reality TV consultation — production-ready artifacts (2026-05-11)

Captured from the external advisor response to `D:\Coding\double-ivan\20260511_realityTV-expert-request.md`. These supersede the MVP-path narration draft above; the MVP-path version was a strawman before the consultation landed.

**Source:** Burnett / de Mol / Parsons "lens" framework (see `20260511_realityTV-expert-request.md` § Round 1 status for full response). Follow-up gaps queued in `20260511_realityTV-expert-followup.md`.

#### Verdict adopted

Our original 5-beat structure (concept → cast → drama → lesson → future) reads as a **format explainer**. It tells viewers about the rules before earning emotional attachment. Replaced wholesale with a **"relationship-under-pressure"** structure built around a social contradiction that lands in the first 7 seconds.

#### V2 opener beat sheet (130 s, locked)

| Time | Beat | Job |
|---|---|---|
| 0–7 s | **Cold open contradiction** | Real family / simulated betrayal |
| 7–18 s | **Format lock** | Four AI Doubles, one village, nightly vote-out |
| 18–65 s | **Cast as threats** | Each persona: virtue → danger → likely betrayal mode |
| 65–90 s | **First pressure event** | One real challenge or social rupture — not a generic montage |
| 90–112 s | **Vote-out dread** | Who is safe, who is exposed, who has motive |
| 112–130 s | **Return hook** | Named question + exact habit: "Tomorrow, 6:30 PM" |

#### Cast-intro template (locked, repeatable across cohorts)

```
[Name] is the one who [lovable strength]. But under pressure,
that could make them [danger].
```

#### Pistsov cohort sample copy (v2 narration, ready to render)

- **Gosha:** *"Gosha keeps people together. But in a survival game, the person holding the group together can also decide who gets left outside."*
- **Ivan:** *"Ivan watches everything. That makes him patient. It also makes him dangerous."*
- **Katya:** *"Katya turns plans into action. If the village needs order, she could lead it. If order becomes power, she could run it."*
- **Luba:** *"Luba organizes the room without needing the spotlight. The question is whether anyone notices before she has the votes."*

#### Cold-open narration draft (v2, 0–18 s)

```
[0–7 s — social contradiction]
This is the Pistsov family. In real life, they know each other too well.
In Doubland, their AI Doubles have one rule: survive each other.

[7–18 s — format lock]
Four Doubles enter a private village. Every day brings pressure. Every
night, they vote one of their own out.
```

#### Conflict-beat structure (Trigger → Choice → Consequence)

Every drama beat must show three visible pieces:

1. **Trigger:** what changed?
2. **Choice:** what did someone do?
3. **Consequence:** who now trusts them less?

Never use "everything changed" — show the exact social pivot. Sample landing line:

> *"Then the first challenge exposed the problem: everyone needed cooperation, but only one person could afford to be honest."*

#### Vote-dread closing (90–112 s)

Tease through **motives, not outcome**:

> *"By nightfall, the question is not who played best. It is who feels safest enough to betray first."*

Visual: three possible targets, quick flashes of contradictory dialogue, **cut before the vote reveal.**

#### Habit hook (112–130 s)

Named unresolved question + daily cadence:

> *"Tonight, one Double loses the village. Tomorrow at 6:30, the survivors explain themselves. Watch live at doubland.ai."*

#### End-card module (replaces dynamic end card #9)

Three persistent tiles at the close of every trailer (opener AND day-overview):

```
┌─────────────────┬──────────────────┬───────────────────┐
│    AT RISK      │  HOLDING POWER   │  WATCH TOMORROW   │
│  <persona name> │  <persona name>  │     6:30 PM       │
└─────────────────┴──────────────────┴───────────────────┘
```

This turns the opener from a one-off promo into the **first installment of the daily habit loop.** The same module evolves each day as new doubles fall into "at risk" or rise to "holding power."

#### Guardrail (must respect)

> Do NOT make the trailer feel like the real family is being humiliated by their AI selves. The safe dramatic frame is **"social pressure reveals surprising strategy,"** not **"your Double exposes the worst version of you."** Keep betrayal playful, consequential, and opt-in; avoid copy that implies the AI is revealing hidden real-world truth about the person.

This rules out a class of "AI knows the real you" framings that would otherwise be tempting. Active replacement framing is still open — queued as Q7 in the follow-up.

#### A/B testing protocol (lock before iterating further)

Build **two 130-second animatics** from the same footage:

- **A — current proposed 5-beat:** concept → cast → drama → lesson → future.
- **B — relationship-under-pressure:** real bond → survival rule → cast danger → rupture → vote dread → 6:30 habit.

Test with **10 cold viewers**. Ask only:

1. "What is the show?"
2. "Who do you remember?"
3. "Who do you think is dangerous?"
4. "Would you watch tomorrow's recap?"

The winning cut is **not** the one people understand best. It's the one where viewers can name a person, predict a betrayal, and ask what happens at the vote.

#### What's still open (Round 2 — see `20260511_realityTV-expert-followup.md`)

Production-blocking gaps from Round 1: narrator voice casting, music-vs-narration ratio, animated-sprite emotional weight, three reference trailers to study, vocabulary inventory, daily-recap structure, and the active dramatic frame to use *instead of* "AI exposes hidden truth."

---

### v2 production scope — locked 2026-05-11

Goal: ship v2 of the opener trailer **as fast as possible** with **zero new asset commissioning**. v2 is a narration-overhaul-only release; everything else stays on v1 assets.

**In scope for v2 (text-only changes + one render):**
- Replace `narrator_script` in `data/20260506-5/opener&001/script.json` with the Burnett 6-beat structure using Round-1 advisor copy.
- Delete `audio/narration.mp3`; re-invoke `compose_opener_trailer` to regenerate via ElevenLabs.
- Trailer compose stitches new narration into existing visual + audio scaffolding.

**Explicitly out of scope for v2** (deferred to v3+ regardless of Round 2 advisor recommendations):
- **No new ElevenLabs voice.** Current voice ID `cIO62fcmCSQhE0DE2WS2` stays. The Round-2 "mysterious-intimate female" casting brief is adopted as a *future* direction; not implementing now.
- **No new anthem / music track.** Current `video/audio/music_anthem.mp3` stays. No separate cold-open music bed, no Suno regeneration, no audio-bakeoff prototype.
- **No music-ducking change.** Current `−6 dB` under narration stays. Round-2 recommended `−9 to −12 dB`; that's a tunable, defer it.
- **No silence-moment insertions.** Round-2 recommended three silence beats (post-contradiction, pre-rupture, pre-end-card); requires audio-mix code changes, defer.
- **No 3-tile end-card module** (AT RISK / HOLDING POWER / WATCH TOMORROW). Requires new compose function, defer.
- **No voice-and-sound A/B/C bakeoff.** Skip the audio-layer test protocol; voice is locked to v1.
- **No code changes to `compose_trailer.py`.** Pass-1 flag changes (no 9x16, no stings, no archetype labels) already shipped; nothing else touched.

**Acceptance for v2:** the trailer plays end-to-end at ~130 s, opens with the social-contradiction line ("In real life, they're family. In Doubland, their Doubles have to survive each other"), introduces each Pistsov double via the social-risk template, and closes with the habit hook ("Tomorrow at 6:30, the survivors explain themselves"). Same voice, same music, same visuals.

**What this buys us:** a v2 trailer that has the **right script** without the cost of new voice casting, new music commissioning, or new compose-pipeline engineering. The Round-2 audio/code recommendations remain in the doc as the v3 backlog.

---

### Round 3 milestone — automated narration generator + Supabase cache (DONE 2026-05-12)

**Scope upgrade from v2 plan:** rather than hand-editing one trailer's `script.json` and force-rendering (the original v2 plan above), the narration overhaul shipped as an **automated cohort-aware LLM generator with cross-render caching**. Every future cohort now gets Burnett 6-beat narration automatically. The v2 plan above is technically superseded; that's documented for posterity, not for execution.

**What shipped (4 files):**

| Layer | File | Change |
|---|---|---|
| Database | `supabase/migrations/20260511180000_video_narration_cache.sql` | New `double.video_narration_cache` table. Keyed by `(sim_code, scope, artifact_key, persona_id, day_number)`. `prompt_hash` drives cache invalidation (sha256 of system + user + model); `pinned=true` rows override invalidation for hand-edited copy. RLS enabled with no policies — service_role bypass only (anon/authenticated denied). |
| DB Reference | `supabase/db_reference.md` | New Video Trailer section documenting the cache for LLM-lookup tooling. |
| Cache module | `video/narration_cache.py` | `get_or_generate(sim_code, scope, artifact_key, ..., system_prompt, user_prompt, model, llm_caller)` — checks cache, returns on hash match or pinned, calls LLM and persists on miss. Smoke-tested: MISS → HIT → STALE (prompt-change regen) → PINNED override. All 4 paths verified against live DB. |
| Showrunner | `video/showrunner.py` | Removed hardcoded `_opener_cold_open_line` + monolithic `OPENER_STAKES_SYSTEM`. Added 6 new Tier-B system prompts (cold_open, format_lock, persona_narration, pressure_event, vote_dread, habit_hook). Added 6 cache-backed `_generate_*` helpers. Cast scenes now carry a `narration_line` field. `_opener_assemble_narrator_script` rewritten to weave the 6 beats with [PAUSE Ns] markers. `OPENER_NARRATION_BOUNDS` upper bumped 220 → 280. |

**Cache scope dimensions:**

| scope | dimensions | example artifact_keys |
|---|---|---|
| `sim` | `sim_code` | `cold_open`, `format_lock`, `pressure_event`, `vote_dread`, `habit_hook` |
| `persona` | `sim_code` + `persona_id` | `persona_narration` |
| `day` | `sim_code` + `day_number` | (reserved for day-overview trailer) |
| `day-persona` | `sim_code` + `persona_id` + `day_number` | (reserved for day-in-life trailer) |

The `day` and `day-persona` scopes are infrastructure-ready but not yet consumed; they unblock the day-overview and day-in-life trailer products without further schema work.

**LLM cost economics:**

| Scenario | LLM call count |
|---|---|
| First render of a new cohort | 11 calls (4× bio + 4× archetype + 4× trait_moment + 6× narration artifacts, paid once) |
| Re-render of same cohort, same prompts | 0 narration calls (full cache hit); bio/archetype/trait still re-call (those don't go through the cache yet) |
| Cohort identical except for one persona's profile | 1 narration regen for that persona; everything else cached |
| Iterating on a system prompt | All rows for that artifact key invalidate (prompt_hash mismatch); fresh LLM call until pinned |

**Verified working end-to-end against `20260506-5`:**
- 9 cache rows persisted: 5 sim-scope + 4 persona-scope (one per Pistsov double)
- `narrator_script` = 218 words, within `OPENER_NARRATION_BOUNDS=(60, 280)`
- `trailer_16x9.mp4` rendered at `data/20260506-5/opener&002/output/trailer_16x9.mp4` (1280×720, 130.0 s, 20 MB)

**Architectural implications for the rest of the trailer backlog:**

- **§TODO-U Series narrative template** (Round 1 Reality TV §3, subsection): no longer needs to be a hand-written template. The cohort-aware cold_open + format_lock + pressure_event generators ARE the template implementation — they take the cohort name and cast and produce franchise-consistent copy per cohort. §TODO-U could be downgraded to "lock the system prompts as the franchise spec" rather than "write narrative copy".
- **#9 Dynamic cycling end card**: the cycling third line (Living Drama / Strategic Alliances / Unexpected Bonds / Insidious Betrayals / Unscripted Life) could optionally also become an LLM-generated artifact (one new system prompt + one cache key per sim). Defer until end-card compose work happens.
- **#6 Grid-anchored cast intro**: now has per-persona `narration_line` already populated in `cast_scenes`. When #6 ships, the compose layer can use this directly — no new LLM call needed.
- **Day-overview trailer pipeline** (separate product): can reuse the same `narration_cache` infrastructure with the `day` scope. New system prompts for daily-recap narration plug in cleanly.

**What's still open (full execution order in next section):** §TODO-S logo splash, §TODO-T iconic flyover (visual asset commissions); #6 cast-intro restructure (compose function rewrite); #8 Phaser↔rendered fusion beat (new compose stage); #9 dynamic end-card module (new compose function); #10 two-tier Phaser capture system (foundational refactor). None of these are blocked by the narration work; the narration milestone is independent of all of them.
---

# Part III — Pipeline changelog (archived)
## v3.0 — Vertical pipeline rebuild on Remotion (match Anya's production) — 2026-06-17

**Direction change.** Anya's hand-edited cut (`video/opening-anya/DOUBLAND1.mov` — 1080×1920 vertical, ~77s) is the quality bar. **Decision (Ivan, 2026-06-17):** keep Python orchestration; **Remotion renders opener visuals**; **vertical-only**; **photo-real cut-outs** (not sketches). Full teardown and phase ledger: `20260617_vertical-trailer-automation.md`.

**Architecture — as built:**

```
persona_ranker → showrunner (+narration_cache) → tts (VO + timing map)
              → build_opener_remotion_props → render_opener_remotion (Remotion)
              → validate_trailer (9:16 + LUFS)
```

Opener no longer uses FFmpeg `compose_opener_trailer`, Phaser capture, or 16:9 output. Day modes unchanged.

The renderer reads a normalized props file (`script.json` + `narration_timing.json` + cast assets), insulated from showrunner schema drift.

**Exact pipeline changes — file by file:**

| File | Change | Phase |
|---|---|---|
| **`video/remotion/`** *(new)* | Code-driven 9:16 engine: `Root.tsx` (data-driven dims/duration via `calculateMetadata`), `OpenerTrailer.tsx` (lays beats as `<Sequence>`s, mixes narration + ducked music w/ tail fade), `beats/{ColdOpen,Concept,Cast,Stakes,EndCard}.tsx`, `components/KineticText.tsx`, `styles.ts`. | **1 — DONE** |
| **`video/build_remotion_props.py`** | Legacy adapter: reads opener `script.json` + `narration_timing.json` → coarse 5-beat props. Superseded for Anya match by Package A builder. | **1 — DONE** |
| **`video/build_anya_package_a_props.py`** *(new)* | Package A: reads locked `auto_match_v3_warm` narration timing + stages `opening-anya` assets + Pistsov cut-outs → 18-segment beat map → `props/pistsov_package_a.json`. Ignores stale `opener&004`. | **1c — DONE** |
| **`video/remotion/src/beats/AnyaBeats.tsx`** *(new)* | Package A visual beats: hook, concept, wordmark, world, season, cast (photo cut-outs), pressure, live, turn, end card — uses Anya PNGs + B-roll loops. | **1c — DONE** |
| **`generate_trailer.py`** | Opener branch: `render_opener_remotion` + Package A props (no FFmpeg dual render, no Phaser capture). Day modes unchanged. | **4 — DONE** |
| **`validate_trailer.py`** | Opener: `trailer_9x16.mp4` only (1080×1920, 65–95s) + integrated loudness (LUFS) check. | **4 — DONE** |
| **`video/render_opener_remotion.py`** *(new)* | Build props + `npx remotion render` → `output/trailer_9x16.mp4`. | **4 — DONE** |
| **`video/opener_beat_map.py`** *(new)* | Shared 18-beat map + Pistsov relationship graph layout. Used by Package A and generalized props builders. | **2.5 — DONE** |
| **`video/build_opener_remotion_props.py`** *(new)* | Generalized Package A props from any opener dir (18 segments). | **3 — DONE** |
| **`video/export_relationship_graph.py`** | Export cast diagram JSON for concept/turn beats. | **3 — DONE** |
| **`video/assets/scripts-prompts/generate_cutouts.py`** | Grey-backdrop cut-outs from character sheets; `--grok` for photo-real. | **3 — DONE** |
| **`video/assets/scripts-prompts/generate_group_photo.py`** | Cohort group photo via Grok Imagine. | **3 — DONE** |
| **`capture_static_assets.py`** | **Skipped for opener** (implemented in `generate_trailer.py` Step 4). Day modes unchanged. | **4 — DONE** |
| **`compose_trailer.py`** | Opener FFmpeg path **unused**; `compose_opener_trailer` retained for legacy/manual only. Day modes unchanged. | **4 — DONE** |
| **`showrunner.py`** | **DONE (narration lock):** v3 cues, minimal pauses, dropped "sometimes…" line. *Residual:* emit relationship pairs for dynamic diagram (optional; graph uses defaults today). | **narration — DONE** |
| **`tts.py`** | **DONE (narration lock 2026-06-17):** `OPENER_VOICE_PROFILE` — ElevenLabs **`eleven_v3`**, stability **0.60**, speed **1.5×**; cues reach the voice, stripped from `narration_timing.json` for beat-matching. Passed via `generate_trailer.py` for opener mode only (day modes keep `eleven_multilingual_v2`). Verified: ~**76.7s** (`video/voiceover/auto_match_v3_warm_x1.5/narration.mp3`). | **narration — DONE** |
| **`persona_ranker.py`, `narration_cache.py`** | Unchanged. | — |

**Locked narration (Ivan, 2026-06-17) — baked into auto-gen:**

| Setting | Value |
|---|---|
| Voice model | ElevenLabs **`eleven_v3`** (not `eleven_multilingual_v2`) |
| Tone / speed | **Warm** (stability 0.60) at **1.5×** — evolved from the approved `v3_warm_x1.2` experiment |
| Delivery cues | `[curious]` / `[warmly]` / `[excited]` in fixed opener blocks; sent to TTS, stripped from timing map |
| Script trim | **Drop** *"And sometimes… you see something about yourself you never noticed before."* (present in `narration_anya.json` but cut in Anya's final audio) |
| Pauses | Minimal — ~**2.75s** total baked silence (0.1–0.2s between beats) |
| Verified duration | **~76.7s** — reference render: `video/voiceover/auto_match_v3_warm_x1.5/narration.mp3` |

Cast portraits: **photo-real cut-outs** (not sketches) — per per-scene spec (2026-06-17).

**Reusable "style" layer** — built as Remotion components in `video/remotion/src/components/` (Phases 2 + 2.5): glitch type, matrix readout, AI-core ring, ink figures, relationship graph, gauges, live HUD, gold transition, color grade, wordmark animation, crossfades. Handover note = `video/remotion/README.md`.

**Per-cohort delta** (new cast, same village): run `generate_cutouts.py` (+ optional `generate_group_photo.py`), then `generate_trailer --mode opener`. Brand/village assets reused.

**Status:** Phases 1–4 **DONE**. One-command opener:

```bash
python -m video.generate_trailer base_family_sim opener --mode opener --top 4 --cohort-name "Pistsov family"
```

Output: `output/trailer_9x16.mp4` via Remotion (~81s incl. end-card hold).

**Residual quality gaps** (not blocking generation): continuous 0–15s hook montage, transition SFX, Supabase-driven relationship labels, full end-to-end smoke test. See `20260617_vertical-trailer-automation.md` §4.

**Supersedes (opener only):** FFmpeg `compose_opener_trailer` and 16:9 dual render.

---

## v2.4 — Concept-script rewrite ("Anya cut") — 2026-06-03

**Direction change.** The opener narration is being replaced wholesale with a producer-finalized concept script (worked out with the video team). It drops the Burnett "stakes / vote" framing in favor of a concept-first script that explains what a Double is, shows the season as the concrete example, and turns the question back on the viewer ("what would my Double do?"). Final locked script: `video/anya/narration_anya.json`.

**Locked decisions (2026-06-03):**
- **Snappy cast cards.** Each character's spoken line is one short trait (~2–3s). Cast cards compress to ~3s each (fast reality-TV cuts) instead of the ~12–15s per-persona blueprint below. Trailer runtime drops to ~60–70s.
- **Season + cast block fully AI-written.** The "This season: the {cohort} enters Survival Mode. Four {relation}. Four personalities. Four Doubles." framing **and** the four character one-liners are LLM-generated per cohort each render. Hand-edit override preserved via the narration cache.
- **Wordmark + CTA on the end card only.** The animated DOUBLAND wordmark and `doubland.ai` are visual-only at the close — not narrated. The script no longer carries a 6s wordmark gap or a spoken "Doubland.ai".
- **Season title retired.** "Who will stay alive" is dropped from the opener (no longer narrated or passed through).

**Pronunciation rule (locked 2026-06-03):** "Doubland" → **"Dub-land"** (Dublin's first syllable, keeps the brand's "-land" ending). Applied globally in `video/tts.py` `TTS_PRONUNCIATION_OVERRIDES`; scripts keep the normal "Doubland" spelling everywhere. Also locked: gradual head-in open (lead `[PAUSE]` + ellipses on the first line) and capitalized **"MY"** in the closing "what would MY Double do?".

**Script structure (fixed vs. AI):**

| Block | Source | Content |
|---|---|---|
| 1 — Hook + concept | **Fixed** (cohort-agnostic literal) | "What if…" ×3 → "An AI version of you… talking like you / reacting like you / making choices like you." → "In Doubland, you create an AI Double based on your personality… Every conversation. Every choice. Every relationship." *(the "sometimes… you never noticed before" line was dropped 2026-06-17 to match Anya's final cut)* |
| 2 — Season + cast | **AI-generated per cohort** | "This season: the {cohort} enters Survival Mode. Four {relation}. Four personalities. Four Doubles." + one short trait line per persona. |
| 3 — Promise + features + turn | **Fixed** (cohort-agnostic literal) | "See how people change under pressure… Watch live 24/7. Follow any Double. Replay every moment. These aren't just avatars… what would my Double do?" |

**Pipeline work (staged):**
1. **(this doc)** spec captured. ✓
2. **Narration generation** (`showrunner.py`): swapped the hardcoded concept-frame lines to Block 1 + Block 3 verbatim; retired the now-unused beats (`cold_open` / `pressure_event` / `vote_dread` / `social_hook`); added `_generate_season_framing`; repointed the persona-narration prompt to the short-trait style; dropped the season-title input; updated the length bounds. ✓
3. **Visuals** (`compose_trailer.py` + `validate_trailer.py` + `generate_trailer.py`): re-timed the front matter for the v2.4 structure (intro hook spans Block 1 → season-bridge → snappy cast → closing); simplified each cast card to a single ~3s clip (name + spoken trait, no bio/social-hook split); removed the retired cold-open stage; moved the DOUBLAND wordmark to just before the end card; lowered the post-render duration bound to 45–110s; made `--season-title` optional. ✓
4. **Validation render** of `base_family_sim` + review. ⬜

**Supersedes:** the v2.2 7-beat structure and the v2.3 concept-frame wrap lines (`OPENER_HOOK_LINE` / `OPENER_CONCEPT_INTRO_LINE` / `OPENER_ACCESS_REVEAL_LINE` / `OPENER_MAIN_CHARACTER_LINE`) and the §TODO-VO1 closing-VO item. Sections below are kept for history.

---