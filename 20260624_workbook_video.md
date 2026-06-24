# Trailer comparison workbook — Anya reference vs `opener&006`

**Purpose:** Side-by-side review aid for Ivan + Anya. Each row = one review beat. Use **Anya TC** and **006 TC** to scrub both players to the same narrative moment (timings drift ~5–6s in the back half — that is expected).

---

## Path legend

| Prefix | Root |
|---|---|
| **GA** | `D:\Coding\generative_agents\` |
| **Run** | `D:\Coding\generative_agents\data\base_family_sim\opener&006\` |

**Asset types**

| Tag | Meaning |
|---|---|
| **SOURCE** | Original Anya kit or pipeline input — open this to judge raw art |
| **STAGED** | Copy used by Remotion last render → `GA/video/remotion/public/render/` (rebuilt each props build) |
| **REF** | Reference board — design spec only; **not** for full-frame render (Playbook §16.8) |
| **CODE** | Built in Remotion — no PNG; tweak layout in linked `.tsx` |

**How to use asset links:** Open the SOURCE file, compare to what you see in the trailer at **TC**, then note in **Notes / direction** e.g. *“use Talk 0:01–0:04 only, crop center 60%, faces upper third”*.

---

## Master outputs (open first)

| Role | Anya | 006 |
|---|---|---|
| **Final trailer** | [DOUBLAND1.mov](D:/Coding/generative_agents/video/opening-anya/DOUBLAND1.mov) · 76.6 s · 2160×3840 | [trailer_9x16.mp4](D:/Coding/generative_agents/data/base_family_sim/opener&006/output/trailer_9x16.mp4) · 82.4 s · 1080×1920 |
| **Poster still** | Concept ~0:15 in master | [poster.png](D:/Coding/generative_agents/data/base_family_sim/opener&006/output/poster.png) · frame @ **0:15** |
| **Narration** | [narration.mp3](D:/Coding/generative_agents/video/voiceover/auto_match_v3_warm/narration.mp3) + [timing JSON](D:/Coding/generative_agents/video/voiceover/auto_match_v3_warm/narration_timing.json) | [narration.mp3](D:/Coding/generative_agents/data/base_family_sim/opener&006/audio/narration.mp3) + [timing JSON](D:/Coding/generative_agents/data/base_family_sim/opener&006/audio/narration_timing.json) |
| **Music** | (embedded in CapCut export) | [music_anthem.mp3](D:/Coding/generative_agents/data/base_family_sim/opener&006/audio/music_anthem.mp3) · also [library copy](D:/Coding/generative_agents/video/audio/music_anthem.mp3) |
| **Props / edit map** | CapCut project (on request) | [base_family_sim__opener_006.json](D:/Coding/generative_agents/video/remotion/props/base_family_sim__opener_006.json) |
| **Concept ref still** | [montage_concept.png](D:/Coding/generative_agents/video/opening-anya/_teardown/montage_concept.png) | — |

**How to comment:** Fill **Notes / direction**. Shorthand: ✅ keep · ⚠️ tweak · ❌ redo · 🔇 audio · 🎨 visual · ⏱ pacing · ✂️ trim · 🔍 zoom

---

## A. Macro map (quick orientation)

| # | Section | Anya (approx) | 006 (actual) | Same story beat? |
|---:|---|---|---|---|
| 1 | Hook — three “What if” questions | 0:00–0:15 | 0:00–0:11 | Yes (006 merges into one visual sequence) |
| 2 | Concept — what is a Double | 0:15–0:24 | 0:11–0:19 | Yes (006 = split poster layout) |
| 3 | World + relationships | 0:24–0:37 | 0:19–0:32 | Partial (006 lacks live map HUD) |
| 4 | Season / Survival setup | 0:35–0:42 | 0:32–0:43 | Partial |
| 5 | Cast — four Pistsovs | 0:42–0:58 | 0:43–0:56 | Yes (different trait copy) |
| 6 | Pressure + relationships | 0:58–1:07 | 0:56–1:02 | Partial |
| 7 | Live / replay | (in world block) | 1:02–1:08 | 006 has dedicated aerial beat |
| 8 | Reflective turn | 1:07–1:14 | 1:08–1:14 | Yes |
| 9 | End card + CTA | 1:14–1:17 (~3s hold) | 1:14–1:22 (**4 s** hold) | Yes |

Anya hard-cut times (scene detection): `0 · 23.5 · 24.0 · 27.2 · 31.8 · 35.0 · 43.2 · 45.7 · 48.3 · 49.1 · 63.0 · 66.4 · 71.7 · 73.8`

---

## B. Beat-by-beat review sheet

### 1 · Hook — “second chance”

| | **Anya** | **006** |
|---|---|---|
| **TC** | **0:00 – 0:03** | **0:00 – 0:04** |
| **Narration** | *What if… you had a second chance to make it right?* | Same line |
| **Visual** | Black field → blue light ignition → profile ring / eclipse core → faint particles. **WHAT IF** types once, minimal glitch. | Dark field + particles. **WHAT IF** types (glitch only during reveal, then holds). AI core ring + matrix readout. Chat overlay faint in bg. No fade-in at hook start. |
| **Audio** | Soft whoosh on motif entry; music bed low | Music bed; no SFX yet |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Hook ignition line | [Asset4.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Asset4.png) **SOURCE** | [gold_ornament.png](D:/Coding/generative_agents/video/remotion/public/render/gold_ornament.png) (later beats) | Anya: horizontal blue flare, scale-X wipe once. **✂️** Use center band only; don’t hold full frame >0.5 s |
| Profile / eclipse ring | **REF** [Asset.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Asset.png) (motif board) | **CODE** [AiCoreRing.tsx](D:/Coding/generative_agents/video/remotion/src/components/AiCoreRing.tsx) | Recreate ring from board — don’t render 2×2 board. **🔍** Ring upper-center |
| Chat ambient | [Asset2.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Asset2.png) **SOURCE** | [asset_orb.png](D:/Coding/generative_agents/video/remotion/public/render/asset_orb.png) @ ~18–20% opacity | **✂️** Crop bubble cluster; animate individual bubbles if static |
| Particles | — (CapCut) | **CODE** [ParticleField.tsx](D:/Coding/generative_agents/video/remotion/src/components/ParticleField.tsx) | Ambient only — must not compete with headline |
| Headline | — | **CODE** [GlitchText.tsx](D:/Coding/generative_agents/video/remotion/src/components/GlitchText.tsx) · [HookContinuous.tsx](D:/Coding/generative_agents/video/remotion/src/beats/HookContinuous.tsx) | Glitch **during** type only; verify hold @ 006 **0:03–0:04** |
| Matrix readout | — | **CODE** [MatrixReadout.tsx](D:/Coding/generative_agents/video/remotion/src/components/MatrixReadout.tsx) | Lines appear from 0:00; hide during Talk phase (006) |

---

### 2 · Hook — “hard conversation” (Talk hero)

| | **Anya** | **006** |
|---|---|---|
| **TC** | **0:03 – 0:08** | **0:04 – 0:09** |
| **Narration** | *What if you could practice that hard conversation before it ever happened?* | Same |
| **Visual** | **`Talk.mp4` hero** — full-frame ~75%+. Conversation → relationship nodes. | **`Talk.mp4` hero** @ ~0.75–0.82 opacity, vertical crop. Phrase swaps on headline. |
| **Audio** | Digital reveal / whoosh | **SFX @ 0:04** — digital_reveal |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| **Talk hero clip** | [Talk.mp4](D:/Coding/generative_agents/video/opening-anya/Anya_animated/Talk.mp4) **SOURCE** · 1848×1120 · 24 fps · **~5.0 s** landscape | [talk.mp4](D:/Coding/generative_agents/video/remotion/public/render/talk.mp4) | **✂️** Prefer **0:00–0:04** or best dialogue beat; don’t loop past 5 s. **🔍** Vertical crop: `objectPosition: center 42%` — keep **both faces** in upper half. Opacity ≥0.75. Compare SOURCE vs 006 **0:04–0:09** |
| Chat fallback still | [Asset3.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Asset3.png) | — | Freeze-frame end of Talk if clip too short |
| Chat overlay | [Asset2.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Asset2.png) | (faded during Talk) | Secondary layer only — not on top of faces |
| Relationship (Anya) | **REF** [Connections.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Connections.png) | — | Anya morphs into graph — don’t use board full-frame |
| Relationship (006) | — | **CODE** [RelationshipGraph.tsx](D:/Coding/generative_agents/video/remotion/src/components/RelationshipGraph.tsx) | Not shown during Talk hero in 006 |
| SFX | CapCut library | [sfx_0_digital_reveal.mp3](D:/Coding/generative_agents/video/remotion/public/render/sfx_0_digital_reveal.mp3) @ **0:04** | **🔇** Should lead visual by ~2–6 frames |

---

### 3 · Hook — “What if you had a Double?”

| | **Anya** | **006** |
|---|---|---|
| **TC** | **0:08 – 0:15** | **0:09 – 0:11** |
| **Narration** | *What if you had a Double?* | Same |
| **Visual** | Network diagram → ink figures → **`Double.png`** glow. Continuous hook. | Ink figures + AI core. **WHAT IF / YOU HAD A DOUBLE?** Crossfade to concept. |
| **Audio** | Whoosh into concept | **SFX @ 0:09** — whoosh_soft |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Network / silhouettes | **REF** [Asset.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Asset.png) | **CODE** [InkFigures.tsx](D:/Coding/generative_agents/video/remotion/src/components/InkFigures.tsx) | Split motifs from board; ink figures lower third |
| Double wordmark tease | [Double.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Double.png) | — (appears next beat) | Anya: glow begins end of hook; **🔍** center, hold still |
| AI core | — | **CODE** [AiCoreRing.tsx](D:/Coding/generative_agents/video/remotion/src/components/AiCoreRing.tsx) | One pulse into handoff — no infinite pulse |
| SFX | — | [sfx_1_whoosh_soft.mp3](D:/Coding/generative_agents/video/remotion/public/render/sfx_1_whoosh_soft.mp3) @ **0:09** | Handoff into concept poster |

---

### 4 · Concept / poster frame

| | **Anya** | **006** |
|---|---|---|
| **TC** | **0:15 – 0:24** | **0:11 – 0:19** |
| **Narration** | *An AI version of you — talking like you. Reacting like you. Making choices like you.* | Same |
| **Visual** | **`Double.png`** + portrait cards + matrix group. **YouTube poster** intent. | Split poster: matrix top / black band / clean photo bottom. [poster.png](D:/Coding/generative_agents/data/base_family_sim/opener&006/output/poster.png) @ **0:15**. |
| **Audio** | Typing / chime | **SFX @ 0:11** — typing |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Group photo (clean) | [Family.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Family.png) **SOURCE** | [family.png](D:/Coding/generative_agents/video/remotion/public/render/family.png) | Bottom third + poster export. **🔍** Faces center; safe for 9:16 crop |
| Group motion (once) | [Family.mp4](D:/Coding/generative_agents/video/opening-anya/Anya_animated/Family.mp4) · 1764×1172 · **~5 s** | [family_anim.mp4](D:/Coding/generative_agents/video/remotion/public/render/family_anim.mp4) | **✂️** Use **once** only (top band). **✂️** 0:00–0:05 max; subtle motion. **🔍** Crop to group center |
| Cohort cutout layer | [Photoroom_20260611_151820.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Photoroom_20260611_151820.png) | — (not wired in 006) | Anya foreground separation — candidate for P1 |
| DOUBLE wordmark | [Double.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Double.png) | [double_wordmark.png](D:/Coding/generative_agents/video/remotion/public/render/double_wordmark.png) | Black band center. Entry glow **once** then hold @ **0:14–0:16** |
| Portrait cards (Anya) | **REF** [Cards1.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Cards1.png) · [Cards3.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Cards3.png) | — | Trait card layout reference |
| Init progress board | **REF** [Profile.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Profile.png) | — | P1 `CohortInitializationProgress` |
| Poster layout | [montage_concept.png](D:/Coding/generative_agents/video/opening-anya/_teardown/montage_concept.png) | **CODE** [ConceptPoster.tsx](D:/Coding/generative_agents/video/remotion/src/beats/ConceptPoster.tsx) | Compare 006 [poster.png](D:/Coding/generative_agents/data/base_family_sim/opener&006/output/poster.png) vs montage |
| Phrase captions | — | **CODE** [WordSwapTitles.tsx](D:/Coding/generative_agents/video/remotion/src/components/WordSwapTitles.tsx) | TALKING / REACTING / CHOOSING — settle on last phrase |
| SFX | — | [sfx_2_typing.mp3](D:/Coding/generative_agents/video/remotion/public/render/sfx_2_typing.mp3) @ **0:11** vol 0.35 | Subtle — not on every keystroke |

---

### 5 · World — create your Double

| | **Anya** | **006** |
|---|---|---|
| **TC** | **0:24 – 0:28** | **0:19 – 0:24** |
| **Narration** | *In Doubland, you create an AI Double based on your personality.* | Same |
| **Visual** | Group → **`Village.mp4`** → handoff to map | **`Village.mp4`** full-frame + push-in |
| **Audio** | Fly-over whoosh | Music only |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Village establishing | [Village.mp4](D:/Coding/generative_agents/video/opening-anya/Anya_animated/Village.mp4) · 1264×720 · **~3 s** top-down | [village.mp4](D:/Coding/generative_agents/video/remotion/public/render/village.mp4) | **✂️** Full clip ~3 s — don’t slow below readable motion. **🔍** Vertical crop + push-in ([PushIn.tsx](D:/Coding/generative_agents/video/remotion/src/components/PushIn.tsx)). Bridge **into** map on Anya — 006 holds village only |
| Map handoff (Anya) | **REF** [Map.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Map.png) | — | P1 `WorldMapHUD` — never full board as static bg |

---

### 6 · World — watch live with other Doubles

| | **Anya** | **006** |
|---|---|---|
| **TC** | **0:28 – 0:32** | **0:24 – 0:28** |
| **Narration** | *Then you watch it live in a world with other Doubles.* | Same |
| **Visual** | **`Map.png`** + live UI drift | **`Village.mp4`** continues + gold wipe |
| **Audio** | UI pulse | Music |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Map + HUD (Anya) | **REF** [Map.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Map.png) | — | **🔍** Animate drift on map; crop to lower relationship panel for legibility |
| Village (006) | [Village.mp4](D:/Coding/generative_agents/video/opening-anya/Anya_animated/Village.mp4) | [village.mp4](D:/Coding/generative_agents/video/remotion/public/render/village.mp4) | Same clip as §5 — **✂️** consider **second 1–3 s** of source for variety vs §5 |
| Gold chapter wipe | [Asset4.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Asset4.png) | [gold_ornament.png](D:/Coding/generative_agents/video/remotion/public/render/gold_ornament.png) | **CODE** [GoldTransition.tsx](D:/Coding/generative_agents/video/remotion/src/components/GoldTransition.tsx) — one sweep, not loop |

---

### 7 · World — every conversation / choice / relationship

| | **Anya** | **006** |
|---|---|---|
| **TC** | **0:32 – 0:37** | **0:28 – 0:32** |
| **Narration** | *Every conversation. Every choice. Every relationship.* | Same |
| **Visual** | Map + animated relationship diagram | Live **RelationshipGraph** component |
| **Audio** | Connection pulse | Music |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Relationship UI (Anya) | **REF** [Connections2.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Connections2.png) · [Connections.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Connections.png) | — | Use as module layout ref — rebuild in code |
| Relationship graph (006) | — | **CODE** [RelationshipGraph.tsx](D:/Coding/generative_agents/video/remotion/src/components/RelationshipGraph.tsx) | ⚠️ Label bug in 006 props — verify names vs nodes @ **0:28–0:32** |
| Decision tree (Anya) | **REF** [Connections2.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Connections2.png) (lower-right) | — | P1 for “making choices” beat |

---

### 8 · Season — Survival Mode setup

| | **Anya** | **006** |
|---|---|---|
| **TC** | **0:35 – 0:42** | **0:32 – 0:43** |
| **Narration** | *This season: the Pistsov family enters Survival Mode…* | Same |
| **Visual** | **Survival banner** + **dashboard** scan + **Family.mp4** warmth | **Village.mp4** + gold wipe; phrase swaps |
| **Audio** | Impact / riser | Music |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Survival banner | **REF** [Survival.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Survival.png) (top plate) | — | P1 `SeasonModeBanner` — split from PNG |
| Season dashboard | **REF** [Cards2.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Cards2.png) | — | P1 `SurvivalDashboard` — **✂️** 3 editorial crops, 2.5–4 s total |
| Family warmth (Anya) | [Family.mp4](D:/Coding/generative_agents/video/opening-anya/Anya_animated/Family.mp4) | — (006 used only @ concept) | Anya: human moment **before** cast split — note if 006 should repeat here |
| Village bg (006) | [Village.mp4](D:/Coding/generative_agents/video/opening-anya/Anya_animated/Village.mp4) | [village.mp4](D:/Coding/generative_agents/video/remotion/public/render/village.mp4) | Long hold **0:32–0:43** — flag if too static |

---

### 9 · Cast — Gosha

| | **Anya** | **006** |
|---|---|---|
| **TC** | **0:42 – 0:45** | **0:43 – 0:46** |
| **Narration** | *Gosha **thinks three moves ahead**.* | *Gosha **solves complex problems instantly**.* |
| **Visual** | Cut-out + identity card frame | Cut-out slide-in, no HUD frame |
| **Audio** | Whoosh | **SFX @ 0:43** |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Identity card style (Anya) | [Gosha .png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Gosha%20.png) · **REF** [Cards1.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Cards1.png) | — | Card frame ref — **323 px wide, don’t upscale**; rebuild in code |
| Cut-out (006) | [cutouts/d4407efa….png](D:/Coding/generative_agents/video/assets/users/cutouts/d4407efa-cf0f-4133-ba6a-7f6c90d06a33.png) or [full_body_standing.png](D:/Coding/generative_agents/video/assets/users/character-sheets/d4407efa-cf0f-4133-ba6a-7f6c90d06a33/full_body_standing.png) | [portrait_0_gosha.png](D:/Coding/generative_agents/video/remotion/public/render/portrait_0_gosha.png) | **🔍** Full-body, height ~1180 px in comp. Grey flatten OK? Face readable on mobile? |
| Sketch fallback | [sketches/d4407efa….png](D:/Coding/generative_agents/video/assets/users/sketches/d4407efa-cf0f-4133-ba6a-7f6c90d06a33.png) | — | |
| Cast beat code | — | **CODE** [AnyaBeats.tsx](D:/Coding/generative_agents/video/remotion/src/beats/AnyaBeats.tsx) `AnyaCastBeat` | Slide from right; trait in gold |
| SFX | — | [sfx_3_whoosh_soft.mp3](D:/Coding/generative_agents/video/remotion/public/render/sfx_3_whoosh_soft.mp3) @ **0:43** | |

---

### 10 · Cast — Ivan

| | **Anya** | **006** |
|---|---|---|
| **TC** | **0:45 – 0:48** | **0:46 – 0:50** |
| **Narration** | *Ivan **refuses to lose**.* | *Ivan **rehearses every pitch until flawless**.* |
| **Visual** | Identity card; alternate entry direction | Same cut-out pattern |
| **Audio** | Whoosh | **SFX @ 0:46** |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Card style (Anya) | [Iván.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Iv%C3%A1n.png) | — | |
| Cut-out (006) | [cutouts/8af61baf….png](D:/Coding/generative_agents/video/assets/users/cutouts/8af61baf-667d-4730-914d-ea8dccfd4d43.png) | [portrait_1_ivan.png](D:/Coding/generative_agents/video/remotion/public/render/portrait_1_ivan.png) | Vary entry direction vs Gosha (Anya) — 006 same slide pattern |
| SFX | — | [sfx_4_whoosh_soft.mp3](D:/Coding/generative_agents/video/remotion/public/render/sfx_4_whoosh_soft.mp3) @ **0:46** | |

---

### 11 · Cast — Katya

| | **Anya** | **006** |
|---|---|---|
| **TC** | **0:48 – 0:50** | **0:50 – 0:52** |
| **Narration** | *Katya **knows how to move people**.* | *Katya **tries every new craft**.* |
| **Visual** | Same card system | Same cut-out pattern |
| **Audio** | Whoosh | **SFX @ 0:50** |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Card style (Anya) | [Dasha.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Dasha.png) *(label says KATYA)* | — | Filename ≠ baked label — use sim data only |
| Cut-out (006) | [cutouts/dfc32e65….png](D:/Coding/generative_agents/video/assets/users/cutouts/dfc32e65-8854-4033-bf23-f6f84a8c4a76.png) | [portrait_2_katya.png](D:/Coding/generative_agents/video/remotion/public/render/portrait_2_katya.png) | |
| SFX | — | [sfx_5_whoosh_soft.mp3](D:/Coding/generative_agents/video/remotion/public/render/sfx_5_whoosh_soft.mp3) @ **0:50** | |

---

### 12 · Cast — Luba

| | **Anya** | **006** |
|---|---|---|
| **TC** | **0:50 – 0:58** | **0:52 – 0:56** |
| **Narration** | *Luba **stays calm — until everyone realizes they underestimated her**.* | *Luba **organizes everyone's day down to minutes**.* |
| **Visual** | Longest card; handoff to gauge | Shorter beat (~3.7 s) |
| **Audio** | Whoosh → gauge riser | **SFX @ 0:52** |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Card style (Anya) | [Luba.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Luba.png) | — | |
| Cut-out (006) | [cutouts/0860c8a7….png](D:/Coding/generative_agents/video/assets/users/cutouts/0860c8a7-c0ea-4ce7-96a4-dd7c09ab8775.png) | [portrait_3_luba.png](D:/Coding/generative_agents/video/remotion/public/render/portrait_3_luba.png) | Anya holds ~8 s — 006 much shorter; **⏱** trait line pacing |
| Trait cards ref | **REF** [Cards3.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Cards3.png) | — | P1 personality trait panel |
| SFX | — | [sfx_6_whoosh_soft.mp3](D:/Coding/generative_agents/video/remotion/public/render/sfx_6_whoosh_soft.mp3) @ **0:52** | |

---

### 13 · Pressure — change under pressure

| | **Anya** | **006** |
|---|---|---|
| **TC** | **0:58 – 1:02** | **0:56 – 0:58** |
| **Narration** | *See how people change under pressure.* | Same |
| **Visual** | **`Pressure.mp4`** + gauge sweep — visual **peak** | **`Pressure.mp4`** + **PressureGauges** overlay |
| **Audio** | Low impact / riser @ red zone | **SFX @ 0:56** — impact_low |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| **Pressure clip** | [Pressure.mp4](D:/Coding/generative_agents/video/opening-anya/Anya_animated/Pressure.mp4) · 1076×**1928** · **~3 s** near-vertical | [pressure.mp4](D:/Coding/generative_agents/video/remotion/public/render/pressure.mp4) | **✂️** One needle sweep **low → critical**; sync impact to red zone @ ~2 s. **🔍** Full height hero @ 85% opacity. Compare peak energy Anya **0:58** vs 006 **0:56** |
| Gauge overlay (006) | — | **CODE** [PressureGauges.tsx](D:/Coding/generative_agents/video/remotion/src/components/PressureGauges.tsx) | CONTROL / EMOTIONAL labels — one sweep then hold |
| SFX | — | [sfx impact from props](D:/Coding/generative_agents/video/remotion/public/render/) @ **0:56** | Match gauge hit |

---

### 14 · Pressure — relationships in the game

| | **Anya** | **006** |
|---|---|---|
| **TC** | **1:02 – 1:07** | **0:58 – 1:02** |
| **Narration** | *See what happens when relationships become part of the game.* | Same |
| **Visual** | Relationship delta toast + map alerts | Same **Pressure.mp4** clip (second beat) |
| **Audio** | Pulse SFX | Music |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Relationship toast (Anya) | **REF** [Connections.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Connections.png) | — | P1 `RelationshipDeltaToast` — 0.8–1.5 s |
| Pressure (006) | [Pressure.mp4](D:/Coding/generative_agents/video/opening-anya/Anya_animated/Pressure.mp4) | [pressure.mp4](D:/Coding/generative_agents/video/remotion/public/render/pressure.mp4) | **✂️** If reusing clip, **offset start** (e.g. 1:02–1:04 of source) or transition to still — avoid obvious loop |

---

### 15 · Live / replay (006-only beat)

| | **Anya** | **006** |
|---|---|---|
| **TC** | *(in map ~0:59–1:05)* | **1:02 – 1:08** |
| **Narration** | *Watch live 24/7. Follow any Double. Replay every moment.* | Same |
| **Visual** | Map focus + **Replay** control on “Replay” line only | **Aerial village** + live HUD |
| **Audio** | Chime / UI tick | Music |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Replay control (Anya) | [F1714AC2-78E4-434B-844C-30F0A03D4DD7.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/F1714AC2-78E4-434B-844C-30F0A03D4DD7.png) | — | **Only** on “Replay every moment” — not end card |
| Aerial b-roll (006) | [cinematic_village_aerial_tudor.mp4](D:/Coding/generative_agents/video/fly-over/cinematic_village_aerial_tudor.mp4) | [aerial.mp4](D:/Coding/generative_agents/video/remotion/public/render/aerial.mp4) | **✂️** Night windows / glow — **🔍** center crop 9:16. **✂️** Trim to 6 s max |
| Live HUD (006) | — | **CODE** [LiveHudOverlay.tsx](D:/Coding/generative_agents/video/remotion/src/components/LiveHudOverlay.tsx) | Corner brackets + LIVE badge |

---

### 16 · Turn — not just avatars

| | **Anya** | **006** |
|---|---|---|
| **TC** | **1:07 – 1:10** | **1:08 – 1:10** |
| **Narration** | *These aren't just avatars.* | Same |
| **Visual** | Day map widens; overlays peel back | **Village.mp4** + caption |
| **Audio** | Music softens | Music |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Map wide (Anya) | **REF** [Map.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Map.png) | — | Reduce overlay density — calmer frame |
| Village (006) | [Village.mp4](D:/Coding/generative_agents/video/opening-anya/Anya_animated/Village.mp4) | [village.mp4](D:/Coding/generative_agents/video/remotion/public/render/village.mp4) | Third use of same clip — note repetition |

---

### 17 · Turn — learn / change / surprise

| | **Anya** | **006** |
|---|---|---|
| **TC** | **1:10 – 1:14** | **1:10 – 1:14** |
| **Narration** | *They learn. They change. They surprise you.* | Same |
| **Visual** | Map + personality updates | Phrase swaps + faint graph |
| **Audio** | Music dip | Music |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Analysis panel (Anya) | **REF** [Cards4.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Cards4.png) | — | P1 `PersonalityAnalysisPanel` |
| Graph (006) | — | **CODE** [RelationshipGraph.tsx](D:/Coding/generative_agents/video/remotion/src/components/RelationshipGraph.tsx) @ 45% opacity | Brief pulse on one edge |

---

### 18 · End card

| | **Anya** | **006** |
|---|---|---|
| **TC** | **1:14 – 1:17** (~**3 s** hold) | **1:14 – 1:22** (**4 s** hold) |
| **Narration** | *…what would MY Double do?* | Same |
| **Visual** | **DOUBLAND** logo → **URL** plate; static hold | **DOUBLAND2** URL + question; scale settle |
| **Audio** | Logo chime; music out | **SFX @ 1:15** logo_resolve; 4 s fade |
| **Notes / direction** | | |

**Assets**

| Role | Source file(s) | 006 staged | Spec / trim & zoom notes |
|---|---|---|---|
| Logo plate (Anya) | [DOUBLAND.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/DOUBLAND.png) | — | Simulation-active mark — generous safe area |
| URL plate | [DOUBLAND2.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/DOUBLAND2.png) | [end_card.png](D:/Coding/generative_agents/video/remotion/public/render/end_card.png) | **🔍** URL readable ≥1.5 s @ **1:16–1:20**. Anya ~3 s total hold vs 006 **4 s** |
| End card code | — | **CODE** [AnyaBeats.tsx](D:/Coding/generative_agents/video/remotion/src/beats/AnyaBeats.tsx) `AnyaEndCard` | Question types first; URL after; no pulse after settle |
| SFX | — | logo_resolve staged file @ **1:15** | Single clean resolve |

---

## C. Cross-cutting comparison (fill after first pass)

| Dimension | Anya | 006 | Winner / notes |
|---|---|---|---|
| **Overall runtime** | 76.6 s | 82.4 s | ⏱ ~6 s longer on 006 — acceptable per policy |
| **Hook continuity** | One morph 0–15 s | One sequence 0–11 s | |
| **Talk beat prominence** | Hero | Hero @ 0.75+ | Compare [Talk.mp4](D:/Coding/generative_agents/video/opening-anya/Anya_animated/Talk.mp4) SOURCE vs 006 **0:04–0:09** |
| **Poster / thumbnail** | [montage_concept.png](D:/Coding/generative_agents/video/opening-anya/_teardown/montage_concept.png) | [poster.png](D:/Coding/generative_agents/data/base_family_sim/opener&006/output/poster.png) | |
| **Text settle** | Reference | Phase 5 — verify on scrub | |
| **Map / Survival UI** | REF boards → dynamic | Not built (P1) | |
| **Cast card frame** | Anya PNG examples | Plain cut-out | |
| **Trait copy** | [auto_match timing](D:/Coding/generative_agents/video/voiceover/auto_match_v3_warm/narration_timing.json) | [006 timing](D:/Coding/generative_agents/data/base_family_sim/opener&006/audio/narration_timing.json) | |
| **SFX punctuation** | CapCut | 7 wired SFX in props | |
| **Mix loudness** | ~-13.1 LUFS | ~-13.9 LUFS | |

---

## D. Priority feedback buckets (for next sprint)

| Priority | Theme | Your notes |
|---|---|---|
| **P0** | Hook / Talk / poster / text settle | |
| **P0** | End card length & logo treatment | |
| **P1** | Map HUD, Survival dashboard, identity cards | |
| **P1** | Trait line lock vs regenerate; graph label bug | |
| **P2** | VO A/B — compare [v3_trailer_x1.5](D:/Coding/generative_agents/video/opening-anya/_teardown/cand/) vs warm | |
| **P2** | Resolution / fps delivery | |

---

## E. Master asset index (all production files)

### Motion clips (direct use)

| File | Size / fps / dur | Role | Playbook trim guidance |
|---|---|---|---|
| [Talk.mp4](D:/Coding/generative_agents/video/opening-anya/Anya_animated/Talk.mp4) | 1848×1120 · 24p · ~5s | Hard-conversation hook | Hero ≥75%; vertical crop; **0:00–0:04** sweet spot |
| [Family.mp4](D:/Coding/generative_agents/video/opening-anya/Anya_animated/Family.mp4) | 1764×1172 · 24p · ~5s | Cohort reveal **once** | HUD frame; don’t repeat in season block |
| [Village.mp4](D:/Coding/generative_agents/video/opening-anya/Anya_animated/Village.mp4) | 1264×720 · 24p · ~3s | World bridge | Push-in; bridge to map; don’t loop visibly |
| [Pressure.mp4](D:/Coding/generative_agents/video/opening-anya/Anya_animated/Pressure.mp4) | 1076×1928 · 24p · ~3s | Pressure peak | One sweep; impact @ red zone |
| [cinematic_village_aerial_tudor.mp4](D:/Coding/generative_agents/video/fly-over/cinematic_village_aerial_tudor.mp4) | (fly-over) | Live / night beat | 9:16 center crop |

### Brand & overlay PNGs (direct use)

| File | Role |
|---|---|
| [Asset4.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Asset4.png) | Blue light wipe / chapter transition |
| [Asset2.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Asset2.png) | Chat bubble overlay |
| [Asset3.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Asset3.png) | Conversation still / Talk freeze |
| [Double.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Double.png) | DOUBLE wordmark |
| [DOUBLAND.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/DOUBLAND.png) | Logo plate |
| [DOUBLAND2.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/DOUBLAND2.png) | URL end card |
| [Family.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Family.png) | Clean group photo |
| [Photoroom_20260611_151820.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Photoroom_20260611_151820.png) | Transparent group cutout |
| [F1714AC2-78E4-434B-844C-30F0A03D4DD7.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/F1714AC2-78E4-434B-844C-30F0A03D4DD7.png) | REPLAY control |

### Reference boards (design only — **REF**)

[Asset.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Asset.png) · [Cards1.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Cards1.png) · [Cards2.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Cards2.png) · [Cards3.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Cards3.png) · [Cards4.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Cards4.png) · [Cards5.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Cards5.png) · [Connections.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Connections.png) · [Connections2.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Connections2.png) · [Map.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Map.png) · [Profile.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Profile.png) · [Survival.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Survival.png)

### Cast portraits (Anya examples + 006 cut-outs)

| Person | Anya card example | 006 cut-out source | 006 staged |
|---|---|---|---|
| Gosha | [Gosha .png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Gosha%20.png) | [d4407efa…](D:/Coding/generative_agents/video/assets/users/cutouts/d4407efa-cf0f-4133-ba6a-7f6c90d06a33.png) | portrait_0_gosha.png |
| Ivan | [Iván.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Iv%C3%A1n.png) | [8af61baf…](D:/Coding/generative_agents/video/assets/users/cutouts/8af61baf-667d-4730-914d-ea8dccfd4d43.png) | portrait_1_ivan.png |
| Katya | [Dasha.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Dasha.png) | [dfc32e65…](D:/Coding/generative_agents/video/assets/users/cutouts/dfc32e65-8854-4033-bf23-f6f84a8c4a76.png) | portrait_2_katya.png |
| Luba | [Luba.png](D:/Coding/generative_agents/video/opening-anya/Anya_PNG_assets/Luba.png) | [0860c8a7…](D:/Coding/generative_agents/video/assets/users/cutouts/0860c8a7-c0ea-4ce7-96a4-dd7c09ab8775.png) | portrait_3_luba.png |

*Staged portraits live under* `D:/Coding/generative_agents/video/remotion/public/render/` *after each props build.*

### Audio library

| File | Role |
|---|---|
| [music_anthem.mp3](D:/Coding/generative_agents/video/audio/music_anthem.mp3) | Bed @ 30% in 006 |
| [audio/sfx/](D:/Coding/generative_agents/video/audio/sfx/) | Raw SFX (if present) |
| [audio/sfx_trimmed/](D:/Coding/generative_agents/video/audio/sfx_trimmed/) | Trimmed SFX per playbook |
| VO A/B refs | [video_audio.wav](D:/Coding/generative_agents/video/opening-anya/_teardown/video_audio.wav) · [v3_trailer_x1.2.wav](D:/Coding/generative_agents/video/opening-anya/_teardown/cand/v3_trailer_x1.2.wav) |

### Remotion components (layout / motion code)

[OpenerTrailer.tsx](D:/Coding/generative_agents/video/remotion/src/OpenerTrailer.tsx) · [HookContinuous.tsx](D:/Coding/generative_agents/video/remotion/src/beats/HookContinuous.tsx) · [ConceptPoster.tsx](D:/Coding/generative_agents/video/remotion/src/beats/ConceptPoster.tsx) · [AnyaBeats.tsx](D:/Coding/generative_agents/video/remotion/src/beats/AnyaBeats.tsx) · [asset_manifest.py](D:/Coding/generative_agents/video/asset_manifest.py)

---

## F. Review session log

| Date | Reviewers | Version | Top 3 actions |
|---|---|---|---|
| | Ivan + Anya | 006 vs DOUBLAND1 | 1. · 2. · 3. |

---

*Updated 2026-06-24 — asset links + trim/zoom notes from Playbook §16.3 and `opener&006` props. STAGED paths under `public/render/` are rebuilt on each render; SOURCE paths are stable.*
