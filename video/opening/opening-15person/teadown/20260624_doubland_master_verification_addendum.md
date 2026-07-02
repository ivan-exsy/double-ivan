# Doubland Anya Trailer Teardown — Master Verification Addendum

**Date:** 2026-06-24  
**Applies to:** the original `20260624_doubland_anya_reference_teardown` package  
**Verified against:** `DOUBLAND1.mov` (2160×3840 native master)

## Purpose

Correction memo — **not** a replacement specification. Continue using scene spec, timecode index, text log, SFX log, and cross-cutting summary as the implementation baseline.

The master confirms **65-sub-moment structure, section boundaries, transition grammar, text-settle behavior, cast rhythm, clip prominence, and end-card sequence**. No scene added, removed, reordered, or redesigned. Apply only the corrections listed in this addendum and in the patched package files.

## Implementation changes that matter

1. **Native 9:16** — Do not reproduce proxy black side margins. 1080×1920 is exact 50% scale of 2160×3840.
2. **Opening head** — Poster flash ~50 ms (three decoded master frames); black reset; `WHAT IF…` readable ~0.133 s. At 30 fps: poster frames 0–1, black frames 2–3, WHAT IF by frame 4.
3. **Endpoint** — Master ends at **76.578 s** (not 76.600). Final URL hold ~0.58 s; no post-settle pulse.
4. **Copy policy** — product uses **PISTSOV** and **AI VERSION OF YOU** (reference master has PISTSOFF / “AN AI…”); locked in impl plan **§8.13**.

## Package file edits (2026-06-24)

| File | Change |
|---|---|
| `20260624_doubland_anya_reference_scene_spec.md` | Header, §0/§1/§18 boundaries, sub-moments 0.1 / 1.1 / 18.5, clarifications |
| `20260624_doubland_timecode_index.csv` | Rows 0.1, 1.1, 18.5 only |
| `20260624_doubland_text_log.csv` | Row 1 hard removal → 0.050 |
| `20260624_doubland_sfx_log.csv` | No change |
| `20260624_doubland_cross_cutting_summary.md` | Runtime, native source, poster wording, verification statement |
| `README.md` | Proxy-then-master verification note |
| `reference_grabs/` | Optional — re-export from master for pixel QA |

## Engineering acceptance

- [ ] Native 9:16 layout (no proxy margins)
- [ ] Poster = momentary flash + black reset before WHAT IF
- [ ] Duration metadata 76.578 s
- [ ] Final URL ends at source endpoint without extra motion
- [x] Product copy locked: **PISTSOV**, poster band **AI VERSION OF YOU** (see impl plan §8.13)
- [ ] Only three timecode-index rows changed; SFX not globally shifted

**Bottom line:** No Phase 6 rebuild. Head/tail + metadata corrections only.
