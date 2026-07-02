# Top 10 visual gaps, ranked by impact on "feels like Anya"

Timecodes: REF = DOUBLAND1.mov (76.6s), AUTO = trailer_9x16.mp4 (115s). Fix type: **spec** (beat planner/props), **primitive** (Remotion component), **asset** (missing imagery), **layout** (composition rules).

| # | Gap | Timecode range | Reference does | Auto does | Fix type |
|---|---|---|---|---|---|
| 1 | No cast panel↔character rhythm | REF 39.9–52.5 / AUTO ~28–55 | Selection panel (0.6–0.8s, cursor) → full-body character on light gray (1.8–2.3s) → panel, ×4 characters with gestures | One dim portrait thumbnail held near-static ~25s under caption text | spec + asset + primitive (`cardSelectZoom`, `panelReturn`) |
| 2 | One VO segment = one static scene | whole runtime | 2–4 visual micro-beats per VO segment; 23.5 changes/min | 1 composition per narration line, held 8–25s; 9.3 changes/min | spec (beat planner must emit visual beats, not VO beats) |
| 3 | No layer persistence across cuts | REF 27.2–31.8, 33–35, 60.9–63 / AUTO all | Anchor layer (figures, family, map, text) survives every cut; UI morphs in place | Full-frame replace or no change at all | primitive (`persistentLayerSwap`, `uiStateMorph`, `textHoldAcrossBackgroundCut`) |
| 4 | No hero-scale world imagery | REF 19.5–27.2, 60.9–66.4 / AUTO none | Full-bleed village clip + tile-map register at full opacity, camera drift | Dark gradient background with tiny dim thumbnail; no world footage | asset + layout |
| 5 | Flat brightness/density curve | whole runtime | Dark hook → bright village → dense blue UI → red gauge peak → light-gray cast → dark end | Uniformly dark; brightest frames are the gauge section | spec (per-section palette + luminance targets) |
| 6 | Text behavior: paragraphs instead of type-and-hold phrases | AUTO ~75–100s worst | ≤6-word phrases, type-on with cursor, 0.6–1.4s motionless hold, phrase swap | 4–6 line static paragraphs held 10s+; some body text under title simultaneously | spec + primitive (phrase splitter + type-and-hold component) |
| 7 | No motivated morphs between registers | REF 10.3, 52.5–53.1, 75.3 | Word→logo, character-blur→gauge, question→URL overlap | Cross-dissolve or hard cut only | primitive (`wordToLogoMorph`, `radialObjectMatch`, `questionToUrlTakeover`) |
| 8 | Static gauge vs animated gauge | REF 53.1–55.9 / AUTO ~92–110 | Needle sweeps continuously, LOW→CRITICAL slam, chassis persists | Gauge present but needle near-frozen for ~18s with growing text paragraph | primitive (`gaugeStateAnim`) + spec (cap beat length) |
| 9 | No hook ritual (poster flash / WHAT IF loop / ring) | REF 0–10.8 / AUTO 0–8 | 50ms poster flash, black reset, WHAT IF refrain ×3, rotating ring accreting HUD lines | Slow fade-in to a "PREVIOUSLY ON" card held ~10s | spec + asset (ring/HUD elements) |
| 10 | End card timing | REF 71.7–76.6 / AUTO ~110–115 | Scenic 2.1s → question 1.5s → 0.7s overlapping URL takeover → 0.58s isolated hold | URL card appears and holds statically; no question→URL overlap, no scenic beat | primitive (`questionToUrlTakeover`) + spec |

Also material but below top-10: auto runtime 115s vs 76.6s (+50% — compresses nothing, stretches everything); no cursor/selection affordances anywhere; no semantic color coding (copper/red reserved for danger).
