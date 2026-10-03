# North star — Anya CapCut Day 1 → auto-gen uplift

**Updated:** 2026-10-02 · primary video SOT = [`SOT-video.md`](SOT-video.md) (§9 closer lock). Old `sot-video.md` → `done/`. 2D→3D morph = post-MVP [`TODO_2D-3D.md`](TODO_2D-3D.md).  
**Authority:** Creative bar = Anya’s approved cut. Daily contract = SOT §9. Path **[A]→[E]** below is **closed**. Watch-loop names: **Loop-A / Loop-B / Loop-C** (parked below). Do not say “send it back to A” without saying which.

**Architecture:** Nightly + opener **code** is in `double-video/video/`. New extracts/packages under `double-video/data/` (gitignored). Locked 20260724-2 nights stay under eng `data/` until copied. Post-Production polishes `{package}/edit_script.json`. Rebuild cwd = `double-video`. Eng `video/` is rollback. Cold quality = recipe priors, not Save→train.

**Current daily:** Closer tonight (`--sku closer`). New sim with no `vo_locked_long.txt` auto-locks from `draft_closer_tonight_vo`. Bake fails closed on `check_closer_vo_facts`. Short Scar is `--sku scar`. Episode 1 Ivan/Alex is a **specimen**, not the lock.

**LeaderTalks season:** Premiere opener = **Anya’s locked L-Talks cut** (do not auto-gen a Downtown opener). Then 15 evening closers on the **Pittsburgh Downtown** maze (`20260917_pre-MVP.md` Season Spec). Workplace and home interiors are on disk. The room lookup, the PPG Cafe gather plate, and the Downtown flyover are on `mvp-ready` locally (not pushed). A Downtown ledger uses `video/assets/pittsburgh/flyover/`. Village nights stay on `video/fly-over/`.

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

That package is the **version-1 specimen** (auto-gen quality bar). The **live repeating format** is SOT §9. New sims (e.g. `20260825-1`) fill that format. Do not reopen a 45–60s `--sku scar` Episode 1 as the daily.

---

## Done (do not reopen as closer work)

| Item | Status |
|------|--------|
| Path **[A]→[E]** polish → Rebuild → learn → cold → migrate | Closed (summary below) |
| Closer tonight = default daily; short = `--sku scar` | Live |
| Format lock [A] (Doubles, Day-1 vs later, living last line, ≥2 hooks, Peak choice/win) | Live in SOT §9.0; ship gate `check_closer_vo_facts` |
| Later-night closer (Episode 2+) same CLI, drop alliances sermon | Live in writer + validator |
| Bonding overlay (SOT §9.5) | Live 2026-08-29 — `closer_tonight_v11`. Kid-plain on weather, doing, one choice, inner vote, last words, living last line. Status then why/who/when if the ledger has it. Weather: `{A} and {B} have each other's backs.` plus context. Bake fails “are locked” / trust scores. |
| P2 closer gates | Live 2026-08-29 — `validate_closer_p2`: black hole **fail** (interval overlap; recipe `_abut_picture_gaps`); wrong kit **fail**; starve-freeze **warn** (skip if duration unknown). Prove: same day3 bake `post_props_gates` passed after weather abut. Spec below. |
| Longer informative cut as a *new SKU* | **Not open** — closer *is* that cut. Length follows the night. |

Village MVP gate is gather + town talk (`done/20260910_launch.md`). Nothing below is that gate. Post-MVP index: `double-docs/TODO_post_mvp.md`.

### P2 — closer bake gates (shipped 2026-08-29)

For **cold closer** (`--sku closer`). Length follows the night. Do not use the Aug 11 Scar polish P2 as the live spec ([`../done/20260811_capcut-vs-post-prod.md`](../done/20260811_capcut-vs-post-prod.md) stays archive). Do not re-check VO facts, literacy plant/bridge/door, imported-media ban, or runtime band — those already ship.

Habitat, looped leave, census, flyover, weather, and lockup are **meant** to hold. Do not fail a closer because those sit longer than 3.5s.

| # | Gate | When | Not |
|---|------|------|-----|
| **1** | **Black hole** | Fail if any body-clock second has no picture at opacity ≥0.5. | Captions / HUD type do not count as picture. |
| **2** | **Wrong kit** | Fail if faces, challenge pack, or Phaser stills are from another sim. | Post-Production “pack status” chrome. |
| **3** | **Starve freeze** | **Warn** when a *motion* cut is much longer than its file and has no loop / speed / Ken Burns. | Hard-fail on slowed gather, Ken Burns stills, looped G5 leave, census, flyover, lockup. |

**Drop for closer** (old Scar P2): honour `fx[].enabled` + stop recipe FX on polish; `*.base.json` so force-materialize does not eat polish; “do not exempt beds.” Those are polish-path. Cold closer ignores `edit_script`.

Hero-hold cadence already exists and already exempts closer-long roles; polish demotes it to warn. Do not bring back a 3.5s max on G1/G2/G5.

---

## Open (video)

Story rehaul: [`20261002_daily-story.md`](20261002_daily-story.md). Do not open a second show. Do not edit `SOT-video.md` until a script from that note is accepted. Village gather/talk is elsewhere. **LeaderTalks daily is blocked on that story note**, then one cold Downtown closer. Interior plates, the room lookup, the PPG Cafe gather plate, and the Downtown flyover are on `mvp-ready` locally. A cold bake has not been run.

| P | Work | Notes |
|---|------|-------|
| **Craft** | Extra P1 pictures | Namecards + readable tie / VOTING TARGET. Peak/challenge/Phaser already accepted on the Episode 1 benchmark. grok.com/imagine 2.0 (6–15s, 720p, 9:16) → kit. Do not Imagine Phaser elim. |
| **L-Talks (blocking)** | Daily story rehaul | [`20261002_daily-story.md`](20261002_daily-story.md). Headcount is this sim’s start roster, not fifteen. The `20261001-2` draft is a form, not the night. Script only until that note is accepted. |
| **L-Talks (blocking)** | Cold Downtown closer | After the story note. Pending shots: [`TODO_pittsburgh-assets.md`](TODO_pittsburgh-assets.md). Interiors done 2026-09-30. Room lookup, PPG Cafe gather, and the Downtown C-pack / flyover are on `mvp-ready` locally (not pushed). Still open: remaining façades, then one cold Downtown closer. |
| **L-Talks (drop)** | **PM-LTALK-8** YouTube chapters + Telegram blurb | Hook closer bake in **`double-video`**. Encyclopedia generator already works; closer does not call it. See below. |
| **Optional** | [E] leftover helpers | Copy remaining helpers anytime. No bulk move of eng `video/`. Polish UX already in `double-video`. |
| **Optional art (village only)** | Exteriors / C5/C7 / Hobbs cafe / flyover names | Village interiors + Johnson Park are done. **Does not** unblock Downtown daily. |
| **Post-MVP** | 2D→3D morph (outsource) | Phaser scene from a sim moment → cinematic. Producer brief: [`TODO_2D-3D.md`](TODO_2D-3D.md). Do not fold into tonight’s closer. |
| — | Not this spine | Encyclopedia Gate A–E · `[B] day_normal` · moment clips · recut Ivan/Alex · auto-gen L-Talks opener (Anya’s cut is the premiere). |

---

## LeaderTalks — Pittsburgh Downtown (blocking daily)

**Want:** the existing closer bake (`python -m video.run_tonight_scar`, cwd `double-video`) on a Downtown sim, with Imagine refs that look like Pittsburgh, not Hobbs.

**Do not:** reuse village interiors as PPG / Fifth Avenue / EQT / O’Reilly / Penn. Do not auto-gen the season opener. Encyclopedia `[C]` stays killed. Night 15 overview stays closer-shaped.

Occupancy shops (doors locked in `20260917_pre-MVP.md`): **PPG Cafe** (gather) · **Fifth Avenue Market** · **EQT Supply Store** · **O’Reilly Pub** · **Penn College**. Homes: **20** apartments (`double-docs/R3F/20260918_home-wave-20.md`).

**Photo roster:** pending shots only in [`TODO_pittsburgh-assets.md`](TODO_pittsburgh-assets.md). Finished interiors are in `double-video/video/assets/pittsburgh/interior/`. Finished exteriors are in `double-video/video/assets/pittsburgh/exterior/ref/`. Photograph **real façades**. Interiors are **ground-floor sim rooms**, not real tower floor plans. The closer interior set (five shops, three apartment looks, Point) is on disk.

Village plates live in `double-video/video/assets/village/{interior,exterior}/`. Phaser moodboard still in `generative_agents/video/assets/phaser/_moodboard/`. Village C1–C8 + `signature_flyover.mp4` stay the_ville (`double-video/video/fly-over/`). Downtown C1–C8 + `signature_flyover.mp4` are on disk at `double-video/video/assets/pittsburgh/flyover/`. A Downtown ledger selects that folder. SOT §2.1 still names `generative_agents/video/assets/…` — treat `double-video` as the live copy.

### Place plates (Imagine refs + photo)

Same commission order as SOT §2.1 for interiors: unlabeled Phaser crop → room inventory → Imagine (layout + style frame + continuity) → register. New files go under e.g. `double-video/video/assets/pittsburgh/`, **not** into `village/`.

Do **not** use Tower at PNC Plaza (300 Fifth) for PNC Center or One PNC Plaza. Do **not** put **East Park** on VO (sim label only). Landmark pads get skyline stills, **no interiors** this wave.

#### A — Daily closer (blocking — do first)

| # | Asset | Why |
|---|--------|-----|
| **1** | **Workplace interiors** — on disk 2026-09-29 | PPG Cafe, Fifth Avenue Market, EQT Supply, O’Reilly Pub, Penn College (library + gym). Gather uses the PPG Cafe plate on a Downtown night. |
| **2** | **Home interiors** — on disk 2026-09-30 | Three shared looks, 19 own plates, bedrooms for One Gateway and Two PPG. First & Market uses `apt_small_int.jpg`. |
| **3** | **Shop + Point exteriors** — on disk | Five shop façades with door plates, Point wide + lawn door, ten home streets. Fountain is still open in the shoot list. |
| **4** | **Phaser `_moodboard` crops** of those five shops + the 2–3 homes (unlabeled top-down) | Imagine layout gate. Do not auto-crop from a low-res birdseye. Do not feed `*_labeled.png`. |
| **5** | **Cinematic pack Downtown** — on disk 2026-10-02 | C1–C8 + `signature_flyover.mp4` in `video/assets/pittsburgh/flyover/`. A Downtown ledger uses them for weather, cliff, and the plant/door. Village nights keep `video/fly-over/`. |

Tick when the still is on disk under `video/assets/pittsburgh/`:

- [x] PPG Cafe interior — one plate covers dining, bar, and kitchen (2026-09-29)
- [x] Fifth Avenue Market interior (2026-09-29)
- [x] EQT Supply interior (2026-09-29)
- [x] O’Reilly Pub interior (2026-09-29)
- [x] Penn College interior — **library** + **gym / rest area**, no classroom (2026-09-29)
- [x] Those five shop façades (+ door plates)
- [x] Three home looks: small studio, mid one-room, large two-bedroom, plus 19 own plates and two large bedrooms — 2026-09-30. Files in `double-video/video/assets/pittsburgh/interior/`.
- [x] Point State Park wide + lawn door (fountain still open)
- [x] Home street faces for the closer (ten on disk; Encore is mass-only). The other ten streets are in the shoot list.
- [ ] Phaser crops for the rooms above (`video/assets/phaser/_moodboard/pittsburgh/` is empty)
- [x] Downtown C-pack / `signature_flyover` — 2026-10-02, `video/assets/pittsburgh/flyover/`

#### B — Full maze (remaining)

Filenames and shoot notes: [`TODO_pittsburgh-assets.md`](TODO_pittsburgh-assets.md). On disk already, and removed from that list: ten home streets (Gateway Tower, Roosevelt, Midtown, River Vue, Tower Two-Sixty, 11 Stanwix, Six PPG, USW, PNC Center, One PNC) plus Market Square, Mellon Square, Gateway Center Park, Arts Landing, and Firstside Park.

- [ ] **10 home street faces** still missing (Encore street, First & Market, Three PNC, Four Gateway, K&L Gates, Three Gateway, Two Gateway, Two PNC, Two PPG, One Gateway)
- [ ] **Outdoors still open:** fountain, Fort Pitt Museum grounds, Mon Wharf, Roberto Clemente / Andy Warhol / Rachel Carson bridges, East Park lawn
- [ ] **On the map, not enterable** (skyline / flyover, no interiors): Wyndham Grand, Heinz Hall, Benedum, PPG wintergarden, Three / Four / Five PPG, St. Mary of Mercy, Star Loft, Wood Street Studios, Academic Hall, YWCA 305 Wood, CityHigh if the façade is certain
- [ ] Unnamed OSM boxes, garages, rivers = backdrop only — do not commission as locations

### Code

**Lookup and gather — on `mvp-ready` locally, 2026-10-01, not pushed.** Downtown place names resolve before the village words. PPG Cafe, Fifth Avenue Market, EQT Supply, and O’Reilly Pub use their Pittsburgh jpg. Penn College uses the library plate, or the gym plate when the job or room says gym, coach, fitness, or trainer. Homes use `{slug}_int.jpg` when that file is on disk, otherwise `apt_small_int.jpg` / `apt_mid_int.jpg` / `apt_large_int.jpg`. First & Market uses the small look. A known Downtown place with no file fails closed. Bedroom plates (`one_gateway_bedroom_int.jpg`, `two_ppg_place_bedroom_int.jpg`) are used only when the caller passes `sleep=True`. The closer recipe does not pass that flag yet, so a sleep beat still gets the living plate. A Downtown gather says PPG Cafe, attaches `ppg_cafe_int.jpg`, and bans Hobbs furniture and metal shields. The clip file stays `hobbs_gather` so the edit can find it. Village nights still gather at Hobbs.

- Recipe world plates: a Downtown ledger (`is_pittsburgh_context` on role place, home, or job) resolves C1–C8 from `video/assets/pittsburgh/flyover/`. Missing Downtown file fails closed. Village nights still stage `cinematic_ville_*` from `video/fly-over/`. `_WORLD_PLATE_NEEDLES` still names the village talk plates.
- Phaser plant/door: the kit file stays `signature_flyover.mp4`. A Downtown ledger copies the Pittsburgh clip. A village night copies `video/fly-over/signature_flyover.mp4`. Do not swap plant/door for a C-plate (SOT §11.5).
- Prove: one cold closer on a Downtown sim (`--ignore-edit-script`) from this `mvp-ready`. Fail if any cut still uses Hobbs / Willows / Oak Hill / Rose and Crown plates. The gather clip may still be named `hobbs_gather`; judge the picture, not that filename.

Census G7 15-seat assets are fine for soul_15. Look photos in Supabase still do **not** feed `_find_cohort_portrait` — named portraits remain a kit requirement (identity, not maze).

### PM-LTALK-8 — YouTube chapters + Telegram blurb

Ticket: `double-ivan/20260917_pre-MVP.md`. BE Cloud Agent brief is the right **acceptance**, wrong **repo as primary**. Nightly closer code lives in `double-video/video/` (`run_tonight_scar`). Eng `generative_agents/video/` is rollback. `generate_description.py` exists in both; tests exist **only** in eng.

**Verified 2026-09-18 (re-checked this evening — encyclopedia works; closer has nothing to test yet):**

| Check | Result |
|-------|--------|
| Encyclopedia units | `python tests/test_generate_description.py` from `generative_agents` — **24 passed**. **No** `test_generate_description.py` in `double-video`. |
| Same module in both repos | `video/generate_description.py` is **byte-identical** (`double-video` copy vs eng rollback). |
| Encyclopedia Step 6 | `double-video/video/generate_trailer.py` still calls it (best-effort; MP4 ships if description fails). Same in eng. |
| Historical paste-ready files | **41** `youtube_description.txt` under `generative_agents/data/` (openers + encyclopedia). **0** under `double-video/data/`. Best example: `generative_agents/data/20260526-3/overview_day1&003/output/youtube_description.txt` — `0:00 — Gosha: …` + `/sim/20260526-3/play?t=238&double=Gosha%20Pistsov`. Also `20250516-2`, `20260506-5`, `20260513-1` openers. |
| Closer bake | **`run_tonight_scar` does not call it.** |
| Closer `script.json` | Beats `hook` / `stake` / `pressure` / `peak` / `cliff_door` only. **No** `key_steps` / `step_range` / `time_range_sec` (encyclopedia Showrunner fields). |
| Dry-run (in memory, no write) | Episode 1 closer `20260823-2/trailer_ready_day2`: skips every scene; body is title + empty “Key moments” + current CTA `Watch live at doubland.ai…` + `https://doubland.ai/?source=yt`. Do **not** write a probe onto that locked package. |
| Watch URLs | Stale `/sim/{code}/play` (module docstring still says Play mode was unshipped). Current Watch is `https://www.doubland.ai/{sim}` (`?double=` already works on the iframe). Keep `source=` (`tg-survival-premiere`, `tg-survival-d{N}`) per `sot_api.md` §10. May files often **omit** `source=` — generator added it later. |
| Telegram blurb | **Does not exist** (no second file / section today) |

**Do (when you say go):** hook closer packages in **`double-video`** — bake or a documented one-liner after bake writes `output/youtube_description.txt` with `M:SS` chapter lines derived from closer beats / `edit_script` windows / ledger. No new Showrunner/LLM picker. Telegram blurb = YouTube + Current Watch + `source=`. MP4 stays load-bearing if description fails. Keep encyclopedia Step 6 working. Units: copy/extend `tests/test_generate_description.py` into `double-video`. BE brief `ivan/ltalk-closer-youtube-chapters` is the right **acceptance**, wrong **primary repo** — if that branch lands only on `generative_agents`, nightly closer drops stay empty.

**How to test the old generator today (encyclopedia only — this is the past work):**

```bash
cd generative_agents
python tests/test_generate_description.py
python -m video.generate_description data/20260526-3/overview_day1&003 20260526-3 --source-campaign yt-d1
```

Compare **chapter lines** (`M:SS — Name: label` and `t=` / `double=`) to the existing `output/youtube_description.txt`. Do not expect a full-file match: May footers say waitlist; today’s generator says the Watch-live CTA and appends `source=`.

To see closer fail closed (optional; write somewhere that is **not** the locked package):

```bash
cd double-video
python -c "import json,sys; from video.generate_description import _render_description; s=json.load(open('data/20260823-2/trailer_ready_day2/script.json',encoding='utf-8')); print(_render_description(s,'20260823-2','https://doubland.ai','yt'))"
```

---

## Parked concepts (briefs → `done/`)

Do not brief the next bake from these files. SOT §9 is the closer. Open work above is the next closer pass.

**Watch a bake — Loop-A / B / C** (was `20260821_video_loop.md`)

- **Loop-A (project):** Post-Production, Live on. Kit + VO + ledger + picture-under-this-line. Fail → eng. Do not “fix” by polishing `edit_script` as the win.
- **Loop-B (taste):** Phone MP4, 1×, start through Door. Write 7 quiz answers before opening the ledger. Fail only on quiz miss or HF1–HF10. Unlisted complaint = `untaught`, not a fail.
- **Loop-C (done):** A and B both pass → snapshot → stop.
- Written for short Scar. Same shape for closer; ignore the old runtime band. Do not confuse with Path **[A]→[E]** (closed polish program below).

**2D→3D morph — post-MVP, outsource** — live brief [`TODO_2D-3D.md`](TODO_2D-3D.md) (started from `daily-2D-3D-blend.md`)

- Vision: actual Phaser scene from a simulation moment morphs into cinematic (location / pose / color). Not stock `signature_flyover.mp4`.
- Today’s closer only plants a generic map, a Cost FE still (often the wrong beat, name tags on), and the same map at Door. Wipe/fade only. `2d-3d` recipe discarded 2026-08-29.
- Spark / timestamps (was `20260827_viral_video.md`) stay archived. Not a closer ship gate.

**2D ship gates on the locked daily** (SOT §3.6)

- Phaser plant + Peak/Cost Phaser bridge + Door tease. Fail all-cinematic. Caps ≤3 cinematic punctuations on arc beats.
- Tighter dive / morph timing is the producer TODO, not tonight’s closer.

**Closer vs short SKU** (was `20260820_longer_daily.md`)

- Shipped: closer is the default daily; `--sku scar` is the short sibling. Never clobber `vo_locked.txt` / `trailer_9x16.mp4` when baking closer.
- Story overlay (doing / weather / vote-why / last words) = SOT §9.5. Spoken English; no recap slogans; no mind-read; chats only after they match the board.
- Do not reopen a third show or a 90–140 fill-to clock.

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
- **Village interiors + Johnson Park:** inventory 0 interior TODO. **Does not cover Downtown.** Downtown interiors are done; remaining Pittsburgh exteriors are in [`TODO_pittsburgh-assets.md`](TODO_pittsburgh-assets.md).
- **P1 peak/challenge/Phaser + Episode 1 closer auto-gen:** Alexis rank **11** still+clip · challenge table card-backs · FE `*_leave_phaser.png`. `20260823-2` closer locked 2026-08-27.

---

## Pointers

| Doc | Use |
|-----|-----|
| [`SOT-video.md`](SOT-video.md) | **Primary video SOT** (closer + shared craft + opener pointer) |
| [`../20260917_pre-MVP.md`](../20260917_pre-MVP.md) | LeaderTalks Season Spec + **PM-LTALK-8** + Downtown occupancy shops |
| [`TODO_2D-3D.md`](TODO_2D-3D.md) | **Post-MVP** 2D→3D morph — producer brief (do not bake from this) |
| [`daily/gold/20260713-1_day1_anya/GOLD.md`](daily/gold/20260713-1_day1_anya/GOLD.md) | Anya gold hub |
| [`../opening/TODOs-opening-trailer.md`](../opening/TODOs-opening-trailer.md) | Opener [A] WIP |
| [`../done/20260910_launch.md`](../done/20260910_launch.md) | Closed village MVP score trail vs parallel video track |
| [`../done/sot-video.md`](../done/sot-video.md) | Archived July taxonomy / opener scene map |
| [`../done/20260828_format_lock_closer.md`](../done/20260828_format_lock_closer.md) | Archived format-lock brief |
| [`../done/20260827_viral_video.md`](../done/20260827_viral_video.md) | Archived later 2D-legend / Spark paper |
| [`../done/20260821_video_loop.md`](../done/20260821_video_loop.md) | Archived Loop-A/B/C detail |
| [`../done/20260820_longer_daily.md`](../done/20260820_longer_daily.md) | Archived closer-SKU rec |
| [`../done/20260811_capcut-vs-post-prod.md`](../done/20260811_capcut-vs-post-prod.md) | Archived Path [A] P0 field notes |
| `double-video/prd.md` §22.2 | Polish→learn contract |
