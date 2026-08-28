# AGENTS.md — double-ivan

Doc / concept / video-WIP repo for Doubland. **Process rules** that are global live under `~/.cursor/rules/` and `D:\Coding\COS\config\project_context.md`. This file is repo memory only.

## Patterns & Conventions

- **Main-track only:** commit and push on `main`. Do **not** create `ivan/*` (or any) feature branches unless the founder explicitly asks.
- This is **not** an eng app repo. Do not copy `generative_agents` / `double-front` branch naming here.
- Product concept entry: `concept/mission.md`. Video taxonomy WIP: `video/sot-video.md`. Daily trailer SOT: `video/daily/SOT-new-daily.md`.
- Live landing ship notes (when present): dated `2026*_ux_landing_*.md` at repo root may beat aspirational docs in `double-docs/landing/`.

## Gotchas

- Eng-style feature branches left this repo’s “real” history off `main` for weeks (e.g. former `ivan/digest-challenge-card-checklist`). Prefer staying on `main` so docs stay findable.
- Sibling eng SOT lives in `double-docs/sot/` — do not duplicate runtime contracts here.

## Style / Preferences

- Plain markdown; keep filenames dated (`YYYYMMDD_…`) for working notes; move finished notes under `done/` when retiring them.
- Communicate outcomes first; file paths only when needed for handoff.

## Recent Learnings / Changes

- 2026-08-27: **Featured intro + want HUD are auto-gen personality** — job+place, then tonight's who-clause (else innate `roles.trait`). Never Expose/Protect/rank as intro. HUD stamps that line. Rebake 20260825-1 with `--replace-vo-lock`; do not treat 20260823-2 as the only cast that works.
- 2026-08-27: **Episode 1 closer auto-gen benchmark locked** — that cut **is the short**. Package `double-video/data/20260823-2/trailer_ready_day2` — `trailer_9x16_closer_autogen_benchmark.mp4` + `vo_locked_long_accepted.txt`. Cold (`--ignore-edit-script`). Do not overwrite without a snapshot. Remaining video is **Post-MVP** (`video/TODO_video.md`). Village MVP gate is gather + talk (`20260901_launch.md`).
- 2026-08-23: True-Double research KB (MatrAIx + MiroFish + Park/BehaviorChain/IMPersona + §8 human/IC). §0 is live village/Talk for the chat RCA. Eng charter stays `TODO_realism_matriAIx.md` — do not treat the KB as an implement brief.
- 2026-07-21: Confirmed main-track posture after FF-merging stray feature-branch history back to `main` and deleting `ivan/digest-challenge-card-checklist`.
- 2026-07-27: Re-confirmed main-track only; added `.cursor/rules/main-track.mdc`. Sibling `double-docs` cleaned the same day (feature branches deleted; eng `git-workflow` scoped so it cannot leak `ivan/*` into doc repos).
