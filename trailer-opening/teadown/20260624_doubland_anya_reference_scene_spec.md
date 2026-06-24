# Doubland — Anya reference trailer visual specification

**Prepared:** 2026-06-24  \
**Analyzed source:** `DOUBLAND1.mov`  \
**Measured runtime:** 76.578 s  \
**Encoding:** 2160×3840 native 9:16, HEVC, variable frame cadence, AAC 44.1 kHz stereo  \
**Method:** reference-only pass; core analysis from compressed proxy, verified against master (see `20260624_doubland_master_verification_addendum.md`)

## Measurement notes

- Timecodes are measured against the **2160×3840 native master**; hard-cut boundaries are frame-aligned where detectable.
- Scale, crop and opacity values are visual estimates. Treat them as proportional rebuild targets inside the full 9:16 canvas, not proxy-side-margin metadata.
- Audio descriptions are classifications from the embedded final mix. Master/proxy audio align at **0 ms offset** with **0.998 normalized waveform correlation**.
- The first-frame poster is a **three decoded source-frame flash (~50 ms)** — a momentary pre-roll, not a readable hold.
- Master verification confirmed the original **65-sub-moment structure**; no structural retiming outside head (§0–§1) and tail (§18).

## Section-level map

| Section | Time | Function | Dominant handoff |
|---|---:|---|---|
| 0 · Poster | 0:00.000–0:00.050 | Three-frame concept poster flash | Hard removal to black |
| 1 · Hook — second chance | 0:00.050–0:04.200 | Question + AI core + human silhouettes | Black reset; WHAT IF readable ~0:00.133 |
| 2 · Hook — hard conversation | 0:04.200–0:08.600 | Conversation rehearsal UI | Upper-layer morph; lower figures persist |
| 3 · Hook — Double tease | 0:08.600–0:10.800 | Minimal question → brand wordmark | Text meaning becomes logo |
| 4 · Concept / poster | 0:10.800–0:19.467 | Definition + identity/decision demonstrations | Poster deconstructs into cards/tree |
| 5 · World — create Double | 0:19.467–0:24.033 | Village hero + personality UI | Logo match-carry; fade to black |
| 6 · World — watch live | 0:24.033–0:27.167 | Pixel world + four portrait cards | Hard cut with shared cyan UI language |
| 7 · Every conversation / choice / relationship | 0:27.167–0:31.767 | Three UI states in one continuous system | Card-to-card/state morphs |
| 8 · Season — Survival Mode | 0:31.767–0:41.433 | Premise, family, mode, count and selection | Location→warning→family UI→selected card |
| 9–12 · Cast | 0:41.433–0:52.533 | Four animated full-body portraits | Alternating character ↔ selection panel |
| 13 · Pressure — change | 0:52.533–0:57.000 | Radial morph to gauge; critical peak | Blur/circle match, then black reset |
| 14 · Pressure — relationships | 0:57.000–1:00.900 | Night world dashboard + game consequence | Center URL wipe dims map |
| 15 · Live / replay | 1:00.900–1:06.433 | Live day/night, follow, replay | Text persists across background swaps |
| 16 · Not just avatars | 1:06.433–1:08.167 | Identity-card row and proof tile | Card-row rebuild |
| 17 · Learn / change / surprise | 1:08.167–1:11.667 | Dashboard evidence cycles | Lower panel replacement under persistent card row |
| 18 · End card | 1:11.667–1:16.578 | Reflective scene → final question → URL | Hard callback then opacity takeover |

## Detailed sub-moment specification

### 0.1 · Poster / first frame

| Field | Specification |
|---|---|
| **Timecode** | `0:00.000 – 0:00.050` |
| **Duration feel** | Three decoded source-frame flash (~50 ms); pre-roll poster, **not** a readable in-motion card. |
| **Narration overlap** | No narration yet. |
| **Background** | Black field with a three-band concept composition inside the active 9:16 frame. |
| **Mid layer(s)** | Top: darkened family group with faint cyan scan/HUD treatment. Bottom: clean family group at full color. |
| **Foreground** | Large outlined blue DOUBLE wordmark across the upper group; centered white line AN AI VERSION OF YOU. |
| **Motion detail** | All elements are already composed on frame 0; no visible entrance before the cut. |
| **Handoff IN** | Start of file. |
| **Text on screen** | DOUBLE · AN AI VERSION OF YOU. Static for ~3 decoded frames (~50 ms). |
| **Audio** | Music/mix is already present at the head; no isolated SFX can be separated confidently in the flattened mix. |
| **Handoff OUT** | Abrupt removal to black at 0:00.050; no dissolve. |
| **Asset ID(s)** | Family group stills; DOUBLE wordmark; scan/HUD overlay. |
| **Mobile notes** | Native 9:16 master — the visible composition is the framing reference. Duration too short for intentional reading; treat as thumbnail flash only. |

### 1.1 · Hook — second chance

| Field | Specification |
|---|---|
| **Timecode** | `0:00.050 – 0:00.900` |
| **Duration feel** | ~0.85s; sparse opening after brief black reset. |
| **Narration overlap** | “What if…” |
| **Background** | Near-black field (brief black reset from poster through ~0:00.133). |
| **Mid layer(s)** | Very faint grain/particle noise only. |
| **Foreground** | WHAT IF… centered slightly above vertical middle — **becomes visibly readable at approximately 0:00.133**, not on the first post-poster frame. |
| **Motion detail** | Headline types/fades in after black reset, then holds perfectly still; no continuous pulse. |
| **Handoff IN** | Hard cut from poster flash to black; brief black gap before headline is readable. |
| **Text on screen** | WHAT IF… · white bold caps · quick type/fade-on, then static. |
| **Audio** | VO begins on the headline; low electronic bed continues. A short high-frequency digital tick is audible near the visual start (~0.22s in the mix). |
| **Handoff OUT** | AI ring begins to reveal above the headline; headline remains as the anchor. |
| **Asset ID(s)** | Unknown black field; text layer. |
| **Mobile notes** | Large central text sits within the middle 60% of the vertical frame; safe for mobile UI. |

### 1.2 · Hook — second chance

| Field | Specification |
|---|---|
| **Timecode** | `0:00.900 – 0:01.533` |
| **Duration feel** | ~0.63s; fast system reveal. |
| **Narration overlap** | “…you had a second chance…” |
| **Background** | Black. |
| **Mid layer(s)** | Circular AI core/ring fades up in upper-middle; left-side diagnostic copy begins: SCANNING… and partial PERSONALITY DETECTED. |
| **Foreground** | Subline types beneath ring: YOU HAD A SECOND CHANCE. |
| **Motion detail** | Ring scales roughly 94%→100% with ease-out; cyan/red arcs brighten; diagnostic text types line-by-line. |
| **Handoff IN** | WHAT IF headline clears as the ring takes over the same central axis. |
| **Text on screen** | YOU HAD A SECOND CHANCE · type-on; underscore cursor visible during typing only. |
| **Audio** | Soft digital reveal/scan hit lands around the ring appearance (~1.06s); VO remains foreground. |
| **Handoff OUT** | Ring and diagnostic stack remain; typed sentence settles and freezes. |
| **Asset ID(s)** | AI core/ring; diagnostic UI text. |
| **Mobile notes** | Ring stays above the text; no overlap with central caption. |

### 1.3 · Hook — second chance

| Field | Specification |
|---|---|
| **Timecode** | `0:01.533 – 0:02.333` |
| **Duration feel** | ~0.80s; readable hold with system build. |
| **Narration overlap** | “…a second chance…” |
| **Background** | Black. |
| **Mid layer(s)** | Diagnostic stack expands: SCANNING…, PERSONALITY DETECTED, MEMORIES DETECTED, BEHAVIOR MODEL CREATED; thin horizontal data scratches around ring. |
| **Foreground** | YOU HAD A SECOND CHANCE remains centered below ring. |
| **Motion detail** | Text is frozen after completion. Ring arcs rotate/flicker subtly; diagnostic lines continue typing. |
| **Handoff IN** | Continuation; no reset. |
| **Text on screen** | YOU HAD A SECOND CHANCE · static hold ≥0.7s. |
| **Audio** | Low synthetic pulse; small UI typing/tick accents embedded under narration. |
| **Handoff OUT** | Caption swaps to the next phrase while the ring remains. |
| **Asset ID(s)** | AI core/ring; diagnostic readout. |
| **Mobile notes** | System copy is intentionally small and atmospheric; primary sentence remains the legibility priority. |

### 1.4 · Hook — second chance

| Field | Specification |
|---|---|
| **Timecode** | `0:02.333 – 0:03.133` |
| **Duration feel** | ~0.80s; phrase completion plus human-image reveal. |
| **Narration overlap** | “…to make it right?” |
| **Background** | Black. |
| **Mid layer(s)** | Ring continues; diagnostic list reaches AI DOUBLE INITIALIZING…. A cyan-tinted video strip of four backlit silhouettes rises/fades into the lower third. |
| **Foreground** | TO MAKE IT RIGHT? replaces the prior sentence below the ring. |
| **Motion detail** | New sentence types quickly then holds. Silhouette strip opacity increases from ~0→70%; slight horizontal scan/glitch within the strip. |
| **Handoff IN** | Ring is the shared element from the previous phrase. |
| **Text on screen** | TO MAKE IT RIGHT? · white caps · type-on with underscore cursor; cursor disappears at completion. |
| **Audio** | A soft low whoosh/impact is visible in the onset map around 2.88s, aligned to the silhouettes becoming prominent. |
| **Handoff OUT** | All layers remain for a short full-composition hold. |
| **Asset ID(s)** | AI ring; silhouette video strip; diagnostic UI. |
| **Mobile notes** | Silhouettes occupy the bottom ~25% and do not compete with the question. |

### 1.5 · Hook — second chance

| Field | Specification |
|---|---|
| **Timecode** | `0:03.133 – 0:04.200` |
| **Duration feel** | ~1.07s; complete tableau, then controlled reset. |
| **Narration overlap** | End of “…right?”; brief breath before the next “What if.” |
| **Background** | Black. |
| **Mid layer(s)** | Full diagnostic ring and silhouette strip remain; cyan/red arcs shift brightness and minor scan noise runs through lower video. |
| **Foreground** | TO MAKE IT RIGHT? stays fixed. |
| **Motion detail** | No text motion after completion. Ring/strip motion is ambient only. Near 4.0s the ring and strip dim while WHAT IF… returns. |
| **Handoff IN** | Continuation. |
| **Text on screen** | TO MAKE IT RIGHT? holds; WHAT IF… reappears during the final ~0.2s as the next beat begins. |
| **Audio** | Music sustains; no new major impact until the next UI reveal. |
| **Handoff OUT** | Opacity handoff: ring/silhouettes fade down, WHAT IF… becomes the surviving element on black. |
| **Asset ID(s)** | Same as 1.4. |
| **Mobile notes** | Hold is long enough to read; next headline appears on the same center line to preserve continuity. |

### 2.1 · Hook — hard conversation

| Field | Specification |
|---|---|
| **Timecode** | `0:04.200 – 0:04.800` |
| **Duration feel** | ~0.60s; clean question reset. |
| **Narration overlap** | “What if you could…” |
| **Background** | Black. |
| **Mid layer(s)** | Previous ring is barely visible, then disappears. |
| **Foreground** | WHAT IF… centered. |
| **Motion detail** | Headline remains still; residual ring opacity falls to zero. |
| **Handoff IN** | Opacity carry from ring beat, not a full black interruption. |
| **Text on screen** | WHAT IF… · static. |
| **Audio** | A digital reveal onset begins around 4.38s, slightly before the new interface becomes clear (~1–2 frames lead). |
| **Handoff OUT** | Conversation UI grows in behind/below the headline. |
| **Asset ID(s)** | Black field; residual ring. |
| **Mobile notes** | Single line remains centered and uncluttered. |

### 2.2 · Hook — hard conversation

| Field | Specification |
|---|---|
| **Timecode** | `0:04.800 – 0:05.533` |
| **Duration feel** | ~0.73s; rapid interface assembly. |
| **Narration overlap** | “…you could practice…” |
| **Background** | Black. |
| **Mid layer(s)** | Top: three outlined chat bubbles and dotted/grid HUD marks. Bottom: framed wireframe man and woman facing each other with small speech bubbles and scan labels. |
| **Foreground** | YOU COULD PRACTICE types between top and bottom clusters. |
| **Motion detail** | Top bubbles scale/fade in; lower conversation panel rises from bottom and sharpens from blur. Caption types then freezes. |
| **Handoff IN** | WHAT IF clears while conversation imagery occupies the same central axis. |
| **Text on screen** | YOU COULD PRACTICE · white caps · quick type-on. |
| **Audio** | Digital UI reveal/typing accents cluster around 4.5–4.9s; VO remains centered in mix. |
| **Handoff OUT** | Headline changes while the same lower conversation panel stays. |
| **Asset ID(s)** | Talk/conversation wireframe panel; chat-bubble HUD. |
| **Mobile notes** | Main text is centered in the open negative space between top and bottom graphics. |

### 2.3 · Hook — hard conversation

| Field | Specification |
|---|---|
| **Timecode** | `0:05.533 – 0:06.533` |
| **Duration feel** | ~1.0s; phrase focus. |
| **Narration overlap** | “…that hard conversation…” |
| **Background** | Black. |
| **Mid layer(s)** | Top chat bubbles; lower facing figures and their speech bubbles remain. |
| **Foreground** | THAT HARD CONVERSATION replaces the prior line. |
| **Motion detail** | Text types in two lines and then holds; interface elements remain largely static except faint scan noise. |
| **Handoff IN** | Same composition; phrase swap only. |
| **Text on screen** | THAT HARD CONVERSATION · white caps · type-on with temporary underscore cursor. |
| **Audio** | Small UI pop/typing accents around 5.83–5.91s align with the new phrase. |
| **Handoff OUT** | Top layer transforms from generic chat bubbles into a relationship graph. |
| **Asset ID(s)** | Talk/conversation wireframe panel. |
| **Mobile notes** | Two-line caption remains above the lower figures and below the top UI. |

### 2.4 · Hook — hard conversation

| Field | Specification |
|---|---|
| **Timecode** | `0:06.533 – 0:07.467` |
| **Duration feel** | ~0.93s; information escalation. |
| **Narration overlap** | End of “…conversation…” |
| **Background** | Black. |
| **Mid layer(s)** | Top chat bubbles are replaced by a four-node relationship diamond labeled KATYA, GOSHA, IVAN, LUBA with TRUST / INFLUENCE / RIVALRY / ALLIANCE lines. Lower conversation panel persists. |
| **Foreground** | THAT HARD CONVERSATION remains centered and frozen. |
| **Motion detail** | Graph fades/scales in over ~250ms; cyan nodes glow once, then settle. Lower figures do not reset. |
| **Handoff IN** | Morph/replace in the upper third; lower human silhouettes are the shared anchor. |
| **Text on screen** | THAT HARD CONVERSATION · static hold. |
| **Audio** | A bright digital accent around 7.09s punctuates the graph becoming readable. |
| **Handoff OUT** | Caption swaps to BEFORE IT EVER HAPPENED? while graph and figures stay. |
| **Asset ID(s)** | Relationship graph; Talk/conversation wireframe panel. |
| **Mobile notes** | Dense graph is restricted to upper third; primary text stays clear. |

### 2.5 · Hook — hard conversation

| Field | Specification |
|---|---|
| **Timecode** | `0:07.467 – 0:08.600` |
| **Duration feel** | ~1.13s; final question and glitch release. |
| **Narration overlap** | “…before it ever happened?” |
| **Background** | Black. |
| **Mid layer(s)** | Relationship graph upper third; facing figures lower third; small interface specks. |
| **Foreground** | BEFORE IT EVER HAPPENED? centered. |
| **Motion detail** | Caption types and holds. Near 8.5s the composition breaks into brief RGB/glitch fragments and collapses to WHAT IF…. |
| **Handoff IN** | Continuous composition; only phrase changes. |
| **Text on screen** | BEFORE IT EVER HAPPENED? · type-on, then static ~0.6s. |
| **Audio** | Low whoosh/glitch accent around 8.06–8.68s leads the visual reset by approximately 0–50ms. |
| **Handoff OUT** | Glitch-collapse removes graph and figures; WHAT IF… remains on black. |
| **Asset ID(s)** | Relationship graph; wireframe figures; glitch overlay. |
| **Mobile notes** | Final question holds long enough before the glitch; no ongoing text animation after completion. |

### 3.1 · Hook — Double tease

| Field | Specification |
|---|---|
| **Timecode** | `0:08.600 – 0:09.400` |
| **Duration feel** | ~0.80s; stripped-back reset. |
| **Narration overlap** | “What if…” |
| **Background** | Black. |
| **Mid layer(s)** | A few RGB glitch flecks disappear near the top. |
| **Foreground** | WHAT IF… centered. |
| **Motion detail** | Headline appears with a brief glitch during entry only, then locks. |
| **Handoff IN** | Glitch-collapse from the hard-conversation layout. |
| **Text on screen** | WHAT IF… · white caps · quick glitch/type reveal, then static. |
| **Audio** | Short glitch/whoosh at ~8.68s; music bed dips slightly around the reset. |
| **Handoff OUT** | Headline clears as the answer line begins. |
| **Asset ID(s)** | Black field; glitch fragments. |
| **Mobile notes** | Strong central negative space; no competing layers. |

### 3.2 · Hook — Double tease

| Field | Specification |
|---|---|
| **Timecode** | `0:09.400 – 0:10.300` |
| **Duration feel** | ~0.90s; direct reveal line. |
| **Narration overlap** | “…you had a Double?” |
| **Background** | Black. |
| **Mid layer(s)** | No supporting UI. |
| **Foreground** | YOU HAD A DOUBLE centered. |
| **Motion detail** | Text types rapidly from left to right, then holds. |
| **Handoff IN** | WHAT IF is replaced on the same baseline/center axis. |
| **Text on screen** | YOU HAD A DOUBLE · white caps · type-on; reference on-screen copy has no visible question mark. |
| **Audio** | Digital text/reveal accents around 9.32–9.88s. |
| **Handoff OUT** | Blue DOUBLE wordmark appears in the same center zone and expands. |
| **Asset ID(s)** | Text only. |
| **Mobile notes** | Large one-line message is optimized for phone viewing. |

### 3.3 · Hook — Double tease

| Field | Specification |
|---|---|
| **Timecode** | `0:10.300 – 0:10.800` |
| **Duration feel** | ~0.50s; brand hit. |
| **Narration overlap** | VO finishes “Double.” |
| **Background** | Black. |
| **Mid layer(s)** | Faint scan/glitch streaks. |
| **Foreground** | Outlined electric-blue DOUBLE wordmark. |
| **Motion detail** | Wordmark flashes on small, scales to roughly 135–150%, and gains a cyan glow; a second offset echo briefly overlaps during the scale. |
| **Handoff IN** | The spoken word becomes the graphic wordmark; exact text match is the handoff. |
| **Text on screen** | DOUBLE · outlined blue caps · no type-on; scale/glitch hit. |
| **Audio** | Distinct logo hit around 10.08–10.53s; picture reaches maximum scale just after the onset. |
| **Handoff OUT** | The enlarged wordmark becomes the top band of the concept poster while family imagery fades in above/below it. |
| **Asset ID(s)** | DOUBLE wordmark. |
| **Mobile notes** | Wordmark remains centered and very large; safe from side crops. |

### 4.1 · Concept / poster

| Field | Specification |
|---|---|
| **Timecode** | `0:10.800 – 0:12.600` |
| **Duration feel** | ~1.8s; first sustained product-definition card. |
| **Narration overlap** | “An AI version of you…” |
| **Background** | Black behind a three-band poster layout. |
| **Mid layer(s)** | Top: dark family group with faint cyan scan corners and microcopy. Bottom: clean, brighter family group cutout. |
| **Foreground** | Large blue DOUBLE spans the top group; AN AI VERSION OF YOU centered between top and bottom bands. |
| **Motion detail** | Family bands fade/slide into place over ~300ms; wordmark settles and then stays still. Bottom family has a subtle scale-up/push. |
| **Handoff IN** | DOUBLE wordmark from 3.3 persists and becomes part of the poster rather than disappearing. |
| **Text on screen** | AN AI VERSION OF YOU · white caps · fast type-on, then static. |
| **Audio** | Logo/section impact around 10.79s, followed by light typing ticks. |
| **Handoff OUT** | Poster deconstructs into individual identity cards while the black field persists. |
| **Asset ID(s)** | Family group stills; DOUBLE wordmark; scan-frame overlay. |
| **Mobile notes** | Faces are large and centered; caption occupies the clear middle band. |

### 4.2 · Concept / poster

| Field | Specification |
|---|---|
| **Timecode** | `0:12.600 – 0:14.200` |
| **Duration feel** | ~1.6s; paired identity-card example. |
| **Narration overlap** | “…talking like you.” |
| **Background** | Black. |
| **Mid layer(s)** | KATYA AI DOUBLE card enters upper-left/center; IVAN AI DOUBLE card enters lower-right. Thin horizontal progress/match bars extend toward frame center with percentages. |
| **Foreground** | TALKING LIKE YOU centered between cards. |
| **Motion detail** | Cards scale/fade in from opposite directions. Progress bars fill once left→right, then stop. Portraits remain static after entry. |
| **Handoff IN** | Top/bottom family bands dissolve into the two profile cards; cyan frame language is shared. |
| **Text on screen** | TALKING LIKE YOU · white caps · type-on, then hold. Card microcopy includes names, AI DOUBLE, ONLINE and match percentages (**78% Katya, 64% Ivan** confirmed on master). |
| **Audio** | UI reveal accents around 12.8–13.3s; no continuous typing SFX after the caption settles. |
| **Handoff OUT** | Cards swap identities/positions without returning to black. |
| **Asset ID(s)** | Katya and Ivan identity cards; progress bars. |
| **Mobile notes** | Primary caption stays central; portrait cards avoid the exact center. |

### 4.3 · Concept / poster

| Field | Specification |
|---|---|
| **Timecode** | `0:14.200 – 0:15.900` |
| **Duration feel** | ~1.7s; second paired identity-card example. |
| **Narration overlap** | “Reacting like you.” |
| **Background** | Black. |
| **Mid layer(s)** | LUBA/LYUBA AI DOUBLE card upper area and GOSHA card lower area; horizontal response/match bars. |
| **Foreground** | REACTING LIKE YOU centered. |
| **Motion detail** | Prior cards crossfade/slide out as new cards replace them; bars animate once, then freeze. |
| **Handoff IN** | Matched card-to-card swap with the same cyan frame geometry. |
| **Text on screen** | REACTING LIKE YOU · white caps · type-on; underscore cursor visible only during entry. |
| **Audio** | Digital card swap/reveal accents around 14.25–14.93s. |
| **Handoff OUT** | Cards and bars clear as a decision tree grows in the upper third. |
| **Asset ID(s)** | Lyuba and Gosha identity cards; progress bars. |
| **Mobile notes** | Caption remains readable in the open middle band. |

### 4.4 · Concept / poster

| Field | Specification |
|---|---|
| **Timecode** | `0:15.900 – 0:18.500` |
| **Duration feel** | ~2.6s; choice-system demonstration. |
| **Narration overlap** | “Making choices like you.” |
| **Background** | Black. |
| **Mid layer(s)** | Upper third: branching decision diagram labeled DECISION ?, CHOICE A / CHOICE B and multiple OUTCOME boxes. Lower third: family group returns with faint scan-frame corners. |
| **Foreground** | MAKING CHOICES LIKE YOU centered. |
| **Motion detail** | Caption types; decision tree draws downward node-by-node and then freezes. Family group fades in and holds. |
| **Handoff IN** | Cyan card lines from the previous beat reorganize into the decision-tree geometry. |
| **Text on screen** | MAKING CHOICES LIKE YOU · white caps · type-on, then ~1.4s static hold. |
| **Audio** | UI branching accents around 16.12–16.43s; music continues to build. |
| **Handoff OUT** | Tree/family fade to black while a small DOUBLAND location-pin logo appears. |
| **Asset ID(s)** | Decision tree; family group; scan frame. |
| **Mobile notes** | Decision diagram stays above the caption; family faces remain in lower safe area. |

### 4.5 · Concept / poster

| Field | Specification |
|---|---|
| **Timecode** | `0:18.500 – 0:19.467` |
| **Duration feel** | ~0.97s; brand/world bridge. |
| **Narration overlap** | Brief pause before “In Doubland…” |
| **Background** | Black. |
| **Mid layer(s)** | Faint digital specks. |
| **Foreground** | DOUBLAND location-pin wordmark with SIMULATION ACTIVE underneath, centered. |
| **Motion detail** | Logo flickers/scans in and holds; slight cyan glow only. |
| **Handoff IN** | Decision tree collapses into the location-pin/brand symbol at the same center axis. |
| **Text on screen** | DOUBLAND · SIMULATION ACTIVE. |
| **Audio** | Short digital resolve/transition swell leads the world cut. |
| **Handoff OUT** | Hard cut from black logo card to bright village aerial, with the same logo retained as an overlay. |
| **Asset ID(s)** | DOUBLAND simulation-active logo. |
| **Mobile notes** | Small but centered; use as a half-second bridge, not a long title card. |

### 5.1 · World — create Double

| Field | Specification |
|---|---|
| **Timecode** | `0:19.467 – 0:20.100` |
| **Duration feel** | ~0.63s; immediate world reveal. |
| **Narration overlap** | “In Doubland…” |
| **Background** | Warm, realistic/3D aerial of a Tudor-style village at golden hour; camera drifts slowly forward/down. |
| **Mid layer(s)** | DOUBLAND SIMULATION ACTIVE logo centered at ~45% frame height. |
| **Foreground** | No additional foreground text yet. |
| **Motion detail** | Video is full opacity and prominent; logo holds with faint glow. |
| **Handoff IN** | Hard cut timed to the start of the product sentence; logo match-carries from 4.5. |
| **Text on screen** | DOUBLAND · SIMULATION ACTIVE. |
| **Audio** | Low transition impact around 19.47s; music opens/brights with the visual. |
| **Handoff OUT** | Logo fades as explanatory sentence begins. |
| **Asset ID(s)** | Village aerial; DOUBLAND logo. |
| **Mobile notes** | Full-frame vertical crop keeps central road and houses visible. |

### 5.2 · World — create Double

| Field | Specification |
|---|---|
| **Timecode** | `0:20.100 – 0:21.400` |
| **Duration feel** | ~1.3s; clean explanatory line over hero B-roll. |
| **Narration overlap** | “…you create an AI Double…” |
| **Background** | Village aerial continues at full brightness with slow push/drift. |
| **Mid layer(s)** | None at first; subtle dark gradient behind text only. |
| **Foreground** | YOU CREATE AN AI DOUBLE centered around mid-frame. |
| **Motion detail** | Caption types and then freezes; background continues moving independently. |
| **Handoff IN** | Logo dissolves; moving village remains continuous. |
| **Text on screen** | YOU CREATE AN AI DOUBLE · white caps · type-on, hold ~0.7s. |
| **Audio** | Light typing/UI ticks around 20.37–20.94s. |
| **Handoff OUT** | Large personality-analysis UI fades in over the same village shot. |
| **Asset ID(s)** | Village aerial. |
| **Mobile notes** | Caption sits over a lower-contrast roof/road area; maintain text shadow/gradient. |

### 5.3 · World — create Double

| Field | Specification |
|---|---|
| **Timecode** | `0:21.400 – 0:23.467` |
| **Duration feel** | ~2.07s; layered product UI demonstration. |
| **Narration overlap** | “…based on your personality.” |
| **Background** | Village aerial continues but is darkened ~25–35% to support overlays. |
| **Mid layer(s)** | Upper: PERSONALITY ANALYSIS panel with silhouette and traits SOCIAL 92%, STRATEGIC 67%, LOYAL 78%, CREATIVE 85%, plus AI DOUBLE GENERATION 100%. Lower: circular CREATE YOUR DOUBLE / INITIALIZING… hub with radial category tabs. |
| **Foreground** | BASED ON YOUR PERSONALITY centered between panels. |
| **Motion detail** | Upper panel scales/fades in first; lower circular hub expands/rotates slightly; text types and holds. All UI motion settles before exit. |
| **Handoff IN** | UI grows from the center where the prior caption/logo sat; moving village is the continuous base. |
| **Text on screen** | BASED ON YOUR PERSONALITY · white caps · type-on, then static. |
| **Audio** | A pronounced digital UI reveal around 21.78s; several quiet ticks as the generation meter completes. |
| **Handoff OUT** | Overlays and village fade down together, leaving caption briefly on black before clearing. |
| **Asset ID(s)** | Village aerial; personality-analysis panel; Create Your Double radial HUD. |
| **Mobile notes** | Panels fill upper and lower zones, leaving a central caption channel; avoid shrinking the source video beneath them. |

### 5.4 · World — create Double

| Field | Specification |
|---|---|
| **Timecode** | `0:23.467 – 0:24.033` |
| **Duration feel** | ~0.57s; deliberate black punctuation. |
| **Narration overlap** | Narration breath between sentences. |
| **Background** | Black. |
| **Mid layer(s)** | None; the prior UI is gone. |
| **Foreground** | BASED ON YOUR PERSONALITY lingers briefly, then fades. |
| **Motion detail** | No movement after the fade; this is a true reset. |
| **Handoff IN** | Global fade from the layered village composition. |
| **Text on screen** | BASED ON YOUR PERSONALITY · final hold then opacity-out. |
| **Audio** | Music carries; no strong new SFX until the next hard cut. |
| **Handoff OUT** | Hard cut to pixel-world map at 24.033s. |
| **Asset ID(s)** | Text only. |
| **Mobile notes** | Brief pause prevents the next bright map from feeling crowded. |

### 6.1 · World — watch live

| Field | Specification |
|---|---|
| **Timecode** | `0:24.033 – 0:25.400` |
| **Duration feel** | ~1.37s; bright gameplay reveal. |
| **Narration overlap** | “Then you watch it live…” |
| **Background** | Full-frame top-down pixel-art village map; tiny avatars/NPCs move along paths. |
| **Mid layer(s)** | No heavy HUD; map itself is the hero. |
| **Foreground** | THEN YOU WATCH IT LIVE centered. |
| **Motion detail** | Hard cut, then caption types and stops. Background has continuous small character movement; **no artificial camera zoom** visible in the master. |
| **Handoff IN** | Hard cut from black, marked by a low digital impact. |
| **Text on screen** | THEN YOU WATCH IT LIVE · white caps · type-on, hold. |
| **Audio** | Strong low-frequency hit around 24.22s, ~0–150ms after picture cut; light typing ticks follow. |
| **Handoff OUT** | Caption changes and portrait cards begin entering around the map. |
| **Asset ID(s)** | Pixel-art village/map. |
| **Mobile notes** | Caption remains central; moving sprites are small enough not to harm readability. |

### 6.2 · World — watch live

| Field | Specification |
|---|---|
| **Timecode** | `0:25.400 – 0:27.167` |
| **Duration feel** | ~1.77s; shared-world proof. |
| **Narration overlap** | “…in a world with other Doubles.” |
| **Background** | Pixel map continues. |
| **Mid layer(s)** | Four AI DOUBLE portrait cards pop in around the central open area: Lyuba upper-left, Ivan upper-right, Gosha lower-left, Katya lower-right; each has cyan frame and ONLINE status. |
| **Foreground** | IN A WORLD WITH OTHER DOUBLES centered in two lines. |
| **Motion detail** | Caption types. Cards enter sequentially with ~150–250ms stagger, scale 90%→100%, then remain fixed while sprites continue moving behind. |
| **Handoff IN** | Same map; previous caption swaps, no black reset. |
| **Text on screen** | IN A WORLD WITH OTHER DOUBLES · white caps · type-on, then short hold. |
| **Audio** | UI pops/onsets around 25.06, 26.05–26.72s track card appearances. |
| **Handoff OUT** | Hard cut at 27.167s; portrait-card cyan visual language carries into the conversation UI. |
| **Asset ID(s)** | Pixel map; four identity cards. |
| **Mobile notes** | Cards avoid the central caption and remain inside the active vertical safe zone. |

### 7.1 · World — every conversation

| Field | Specification |
|---|---|
| **Timecode** | `0:27.167 – 0:28.633` |
| **Duration feel** | ~1.47s; conversation state. |
| **Narration overlap** | “Every conversation.” |
| **Background** | Black. |
| **Mid layer(s)** | Large wireframe person in profile on left; oversized outlined speech bubbles behind/right. Lower-center card: LIVE CONVERSATION · TOPIC: ALLIANCE with a warm inset scene and chat dots. |
| **Foreground** | EVERY CONVERSATION centered above the card. |
| **Motion detail** | Hard cut. Profile and bubbles scale/fade in; inset conversation card rises; headline types and freezes. |
| **Handoff IN** | Cut from pixel world; cyan UI frame style is the connecting motif. |
| **Text on screen** | EVERY CONVERSATION · white caps · type-on, hold. |
| **Audio** | Cut/reveal impact around 27.14–27.55s. |
| **Handoff OUT** | The profile rotates/reframes to the opposite side while the lower card changes into a decision menu. |
| **Asset ID(s)** | Wireframe profile; speech bubbles; live-conversation card. |
| **Mobile notes** | Headline remains centered; warm inset is large enough to read as a scene, not a tiny thumbnail. |

### 7.2 · World — every choice

| Field | Specification |
|---|---|
| **Timecode** | `0:28.633 – 0:30.000` |
| **Duration feel** | ~1.37s; choice state. |
| **Narration overlap** | “Every choice.” |
| **Background** | Black. |
| **Mid layer(s)** | Wireframe head profile now dominates center/right. Lower decision panel reads DECISION AVAILABLE with options Support Luba / or / Support Ivan. Background speech bubbles remain faint. |
| **Foreground** | EVERY CHOICE centered. |
| **Motion detail** | Previous profile/card slide laterally and are replaced without black. Decision panel grows upward; headline types then holds. |
| **Handoff IN** | Motivated UI-state morph: conversation card becomes decision card. |
| **Text on screen** | EVERY CHOICE · white caps · type-on, hold. |
| **Audio** | Heavy UI change onset around 28.65–29.08s; sound behaves like a low digital thump plus click. |
| **Handoff OUT** | Decision panel collapses; multiple figures and relationship graph enter. |
| **Asset ID(s)** | Wireframe head; decision menu. |
| **Mobile notes** | Decision labels are readable in the central lower half; keep choice buttons at high opacity. |

### 7.3 · World — every relationship

| Field | Specification |
|---|---|
| **Timecode** | `0:30.000 – 0:31.767` |
| **Duration feel** | ~1.77s; social consequence state. |
| **Narration overlap** | “Every relationship.” |
| **Background** | Black. |
| **Mid layer(s)** | Multiple wireframe people overlap left/right; cyan relationship network card in lower center with named nodes; notification box: RELATIONSHIP UPDATED +12 TRUST. Speech bubbles remain high in frame. |
| **Foreground** | EVERY RELATIONSHIP centered. |
| **Motion detail** | Elements slide/crossfade from the choice layout. Network lines draw on; +12 TRUST box pops once and holds. |
| **Handoff IN** | Decision graph expands into a people/relationship graph; same cyan line system. |
| **Text on screen** | EVERY RELATIONSHIP · white caps · type-on, then static. |
| **Audio** | Cluster of small UI accents around 30.87–31.70s. |
| **Handoff OUT** | Hard cut to realistic rowhouse street at 31.767s. |
| **Asset ID(s)** | Wireframe figures; relationship graph; trust update badge. |
| **Mobile notes** | Dense UI is vertically stacked; headline stays isolated above the graph. |

### 8.1 · Season — Survival Mode

| Field | Specification |
|---|---|
| **Timecode** | `0:31.767 – 0:33.000` |
| **Duration feel** | ~1.23s; narrative reset and location establish. |
| **Narration overlap** | “This season…” |
| **Background** | Realistic/3D twilight rowhouse lane, full frame; gentle forward camera move. |
| **Mid layer(s)** | Subtle dark gradient behind text. |
| **Foreground** | THIS SEASON centered lower-middle. |
| **Motion detail** | Hard cut; text types quickly then holds. Camera motion remains slow and independent. |
| **Handoff IN** | Hard cut marks shift from product explanation to show premise. |
| **Text on screen** | THIS SEASON · white caps · type-on, hold. |
| **Audio** | Low cinematic hit at the cut; music becomes more dramatic. |
| **Handoff OUT** | Family group rises from bottom as new text types. |
| **Asset ID(s)** | Twilight rowhouse video. |
| **Mobile notes** | Text is over the path/sky negative space, away from bright windows. |

### 8.2 · Season — Survival Mode

| Field | Specification |
|---|---|
| **Timecode** | `0:33.000 – 0:34.000` |
| **Duration feel** | ~1.0s; cast introduction. |
| **Narration overlap** | “…the Pistsov family enters…” |
| **Background** | Rowhouse lane continues. |
| **Mid layer(s)** | Family group cutout rises into bottom third inside a faint scan-frame; background darkens behind them. |
| **Foreground** | THE PISTSOFF FAMILY ENTERS centered above family. |
| **Motion detail** | Family scales 92%→100% and slides up with ease-out. Text types and stops. |
| **Handoff IN** | The location remains continuous; family is added as a new foreground layer. |
| **Text on screen** | THE PISTSOFF FAMILY ENTERS · white caps · type-on. Note reference spelling on screen: PISTSOFF. |
| **Audio** | Subtle rise/whoosh under the family reveal. |
| **Handoff OUT** | Background dissolves to a warmer front-porch shot while family/text remain. |
| **Asset ID(s)** | Family group; rowhouse video; scan frame. |
| **Mobile notes** | Four faces occupy bottom third at useful size; text remains just above heads. |

### 8.3 · Season — Survival Mode

| Field | Specification |
|---|---|
| **Timecode** | `0:34.000 – 0:35.033` |
| **Duration feel** | ~1.03s; warm-to-danger contrast setup. |
| **Narration overlap** | End of “…enters Survival Mode.” |
| **Background** | Warm porch/front-door video replaces the lane; string lights and lamps glow. |
| **Mid layer(s)** | Family group remains bottom, then starts dimming. |
| **Foreground** | THE PISTSOFF FAMILY ENTERS holds. |
| **Motion detail** | Background cross-dissolve/match transition; family layer stays fixed, creating continuity. Near exit, all layers dim. |
| **Handoff IN** | Background-only replacement; foreground family is the bridge. |
| **Text on screen** | THE PISTSOFF FAMILY ENTERS · static hold. |
| **Audio** | Music tension rises; no text movement. |
| **Handoff OUT** | Hard cut/dip to black and copper warning graphic. |
| **Asset ID(s)** | Warm porch video; family group. |
| **Mobile notes** | Warm background makes the impending warning-card contrast stronger. |

### 8.4 · Season — Survival Mode

| Field | Specification |
|---|---|
| **Timecode** | `0:35.033 – 0:36.833` |
| **Duration feel** | ~1.8s; warning/title punctuation. |
| **Narration overlap** | “Survival Mode.” |
| **Background** | Black. |
| **Mid layer(s)** | Thin copper/red horizontal scan lines and a triangular warning icon. |
| **Foreground** | SURVIVAL MODE with INITIATED beneath, centered. |
| **Motion detail** | Title flickers/scans in, briefly distorts, then holds with a faint red glow; no ongoing pulse after settle. |
| **Handoff IN** | Hard cut from the warm family scene. |
| **Text on screen** | SURVIVAL MODE · INITIATED · copper/red caps. |
| **Audio** | Strong low-frequency impact at ~35.03s, picture-synchronous; short glitch tail. |
| **Handoff OUT** | Title fades to black; family group appears at bottom with the next count. |
| **Asset ID(s)** | Survival warning/title graphic. |
| **Mobile notes** | High contrast; small INITIATED line should remain at least ~24 px at 1080×1920 equivalent. |

### 8.5 · Season — Survival Mode

| Field | Specification |
|---|---|
| **Timecode** | `0:36.833 – 0:38.300` |
| **Duration feel** | ~1.47s; count one. |
| **Narration overlap** | “Four family members.” |
| **Background** | Black. |
| **Mid layer(s)** | Family group/candid loop fills bottom ~35%; subjects subtly smile/shift. |
| **Foreground** | FOUR FAMILY MEMBERS centered in upper-middle. |
| **Motion detail** | Family fades/slides up; caption types and freezes. |
| **Handoff IN** | Warning title clears; black background and centered text axis remain. |
| **Text on screen** | FOUR FAMILY MEMBERS · white caps · type-on, hold. |
| **Audio** | Soft reveal around 36.83s; VO lands directly on text. |
| **Handoff OUT** | Trait cards start populating across upper third; sentence swaps. |
| **Asset ID(s)** | Family group/candid clip. |
| **Mobile notes** | Faces are large and remain clear; upper half reserved for the count. |

### 8.6 · Season — Survival Mode

| Field | Specification |
|---|---|
| **Timecode** | `0:38.300 – 0:39.900` |
| **Duration feel** | ~1.6s; count two and trait differentiation. |
| **Narration overlap** | “Four personalities.” |
| **Background** | Black with family group continuing along bottom. |
| **Mid layer(s)** | Four small vertical trait cards populate top left→right: Gosha, Ivan, Katya, Luba/Lyuba, each with three trait labels/icons. |
| **Foreground** | FOUR PERSONALITIES centered between top cards and family. |
| **Motion detail** | Cards enter sequentially with short stagger; caption types once and holds. Family continues a subtle candid-motion loop. |
| **Handoff IN** | Family persists; new cards build above it. |
| **Text on screen** | FOUR PERSONALITIES · white caps · type-on. |
| **Audio** | Light card-pop accents during the stagger; music maintains momentum. |
| **Handoff OUT** | Larger ACTIVE DOUBLES identity-card strip appears in the middle and cursor enters. |
| **Asset ID(s)** | Four trait cards; family group. |
| **Mobile notes** | Three-tier layout remains readable because the center text has a dedicated gap. |

### 8.7 · Season — Survival Mode

| Field | Specification |
|---|---|
| **Timecode** | `0:39.900 – 0:41.433` |
| **Duration feel** | ~1.53s; count three shown visually. |
| **Narration overlap** | “Four Doubles.” |
| **Background** | Black; family group stays at bottom. |
| **Mid layer(s)** | Top trait cards remain. Middle: larger four-card ACTIVE DOUBLES panel with Katya, Gosha, Luba/Lyuba, Ivan; white hand cursor moves onto a card and clicks. |
| **Foreground** | FOUR PERSONALITIES remains briefly, then clears; **no separate FOUR DOUBLES headline is visibly readable** — the four-card selection UI communicates that line. |
| **Motion detail** | ACTIVE DOUBLES panel scales in and sharpens; cursor moves diagonally and performs a single click. At 41.43s the selected card expands via radial/zoom blur. |
| **Handoff IN** | The trait-card row is reinterpreted as a selectable cast interface. |
| **Text on screen** | No new locked headline beyond the lingering FOUR PERSONALITIES; “Four Doubles” is communicated by the four-card UI. |
| **Audio** | Single click/select accent near the expansion; mixed track onset is close to 41.43s. |
| **Handoff OUT** | Selected Gosha card zooms to full-frame character scene using blur/scale, not a simple crossfade. |
| **Asset ID(s)** | Trait cards; ACTIVE DOUBLES panel; cursor; family group. |
| **Mobile notes** | Four portrait cards are large enough to distinguish; cursor clearly identifies the next subject. |

### 9.1 · Cast — Gosha

| Field | Specification |
|---|---|
| **Timecode** | `0:41.433 – 0:42.100` |
| **Duration feel** | ~0.67s; fast identity reveal. |
| **Narration overlap** | “Gosha thinks three moves ahead.” |
| **Background** | Neutral light-gray studio background. |
| **Mid layer(s)** | Full-body stylized Gosha, centered; residual radial blur at entry. |
| **Foreground** | GOSHA THINKS THREE MOVES AHEAD types across torso/waist in two lines. |
| **Motion detail** | Selected card zoom-blurs into the full-body render. Blur resolves in ~200–300ms; text types immediately. |
| **Handoff IN** | Direct expansion of the selected card from the prior ACTIVE DOUBLES panel. |
| **Text on screen** | GOSHA THINKS THREE MOVES AHEAD · white caps · type-on with underscore cursor. |
| **Audio** | Whoosh/selection hit at the zoom; VO begins as blur resolves. |
| **Handoff OUT** | Text settles; character performs subtle face/head animation. |
| **Asset ID(s)** | Gosha full-body animated render. |
| **Mobile notes** | Full body uses almost entire height; caption crosses torso but remains high contrast. |

### 9.2 · Cast — Gosha

| Field | Specification |
|---|---|
| **Timecode** | `0:42.100 – 0:43.200` |
| **Duration feel** | ~1.1s; character hold. |
| **Narration overlap** | Completion of Gosha line. |
| **Background** | Light gray studio background. |
| **Mid layer(s)** | Gosha full body; no UI. |
| **Foreground** | GOSHA THINKS THREE MOVES AHEAD remains fixed. |
| **Motion detail** | Character blinks/tilts head and shifts expression slightly; caption does not move or pulse. |
| **Handoff IN** | Continuation. |
| **Text on screen** | GOSHA THINKS THREE MOVES AHEAD · static hold. |
| **Audio** | Music/VO carry; no major new SFX until exit. |
| **Handoff OUT** | Hard cut back to ACTIVE DOUBLES panel. |
| **Asset ID(s)** | Gosha full-body animation. |
| **Mobile notes** | Character remains centered and fully visible from head to shoes. |

### 10.1 · Cast — Ivan selection

| Field | Specification |
|---|---|
| **Timecode** | `0:43.200 – 0:43.900` |
| **Duration feel** | ~0.70s; interface interstitial. |
| **Narration overlap** | Short gap/lead into “Ivan…” |
| **Background** | Black. |
| **Mid layer(s)** | ACTIVE DOUBLES four-card strip centered upper-middle; white hand cursor moves toward Ivan card. |
| **Foreground** | Early characters of IVAN REFUSES… may begin during the zoom-blur at the end, but no stable line is held on the panel. |
| **Motion detail** | Hard cut from gray to black panel. Cursor travels and clicks once; panel begins radial expansion. |
| **Handoff IN** | Return to the exact selection UI seen before Gosha. |
| **Text on screen** | No stable foreground headline. |
| **Audio** | Click/digital selection accents cluster around 43.75–43.90s. |
| **Handoff OUT** | Ivan card expands through gray radial blur into full body. |
| **Asset ID(s)** | ACTIVE DOUBLES panel; cursor. |
| **Mobile notes** | Interstitial is brief but long enough to show that the viewer is selecting the next Double. |

### 10.2 · Cast — Ivan

| Field | Specification |
|---|---|
| **Timecode** | `0:43.900 – 0:45.733` |
| **Duration feel** | ~1.83s; full character beat. |
| **Narration overlap** | “Ivan refuses to lose.” |
| **Background** | Neutral light-gray studio background. |
| **Mid layer(s)** | Full-body stylized Ivan, centered. |
| **Foreground** | IVAN REFUSES TO LOSE across torso/waist. |
| **Motion detail** | Blur resolves; caption types and locks. Ivan looks down/bows slightly, then raises head and smiles; no camera move. |
| **Handoff IN** | Zoom-blur from Ivan card. |
| **Text on screen** | IVAN REFUSES TO LOSE · white caps · type-on, static after completion. |
| **Audio** | Whoosh/impact at reveal; small motion accents in mix under character animation. |
| **Handoff OUT** | Hard cut back to card strip at 45.733s. |
| **Asset ID(s)** | Ivan full-body animated render. |
| **Mobile notes** | Full body stays centered; caption does not cover face. |

### 11.1 · Cast — Katya selection

| Field | Specification |
|---|---|
| **Timecode** | `0:45.733 – 0:46.300` |
| **Duration feel** | ~0.57s; interface interstitial. |
| **Narration overlap** | Lead into “Katya…” |
| **Background** | Black. |
| **Mid layer(s)** | ACTIVE DOUBLES strip; cursor shifts to Katya card. |
| **Foreground** | No stable headline. |
| **Motion detail** | Hard cut; cursor click; quick radial blur begins. |
| **Handoff IN** | Repeat of the same selection grammar. |
| **Text on screen** | — |
| **Audio** | Digital click/selection accents around 45.96–46.23s. |
| **Handoff OUT** | Katya card expands to full-frame gray studio. |
| **Asset ID(s)** | ACTIVE DOUBLES panel; cursor. |
| **Mobile notes** | Consistent panel placement trains the viewer to understand the pattern. |

### 11.2 · Cast — Katya

| Field | Specification |
|---|---|
| **Timecode** | `0:46.300 – 0:48.333` |
| **Duration feel** | ~2.03s; animated character beat. |
| **Narration overlap** | “Katya knows how to move people.” |
| **Background** | Neutral light-gray studio background. |
| **Mid layer(s)** | Full-body stylized Katya, centered. |
| **Foreground** | KATYA KNOWS HOW TO MOVE PEOPLE in two lines. |
| **Motion detail** | Blur resolves; text types and stops. Katya moves from neutral to smiling and raises one hand in a wave. |
| **Handoff IN** | Zoom-blur from selected card. |
| **Text on screen** | KATYA KNOWS HOW TO MOVE PEOPLE · white caps · type-on, static after completion. |
| **Audio** | Whoosh/selection hit at reveal; VO aligns to the text. |
| **Handoff OUT** | Hard cut to selection panel at 48.333s. |
| **Asset ID(s)** | Katya full-body animated render. |
| **Mobile notes** | Raised hand remains inside top safe area; caption sits across torso. |

### 12.1 · Cast — Lyuba selection

| Field | Specification |
|---|---|
| **Timecode** | `0:48.333 – 0:49.133` |
| **Duration feel** | ~0.80s; final interface interstitial. |
| **Narration overlap** | Lead into “Lyuba…” |
| **Background** | Black. |
| **Mid layer(s)** | ACTIVE DOUBLES strip; cursor travels to Lyuba/Luba card and clicks. |
| **Foreground** | LYU… begins during the final blur in some frames; no completed line on panel. |
| **Motion detail** | Hard cut; cursor click; panel expands with radial blur. |
| **Handoff IN** | Repeat selection grammar. |
| **Text on screen** | — |
| **Audio** | Click/transition accents cluster around 48.46–49.15s. |
| **Handoff OUT** | Full-body Lyuba resolves on gray. |
| **Asset ID(s)** | ACTIVE DOUBLES panel; cursor. |
| **Mobile notes** | Cursor clearly indicates the selected portrait before expansion. |

### 12.2 · Cast — Lyuba: calm

| Field | Specification |
|---|---|
| **Timecode** | `0:49.133 – 0:50.200` |
| **Duration feel** | ~1.07s; first clause. |
| **Narration overlap** | “Lyuba stays calm…” |
| **Background** | Neutral light-gray studio background. |
| **Mid layer(s)** | Full-body stylized Lyuba, centered. |
| **Foreground** | LYUBA STAYS CALM across torso. |
| **Motion detail** | Blur resolves; Lyuba opens eyes/smiles subtly. Caption types and freezes. |
| **Handoff IN** | Zoom-blur from selected card. |
| **Text on screen** | LYUBA STAYS CALM · white caps · type-on. Reference uses LYUBA on screen. |
| **Audio** | Reveal whoosh at entry; VO phrase aligns to type-on. |
| **Handoff OUT** | First line is replaced by a longer consequence line while character remains. |
| **Asset ID(s)** | Lyuba full-body animated render. |
| **Mobile notes** | Simple one-line clause is large and centered. |

### 12.3 · Cast — Lyuba: underestimated

| Field | Specification |
|---|---|
| **Timecode** | `0:50.200 – 0:52.533` |
| **Duration feel** | ~2.33s; longest cast hold. |
| **Narration overlap** | “…until everyone realizes they underestimated her.” |
| **Background** | Neutral light-gray studio background. |
| **Mid layer(s)** | Lyuba full body; later raises one hand in a restrained wave. |
| **Foreground** | UNTIL EVERYONE REALIZES / THEY UNDERESTIMATED / HER, three lines centered across torso/waist. |
| **Motion detail** | Longer text types in stages and then holds. Character motion continues, but text stays perfectly still after completion. |
| **Handoff IN** | Same full-body shot; phrase swap only. |
| **Text on screen** | UNTIL EVERYONE REALIZES THEY UNDERESTIMATED HER · white caps · multi-line type-on. |
| **Audio** | VO carries the long sentence; no major transition SFX until the end. |
| **Handoff OUT** | Radial zoom/blur grows over the full character; circular gauge geometry appears through the blur. |
| **Asset ID(s)** | Lyuba full-body animated render. |
| **Mobile notes** | Three-line caption remains readable; line breaks keep width inside ~80% of frame. |

### 13.1 · Pressure — transition

| Field | Specification |
|---|---|
| **Timecode** | `0:52.533 – 0:53.067` |
| **Duration feel** | ~0.53s; aggressive visual handoff. |
| **Narration overlap** | End of Lyuba line / start of “See how…” |
| **Background** | Lyuba/gray studio rapidly blurs and darkens. |
| **Mid layer(s)** | Circular gauge face overlays at center, initially semi-transparent. |
| **Foreground** | Prior text dissolves. |
| **Motion detail** | Radial zoom blur pushes Lyuba backward while gauge scales up to full prominence; shared central circle motivates the transition. |
| **Handoff IN** | Character shot transforms rather than cutting directly. |
| **Text on screen** | No stable new headline. |
| **Audio** | Riser/zoom whoosh leads into the gauge; onset near 53.30s follows the visible blur start. |
| **Handoff OUT** | Gauge becomes fully opaque; background character disappears. |
| **Asset ID(s)** | Pressure gauge graphic. |
| **Mobile notes** | Transition stays centered, avoiding side-edge artifacts. |

### 13.2 · Pressure — low

| Field | Specification |
|---|---|
| **Timecode** | `0:53.067 – 0:54.400` |
| **Duration feel** | ~1.33s; measured tension build. |
| **Narration overlap** | “See how people change under pressure.” |
| **Background** | Dark mechanical gauge panel, full width of active frame, with black margins above/below inside the design. |
| **Mid layer(s)** | Blue-to-white-to-red arc around dial; small cyan side indicators. |
| **Foreground** | PRESSURE LEVEL: LOW inside gauge. |
| **Motion detail** | Needle begins left/low and sweeps toward center in a smooth clockwise move; label remains LOW. No text outside gauge. |
| **Handoff IN** | Gauge completes the radial morph from Lyuba. |
| **Text on screen** | PRESSURE LEVEL: LOW · embedded UI text, static. |
| **Audio** | Mechanical/electronic ticks and low pulses; distinct transient around 54.13s marks needle movement. |
| **Handoff OUT** | Needle accelerates toward red; label prepares to switch. |
| **Asset ID(s)** | Pressure gauge animation. |
| **Mobile notes** | Gauge fills most of frame width; embedded label remains legible. |

### 13.3 · Pressure — critical

| Field | Specification |
|---|---|
| **Timecode** | `0:54.400 – 0:55.900` |
| **Duration feel** | ~1.5s; payoff/peak. |
| **Narration overlap** | Completion of “…under pressure.” |
| **Background** | Same gauge panel. |
| **Mid layer(s)** | Red arc brightens; needle reaches right/red zone. |
| **Foreground** | PRESSURE LEVEL: CRITICAL replaces LOW. |
| **Motion detail** | Needle sweeps through center to the red zone with slight ease/settle. Red glow increases once; label changes at/near the peak and then holds. |
| **Handoff IN** | Continuous gauge animation. |
| **Text on screen** | PRESSURE LEVEL: CRITICAL · embedded UI text, static after swap. |
| **Audio** | Strong low impacts/ticks around 54.83s and the red-zone arrival; no repeated alarm loop is visually implied. |
| **Handoff OUT** | Gauge cuts/fades to black; new sentence types in empty space. |
| **Asset ID(s)** | Pressure gauge animation. |
| **Mobile notes** | Critical label has maximum contrast at the visual peak. |

### 13.4 · Pressure — change line

| Field | Specification |
|---|---|
| **Timecode** | `0:55.900 – 0:57.000` |
| **Duration feel** | ~1.1s; breath before map reveal. |
| **Narration overlap** | “See what happens…” |
| **Background** | Black. |
| **Mid layer(s)** | None. |
| **Foreground** | SEE WHAT HAPPENS centered. |
| **Motion detail** | Caption types, underscore cursor disappears, then holds. |
| **Handoff IN** | Gauge clears completely, creating a clean reset. |
| **Text on screen** | SEE WHAT HAPPENS · white caps · type-on. |
| **Audio** | Bright type/reveal accent around 56.07s; VO is exposed over the sparse frame. |
| **Handoff OUT** | Hard cut to a dense night-world dashboard at 57.000s. |
| **Asset ID(s)** | Text only. |
| **Mobile notes** | Large central text provides a deliberate pause after the busy gauge. |

### 14.1 · Pressure — relationships

| Field | Specification |
|---|---|
| **Timecode** | `0:57.000 – 0:58.300` |
| **Duration feel** | ~1.3s; map/HUD reveal. |
| **Narration overlap** | “…when relationships…” |
| **Background** | Night aerial/illustrated world map, full frame, warm city lights. |
| **Mid layer(s)** | Top-left LIVE SIMULATION status panel; top-right WORLD MAP panel. Four cyan location pins labeled LYUBA/LUBA, KATYA, IVAN, GOSHA. Bottom-left relationship network; bottom-right KATYA personality profile and 78% relationship status. |
| **Foreground** | WHEN RELATIONSHIPS types across center. |
| **Motion detail** | Hard cut. HUD panels and pins appear already assembled or settle within first ~200ms; pins emit a small one-time glow. Text types and holds. |
| **Handoff IN** | Hard cut from black sentence card; phrase continues semantically. |
| **Text on screen** | WHEN RELATIONSHIPS · white caps · type-on. |
| **Audio** | Large low-frequency reveal impact at ~57.03s, picture-synchronous. |
| **Handoff OUT** | Center text swaps through BECOME to PART OF THE GAME while map persists. |
| **Asset ID(s)** | Night world map/dashboard. |
| **Mobile notes** | Dense HUD occupies corners; center remains reserved for headline. |

### 14.2 · Pressure — game consequence

| Field | Specification |
|---|---|
| **Timecode** | `0:58.300 – 0:59.400` |
| **Duration feel** | ~1.1s; phrase completion over stable system view. |
| **Narration overlap** | “…become part of the game.” |
| **Background** | Night world map/dashboard continues. |
| **Mid layer(s)** | Pins and all four HUD panels remain fixed; faint map glow/ambient movement only. |
| **Foreground** | BECOME appears briefly, then PART OF THE GAME centered. |
| **Motion detail** | Fast phrase swap/type pattern; background does not reanimate. |
| **Handoff IN** | Same dashboard; text is the only major change. |
| **Text on screen** | BECOME → PART OF THE GAME · white caps · type-on each phrase, then hold. |
| **Audio** | Small typing/UI accents; music remains at high energy. |
| **Handoff OUT** | Orange-red URL plate begins sweeping across the center. |
| **Asset ID(s)** | Night world map/dashboard. |
| **Mobile notes** | Headline is large enough to dominate despite dense corners. |

### 14.3 · Pressure — URL bridge

| Field | Specification |
|---|---|
| **Timecode** | `0:59.400 – 1:00.900` |
| **Duration feel** | ~1.5s; promotional bridge, not final end card. |
| **Narration overlap** | Narration transitions toward “Watch live…” |
| **Background** | Night dashboard dims progressively toward black. |
| **Mid layer(s)** | Horizontal translucent orange/red plate or light streak crosses center. |
| **Foreground** | WWW.DOUBLAND.AI in bright blue/white centered on the plate. |
| **Motion detail** | Plate wipes/expands left→right; URL appears with glow and remains while the map opacity falls to near zero. |
| **Handoff IN** | URL plate grows out of the center headline zone. |
| **Text on screen** | WWW.DOUBLAND.AI · bold blue/white caps · reveal, then static. |
| **Audio** | Digital sting around 59.15–59.57s; music briefly punctuates the URL. |
| **Handoff OUT** | URL remains momentarily on black, then clears as WATCH LIVE begins. |
| **Asset ID(s)** | URL plate; night dashboard. |
| **Mobile notes** | URL is large and central; use high contrast and avoid continuous jitter. |

### 15.1 · Live / replay — live

| Field | Specification |
|---|---|
| **Timecode** | `1:00.900 – 1:01.533` |
| **Duration feel** | ~0.63s; rapid restart into feature list. |
| **Narration overlap** | “Watch live 24/7.” |
| **Background** | Black transitions into a day pixel-art village view. |
| **Mid layer(s)** | None beyond the incoming world image. |
| **Foreground** | WATCH LIVE 24/7 centered. |
| **Motion detail** | Text begins on black, then the day map appears behind it; type-on completes as background reaches full opacity. |
| **Handoff IN** | URL clears; shared central text position continues. |
| **Text on screen** | WATCH LIVE 24/7 · white caps · type-on. |
| **Audio** | Typing/reveal accent near 61.0s. |
| **Handoff OUT** | Background switches from day to night while text stays fixed. |
| **Asset ID(s)** | Pixel-art village day. |
| **Mobile notes** | Caption remains central and unchanged across the day/night switch. |

### 15.2 · Live / replay — day/night proof

| Field | Specification |
|---|---|
| **Timecode** | `1:01.533 – 1:03.000` |
| **Duration feel** | ~1.47s; time-passage demonstration. |
| **Narration overlap** | Completion of “Watch live 24/7.” |
| **Background** | Pixel village switches from daylight to deep blue night; lit windows become prominent. |
| **Mid layer(s)** | No additional HUD. |
| **Foreground** | WATCH LIVE 24/7 remains centered and static. |
| **Motion detail** | Day→night transition is a quick dissolve/cut around 62.1s. Text does not move, retype, pulse, or change opacity. |
| **Handoff IN** | Same composition; only background time state changes. |
| **Text on screen** | WATCH LIVE 24/7 · static hold. |
| **Audio** | Low hit around 62.15s marks the day/night change. |
| **Handoff OUT** | Hard cut to a more realistic/3D top-down village map. |
| **Asset ID(s)** | Pixel-art village day/night. |
| **Mobile notes** | Persistent text demonstrates the hold-still rule clearly. |

### 15.3 · Live / replay — follow

| Field | Specification |
|---|---|
| **Timecode** | `1:03.000 – 1:04.400` |
| **Duration feel** | ~1.4s; spatial overview. |
| **Narration overlap** | “Follow any Double.” |
| **Background** | Realistic/3D top-down village map with roads, buildings and forest, full frame; slow downward/vertical camera drift. |
| **Mid layer(s)** | None. |
| **Foreground** | FOLLOW ANY DOUBLE centered. |
| **Motion detail** | Hard cut. Text types and locks; map continues slow movement. |
| **Handoff IN** | Hard cut changes art style but preserves top-down spatial framing. |
| **Text on screen** | FOLLOW ANY DOUBLE · white caps · type-on, hold. |
| **Audio** | Impact at ~63.09s; light text ticks around 63.8s. |
| **Handoff OUT** | Caption swaps to replay; semi-transparent replay control overlays the map. |
| **Asset ID(s)** | Top-down 3D village map. |
| **Mobile notes** | Text is centered over a relatively open road area. |

### 15.4 · Live / replay — replay

| Field | Specification |
|---|---|
| **Timecode** | `1:04.400 – 1:06.433` |
| **Duration feel** | ~2.03s; longest feature hold. |
| **Narration overlap** | “Replay every moment.” |
| **Background** | Same top-down 3D village map with slow drift. |
| **Mid layer(s)** | Large semi-transparent replay UI/wordmark appears in lower-middle around 64.5–65.0s, including circular play/rewind symbol and thin horizontal lines; fades after the initial emphasis. |
| **Foreground** | REPLAY EVERY MOMENT centered. |
| **Motion detail** | Caption types then freezes. Replay graphic rises/fades in once, peaks at ~35–45% opacity, then fades while headline remains. Map motion continues. |
| **Handoff IN** | Same map; follow caption transforms into replay caption. |
| **Text on screen** | REPLAY EVERY MOMENT · white caps · type-on, then ~1s hold. |
| **Audio** | Digital replay accent around 64.36–65.0s. |
| **Handoff OUT** | Hard cut to black at 66.433s. |
| **Asset ID(s)** | Top-down 3D village; replay overlay. |
| **Mobile notes** | Replay UI is supporting, not a full-screen obstruction; headline stays primary. |

### 16.1 · Turn — not just avatars

| Field | Specification |
|---|---|
| **Timecode** | `1:06.433 – 1:07.267` |
| **Duration feel** | ~0.83s; card row rebuild. |
| **Narration overlap** | “These aren’t just avatars.” |
| **Background** | Black. |
| **Mid layer(s)** | ACTIVE DOUBLES cards enter sequentially across the upper third, left→right. |
| **Foreground** | THESE AREN’T JUST AVATARS types below the cards. |
| **Motion detail** | Hard cut. Cards slide/fade in with short stagger; caption types and settles. |
| **Handoff IN** | Abrupt reset from the map; cyan card language reconnects to earlier cast UI. |
| **Text on screen** | THESE AREN’T JUST AVATARS · white caps · two lines · type-on. |
| **Audio** | Low cut impact around 66.43s and a lighter card-pop around 66.54s. |
| **Handoff OUT** | Full card row holds; a small simulation/dashboard thumbnail appears below. |
| **Asset ID(s)** | ACTIVE DOUBLES identity cards. |
| **Mobile notes** | Cards occupy only upper third, leaving a clear caption band. |

### 16.2 · Turn — not just avatars

| Field | Specification |
|---|---|
| **Timecode** | `1:07.267 – 1:08.167` |
| **Duration feel** | ~0.90s; sentence hold and evidence seed. |
| **Narration overlap** | End of “avatars.” |
| **Background** | Black. |
| **Mid layer(s)** | Four-card ACTIVE DOUBLES row remains at top. Small blue simulation/dashboard tile fades in near lower center. |
| **Foreground** | THESE AREN’T JUST AVATARS remains static. |
| **Motion detail** | No text movement. Small tile scales 85%→100% and holds. |
| **Handoff IN** | Continuation. |
| **Text on screen** | THESE AREN’T JUST AVATARS · static hold. |
| **Audio** | Music sustains; no major SFX after card settle. |
| **Handoff OUT** | Headline swaps to THEY LEARN; lower tile expands/replaces with Survival Mode dashboard. |
| **Asset ID(s)** | Active Double cards; small dashboard tile. |
| **Mobile notes** | Sentence is isolated between top row and lower evidence tile. |

### 17.1 · Turn — learn

| Field | Specification |
|---|---|
| **Timecode** | `1:08.167 – 1:09.167` |
| **Duration feel** | ~1.0s; system learning evidence. |
| **Narration overlap** | “They learn.” |
| **Background** | Black. |
| **Mid layer(s)** | Top ACTIVE DOUBLES row persists. Large SURVIVAL MODE · DAY 01 dashboard expands into lower half with map, participant/status columns and challenge panel. |
| **Foreground** | THEY LEARN centered. |
| **Motion detail** | Prior small tile grows to the full dashboard with ease-out. Caption types quickly and holds. |
| **Handoff IN** | Lower evidence tile is the morph anchor. |
| **Text on screen** | THEY LEARN · white caps · type-on. |
| **Audio** | Digital expansion accent around 68.22s. |
| **Handoff OUT** | Dashboard recedes/replaces with alliances card as headline changes. |
| **Asset ID(s)** | Survival Mode dashboard; active-double cards. |
| **Mobile notes** | Top identity row and lower dashboard are separated by central headline space. |

### 17.2 · Turn — change

| Field | Specification |
|---|---|
| **Timecode** | `1:09.167 – 1:10.000` |
| **Duration feel** | ~0.83s; relationship-state change. |
| **Narration overlap** | “They change.” |
| **Background** | Black. |
| **Mid layer(s)** | Top card row persists. Vertical ALLIANCES card slides into lower half showing KATYA & LUBA trust 82%, GOSHA & IVAN trust 71%, and VIEW ALL ALLIANCES. |
| **Foreground** | THEY CHANGE centered. |
| **Motion detail** | Dashboard crossfades/slides out; alliances panel slides from right and settles. Text types then stops. |
| **Handoff IN** | Evidence panel replacement, not a full scene cut. |
| **Text on screen** | THEY CHANGE · white caps · type-on. |
| **Audio** | Prominent UI whoosh/impact around 69.58s. |
| **Handoff OUT** | Headline changes to THEY SURPRISE YOU; evidence panel changes twice. |
| **Asset ID(s)** | Alliances panel; active-double cards. |
| **Mobile notes** | Tall panel is offset lower-left/center so headline stays readable. |

### 17.3 · Turn — surprise

| Field | Specification |
|---|---|
| **Timecode** | `1:10.000 – 1:11.667` |
| **Duration feel** | ~1.67s; final system proof and fade. |
| **Narration overlap** | “They surprise you.” |
| **Background** | Black. |
| **Mid layer(s)** | Top ACTIVE DOUBLES row persists. Lower evidence cycles from alliance card to a small cursor-selected tile, then to a larger LIVE ACTIVITY FEED card with timestamped actions and LIVE indicator. |
| **Foreground** | THEY SURPRISE YOU centered. |
| **Motion detail** | Headline types and freezes. Lower card briefly shrinks/replaces; cursor click is visible near 70.5s; activity feed scales up and holds. All elements dim toward 71.67s. |
| **Handoff IN** | Same top row and center caption anchor the successive lower evidence panels. |
| **Text on screen** | THEY SURPRISE YOU · white caps · type-on, then static. |
| **Audio** | High-frequency digital accent around 70.43s; fade/riser into next scene near 71.51–71.79s. |
| **Handoff OUT** | Global fade to black, then hard cut to foggy deck at 71.667s. |
| **Asset ID(s)** | Alliances card; activity feed; active-double cards; cursor. |
| **Mobile notes** | Activity feed reaches readable size before fade; avoid leaving it as a tiny thumbnail. |

### 18.1 · End card — reflection setup

| Field | Specification |
|---|---|
| **Timecode** | `1:11.667 – 1:12.733` |
| **Duration feel** | ~1.07s; atmospheric slowdown. |
| **Narration overlap** | “And after a while…” |
| **Background** | Foggy, blue-gray outdoor deck/dining area at night with empty chairs, string lights and hanging lanterns; subtle camera drift. |
| **Mid layer(s)** | No HUD. |
| **Foreground** | AND AFTER A WHILE centered. |
| **Motion detail** | Hard cut from black/UI to full-frame scenic video. Caption types and then holds; background motion is slow. |
| **Handoff IN** | Energy contrast: dense UI disappears; warm lanterns replace cyan interface lights. |
| **Text on screen** | AND AFTER A WHILE · white caps · type-on. |
| **Audio** | Cinematic transition hit at ~71.67s; music opens and begins resolving. |
| **Handoff OUT** | Caption swaps to YOU ASK while the same deck shot continues. |
| **Asset ID(s)** | Foggy deck/night video. |
| **Mobile notes** | Text sits over clear mid-frame negative space; lanterns frame rather than obscure it. |

### 18.2 · End card — question lead-in

| Field | Specification |
|---|---|
| **Timecode** | `1:12.733 – 1:13.800` |
| **Duration feel** | ~1.07s; pause before final question. |
| **Narration overlap** | “…you ask—” |
| **Background** | Foggy deck continues. |
| **Mid layer(s)** | None. |
| **Foreground** | YOU ASK centered. |
| **Motion detail** | Phrase appears quickly and stays still; camera remains slow. Near exit the scenic image darkens. |
| **Handoff IN** | Same deck shot, phrase swap only. |
| **Text on screen** | YOU ASK · white caps · quick type/fade-on, hold. |
| **Audio** | Music dips before the final question; no large SFX until the cut. |
| **Handoff OUT** | Hard cut to wireframe speaker at 73.800s. |
| **Asset ID(s)** | Foggy deck/night video. |
| **Mobile notes** | Very short phrase is held long enough to create anticipation. |

### 18.3 · End card — final question

| Field | Specification |
|---|---|
| **Timecode** | `1:13.800 – 1:15.300` |
| **Duration feel** | ~1.5s; principal end-card statement. |
| **Narration overlap** | “What would my Double do?” |
| **Background** | Black. |
| **Mid layer(s)** | Large cyan wireframe speaker in profile fills left/lower frame; oversized outlined speech bubbles occupy right/top; faint scan marks. |
| **Foreground** | WHAT WOULD MY DOUBLE DO? centered over the figure. |
| **Motion detail** | Hard cut. Figure/UI are already present; question appears quickly (short type/fade) and then remains completely static. |
| **Handoff IN** | Visual callback to the hard-conversation hook; wireframe person and chat bubbles return. |
| **Text on screen** | WHAT WOULD MY DOUBLE DO? · white caps · two lines · quick reveal, then hold. |
| **Audio** | Final-question impact/reveal around 74.29s. Music reaches resolution under the hold. |
| **Handoff OUT** | Blue URL begins appearing through/behind the white question; figure darkens. |
| **Asset ID(s)** | Wireframe speaker; speech-bubble HUD. |
| **Mobile notes** | Question is the largest text in the ending and remains central. |

### 18.4 · End card — URL takeover

| Field | Specification |
|---|---|
| **Timecode** | `1:15.300 – 1:16.000` |
| **Duration feel** | ~0.70s; brand handoff. |
| **Narration overlap** | VO ends. |
| **Background** | Black; wireframe figure and bubbles dim to low opacity. |
| **Mid layer(s)** | Faint residual HUD. |
| **Foreground** | WWW.DOUBLAND.AI in bright electric blue emerges on the same horizontal band as the question. |
| **Motion detail** | URL fades/slides in while question opacity falls; for several frames both overlap. No bouncing or repeated glitch after the URL is readable. |
| **Handoff IN** | Shared blue/cyan palette and center line create the handoff. |
| **Text on screen** | WWW.DOUBLAND.AI · bold blue caps · opacity/position reveal; question fades. |
| **Audio** | Logo/URL resolve accents around 75.25 and 75.78s. |
| **Handoff OUT** | URL becomes the only high-contrast element. |
| **Asset ID(s)** | URL text; residual wireframe speaker. |
| **Mobile notes** | Ensure overlap phase is brief enough that both strings do not become illegible. |

### 18.5 · End card — final hold

| Field | Specification |
|---|---|
| **Timecode** | `1:16.000 – 1:16.578` |
| **Duration feel** | ~0.58s; concise final hold. |
| **Narration overlap** | No narration. |
| **Background** | Near-black. |
| **Mid layer(s)** | Wireframe figure is barely visible or gone. |
| **Foreground** | WWW.DOUBLAND.AI centered, blue glow. |
| **Motion detail** | URL stays fixed; only faint glow/noise remains. No scale pulse after settle. |
| **Handoff IN** | Question has fully yielded to the URL. |
| **Text on screen** | WWW.DOUBLAND.AI · static. |
| **Audio** | Music/SFX tail fades to end. |
| **Handoff OUT** | End of file; no additional logo card. |
| **Asset ID(s)** | URL text. |
| **Mobile notes** | Final readable hold is ~0.58s on master; no pulse/scale after URL settles. |

## Cross-cutting summary

### Layer depth by section

| Section | Typical layers, back → front | Implementation note |
|---|---|---|
| Hook | black/grain → human or AI hero image → diagnostic/UI geometry → primary text → transient glitch | Usually 4–5 visible layers; the text remains the top readability layer. |
| Concept | black → portrait/family media → scan frames/progress bars/tree → headline | Cards are full-strength hero elements, not faint decoration. |
| World | full-opacity village/map video → darkening gradient → HUD panels/cards → caption | Video remains prominent; UI is added around central text rather than covering it. |
| Season | location video or black → family group → trait/identity cards → caption/cursor | Layer count rises from 2 to 5 as the premise becomes a selectable cast system. |
| Cast | gray studio → full-body character → locked caption | Only 2–3 layers; intentionally simple after dense UI. |
| Pressure | character blur → gauge or night map → HUD → phrase/URL | Gauge is nearly full-frame; map HUD uses all four corners but keeps center open. |
| Turn | black → persistent active-double row → changing evidence panel → headline/cursor | Top identity row is the continuity anchor while lower proof changes. |
| End card | scenic video or black → wireframe speaker/HUD → question → URL | Question and URL share one center band and crossfade briefly. |

### Visual change rate

- **0:00–0:19.5:** a meaningful change every ~0.5–1.5s: new phrase, UI layer, card pair, or graphic state. The hook never relies on a single static shot for an entire VO sentence.
- **0:19.5–0:31.8:** changes every ~1–2s, but the world videos are allowed to move continuously beneath text holds.
- **0:31.8–0:41.4:** pace accelerates through premise, warning title, counts, cards and cursor selection.
- **0:41.4–0:52.5:** each cast member receives ~1.8–2.3s, separated by ~0.6–0.8s selection interstitials.
- **0:52.5–1:06.4:** strong visual resets at gauge, map, day/night, follow and replay; text generally holds while backgrounds change.
- **1:06.4–end:** proof panels change every ~0.8–1.2s, followed by a slower atmospheric end-card setup.

### Brightness / energy curve

Two-frame bright poster → near-black cyan/red hook → brighter portrait concept → warm village hero → saturated pixel map → dark cyan UI → warm season location → black/copper warning → bright gray cast portraits → dark gauge/map peak → bright map/day-night montage → black proof UI → soft foggy lantern scene → black/cyan final question and URL.

### Text behavior rules

- Primary phrases use a **fast character-by-character type-on**. An underscore cursor is visible only while incomplete.
- Once readable, text **locks perfectly still**. It does not keep glitching, pulsing, scaling or drifting.
- Glitch is reserved for entries/exits and brand/system resets: WHAT IF reset, DOUBLE wordmark, Survival Mode warning and select-card zooms.
- Phrase swaps usually reuse the same center axis. The background or UI remains continuous so the viewer perceives one evolving sentence/system rather than unrelated cards.
- Typical completed-text hold is ~0.6–1.4s; very short bridge lines hold ~0.4–0.7s.
- White all-caps text is dominant. Electric blue is reserved for DOUBLE/URL and cyan UI; copper/red is reserved for Survival/pressure danger.

### Transition grammar

| Pattern | Example | Rebuild rule |
|---|---:|---|
| Shared center-axis replacement | 0:00–0:10 | WHAT IF, answer line and DOUBLE occupy the same center zone; replace content without moving the viewer’s eye. |
| Persistent hero, changing UI | 0:04.8–0:08.6 | Lower conversation figures remain while upper chat bubbles become a relationship graph and captions change. |
| Word-to-logo match | 0:09.4–0:10.8 | Spoken/on-screen DOUBLE becomes the oversized blue brand wordmark. |
| Poster deconstruction | 0:10.8–0:18.5 | Family poster breaks into identity cards, then bars, then a decision tree while black/cyan styling remains. |
| Logo match-carry | 0:18.5–0:19.5 | DOUBLAND SIMULATION ACTIVE persists across black-to-village cut. |
| UI state morph | 0:27.2–0:31.8 | Conversation card becomes choice card, then relationship graph; avoid generic crossfades. |
| Foreground persistence over background swap | 0:33–0:35 | Family and text remain while rowhouse lane dissolves to warm porch. |
| Select-card expansion | 0:41.4–0:49.1 | Cursor click → radial blur/scale → full-body character; character → hard cut back to card row. |
| Radial object match | 0:52.5–0:53.1 | Character blur becomes circular pressure gauge. |
| Persistent text across time-state change | 1:01.5–1:03 | WATCH LIVE 24/7 stays frozen while pixel world changes day→night. |
| Persistent identity row, changing evidence | 1:06.4–1:11.7 | Top cards remain; lower dashboard/alliance/feed panels replace each other. |
| Question-to-URL takeover | 1:15.3–end | URL appears through the same center band while question and wireframe figure dim. |

### Repeated assets and changed treatment

| Asset / motif | Uses | Treatment changes |
|---|---|---|
| Family group | frame 0; 0:10.8–0:12.6; 0:15.9–0:18.5; 0:33–0:41.4 | Poster top/bottom bands → lower concept anchor → season cast cutout/candid loop. Brightness, crop and framing change each time. |
| Wireframe conversation figures | 0:02.3–0:04.0; 0:04.8–0:08.6; 1:13.8–1:16.0 | Silhouette strip → full rehearsal UI → end-card callback with single speaker and oversized bubbles. |
| Identity cards | 0:12.6–0:15.9; 0:25.4–0:27.2; 0:39.9–0:49.1; 1:06.4–1:11.7 | Paired proof cards → four floating world cards → selectable cast row → persistent proof anchor. |
| Village / world imagery | 0:19.5–0:23.5; 0:24–0:27.2; 0:31.8–0:35; 0:57–1:06.4 | Warm 3D hero → pixel live world → realistic season location → night dashboard → pixel day/night → top-down 3D replay map. |
| Relationship graph | 0:06.5–0:08.6; 0:30–0:31.8; 0:57–1:00.5 | Narrative relationship diamond → decision consequence card → full world-map dashboard panel. |
| DOUBLAND / URL | 0:10.3; 0:18.5–0:20.1; 0:59.4–1:00.9; 1:15.3–end | Blue wordmark hit → simulation-active location-pin logo → orange-plate mid-trailer URL → clean blue final URL. |

### Mobile legibility

- Primary text stays mostly inside the middle 70–80% width and between ~30–70% frame height.
- Character faces are kept away from caption bands; full-body captions cross torso/waist, never the face.
- Dense HUD panels are pushed to upper/lower corners, preserving a central text channel.
- Full-opacity or near-full-opacity video is used for hero world moments; overlays are darkened locally rather than reducing the whole clip to a faint background.
- The master is **native 9:16**; the visible composition is the framing reference — not a landscape wrapper with side margins.

### End-card sequence

| Phase | Time | On screen | Motion after settle |
|---|---:|---|---|
| Reflection | 1:11.667–1:12.733 | Foggy deck + AND AFTER A WHILE | Only slow background drift; text frozen. |
| Lead-in | 1:12.733–1:13.800 | Same deck + YOU ASK | Text static after quick reveal. |
| Question | 1:13.800–1:15.300 | Wireframe speaker + WHAT WOULD MY DOUBLE DO? | No motion in question after settle. |
| URL takeover | 1:15.300–1:16.000 | Question dims as WWW.DOUBLAND.AI appears | Brief opacity overlap only. |
| Final hold | 1:16.000–1:16.578 | WWW.DOUBLAND.AI alone | No pulse/scale; faint glow and audio tail. |

### Poster frame

Frame 0 is a three-band thumbnail composition: dark scanned family image at top with a large outlined blue DOUBLE wordmark, white AN AI VERSION OF YOU in the center gap, and a brighter clean family image at the bottom. It is visually strong as a cover image but lasts only **~50 ms (three decoded frames)** before black reset and the hook. Preserve literal reference string `THE PISTSOFF FAMILY ENTERS` unless intentionally correcting product copy.