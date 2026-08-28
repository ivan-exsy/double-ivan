# North star — Anya CapCut Day 1 → auto-gen uplift

```````````````````````````
**Assess D:\Coding\double-ivan\video\20260827_viral_video.md** (Post-MVP)
- amount of work to bring the locked closer >> that paper’s ~60s / 2D-legend grammar
- Dedicated branch when you pick it up — not the village gate
```````````````````````````

**Updated:** 2026-08-27 · auto-gen benchmark locked · that closer **is** the short ship · remaining video = **Post-MVP**  
**Authority:** Creative bar = Anya’s approved cut. Contracts: [`daily/SOT-new-daily.md`](daily/SOT-new-daily.md). Cut IDs / do-nots: [`../20260811_capcut-vs-post-prod.md`](../20260811_capcut-vs-post-prod.md).  
**Loop names:** Path **[A]→[E]** below is the closed polish→cold program. Agentic nights are **Loop-A / Loop-B / Loop-C** ([`../20260821_video_loop.md`](../20260821_video_loop.md)). Do not say “send it back to A” without saying which.

**Architecture:** Nightly + opener **code** is in `double-video/video/`. New extracts/packages under `double-video/data/` (gitignored). Locked 20260724-2 nights stay under eng `data/` until copied. Post-Production polishes `{package}/edit_script.json`. Rebuild cwd = `double-video`. Eng `video/` is rollback. Cold quality = recipe priors, not Save→train.

---

## Locked — auto-gen benchmark (2026-08-27)

Founder accepted this **cold** closer as the nightly auto-gen quality bar (not a Post-Production polish cut). Anya CapCut Day 1 stays the creative north star. `20260724-2` Day 1 stays the polish bar.

| | |
|--|--|
| Package | `double-video/data/20260823-2/trailer_ready_day2` |
| Master | `output/trailer_9x16_closer.mp4` · immutable copy `output/trailer_9x16_closer_autogen_benchmark.mp4` |
| VO | `vo_locked_long.txt` · copy `vo_locked_long_accepted.txt` |
| Night | Engine day 2 · Peak **Ivan Pitts** · Cost **Alex Butcher** · Hold for the Shield |
| Bake | `--ignore-edit-script` · Phaser elim from local FE · G3 table regen |

Do **not** `--force` / `--replace-vo-lock` this package without snapshotting first.

This locked closer **is the short**. A later Post-MVP pass can make a **longer, more informative** cut. Do not reopen a 45–60s `--sku scar` Episode 1 as open work.

---

## Post-MVP (video)

Village MVP gate is gather + town talk (`20260901_launch.md`). Nothing below is that gate. The Episode 1 closer above is enough to post tape.

| P | Work | How |
|---|------|-----|
| **1** | Later-night **closer** (Episode 2+) | Census stills / leftover heat / `{N} still in`. **Spine is Episode 1:** alliances→votes + ballot + stamp-on-photo then HUD — already auto-gen. Same CLI, new package (`--day 3+`). Do not overwrite the Episode 1 benchmark. Needs a **finished** Survival-day vote (Peak + Cost), not challenge-only. |
| **2** | Viral-grammar pass (`20260827_viral_video.md`) | Locked closer is ~90s cinematic-heavy; paper wants ~60s + tighter 2D legend. Dedicated branch; fold plant / cost-dive / door timestamps into recipe — do not throw away the locked bar. |
| **3** | Extra **P1** pictures | Namecards + readable tie / VOTING TARGET. Peak/challenge/Phaser already accepted on the benchmark. grok.com/imagine 2.0 (6–15s, 720p, 9:16) → kit. Do not Imagine Phaser elim. |
| **4** | Eng **P2** gates | Freeze/coverage/FX validators · kit sim-code guard · optional `*.base.json`. Spec: `20260811_capcut-vs-post-prod.md` §P2. |
| **5** | **[E] leftover** helpers | Copy remaining helpers anytime. No bulk move of eng `video/`. Polish UX already in `double-video`. |
| **6** | Longer informative cut + GrokFilm tokens | Second pass on length: more story, not a short Scar. Harvest lighting phrases into prompt families only. |
| — | Optional art | Oak Hill / Willows exteriors · C5/C7 · Hobbs-branded cafe · flyover filenames. Interiors + Johnson Park are done. |
| — | Not this spine | Encyclopedia Gate A–E · `[B] day_normal` · moment clips. |

---

## Path [A]→[E] — done (implementation summary)

| Step | Goal | Status |
|------|------|--------|
| **[A]** | Polish in Post-Production → phone-acceptable Live | **Accepted** |
| **[B]** | Rebuild → MP4 matches Live | **Done** |
| **[C]** | Eng learn (E0 diff → E1 priors) | **E0 + E1** |
| **[D]** | Cold auto (no polish) vs [A] bar | **Accepted** 2026-08-18 (8 taught looks) + Wave 1.5–1.16 · **new-sim Episode 1 closer = auto-gen benchmark 2026-08-27** |
| **[E]** | Staged migrate eng `video/` → `double-video` | **Nightly + opener** 2026-08-22 · **Rebuild cwd** 2026-08-25 |

### [A] Polish Live
Founder cut in Post-Production (`double-video` Trim Board) on `edit_script.json`. Timing/look only; VO locked. P0 dynamism + P1 peak/challenge beds phone-OK. Live overlays polish onto nightly props (`POST /api/package/preview-props`). Do not clone `clip_kit/imported` into cold defaults.

### [B] Rebuild = Live
`python -m video.run_nightly_survival` from `double-video` applies `edit_script` onto the kit and renders `NightlySurvival`. Soft hero-hold warnings when polish exists so Live holds ship. P1 imported peak + challenge v2 baked (~00:03). Live media ladder: this-repo remotion public, then eng rollback.

### [C] Polish → learn
`video/polish_learn.py` diffs rough snapshot vs polish (`promote_candidate` / `package_only` / `do_not_touch`). Founder allowlisted **8 priors** into `nightly_craft` (scan ~6s, wipeDelay 0.1, badge holds, want_cost window, door 6.7s@0.85, music duck ~0.08, optional end_lockup hold). Never promote imports, captions, VO, ledger, Phaser one-offs. Cold bake 2026-08-12 on day2 package.

### [D] Cold vs [A]
`--ignore-edit-script` nightly. [D] accepted on the **eight taught looks only** (not full Anya clone). Then Wave 1 recipe hygiene through **1.16**. **Cold bar now:** `20260823-2` Episode 1 closer (2026-08-27) — that cut **is** the short ship. Do not copy `imported/` into auto-kit.

### [E] Code home
Gen + Remotion compositions live under `double-video/video/`. Prove: `trailer_ready_e_migrate_prove/output/trailer_9x16_closer.mp4` (~105s) · opener `double-video/video/remotion/out/opener_e_migrate_prove.mp4` (~77s). Eng `video/` kept on disk as rollback (missing staged media may still read from there). Packages: new work → `double-video/data/`; do not overwrite locked 20260724-2 masters **or** the `20260823-2` Episode 1 closer benchmark.

---

## Do not overwrite

| Night | Path | Master |
|-------|------|--------|
| **Auto-gen benchmark (Episode 1 closer)** | `double-video/data/20260823-2/trailer_ready_day2` | `trailer_9x16_closer.mp4` + `trailer_9x16_closer_autogen_benchmark.mp4` + `vo_locked_long_accepted.txt` |
| Day 1 polish bar | eng `data/20260724-2/trailer_ready_day2` | `trailer_9x16_20260812_003937_e1_cold.mp4` (filename tag is wrong — this is **polish**) |
| Day 2 short | `…/trailer_ready_day3` | `trailer_9x16.mp4` wave22 |
| Day 2 closer | same | `trailer_9x16_closer.mp4` + `vo_locked_long_accepted.txt` |
| Day 3 wave29 | `…/accepted_day3_wave29/trailer_ready_day4` | `trailer_9x16.mp4` |
| Day 3 cold re-prove | `…/trailer_ready_day4` | `trailer_9x16.mp4` (priors = day2+day3 only) |
| [E] prove (not a lock) | `…/trailer_ready_e_migrate_prove` | `trailer_9x16_closer.mp4` |
| Opener gold | `opening-anya-pistsov` | `output/trailer_9x16.mp4` |

Snapshot before any overwrite. `20260724-2` has no Day 4 short. Do not treat `20260823-2` Episode 1 as overwrite-safe.

---

## Bake (cwd = `double-video`)

```bash
python -m video.run_tonight_scar <sim> --day N --peak "…" --cost "…" --ignore-edit-script
```

Seeds G6 `ballots.mp4` + G7 census; habitat = namecard + mp4 (no still freeze); no C1 under the vote. Missing `fact_ledger.json` extracts from Supabase into `double-video/data/<sim>/trailer_ready_dayN`. Phaser elim captures from local FE unless `--no-capture-phaser-elim`. After closer TTS, keep `narration_closer.mp3` — do not leave the short bed under the long cut. Do not point this command at the 20260823-2 Episode 1 benchmark package unless you meant to snapshot-and-replace.

---

## Foundation already shipped (do not re-open)

- **N1–N6:** Tonight’s Scar chain · challenge teach packs in git · auto picture G1–G5+G8+G3 i2v · Soul15 seat_map C/B/A (Ivan 3.3) · interiors+Phaser crops · one-command `run_tonight_scar`.
- **Gold replay:** CapCut CSV → `DailyGoldReplay` · C1–C8 wired · Remotion = product, CapCut = forensics only.
- **Village interiors + Johnson Park:** inventory 0 interior TODO.
- **P1 peak/challenge/Phaser + Episode 1 closer auto-gen:** Alexis rank **11** still+clip · challenge table card-backs · FE `*_leave_phaser.png`. `20260823-2` closer locked 2026-08-27.

---

## Pointers

| Doc | Use |
|-----|-----|
| [`daily/SOT-new-daily.md`](daily/SOT-new-daily.md) | D1 contract, bins, G jobs |
| [`daily/gold/20260713-1_day1_anya/GOLD.md`](daily/gold/20260713-1_day1_anya/GOLD.md) | Anya gold hub |
| [`../20260820_longer_daily.md`](../20260820_longer_daily.md) | Closer SKU rec |
| [`../20260821_video_loop.md`](../20260821_video_loop.md) | Loop-A/B/C |
| `video/sot-video.md` | Trailer taxonomy |
| [`../20260901_launch.md`](../20260901_launch.md) | Village MVP gate vs parallel video track |
| `double-video/prd.md` §22.2 | Polish→learn contract |
