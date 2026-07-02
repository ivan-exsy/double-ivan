# Verdict addendum — corrected auto baseline (opener&009)

**Date:** 2026-07-02. Original audit compared REF against the wrong video (daily trailer, 115s). Corrected baseline: `base_family_sim/opener&009/output/trailer_9x16.mp4` (**79.8s**). Reference artifacts (beat map, primitive catalog, coupling table, asset map) unchanged and still valid.

## Corrected comparison stats

| Metric | REF (Anya) | Daily (wrong baseline) | opener&009 (correct) |
|---|---|---|---|
| Duration | 76.578s | 115.0s | 79.8s (within ±5s ✓, but ~4.5s dead black tail after URL) |
| Visual-change rate | ~23.5/min | ~9.3/min | **~15/min** (frame-grid count) |
| Near-static screen time | ~16% | ~57% | **~30%** (worst: every-conversation block ~27–32s, Survival plate ~33–41s, turn/feed ~66–71s, end card 71–79.8s) |
| Section structure | 19 sections | absent | **present** — copy, order, and boundaries match the teardown |
| Cast panel↔character loop | yes | absent | **present** (panel bridges + ~2s gray full-body characters) |

## Which of the 3 root causes still hold for opener&009?

1. **Narration segment = one static scene — PARTIALLY FIXED.** Text now retypes per phrase and sections follow the skeleton. But inside long segments the background still freezes: "EVERY CONVERSATION/CHOICE/RELATIONSHIP" plays as text swaps over one motionless dark gradient (ref: wireframe figures + 3 UI card morphs), and the Survival plate is a flat copper background for ~8s. The micro-beat layer (uiStateMorph, background cuts under held text) is still missing.
2. **No layer persistence / motivated handoffs — STILL HOLDS.** The family photo band vanishes instead of anchoring the three feature cards (12.6–18.5); no wireframe figures persist under the world-UI section; no day→night `textHoldAcrossBackgroundCut` in the live block (same village still reused); end card has no persisting figure and no question→URL overlap. The pressure handoff exists but as a shrink-to-thumbnail, not the `radialObjectMatch` blur-morph, and the gauge renders as two small dials on black instead of the full-width chassis.
3. **No hero imagery / cast rhythm — MOSTLY FIXED.** Cast rhythm is in and close to spec. Village hero stills with slow zoom carry the world/live sections. Remaining hero gaps: no tile-map register at all ("THEN YOU WATCH IT LIVE" is a dark gradient + lens flare + broken/placeholder portrait icons), and no end-card scenic.

## New opener-specific defects (not visible in the daily baseline)

- **Double-exposed text:** several moments render two text events on top of each other (e.g. ~4.2s "TO MAKE IT RIGHT?"/"WHAT IF" overlap, ~18.5s "DOUBLAND/SIMULATION" garble, ~55s "SEE WHAT"/gauge label). Rubric gate 5 violation — likely a text-track scheduling bug, not a design gap.
- **Placeholder assets:** gray icon boxes where portraits should be (watch-live map cards, turn dashboard, end-card strip).
- **Dead tail:** ~4.5s of empty dark frames after the URL fades (ref ends hard at the URL hold).

## Daily-only artifacts (now moot)

115s runtime, paragraph-length captions as the norm, total absence of cast/world/hook structure, uniformly dark luma. These were properties of the wrong baseline, not of the opener pipeline.
