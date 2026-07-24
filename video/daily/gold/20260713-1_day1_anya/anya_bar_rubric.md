# Anya bar — auto-gen quality rubric (draft)

**Purpose:** raise pipeline standards toward gold without requiring CapCut project.  
**Runtime (locked 2026-07-23):** target 45–60s · warn >90s · **fail >120s**. Gold reference 88s = pass.

Use after each auto or CapCut cut. Cold-quiz rows are hard; picture rows mix hard/soft.

## A. Meaning (hard — fail ship)

| # | Check | Pass if |
|---|--------|---------|
| A1 | Cold lead | Viewer names Peak + Cost after one watch |
| A2 | Want | At least Cost tonight-want/behavior lands |
| A3 | Pressure fork | Challenge name + what winning does tonight |
| A4 | Turn | Peak outcome correct (ledger) |
| A5 | Cost | Who left + dignity (no humiliation-as-joke) |
| A6 | Open question | Tomorrow itch present |
| A7 | Door | doubland.ai (or shipped deep link) on end |
| A8 | Fact-lock | No invented blocs / tallies / second winners |

## B. Simulation literacy (hard — SOT §3.6 / §12)

| # | Check | Pass if |
|---|--------|---------|
| B1 | Phaser plant | ≥1 early Phaser (or labeled live-map) moment |
| B2 | Peak/Cost bridge | ≥1 2D→3D (or reverse) on pressure/peak/**cost** |
| B3 | Door Phaser tease | ≥1 short Phaser (or live-map) at/under Door |
| B4 | Not all-cinematic | Fail if zero Phaser/live-map |
| B5 | Cap cinematic punctuations | ≤3 major arc “movie” inserts (establishing cards OK) |

**Gold timestamps (regression examples):** plant ~t7–13 · cost dive ~t66→70 · door ~t85.

## C. Picture craft (soft → harden after taste pass)

| # | Check | Gold signal | Auto v1 default |
|---|--------|-------------|-----------------|
| C1 | Mute hook = face/move not logo | t0 walk-in + status | Face/move required; HUD badge optional |
| C2 | Visual change rate | frequent cuts/type | warn if static >2.5s (existing trailer gate) |
| C3 | Habitat under Peak want | t20 Irene cafe | G1 still/clip required when workplace known |
| C4 | Cost bonding | t28 objective HUD | **Taste:** HUD vs habitat |
| C5 | Challenge teach readable mute | t33–42 steps | Title + bodies min; step HUD optional |
| C6 | Peak evidence on screen | card 7 | Winner identity clear mute |
| C7 | Ballots tactile | t62 bowl | G6 still/clip |
| C8 | Leave dignity | t70 bag walk | G5; no celebration pile-on |
| C9 | Cliff forward not recap | t74–78 | Open question picture |
| C10 | End lockup | t87 L-Talks | URL+brand; custom lockup optional |
| C11 | Kinetic type density | throughout | **Taste:** how much is mandatory |
| C12 | Caption discipline | supports VO, doesn’t dump job directory | no spoken job+place; on-screen chips OK |

## D. Runtime & audio

| # | Check | Pass |
|---|--------|------|
| D1 | Duration | ≤120s hard; warn >90s |
| D2 | VO match | Picture serves locked VO; no rewrite |
| D3 | Mix | VO intelligible; music ducked (Phase 2 LUFS later) |

## E. Validator mapping (eng)

| Rubric | Exists today | Gap |
|--------|--------------|-----|
| A1–A8 meaning | Partial via picker/VO validate; no MP4 comprehension | Human cold quiz until OCR/ASR |
| B1–B5 2D↔3D | SOT text only; **not** in `validate_clip_kit` | Add kit-level: F_phaser staged non-empty; optional post-render |
| C1 hook≠concept | `validate_clip_kit` concept-token on A_hook | Keep |
| C2 motion | `validate_trailer` visual-change | Wire when Remotion/CapCut MP4 exists |
| D1 runtime | SOT said 75s; **update code to 120/90** | `validate_clip_kit` has no duration yet — add when export path exists |
| G1–G8 presence | manifest staged lists | Extend jobs manifest for HUD families |

## Ship bar by phase

| Phase | Must pass |
|-------|-----------|
| Clip kit handoff | A (via VO+picker facts), C1 hook, B1/B3 assets staged, D2 VO hash |
| Human CapCut | Full A + B + D1; C as Anya craft |
| Auto Remotion v1 | A + B + D1 + C3/C6/C7/C8 hard; C4/C5/C11 per taste answers |
