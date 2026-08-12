# Second opinion (Opus) — P0 bake review, `20260724-2`

> **Working todo moved to** [`../../../../20260811_capcut-vs-post-prod.md`](../../../../20260811_capcut-vs-post-prod.md). This file is **evidence archive** (freeze measure + FX caveat corrected there).

**Date:** 2026-08-11 · **Reviewer:** Opus (second opinion, no re-investigation)
**Reviewing:** `20260811_dynamism_gap_20260724-2.md` + the fresh bake
**Craft bar:** Anya `20260713-1` / `0720(1).mp4` (88.2s) — grammar only, not cast

## Bake provenance (verified fresh)

| Artefact | Timestamp | Note |
|---|---|---|
| `edit_script.json` (SOT) | **2026-08-11 20:10:22** | last founder save |
| `output/trailer_9x16.mp4` | **2026-08-11 21:03:59** | **fresh — not Aug 7** |
| prior master archived | `trailer_9x16_20260811_205649_long.mp4` | the Aug-7 bake, parked at 20:56 |
| props regenerated | 20:56:49 | run meta: *"edit_script: using edit_script.json"*, *"applied 24 sfx[] polish clip(s)"* |

The render consumed the 20:10 save. This is the first rebuild since Aug 7, so everything the founder did tonight is in this MP4.

---

## Headline

One number replaces the whole debate. Same filter, same threshold, same crop (picture centre band, 32–62% of frame height), both films:

| | Anya gold | Ours `20260724-2` |
|---|---:|---:|
| Frozen picture stretches ≥1s | **0** | **17** |
| Total frozen picture | **0.0s (0%)** | **37.8s (39%)** |
| Worst single freeze | **—** | **9.5s** (37.2→46.8) |
| Frozen bed inside challenge teach | **0.0s of 12s** | **13.4s of 16.8s** |

Anya's picture centre never holds still for a full second across 88 seconds. Ours holds still for 39% of its runtime. That is the dynamism gap — the report's verdict was right, and this is the number to hold eng to.

Reproduce: `ffmpeg -i <film> -vf "crop=iw:ih*0.30:0:ih*0.32,freezedetect=n=-45dB:d=1.0" -map 0:v -f null -`

**But the most urgent problem in this bake is not dynamism.** At 70.7–74.1 the film shows a Phaser screenshot labelled **"Irene"** and **"Ivan"** — the Anya sim's cast — underneath the VO line "VINCENT IS GONE". Wrong names, largest legible text in frame, on the elimination beat. Fix that before any polish.

---

## 1. Report stress-test

- **AGREE — verdict and gaps #1, #2, #5 are confirmed at the stated timecodes**, and the freeze measure above is a harder version of the report's "scene-change frames 29 vs 12". Challenge bed frozen 9.5s straight (37.2–46.8); peak frozen 3.4s (51.9–55.3); cost habitat frozen 4.2s (25.9–30.1).
- **AGREE — #7 music is exactly as described and is safe work.** One row, `1.1→96.6 @ gain 0.22`, no segments. Music/SFX *do* survive Rebuild (meta confirms 24 sfx clips applied), so ducking under the teach is real, cheap yield.
- **DISAGREE (biggest error) — the near-miss table blesses the wrong-cast shot.** It reads "Phaser cost bridge — *Already good* on ours (~0:71 Phaser Irene/Ivan labels)". The report saw the Anya cast names and treated them as literacy parity. They are a factual defect. `clip_kit/bins/F_phaser/` holds exactly one file, `ivan_leave_phaser.jpg`, imported from the other sim; there is no correct-cast Phaser asset in this package.
- **DISAGREE — #1's cause is wrong, which changes the fix.** It is not "a single long primary cut with overlay-only bands". `hobbs_gather.mp4` is **2.04s** placed in a **17.0s** window, so it plays once and freezes. Same defect on `peak_portrait` (2.04s clip / 5.45s window), `tie_gather_bed` (2.04/4.45) and `ballots` (2.04/3.36). Fix is `speed` or `loop` or slices that re-trigger the clip — and any commissioned replacement must be **longer than the window**, which the asset list never specifies.
- **DISAGREE — #5 asks for an asset that already ships.** The "PLAYER OBJECTIVE / READ THE ROOM" HUD exists as `want_cost` (`labelText: READ THE ROOM`, `labelSub: VINCENT SLATER`) at 30.47–32.77 — same copy as Anya's. It is late and brief, sitting over a frozen classroom. Timing fix, not a commission. Drop it from the P1 musts.
- **DISAGREE — #2's caption advice is already done, and #4/#10 are overstated.** Peak captions are already three chips ("ALEXIS GOT THE HIGHEST CARD" / "SHE WINS THE SHIELD" / "AND IS SAFE TONIGHT"). Mean caption length is **3.72 words** against Anya's 3.5, with only **6 of 50** over five words — rewriting text is low-yield next to the freeze work. And the open hook (#10) is now genuinely good: the 4.9s frame is an AI-SCAN-MODE roster grid with 15 framed portraits, on par with Anya's 4s roster.
- **DISAGREE — #6 and #8 fix classes cannot ship as written.** `apply_edit_script()` returns `(layers, missing, warnings)` and never reads `script["fx"]`; the module exports `get_script_vo_clips` and `get_script_sfx_clips` but no fx equivalent. The rendered props carry **21** FX windows against the SOT's **15**, including a `radial_zoom`+`black_hit` pair at 36.57 and a `shake` at 56.30 that exist nowhere in the SOT. FX is recipe-owned. "Add scan/shake/black_hit punches" and "4–6 FX punches" would be discarded at Rebuild.
- **MISSING — four defects the report did not list.** (a) A **2.17s hard-black hole at 14.73–16.90**, only "TODAY WE ARE FOLLOWING" / "TWO OF THEM" on black — no picture layer exists there in the SOT or the props. (b) The **ALLIANCES→VOTES card overscans**: `scaleFrom: 2` crops the word to "LLIANC" for ~1.8 of its 2.6s (60.2–62.2). (c) The **"3 vs. 3" tie board (66.8–70.1) is mid-grey on a dark crowd** — unreadable at phone distance, where Anya's equivalent at 64s is a VOTING TARGET card with a live vote counter. (d) **Both namecards are near-black** (16.9–18.4, 24.2–25.8) against Anya's cinematic "Ivan PITTS" hero plate at 18s.

---

## 2. New bake vs the report's killers

**What the founder actually changed tonight** (diff of SOT against the 17:44 `pre_matrix_wipe` snapshot): the photo→matrix wipe went on (`cast_photo` to track 2, `wipeDown: true`, `wipeDelaySec: 0.1`, trimmed to 3.1s), the opening scan FX widened 0→6s, the opening badges were retimed, and four stray duplicate cuts from an earlier wipe experiment were deleted. **No hold was shortened, no bed was split, no music was segmented, no caption was rewritten.**

| Report killer | Status in this bake | Evidence |
|---|---|---|
| #8 wipes / join glue | **Improved — the win of the bake** | Matrix wipe is on and reads well; 4.9s roster grid is strong |
| #10 open hook | **Effectively closed** | AI SCAN MODE + 15 framed portraits + DOUBLAND.AI badge |
| #1 challenge 17s | **Still dead** | `32.77→49.77` unchanged; bed frozen 34.9–36.7, **37.2–46.8**, 46.8–48.9 |
| #2 peak no evidence | **Still dead** | `49.83→55.28` unchanged; frozen from 51.9; no card in frame |
| #3 holds >3.5s | **Unchanged** | 10 primary holds >3.5s |
| #4 caption punch | **Untouched** | 6 captions >5 words (was 6) |
| #5 cost want | **Still dead** | `cost_habitat` 25.76→30.37 frozen 4.2s; HUD still lands at 30.47 |
| #6 SFX on joins | **Untouched** | 17 of 24 primary cut starts have no hit within 0.45s |
| #7 music rides | **Untouched** | single row @ 0.22 |
| #9 black leave / dim door | **Still dead** | black 87.45→88.85 (1.40s); door still `opacity 0.55`, lockup still only 94→96.6 |

Two judgment calls, not defects: the 12s `hook_census` graphic reads **"14 ACTIVE"** while the 15→14 reveal is still 64 seconds away, which softens that later beat; and by 46–49s four stacked STEP boards cover most of the frame, so the teach ends as a HUD wall rather than a scene. Both defensible — flagging so they are chosen, not inherited.

Credit where due: the STEP boards *do* stack progressively every ~2.5s, so the teach is not information-dead. It is *picture*-dead. That distinction is why the eng gate missed it.

---

## 3. Live vs MP4 — one real mismatch

Picture, captions, SFX/music, VO and poster all bake exactly as the SOT says. Every `edit_script` window matches the rendered props window; the two black holes and the 0.55 door opacity are faithfully rendered, so they are authoring gaps, not render bugs.

**The FX lane is a ghost lane.** `apply_edit_script` never applies `edit_script.fx[]`; the MP4's effects come entirely from the cold recipe. So FX you add, delete, disable or retune in Live show up in the Player and vanish in the MP4. The SOT even carries `fx_3` marked `enabled: false` that the render has no way to honour. **Do not spend tonight placing FX.**

Two more parity notes worth one eng check each:

- **The pre-polish baseline is gone.** Rebuild overwrote `video/remotion/props/nightly_20260724-2_day2_long.json` at 20:56 with the *post-apply* plan — and that file is exactly what `edit_script.source.propsPath` points at. A future force-materialize would re-derive "base" from already-polished props. Keep a `*.base.json`.
- **The gate is green and should not be.** `nightly_run_report` reports `heroHold.passed: true`, `worstGapSec: 2.84`, `heroLayerHold.passed: true`, `worstLayerSec: 3.4`. The validator believes the worst hold in the film is 3.4s. The actual worst is 17.0s, and 3.6s of literal black shipped unflagged. Its single warning is on `cost_phaser_bridge` — the one shot with the wrong cast on it. Do not read this report as a dynamism signal.

---

## 4. Ranked next actions

### P0 tonight — in Live, verified to survive Rebuild (5)

1. **Kill the wrong-cast Phaser shot (70.7–74.1).** Delete `c_cost_phaser_bridge_33` and pull `c_cost_leave_34` back to 70.7, or repoint `src` to a label-free plate (`signature_flyover.mp4`, or `bins/E_cliff_door/vincent_leave.png`). Removes wrong names *and* a 3.2s frozen JPG. ~2 min. Do this first.
2. **Unfreeze the challenge bed.** Set `speed ≈ 0.12` on `c_challenge_gather_17` so its 2.04s source spans the 17.0s window as continuous slow motion — one field, biggest single win available. If slow-mo reads as syrup, instead split into five ≤3.5s cuts on the same `src`; each slice restarts the clip and buys 2s of motion. ~10 min.
3. **Fill the two black holes.** Pull `c_peak_namecard_10` start from 16.8 back to 14.75, and pull `c_signature_flyover_door_40` start from 88.8 back to 87.45 while raising its `opacity` 0.55 → 0.85. Kills 3.6s of dead screen and fixes report #9's dim door in the same edit. ~5 min.
4. **Unfreeze peak and the two habitats.** `speed ≈ 0.38` on `c_peak_portrait_25` (2.04s over 5.45s). The habitats are PNGs and cannot move, so give them `scaleFrom/scaleTo` Ken Burns — a cut field, so it survives — on `c_peak_habitat_9` (18.5–21.8) and `c_cost_habitat_13` (25.9–30.1). While there, move the `want_cost` "READ THE ROOM" card earlier, over the habitat rather than after it. ~10 min.
5. **Fix the ALLIANCES→VOTES overscan.** `c_alliances_votes_card_29`: `scaleFrom: 2` → `1.15`, or clear the anim. 30 seconds, and it makes a key story beat readable.

*If time remains and you still have appetite:* split the music row into 4–5 gains with a hard duck under the teach. It is proven to survive Rebuild and it is cheap — it just yields less than items 1–5.

### P1 musts — assets (3)

1. **Correct-cast Phaser capture for `20260724-2`** (Vincent + Alex Butcher labels) so beat 70.7–74.1 comes back properly. Replaces the imported Anya screenshot.
2. **Challenge teach bed with real motion — minimum 6s of source**, card table / hands / cards. The length requirement is the point; another 2s clip reproduces tonight's freeze.
3. **Peak evidence — Alexis with a readable winning card, minimum 3s of motion.** Anya's 48s frame (card "7" plus IMMUNITY ACTIVE badge) is the target.

Deferred from the report's must list: the Vincent objective HUD (already ships as `want_cost`). Worth adding later: a hero namecard grade, and a VOTING-TARGET-style tie card to replace the grey "3 vs. 3".

### P2 eng — hand over only after the founder accepts a P0 bake

1. **Apply `edit_script.fx[]` at Rebuild** (add a `get_script_fx_clips` alongside the vo/sfx helpers) — or hide the FX lane in Post-Production until it ships. Today the lane silently lies.
2. **Add a clip-duration-vs-window gate:** warn when `window > 1.25 × source duration` and neither `loop` nor `speed` is set. Would have caught 17.0/2.04, 5.45/2.04, 4.45/2.04, 3.36/2.04 in one pass.
3. **Add a picture-coverage gate:** every second from poster to lockup needs ≥1 visible picture layer at opacity ≥0.5. Would have caught both black holes.
4. **Fix the hold gates.** `_STRICT_HOLD_ROLES` contains no bed role — `challenge_gather`, `*_gather_bed`, `cliff_world_bed`, `alliances_chat`, `ballots` are all unchecked; and the `peak_portrait`-is-video and `peak_habitat`/`cost_habitat` exemptions let frozen clips through. Consider a deny-list instead of an allow-list.
5. **Make `check_hero_hold_cadence` picture-only.** It counts caption starts as events, so dense captions mask a frozen picture — that is why `worstGapSec` came back 2.84 on a film with a 9.5s freeze.
6. **Guard kit import by sim code.** A `20260713-1` asset landed in `20260724-2`'s `F_phaser` bin and shipped. Also surface `challengePackStatus: "specimen"` to the founder rather than burying it in meta.

---

## 5. Explicit do not

- **Do not place FX punches in Live** until eng confirms `fx[]` is applied. That work is discarded at Rebuild.
- **Do not force-materialize this package.** The props file at `source.propsPath` was overwritten at 20:56 with the post-apply plan; materialize would fold tonight's polish into "base".
- **Do not read `nightly_run_report` green as dynamism.** It says the worst hold is 3.4s on a film with a 9.5s freeze.
- **Do not commission the Vincent objective HUD** — it already ships as `want_cost` at 30.47.
- **Do not commission any clip shorter than the window it must fill.** 2.04s sources are the root cause of five separate freezes.
- **Do not reopen the open hook or the matrix wipe.** They are this bake's win; leave them.
- **Do not rewrite captions as a primary move** — 3.72 mean words already beats Anya's 3.5.
- **Do not rewrite VO, chase CapCut parity, recast to Anya's faces, or treat 88.2s vs 96.7s as the gap.**
- **Do not start [C] eng learning or [E] migration.** Plan order stays A polish → B Rebuild proof.

---

## Bottom line

**P0 moved:** the matrix wipe and the roster-grid open. Real, visible, keep them.

**Still blocked by:** a wrong-cast Phaser shot on the elimination beat, and 37.8s of frozen picture caused by 2-second clips sitting in windows up to 17 seconds long. None of the report's ten dynamism fixes were applied to timing.

**Do next:** the five P0 items above, in that order — Phaser first (credibility), then the challenge `speed` change (largest single win). Roughly 30 minutes, all in Live, all verified to survive Rebuild. Then one bake, then decide on P1.

---

### Method

Frame evidence and contact sheets under `teardown/opus_20260811/`. Both films sampled at 0.5 fps for phone-distance reading, plus targeted 6 fps strips on the suspect windows. Freeze measurement via `ffmpeg freezedetect` on a fixed centre-band crop, identical parameters on both films — an early bottom-strip run showed a 5.7s "freeze" at 57.1s that turned out to be the alliances black matte, not a frozen bed, and was discarded. SOT cross-checked field-by-field against the rendered props and against the three snapshots from tonight. No CapCut re-parse, no code changed.
