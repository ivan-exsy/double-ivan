# Rubric scorecard — opener&009 vs visual_acceptance_rubric.md

Measured from frame grids (1fps full pass + 3–4fps on the six audit windows). Values are frame-count estimates, not pixel-diff telemetry; borderline gates marked accordingly.

| # | Gate | Threshold | opener&009 measured | Result |
|---|---|---|---|---|
| 1 | Visual-change rate | ≥18/min (ref ~23.5) | ~15/min (≈20 distinct layer/text/bg changes per 80s window-averaged) | **FAIL** (close; gaps 1–2 in v2 list account for the deficit) |
| 2 | Max static interval | ≤2.5s all-layers-motionless | ~4.5s dead black tail after URL (~75.3–79.8); Survival plate ~3–4s stretches with only cursor motion; every-conversation bg frozen ~7s but text typing keeps it under gate — borderline | **FAIL** (tail alone fails it) |
| 3 | Layer persistence | ≥60% of transitions keep ≥1 layer | est. ~35–40%: cast panel loop and hook bubbles persist; poster→features, world→UI, live cuts, end card do not | **FAIL** |
| 4 | Cast cadence | char 1.8–2.3s; panel bridge 0.6–0.8s; ≥3 panel returns | 4 characters ~2.0–2.5s each; panel returns present between all pairs (~0.7–1.0s); Luba two-stage caption present | **PASS** (marginal: some bridges ~1s, Gosha intro panel dwell long) |
| 5 | Text type-and-hold | ≤8 words; cursor only during type; no simultaneous text animation | Type-and-hold behaviour correct; phrases ≤8 words; **but double-exposed simultaneous text at ~4.2s, ~18.5s, ~36s, ~55s** | **FAIL** (scheduler bug, not design) |
| 6 | Depth layers | ≥2 concurrent layers ≥70% of runtime | Hook/cast/pressure sections yes; every-conversation, Survival, turn, end card mostly bg+text only → est. ~55–60% | **FAIL** (borderline) |
| 7 | Brightness curve | ≥3 luma regimes; cast block = peak | Dark hook/end ✓; bright gray cast block = peak ✓; village mid ✓; Survival brown adds a 4th regime | **PASS** (village register dimmer than ref — cosmetic) |
| 8 | Duration envelope | 76.6s ±5s | 79.8s | **PASS** (but ~4.5s of it is dead tail; trimming it lands at ~75.3s and also fixes gate 2's worst offender) |

**Score: 3 / 8 pass.** Shortest path to +3: fix the text-overlap scheduler bug (gate 5), trim the dead tail (gate 2, helps 8), and add anchor-layer persistence to poster/world/end sections (gate 3, pulls gate 1 and 6 up with it).
