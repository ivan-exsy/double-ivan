# Video prompts — generation catalog

> **SOT contracts:** `video/sot-video.md` §8 (asset system)  
> **Codegen script templates:** `generative_agents/video/assets/scripts-prompts/!prompts.md` (engineering repo)

Placeholders: `[CAST_SIZE]`, `[COHORT_NAME]`, `[PERSONA_NAME]`, `[MODE_NAME]`, `[WORLD_STYLE]`, `[PRIMARY_TRAIT]`, etc.

---
## General prompt rules

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

## Hook and abstract UI assets

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset.png` → generalized hook motif pack

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

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset2.png` → generalized chat-bubble overlay

**Current role:** Static chat-bubble composition used as a fallback or supporting overlay.

**Generalized reusable asset:** Clean conversation UI overlay not tied to a specific cast.

**Prompt:**
```text
Create a premium futuristic conversation UI overlay for Doubland on a black background. Show three glowing white and cyan chat bubbles of different sizes floating in a minimal HUD environment with dotted technical accents, thin brackets, and subtle scan-line details. The composition should feel like a clean communication interface, with no real text inside the bubbles, only abstract text lines or dots. Elegant neon glow, dark sci-fi look, minimal clutter, suitable as an overlay in a vertical trailer.
```

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset3.png` → generalized live-conversation still

**Current role:** Live-feed style conversation still with two digital people and chat bubbles.

**Generalized reusable asset:** Cast-agnostic conversation screen showing two people talking.

**Prompt:**
```text
Create a Doubland-style live conversation interface on a black background. Show two human figures in profile facing each other, rendered as luminous blue digital wireframe or point-cloud silhouettes, with glowing chat bubbles floating between them. Add subtle live-feed UI framing in the corners, tiny status text, dotted HUD accents, and a cinematic futuristic interface feel. Keep the scene clean, readable, and emotionally focused on conversation. No specific names. High-resolution, premium sci-fi visual language.
```

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Asset4.png` → generalized blue light ignition line

**Current role:** Horizontal blue light sweep used for ignition and transition.

**Generalized reusable asset:** Clean transition light-line overlay.

**Prompt:**
```text
Create a sleek horizontal blue energy line on a black background, centered across the frame, with a bright glowing core flare in the middle and soft cyan neon bloom extending outward. The line should feel precise, premium, and futuristic, suitable for use as a transition wipe or activation effect in a sci-fi interface trailer. Minimal composition, high contrast, no text.
```

## Brand and CTA assets

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Double.png` → generalized DOUBLE concept wordmark

**Current role:** Concept wordmark used when the narration defines the Double.

**Generalized reusable asset:** Clean wordmark treatment for the term “DOUBLE”.

**Prompt:**
```text
Create a premium Doubland-style title card on a black background featuring the word “DOUBLE” in large futuristic uppercase lettering. Use a cyan-blue neon outline or glow, clean spacing, and elegant sci-fi branding. The composition should feel cinematic, minimal, and powerful, with subtle digital texture and restrained light bloom. No extra text unless very small ambient interface accents are needed.
```

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\DOUBLAND.png` → generalized Doubland active-logo plate

**Current role:** Simulation activation / end-card logo.

**Generalized reusable asset:** Reusable Doubland logo plate.

**Prompt:**
```text
Create a premium futuristic logo plate for DOUBLAND on a black background. Include a cyan-blue neon interface frame, a clean location-pin or simulation marker icon above or integrated with the wordmark, and a smaller subtitle area that can read “SIMULATION ACTIVE.” The style should be minimal, elegant, highly legible, and consistent with a premium sci-fi HUD system. Strong central alignment, controlled glow, and plenty of black negative space.
```

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\DOUBLAND2.png` → generalized URL end-card

**Current role:** Final URL treatment.

**Generalized reusable asset:** Website/URL end-card.

**Prompt:**
```text
Create a minimal futuristic end-card on a black background featuring the URL “WWW.DOUBLAND.AI” in large uppercase cyan-blue neon lettering. Make it crisp, highly legible, centered, and premium. Use restrained glow and subtle sci-fi interface atmosphere, but keep the URL as the dominant element. No unnecessary clutter.
```

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\F1714AC2-78E4-434B-844C-30F0A03D4DD7.png` → generalized replay-control overlay

**Current role:** Replay button used with “Replay every moment.”

**Generalized reusable asset:** Reusable replay interface element.

**Prompt:**
```text
Create a futuristic replay-control UI element on a black background. Show a rounded rectangular HUD-style button with a replay or fast-rewind icon and the word “REPLAY” in crisp uppercase lettering. Use cyan-blue neon borders, subtle glow, thin interface details, and a premium sci-fi dashboard feel. The element should be isolated and easy to composite over a trailer scene. No extra clutter.
```

## Cohort and group assets

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Family.png` → generalized clean cohort photo

**Current role:** Clean warm group image of the current cast.

**Generalized reusable asset:** Cohort-specific group portrait for any new cast.

**Prompt:**
```text
Create a clean, cinematic group portrait of [CAST_SIZE] people representing the cohort “[COHORT_NAME]”. Show the group standing close together, facing camera naturally, with warm realistic lighting and a believable shared environment or softly blurred neutral interior background. The people should feel like a cohesive cast, visually distinct from one another, and emotionally grounded. Keep the composition centered and readable so it can be used in a trailer concept card and marketing collage. No text or UI overlay.
```

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Photoroom_20260611_151820.png` → generalized transparent group cutout

**Current role:** Transparent cutout of the full cast, used for layering over UI and backgrounds.

**Generalized reusable asset:** Transparent or isolated group cutout for any new cast.

**Prompt:**
```text
Create a clean isolated group cutout of [CAST_SIZE] people representing the cohort “[COHORT_NAME]”. The cast should be standing together in a natural staggered arrangement, fully visible from about thigh-up or waist-up, with realistic appearance, clean separation from the background, and subtle cinematic rim lighting. Output should look like a transparent-background cutout or black-background cutout suitable for compositing into a futuristic trailer. No text, no UI elements.
```

### `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Family.mp4` → generalized group-reveal motion clip

**Current role:** Warm animated cast motion used in the concept and “this season” sections.

**Generalized reusable asset:** Short cohort-specific group motion clip.

**Prompt:**
```text
Create a 3 to 5 second cinematic motion clip showing the cohort “[COHORT_NAME]”, a cast of [CAST_SIZE] people, standing together in a warm realistic environment. Use subtle natural movement such as small head turns, breathing, eye contact, or slight posture shifts. The shot should feel emotionally grounded and premium, like a live-action hero moment before futuristic UI overlays appear. Keep the group clearly visible and centered, with clean framing that can crop vertically for a 9:16 trailer. No text.
```

## Individual Double assets

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Dasha.png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Gosha .png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Iván.png`, `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Luba.png` → generalized `DoubleIdentityCard` style reference

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

### Clean isolated portrait / cutout for each persona

**Current role:** Needed to build new identity cards and cast sequences.

**Generalized reusable asset:** Per-person portrait cutout.

**Prompt:**
```text
Create a clean isolated portrait of [PERSONA_NAME] from the cohort “[COHORT_NAME]”. Show the character from chest-up or waist-up, facing camera with a natural confident expression, realistic lighting, and subtle rim light separation. The look should reflect traits such as [PRIMARY_TRAIT], [SECONDARY_TRAIT], and [TERTIARY_TRAIT]. Background should be transparent, pure black, or very clean and easy to remove so the portrait can be composited into a futuristic HUD card. No text.
```

## World and simulation assets

### `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Village.mp4` → generalized world-establishing aerial clip

**Current role:** World-entry motion, moving bridge into the map.

**Generalized reusable asset:** Short aerial/overview motion clip for the simulation world.

**Prompt:**
```text
Create a 3 to 5 second cinematic aerial motion clip of the simulation world “[WORLD_NAME]” in a [WORLD_STYLE] setting. Show a richly detailed environment from above or at a high angle, with a strong sense of place, subtle motion, and visual depth. The shot should feel like a premium fantasy-meets-digital simulation world that can support UI overlays. Include pathways, lights, buildings or landmarks, and a believable living environment. Composition should work for vertical cropping in a 9:16 trailer. No text.
```

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Map.png` → generalized `WorldMapHUD`

**Current role:** World status, location map, cast nodes, relationship panel, and focused-person panel.

**Generalized reusable asset:** A reusable world-map HUD component or one cohort-specific rendered map board.

**Prompt:**
```text
Create a futuristic world-status interface in the Doubland trailer style. Use a cinematic aerial view of the simulation world “[WORLD_NAME]” as the background and overlay elegant cyan-blue HUD panels. Include: a top-left world-status panel with live metrics, a top-right mini map or radar panel, several glowing location markers for selected cast members, a lower-left relationship-network panel, and a lower-right focused-person profile panel. Keep the interface clean, premium, and readable on mobile. The cast markers should correspond to [HIGHLIGHTED_PERSONAS], and the focused profile should be [FOCUSED_PERSONA]. Dark sci-fi UI, high detail, no clutter.
```

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Profile.png` → generalized cohort initialization progress board

**Current role:** Initialization progress bars for multiple cast members.

**Generalized reusable asset:** Live initialization board for current cohort.

**Prompt:**
```text
Create a futuristic cohort initialization progress board for Doubland on a black background. Show [CAST_SIZE] stacked progress rows, one for each cast member in [PERSONA_LIST]. Each row should include a circular user icon, the character name, the label “AI DOUBLE INITIALIZING”, a glowing horizontal progress bar, and a numeric completion percentage. Use a clean dark UI with cyan-blue glow, thin borders, and strong legibility. The board should feel like a live system status screen. No extra clutter.
```

## Relationship and decision assets

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Connections.png` → generalized relationship-update toast

**Current role:** Small trust/relationship change card.

**Generalized reusable asset:** Reusable short-form relationship update overlay.

**Prompt:**
```text
Create a compact futuristic relationship-update UI card on a dark background. Show a small relationship network diagram or linked user icons near the top and a bold title such as “RELATIONSHIP UPDATED” in uppercase. Beneath it, show a large signed metric such as “[SIGNED_DELTA] [RELATIONSHIP_LABEL]”. Use cyan-blue glow for positive or neutral updates and orange-red glow for negative or conflict-based updates. Make it clean, legible, and easy to composite into a trailer.
```

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Connections2.png` → generalized conversation / relationship / decision component set

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

### Relationship graph as a standalone generalized asset

**Prompt:**
```text
Create a futuristic relationship graph interface for the Doubland trailer style. Show [NODE_COUNT] character nodes arranged in a clean readable network on a dark background, with glowing edges labeled by relationship types such as alliance, trust, rivalry, influence, or conflict. Highlight one important connection involving [FOCUSED_PERSONA]. Use cyan-blue neon lines, subtle node pulses, and a premium sci-fi interface feel. Keep the graph readable and uncluttered.
```

### Decision tree as a standalone generalized asset

**Prompt:**
```text
Create a sleek futuristic decision-tree interface on a black background. Show a central decision node labeled “[DECISION_TOPIC]”, branching into two or three choice nodes, then into multiple outcome nodes. Use glowing cyan-blue HUD boxes, thin connection lines, and a premium sci-fi style. The composition should clearly communicate that choices lead to different outcomes. Keep it elegant, readable, and mobile-friendly.
```

## Season, mode, and pressure assets

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards2.png` → generalized Survival dashboard

**Current role:** Full-season dashboard with players, alliances, conflicts, events, active Doubles, live feed, and day progress.

**Generalized reusable asset:** Any mode dashboard, not just the Pistsov-family version.

**Prompt:**
```text
Create a premium futuristic simulation dashboard for the mode “[MODE_NAME]” in the Doubland style. Use a dark blue-black interface with cyan-blue HUD borders and a small amount of warning-color accent where appropriate. Include: an overview panel with live counts, a main world-status section, an active Doubles section showing selected cast members, an alliances panel, a conflicts panel, a live activity feed, and a day-progress or time-progress strip. The cast should be [HIGHLIGHTED_PERSONAS]. The interface should feel like a powerful live-simulation control screen, readable on mobile, highly polished, and information-dense but organized.
```

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Survival.png` → generalized mode-banner / season-title set

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

### `D:\Coding\generative_agents\video\opening-anya\Anya_animated\Pressure.mp4` → generalized pressure / escalation motion clip

**Current role:** Pressure peak clip.

**Generalized reusable asset:** Short escalation motion clip for any tense moment.

**Prompt:**
```text
Create a 3 to 5 second futuristic pressure-escalation motion clip in the Doubland style. Show a large glowing circular gauge, radar, or pressure indicator on a dark background, starting calm and sweeping toward higher intensity. The visual should feel urgent and cinematic, with cyan-blue UI transitioning into orange-red or brighter intensity near the critical zone. Add subtle background world or village texture if helpful, but keep the gauge as the hero element. High-end sci-fi interface motion, clear rise in tension, no text unless minimal UI labels are needed.
```

## Personality-analysis assets

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards3.png` → generalized trait-card set

**Current role:** Personality trait cards for current cast.

**Generalized reusable asset:** Reusable trait-card component system.

**Prompt:**
```text
Create a set of premium futuristic personality trait cards for a Doubland trailer. Show [CARD_COUNT] vertical cards on a dark background, one per selected character. Each card should include the character name, two to three concise personality traits, small trait icons, and a refined cyan-blue neon interface frame. The design should feel sleek, minimal, and premium, with readable typography and subtle glow. If a trait implies tension or risk, a small orange accent may be used. Keep the cards clean and modular.
```

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards4.png` → generalized personality-analysis panel and Double initializer

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

## Concept-layout assets

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards1.png` → generalized concept-sequence board

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

### `D:\Coding\generative_agents\video\opening-anya\Anya_PNG_assets\Cards5.png` → generalized cast-asset board

**Current role:** White-background board showing group photo, scanned version, and individual cards.

**Generalized reusable asset:** Internal asset board for QC and workflow, not necessarily a trailer shot.

**Prompt:**
```text
Create a clean internal asset board showing the core visual package for the cohort “[COHORT_NAME]”. Include: a clean group portrait, a scanned-interface group version, and four individual AI Double identity cards. Use a simple neutral or white presentation-board background so the assets can be reviewed side by side by the production team. Keep the visuals premium and consistent with Doubland branding, but treat this as a design-board or QA board rather than a final trailer frame.
```

## Asset-generation workflow

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

## Naming convention

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

## Generalization principle

The current Pistsov-family assets should be treated as **visual prototypes**. The reusable system should preserve:

- the **composition logic**,
- the **HUD frame language**,
- the **color semantics**,
- the **motion behavior**,
- and the **editorial role** of each asset,

while replacing the cast, world, names, metrics, and relationships with simulation-specific content.

When in doubt, generate a new asset that matches the **function** of the current asset rather than trying to force the existing Pistsov-family asset into a new simulation.

---

## Flyover clips (the_ville / Grok Imagine)

### Grok Imagine - foreword:
```
I work on Reality AI show, where AI generated scenarios are visualized via Phaser game engine. For promotion purposes, I am planning to generate images and video materials for video trailers.   
Assess these top-level screenshots for inspiration - in the attached images.   
I need you to create semi-realistic visuals that would look like a better, almost real version of the phaser village.   


While on the screenshots all houses are top-opened, I need you to envision how this village would look like if all houses were with real roofs.



I need you to:
1. Exactly match the Phaser layout/plan from screenshots
2. Start video as if house are with real roofs, but as you zoom out, all roof gradually fadeout to completely disappear as the camera reaches the bird-eye level.

```

### 1. Village Overhead Fly-Over (Overall Layout)
`video\fly-over\cinematic_flyover_village_overhead.mp4`
What: A sweeping aerial view rising from the village center to reveal the full tile-based layout, highlighting clustered houses, winding paths, and outer boundaries to show isolation.
Duration: 4s
Grok Imagine Prompt: "Create a 4-second 3D fly-over video of a quaint isometric village called The Ville, starting low over the central paths and rising to overhead view. Show 20-30 cozy tile-based houses in warm wood and stone, connected by dirt roads, with misty fog adding depth. Empty at dawn, soft golden light, no people. Cinematic, subtle camera pan rightward, 1080p MP4, 30fps, loopable."

Homes Row Approach (Residential Stakes)
"video\fly-over\cinematic_flyover_homes_row_approach.mp4"
What: Low fly-over approaching a row of family homes, zooming into open windows/doors to glimpse interiors (kitchens, living rooms) symbolizing personal routines and hidden alliances.
Duration: 3s
Grok Imagine Prompt: "3-second 3D video fly-over approaching a row of 6-8 attached houses in a village, isometric style like a 2D tile map but with depth. Start ground-level on a dirt path, rise and pan left to show wooden facades, open windows revealing cozy kitchens and living rooms with soft lamplight. Empty, twilight dusk lighting, subtle wind in trees, no characters. Cinematic tension, 1080p MP4, 30fps."

### Cafe Exterior Pan (Social Hub)
`video\fly-over\cinematic_flyover_cafe_exterior_pan.mp4`
What: Ground-level fly-over circling the cafe exterior, emphasizing outdoor seating and entrance to evoke gathering spots for conversations and conflicts.
Duration: 4s
Grok Imagine Prompt: "4-second 3D fly-over video circling a rustic village cafe exterior, starting at street level and rising slightly. Isometric view with 3D depth: wooden building with large windows, outdoor tables under string lights, surrounded by paths and flowers. Empty at midday, warm sunlight filtering through, no people. Build subtle anticipation, smooth pan clockwise, 1080p MP4, 30fps, loopable."

### Hobbs Cafe Interior Overview Fly-Over (Council Zone)
`video\fly-over\cinematic_flyover_hobbs_cafe_interior.mp4`
"Create a 4-second 3D fly-over video of the interior of a cozy village cafe called Hobbs Cafe, inspired by a warm wooden exterior with string lights and patio (reference: inviting alpine-style building with golden-hour glow). Start at the patio entrance door, smoothly rise and pan rightward across the open floor plan: central wooden tables and chairs around a patterned rug, a polished bar/kitchen area with counters and stools on the left, a grand piano in the far corner, large windows letting in soft dusk light, and wooden beams overhead. Isometric perspective with added 3D depth like a tile-map game but volumetric – empty of people, subtle shadows and warm lamp glow creating a welcoming yet tense atmosphere for social gatherings. No characters, cinematic build-up with misty air and fading daylight, 1080p MP4, 30fps, loopable."


### Village Dusk Wind-Down (Day End Stakes)
`video\fly-over\cinematic_flyover_village_dusk_wind_down.mp4`
What: Closing fly-over retreating from the center at dusk, fading lights in houses and cafe to symbolize routines ending and nightly risks.
Duration: 4s
Grok Imagine Prompt: "4-second 3D fly-over of a village at dusk, starting overhead center and retreating outward. Isometric tile layout with depth: houses with dimming windows, cafe lights flickering on, long shadows across paths. Empty, melancholic tension, purple-blue twilight hues, subtle breeze effect. Backward pan, 1080p MP4, 30fps."



## *How Camera works*

<X: https://x.com/beginnersblog1/status/2065759796104761770>

Cinematographers learn 12 camera moves in film school. 

Most AI creators don't know a single one. Because nobody told the camera what to do.

Here they are:

→ Push-in — moves toward the subject
Builds tension. Creates intimacy. Use it slowly.

→ Pull-back — retreats to reveal
Isolation. Scale. Endings. The reveal shot.

→ Pan — horizontal rotation, camera stays fixed
Suspense lives in what you haven't shown yet.

→ Tilt — vertical version of the pan
Tilt up on a hero. They look powerful immediately.

→ Tracking shot — camera travels with the subject
Energy. Forward motion. You feel like you're there.

→ Arc / orbit — circles the subject
Hero moments. Product showcases. Keep it under 30 degrees.

→ Crane / jib — sweeps vertically on a boom
Grandeur. Scale. The "god-view" of cinematography.

→ Zoom — focal length changes, camera doesn't move
Flatter look than a dolly. Fast zoom = music video energy.

→ Dolly zoom — camera goes one way, lens goes the other
Background warps. Subject stays still. Pure psychological dread.

→ Whip pan / crash zoom — extreme speed for transitions
Shock. Comedy. Stops the scroll every time.

→ Handheld — natural shake, no stabilisation
Add "subtle" or the model goes full earthquake.

→ Static + angles — low, high, Dutch, bird's-eye, worm's-eye

Low angle = power.
Dutch angle = unease.
Bird's-eye = scale.

The mistake everyone makes: stacking multiple moves into one prompt. One move. One clip. Always.

And add "slow" to almost everything. Slow moves hide what AI can't render cleanly. Fast moves expose every flaw.
