# TODO — L-Talks / Press Play Opening Trailer (manual production)

> **Mode:** Manual — Anya edits by hand in CapCut. Not the automated Remotion pipeline.
> **Sim:** `soul15_seed_20260224` (15 Doubles, forked from the soul15 baseline).
> **Cohort display name:** L-Talks (masked) · **Season:** Press Play.
> **Type:** Opener [A] — lean viral asset. Per `video/sot-video.md` §0 and §10.
> **Brief for scenario writer:** `opening-15person/20260701_scenario-writer-brief_leadertalks-opener.md`

---

## Trailer shape (locked)

Lean, **~60s**, mobile 9:16, shareable. No per-Double intros, no survival mechanics in the body.

1. **Concept intro** — what Doubland is, what a Double is.
2. **Cast overview** — the L-Talks alumni-chat → "pressed play" reveal, all 15 visible at a glance (group frame / matrix). No spoken trait lines.
3. **Close — survival tease** — one hint at the real survival episodes ahead → "What if?" → `doubland.ai`.

Per-Double intros and the 15 spoken trait lines move to **[B] `day_normal`** daily (SOT L2).

## Raw materials to prep for Anya

### Narrative (must be produced)
- [ ] **Final script** — cold open + cast-overview block + survival-tease close. Commission via the scenario-writer brief. **Blocks everything.**
  - Note: brief §6.3 (stakes montage) and tone section still lean on survival pressure; retune to "normal-day/concept body, survival tease at close only" before send-out.
- [ ] **VO narration** (`narration.mp3` + `narration_timing.json`) — TTS, `eleven_v3` warm @ 1.5×, from the locked script. Use `--skip-render`; only audio needed for manual mode.
- [ ] **On-screen copy sheet** — season line `L-TALKS · PRESS PLAY`, captions, mid-URL, end card strings. One-page list so Anya isn't guessing from the JSON.

### Cast pack (already in hand — do not regenerate)
- [x] 15 hero spotlight PNGs (full-screen safe) — approved
- [x] 15 portrait / identity card crops
- [x] Group photo (clean, 3×5) + matrix-filtered tier
- [x] `group_anim.mp4` (cast motion plate, replaces Pistsov `Family.mp4`)
- [x] 15 locked trait lines (in Supabase + `video_narration_cache`) — **held for [B], not used in opener VO**
- [x] `fifteen_spotlight_montage` preview v2 — hand to Anya as cast-block pacing reference only

### World / survival-tease visuals (small new spend)
- [ ] **One survival-tease still/clip** — single frame or short loop hinting at the survival season, for the close. Low effort, high impact. (Grok or a frame from a future survival run.)
- [ ] **World-establishing beat** — reuse sim-agnostic `Village.mp4` from the Anya kit (no survival mechanics). Confirm reuse is acceptable for a launch asset.

### Reusable brand kit (no action)
- [x] End card (`What if?`, URL takeover), mid-trailer URL plate, anthem, SFX library — from `opening-anya/`. Anya reuses.

## Handoff bundle for Anya

Assemble into one folder once the narrative + survival-tease visual are ready:

- Final script (markdown + JSON shape Anya's used to)
- `narration.mp3` + `narration_timing.json`
- 15 hero PNGs + 15 portrait crops
- Group photo (clean + matrix) + `group_anim.mp4`
- Survival-tease still/clip
- `fifteen_spotlight_montage` preview v2 (pacing reference)
- On-screen copy sheet
- Pointers to reused brand kit (or the actual files)

## Open dependencies / decisions

- **D1.** Update the scenario-writer brief (§6.3 stakes montage + tone) to match the lean [A] shape before sending it out. Owner: Ivan.
- **D2.** Confirm whether a non-survival first-day sim run for L-Talks is needed to source any world/role visuals, or whether reusing `Village.mp4` + the cast pack is enough for the lean opener. (Per-Double sim-habitat visuals are [B], not [A], so the opener may not need a sim run at all.)
- **D3.** Decide the survival-tease visual source: Grok still vs. frame from a future survival run vs. simple text+motion card. Affects only the close.

## Order of work

1. Send the (retuned) scenario-writer brief → get final script.
2. Record VO from the locked script (`--skip-render`).
3. Generate the one survival-tease visual.
4. Decide D2 (sim run or not) — likely "not" for the lean opener.
5. Assemble handoff bundle → deliver to Anya.