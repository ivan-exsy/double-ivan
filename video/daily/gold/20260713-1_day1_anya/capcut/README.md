# CapCut machine extracts

Generated from `clip_kit/bins/capcut_proj/draft_info.json` (2026-07-24).

| File | Contents |
|------|----------|
| `capcut_summary.json` | Draft meta, counts, beat buckets, full text list, legend used/unused |
| `capcut_segments.csv` | All 133 timeline segments |
| `capcut_media_timeline.csv` | Video/photo segments (resolved filenames when MD5 matched) |
| `capcut_text_timeline.csv` | 43 kinetic text segments |
| `capcut_audio_timeline.csv` | VO / music / SFX |
| `capcut_materials.csv` | Material library |
| `capcut_media_map.csv` | Unique media → first use |
| `legend_usage.csv` | Each `F_Anya-legend` file × used flag |

Human narrative: [`../capcut_project_breakdown.md`](../capcut_project_breakdown.md).

To regenerate after draft changes, re-run the extract script against the repo package (ask eng for `picture_kit` / gold extract helper — last run used a one-off parser hashing bins + legend against `Resources/local`).
