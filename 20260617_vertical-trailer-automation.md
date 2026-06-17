# Vertical Trailer Automation — Teardown + Plan

=============================
<FULLY IMPLEMENTED: Run script to verify results>
=============================


> Goal: auto-generate vertical (9:16) opening trailers for any new cast/simulation that match the style and polish of Anya's hand-edited cut (`video/opening-anya/DOUBLAND1.mov`). Scope locked **2026-06-17: vertical only** for now. Companion to `20260501_opening-trailer.md` (asset punch list) and `video_PRD.md`.

---

## 1. Anya's cut — the facts

- **Format:** 2160×3840 (9:16 vertical), 120fps, **76.6s**, HEVC. Mobile-first.
- **Narration:** ElevenLabs **`eleven_v3`** warm take at **1.5×** (evolved from the `v3_warm_x1.2` experiment), with inline delivery cues `[curious]` / `[warmly]` / `[excited]`. Script = showrunner opener fixed blocks (v2.4 "Anya cut" **minus** the dropped *"sometimes… you never noticed before"* line). Pauses minimal (~2.75s total silence). **Auto-gen lands ~76.7s** — matches Anya's 76.6s hand-cut. Reference: `video/voiceover/auto_match_v3_warm_x1.5/narration.mp3`. Legacy producer script still at `video/anya/narration_anya.json`.
- **Her toolkit:** ~24 transparent PNG overlay graphics + 4 short image-to-video B-roll loops (`opening-anya/Anya_animated/{Family,Pressure,Talk,Village}.mp4`, 3–5s each, mixed aspect) + existing anthem + SFX library. **Editor: CapCut** (project file available on request — usable as a *blueprint*, not a render engine; CapCut can't run headless). Reference cut + assets live in `video/opening-anya/`.

## 2. Teardown — beat / shot map

Hard-cut timestamps (ffmpeg scene detection): 0, 23.5, 24.0, 27.2, 31.8, 35.0, 43.2, 45.7, 48.3, 49.1, 63.0, 66.4, 71.7, 73.8. Long gaps between cuts = continuous morphing motion-graphic sequences (she favors smooth transitions over hard cuts).

| t (s) | Beat | On screen | Technique |
|---|---|---|---|
| 0–15 | **Hook** | "What if…" → eclipse ring → glowing network-of-people diagram → blue "ink-figure" forming from smoke | Continuous kinetic-type + abstract motion graphics (no cuts) |
| 15–24 | **Concept** | "DOUBLE" wordmark + portrait cards: "an AI version of you / talking / reacting / making choices like you" | Portrait cards, kinetic captions |
| 24–37 | **World** | Cast group → cinematic Tudor village exterior → illustrated top-down map w/ UI → "watch it live with other Doubles / every choice / every relationship" | Live footage + map UI overlays |
| 37–50 | **Cast** | The 4 Pistsovs as **photo-real cut-outs on grey**, full-body, each with a one-line trait | Cut-out portraits, trait captions |
| 50–60 | **Pressure** | Speedometer/gauge (HIGH→LOW) + night-village aerials with glowing windows | Bespoke gauge graphic, graded night footage |
| 60–73 | **Turn** | Day map "these aren't just avatars / they learn / they surprise you / you ask…" | Footage + captions |
| 73–77 | **End card** | "what would MY Double do?" → animated DOUBLAND wordmark + doubland.ai | Brand motion + CTA |

## 3. What the pipeline does today (opener mode)

`python -m video.generate_trailer <sim> opener --mode opener --top 4 --cohort-name "…"` runs the full chain and outputs **`output/trailer_9x16.mp4`** (1080×1920) via Remotion:

| Step | Module | Role |
|---|---|---|
| Cast pick | `persona_ranker.py` | Selects featured personas |
| Script | `showrunner.py` | Fixed hook/concept/closing + AI season framing + per-cast trait lines (Supabase-cached) |
| Voice | `tts.py` | Opener: `eleven_v3` / stability 0.60 / **1.5×** → `narration_timing.json` (18 segments) |
| Assets | `generate_cutouts.py`, `generate_group_photo.py` | Per-cohort cut-outs + group photo (manual/optional before render) |
| Props | `build_opener_remotion_props.py` | Maps 18 VO segments → Package A beat map + staged assets |
| Render | `render_opener_remotion.py` | `npx remotion render` → `trailer_9x16.mp4` |
| Gate | `validate_trailer.py` | 9:16 only, 65–95s, integrated loudness (LUFS) |

**Not used for opener anymore:** Phaser static capture, `compose_opener_trailer` (FFmpeg), 16:9 master. Day modes (`day_in_life`, `day_overview`) still use FFmpeg `compose_trailer.py` unchanged.

**Pistsov reference path (manual):** `build_anya_package_a_props.py` + locked `auto_match_v3_warm` timing — bypasses showrunner/TTS for Anya-asset QA.

## 4. Remaining gap vs Anya's cut

Phases 0–4 closed the architecture and most motion design. What still differs in quality (not blocking one-command generation):

| Gap | Status |
|---|---|
| **Continuous hook montage** (0–15s as one morph, not 3 VO-aligned beats) | Open — would need a single long `Sequence` or merged beat |
| **Transition SFX** (whoosh/typing on beat changes) | Open — SFX library referenced but not wired into Remotion audio |
| **Relationship labels from Supabase** | Partial — `export_relationship_graph.py` exists; showrunner does not emit pairs yet; Pistsov uses layout defaults |
| **Per-cohort group photo** | Generator exists (`generate_group_photo.py`); Pistsov still uses Anya's `Family.png` until Grok run |
| **Photo-real cut-outs on new casts** | Generator exists (`generate_cutouts.py --grok`); grey-flatten fallback shipped for all character sheets |
| **Full pipeline smoke test** | Open — end-to-end `generate_trailer --mode opener` not yet validated on a fresh run |

The original FFmpeg `drawtext` gap is **closed** — opener visuals are Remotion-only.

## 5. Architecture (as built)

```
persona_ranker → showrunner (+narration_cache) → tts (VO + 18-segment timing map)
              → [optional: cutouts / group photo / relationship graph]
              → build_opener_remotion_props → npx remotion render
              → validate_trailer (9:16 + LUFS)
```

### Asset buckets
- **Reusable once (built):** Remotion components in `video/remotion/src/components/` + `opener_beat_map.py` + brand assets in `opening-anya/`.
- **Per-village (the_ville = done):** village B-roll, map, night aerial (`video/fly-over/`).
- **Per-cast:** cut-out portraits, group photo, trait narration, relationship graph data.

## 6. Phased plan

- **Phase 0 — spec lock.** **DONE** — this doc + per-scene spec. Narration + photo-real cut-outs locked 2026-06-17.
- **Phase 1 — Remotion skeleton.** **DONE**
- **Phase 1b — narration lock.** **DONE** — v3 warm / 1.5× / ~76.7s
- **Phase 1c — Package A.** **DONE** — Anya assets wired; `pistsov_package_a.mp4` reference
- **Phase 2 — motion-graphic components.** **DONE**
- **Phase 2.5 — visual polish.** **DONE** — AI-core ring, relationship graph, gold transition, color grade
- **Phase 3 — per-cast automation.** **DONE** — props builder, cut-outs, group photo, relationship export
- **Phase 4 — integrate + gate.** **DONE** — `generate_trailer` → Remotion; opener validation
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
