# Vertical Trailer Automation — Teardown + Plan

=============================
Phase 0–4 DONE · Phase 5 OPEN · Run §7 · Gaps §8 · North-star: 20260622 Playbook
On creative/quality/asset conflicts → Playbook wins; this doc = built state + commands
=============================


> Goal: auto-generate vertical (9:16) opening trailers for any new cast/simulation that match the style and polish of Anya's hand-edited cut (`video/opening-anya/DOUBLAND1.mov`). Scope locked **2026-06-17: vertical only** for now. Companion to `20260501_opening-trailer.md` (asset punch list), `video_PRD.md`, and **`20260622_Automated_Trailer_Production_Playbook (1).md`** (quality + asset north star).

**Duration policy:** Total trailer length is **not a hard product requirement**. A few seconds vs Anya's hand cut is fine (e.g. **~76.7s** narration vs **~83.6s** final MP4 on opener&005). **Larger casts are expected to produce longer trailers** — tiered layouts keep the cast *block* efficient (~15–20s), but total runtime may grow with cohort size within validator bounds (today **65–95s**).

## TODO — next steps

**Status:** Phases 0–4 **done** (one-command path works). **Phase 5 polish + new-sim scale** still open.  
**North-star spec:** `20260622_Automated_Trailer_Production_Playbook (1).md` — creative grammar, asset map (§16), dev tickets (§13), acceptance tests (§14, §16.13). Use this doc for run commands and built-state; use the Playbook for *what good looks like*.  
**Governance:** If anything below disagrees with the Playbook on targets (LUFS, asset render policy, cast tiers, beat roles, validation gates), **follow the Playbook** and treat this doc as describing **current code** until Phase 5/P1 land. **Exception — duration:** Playbook section timings and bands are **pacing guidance**; see Duration policy above — exact total seconds is not pass/fail.

### P0 — next trailer run (`opener&006`; Playbook §12 P0 + §16.12 P0)

Target: four-person Pistsov pass that feels materially smoother — no full pipeline rewrite.

- [ ] **Poster / concept frame** — split layout (matrix group + black band + clean photo); export poster still (§8.5 · Playbook Ticket 4)
- [ ] **Text settle** — `type-then-hold`; remove persistent `GlitchText` ghost on headlines (§8.2, §8.6 · Playbook Ticket 2)
- [ ] **`Talk.mp4` hero** — hard-conversation line at ≥0.75 opacity, not under graph (§8.7 · Playbook §16.12 #2)
- [ ] **Trailer VO** — trial `eleven_v3` trailer profile @ 1.5× vs warm; side-by-side with Anya audio before re-lock (§8.3)
- [ ] **Hook morph** — merge VO segments 0–2 into one continuous 0–14s sequence (§4 · Playbook Tickets 1 + 3)
- [ ] **Visual timeline decoupling** — micro-beats independent of 18-segment VO map (Playbook Ticket 1)
- [ ] **End card** — tighten to ~3.5–5s resolved hold (creative polish, not a runtime gate) (Playbook §12 P0 #5)
- [ ] **Audio punctuation** — wire transition SFX; normalize mix toward ~-14 LUFS (§4 · Playbook Ticket 6)
- [ ] **Wire `Family.mp4`** — concept/cast reveal **once** (~0:14–0:20); stop holding static `Family.png` across beats (§8.8 · Playbook §16.12 #3)
- [ ] **Asset manifest** — register Anya kit with render policies; block reference boards from direct render (Playbook §16.12 #1, #10)

**Review gate:** side-by-side `opener&006` vs `DOUBLAND1.mov` — §8.9 checklist + Playbook §16.13 acceptance test.

### P1 — new simulations & casts (Playbook §12 P1 + §16.12 P1)

Target: any sim with 1–15 Doubles renders without manual Remotion edits or wrong-cohort assets.

- [ ] **Cast scale** — `--top` 1–15; tiered layouts for 1–4 / 5–8 / 9–15; cast block ≤ ~20s (total trailer may run longer — expected) (§8.4 · Playbook Ticket 5)
- [ ] **Relationship graph** — Supabase-driven labels; generalize layout for 2–15 nodes (§4 · Playbook §12 P1 #4)
- [ ] **Per-cohort assets** — auto-generate + verify cutouts and group photo; no silent Pistsov fallback (§8.4, §8.8 · Playbook §17 workflow)
- [ ] **Component library** — `DoubleIdentityCard`, `WorldMapHUD`, `SurvivalDashboard`, `RelationshipGraph`, etc. from PNG templates (Playbook §16.5, §16.12 P1)
- [ ] **Editorial validator** — low-motion ratio, static-run length, visual-change rate, repetition flags (Playbook Ticket 7)
- [ ] **Scale smoke test** — fork sim with 8–15 personas; full asset gen + render (§8.4)

### P2 — defer until P0/P1 pass (Playbook §12 P2 + §16.12 P2)

Golden test set (4 / 8 / 15 cast), composition variants, 60fps delivery, thumbnail scoring, homepage hero loop, 16:9 master.

---

## 1. Anya's cut — the facts

- **Format:** 2160×3840 (9:16 vertical), 120fps, **76.6s**, HEVC. Mobile-first.
- **Narration:** ElevenLabs **`eleven_v3`** warm take at **1.5×** (evolved from the `v3_warm_x1.2` experiment), with inline delivery cues `[curious]` / `[warmly]` / `[excited]`. Script = showrunner opener fixed blocks (v2.4 "Anya cut" **minus** the dropped *"sometimes… you never noticed before"* line). Pauses minimal (~2.75s total silence). **Narration audio ~76.7s** — close to Anya's 76.6s VO. **Final MP4** may run longer (opener&005 = **83.6s**) — acceptable; see Duration policy. Reference: `video/voiceover/auto_match_v3_warm_x1.5/narration.mp3`. Legacy producer script still at `video/anya/narration_anya.json`.
- **Her toolkit:** ~24 transparent PNG overlay graphics + 4 short image-to-video B-roll loops (`opening-anya/Anya_animated/{Family,Pressure,Talk,Village}.mp4`, 3–5s each, mixed aspect) + existing anthem + SFX library. **Editor: CapCut** (project file available on request — usable as a *blueprint*, not a render engine; CapCut can't run headless). Reference cut + assets live in `video/opening-anya/`.

## 2. Teardown — beat / shot map

Hard-cut timestamps (ffmpeg scene detection): 0, 23.5, 24.0, 27.2, 31.8, 35.0, 43.2, 45.7, 48.3, 49.1, 63.0, 66.4, 71.7, 73.8. Long gaps between cuts = continuous morphing motion-graphic sequences (she favors smooth transitions over hard cuts). Section boundaries below are **Anya reference approximations** (76.6s hand cut); auto output may run longer — see Duration policy. Macro rhythm guidance: Playbook §4.1, §16.6.

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

Phases 0–4 closed the architecture and most motion design. What still differs in quality (not blocking one-command generation):

| Gap | Status |
|---|---|
| **Visual timeline decoupling** | Open — 18 VO segments drive visuals 1:1; need micro-beats + cross-segment sequences (Playbook §3.1, Ticket 1) |
| **Continuous hook montage** (0–14s as one morph, not 3 VO-aligned beats) | Open — single long `Sequence` or merged beat (Playbook §6.1, Ticket 3) |
| **End card length** | Open — end-card **hold** can run long vs Anya's tight resolve; tighten to ~3.5–5s for polish (Playbook §4.1) — **not** because total runtime is wrong |
| **Mix loudness / SFX** | Open — today ~-16.6 LUFS, no transition SFX; target ~**-14 LUFS** + punctuation (Playbook §9, Ticket 6) |
| **Transition SFX** (whoosh/typing on beat changes) | Open — SFX library referenced but not wired into Remotion audio |
| **Relationship labels from Supabase** | Partial — `export_relationship_graph.py` exists; showrunner does not emit pairs yet; Pistsov uses layout defaults |
| **Per-cohort group photo** | Generator exists (`generate_group_photo.py`); Pistsov still uses Anya's `Family.png` until Grok run |
| **Photo-real cut-outs on new casts** | Generator exists (`generate_cutouts.py --grok`); grey-flatten fallback shipped for all character sheets |
| **Full pipeline smoke test** | **Partial (2026-06-22)** — Steps 1–3 pass on `opener&005`; Step 5 failed until `npm install` in `video/remotion`; re-render → `trailer_9x16.mp4` (83.6s). See §8. |
| **Poster / thumbnail frame** | Open — first frame does not match Anya's concept split (§8.5) |
| **Fixed-text hold (no pulse/glitch)** | Open — `GlitchText` RGB ghost + wordmark glow on static lines (§8.2, §8.6) |
| **Trailer VO profile** | Open — still on warm / 1.5×; switch to trailer for next run (§8.3) |
| **Multi-cast (up to 15 doubles)** | Open — pipeline caps at `--top 6`; graph + cast layout hard-coded for 4 (§8.4) |
| **Talk.mp4 on hard-conversation beat** | Partial — staged on **hook** seg index 1 (~0:03–0:08) at low opacity under graph, not hero (§8.7 · Playbook §6.1, §16.6) |

The original FFmpeg `drawtext` gap is **closed** — opener visuals are Remotion-only.

## 5. Architecture (as built)

**Today (Phase 4):**

```
persona_ranker → showrunner (+narration_cache) → tts (VO + 18-segment timing map)
              → [optional: cutouts / group photo / relationship graph]
              → build_opener_remotion_props → npx remotion render
              → validate_trailer (9:16 + LUFS)
```

**Target (Playbook §5):** evolve to a spec-driven compiler — cast/conflict selector → visual beat planner → asset resolver → **TrailerSpec JSON** → Remotion → SFX/mix pass → technical + **editorial** validator → MP4 + poster + QA report. Phase 5/P1 close the gap; do not extend the VO-segment = one-scene pattern.

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
- **Phase 5 — polish pass (post–opener&005 review).** **OPEN** — poster frame, static text hold, trailer VO, Talk beat prominence, 15-cast scale, SFX (§8)
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

### 8.9 Next run checklist (`opener&006`)

```bash
# One-time if fresh clone
cd video/remotion && npm install

# Optional: per-cohort assets (required for non-Pistsov sims)
python video/assets/scripts-prompts/generate_cutouts.py --grok --skip-existing
python video/assets/scripts-prompts/generate_group_photo.py --cohort <slug>

# After §8.3 code change (trailer voice profile)
python -m video.generate_trailer <sim> opener --mode opener --top 4 --cohort-name "<Cohort label>"
```

**Review with Anya:** side-by-side `opener&006/output/trailer_9x16.mp4` vs `opening-anya/DOUBLAND1.mov` — focus on §8.5 poster frame, §8.6 headline legibility, §8.7 Talk beat, §8.3 voice tone.
