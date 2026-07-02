# Narration — pending locked script

After final script is approved, generate VO and copy here:

- `narration.mp3`
- `narration_timing.json`

Command (from `generative_agents` repo):

```powershell
python -m video.generate_trailer 20260628-4 opener `
  --mode opener --top 15 `
  --cohort-name "L-Talks" --season-title "Press Play" `
  --skip-render --force `
  -o "d:\Coding\double-ivan\video\l-talk\audio\_gen"
```

Voice: ElevenLabs `eleven_v3` warm @ 1.5×.
