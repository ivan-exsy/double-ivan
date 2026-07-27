# Gold — Survival Day 1 CapCut (Anya)

**Status:** Creative north star for auto-gen uplift · **CapCut draft ingested 2026-07-24**  
**Sim:** `20260713-1` · engine day 2 · Survival Day 1  
**VO:** V6 locked (`clip_kit/vo_locked.txt`) — do not rewrite  
**Runtime decision (founder 2026-07-23):** gold **~88.2s** accepted; auto-gen target 45–60s, soft warn **>90s**, hard max **120s**

## Start here

| Priority | Doc |
|----------|-----|
| 1 | **This file** — hub + paths |
| 2 | [`capcut_project_breakdown.md`](capcut_project_breakdown.md) — **how the edit was built** (tracks, type, FX, media graph) |
| 3 | [`capcut/`](capcut/) — machine CSVs/JSON extracted from the draft |
| 4 | [`gold_beat_map.md`](gold_beat_map.md) · [`craft_notes.md`](craft_notes.md) · [`anya_bar_rubric.md`](anya_bar_rubric.md) |


## Remotion gold replay (eng Phase 1)

Rebuild the CapCut timeline in code (not a substitute for the master MP4):

```
cd generative_agents-ivan-dev
python -m video.build_gold_replay_props
cd video/remotion
npx remotion still DailyGoldReplay out/gold_replay_smoke.png --props=props/gold_replay_day1.json --frame=90
npx remotion render DailyGoldReplay out/gold_replay_day1.mp4 --props=props/gold_replay_day1.json
```

- Props builder: `video/build_gold_replay_props.py` (reads `capcut/*.csv`)
- Composition: `DailyGoldReplay`
- CapCut stock SFX use local stand-ins under `video/audio/sfx/` until licensed packs land
- **World-plate swaps (2026-07-25):** mismatched Doubland geography → C1–C8 pack under `video/fly-over/`  
  - Alpine alumni still `B604…PNG` (~30.4–32.9s) → **C1** `c1.2.mp4`  
  - Open-roof `Village.mp4` (~58.7–60.0s) → **C1**  
  - Phaser `signature_flyover` **kept** (plant / door literacy)  
  - Pack map + legacy flyover fallbacks live in `WORLD_PLATE_REPLACEMENTS` in the props builder  
  - Brief: `generative_agents/video/fly-over/COMMISSION_cinematic_pack.md`
- Compare against master `bins/video/0720(1).mp4`

## Canonical media (do not duplicate large binaries here)

| Role | Path |
|------|------|
| **Master export** | `generative_agents/…/clip_kit/bins/video/0720(1).mp4` |
| Specs | 9:16 · 2160×3840 HEVC export · project canvas **1080×1920** @ 30fps · **88.233s** · ~360 MB |
| Proxy | `…/bins/video/0720.mp4` (~73s, small) |
| Staged kit we gave | `…/trailer_ready_day2/clip_kit/` |
| Pre-Anya baseline | `…/trailer_ready_day2/clip_kit_v0/` (**immutable**) |
| Legend extras | `…/clip_kit/bins/F_Anya-legend/` (**32/47 used** in CapCut) |
| **CapCut project** | `…/clip_kit/bins/capcut_proj/` · draft **L-talks Day 1** · `draft_info.json` |

## Package facts

| Field | Value |
|-------|--------|
| Peak | Irene Dove (Shield) |
| Cost | Ivan Pitts (boot, 6 votes) |
| Challenge | Hold for the Shield |
| Door | doubland.ai / L-Talks watch live |
| VO audio | `audio/v6_narration.mp3` ~87.6s (film = 88.233s) |
| CapCut structure | 21 tracks · 133 segments · **43 kinetic text** · 10 video tracks |
| scar.json | Present on package (`locked_at` 2026-07-17) |

## Forensics in this folder

| File | What |
|------|------|
| [`capcut_project_breakdown.md`](capcut_project_breakdown.md) | **Primary rebuild guide** from CapCut draft |
| [`capcut/`](capcut/) | Timeline CSVs, summary JSON, legend usage |
| [`teardown/reference_grabs/`](teardown/reference_grabs/) | 88× 1fps review stills (540px wide) |
| [`teardown/sample_key/`](teardown/sample_key/) | Key timestamps for quick scrub |
| [`teardown/timecode_index.csv`](teardown/timecode_index.csv) | Film grab index |
| [`gold_beat_map.md`](gold_beat_map.md) | Sheet ↔ film ↔ kit ↔ CapCut |
| [`craft_notes.md`](craft_notes.md) | Craft + **open taste questions** |
| [`anya_bar_rubric.md`](anya_bar_rubric.md) | Auto-gen quality bar draft |
| [`legend_catalog/`](legend_catalog/) | Legend inventory (see also `capcut/legend_usage.csv`) |
| [`CANONICAL_PATHS.md`](CANONICAL_PATHS.md) | Path pointers only |

## What gold is / is not

- **Is:** multi-track CapCut craft — kinetic VO type, legend cinematic library, staged fact anchors, Phaser literacy, SFX/scan palette, 88s VO-locked cut.
- **Is not:** one-file-per-bin Ken Burns; a hard 60s bar; permission to invent VO; mandatory copy of CapCut cloud effect IDs.

## Immutable rules

1. Never overwrite master MP4, `clip_kit_v0/`, CapCut draft, or locked VO.  
2. Regen kits → new `clip_kit_vN/` or overwrite only non-gold staged bins after backup.  
3. Taste calls (which gold flourishes are mandatory vs optional for auto-gen) stay with founder — see open questions in `craft_notes.md`.
