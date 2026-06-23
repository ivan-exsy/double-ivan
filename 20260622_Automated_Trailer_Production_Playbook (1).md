# Doubland Automated Trailer Production Playbook — Asset-Mapped Edition

**Purpose:** Define the production system developers should automate so every new vertical Doubland simulation trailer approaches Anya’s hand-edited reference in smoothness, visual richness, pacing, and perceived production value. This edition also maps the supplied production assets to specific trailer beats and defines which assets may be rendered directly, which must be rebuilt as dynamic components, and which are reference boards only.

**Duration policy:** Exact total runtime is **not a hard product requirement**. A few seconds difference from Anya’s hand cut is acceptable (e.g. **76.6s** reference vs **~83.6s** automated on a four-person sim). **Trailers for simulations with many Doubles are expected to run longer** — tiered cast layouts keep the *cast block* efficient (~15–20s), but total length may grow with cohort size. Section timings and validator bands below are **pacing guidance**, not pass/fail gates on total seconds.

**Reference files reviewed**

- `doubland_small.mp4` — hand-edited creative reference
- `trailer_9x16.mp4` — first automated trailer
- `20260617_vertical-trailer-automation.md` — current architecture, implementation status, and known gaps

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

| Measure | Hand-edited reference | Automated version | Meaning |
|---|---:|---:|---|
| Runtime | 76.6 sec | 83.6 sec | ~7 sec longer on auto-gen — **acceptable**; not a quality failure by itself |
| Average frame-change score | 0.073 | 0.025 | Reference changes about 2.9× more between sampled frames |
| Average optical-motion score | 0.963 | 0.385 | Reference contains about 2.5× more actual screen motion |
| Near-static sampled intervals | 16% | 57% | Automated trailer remains visually unchanged far more often |
| Meaningful visual-change events | ~30 | ~13 | Reference provides more than twice as many visual developments |
| Visual-change rate | ~23.5/min | ~9.3/min | Automated version feels substantially slower than its narration |
| Integrated loudness | -13.1 LUFS | -16.6 LUFS | Automated mix is about 3.5 dB quieter |
| Loudness range | 7.5 LU | 4.2 LU | Automated mix has less dramatic rise and fall |
| True peak | +0.3 dBTP | -3.1 dBTP | Reference is more aggressive but peaks too high; do not copy the clipping risk |

The numbers support the visual impression: the automated trailer is not merely less polished. It is **less active, less rhythmically varied, and less dynamically mixed**.

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

A typical four-person opener is often **~72–84 seconds**, but total length is **flexible**. Use this energy curve as **guidance** — not a strict cap. Larger casts may produce longer trailers (see Duration policy).

| Section | Typical duration | Energy purpose |
|---|---:|---|
| Hook | 0–14 sec | Curiosity; abstract, controlled buildup |
| Product concept | 14–23 sec | Fast clarity; explain what a Double is |
| World and relationships | 23–34 sec | Expand scale and show simulation life |
| Season premise | 34–41 sec | Establish stakes and current mode |
| Cast | 41–57 sec | Personality, contrast, and conflict potential |
| Pressure and transformation | 57–69 sec | Highest emotional and visual intensity |
| Reflective turn | 69–75 sec | Slow briefly; move from spectacle to self-reflection |
| End card | final 3.5–5 sec | One question, logo, URL |

The sections can move by several seconds depending on script length, but the end card should not occupy 10–14 seconds.

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
- semantic tags;
- cast size;
- available assets;
- relationships;
- season mode;
- target runtime;
- target style profile.

It should output independent visual beats and micro-beats.

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

Build a small transition grammar rather than a large collection of unrelated effects.

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

## P0 — Highest impact; fix the current trailer language

1. Decouple visual beats from narration segments.
2. Rebuild the hook as one continuous sequence.
3. Implement `type-then-hold`; remove persistent headline glitch.
4. Promote `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Talk.mp4` to a hero layer.
5. Tighten and redesign the end card (~3.5–5s hold — composition polish, not a total-runtime gate).
6. Add transition SFX and final mix normalization.
7. Add the split-layout concept/poster frame.
8. Export a poster still with every trailer.

**Expected result:** The next four-person trailer should feel materially smoother and richer without changing the entire pipeline.

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

**Goal:** Permit multiple visual beats per narration segment and visuals spanning several narration segments.

**Acceptance criteria**

- Hook segments 0–2 render as one sequence.
- Visual beat timestamps are stored independently of narration segment boundaries.
- Planner can schedule micro-beats from phrase timings.
- Renderer supports overlaps and anticipatory transitions.

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
- the URL appears before the end card or is too small to read;
- replay artwork is used as the final CTA;
- the end card lasts longer than five seconds;
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
