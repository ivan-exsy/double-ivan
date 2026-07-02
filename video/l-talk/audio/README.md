# Narration — locked script

Script is locked: `../script/script.md` + `../script/script.json`.
Voice: ElevenLabs `eleven_v3` warm @ 1.5× (opener `warm` profile, see HANDOFF.md).

After this run, this folder holds:

- `narration.mp3`
- `narration_timing.json`

## Render command

Run from the `generative_agents-daily-trailer` repo root (so `.env.local` with
`ELEVENLABS_API_KEY` is picked up):

```powershell
python -m video.render_ltalk_vo
```

`render_ltalk_vo.py` reads the locked `narrator_script` from
`double-ivan/video/l-talk/script/script.json` and renders with the opener `warm`
profile (`eleven_v3`, speed 1.5×). It writes both files into this folder.

Do **not** use `python -m video.generate_trailer ...` for this trailer — that
pipeline regenerates its own script from a sim's `day_log` and would not match
the manually locked narration. The L-Talks opener is a manual CapCut edit; only
the VO step is automated.
