# L-Talks narration experiment — 5 variants

**Goal:** Pick the best balance of **smooth flow**, **emotional accents**, and **runtime** before updating the auto Remotion pipeline.

**How to listen:** Play each `*/narration.mp3` in order. Use headphones. Score in the table below.

| # | Folder | What it tests | Segments | Length |
|---|--------|---------------|----------|--------|
| v1 | `v1_oneshot_speed15/` | Current one-shot baseline @ 1.5× | 1 | **87.6s** |
| v2 | `v2_oneshot_speed12/` | One-shot @ API max speed 1.2× | 1 | **87.5s** |
| v3 | `v3_oneshot_block_pauses/` | One-shot @ 1.2× + `[short pause]` between 6 blocks only | 1 | **91.0s** |
| v4 | `v4_six_block_oneshots/` | Six separate one-shots @ 1.2×, hard-concatenated | 6 | **86.6s** |
| v5 | `v5_manual_segmented/` | Sentence-level `[PAUSE]` @ 1.5× (today's Remotion-friendly path) | 30 | **80.2s** |
| v6 | `v6_phrase_overlap/` | **v1 one-shot** cut to phrases + **0.18s crossfade overlap** (Anya-style) | 30 | **82.4s** |

After listening, fill `manifest.json` scores or the table below.

## Scorecard (1–5 each)

| Variant | Smooth joins | Emotional beats | Runtime OK | Edit/Remotion sync | **Winner?** | Notes |
|---------|-------------|-----------------|------------|-------------------|-------------|-------|
| v1 | | | | | | |
| v2 | | | | | | |
| v3 | | | | | | |
| v4 | | | | | | |
| v5 | | | | | | |
| v6 | | | | | | |

**Listen checkpoints:** Hook "What if…" · Concept `[warmly]` · Reveal `[excited] And pressed play` · Survival `[accentuate] Survival Mode` · Close `what would MY Double do?`

## Re-run

From `generative_agents-daily-trailer` root:

```powershell
python -m video.render_ltalk_vo_experiment
python -m video.render_ltalk_vo_experiment --only v3_oneshot_block_pauses
```

Results summary: `manifest.json` in this folder.
