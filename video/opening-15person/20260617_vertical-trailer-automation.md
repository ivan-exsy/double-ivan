# Opening Trailer — Implementation Plan

## References
PRIMARY implementation doc · Phase 0–6 DONE · P1 OPEN · Latest: `opener&008`
Creative bible → `sot-opening-trailer.md` · Visual SOT → `teadown/`


> **Primary engineering plan** for auto-generating vertical (9:16) opening trailers. Goal: match Anya's hand-edited cut (`video/opening-anya/DOUBLAND1.mov`). Scope locked **2026-06-17: vertical only**. Creative standard + asset map: **`sot-opening-trailer.md`** (Part I playbook). Visual timing: **`trailer-opening/teadown/`**.

**Duration policy:** Total trailer length is **not a hard product requirement**. A few seconds vs Anya's hand cut is fine (e.g. **~76.7s** narration vs **~77s** final MP4 on `opener&008`). **Larger casts are expected to produce longer trailers** — tiered layouts keep the cast *block* efficient (~15–20s); validator band today **65–95s**.

**Data posture (2026-06-25):** Trailer pipeline must be **Supabase-first** — read cast, scratch, relationships, and trait lines from Supabase; write generated assets, copy, QA status, and render outputs back to **Supabase Storage + DB tables**. Local paths (`video/assets/`, `data/*/opener&*`, `remotion/public/render/`) are **dev/bootstrap or render transport**, not canonical state. See **`20260625_trailer-workbook.md` § Data posture** for the pilot plan; soul15 work should not add new disk-only SOT paths.

---

## Implementation status

**Latest reference run:** `data/base_family_sim/opener&008` — **~77.2s**, validation **PASS**, poster export @ frame **340** (~11.35s). Visual spec verified against native **2160×3840 / 76.578s** master (`teadown/20260624_doubland_master_verification_addendum.md`). Opening flash + black reset + WHAT IF @ ~0.133s aligned in code post-verification.

The pipeline is **production-capable for Pistsov ×4**: one-command `generate_trailer` → Remotion render → LUFS gate. Producer CSVs drive **text timing**, **SFX timing**, and **section-level beat boundaries**; ~16 macro beats carry **named transition primitives** (poster, cast panel, mid-URL, survival UI, etc.). Full **65 sub-moment Sequences** are not built — sub-moments are in props for QA; visuals attach via beat `phases[]` / overlay flags.

| Milestone | Run | Summary |
|---|---|---|
| Phase 0–4 | — | Remotion stack, Package A, `generate_trailer` integration (**§6**) |
| Phase 5 P0 | `opener&006` | Type-then-hold, hook merge, Talk hero, first poster export, SFX/mix (**§8.10**) |
| Phase 6A | `opener&007` | CSV planner, `textTrack` overlay, 40 SFX in props, section retiming (**§8.11**) |
| Phase 6B–6D | `opener&008` | Poster/matrix, end-card takeover, cast panel, mid-URL, world/survival/turn UI scaffolds (**§8.12**) |

### Shipped — brief summaries

- **Phase 6A (`007`):** Vendored `teadown/` CSVs → `opener_visual_planner`; global `SharedCenterReplace` text axis; macro beats retimed to producer sections; 40 SFX events in props.
- **Phase 6B (`008`):** `generate_matrix_photo.py` + three-band `ConceptPosterBeat`; opening **poster flash** (~50 ms / frames 0–1 @ 30 fps) + **black reset** before WHAT IF @ ~0.133s; **export still** @ 11.35s; `QuestionToUrlTakeover` end card ending **76.578s**; hook `ConversationHud` / `PersistentLayerSwap`. Poster spec: **§8.5**.
- **Phase 6C (`008`):** `ActiveDoublesPanel` + `CardSelectZoom` on cast beats; `MidUrlPlate` @ 59.4s; `RadialObjectMatch` + live `backgroundCuts`.
- **Phase 6D (`008`):** `ConceptDeconstruct`, `WorldMapHud`, `UiStateMorph`, `SurvivalDashboard`, `TurnDashboard` — functional scaffolds on macro beats (not pixel-perfect vs Anya boards yet).

### Remaining / TODO

| Priority | Item | Detail in doc |
|---|---|---|
| **Now** | **Supabase-first trailer schema** — cohort manifest, asset registry, Storage buckets; stop growing disk SOT | **§5.1**, workbook Phase 0a |
| **Now** | **soul15 pilot** — seed manifest + **locked trait lines** in DB; register existing sheets/walkouts | **`20260625_trailer-workbook.md`** |
| **Now** | Manual QA — diff latest render vs `teadown/reference_grabs/` at CSV timecodes; add **0.133s** (WHAT IF) check | **§8.12**, **§8.13** |
| **Now** | Per-cohort **Grok group + matrix photos** → **Storage + asset rows**; stop silent Anya `Family.png` fallback | **§8.5**, **§8.4**, **§5.1** |
| **Now** | Stage **SFX library** (shared kit or Storage); 40 prop events audible | **§4**, **§7** |
| **P1** | Cast scale **1–15**, tiered layouts, cast block ≤ ~20s; soul15 Option A montage | **§8.4**, **§6** |
| **P1** | Trait lines from **DB/manifest cache**, not per-render LLM for cohort trailers | **§3**, workbook Phase 5 |
| **P1** | Supabase relationship graph labels; layout for 2–15 nodes | **§4**, **§8.4** |
| **P1** | **Editorial-motion validator** (low-motion, visual-change rate ~23.5/min) | **§4**, Playbook Ticket 7 |
| **P1** | **Trailer VO A/B** (warm vs trailer @ 1.5×) | **§8.3** |
| **P1** | Polish UI scaffolds toward Anya art fidelity | **§8.8**, Playbook §16.12 |
| **P2** | Golden test set (4/8/15 cast), 60fps, 16:9 master, homepage hero loop | **§6** (P2) |

### Next steps (recommended order)

1. **Supabase schema (0a)** — `cohort_trailer_manifest`, `trailer_asset`, Storage layout; `db_reference.md`.
2. **soul15 manifest seed (0b)** — DB rows with **locked trait lines** (no manual approval step in pipeline).
3. **QA pass** — scrub at **0.033 · 0.133 · 11.3 · 41.4 · 53 · 59.4 · 73.8 · 76.578s** vs grabs (**§8.12–8.13**).
4. **Asset register** — upload/register soul15 character sheets + walkouts; generators write Storage + DB.
5. **Cohort Grok assets** — group + matrix photos with Storage register (**§8.5**).
6. **SFX staging** — populate library; re-render and spot-check sync.
7. **P1 kickoff** — cast scale + DB-driven asset resolution (**§8.4**).

```bash
python -m video.generate_trailer base_family_sim opener --mode opener --top 4 --cohort-name "Pistsov family" --force
# → data/base_family_sim/opener&008 (or next increment)
```

---

| Document | Role | When to use |
|---|---|---|
| **This doc (`20260617_…`)** | **Primary implementation plan** — built state, commands (§7), gaps (§4, §8), P1 backlog | Day-to-day engineering; what's shipped vs what's next |
| **`20260501_opening-trailer.md`** | **Opening trailer bible** (draft → `sot-opening-trailer`) — Part I: creative playbook + asset map; Part II: commission punch list | *What good looks like*; asset render policy; cast tiers |
| **`trailer-opening/teadown/`** | **Visual timing SOT** — 65 sub-moments, text/SFX logs, reference grabs; master-verified **76.578s** | Beat implementation; QA diff at a timecode |
| **`video/video_PRD.md`** | Product requirements for video/trailer features | Scope questions |

**Governance:** Producer teardown wins on **visual timing, sub-moment structure, on-screen copy, and SFX sync**. Opening trailer bible (Part I) wins on **asset policy, cast scale, mix targets, and acceptance framework**. This doc tracks **what code actually does today**.

## 1. Anya's cut — the facts

- **Format:** 2160×3840 (9:16 vertical), 120fps, **76.578s** master runtime, HEVC. Mobile-first. Engineering renders **1080×1920** (50% scale); native 9:16 — no proxy side margins.
- **Narration:** ElevenLabs **`eleven_v3`** warm take at **1.5×** (evolved from the `v3_warm_x1.2` experiment), with inline delivery cues `[curious]` / `[warmly]` / `[excited]`. Script = showrunner opener fixed blocks (v2.4 "Anya cut" **minus** the dropped *"sometimes… you never noticed before"* line). Pauses minimal (~2.75s total silence). **Narration audio ~76.7s** — close to Anya's **76.578s** master. **Final MP4** may run slightly longer when VO tail + composition padding apply — acceptable; see Duration policy. Reference: `video/voiceover/auto_match_v3_warm_x1.5/narration.mp3`. Legacy producer script still at `video/anya/narration_anya.json`.
- **Her toolkit:** ~24 transparent PNG overlay graphics + 4 short image-to-video B-roll loops (`opening-anya/Anya_animated/{Family,Pressure,Talk,Village}.mp4`, 3–5s each, mixed aspect) + existing anthem + SFX library. **Editor: CapCut** (project file available on request — usable as a *blueprint*, not a render engine; CapCut can't run headless). Reference cut + assets live in `video/opening-anya/`.

## 2. Beat / shot map

**Authoritative timing:** `trailer-opening/teadown/20260624_doubland_timecode_index.csv` (65 sub-moments, **76.578s** master). The coarse table below is a **legacy macro summary** — use producer index for implementation. Key corrections vs old approximations: **concept starts ~10.8s** (not ~15s); **cast starts ~41.4s**; **mid-trailer URL @ ~59.4s**; **end card §18 @ ~71.7–76.578s**; **WHAT IF readable ~0.133s** after poster flash + black reset.

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
| Script | `showrunner.py` | Fixed hook/concept/closing + season framing + per-cast lines (**today:** LLM + `video_narration_cache`; **target:** trait lines from cohort manifest / cache — no manual approval gate) |
| Voice | `tts.py` | Opener: `eleven_v3` / stability 0.60 / **1.5×** → `narration_timing.json` (18 segments) |
| Visual plan | `build_opener_visual_planner.py` | Producer CSVs → sub-moments, `textTrack`, SFX events, section boundaries |
| Assets | `generate_cutouts.py`, `generate_group_photo.py`, `generate_matrix_photo.py` | Per-cohort assets (**today:** local paths under `video/assets/`; **target:** Supabase Storage + `trailer_asset` rows) |
| Props | `build_opener_remotion_props.py` | VO segments → beat map + CSV overlays + staged assets |
| Render | `render_opener_remotion.py` | `npx remotion render` → `trailer_9x16.mp4` |
| Gate | `validate_trailer.py` | **Today:** 9:16, **65–95s** (wide band; longer OK for large casts), LUFS check. **Target (Playbook §11):** editorial-motion gates, ~**-14 LUFS**, true peak ≤ -1 dBTP, poster export — not a strict 70–85s cap |

**Not used for opener anymore:** Phaser static capture, `compose_opener_trailer` (FFmpeg), 16:9 master. Day modes (`day_in_life`, `day_overview`) still use FFmpeg `compose_trailer.py` unchanged.

**Pistsov reference path (manual):** `build_anya_package_a_props.py` + locked `auto_match_v3_warm` timing — bypasses showrunner/TTS for Anya-asset QA.

## 4. Gap vs Anya's cut (post–`opener&008`)

Phase 6 closed the **structural** gap (timing, text/SFX tracks, named primitives on macro beats). **Polish and scale** gaps remain.

| Gap | Status |
|---|---|
| **CSV visual planner + text/SFX tracks** | **Done (6A/007)** — 65 sub-moments in props; overlay + retiming active |
| **Named transition primitives** | **Scaffolded (6B–6D/008)** — poster, end card, cast panel, mid-URL, radial match, world/survival/turn UI; art fidelity vs Anya boards still P1 |
| **Producer timecodes** | **Mostly done** — concept @ 10.8s, cast @ ~41.4s, mid-URL @ 59.4s, end @ ~76.6s |
| **Poster still / concept card** | **Done (6B/008)** — matrix/clean tiers, flash @ 0, still @ 11.35s; cohort Grok photos may still fallback to Anya kit (**§8.5**) |
| **End card `questionToUrlTakeover`** | **Done (6B/008)** — phased fog → Q → URL; tail 0.3s |
| **Hook handoffs §1–3** | **Partial** — ring, Talk hero, conversation HUD, ink figures; continuous morph feel vs Anya still softer |
| **SFX audible mix** | **Partial** — 40 events in props; library often unstaged locally |
| **Mix loudness** | **Done** — ~-14 LUFS after loudnorm |
| **Multi-cast (up to 15)** | **Open (P1)** — `--top` cap 6; tiered layouts not built (**§8.4**) |
| **Per-cohort assets (non-Pistsov)** | **Open (P1)** — generators exist; **disk paths today**; need Storage register + DB resolver (**§5.1**, **§8.4**, **§8.5**) |
| **Supabase-first manifest + assets** | **Open (Now)** — `manifest.json` on disk is pilot bootstrap; no `trailer_asset` table yet | **§5.1** |
| **Editorial-motion validator** | **Open (P1)** — technical LUFS/9:16 only today |
| **Trailer VO A/B** | **Open (P1)** — warm @ 1.5× locked (**§8.3**) |
| **Resolution / fps** | **Deferred (P2)** — 1080×1920 @ 30fps vs Anya 2160×3840 @ 120fps |

The original FFmpeg `drawtext` gap is **closed** — opener visuals are Remotion-only.

## 5. Architecture (as built)

**Today (`opener&008`):**

```
persona_ranker → showrunner → tts (18 segments)
              → build_opener_visual_planner (CSV) + build_package_a_beats_v2
              → [optional: cutouts / group_photo / matrix_photo / graph]
              → build_opener_remotion_props → npx remotion render
              → validate_trailer (9:16 + LUFS) + poster still
              → output on local disk (data/<sim>/opener&NNN/)
```

**Target (Playbook §5 + Supabase-first, soul15 pilot):**

```
Supabase: sim roster + scratch + relationships + cohort manifest + trait lines
       → generate_cohort_assets (Grok/local gen → Storage upload + trailer_asset rows)
       → showrunner reads trait lines from cohort manifest / video_narration_cache
       → tts → visual planner → props builder (resolve Storage URLs)
       → Remotion render (local staging dir = transport only)
       → upload MP4/poster + validation report to Storage + trailer_run row
```

### 5.1 Supabase-first data model (to build)

**Already in Supabase (reuse):**

| Table | Trailer use |
|---|---|
| `video_narration_cache` | Trait lines, season framing, other LLM narration; `pinned` = optional hand-edit override (not a required approval step) |
| `persona_scratch` / sim persona tables | `scratch_compact` for trait **generation** when manifest has no pre-seeded line |
| `persona_day_snapshots` | Day-trailer scratch context |
| Sim + persona identity | UUID-scoped cast; no filename heuristics |

**New (migration required — names illustrative):**

| Store | Purpose |
|---|---|
| `cohort_trailer_manifest` | One row per (sim, persona): spotlight order, featured, trait line text, status, layout tier |
| `trailer_asset` | One row per asset: sim, persona id (nullable), `asset_type` (cutout, hero, walkout, group_photo, …), Storage path, `prompt_hash`, `qa_status` |
| `trailer_run` (optional) | Render job: sim, opener id, output URLs, validator JSON, duration |
| **Storage bucket(s)** | `trailer-assets/{sim}/{persona_id}/{type}.ext` + cohort-level group/matrix + final renders |

**Local disk — allowed roles only:**

| Path | Role |
|---|---|
| `video/opening-anya/`, `video/fly-over/` | Shared brand / village kit (or migrate to `brand-assets` bucket) |
| `video/remotion/public/render/` | Per-render staging copy from Storage URLs |
| `data/*/opener&*/` | Dev run folder until upload step exists |
| `video/assets/users/*` | **Legacy** — migrate soul15 inputs to Storage; do not add new cohort folders as SOT |

**Anti-patterns to remove:**

- `manifest.json` as the only place trait lines live
- Generators that write `video/assets/cohort/<slug>/` without DB + Storage register
- `build_opener_remotion_props` resolving cohort assets from laptop paths when DB row missing
- Silent fallback to Anya/Pistsov PNGs when Storage object missing (fail or warn)

### Asset buckets (logical)
- **Reusable once (built):** Remotion components in `video/remotion/src/components/` + `opener_beat_map.py` + brand assets in `opening-anya/`.
- **Per-village (the_ville = done):** village B-roll, map, night aerial (`video/fly-over/`).
- **Per-cast:** cut-out portraits, group photo, trait narration, relationship graph data — **registered in Supabase** (Storage + `trailer_asset`); local copies are not authoritative.

## 6. Phased plan (reference)

| Phase | Status | Summary |
|---|---|---|
| 0 — spec lock | **Done** | Narration + cut-outs locked 2026-06-17 |
| 1 — Remotion skeleton | **Done** | |
| 1b — narration lock | **Done** | v3 warm / 1.5× / ~76.7s VO |
| 1c — Package A | **Done** | Anya assets wired |
| 2 — motion-graphic components | **Done** | |
| 2.5 — visual polish | **Done** | AI-core ring, graph, gold transition |
| 3 — per-cast automation | **Done** | Props builder, cut-outs, group photo |
| 4 — integrate + gate | **Done** | `generate_trailer` → Remotion |
| 5 — polish P0 | **Done** (`006`) | **§8.10** |
| 6A — visual spec foundation | **Done** (`007`) | **§8.11** |
| 6B–6D — visual grammar | **Done** (`008`) | **§8.12** |
| **P1 — scale & quality** | **Open** | See **§8.4**, **§8.3**, gap table **§4** |
| **P2 — delivery variants** | **Deferred** | 60fps, 16:9, hero loop, golden test matrix |

### P1 — new simulations & casts (detail: **§8.4**, **§5.1**)

Target: any sim with **1–15 Doubles** renders without manual Remotion edits, wrong-cohort assets, or **laptop-dependent asset folders**.

- **Supabase-first foundation** — cohort manifest table, `trailer_asset` registry, Storage buckets; migrate soul15 bootstrap off disk JSON
- **Trait line workflow** — seed or LLM-generate → write DB/cache with `trait_line_status: approved` in one step; showrunner reads on render (**no manual approval gate**; `pinned` only for hand-edits)
- **Cast scale** — `--top 15`; soul15 `fifteen_spotlight_montage` **cast block implemented** (~46 s visual); full opener ~90–105 s pending VO/world beats
- **Relationship graph** — Supabase-driven labels; 2–15 node layouts
- **Per-cohort assets** — generate → **Storage upload + asset row**; validator queries DB; fail/warn on missing (**§8.5**)
- **Component polish** — identity cards, map HUD, survival/turn UI to match Anya boards (**§8.8**)
- **Editorial validator** — motion density, static-run length, repetition flags
- **Trailer VO A/B** — warm vs trailer @ 1.5× (**§8.3**)
- **Scale smoke test** — second cohort end-to-end using **DB + Storage only** (workbook Phase 7)

### P2 — defer until P1 pass

Golden test set (4 / 8 / 15 cast), composition variants, 60fps delivery, thumbnail scoring, homepage hero loop, 16:9 master.

**Cost shape:** Style layer is built once. Each new cast ≈ regenerate cut-outs (+ optional group photo) + one `generate_trailer` run.

## 7. Commands (quick reference)

```bash
# Full opener (production path)
python -m video.generate_trailer base_family_sim opener --mode opener --top 4 --cohort-name "Pistsov family"

# Pistsov QA with Anya's locked assets
python -m video.build_anya_package_a_props
cd video/remotion && npx remotion render OpenerTrailer out/pistsov_package_a.mp4 --props=props/pistsov_package_a.json

# Per-cohort assets (before or after a run)
# Target (§5.1): upload to Storage + register trailer_asset rows after each generator
python video/assets/scripts-prompts/generate_cutouts.py --skip-existing
python video/assets/scripts-prompts/generate_group_photo.py --cohort pistsov_family
python video/assets/scripts-prompts/generate_matrix_photo.py --cohort pistsov_family
python -m video.export_relationship_graph --personas video/assets/scripts-prompts/personas_base_family_sim_full.json -o graph.json

# soul15 cast-block preview (fifteen_spotlight_montage) — versioned MP4 for A/B review
python -m video.build_fifteen_spotlight_props --cohort soul15_seed_20260224
cd video/remotion && npx remotion render OpenerTrailer out/soul15_seed_20260224_spotlight_preview_vN.mp4 \
  --props=props/soul15_seed_20260224__spotlight_preview.json
# ↑ replace vN with the version printed by the props builder (auto-increments)
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

### 8.2 Fixed text should hold still — **shipped (`006`/`007`)**

**Implemented:** `type-then-hold` on shared text components; macro beats use `suppressCenterText` + global `textTrack` overlay (6A). Short headlines may still show residual glitch layers — see **§8.6** (partial).

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

### 8.5 Poster frame / concept card — **shipped `008`**

**Implemented:** Three-band `ConceptPosterBeat` (matrix top / black band / clean bottom); `generate_matrix_photo.py`; **opening flash** ~50 ms (not a readable hold) + **export still** @ **11.35s** (frame 340); caption **"AI VERSION OF YOU"** on band (locked product copy); `Family.mp4` only in deconstruct overlay, not poster top tier.

**Still open (P1):** Grok-generated cohort photos for non-Pistsov sims; diff matrix art vs `Cards5_family-matrix.png`; optional validator flag for missing cohort assets.

**Two poster moments (do not conflate):**

| Moment | Timing | Purpose |
|---|---|---|
| Opening flash | ~0–0.050s master (~frames 0–1 @ 30 fps) | Thumbnail pre-roll only |
| Export still | ~11.35s | YouTube / custom poster — deliberate readable frame |

**Anya reference layout:**

```
┌─────────────────────────────┐
│  [group photo + matrix HUD] │  ← matrix-filtered Family + face-scan brackets
│         DOUBLE            │  ← glowing blue (`Double.png` treatment)
├─────────────────────────────┤
│   AI VERSION OF YOU         │  ← white caps, centred on black band
├─────────────────────────────┤
│  [group photo — clean]      │  ← photoreal cohort shot, lower third
└─────────────────────────────┘
```

**Historical:** `opener&005` opened on hook, not poster. **`007`** had wrong poster art/timing — fixed in **`008`**.

**Ivan review notes (2026-06-24)** — addressed in 6B/008 except cohort Grok path (P1):

- Poster is a **deliberate export still**, not the 67ms first-frame flash in the proxy (optional flash = 6B product call).
- Lower group photo: OK (all family together); **poster still must not include** CC line "making choices like you".
- Upper matrix layer: **matrix filter on the same group photo** — not `Family.mp4` or a separate smiling photo.
- Caption: **"AI VERSION OF YOU"** — drop "an", increase font size on black band.
- Per cohort: Grok **group photo once** + **matrix filter derived from that photo** (P1 enforcement).

Reference: `_teardown/montage_concept.png` · `Anya_PNG_assets/Cards5_family-matrix.png`.

### 8.6 Remove ghost/shadow behind "WHAT IF" — **partial (`006`)**

**Issue:** RGB offset in `GlitchText` reads as blur behind headline.

**Fix direction:** Glitch only during char reveal, or plain `TypingText` on short headlines. See **§8.2**.

### 8.7 Wire `Talk.mp4` to hard-conversation hook — **shipped (`006`/`008`)**

Talk hero on hook seg 1 at **≥0.85 opacity** with `ConversationHud`. `Family.mp4` once in concept deconstruct (not poster top). Historical gap audit: **§8.8**.

### 8.8 Gap audit — Anya kit vs auto-gen (snapshot `008`)

Inventory of Anya's kit vs **`opener&008`**. Rows marked **P1** = polish or scale still open.

| Asset / technique | Anya (`opening-anya/`) | Auto-gen today | Gap |
|---|---|---|---|
| **Reference master** | `DOUBLAND1.mov` — 2160×3840, 120fps, 76.6s | 1080×1920 @ 30fps, **~77.2s** (`008`) | P2 resolution/fps; runtime OK |
| **Hook 0–11s** | Continuous morph | `hookContinuous` + HUD + ink figures | Partial — softer than Anya montage |
| **Concept card** | Split group + matrix HUD | Three-band poster + deconstruct | **Done** scaffold (**§8.5**) |
| **`Talk.mp4`** | Hero on hook | Hero ≥0.85 + `ConversationHud` | **Done** |
| **`Family.mp4`** | Cast reveal once | Deconstruct overlay only | **Done** |
| **`Village.mp4`** | Exterior → map | World beat + `WorldMapHud` scaffold | Partial P1 |
| **`Pressure.mp4`** | Night pressure + gauge | Wired + gauges + radial match | Mostly OK |
| **`Connections*.png`** | Reference boards | Dynamic `RelationshipGraph` / `UiStateMorph` | P1 polish |
| **`Cards1–5.png`** | Component templates | `ConceptDeconstruct` scaffold | P1 `DoubleIdentityCard` |
| **`Map.png` / `Survival.png`** | Reference boards | `WorldMapHud` / `SurvivalDashboard` | P1 polish |
| **Transition SFX** | Beat punctuation | 40 in props; often unstaged | Stage library (**§4**) |
| **Narration** | Hand-edited warm | Auto warm @ 1.5× | P1 A/B (**§8.3**) |

### 8.9 Run checklist (`opener&008+`)

```bash
# One-time if fresh clone
cd video/remotion && npm install

# Optional: per-cohort assets (required for non-Pistsov sims)
python video/assets/scripts-prompts/generate_cutouts.py --grok --skip-existing
python video/assets/scripts-prompts/generate_group_photo.py --cohort pistsov_family
python video/assets/scripts-prompts/generate_matrix_photo.py --cohort pistsov_family

python -m video.generate_trailer base_family_sim opener --mode opener --top 4 --cohort-name "Pistsov family" --force
# → data/base_family_sim/opener&00N/output/trailer_9x16.mp4 + poster.png
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
| 008 output | `…/data/base_family_sim/opener&008/output/trailer_9x16.mp4` |
| 008 poster | `…/data/base_family_sim/opener&008/output/poster.png` |
| Staged render assets | `…/video/remotion/public/render/` (rebuilt each props build) |

**Tags:** SOURCE = original kit · STAGED = Remotion copy · REF = design board only (do not full-frame render) · CODE = Remotion component

### 8.10 Review — `opener&006` — Phase 5 P0

**Summary:** First polish pass — type-then-hold, `hookContinuous`, Talk hero, coarse poster, 4s end hold, ~7 SFX, ~82.4s. Superseded by Phase 6; baseline for regression.

| Artifact | Value |
|---|---|
| Output | `output/trailer_9x16.mp4` — 1080×1920, **~82.4s**, ~31 MB |
| Poster | `output/poster.png` @ frame ~455 (~15s concept midpoint) |
| Narration | ElevenLabs `eleven_v3` warm / 1.5× — 18 segments |
| Loudness | **~-13.9 LUFS** after loudnorm; validation PASS |
| Cast | Pistsov ×4 — showrunner-regenerated trait lines (may differ from Anya lock copy in `text_log.csv`) |

**What 006 lacked (now addressed in 008):** producer timing, text/SFX CSV tracks, structured end card, cast panel, mid-URL, UI layers — see **§8.12**.

### 8.11 Review — `opener&007` — Phase 6A

**Summary:** CSV planner + `textTrack` overlay + section retiming. Poster art/timing still wrong — fixed in **008** (**§8.5**, **§8.12**).

| Artifact | Value |
|---|---|
| Output | `output/trailer_9x16.mp4` — ~83.7s, validation **PASS** |
| Props | `visualTotalSec` 76.6 · `subMoments` 65 · `textTrack` 51 · `sfx` 40 |
| Retiming | `hookContinuous` ends **10.8s** · `conceptPoster` starts **10.8s** · poster frame **378** (~12.6s) |
| Overlay | `SharedCenterReplace` global text track; macro beats use `suppressCenterText` |
| Poster gaps (007) | Upper `Family.mp4`; caption "AN…"; still @ 12.6s — **fixed in 008** |

### 8.12 Review — `opener&008` — Phase 6B–6D (current reference)

| Artifact | Value |
|---|---|
| Output | `output/trailer_9x16.mp4` — **~77.2s**, validation **PASS** |
| Poster | `output/poster.png` @ frame **340** (~11.35s) + **67ms flash** @ t=0 |
| Props | All Phase 6B–6D flags: `posterFlash`, `matrixPhoto`, `midUrlPlate`, cast panel, survival, turn dashboard |
| Runtime | Closer to Anya **76.6s** visual end (was ~83s on 007) |

**Manual QA:** diff vs `teadown/reference_grabs/` at 0.033 · 11.3 · 41.4 · 53 · 59.4 · 73.8s.

**Known gaps (→ P1):** cohort Grok photos; staged SFX; UI scaffold art fidelity vs Anya boards (**§4**, **§8.8**).

### 8.13 Master verification addendum (2026-06-24)

**Source:** `teadown/20260624_doubland_master_verification_addendum.md` — corrections verified against `DOUBLAND1.mov` (2160×3840 native 9:16, **76.578s**).

**What changed in teadown + code (not a Phase 6 rebuild):**

| Item | Master-correct value | Code status |
|---|---|---|
| Runtime metadata | 76.578 s | `visualTotalSec` + end-card `urlOnly` → **76.578** |
| Poster §0 | 0.000–0.050 s flash | `posterFlash` ≈ frames 0–1 @ 30 fps |
| Hook §1 start | 0.050 s + black reset | `hookContinuous` retimed; WHAT IF display **0.133 s** |
| End §18.5 | 76.000–76.578 s URL hold | Phases updated; no post-settle pulse |
| Native 9:16 | Full canvas, no proxy margins | Remotion 1080×1920 — OK |

**Copy policy (locked 2026-06-24):**

| String | Anya reference master | Product / auto-gen |
|---|---|---|
| Poster band | AN AI VERSION OF YOU | **AI VERSION OF YOU** |
| Season line | THE PISTSOFF FAMILY ENTERS (typo) | **THE PISTSOV FAMILY ENTERS** |

Reference CSVs in `teadown/` keep Anya’s literal strings for audit; `build_text_track()` applies the product corrections above at render time.

**QA timecodes (post-verification):** 0.033 · **0.133** · 11.3 · 41.4 · 53 · 59.4 · 73.8 · **76.578**
