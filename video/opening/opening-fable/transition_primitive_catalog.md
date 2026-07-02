# Transition primitive catalog (Remotion targets)

All timecodes from `DOUBLAND1.mov` master. "Persists" = layer keeps rendering across the transition with no opacity dip.

| Primitive | Trigger | Typical duration | What persists | What replaces | Example timecodes |
|---|---|---|---|---|---|
| `sharedCenterReplace` | New phrase/object owns the central axis | 0.2–0.4s swap | Background, HUD accents, center-axis position | Center text/object only | 0.9, 2.33, 9.4 |
| `persistentLayerSwap` | Section continues but one zone updates | 0.3–0.6s | Anchor layer (figures, family photo, hero clip, map) | One UI/text zone | 4.8–8.6, 11.0–18.5, 27.2–31.8, 57.0–59.4, 72.7 |
| `uiStateMorph` | Same UI slot changes content/state | 0.3–0.5s morph, no cut | UI frame + anchor layer | Card contents / label / feed rows | 28.6, 30.0, 38.3, 50.2, 68.2–71.7 |
| `cardSelectZoom` | Cursor selects an identity card | 0.6–0.8s bridge → 1.8–2.3s character hold | Gray backdrop palette | Panel → full-body character (blur-in settle) | 43.2→43.9, 45.7→46.3, 48.3→49.1 |
| `panelReturn` | Character beat ends | 0.6–0.8s | Selection panel UI (identical layout each return) | Character exits hard | 43.2, 45.7, 48.3 |
| `radialObjectMatch` | Shape-motivated morph between registers | 0.5–0.7s | Silhouette mass/position | Character radial-blurs into gauge ring | 52.5–53.1 |
| `gaugeStateAnim` | Pressure escalation | 1.3–1.5s per state | Gauge chassis | Needle position + state label + color | 53.1 (LOW), 54.4 (CRITICAL) |
| `textHoldAcrossBackgroundCut` | Background hard-cuts while copy holds | Text motionless ≥1.0s spanning cut | On-screen text (pixel-locked) | Full background | 33.0–35.0 (family), 60.9–63.0 (day→night map) |
| `heroRevealUnderText` | New world register introduced | 0.3–0.5s in; clip runs full-bleed | Center text channel | Entire background to hero clip/map | 19.5, 24.0, 31.8, 63.0, 71.7 |
| `wordToLogoMorph` | Copy word becomes brand mark | 0.4–0.5s scale/glitch | Word position on center axis | Type style → wordmark | 10.3 |
| `logoMatchCarry` | Logo bridges two sections | 0.8–1.0s | Logo mark | Everything else | 18.5–19.5 |
| `textResetLoop` | Return to WHAT IF… refrain | 0.4–0.6s | Black bg, center axis | Previous scene collapses (glitch) | 4.2, 8.6 |
| `scanGlitchReveal` | High-stakes plate (Survival, Simulation Active) | 0.8–1.0s scan-in | Dark bg | Plate flickers/scans in | 18.5, 35.0 |
| `urlPlateReveal` | Mid-trailer URL | 0.4s in, ~1.1s hold | Background map + HUD | Center text → copper URL plate | 59.4 |
| `questionToUrlTakeover` | Ending | ~0.7s overlap + 0.58s isolated hold | Question fades while URL enters (both visible) | Question → blue URL | 75.3–76.578 |
| `fadeToBlackBeat` | Breath between peaks | 0.4–0.6s | Nothing (or next text pre-typed) | All layers | 23.5, 55.9 |
| `hardCut` | Poster flash / abrupt section end | 1 frame | Nothing | Everything | 0.05, 27.2, 43.2 |

## New names added beyond cross_cutting_summary
`uiStateMorph`, `panelReturn`, `gaugeStateAnim`, `heroRevealUnderText`, `wordToLogoMorph`, `logoMatchCarry`, `textResetLoop`, `scanGlitchReveal`, `urlPlateReveal`, `fadeToBlackBeat`, `cardSwapOverAnchor` (variant of `persistentLayerSwap` where a side portrait pops with each card: 12.6–18.5), `cardRowBuild` (39.9), `isolatedHold` (76.0).

## Global rules for the compiler
- Every beat ≥1.5s must contain at least one continuously-animating layer (ring rotation, needle sweep, feed tick, clip playback, fog drift).
- A transition without a named persisting layer is only legal at section boundaries (hard cuts), max 1 per ~8s.
- Text: type-on with cursor only during entry; after last character, 0.6–1.4s motionless hold, then exit via the beat's primitive.
