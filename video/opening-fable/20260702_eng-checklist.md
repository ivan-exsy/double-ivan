# Engineering checklist — auto opener to Anya standard

**Date:** 2026-07-02. Baseline: `opener&009` (3/8 rubric gates). Target: 8/8 + top-10 v2 gaps closed.
Inputs: `rubric_scorecard_opener009.md`, `top_10_visual_gaps_ranked_v2.md`, `visual_beat_map.csv`, `transition_primitive_catalog.md`, `remotion_props_schema.md`.
Anya kit: `video/opening-anya/` (`Anya_PNG_assets/`, `Anya_animated/`), registered via `video/asset_manifest.py`.

Ordered by payoff-per-effort. Each item: task → files → asset leverage → acceptance.

---

## P0 — Bugs (no design work, biggest rubric jump)

- [ ] **1. Fix double-exposed text scheduler.** Two text events render simultaneously at ~4.2s, ~18.5s, ~36s, ~55s in opener&009. Enforce: a new center-band text event may not start until the previous one's exit completes; assert non-overlap when building the text track.
  - Files: `video/build_opener_remotion_props.py` (or `opener_beat_map.py` where the text track is emitted); guard in `remotion/src/components/TypingText.tsx` / `KineticText.tsx`.
  - Acceptance: rubric gate 5 pass; frame-grab at the four timecodes shows single clean phrase.

- [ ] **2. Trim the dead tail.** ~4.5s of empty black after the URL fade (75.3→79.8s). End sequence must be: question → 0.7s overlapping URL takeover → ~0.6s isolated hold → hard end (`questionToUrlTakeover` + `isolatedHold`).
  - Files: `video/build_opener_remotion_props.py` (totalSec calc), `remotion/src/beats/EndCard.tsx`.
  - Asset: `DOUBLAND2.png` (already registered as `doubland_url`).
  - Acceptance: rubric gate 2's worst offender gone; runtime ≈75–77s; last frame is the URL, not black.

- [ ] **3. Fix placeholder portraits.** Gray icon boxes render where portraits should be (watch-live map cards ~24–27s, turn dashboard ~66–71s, end strip). Root-cause the asset path resolution; fail the build loudly on missing portrait instead of rendering a placeholder.
  - Files: `video/build_opener_remotion_props.py` portrait staging, `video/register_cohort_trailer_assets.py`, `video/validate_cohort_assets.py`.
  - Acceptance: zero placeholder boxes in a full render; validator errors if a referenced portrait file is absent.

## P1 — Asset registration (unlocks the design fixes below)

- [ ] **4. Register the unregistered Anya assets in `asset_manifest.py`.** Missing entirely today: `Gosha .png` (note trailing space — rename to `Gosha.png`), `Iván.png` (rename ASCII `Ivan.png`), `Luba.png`, `Photoroom_20260611_151820.png` (verify = Katya; rename `Katya.png`), `Cards5_family-matrix.png`, `matrix-cards_full-cast.png`, `Asset3.png`, `Dasha.png`, `F1714AC2-…png` (identify or drop).
  - Policy: character PNGs → `direct-overlay` (cast section); `Cards5_family-matrix.png` / `matrix-cards_full-cast.png` → `dynamic-component-template` (selection panel / dashboard layout source).
  - Acceptance: `production_stage_records()` includes all cast + panel assets; filenames ASCII-clean.

- [ ] **5. Decide the "reference-only" boards' role.** `Cards1–5`, `Connections/2`, `Map.png`, `Profile.png`, `Survival.png` are locked out of full-frame use (Playbook §16.8/16.9) — correct, but they should drive **component templates**: rebuild each board as a Remotion component matching its layout/colors, using the PNG as the styling spec. Do not relax the full-frame ban.
  - Files: `remotion/src/components/` (ConversationHud, RelationshipGraph, SurvivalDashboard, WorldMapHud already exist — restyle against the boards).
  - Acceptance: side-by-side screenshot of each component vs its board approved by Ivan/Anya.

## P2 — Layer persistence (gap #1, rubric gates 1/3/6)

- [ ] **6. Layer manager in the renderer.** Implement `visualLayers` with independent lifespans per `remotion_props_schema.md`; beats reference `layersPersisting/Entering/Exiting`. This is the enabling piece for items 7–10.
  - Files: new `remotion/src/LayerStage.tsx`; extend `remotion/src/types.ts` (schemaVersion 2); emit from `build_opener_remotion_props.py`.
  - Acceptance: a layer can span two beats with zero opacity dip (automated check: sample the layer's pixels across the beat boundary).

- [ ] **7. Family band persists through the feature-card run (REF 10.8–18.5).** Poster assembles (Double wordmark + `Family.png`), then family stays pinned bottom while TALKING/REACTING/CHOICES cards swap above (`persistentLayerSwap` / `cardSwapOverAnchor`).
  - Assets: `Family.png`, `Double.png` (registered), `Family.mp4` for motion variant.
  - Acceptance: family band visible ≥90% of 10.8–18.5s window.

- [ ] **8. Wireframe figures anchor the conversation block (REF 27.2–31.8).** `Talk.mp4` (registered, `direct-motion`) plays bottom-half throughout while EVERY CONVERSATION → CHOICE → RELATIONSHIP UI cards morph in place (`uiStateMorph`), replacing today's frozen gradient.
  - Assets: `Talk.mp4`; card styling from `Cards4.png` (template per item 5).
  - Acceptance: no frozen background >2.5s in the block; 3 distinct UI states visible.

- [ ] **9. Survival plate gets motion + family anchor (REF 33–41.4).** Replace the 8s flat copper hold: family photo persists while background cuts (`textHoldAcrossBackgroundCut`, use `Family.mp4`/`Village.mp4` night frames), then `Survival.png`-styled plate scans in (`scanGlitchReveal`), then identity card row builds (`cardRowBuild` from `Cards5_family-matrix.png` template).
  - Acceptance: ≥3 visual beats inside the section; max static ≤2.5s.

- [ ] **10. End card sequence (REF 71.7–76.6).** Scenic hold (~2.1s; nearest kit asset: `Village.mp4` dusk frames or fly-over b-roll) → question over dim figure (`Asset4.png` wireframe fx layer) → `questionToUrlTakeover` overlap → isolated URL hold. Pairs with item 2.
  - Acceptance: all four phases present at reference durations ±20%.

## P3 — Registers and morphs (gaps #4, #5, #8)

- [ ] **11. Tile-map world register (REF 24–27.2 and 60.9–66.4).** "THEN YOU WATCH IT LIVE" needs the overhead game map + populating portrait stack, not a gradient with lens flare. Live block needs the day→night map cut under held WATCH LIVE 24/7 text.
  - Assets: `Map.png` as layout template; live map captures via `capture_static_assets.py` / headless FE; real portraits from cohort assets.
  - Acceptance: two distinct map appearances; day→night cut lands while text is pixel-static.

- [ ] **12. Pressure handoff at full scale (REF 52.5–55.9).** Character radial-blurs into a full-width gauge (`RadialObjectMatch.tsx` exists — wire it), needle sweeps LOW→CRITICAL (`gaugeStateAnim`, drive from `Pressure.mp4` or rebuilt gauge component). Kill the shrink-to-thumbnail + two-small-dials layout.
  - Acceptance: gauge occupies ≥70% frame width; LOW and CRITICAL states each ≥1.2s with continuous needle motion.

- [ ] **13. Hook upgrades (REF 0–4.2).** Add 50ms poster flash → black reset (`posterFlash` beat exists — verify frames 0–1/2–3/4 at 30fps) and the rotating ring accreting HUD scan lines (`AiCoreRing.tsx` exists — place on center axis with `Asset2.png` scan-line overlay). Keep the existing bubble/hands density.
  - Acceptance: matches addendum head spec; WHAT IF readable by frame 4.

## P4 — Validation (make regressions impossible)

- [ ] **14. Automate the rubric.** Add the 8 gates from `visual_acceptance_rubric.md` to `video/validate_trailer.py`: frame-diff change rate, max static interval, layer-persistence ratio (from props), cast cadence (from props), text-overlap check, layer depth, luma regimes, duration envelope. Fail the render pipeline on gate breach; write `rubric_report.json` next to `validation_report.json`.
  - Acceptance: opener&009 rerun reports the same 5 failures this audit found by hand; post-fix render reports 8/8.

- [ ] **15. Golden-frame comparison.** Check 6 canonical timecodes (hook ring, poster, conversation block, cast character, gauge CRITICAL, URL hold) against approved stills; alert on drift.
  - Files: extend `validate_trailer.py`; stills exported from the post-fix approved render.

---

**Suggested order:** 1 → 2 → 3 (bug pass, re-render, re-score) → 4 → 6 (foundations) → 7–10 (persistence) → 11–13 (registers) → 14–15 (lock it in). Expect ≥6/8 gates after P0+P2, 8/8 after P3.
