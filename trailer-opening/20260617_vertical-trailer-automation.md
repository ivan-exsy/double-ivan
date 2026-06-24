# Opening Trailer — Implementation Plan

=============================
PRIMARY implementation doc · Phase 0–5 P0 DONE · Phase 6 OPEN
Creative bible → 20260501_opening-trailer.md · Visual SOT → teadown/
=============================


> **Primary engineering plan** for auto-generating vertical (9:16) opening trailers. Goal: match Anya's hand-edited cut (`video/opening-anya/DOUBLAND1.mov`). Scope locked **2026-06-17: vertical only**. Creative standard + asset map: **`20260501_opening-trailer.md`** (Part I playbook). Visual timing: **`trailer-opening/teadown/`**.

**Duration policy:** Total trailer length is **not a hard product requirement**. A few seconds vs Anya's hand cut is fine (e.g. **~76.7s** narration vs **~82–84s** final MP4 on opener&006). **Larger casts are expected to produce longer trailers** — tiered layouts keep the cast *block* efficient (~15–20s), but total runtime may grow with cohort size within validator bounds (today **65–95s**).

## Document hierarchy (which doc does what)

| Document | Role | When to use |
|---|---|---|
| **This doc (`20260617_…`)** | **Primary implementation plan** — built state, commands (§7), gaps (§4, §8), Phase 6 todos | Day-to-day engineering; what's shipped vs what's next |
| **`20260501_opening-trailer.md`** | **Opening trailer bible** (draft → `sot-opening-trailer`) — Part I: creative playbook + asset map; Part II: commission punch list | *What good looks like*; asset render policy; cast tiers |
| **`trailer-opening/teadown/`** | **Visual timing SOT** — ~50 sub-moments, text/SFX logs, reference grabs | Beat implementation; QA diff at a timecode |
| **`video/video_PRD.md`** | Product requirements for video/trailer features | Scope questions |

**Governance:** Producer teardown wins on **visual timing, sub-moment structure, on-screen copy, and SFX sync**. Opening trailer bible (Part I) wins on **asset policy, cast scale, mix targets, and acceptance framework**. This doc tracks **what code actually does today**.

---

## TODO — next steps

**Status:** Phases 0–4 **done**. Phase 5 P0 **done on `opener&006`** (see §8.10). **Phase 6** — producer-teardown-driven rebuild — is the active workstream.

### Phase 6 — visual grammar rebuild (`opener&007+`; teardown SOT)

Target: move from ~16 VO-aligned beats to **~50 producer sub-moments** with named transition primitives. Read order: `teadown/20260624_doubland_cross_cutting_summary.md` → `timecode_index.csv` → `text_log.csv` + `sfx_log.csv` → matching rows in `scene_spec.md` → `reference_grabs/` at those timecodes.

#### Phase 6A — foundation (unblocks everything)

- [ ] **Visual sub-moment planner** — consume `teadown/20260624_doubland_timecode_index.csv`; emit ~50 timed events independent of 18 VO segment boundaries (Playbook Ticket 1 · §5.2)
- [ ] **Text from `text_log.csv`** — exact strings, `animation`, `hold_sec`, `exit` per row; wire into props builder
- [ ] **`sharedCenterReplace`** — one center text axis; phrases swap in place (hook, concept, world captions)
- [ ] **SFX from `sfx_log.csv`** — ~39 classified hits with `leads_picture_by_ms` (today: ~7 generic roles on 006)

#### Phase 6B — P0 visual grammar (highest leverage vs 006)

- [ ] **Retime hook/concept boundary** — concept starts **~10.8s**, not ~15s (producer §4.1); update beat map + poster still frame
- [ ] **`questionToUrlTakeover`** — end card §18: ~2.1s fog setup → question → URL overlap → ~0.6s URL-only (replace 4s static hold)
- [ ] **Hero video policy** — Talk / village / pressure at full or near-full opacity; HUD in margins, not dimmed B-roll
- [ ] **Hook sub-moments §1–3** — ring + diagnostics + silhouette strip; conversation UI with **persistent lower figures** (`persistentLayerSwap`)

#### Phase 6C — P1 middle-trailer density

- [ ] **`cardSelectZoom` + ACTIVE DOUBLES panel** — cast §9–12: panel → character → panel (~0.6–0.8s bridges); **required**, not decoration
- [ ] **Mid-trailer URL plate** — `WWW.DOUBLAND.AI` @ **~59.4s** (§14.3); separate from final end-card URL
- [ ] **`textHoldAcrossBackgroundCut`** — live/replay §15: caption frozen while map swaps day/night
- [ ] **`radialObjectMatch`** — Lyuba blur → pressure gauge (§13.1)

#### Phase 6D — rich middle (world / season / turn)

- [ ] **Concept deconstruct** — §4: poster → identity/decision cards + branching tree (not split poster + phrase swaps only)
- [ ] **Pixel map + portrait cards** — §6: distinct from aerial village; four ONLINE cards around map
- [ ] **Three-state UI morph** — §7: conversation → decision → relationship graph (`persistentLayerSwap`)
- [ ] **Survival sequence** — §8: mode banner, family count, selection UI before cast
- [ ] **Turn dashboard cycles** — §16–17: identity card row + evidence panels under persistent row

**Review gate per section:** diff render vs `teadown/reference_grabs/` at CSV timecodes; check rows in `teadown/scene_spec.md` for the section; run opening bible Part I §16.13 acceptance tests + editorial-motion gates (Ticket 7).

**Next run command (after Phase 6A lands):**

```bash
python -m video.generate_trailer base_family_sim opener --mode opener --top 4 --cohort-name "Pistsov family" --force
# cohort dir: data/base_family_sim/opener&007
```

### P1 — new simulations & casts (unchanged scope; after Phase 6B)

Target: any sim with 1–15 Doubles renders without manual Remotion edits or wrong-cohort assets.

- [ ] **Cast scale** — `--top` 1–15; tiered layouts for 1–4 / 5–8 / 9–15; cast block ≤ ~20s (Playbook Ticket 5)
- [ ] **Relationship graph** — Supabase-driven labels; generalize layout for 2–15 nodes
- [ ] **Per-cohort assets** — auto-generate + verify cutouts and group photo; no silent Pistsov fallback (Playbook §17)
- [ ] **Component library** — `DoubleIdentityCard`, `WorldMapHUD`, `SurvivalDashboard`, `PersonalityAnalysisPanel`, etc. (Playbook §16.12 P1)
- [ ] **Editorial validator** — low-motion ratio, static-run length, visual-change rate (~23.5/min target), repetition flags (Playbook Ticket 7)
- [ ] **Trailer VO A/B** — warm vs trailer profile @ 1.5×; side-by-side with Anya before re-lock (§8.3 · deferred from 006)
- [ ] **Scale smoke test** — fork sim with 8–15 personas; full asset gen + render (§8.4)

### P2 — defer until Phase 6 + P1 pass

Golden test set (4 / 8 / 15 cast), composition variants, 60fps delivery, thumbnail scoring, homepage hero loop, 16:9 master.

### Phase 5 P0 — completed on `opener&006` (2026-06-22)

- [x] Poster / concept frame + poster still export
- [x] Text settle — `type-then-hold`; glitch/cursor during type only
- [x] `Talk.mp4` hero on hard-conversation hook phase
- [x] Hook morph — merged VO segments 0–2 into `hookContinuous`
- [x] Partial visual timeline decoupling (~16 beats; full ~50 sub-moments = Phase 6)
- [x] End card hold wired (4s — **too long vs Anya**; fix in Phase 6B `questionToUrlTakeover`)
- [x] SFX wiring + loudnorm ~-14 LUFS
- [x] `Family.mp4` once at concept reveal
- [x] Asset manifest render policies; block reference boards

---

## 1. Anya's cut — the facts

- **Format:** 2160×3840 (9:16 vertical), 120fps, **76.6s**, HEVC. Mobile-first.
- **Narration:** ElevenLabs **`eleven_v3`** warm take at **1.5×** (evolved from the `v3_warm_x1.2` experiment), with inline delivery cues `[curious]` / `[warmly]` / `[excited]`. Script = showrunner opener fixed blocks (v2.4 "Anya cut" **minus** the dropped *"sometimes… you never noticed before"* line). Pauses minimal (~2.75s total silence). **Narration audio ~76.7s** — close to Anya's 76.6s VO. **Final MP4** may run longer (opener&005 = **83.6s**) — acceptable; see Duration policy. Reference: `video/voiceover/auto_match_v3_warm_x1.5/narration.mp3`. Legacy producer script still at `video/anya/narration_anya.json`.
- **Her toolkit:** ~24 transparent PNG overlay graphics + 4 short image-to-video B-roll loops (`opening-anya/Anya_animated/{Family,Pressure,Talk,Village}.mp4`, 3–5s each, mixed aspect) + existing anthem + SFX library. **Editor: CapCut** (project file available on request — usable as a *blueprint*, not a render engine; CapCut can't run headless). Reference cut + assets live in `video/opening-anya/`.

## 2. Beat / shot map

**Authoritative timing:** `trailer-opening/teadown/20260624_doubland_timecode_index.csv` (~50 sub-moments, 76.6s proxy). The coarse table below is a **legacy macro summary** — use producer index for implementation. Key corrections vs old approximations: **concept starts ~10.8s** (not ~15s); **cast starts ~41.4s**; **mid-trailer URL @ ~59.4s**; **end card §18 @ ~71.7–76.6s**.

Hard-cut timestamps (ffmpeg scene detection on master): 0, 23.5, 24.0, 27.2, 31.8, 35.0, 43.2, 45.7, 48.3, 49.1, 63.0, 66.4, 71.7, 73.8. Long gaps between cuts = continuous morphing motion-graphic sequences. Macro rhythm guidance: Playbook §4.1, §16.6; micro rhythm: `teadown/20260624_doubland_cross_cutting_summary.md`.

| t (s) | Beat | On screen | Technique |
|---|---|---|---|
| 0–11 | **Hook** | "What if…" → ring/diagnostics → silhouettes → conversation UI → DOUBLE wordmark | Continuous kinetic-type + motivated handoffs (§1–3 in producer index) |
| 11–19 | **Concept** | Poster deconstructs → identity/decision cards → "talking / reacting / making choices like you" | Portrait cards, decision tree, kinetic captions |
| 19–32 | **World + season setup** | Village hero + personality UI → pixel map + cards → conv/choice/relationship UI morphs → Survival mode | Live footage + layered HUD; three UI states in §7–8 |
| 41–53 | **Cast** | ACTIVE DOUBLES panel → full-body cut-out → panel (×4) | `cardSelectZoom` rhythm; trait captions from `text_log.csv` |
| 53–61 | **Pressure** | Gauge LOW→CRITICAL → night dashboard → **mid-trailer URL plate** | Radial morph + map; URL @ ~59.4s |
| 61–67 | **Live / replay** | Day/night map, follow, replay; text holds across background cuts | Feature montage |
| 67–72 | **Turn** | Identity row + dashboard evidence cycles | Card row + lower panel swaps |
| 72–77 | **End card** | Fog reflection → "what would MY Double do?" → URL takeover | `questionToUrlTakeover`; ~4.9s total, not 10s+ hold |

## 3. What the pipeline does today (opener mode)

`python -m video.generate_trailer <sim> opener --mode opener --top 4 --cohort-name "…"` runs the full chain and outputs **`output/trailer_9x16.mp4`** (1080×1920) via Remotion:

| Step | Module | Role |
|---|---|---|
| Cast pick | `persona_ranker.py` | Selects featured personas (**today:** importance-led; **target:** Playbook §5.1 conflict/contrast scoring) |
| Script | `showrunner.py` | Fixed hook/concept/closing + AI season framing + per-cast trait lines (Supabase-cached) |
| Voice | `tts.py` | Opener: `eleven_v3` / stability 0.60 / **1.5×** → `narration_timing.json` (18 segments) |
| Assets | `generate_cutouts.py`, `generate_group_photo.py` | Per-cohort cut-outs + group photo (manual/optional before render) |
| Props | `build_opener_remotion_props.py` | Maps 18 VO segments → Package A beat map + staged assets |
| Render | `render_opener_remotion.py` | `npx remotion render` → `trailer_9x16.mp4` |
| Gate | `validate_trailer.py` | **Today:** 9:16, **65–95s** (wide band; longer OK for large casts), LUFS check. **Target (Playbook §11):** editorial-motion gates, ~**-14 LUFS**, true peak ≤ -1 dBTP, poster export — not a strict 70–85s cap |

**Not used for opener anymore:** Phaser static capture, `compose_opener_trailer` (FFmpeg), 16:9 master. Day modes (`day_in_life`, `day_overview`) still use FFmpeg `compose_trailer.py` unchanged.

**Pistsov reference path (manual):** `build_anya_package_a_props.py` + locked `auto_match_v3_warm` timing — bypasses showrunner/TTS for Anya-asset QA.

## 4. Remaining gap vs Anya's cut

Phases 0–5 P0 closed the render stack and first-pass polish (`opener&006`). The **visual grammar gap** remains — we still render ~16 VO-aligned beats, not ~50 producer sub-moments. Phase 6 closes that gap using `trailer-opening/teadown/` as SOT.

| Gap | Status |
|---|---|
| **~50 sub-moment visual planner** | Open — CSV-driven planner not built; 006 still ~16 beats (Phase 6A) |
| **Named transition primitives** | Open — `sharedCenterReplace`, `cardSelectZoom`, `questionToUrlTakeover`, etc. not implemented |
| **Producer timecodes** | Open — concept @ ~10.8s, cast selection panels, mid-URL @ 59.4s misaligned on 006 |
| **Continuous hook + handoffs** | Partial — `hookContinuous` merged seg 0–2; missing silhouettes, persistent figures, logo impact timing |
| **Concept deconstruct** | Partial — split poster + Family.mp4 once; missing card/tree demo layer (§4) |
| **Cast selection rhythm** | Open — no ACTIVE DOUBLES panel or cursor between characters (§9–12) |
| **Middle-trailer richness** | Open — pixel map, UI morphs, Survival sequence, turn dashboards largely absent |
| **End card pattern** | Partial — renders but 4s static hold vs Anya `questionToUrlTakeover` (~4.9s structured) |
| **SFX density** | Partial — ~7 wired on 006 vs ~39 in `sfx_log.csv`; no `leads_picture_by_ms` |
| **Mix loudness** | **Done on 006** — ~-14 LUFS after loudnorm |
| **Text type-then-hold** | **Done on 006** — shared text components updated |
| **Talk.mp4 hero** | **Done on 006** — hero phase on hard-conversation beat |
| **Poster still export** | **Done on 006** — deliberate still (frame ~15s); producer poster flash @ 67ms is thumbnail-only |
| **Relationship labels from Supabase** | Partial — layout defaults for Pistsov; graph node label bug on 006 |
| **Per-cohort group photo / cut-outs** | Generators exist; Pistsov still uses Anya assets until Grok run |
| **Multi-cast (up to 15 doubles)** | Open — pipeline caps at `--top 6` (P1) |
| **Editorial-motion validator** | Open — no low-motion / visual-change-rate gates yet (P1) |
| **Trailer VO profile A/B** | Open — still warm @ 1.5× on 006 (deferred) |

The original FFmpeg `drawtext` gap is **closed** — opener visuals are Remotion-only.

## 5. Architecture (as built)

**Today (Phase 4):**

```
persona_ranker → showrunner (+narration_cache) → tts (VO + 18-segment timing map)
              → [optional: cutouts / group photo / relationship graph]
              → build_opener_remotion_props → npx remotion render
              → validate_trailer (9:16 + LUFS)
```

**Target (Playbook §5):** evolve to a spec-driven compiler — cast/conflict selector → **visual sub-moment planner** (producer CSV) → asset resolver → **TrailerSpec JSON** → Remotion transition primitives → SFX/mix pass → technical + **editorial** validator → MP4 + poster + QA report. Phase 6 closes the gap; do not extend the VO-segment = one-scene pattern.

### Asset buckets
- **Reusable once (built):** Remotion components in `video/remotion/src/components/` + `opener_beat_map.py` + brand assets in `opening-anya/`.
- **Per-village (the_ville = done):** village B-roll, map, night aerial (`video/fly-over/`).
- **Per-cast:** cut-out portraits, group photo, trait narration, relationship graph data.

## 6. Phased plan

- **Phase 0 — spec lock.** **DONE** — this doc + per-scene spec. Narration + photo-real cut-outs locked 2026-06-17.
- **Phase 1 — Remotion skeleton.** **DONE**
- **Phase 1b — narration lock.** **DONE** — v3 warm / 1.5× / ~76.7s **narration audio** (final MP4 length flexible — see Duration policy)
- **Phase 1c — Package A.** **DONE** — Anya assets wired; `pistsov_package_a.mp4` reference
- **Phase 2 — motion-graphic components.** **DONE**
- **Phase 2.5 — visual polish.** **DONE** — AI-core ring, relationship graph, gold transition, color grade
- **Phase 3 — per-cast automation.** **DONE** — props builder, cut-outs, group photo, relationship export
- **Phase 4 — integrate + gate.** **DONE** — `generate_trailer` → Remotion; opener validation
- **Phase 5 — polish pass (post–opener&005 review).** **P0 DONE** on `opener&006` — poster, text settle, Talk hero, hook merge, SFX/mix, Family.mp4 once, asset manifest (§8.10)
- **Phase 6 — producer teardown rebuild.** **OPEN** — CSV-driven sub-moment planner + transition primitives (`trailer-opening/teadown/`)
- **Fast-follow (out of scope):** silent center-safe **hero loop** for doubland.ai homepage + **16:9 master**

**Cost shape:** Style layer is built once. Each new cast ≈ regenerate cut-outs (+ optional group photo) + one `generate_trailer` run.

## 7. Commands (quick reference)

```bash
# Full opener (production path)
python -m video.generate_trailer base_family_sim opener --mode opener --top 4 --cohort-name "Pistsov family"

# Pistsov QA with Anya's locked assets
python -m video.build_anya_package_a_props
cd video/remotion && npx remotion render OpenerTrailer out/pistsov_package_a.mp4 --props=props/pistsov_package_a.json

# Per-cohort assets (before or after a run)
python video/assets/scripts-prompts/generate_cutouts.py --skip-existing
python video/assets/scripts-prompts/generate_group_photo.py --cohort pistsov_family
python -m video.export_relationship_graph --personas video/assets/scripts-prompts/personas_base_family_sim_full.json -o graph.json
```

---

## 8. Review — `base_family_sim/opener&005` (2026-06-22)

**Reference run:** `data/base_family_sim/opener&005` — first full auto-gen after Phase 4 wiring.

| Artifact | Value |
|---|---|
| Output | `output/trailer_9x16.mp4` — 1080×1920, **~83.6s**, ~35 MB |
| Narration | ElevenLabs `eleven_v3` **warm** / stability **0.60** / **1.5×** — 18 segments, ~160 words |
| Cast | Pistsov family ×4 (Gosha, Ivan, Katya, Luba) — AI trait lines regenerated (cache stale) |
| Blocker hit | Remotion `node_modules` missing → Step 5 skipped on first pass; fixed with `cd video/remotion && npm install`, then `python -m video.render_opener_remotion data/base_family_sim/opener&005` |
| Audio | **Confirmed present** in the rendered MP4 (narration + ducked anthem). Earlier validator LUFS false alarm was from validating before the video existed. |

### 8.1 What worked

- One-command path produces script + VO + props without manual steps (once Remotion deps installed).
- **Typing animation** on sub-lines reads well — keep `TypingText` for lines that are still being "spoken in."
- Beat map, cast cut-outs, village/pressure/aerial B-roll, and end card all render end-to-end.
- Runtime **83.6s** passes today's validator (65–95s); ~7s longer than Anya's 76.6s reference is **acceptable** — priority is motion quality, not matching seconds.

### 8.2 Fixed text should hold still (no heartbeat / pulse)

**Issue:** After a line finishes typing, some headlines keep animating — pulsing glow or RGB "ghost" layers — instead of sitting still for a beat.

**Root cause (code):**

| Component | Behaviour today | Anya intent |
|---|---|---|
| `GlitchText.tsx` | Three stacked `TypingText` layers (cyan/red/white) with continuous `sin()` flicker + RGB offset | Typing OK; once done → **static** white type |
| `AnimatedWordmark.tsx` | `filter: drop-shadow(…)` glow ramps 0→1 over 1.2s on **DOUBLE** + subtitle | Glow on **entry only**; then hold |
| `AiCoreRing.tsx` | Continuous energy pulse in hook | Fine for abstract hook; not for readable headlines |
| `WordSwapTitles.tsx` | Fade between rotating phrases | OK for cycling copy; fixed phrases need a **holdSec** plateau with no fade loop |

**Fix direction:** Add a `mode: "type-then-hold"` to shared text components — animate chars while VO speaks, then freeze opacity/transform for ≥0.8s before crossfade. Disable `GlitchText` RGB layers after typing completes (or drop glitch entirely on short headlines like "WHAT IF").

### 8.3 Voice — switch warm → trailer (next run)

Current lock (`tts.py` → `OPENER_VOICE_PROFILE`): `eleven_v3`, stability **0.60** (warm), speed **1.5×**.

**Next run:** trial **trailer** delivery at the same **1.5×** pace. Reference takes live in `video/opening-anya/_teardown/cand/` (`v3_trailer_x1.0.wav`, `v3_trailer_x1.2.wav`; generate `v3_trailer_x1.5` to match current speed). Compare side-by-side with Anya's extracted audio (`_teardown/video_audio.wav`) using `_teardown/match_vo.py` before re-locking.

**Action:** bump `OPENER_VOICE_PROFILE.stability` (or equivalent v3 trailer preset) for opener mode only; re-run TTS on `opener&006` — do not change day-trailer voice.

### 8.4 New sim / new cast — scale to 15 doubles

**Product requirement:** any new simulation with a **different cast (up to 15 Doubles)** should run the same pipeline (Playbook §15: every Double appears visually; **3–4 featured** with hero cards; **not all 15 narrated**).

**Gaps today:**

| Layer | Limit | Work needed |
|---|---|---|
| CLI | `--top` choices **1–6** (`generate_trailer.py`) | Raise cap to **15**; tier layouts **1–4 / 5–8 / 9–15** (Playbook §6.5, §16.7) |
| Context | `extract_opener_context` rejects `top_n > 6` | Align with new cap; rank when cohort > top |
| Script | `showrunner` cast loop is N-agnostic but runtime bounds assume ~4 × 3s cards | Widen bounds for large casts; cap **cast block ≤ ~20s** via tiered layouts (Playbook Ticket 5) — **total trailer may run longer** with more Doubles |
| Visuals | `graph_for_cast()` returns **empty** unless exactly 4 members | Generalize relationship layout (grid / arc / clusters) for 2–15 nodes (Playbook §6.3) |
| Cast beats | `AnyaCastBeat` = one full-screen portrait per persona (~3s each) | Replace with Playbook cast strategies: hero cards for featured only; clusters for 9–15 |
| Assets | `generate_cutouts.py` + `generate_group_photo.py` exist | Must run per cohort before render; resolver must **fail or report**, not silently use Pistsov PNGs (Playbook §5.3) |
| Group photo | `video/assets/cohort/<slug>/group_photo.png` | Required for poster frame (§8.5) on non-Pistsov sims |

**Smoke test for scale:** fork a baseline into a test sim with 8–15 personas, run cutout + group-photo generators, then `generate_trailer --mode opener --top 15`.

### 8.5 Poster frame / default thumbnail (match Anya concept card)

**Anya reference** (concept beat ~15–24s; also the frame users see before pressing play):

```
┌─────────────────────────────┐
│  [group photo + matrix HUD] │  ← matrix-filtered Family + face-scan brackets
│         DOUBLE            │  ← glowing blue (`Double.png` treatment)
├─────────────────────────────┤
│   AN AI VERSION OF YOU      │  ← white caps, centred on black band
├─────────────────────────────┤
│  [group photo — clean]      │  ← photoreal cohort shot, lower third
└─────────────────────────────┘
```

**Our `opener&005` first frame:** dark hook (`WHAT IF` glitch + particle field) — does **not** match.

**Fix direction:**

1. New Remotion beat (or rework `WordmarkBeat`) — **split vertical layout**: matrix layer / black type band / clean photo layer.
2. Stage `opening-anya/Anya_PNG_assets/Double.png` (or cohort-specific glow treatment) instead of full `DOUBLAND.png` wordmark on this beat.
3. Per-cohort **`group_photo.png`** drives both tiers (matrix filter = CSS/Canvas overlay on duplicate).
4. Export explicit **still** at concept-beat midpoint (`npx remotion still … --frame=<N>`) → ship as YouTube/custom poster alongside MP4.

Reference still for art direction: `_teardown/montage_concept.png`.

**Ivan review notes (2026-06-24, from scene-spec worksheet):**

- Poster is a **deliberate export still**, not the 67ms first-frame flash in the proxy.
- Lower group photo: OK (all family together); remove CC line "making choices like you" from poster variant.
- Upper matrix layer: must be **matrix filter on the same group photo** (darker, blue head brackets, glowing DOUBLE) — ref `Cards5_family-matrix.png`; not a separate smiling photo.
- Caption: **"AI VERSION OF YOU"** — drop "an", increase font size.
- Per cohort: Grok group photo + matrix filter derived from that photo (not Pistsov fallback on new sims).

### 8.6 Remove ghost/shadow behind "WHAT IF"

**Issue:** RGB offset layers in `GlitchText` read as a blurry double-image behind the headline (see opener&005 @ ~0:01).

**Fix:** For `headline` beats, replace `GlitchText` with plain `TypingText` (or glitch **only during** char reveal, layers removed on complete). Sub-line ("you had a second chance…") keeps typing cursor — headline holds static once typed.

### 8.7 Wire `Talk.mp4` to the hard-conversation VO line

**VO line:** *"What if you could practice that hard conversation before it ever happened?"* — **hook ~0:03–0:08**, not the concept section (Playbook §6.1, §16.6).

**Today:** `Talk.mp4` is staged on **hook** seg index 1 (`opener_beat_map.py`) at **0.35–0.45 opacity** under `Connections.png` + relationship graph — easy to miss.

**Anya:** `Anya_animated/Talk.mp4` (~9 MB) is a hero motion layer for this exact beat — chat UI, rehearsal energy, full-frame presence.

**Fix direction:** Promote `Talk.mp4` to primary background on the hard-conversation hook beat (≥0.75 opacity); drop or fade static relationship underlays on that beat; align phrase swaps to VO timing. Wire **`Family.mp4` once** for concept/cast reveal (~0:14–0:20), not as a season-loop under static `Family.png` (Playbook §16.12 #3, §6.4).

### 8.8 Gap audit — Anya folder vs auto-gen (`opening-anya/`)

Inventory of Anya's kit and how fully we consume it:

| Asset / technique | Anya (`opening-anya/`) | Auto-gen today | Gap |
|---|---|---|---|
| **Reference master** | `DOUBLAND1.mov` — 2160×3840, 120fps, 76.6s | 1080×1920 @ 30fps, **83.6s** (opener&005) | Resolution/fps deferred; runtime delta OK — **motion richness** is Phase 5 focus (Playbook §2) |
| **Hook 0–15s** | One continuous morph: eclipse ring → network diagram → ink figures | 3 separate hook beats tied to VO segments 0–2 | §4 continuous montage — largest feel gap (Playbook §6.1) |
| **Concept card** | Split group photo + `Double.png` glow + matrix HUD | Single `WordmarkBeat` with full-frame `Family.png` + `DOUBLAND.png` | §8.5 — poster + concept layout (Playbook §6.2) |
| **`Talk.mp4`** | Hero layer on hard-conversation **hook** line | Staged on hook seg 1 but low opacity under graph | §8.7 |
| **`Family.mp4`** | Human/cast reveal (once) | Not wired — static `Family.png` held across beats | Wire **once** at concept reveal (Playbook §16.12 #3) |
| **`Village.mp4`** | Cinematic exterior → map bridge | Placed on world beat as clip | Partial — needs handoff into dynamic `WorldMapHUD` (Playbook §16.12 #4) |
| **`Pressure.mp4`** | Night pressure + gauge | Wired + `PressureGauges` component | Mostly OK — compare grade/intensity |
| **`Connections.png` / `Connections2.png`** | Relationship diagram **reference boards** | Static PNG underlay + `RelationshipGraph` | Open — rebuild live `RelationshipGraph`; do not render boards directly (Playbook §16.8) |
| **`Cards1–5.png`** | Identity/trait **component templates** | Grey cut-outs only; boards unused | Open — build `DoubleIdentityCard`, trait cards (Playbook §16.4–16.5, P1) |
| **`Map.png`** | World map **reference board** | Static PNG on world/turn beats | Partial — rebuild `WorldMapHUD` with sim data (Playbook §16.5) |
| **`Survival.png`** | Season/mode **reference board** | Static PNG on season/turn | Partial — split into dynamic `SeasonModeBanner` + `SurvivalDashboard` (Playbook §16.5) |
| **`Asset.png` / `Asset2.png`** | Hook motif **reference boards** | Motifs abstracted in `GoldTransition`, `AiCoreRing` | OK as inspiration — **never direct-render boards** (Playbook §16.8) |
| **`Profile.png`** | Concept montage plate | Not referenced | Open — concept beat supporting layer (Playbook §16.6) |
| **Individual PNG cut-outs** | Gosha, Ivan, Katya, Luba | Per-agent cutouts or sheets | OK for Pistsov; needs `--grok` path for new casts |
| **Transition SFX** | Whoosh / typing on beat changes | Not in Remotion audio mix | §4 — library exists, unwired (Playbook §9) |
| **Narration** | Hand-edited ElevenLabs v3 warm @ 1.5× | Auto warm @ 1.5× | §8.3 — A/B **trailer** profile; lock `trailer_v3_x1.5` if winner (Playbook §9.1) |
| **CapCut project** | Blueprint for timing/effects | N/A (headless) | Reference for polish passes, not runtime |

**Implementation order:** follow **Playbook §12 P0** (canonical). The list below mirrors it for quick cross-ref only — if order differs, **Playbook wins**.

1. Poster/concept split frame + poster still export (§8.5 · Playbook P0 #7–8)
2. `type-then-hold` + remove headline glitch (§8.2, §8.6 · Playbook P0 #3)
3. Visual timeline decoupling + hook morph (§4 · Playbook P0 #1–2)
4. `Talk.mp4` hero on hook hard-conversation line (§8.7 · Playbook P0 #4)
5. End card hold polish + SFX/mix ~-14 LUFS (Playbook P0 #5–6) — not driven by total-second target
6. `Family.mp4` once at concept reveal; asset manifest + block reference boards (Playbook §16.12)
7. Trailer VO A/B (§8.3 · Playbook §9.1)
8. Cast scale 1–15 + component library (§8.4 · Playbook P1)

### 8.9 Next run checklist (`opener&007` — after Phase 6A)

```bash
# One-time if fresh clone
cd video/remotion && npm install

# Optional: per-cohort assets (required for non-Pistsov sims)
python video/assets/scripts-prompts/generate_cutouts.py --grok --skip-existing
python video/assets/scripts-prompts/generate_group_photo.py --cohort <slug>

python -m video.generate_trailer <sim> opener --mode opener --top 4 --cohort-name "<Cohort label>" --force
```

**Review vs Anya:** `teadown/reference_grabs/` at CSV timecodes + `teadown/scene_spec.md` — not side-by-side scrubbing alone.

### 7.1 Asset quick reference (Anya kit)

| Role | Path |
|---|---|
| Reference master | `D:\Coding\generative_agents\video\opening-anya\DOUBLAND1.mov` |
| Motion clips | `…/opening-anya/Anya_animated/` (Talk, Family, Village, Pressure) |
| PNG kit | `…/opening-anya/Anya_PNG_assets/` |
| Concept still | `…/opening-anya/_teardown/montage_concept.png` |
| Matrix poster ref | `…/Anya_PNG_assets/Cards5_family-matrix.png` |
| 006 output | `…/data/base_family_sim/opener&006/output/trailer_9x16.mp4` |
| 006 props | `…/video/remotion/props/base_family_sim__opener_006.json` |
| Staged render assets | `…/video/remotion/public/render/` (rebuilt each props build) |

**Tags:** SOURCE = original kit · STAGED = Remotion copy · REF = design board only (do not full-frame render) · CODE = Remotion component

### 8.10 Review — `base_family_sim/opener&006` (2026-06-22)

**Reference run:** first Phase 5 P0 pass after producer teardown was commissioned.

| Artifact | Value |
|---|---|
| Output | `output/trailer_9x16.mp4` — 1080×1920, **~82.4s**, ~31 MB |
| Poster | `output/poster.png` @ frame ~455 (~15s concept midpoint) |
| Narration | ElevenLabs `eleven_v3` warm / 1.5× — 18 segments |
| Loudness | **~-13.9 LUFS** after loudnorm; validation PASS |
| Cast | Pistsov ×4 — showrunner-regenerated trait lines (may differ from Anya lock copy in `text_log.csv`) |

**What 006 proved:** one-command path, type-then-hold text, `hookContinuous`, Talk hero, concept poster + Family.mp4 once, SFX pipeline, poster export, asset manifest.

**What 006 still lacks (Phase 6):** ~50 sub-moments, cast selection panels, mid-trailer URL, UI morph layers, producer-accurate timing (concept @ 10.8s), structured end card, ~39 SFX hits. Baseline for gap closure — compare future runs against this + `teadown/`.
