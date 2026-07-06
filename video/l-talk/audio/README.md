# Narration — locked (L-Talks opener)

**Locked with Anya (2026-07-06):** `experiments/script_cos_oneshot_speed12/`

| Item | Path |
|------|------|
| Script | `../script/script_cos.md` (v2) |
| VO | `experiments/script_cos_oneshot_speed12/narration_cos.mp3` (~83.4s) |
| Timing | `experiments/script_cos_oneshot_speed12/narration_timing.json` (1 segment) |
| TTS input | `experiments/script_cos_oneshot_speed12/script_used.txt` |
| Voice | ElevenLabs `eleven_v3` warm @ **1.2×** one-shot |

**Why not 1.5×:** VO experiment listen — `script_cos` @ 1.2× one-shot beat `script.md` @ 1.5× on flow and runtime. See `experiments/README.md`.

## Re-render locked take

From `generative_agents` repo root:

```powershell
python -m video.render_ltalk_cos_oneshot
```

Do **not** use `python -m video.generate_trailer ...` — it regenerates script from sim data.

## Archive (do not hand to Anya)

| File | Description |
|------|-------------|
| `narration_oneshot.mp3` | v1 script @ 1.5× one-shot |
| `narration_timing_oneshot.json` | Timing for v1 one-shot |
| `narration_manual-pauses.mp3` | Segmented take with `[PAUSE]` markers |
| `narration_timing.json` | Timing for manual-pauses take |
| `experiments/v1_…` through `v6_…` | VO experiment matrix (superseded by `script_cos_oneshot_speed12`) |
