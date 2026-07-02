# Anya Opener Trailer — Per-Scene Production Spec (reverse-engineered)

> Frame-accurate teardown superseded by **`trailer-opening/teadown/`** (2026-06-24 producer pass). Kept for history. Active docs: [`20260617_vertical-trailer-automation.md`](../../trailer-opening/20260617_vertical-trailer-automation.md) (implementation) · [`20260501_opening-trailer.md`](../../trailer-opening/20260501_opening-trailer.md) (bible).

## Format & global facts

- **Canvas:** 1080×1920 (9:16), ~76.6s. Anya trimmed the ~100s VO down to ~77s by tightening pauses.
- **Voiceover:** **LOCKED (Ivan, 2026-06-17): `v3_warm` at 1.5×** — ElevenLabs **`eleven_v3`**, stability **0.60**, speed **1.5×**, with inline delivery cues `[curious]` / `[warmly]` / `[excited]`. Baked into `tts.py` `OPENER_VOICE_PROFILE`. Auto-gen lands **~76.7s** (`video/voiceover/auto_match_v3_warm_x1.5/narration.mp3`). Script = showrunner v2.4 "Anya cut" minus the dropped *"sometimes… you never noticed before"* line. Legacy reference script: `video/anya/narration_anya.json`.
- **Cast lines are SHORT.** Anya's per-cast VO is one punchy clause ("Gosha thinks three moves ahead. Ivan refuses to lose."). ✅ Enforced via `OPENER_PERSONA_NARRATION_SYSTEM`.
- **Cast portraits:** **photo-real full-body cut-outs on grey** (locked 2026-06-17). Generator: `generate_cutouts.py` (`--grok` for photo-real; grey flatten fallback).

## Global style spec (the reusable "look")

- **Palette:** near-black navy bg (#05070d), cyan/electric-blue UI accent, warm amber/orange "AI core" glow, gold (#c8a86b) brand accent, white type.
- **Typography:** condensed/clean sans, ALL-CAPS, wide letter-spacing for titles; a **glitch/digital type-on** for "WHAT IF"; a **monospace terminal readout** for the matrix scan lines.
- **Motion principles:** slow push-ins on stills; every title fades/rises on; **smooth crossfades / dissolves between beats** (almost no hard cuts in the concept section); UI elements draw on (lines animate, nodes pop, gauges sweep).
- **Audio:** anthem bed (`music_anthem.mp3`) ducked under VO; SFX library (`video/audio/sfx/`) for whooshes/typing/impacts — **not yet wired** into Remotion; music fade-out at the tail.

## Per-scene table

Legend — Asset status: ✅ have · 🔷 per-cohort (auto-generate) · 🛠 Remotion component · ⬜ not built / open. "Anya file" = delivered source in `video/opening-anya/`. Effect status reflects **auto-gen as of 2026-06-17** (Phases 2–4 done).

| # | T (s) | VO line | On-screen text | Visual / asset (Anya file) | Effect / transition | Status |
|---|---|---|---|---|---|---|
| 1 | 0.0–0.8 | *(silence → swell)* | — | Black + faint particles | Music swell, slow fade-up | 🛠 partial (`ParticleField`) |
| 2 | 0.8–2.0 | "What if…" | **WHAT IF…** | Black | Glitch type-on | 🛠 `GlitchText` |
| 3 | 2.0–3.0 | "you had a second chance" | **YOU HAD A SECOND CHANCE** + readout | Orange AI-core ring (`Asset2.png`) | Matrix readout + ring | 🛠 `AiCoreRing` + `MatrixReadout` |
| 4 | 3.0–4.0 | "to make it right?" | **TO MAKE IT RIGHT?** + readout cont. | AI core ring + wireframe figures | Dissolve + ink figures | 🛠 `InkFigures` |
| 5 | 4.0–4.5 | *(beat)* | **WHAT IF?** | Black | Glitch type-on | 🛠 `GlitchText` |
| 6 | 4.5–8.5 | "you could practice…" | **YOU COULD PRACTICE** → … | Relationship diagram + `Talk.mp4` | Animated graph + crossfade | 🛠 `RelationshipGraph` + 🔷 |
| 7 | 8.5–9.0 | "What — if you had a Double?" | **WHAT IF?** | Black | Glitch | 🛠 `GlitchText` |
| 8 | 9.0–13.0 | "An AI version of you—" | **DOUBLE** + **AN AI VERSION OF YOU** | `Family.png` + `DOUBLAND.png` | Wordmark + push-in | 🛠 + 🔷✅ |
| 9 | 13.0–18.0 | "talking like you…" | **TALKING / REACTING / MAKING CHOICES LIKE YOU** | Cut-out portraits | Word-swap titles | 🛠 `WordSwapTitles` |
| 10 | 18.0–26.0 | "In Doubland… watch it live…" | *(minimal)* | `Village.mp4`, `Map.png`, flyover | Push-ins, dissolves | ✅ 🛠 `PushIn` |
| 11 | 26.0–31.0 | "Every conversation…" | **EVERY CONVERSATION / CHOICE / RELATIONSHIP** | `Connections2.png`, `Talk.mp4` | Title swaps + graph | 🛠 |
| 12 | 31.0–36.0 | *(line dropped in auto-gen)* | — | — | — | N/A (script trim) |
| 13 | 36.0–41.0 | "This season: Pistsov…" | **PISTSOV FAMILY / FOUR DOUBLES** + badge | `Family.png`, `Survival.png` | Gold transition + badge stamp | 🛠 `GoldTransition` + 🔷✅ |
| 14 | 41.0–50.0 | Cast trait lines | Name + trait per double | Cut-outs + `Cards*.png` | Slide-in per cast | 🔷✅ |
| 15 | 50.0–56.0 | "See how people change…" | gauge labels | `Pressure.mp4` + gauges | Needle sweep | 🛠 `PressureGauges` |
| 16 | 56.0–63.0 | "Watch live 24/7…" | *(minimal / LIVE)* | Night aerial + HUD | HUD overlay | 🛠 `LiveHudOverlay` + ✅ |
| 17 | 63.0–72.0 | "These aren't just avatars…" | title swaps | Map + badge | Word swaps | 🛠 `WordSwapTitles` |
| 18 | 72.0–74.5 | "And after a while… you ask—" | *(minimal)* | Dark aerial | Fade | partial |
| 19 | 74.5–76.6 | "what would MY Double do?" | question + **doubland.ai** | `DOUBLAND2.png` | End card + hold | 🔷✅ |

## Asset inventory — have vs. produce (feeds steps 2–3)

**✅ Have (the_ville / Pistsov):** village exteriors + flyovers + aerials (`video/assets/village/`, `video/fly-over/`), illustrated map, anthem + SFX, brand wordmark/end-card, SURVIVAL badge, and **Anya's delivered Pistsov graphics** (`Anya_PNG_assets/`: Family group photo, Connections diagram, cut-out portraits, ornamental frames) + `Anya_animated/` B-roll. These are the **reference** for the per-cohort generators.

**🔷 Per-cohort — generators shipped (Phase 3); run per new cast:**
- Group photo — `generate_group_photo.py` (Grok Imagine)
- Relationship diagram — `export_relationship_graph.py` (+ `RelationshipGraph` component)
- Cut-out portraits — `generate_cutouts.py` (grey flatten or `--grok`)
- Trait one-liners — showrunner (already per-cohort)

**🛠 Build-once Remotion components — DONE (Phases 2 + 2.5):** see `video/remotion/src/components/`. Wired via `opener_beat_map.py` → `AnyaBeats.tsx`. Render path: `generate_trailer --mode opener` → `render_opener_remotion.py`.

**⬜ Still open vs Anya's polish:**
- Continuous 0–15s hook (one morph vs 3 VO beats)
- Transition SFX on beat changes
- Supabase-driven relationship edge labels (showrunner emit)

**Locked decisions (2026-06-17):**
1. **Cast portraits:** photo-real cut-outs on grey (not sketches).
2. **Voiceover:** `v3_warm` at **1.5×** — reference `auto_match_v3_warm_x1.5/narration.mp3`.

## Pipeline — current state (2026-06-17)

Phases 1–4 **DONE**. Production entry point:

```bash
python -m video.generate_trailer base_family_sim opener --mode opener --top 4 --cohort-name "Pistsov family"
```

- **showrunner.py:** narration lock DONE. Optional future: emit relationship pairs for dynamic diagram.
- **build_opener_remotion_props.py:** 18-beat Package A map from opener dir.
- **Per-cohort generators:** `generate_cutouts.py`, `generate_group_photo.py`, `export_relationship_graph.py`.
- **tts.py:** `OPENER_VOICE_PROFILE` — eleven_v3 / 0.60 / **1.5×**.
