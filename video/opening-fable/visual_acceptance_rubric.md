# Visual acceptance rubric — auto trailer must pass all gates

Measure on the rendered 1080×1920 output. Reference values from DOUBLAND1.mov.

| # | Gate | Threshold | How to measure |
|---|---|---|---|
| 1 | Visual-change rate | ≥ 18 distinct visual changes/min (ref ~23.5) | Frame-diff: count events where >15% of pixels change OR a text/UI layer enters/exits |
| 2 | Max static interval | No interval > 2.5s where every layer is motionless (ref max ~2.3s) | Frame-diff below noise floor for N consecutive frames |
| 3 | Layer persistence | ≥ 60% of transitions keep ≥1 named layer alive across the cut | Compiler audit: count transitions tagged with a `layers_persisting` entry vs total |
| 4 | Cast cadence | Each character beat 1.8–2.3s; selection-panel bridge 0.6–0.8s between every pair; ≥ 3 panel returns | Beat-plan inspection + render spot-check |
| 5 | Text type-and-hold | Every phrase ≤ 8 words; cursor visible only during type; post-type motionless hold 0.6–1.4s; no two text blocks animating simultaneously | Text layer timeline audit |
| 6 | Depth layers | ≥ 2 concurrent layers on screen for ≥ 70% of runtime (bg + text minimum; hero sections need bg + UI + text) | Compiler layer-count per frame |
| 7 | Brightness curve | At least 3 distinct luminance regimes: dark (<25% mean luma) hook/end, bright (>45%) world/cast block, mid dense-UI; cast block must be the luma peak | Mean-luma-per-second plot |
| 8 | Duration envelope | Total runtime within ±5s of the reference skeleton (76.6s), not stretched per-VO | Container metadata |
