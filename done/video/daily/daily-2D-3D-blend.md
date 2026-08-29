# Daily trailer — 2D↔3D blend grammar

> **North-star (all trailer types):** `video/sot-video.md` §0.2 **L8** — viewers watch Phaser and see real life.  
> **Brand philosophy:** [video_playbook.md](video_playbook.md) §Core 2D↔Cinematic Visual System.  
> **Applies to:** **[B] `day_normal`** and **[C] `day_survival`** dailies (especially [C] arc beats). Opener [A] uses matrix + cinematic tease, not this beat-level clip system.

Execution rules for when and how daily trailers blend 2D sketch/Phaser cards with 3D cinematic clips.

**Status:** Archived grammar. Live producer TODO is [`../../video/TODO_2D-3D.md`](../../video/TODO_2D-3D.md) (post-MVP). Locked daily literacy is `video/SOT-video.md` §3.6. Do not brief the next bake from this file.

---

## 1. Which beats get clips

The daily trailer has two layers: the **establishing layer** (concept reset +
cast intro cards) and the **arc** (yesterday_scar → today_pressure →
apparent_plan → countermove → vote_reveal → new_imbalance).

| Beat | Clip-eligible? | Rationale |
|---|---|---|
| concept_reset | No | Title/identity card — pure 2D brand frame |
| cast_intro | No | Identity reveal — the sketch portrait IS the point |
| yesterday_scar | Optional | "Previously on" cold-open can use a clip for impact |
| today_pressure | **Yes** | The day's central tension — highest clip priority |
| pressure_peak | **Yes** | Non-elimination climax — highest clip priority |
| apparent_plan | Optional | Strategic beat — clip only if the plan is visual |
| countermove | **Yes** | The pivot — strong clip candidate |
| vote_reveal | **Yes** | The payoff — clip if elimination is dramatic |
| new_imbalance | Optional | Cliffhanger setup — clip for the lingering question |

**Rule of thumb:** 1–3 clips per day. Too many clips dilute the "special
moment" effect — the trailer should feel mostly 2D with punctuated cinematic
reveals, not a sequence of film scenes.

---

## 2. Transition grammar

The 2D→3D and 3D→2D transitions are the storytelling language. Two primary
transitions for the daily format:

### 2.1 Camera dive (2D → 3D)

Push into the 2D sketch/portrait until the pixelated surface resolves into
cinematic detail — skin texture, fabric, environmental light. The viewer
understands they are "entering" the moment.

- **Trigger:** the narration lands on the beat's emotional core (e.g., "Max
  feels the pressure" → dive into Max's sketch).
- **Duration:** ~0.5s dive, then the clip plays for the beat's remaining
  duration.
- **Continuity:** the sketch portrait and the clip's first frame must share
  pose, orientation, and lighting direction. The Grok Imagine prompt (B4)
  should reference the sketch as the source image.

### 2.2 Pixel fracture (3D → 2D)

The cinematic clip breaks into pixel blocks and returns to the 2D world. The
viewer understands they are "stepping back" to observe the system.

- **Trigger:** the clip's beat ends and the next beat begins.
- **Duration:** ~0.3s fracture, then the next 2D card appears.
- **Variation:** for the final beat (new_imbalance), the fracture can linger —
  the last pixel block holds as the end card appears, leaving the viewer in
  the liminal space between simulation and story.

### 2.3 Hard cut (alternative)

For rapid-pace beats (vote_reveal on an elimination day), a hard cut from 2D
to the clip is acceptable — the drama doesn't need a soft transition. Use
sparingly; the camera dive is the default.

---

## 3. Continuity rules (from playbook §1)

Every 2D→3D transition must preserve:

- **Character position** — the clip's subject is in the same place the sketch
  implied
- **Body orientation** — facing the same direction
- **Time of day** — the clip's lighting matches the beat's time of day (from
  the day_log's timeline entry)
- **Emotional state** — the clip's expression matches the beat's mood
- **Location** — the clip's environment matches the beat's resolved location
  (B2's `location` field)

The location field (B2) feeds the Grok Imagine prompt's environmental
description. If the location is "Hobbs Cafe," the clip's background should be
a cafe interior, not a generic setting.

---

## 4. Clip sourcing

### 4.1 Manual (B1 — current)

Ivan hand-generates 1–3 clips per day using Grok Imagine's image-to-video or
reference-to-video API, drops them at:

```
video/assets/moment_clips/<sim_code>/<day>/beat_<scene_id>.mp4
```

The build pipeline detects them automatically and overrides the generic opener
loop for that beat. No code changes needed per clip.

### 4.2 Automated (B4 — fast-follow)

A script will automate clip generation:
1. Read the beat's resolved location, mood, focus persona, and sketch
2. Construct a Grok Imagine prompt referencing the sketch as the source image
3. Call the image-to-video API (single source) or reference-to-video (sketch +
   location plate)
4. Save the result to the B1 convention path
5. The next render picks it up automatically

**API choice:**
- **Image-to-video** when the sketch portrait is the primary subject (most
  arc beats — the clip is about the persona's emotional moment)
- **Reference-to-video** when the environment matters as much as the persona
  (vote_reveal, pressure_peak — the location is part of the story)

**Duration limit:** Grok Imagine supports 5–6s clips. The beat's duration is
typically 8–15s, so the clip plays for its full length and the remaining
seconds use the 2D card with a slow push-in. This is intentional — the clip
is a punctuation mark, not the whole sentence.

---

## 5. Visual rhythm

The daily trailer's visual-change rate (C2 editorial-motion gate) is currently
~2.8/min — far below the opener's ~23.5/min reference. The 2D→3D blend is one
lever; the other is increasing motion within the 2D cards themselves (motivated
transitions, multi-layer depth, type-then-hold with kinetic timing).

**Target blend rhythm:**
- 2D card with slow push-in: ~8–12s per beat (current)
- 2D→3D camera dive: ~0.5s
- 3D clip: ~5–6s (Grok Imagine limit)
- 3D→2D pixel fracture: ~0.3s
- Net effect: each clip-eligible beat gains ~2–3 additional visual changes
  (dive + clip + fracture), lifting the rate from ~2.8/min toward ~6–8/min
  with 2 clips in a survival daily up to ~120s

This won't reach the opener's 23.5/min — the daily is a slower, more
contemplative format by design. But it should clear the 16/min SOT floor
(§9.2) once both the blend and the intra-card motion improvements land.

---

## 6. What stays 2D

The establishing layer (concept_reset, cast_intro) is permanently 2D. These
beats establish identity, not experience. The sketch portrait IS the brand
language for "this is a Double" — rendering it in 3D would break the
metaphor (a Double is a pixelated version of you, not a cinematic one).

The cast panel (the small portrait row at the bottom of world/turn beats)
also stays 2D — it's a HUD element, not a narrative frame.

---

## 7. Open creative questions

1. **Clip aspect ratio:** Grok Imagine outputs 16:9 by default; the daily
   trailer is 9:16. Do we crop, letterbox, or prompt for vertical? Currently
   unresolved — needs a test render.

2. **Clip audio:** Do clips carry their own audio (ambient cafe sound,
   dialogue fragments) or stay silent with the narration + music bed on top?
   Recommendation: silent clips — the narration is the voice; the clip is
   the image.

3. **Clip repetition:** Can the same clip be reused across days (e.g., a
   generic "cafe interior" plate)? Recommendation: no — each clip should be
   beat-specific to maintain the "this happened today" authenticity.
