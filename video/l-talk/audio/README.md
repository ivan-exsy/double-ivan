# Narration — locked script

Script: `../script/script.md` + `../script/script.json` (one-shot, no `[PAUSE]` markers).
Voice: ElevenLabs `eleven_v3` warm @ 1.5×.

## Files in this folder

| File | Description |
|------|-------------|
| `narration_oneshot.mp3` | **Current** — single v3 take; ElevenLabs handles pacing |
| `narration_timing_oneshot.json` | Timing map (1 segment — block-level only) |
| `narration_manual-pauses.mp3` | Previous take with manual `[PAUSE]` segmentation (~79s, 30 beat sync points) |
| `narration_timing.json` | Timing map for the manual-pauses take |

## Re-render one-shot

From `generative_agents-daily-trailer` repo root:

```powershell
python -c "
import json, os, sys
sys.path.insert(0, '.')
from dotenv import load_dotenv
load_dotenv('.env.local')
from video.tts import OPENER_VOICE_PROFILE, render_narration
p = r'd:\Coding\double-ivan\video\l-talk\script\script.json'
d = r'd:\Coding\double-ivan\video\l-talk\audio'
with open(p, encoding='utf-8') as f: ns = json.load(f)['narrator_script']
render_narration(ns, os.path.join(d,'narration_oneshot.mp3'), timing_path=os.path.join(d,'narration_timing_oneshot.json'), voice_profile=OPENER_VOICE_PROFILE)
"
```

Do **not** use `python -m video.generate_trailer ...` — it regenerates script from sim data.
