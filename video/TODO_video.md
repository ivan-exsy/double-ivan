# North star — Anya CapCut Day 1 → auto-gen uplift

**Updated:** 2026-08-26 (compacted) · last program lock 2026-08-21 (Closer = default daily)  
**Authority:** Creative bar = Anya’s approved cut. Contracts: [`daily/SOT-new-daily.md`](daily/SOT-new-daily.md). Cut IDs / do-nots: [`../20260811_capcut-vs-post-prod.md`](../20260811_capcut-vs-post-prod.md).  
**Loop names:** Path **[A]→[E]** below is the closed polish→cold program. Agentic nights are **Loop-A / Loop-B / Loop-C** ([`../20260821_video_loop.md`](../20260821_video_loop.md)). Do not say “send it back to A” without saying which.

**Architecture:** Nightly + opener **code** is in `double-video/video/`. New extracts/packages under `double-video/data/` (gitignored). Locked 20260724-2 nights stay under eng `data/` until copied. Post-Production polishes `{package}/edit_script.json`. Rebuild cwd = `double-video`. Eng `video/` is rollback. Cold quality = recipe priors, not Save→train.

---

## Open (priority ranked)

| P | Work | How |
|---|------|-----|
| **1** | Next **closer** auto-gen | Default CLI is long. Cwd `double-video`: `python -m video.run_tonight_scar <sim> --day N --peak "…" --cost "…" --ignore-edit-script`. Writes `trailer_9x16_closer.mp4` + `vo_locked_long.txt`. Do **not** overwrite Day 2 closer lock (`…/trailer_ready_day3/output/trailer_9x16_closer.mp4`) or short `trailer_9x16.mp4` / `vo_locked.txt`. Leftover heat = Cost why-tonight + cliff; last words on leave walk. |
| **2** | Next **short** auto-gen | Same command + `--sku scar`. Prove on a **new sim Episode 1** (this sim has no Day 4 short). Do not clobber Day 1–3 locks or Day 3 cold re-prove. |
| **3** | Later **P1** pictures | Hero **namecards**; readable **tie / VOTING TARGET**. Peak/challenge/Phaser already accepted. Maker: grok.com/imagine 2.0 (6–15s, 720p, 9:16) → kit, not the 2s i2v default. Do not Imagine Phaser elim (FE capture only). |
| **4** | **P2** eng gates | After P0 (already accepted): freeze/coverage/FX validators · kit **sim-code guard** · optional `*.base.json`. Spec: brief §P2 in `20260811_capcut-vs-post-prod.md`. |
| **5** | **[E] leftover** | Inventory / copy remaining helpers anytime. **No bulk move** of leftover eng `video/`. Polish UX already lives in `double-video`. |
| **6** | Length A/B | Render short + long for N nights; lock long budgets after phone-watch. Closer-long is already the daily default. |
| **7** | GrokFilm tokens | Harvest ~10–20 lighting/camera phrases from grokfilm.app into owned prompt families (namecard / habitat / cost / i2v). Prompt text only — no Remotion hook. |
| — | Optional art | Oak Hill College **exterior** · Willows **exterior** · sharpen C5/C7 · Hobbs-branded cafe · canonical flyover filenames. Interiors + Johnson Park are done. |
| — | Not this spine | Encyclopedia Gate A–E (`20260713-1` overview VO / `lock_day_script` / moment clips / `[B] day_normal`) — parked. Do not treat as nightly work. |

---

## Path [A]→[E] — done (implementation summary)

| Step | Goal | Status |
|------|------|--------|
| **[A]** | Polish in Post-Production → phone-acceptable Live | **Accepted** |
| **[B]** | Rebuild → MP4 matches Live | **Done** |
| **[C]** | Eng learn (E0 diff → E1 priors) | **E0 + E1** |
| **[D]** | Cold auto (no polish) vs [A] bar | **Accepted** 2026-08-18 (8 taught looks) + Wave 1.5–1.16 recipe |
| **[E]** | Staged migrate eng `video/` → `double-video` | **Nightly + opener** 2026-08-22 · **Rebuild cwd** 2026-08-25 |

### [A] Polish Live
Founder cut in Post-Production (`double-video` Trim Board) on `edit_script.json`. Timing/look only; VO locked. P0 dynamism + P1 peak/challenge beds phone-OK. Live overlays polish onto nightly props (`POST /api/package/preview-props`). Do not clone `clip_kit/imported` into cold defaults.

### [B] Rebuild = Live
`python -m video.run_nightly_survival` from `double-video` applies `edit_script` onto the kit and renders `NightlySurvival`. Soft hero-hold warnings when polish exists so Live holds ship. P1 imported peak + challenge v2 baked (~00:03). Live media ladder: this-repo remotion public, then eng rollback.

### [C] Polish → learn
`video/polish_learn.py` diffs rough snapshot vs polish (`promote_candidate` / `package_only` / `do_not_touch`). Founder allowlisted **8 priors** into `nightly_craft` (scan ~6s, wipeDelay 0.1, badge holds, want_cost window, door 6.7s@0.85, music duck ~0.08, optional end_lockup hold). Never promote imports, captions, VO, ledger, Phaser one-offs. Cold bake 2026-08-12 on day2 package.

### [D] Cold vs [A]
`--ignore-edit-script` nightly. [D] accepted on the **eight taught looks only** (not full Anya clone). Then Wave 1 recipe hygiene through **1.16** (loading, intros, teach beds, G6 ballots, G7 census cards, Phaser elim capture, consecutive-night VO, leftover-on-Cost, **Closer = default daily**). Do not copy `imported/` into auto-kit. Next proof of short SKU = new sim Episode 1 (P2 above).

### [E] Code home
Gen + Remotion compositions live under `double-video/video/`. Prove: `trailer_ready_e_migrate_prove/output/trailer_9x16_closer.mp4` (~105s) · opener `double-video/video/remotion/out/opener_e_migrate_prove.mp4` (~77s). Eng `video/` kept on disk as rollback (missing staged media may still read from there). Packages: new work → `double-video/data/`; do not overwrite locked 20260724-2 masters.

---

## Do not overwrite

| Night | Path | Master |
|-------|------|--------|
| Day 1 polish bar | eng `data/20260724-2/trailer_ready_day2` | `trailer_9x16_20260812_003937_e1_cold.mp4` (filename tag is wrong — this is **polish**) |
| Day 2 short | `…/trailer_ready_day3` | `trailer_9x16.mp4` wave22 |
| Day 2 closer | same | `trailer_9x16_closer.mp4` + `vo_locked_long_accepted.txt` |
| Day 3 wave29 | `…/accepted_day3_wave29/trailer_ready_day4` | `trailer_9x16.mp4` |
| Day 3 cold re-prove | `…/trailer_ready_day4` | `trailer_9x16.mp4` (priors = day2+day3 only) |
| [E] prove (not a lock) | `…/trailer_ready_e_migrate_prove` | `trailer_9x16_closer.mp4` |
| Opener gold | `opening-anya-pistsov` | `output/trailer_9x16.mp4` |

Snapshot before any overwrite. This sim: **no Day 4 short**.

---

## Bake (cwd = `double-video`)

```bash
python -m video.run_tonight_scar <sim> --day N --peak "…" --cost "…" --ignore-edit-script
# short: add --sku scar
```

Seeds G6 `ballots.mp4` + G7 census; habitat = namecard + mp4 (no still freeze); no C1 under the vote. Missing `fact_ledger.json` extracts from Supabase into `double-video/data/<sim>/trailer_ready_dayN`. Phaser elim captures from local FE unless `--no-capture-phaser-elim`. After closer TTS, keep `narration_closer.mp3` — do not leave the short bed under the long cut.

---

## Foundation already shipped (do not re-open)

- **N1–N6:** Tonight’s Scar chain · challenge teach packs in git · auto picture G1–G5+G8+G3 i2v · Soul15 seat_map C/B/A (Ivan 3.3) · interiors+Phaser crops · one-command `run_tonight_scar`.
- **Gold replay:** CapCut CSV → `DailyGoldReplay` · C1–C8 wired · Remotion = product, CapCut = forensics only.
- **Village interiors + Johnson Park:** inventory 0 interior TODO.
- **P1 peak/challenge/Phaser:** Alexis rank **11** still+clip · challenge table card-backs · FE `*_leave_phaser.png`.

---

## Pointers

| Doc | Use |
|-----|-----|
| [`daily/SOT-new-daily.md`](daily/SOT-new-daily.md) | D1 contract, bins, G jobs |
| [`daily/gold/20260713-1_day1_anya/GOLD.md`](daily/gold/20260713-1_day1_anya/GOLD.md) | Anya gold hub |
| [`../20260820_longer_daily.md`](../20260820_longer_daily.md) | Closer SKU rec |
| [`../20260821_video_loop.md`](../20260821_video_loop.md) | Loop-A/B/C |
| `video/sot-video.md` | Trailer taxonomy |
| `double-video/prd.md` §22.2 | Polish→learn contract |
