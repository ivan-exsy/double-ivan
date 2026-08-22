# North star — Anya CapCut Day 1 → auto-gen uplift

**Updated:** 2026-08-21 (Closer tonight **default daily** · Day 2 long lock · leftover fold) · prior 2026-08-21 (Day 3 **cold re-prove accepted** · Loop-A/B/C + longer daily pointers · wave29 lock · G6 seed + habitat clip-only) · prior 2026-08-20 (Day 3 VO+picture lock · wave25 phone-watch) · 2026-08-20 (consecutive-night VO auto-gen · Day 2 wave22 **accepted** · G7 identity-card auto-gen) · 2026-08-19 (Day 2 wave21 census/grey/flyover) · 2026-08-19 (Wave 1.10 census HUD) · 2026-08-19 (Wave 1.9 Phaser elim accepted) · 2026-08-19 (Phaser capture bake) · 2026-08-19 (Wave 1.8b accepted) · 2026-08-19 (card-backs bake) · 2026-08-18 (Wave 1.8 table recast) · 2026-08-18 (Wave 1.7) · 2026-08-18 (Wave 1.6+2) · 2026-08-12 (E1 cold bake) · 2026-08-11 · 2026-08-03 (GrokFilm deferred) · 2026-07-30 (N6 · N3 · challenge packs · seat_map v4)  
**Authority:** Creative bar = Anya’s approved cut. Contracts: [`daily/SOT-new-daily.md`](daily/SOT-new-daily.md).  
**Detail brief (P0 field list + evidence):** [`../20260811_capcut-vs-post-prod.md`](../20260811_capcut-vs-post-prod.md) — not a second checklist; execute from **here**, open brief for cut IDs / freezedetect / do-nots.

**Architecture (one line):** Nightly gen **code** lives in **`double-video/video/`**. Packages stay in **eng** `data/`. Post-Production polishes `edit_script.json` on that package. Rebuild UI still cwd=`ENG_ROOT` until cutover. Cold quality uplift = eng learn **[C]**, not Save→train.

---

## ▶ Now (2026-08-21) — read this first

**Active package (Survival Day 1, closed — do not overwrite):** `generative_agents-ivan-dev` · `data/20260724-2/trailer_ready_day2`  
**Active package (Survival Day 2, accepted):** `data/20260724-2/trailer_ready_day3`  
**Active package (Survival Day 3, wave29 lock):** `data/20260724-2/accepted_day3_wave29/trailer_ready_day4`  
**Active package (Survival Day 3, cold re-prove — accepted 2026-08-21):** `data/20260724-2/trailer_ready_day4`  
**Tools:** Post-Production (`double-video`) for Live · nightly bake cwd=`double-video` · Rebuild UI still eng (`ENG_ROOT`) until cutover  
**Path [E] prove (2026-08-22, not a locked night):** `data/20260724-2/trailer_ready_e_migrate_prove/output/trailer_9x16_closer.mp4` (~105s). Do not overwrite the locked packages below.

**Quality bar (do not overwrite Day 1):** polish snapshot  
`…/trailer_ready_day2/output/trailer_9x16_20260812_003937_e1_cold.mp4`  
(the `e1_cold` tag on that filename is wrong — it is the **polish** bake).

**Day 2 cold master (locked 2026-08-20, founder “Perfect!”):** `…/trailer_ready_day3/output/trailer_9x16.mp4` — wave22 (~97s). Previous master archived as `*_20260820_161636_wave22.mp4`. Do not overwrite this file without a snapshot.

**Day 3 wave29 lock:** `…/accepted_day3_wave29/trailer_ready_day4/output/trailer_9x16.mp4` — archive `*_20260821_111828_wave29.mp4`. Do not overwrite this folder.  
**Day 3 cold re-prove (accepted 2026-08-21):** `…/trailer_ready_day4/output/trailer_9x16.mp4` — `*_20260821_125030_cold_reprove.mp4`. Priors = day2+day3 only. Do not overwrite Day 1, Day 2, wave29 lock, or this file without a snapshot.

**Day 2 closer (locked 2026-08-21, founder “awesome”):** `…/trailer_ready_day3/output/trailer_9x16_closer.mp4` + `vo_locked_long_accepted.txt`. Short master `trailer_9x16.mp4` stays. Leftover is Cost why-tonight (“hard to pin down — last night he walked a tie”) + cliff; last words on the leave walk.

**Phone-watch (Day 2, accepted)** — wall **00:12–00:16** = 15→14→1 HUD (no wooden bowl); **~01:18–01:21** = ACTIVE DOUBLES card grid (Vincent already `DISCONNECTED`, then Alex; not grey-wash); **01:21–01:27** = C1 leftover flyover still moving. Day 1 Wave 1.10 census HUD already accepted.

**Auto-gen (every later night / new sim):** `python -m video.run_tonight_scar <sim> --day N … --ignore-edit-script`. **Default = Closer tonight** (`vo_locked_long.txt` → `trailer_9x16_closer.mp4`). Short Scar = `--sku scar`. Leftover heat sits on Cost why-tonight + cliff; last words on the leave walk. Bake seeds G6 `ballots.mp4` + G7 census + split tally; recipe uses habitat **mp4 only** after the namecard; no C1 under the vote. Do not overwrite the locked packages above. Next short prove = `--sku scar` on a new sim Episode 1.

### Path A→E (locked)

| Step | Goal | Status |
|------|------|--------|
| **[A]** | Polish in Post-Production → phone-acceptable Live | **✅ Accepted** (P0 + P1 peak/challenge phone OK) |
| **[B]** | Rebuild → MP4 matches Live | **✅ DONE** (incl. P1 assets bake ~00:03) |
| **[C]** | Eng learn (E0 diff → E1 promote priors) | **✅ E0 + E1** (8 priors in `nightly_craft`; cold bake 2026-08-12) |
| **[D]** | Cold auto (no polish) vs [A] bar | **✅ Accepted 2026-08-18** on the **eight taught looks only** |
| **[E]** | Staged migrate eng `video/` → `double-video` | **✅ Code + prove bake 2026-08-22** · `trailer_ready_e_migrate_prove/output/trailer_9x16_closer.mp4` · Rebuild UI still `ENG_ROOT` |

**Name collision:** Path **[A]→[E]** above is the closed polish→cold program. The **agentic cold loop** is **Loop-A / Loop-B / Loop-C** (project → phone taste → done; fail goes to eng, not Live polish). See [`../20260821_video_loop.md`](../20260821_video_loop.md). Do not say “send it back to A” without saying **Loop-A** or **Path [A]**.

### [D] taste (closed)

Watch note: `…/output/E1_COLD_VERIFY.md`.

| # | Flag | Verdict |
|---|------|---------|
| 1 | Vincent goal sign 3.5 vs 3.6 | **Good enough** |
| 2 | DOUBLAND.AI vs village flyover | **Good enough** (slight polish preference; no fail) |
| 3 | End door speed | Motion **OK**; leftover **chat shadow** is a Wave 1 bug |
| 4 | Music duck under challenge VO | **Good enough** |
| 5 | Opening 2.5s poster | Not in E1. Audio hole (loading SFX too short) → Wave 1 |
| 6 | Phaser elim plug | **Good enough** (Wave 1.9: this-sim FE capture) |

**Do not copy** `clip_kit/imported/*` into cold defaults (challenge v2 bed, Alexis card-11 proof). Those stay polish-only until Wave 2 auto-kit can make equivalents.

### Next (pick order)

| Priority | Work | Notes |
|----------|------|-------|
| **1** | Next closer auto-gen | Default CLI is long. Day 2 lock: `trailer_ready_day3/output/trailer_9x16_closer.mp4`. Do not clobber short `trailer_9x16.mp4` / `vo_locked.txt`. Short = `--sku scar`. |
| **2** | Next short auto-gen (new sim Episode 1) | `--sku scar`. Same cold CLI. This sim has no Day 4. Do **not** overwrite Day 1–3 locks or the Day 3 cold re-prove. |
| — | Later P1 | Hero namecards · readable tie / VOTING TARGET |
| — | P2 eng | Freeze/coverage/FX gates · kit sim-code guard (after P0 — already accepted) |
| — | [E] migrate | Inventory OK anytime · **no bulk move** |

### Wave 1.16 — **accepted 2026-08-21** (Closer tonight default daily)

Founder phone-watch on Day 2 closer fold: leftover on Cost why-tonight, last words on the leave walk, no mid-body last-night vote recap. Master `…/trailer_ready_day3/output/trailer_9x16_closer.mp4` · `vo_locked_long_accepted.txt`. Short `trailer_9x16.mp4` untouched. Default CLI is `--sku closer`. Short = `--sku scar`.

### Wave 1.15 — **accepted 2026-08-21** (Day 3 cold re-prove)

Founder phone-watch on a **from-scratch** `trailer_ready_day4` (priors = day2+day3 only; wave29 moved to `accepted_day3_wave29/`). Auto-lock VO, seed G6/G7/split, Phaser elim from local FE, `--ignore-edit-script`. Master `…/trailer_ready_day4/output/trailer_9x16.mp4` · archive `*_20260821_125030_cold_reprove.mp4`. Short later-night auto-gen on this sim is **proven**. Next short prove = another sim’s Episode 1.

### Wave 1.14 — **accepted 2026-08-21** (G6 evening vote + habitat clip-only)

Day 3 phone-watch locked wave29. Auto-gen now: seed G6 `ballots.mp4` (stock or prior kit); split nights overlay `vote_tally`; habitat intro is namecard + mp4 (no still freeze); no hidden C1 under the vote. Applies to the next night of this sim and to Episode 1 of a new sim.

### Wave 1.13 — **baked 2026-08-20** (later-night VO + pictures)

Wave 24 phone-watch failed: “is back,” Irene plates on Alex’s VO, no challenge clip, Alex at ~00:41. Fix: later nights always speak Peak then Cost job+place; scar windows = first contiguous beat; intro plates stay in stake; Alliance Lock-In teach = pressure; Day-1 HUD only when VO says it. Day 3 re-lock + re-TTS via `--replace-vo-lock`. Bake `--snapshot-tag wave25 --ignore-edit-script`. Do not overwrite Day 1 or Day 2.

### Wave 1.12 — **locked 2026-08-20** (consecutive-night VO auto-gen)

Spoken later-night kit: Doubles opener, `{N} still in Survival mode`, Peak then Cost **job+place every night**, `Tonight's game is {challenge}` in steps_board order, `{N} become {N−1}`, catalog Door. N = `15 −` prior boots (same as G7 pictures). Auto-lock `vo_locked.txt` when missing; **never overwrite** an existing lock unless `--replace-vo-lock`. LLM drafts that say “fourteen remain” are rejected.

### Wave 1.11 — **accepted 2026-08-20** (G7 identity-card census + auto-gen)

G7 is Remotion **`CensusMatrix`**, not grey-wash, not a Pillow collage. Bake renders `census_matrix_pre.png` / `census_matrix_post.png` into that night’s `E_cliff_door` (never `imported/`, never a previous night’s mock). Priors come from sibling `trailer_ready_day*` ledgers (all earlier boots, not yesterday only). Count = `15 − n_priors`. Gone tile = stock silhouette + `DISCONNECTED`. Seat order = `seat_map` C→B→A.

### Wave 1.10 — **baked 2026-08-19** (hook census HUD)

“Until one remains” uses the Anya **15 → 14 → 1** countdown clip. Stock: `video/assets/nightly/census_15_to_1.mp4` (tracked). Nightly bake copies it into that package’s `E_cliff_door` — including Episode 1 of a new sim. Later nights copy from the prior kit. Not G6 ballots-in-bowl. Not `imported/`.

### Wave 1.9 — **accepted 2026-08-19** (phone-watch Phaser elim)

Option C: Playwright `?recording=true` still of Vincent at step **2309** (last in-world vote beat) → kit `F_phaser/vincent_leave_phaser.png` (not imported). Recipe prefers that still over the flyover plug. CLI: `python -m video.capture_phaser_elim <pkg> --force`. Nightly later: `--capture-phaser-elim` when FE+API are up.

### Wave 1.8b — **accepted 2026-08-19** (phone-watch 1b)

Option B (COS `2026-08-19-001`): same five Doubles; **card backs** (no phone-readable ranks). Peak clip still owns **11**. Kit dest `challenge_hold_for_shield.mp4` (not imported). `--challenge-table` only. Grammar: teach does not publish the winning fact; Peak does.

### Wave 1.8 — **phone-watch 2026-08-18 / 19**

**Pass:** five unique Doubles at the table.

**Fail (fixed in 1.8b):** Alexis held a readable **7** at the table, then Peak **11**. Face-up ranks during secret-card teach. Archived `*_wave19.mp4`.

### Wave 1.7 — **phone-watch 2026-08-18**

**Pass:** poster group photo; cafe 00:35.4–00:40.7; no village blink at 00:57; votes zoom from 2×.

**Fail (fixed in 1.8):** table 00:40.7–00:52.3 was Vincent + two Alexis, no cards.

### Wave 1.6 + Wave 2 — **phone-watch 2026-08-18**

**Pass:** loading, intros, title/steps, card 11 at 1×, flyover/walk/grey/cliff/door/end.

**Fix in 1.7:** poster photo; split cafe vs game; village blink ~00:57; votes from 2×.

### Wave 1 + 1.5 — **accepted 2026-08-18** (phone-watch)

**Pass:** quieter loading; sequential intros; no bad challenge still; steps on VO; win no longer freezes; alliances split; hole filled; walk then grey; cliff one-line-one-picture; door clean; end cuts after swoosh.

**Leftover (not a fail):**
- Cafe + Alexis win: short kit clips (loop / slow-mo). **Wave 2** = generate longer videos. Do not fail cold for this.
- Alliances: bump Talk speed + zoom. Second line = **text-only** card like the polish bar (not the votes PNG). Village peeking under 00:58–01:03 = `panel_under_title` / underlay leak. That’s **Wave 1.6** if we want one more recipe bake before Wave 2.

### E1 promote list (pre-approved 2026-08-12 — agent may proceed)

Constants / look / stock bus only — **never** promote `clip_kit/imported` src:

1. `photo_to_matrix_scan` — opener scan ~6s  
2. `cast_photo` — `wipeDelaySec` 0.1 (+ short photo hold)  
3. `badge_doubland` — ~1.5s hold  
4. `badge_live_simulation` — tighter LIVE  
5. `badge_n_active` — tighter N ACTIVE  
6. `want_cost` — earlier/longer stake window  
7. `signature_flyover_door` — longer + opacity ~0.85  
8. `intrigue_loop` — music duck (teach ~0.08)  

**Optional if clean:** `end_lockup` **hold length only** (not imported lockup media).  

**Do not promote:** `hook_census*`, `peak_portrait`/`challenge_*` speeds, alliances scale, SoftWhoosh batch (defer), imports, captions, VO, ledger, Phaser plug.

**E1 status (2026-08-18 — [D] accepted on the 8 looks):**

- Promoted 8 + optional end_lockup hold into `nightly_craft` / scar / props (no imports).
- Cold path: `--ignore-edit-script` on same package.
- **Cold MP4:** `generative_agents-ivan-dev/data/20260724-2/trailer_ready_day2/output/trailer_9x16_e1_cold.mp4`  
  (also `trailer_9x16.mp4` master from that bake)
- **Verify note:** `…/output/E1_COLD_VERIFY.md` (pattern table + taste flags)
- Props: `video/remotion/props/nightly_20260724-2_day2_long.json` (cold)
- VO-lock / Peak·Cost·challenge: no regressions in gates
- Soft: want_cost hold **3.5s** (not polish 3.6) for hero-layer gate

### [C] handoff — Grok build agent (eng)

**Project / cwd:** `D:\Coding\generative_agents-ivan-dev` · branch `ivan/*` (e.g. `ivan/dev` or `ivan/polish-learn-e0`)  
**Not** `D:\Coding\double-video` (Post-Production only produces artifacts; learning sink is eng recipe/grammar).  
**Contract:** `D:\Coding\double-video\prd.md` §22.2 · SOT checklist: `D:\Coding\double-ivan\video\TODO_video.md`

**Package:** `D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day2`  
**Polish SOT:** `D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day2\edit_script.json` (current)  
**Rough candidates (pre tonight’s big polish):**  
- Prefer: `D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day2\edit_script.snapshots\edit_script_20260807_223807Z.json`  
- Pre-wipe alt: `D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day2\edit_script.snapshots\edit_script_20260811_214451Z_pre_matrix_wipe.json`  
- Mid (after wipe, before P0 dynamism): `D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day2\edit_script.pre_p0_dynamism_20260811_220017.json`  

If unclear, rebuild rough from cold props *without* applying polish (document choice). Props path if needed: `D:\Coding\generative_agents-ivan-dev\video\remotion\props\nightly_20260724-2_day2_long.json` (note: may already be post-apply — prefer edit_script snapshots).  
**Markers / pain:** freezes from short clips; challenge/peak holds; music duck; poster wipe (keep); Phaser plug (package-only).

**Agent phases (stop for founder between E0 and E1):**
1. **E0** — Implement thin `D:\Coding\generative_agents-ivan-dev\video\polish_learn.py` (or `diff_edit_script.py`) + CLI; emit **diff report only** (no recipe writes). Tag rows `promote_candidate` | `package_only` | `do_not_touch`. Tests for diff. **Do not promote yet.**
2. **Pause** — Founder picks **5–10** promote rows (~15 min).
3. **E1** — Promote **3–7** allowlisted constants (holds/poster/stock SFX/look priors — **not** imports, captions, ledger facts, VO). Cold nightly **without** polish → phone-watch bar: ≥3 patterns visible cold; no VO-lock regression.

**Never promote:** `D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day2\clip_kit\imported\*` as cold defaults · caption text · Peak/Cost/challenge winners · full timeline clone · Imagine one-offs.

**Copy-paste task for agent:**

```
[C] Eng polish→learn — E0 only first (prd §22.2)

Repo / cwd: D:\Coding\generative_agents-ivan-dev
Do NOT change D:\Coding\double-video product UI.
Contract: D:\Coding\double-video\prd.md §22.2
SOT: D:\Coding\double-ivan\video\TODO_video.md ([C] handoff)

Package: D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day2
Polish: D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day2\edit_script.json
Rough prefer: D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day2\edit_script.snapshots\edit_script_20260807_223807Z.json
  alt pre-wipe: ...\edit_script.snapshots\edit_script_20260811_214451Z_pre_matrix_wipe.json
  mid fallback: ...\edit_script.pre_p0_dynamism_20260811_220017.json

Build thin video/polish_learn.py (or diff_edit_script.py) + CLI + tests:
- Diff rough vs polish: per-role Δdur/Δstart, opacity/fade/speed, sfx add/remove,
  poster hold, fx deltas
- Tag each row: promote_candidate | package_only | do_not_touch
- WRITE REPORT ONLY — no recipe/grammar/SFX default changes yet

Never promote: imported media, caption text, ledger/Peak/Cost facts, VO, full timeline clone.
Allowlist intent later (E1): holds, poster, stock SFX, look priors.

Deliverable: markdown/JSON diff report + how to re-run CLI.
STOP and hand founder top promote_candidate rows for 15-min pick.
Do NOT run E1 promote or cold rebuild until founder approves the list.
```

### P1 — assets + Grok Imagine 2.0 leverage (2026-08-11)

**Order (locked):** peak evidence → challenge teach bed → Phaser elim.  
**Maker default:** founder/agent on **grok.com/imagine** (2.0 / Video 1.5+), then stage into `clip_kit/imported/` + wire cuts. Eng auto-kit stays on older i2v defaults (`duration=2`, `720p`) — **do not use that path for these three** until eng bumps duration/resolution.

| # | Asset | Window | Target deliverable | How to leverage 2.0 |
|---|-------|--------|--------------------|---------------------|
| **1** | Peak evidence | ~50–55s | **≥6s** 9:16 clip (fills 5.5s without freeze) | **Multi-ref still** (Alexis face + habitat/namecard + card prop) → **i2v 720p**, duration **6–8s**, subtle hold/reveal of **readable winning card**. Mute only — strip/ignore native audio. Light life OK; **double identity consistent**. |
| **2** | Challenge teach bed | ~33–50s (~17s) | **≥12s** motion (API max often **15s**; loop or `speed≈0.85` for remainder) | Still: card table / hands / Hold-for-Shield (Anya grammar, **Alexis cast**). **i2v 12–15s** @ **720p**; multi-ref lock table + Alexis. Prefer longer single take over 2s loop. |
| **3** | Phaser elim | ~70.7–74.1 | Correct-cast still (or short clip) | **Leave flyover plug** until **FE Phaser screenshot**. No Imagine interim. |

**Use hard:** multi-ref identity (face/prop/place) · **longer duration** (kill 2s freeze root cause) · **720p** (do **not** max 1080p) · 9:16 aspect.  
**Skip for trailer beds:** voice clone / dialogue audio · 1080p.  
**API note:** eng `xai_imagine.generate_i2v` allows duration 1–15; kit callers still pass **2s** — P1 one-offs use **6–15s / 720p** (UI or API).

**Founder locks (2026-08-11):** style refs OK + life improvisation with consistent doubles · Phaser = FE only · peak card = **sim rank 11** (see below) · deliverables @ **720p**.

### P1 — status

| # | Asset | Status |
|---|-------|--------|
| 1 | Peak evidence (Alexis + readable **rank 11** card) **≥6s** @ 720p | ✅ staged `alexis_peak_card11.mp4` (7.0s) · wired `peak_portrait` speed 1.0 |
| 2 | Challenge teach bed **≥12s** @ 720p | ✅ **v2** group secret cards · wired · **Rebuild ✅** (~00:03) |
| 3 | Correct-cast Phaser elim | ✅ captured `vincent_leave_phaser.png` (step 2309) · Wave 1.9 **accepted** |
| — | Later: hero namecards · readable tie / VOTING TARGET | ☐ |

**P1 gen note (2026-08-12):** peak `alexis_peak_card11` + challenge **v2** `challenge_hold_shield_bed_v2` (group, each own secret card; v1 solo-shuffle rejected). Staged under `clip_kit/imported/` + `_p1_gen/`. **Rebuild green** → phone-watch ~33–50s (challenge) + ~50–55s (peak **11**). Phaser elim = FE capture (Wave 1.9).

### Phaser elim — decision

**Plug shipped** then **Option C captured 2026-08-19**: kit `vincent_leave_phaser.png` from local FE recording mode. Flyover remains the fallback if capture is missing. Do not Imagine.

### Peak card rank — resolved (Supabase)

Sim **`20260724-2`** · `hold_for_shield` · day 1 · winner **Alexis Reed**.

| Source | Value | Use? |
|--------|-------|------|
| `survival_season_state.challenge_results` → `public_board.holders["Alexis Reed"]` | **11** | **Yes — resolution truth** (highest among holders) |
| Same row → `decisions[Alexis].card` | 7 | No — private 7-player deal before re-deal; inconsistent |
| Suit / 52-card deck | **none** | Challenge uses integer ranks **1…N** only |

**Mute visual:** show a challenge card labelled **11** (readable at phone), not a poker suit. Optional shield / IMMUNITY badge. Do not invent Ace–King. VO already says “highest card” — no VO change.

**Eng note:** trailer `fact_ledger` only copies winners; card ranks stay in Supabase until ledger gains a field.

### P2 — eng (only after founder accepts P0 bake)

Freeze/coverage/FX gates · kit sim-code guard · optional `*.base.json`. Detail: [brief § P2](../20260811_capcut-vs-post-prod.md#p2--eng-only-after-founder-accepts-a-p0-bake).

### [C] → [D] → [E]

| When | Work |
|------|------|
| After [B] | E0 polish↔rough diff → founder picks 5–10 promote rows → E1 constants |
| After [C] | Cold nightly without polish; phone-watch vs [A] — **done 2026-08-18** |
| After [D] | Wave 1 recipe hygiene → Wave 2 auto pictures → FE Phaser. **Done 2026-08-19.** Do not copy imports. |
| After [B]+[C] | [E] staged slices (inventory OK anytime; **no bulk move**). Polish UX stays in `double-video` now — that is not [E]. |

**Later (after E):** longer daily · 2D↔3D · Grok Imagine 2.0 · cold reproduce [A] inside monorepo.

### Agent map

| Work | Who |
|------|-----|
| P0 Live taste / Save | Human (+ agent in `double-video` if handed) |
| Rebuild babysit | Agent (eng) |
| E0 / E1 | Agent (eng) after founder approve |
| Migration inventory | Agent read-only; no code move |
| Imagine / FE Phaser capture | Founder / product after P0 |

### Evidence (do not re-debate)

| Doc | Role |
|-----|------|
| [`../20260811_capcut-vs-post-prod.md`](../20260811_capcut-vs-post-prod.md) | Merged verdict + P0 field actions |
| [`daily/gold/…/20260811_dynamism_gap_20260724-2.md`](daily/gold/20260713-1_day1_anya/20260811_dynamism_gap_20260724-2.md) | First watch pass |
| [`daily/gold/…/20260811_opus_second_opinion_p0_bake.md`](daily/gold/20260713-1_day1_anya/20260811_opus_second_opinion_p0_bake.md) | Freeze % + bake review |
| Frames | `teardown/opus_20260811/` · `teardown/watch_pass_20260811_*` |

### Paths / locks

| | |
|--|--|
| **Craft bar (Anya)** | `…/20260713-1/…/0720(1).mp4` (~88.2s) |
| **Our package** | `…/20260724-2/trailer_ready_day2/` |
| **Gold forensics** | [`daily/gold/20260713-1_day1_anya/`](daily/gold/20260713-1_day1_anya/GOLD.md) |
| **VO** | Locked — do not rewrite |
| **Runtime** | Gold ~88s · auto warn >90s · hard max 120s |
| **Cinematic pack** | C1–C8 ✅ wired into gold replay |

**Product goal:** cold kit + Remotion approaches Anya night after night.  
**Out of scope until later:** CapCut XML import as product · encyclopedia Remotion polish · inventing ledger facts.

---

## ▶ Historical — N1–N6 ship path (2026-07-30)

**Snapshot (2026-07-30):** N1–N6 ✅ · N5 ✅. Then-current prove MP4: `data/20260724-2/trailer_ready_day2/output/trailer_9x16.mp4` (long mode). VO locked; pictures auto-READY. **Current work is the ▶ Now section above** — do not treat this block as the active checklist.

### ▶ Path — gold-quality daily trailers for **new sims** (active)

Goal: Tonight’s Scar chain (SOT §11.4) produces a Day-1 cut that approaches Anya gold; later nights on the **same** sim reuse that sim’s picture kit.

| # | Work | Owner | Status | Notes |
|--:|------|-------|--------|-------|
| **N1** | Tonight’s Scar package chain stays product path | eng | ✅ | `extract` → picker → VO draft → meaning-lock → `build_clip_kit` → `run_nightly_survival`. Old `day_overview` encyclopedia stays off. |
| **N2** | Challenge teach packs on disk + tracked in git | eng | ✅ 2026-07-30 | Restored 14 packs to `video/assets/challenges/` from Cursor assets cache (were lost because `video/assets/*` was gitignored). `.gitignore` blanket removed. |
| **N3** | **Auto picture kit (G1–G5 + G8 + G3 i2v)**; reuse across nights | eng | ✅ 2026-07-30 | Locked + shipped: `video/auto_picture_kit.py` · xAI i2v in `xai_imagine.py` · CLI `--auto-picture` on `build_clip_kit` / `run_nightly_survival`. |

### N3 lock (2026-07-30) — auto picture for new sims

**Outcome:** First trailer run for a sim/night auto-builds Priority pictures; later nights reuse sim cache. Human checks **final MP4 only** (N6).

| Decision | Lock |
|----------|------|
| Scope | **G1–G5 stills + G8 namecards** auto + READY; **G3 still → i2v clip** in same pass |
| Out of scope | G6/G7, H_*, teach-pack chrome (already on disk) |
| Hook | **Both** `build_clip_kit` + `run_nightly_survival` (nightly = safety net) |
| Cache | `data/<sim>/picture_kit_cache/` — **habitats + namecards** (persona keys); G4/G5 per-night; G3 still/clip by challenge id when present |
| Fail policy | Hard fail G1/G2/G4/G5/G8 if gen fails; **G3 i2v soft** if challenge teach pack exists (warn + teach/stock motion bridge) |
| READY | Auto-mark READY on successful still (and G3_clip after i2v) — no mid-pipeline human gate |
| Nightly default | `--auto-picture` **on**; `--require-picture-ready` **on** for G1–G5 + G8 (+ G3 still); G3_clip soft |
| G3 motion | xAI i2v from approved G3 still → `challenge_<type>.mp4` (~2s, 9:16) |
| Force | `--force-picture` regenerates even when cache/bin exists |

**Prove:** `20260724-2` Day-1 after N3 lands.
| **N4** | Soul15 `seat_map.json` consistent across photo / matrix / roster | eng | ✅ 2026-07-30 | Regenerated v4.0 from `cast_reference.md`: top→bottom = **C / B / A**; Ivan **3.3**; Nick **1.3**. Do not flip front/back rows. Optional: rebuild framed/matrix via `rebuild_framed_matrix_from_group.py` when that script is restored. |
| **N5** | Missing place refs (interiors + Phaser crops) | eng+founder | ✅ 2026-07-30 | Phaser ✅. Interiors ✅ — `generate_missing_interiors --generate` wrote 19 plates; inventory TODO=0. Founder: visual spot-check list in chat. |
| **N6** | SOT + CLI: full auto-gen; human check = final trailer only | eng | ✅ 2026-07-30 | `video/run_tonight_scar.py` one-command (ledger+picker+locked VO → clip_kit auto-picture → nightly). SOT §11.4/§14 updated; mid-pipeline READY not a human hard stop. Inputs still: Peak/Cost, VO lock, audio+timing, fact ledger. |

**Prove on:** sim `20260724-2` Day-1 (Soul15 fork — reuse cohort faces / group photo / seat_map).

**Done when:** cold package for that sim → Remotion `trailer_9x16.mp4` without mid-pipeline human gates; founder only phones the final cut.

### Done (do not re-open unless broken)

| Area | Status |
|------|--------|
| Gold forensics A1–A5 | ✅ Registered package, 1fps teardown, beat map, legend catalog, craft notes |
| CapCut ingest B1/B5 + E1–E3 | ✅ Project + CSV extracts + breakdown |
| Runtime + Anya bar C1–C4 | ✅ Draft rubric; 88s gold / warn>90 / fail>120 |
| Picture-kit schema D1–D2 | ✅ Job list dry-run + prompt family stubs |
| **Remotion gold replay Phase 1** | ✅ CapCut CSV → edit plan → `DailyGoldReplay` layers (plates, kinetic type, VO, music, SFX stand-ins) |
| A/V alignment | ✅ CapCut `source_timerange` offsets (fixes double-VO / music restart); VO clip2 `sourceStartSec≈7.78` |
| Music bed | ✅ Loopable `music_intrigue_loopable.mp3` + Anya volume envelope (not short `music_drama` restart) |
| End-of-film cleanup | ✅ Post-boot (~68.5s): fade music/VO tail, thin stacked plates, soft door — **FX still deferred** |
| Flyover commission brief | ✅ Locked shot list + foundation plate rules (see path above) |
| **C1–C8 pack on disk** | ✅ Landscape C1–C3 · portrait C4–C8 · working names under `video/fly-over/` |
| **D5b gold-replay wire** | ✅ Alpine still `B604…` (~30.4s) + open-roof `Village.mp4` (~58.7s) → **C1** `c1.2.mp4`; Phaser `signature_flyover` kept; props rebuild + unit tests green |
| **Phase 1 portrait HUD** | ✅ Lower-third kinetic type · wide badges `contain` · Survival stamp red-only · (later superseded by stacking pass) · night alpine → **C3** · end audio fade ~2.2s |
| **Legend HUD stack + FX + SFX** | ✅ (2026-07-27 watch-pass retune) Full multi-panel STEP/want/immunity chrome · CapCut FX + SFX floors |
| **Gold replay end-fill cut** | ✅ (2026-07-28) Full-bleed end VO · C2 animated night overhead · 9:16 lockup pad · `out/gold_replay_day1.mp4` |
| **Opener beds → C1–C8** | ✅ (2026-07-29) `video/cinematic_pack.py` · compose_trailer / showrunner / aerial_broll |
| **E5 legend promote** | ✅ (2026-07-29) 32 used → `video/assets/legend_promoted/20260713-1/2/` · unused in `UNUSED.md` |
| **D3 picture still path** | ✅ (2026-07-29) `generate_picture_stills` queue + optional xAI · `mark_picture_jobs` READY gate |
| **E4 product path** | ✅ **Remotion** = production · CapCut = gold-breakdown reference only |
| **#8 Phase A/A2** | ✅ Gap freeze `generative_agents/video/NIGHTLY_CRAFT_GAP.md` · role intro + length modes in daily SOT · `sot_challenges` §5.2 Hold-for-Shield specimen · `video/assets/challenges/hold_for_shield/` |
| **#8 Phase B** | ✅ Shared `video/nightly_craft.py` · gold imports shared craft · day props `lengthMode` stub · `test_nightly_craft.py` |
| **#8 Phase C** | ✅ `build_nightly_remotion_props` → `NightlySurvival` (gold renderer) · challenge teach + Cost grey + end lockup · H_* HUD still off |
| **#8 Phase D** | ✅ `run_nightly_survival` · `validate_nightly_survival` · snapshot-before-overwrite · length/literacy gates · report JSON |
| **#8 Phase E0** | ✅ Day-1 full nightly render (no CapCut) → `trailer_ready_day2/output/trailer_9x16.mp4` (~93s) |
| **#8 Energy pass** | ✅ SFX≈23 + key-phrase CC + Anya WANT; still flat vs gold → expert brief `20260729_expert_brief_gold_vs_nightly_auto.md`; ref MP4 `trailer_9x16_20260729_184421_energy_pass_ref.mp4` |
| **#8 Edit-script sync** | ✅ Gold props → `edit_script.json` (50 cuts); nightly prefers script; master `trailer_9x16_20260729_200304_edit_script_v1_full.mp4`; expert verify `20260729_expert_brief_edit_script_verify.md` |

### Parked on founder (creative — not eng)

- [x] **Manual cinematic pack C1–C8** — **COMPLETE**  
  - Brief: `generative_agents/video/fly-over/COMMISSION_cinematic_pack.md`  
  - Landscape: `c1.2.mp4` · `C2.mp4` · `C3.png` (crop to 9:16 in edit)  
  - Portrait: `C4`–`C8` stills (+ videos where present)  
  - Keep `signature_flyover.mp4` for Phaser plant/door  
- [x] **Phone-watch gold replay** end-fill cut on disk — optional re-check 01:16–01:30; optional true night `C3.mp4` later  
- [x] Optional: taste-gate Qs in [`craft_notes.md`](daily/gold/20260713-1_day1_anya/craft_notes.md) when convenient  
- [ ] Optional: sharpen C5/C7 · Hobbs-branded cafe · canonical renames on disk  
- [x] **Roster seat-map legend (Soul15)** — `seat_map.json` **v4.0 restored 2026-07-30** (C/B/A; Ivan 3.3 / Nick 1.3); group photo + matrix on disk; framed roster optional rebuild  
- [x] **Hold for the Shield teach pack specimen** — on disk under `video/assets/challenges/hold_for_shield/` (restored 2026-07-30) + SOT §5.2  
- [x] **Hold reusable starter pack** — README + cast-agnostic reuse notes in SOT §5.2 / COMMISSION  
- [x] **Silent Pact → Shared Survival Pool teach packs** — §5.3–§5.15 commissioned; **PNG packs restored 2026-07-30** to `video/assets/challenges/<id>/` (title / steps_board / immunity_status)  
- [ ] **Length A/B:** render short + long for N nights; lock long budgets after feedback  
- [x] **N5 interiors generate** — Phaser ✅; 19 plates generated 2026-07-30 (`generate_missing_interiors --generate`); spot-check remaining  

### Later — after video lands in double-video

- [ ] **GrokFilm (prompt craft only)** — Harvest ~10–20 lighting/camera tokens from [grokfilm.app/#index](https://grokfilm.app/#index) into owned prompt families (namecard / habitat / cost / i2v). No runtime dependency; no Remotion / Post-Production integration; skip genre packs. Migrate this bullet into `double-video` when eng `video/` moves.

### Next eng (order)

1. ~~**Wire new plates into gold replay**~~ ✅ (2026-07-25) — see D5b  
2. ~~**Phase 1 portrait HUD grammar**~~ ✅ (2026-07-27)  
3. ~~**Legend HUD stacking + CapCut FX + SFX floors**~~ ✅ (2026-07-27)  
4. ~~**Full 88s gold-replay re-render**~~ ✅ (2026-07-28 end-fill)  
5. ~~**Wire pack into opener beds**~~ ✅ (2026-07-29)  
6. ~~**Promote used legend assets (E5)**~~ ✅ (2026-07-29)  
7. ~~**Picture-kit still path (D3)**~~ ✅ (2026-07-29)  
8. ~~**Daily auto path Phase A–E0 / edit-script**~~ ✅ · gold path proved on `20260713-1`  
9. ~~**E4 decision**~~ ✅ Remotion product path · CapCut gold-breakdown reference  
10. ~~**N3 — Auto G1–G5 + G8 + G3 i2v**~~ ✅ (2026-07-30) — `auto_picture_kit` + sim `picture_kit_cache`
11. ~~**N6 — SOT/CLI full auto; human = final trailer only**~~ ✅ (2026-07-30) — `run_tonight_scar`
12. **N5 interiors** — run `python -m video.generate_missing_interiors --generate` + spot-check (Phaser ready)
13. **Prove** Day-1 nightly on `20260724-2` (Soul15 fork)

### Commands (Tonight’s Scar ship — eng repo `generative_agents-ivan-dev` / `ivan/dev`)

```bash
# Draft VO only (optional)
python -m video.run_tonight_scar <sim> --day 2 --peak "…" --cost "…" --draft-vo-only --template-only

# Ship (after vo_locked.txt + narration audio + timing + fact_ledger)
python -m video.run_tonight_scar <sim> --day 2 --peak "…" --cost "…" \
  --vo data/<sim>/trailer_ready_day2/vo_locked.txt --length-mode long
```

### Commands (gold replay — eng repo `generative_agents-ivan-dev` / `ivan/dev`)

```bash
python -m video.build_gold_replay_props
cd video/remotion
npx remotion still DailyGoldReplay out/gold_replay_smoke.png --props=props/gold_replay_day1.json --frame=90
npx remotion render DailyGoldReplay out/gold_replay_day1.mp4 --props=props/gold_replay_day1.json
```

Compare against master `clip_kit/bins/video/0720(1).mp4`. Details: [`GOLD.md` § Remotion gold replay](daily/gold/20260713-1_day1_anya/GOLD.md).

### Do not do while flyovers are in progress

- Re-open VO rewrite / re-TTS (V6 locked)  
- Force optional HUD (`H_*`) into auto-gen before taste gate  
- Replace Phaser `signature_flyover` with cinematic overheads  
- Commission morning / park-only / library-only packs before C1–C8 accepted  
- Treat encyclopedia Gate A–E or “Suggested order this week (2026-07-23)” below as the active spine

---

## Now — status (2026-07-24)

### Track A — Freeze the gold (forensics) — **DONE**

- [x] **A1 — Register gold package** → [`daily/gold/20260713-1_day1_anya/GOLD.md`](daily/gold/20260713-1_day1_anya/GOLD.md)
- [x] **A2 — 1fps teardown** → `teardown/reference_grabs/` (88) + `timecode_index.csv`
- [x] **A3 — Beat map** → [`gold_beat_map.md`](daily/gold/20260713-1_day1_anya/gold_beat_map.md)
- [x] **A4 — Legend catalog** → `legend_catalog/files_raw.csv` + README (+ CapCut `legend_usage.csv`)
- [x] **A5 — Craft notes** → [`craft_notes.md`](daily/gold/20260713-1_day1_anya/craft_notes.md)

### Track B — Close the kit / handoff hygiene

- [x] **B1 — CapCut project received** → `bins/capcut_proj/` (draft **L-talks Day 1**) · exports in `bins/video/`
- [ ] **B2 — Normalize folder names** in next `START_HERE` template (`capcut_proj/` · `video/` · `F_Anya-legend/`)
- [x] **B3 — Diff staged vs gold** → `gold_beat_map.md` + CapCut breakdown
- [x] **B4 — Preserve `clip_kit_v0`** — documented immutable
- [x] **B5 — CapCut breakdown + extracts** → [`capcut_project_breakdown.md`](daily/gold/20260713-1_day1_anya/capcut_project_breakdown.md) · [`capcut/`](daily/gold/20260713-1_day1_anya/capcut/) CSVs

### Track C — Quality bar → validators — **DONE draft; taste open**

- [x] **C1 — Anya bar rubric** → [`anya_bar_rubric.md`](daily/gold/20260713-1_day1_anya/anya_bar_rubric.md)
- [x] **C2 — Runtime policy** → founder: gold 88s OK; auto **warn >90 / fail >120**
- [x] **C3 — Validator gap map** → inside rubric §E
- [x] **C4 — 2D↔3D freeze** → plant ~t7–13 · cost dive ~t66→70 · door ~t85

### Track D — Pipeline eng

- [x] **D1 — Job list schema + dry-run** → `generative_agents/video/picture_kit_jobs.py`
- [x] **D2 — Prompt family stubs** → `generative_agents/video/prompt_families_picture_kit.md`
- [x] **D5 — Remotion gold replay Phase 1** → `DailyGoldReplay` + `build_gold_replay_props.py` (VO/music offsets, loopable bed, end cleanup). **Not** optional anymore — this is the active rebuild path.
- [x] **D5b — Wire cinematic pack into gold replay** — alpine `B604…` + `Village.mp4` → C1; Phaser flyover kept; `WORLD_PLATE_REPLACEMENTS` + pack resolve in props builder
- [x] **D5c — CapCut-parity FX + SFX floors** — scan/shake from CapCut effect track + craft black-hit/radial-zoom; stock SFX volume floors via `sfx`/`sfx_raw`
- [x] **D5d — Opener beds** — `cinematic_pack.py` wires compose_trailer / showrunner / aerial_broll to C1–C8 (+ signature)
- [x] **D3 — Still generation path** — `generate_picture_stills` + `mark_picture_jobs` (+ optional xAI); i2v still later
- [x] **D4 / E5 — Legend promote** — 32 used → `legend_promoted/20260713-1/2/`; unused listed (pHash optional later)
- [x] **D6 — Out of scope held** — no CapCut XML product path / encyclopedia Remotion as spine

### Track F — Cinematic village pack (founder) — **DONE**

- [x] Commission brief + aspect policy (C1–C3 landscape; C4–C8 9:16)
- [x] **C1–C8** masters on disk under `video/fly-over/` (`c1.2`, `C2`, `C3`, `C4`–`C8` stills/videos)
- [x] Gold-replay wire (wrong world plates → C1)
- [x] Opener wire → C1–C8 (+ signature); old cinematic heroes no longer listed in opener beds
- [ ] Optional: canonical renames · sharpen C5/C7 · Hobbs-branded cafe take

### ⏸ Founder taste gate (before forcing gold HUD into auto-gen)

Answer in [`craft_notes.md`](daily/gold/20260713-1_day1_anya/craft_notes.md) when ready — summary:

1. Kinetic VO words every beat — mandatory / nice / CapCut-only?  
2. Challenge STEP 1–2–3 overlays every immunity day?  
3. Cost want = objective HUD vs workplace habitat?  
4. Abstract alliances card vs real social clip?  
5. Custom L-Talks end lockup every night?  
6. NEW TARGETS radar brand vs one-off?  
7. Is ~88s **preferred** Day-1 length or only acceptable ≤120?

Until then: eng ships **G1–G8 + Phaser** as required; **H_*** jobs stay `optional`.

### Track E — CapCut project (received 2026-07-24)

- [x] **E1 — Ingest project** → `bins/capcut_proj/`; duration matches master 88.233s
- [x] **E2 — Timeline extract** → `capcut/*.csv` + `capcut_summary.json`
- [x] **E3 — SFX / transition / type inventory** → breakdown §4–6
- [x] **E4 — Rebuild path decision** — **Remotion = product**; CapCut = gold-breakdown reference for new trailer types (Anya gold → forensics → Remotion re-assemble)
- [x] **E5 — Promote 32 used legend assets** → `video/assets/legend_promoted/20260713-1/2/`; 15 unused in `UNUSED.md`

---

## Suggested order (from 2026-07-24)

| When | Do |
|------|----|
| **Now (founder)** | Phone-watch gold replay ~31s / ~59s (C1 plates) vs Anya master |
| **Next eng** | Opener beds → C1–C8 · full 88s render if watch OK |
| **Then** | Optional FX · E5 legend promote · D3 still path |
| **After taste + one clean replay** | Lift craft into daily auto-gen; E4 product-path decision |
| **Later** | Phase 2 parity polish; Spark auto-crop; `[B] day_normal` |

---

## Definition of “project started” — **MET (2026-07-24)**

1. ✅ Gold film + legend registered and not overwriteable.  
2. ✅ Beat map: sheet scene ↔ gold picture ↔ kit gap (+ CapCut).  
3. ✅ Anya-bar rubric draft exists.  
4. ✅ G1–G8 job list dry-runs from Day 1 without Imagine.  
5. ✅ CapCut draft ingested; Remotion gold replay Phase 1 renders.

Remaining uplift = **plates + auto path**, not “has the project started.”

---

## Pointers

| Doc / path | Use |
|------------|-----|
| **This section ↑** | Active resume spine after flyovers |
| [`daily/gold/…/GOLD.md`](daily/gold/20260713-1_day1_anya/GOLD.md) | Gold hub + Remotion replay commands |
| [`daily/SOT-new-daily.md`](daily/SOT-new-daily.md) | Normative D1 contract, bins, G1–G8, eng phases |
| [`daily/VO_LOCKED.md`](daily/VO_LOCKED.md) | V6 gold spoken text |
| [`daily/daily-2D-3D-blend.md`](daily/daily-2D-3D-blend.md) | Phaser literacy grammar |
| `generative_agents/video/fly-over/COMMISSION_cinematic_pack.md` | Flyover pack · **C1–C8 COMPLETE** · foundation `village_overhead_wide` |
| `generative_agents/video/build_gold_replay_props.py` | CapCut CSV → DailyGoldReplay props |
| `generative_agents/video/build_clip_kit.py` | Stages CapCut kit |
| `generative_agents/video/validate_clip_kit.py` | Kit gates |
| `generative_agents/video/picture_kit_jobs.py` | G1–G8 / H_* job list |
| Below on this page | Legacy encyclopedia / Gate A–E notes — **not** the active spine |

---

## Picture-pass asset audit — `20260713-1` / `overview_day2&001` (2026-07-15)

**Package:** Survival Day 1 locked VO (`VO_LOCKED.md` ≡ `script.json` ≡ `script_used.txt`).  
**Featured cast:** Ivan Pitts · Irene Dove · Vince Vale.  
**Purpose:** Tomorrow’s Remotion prep checklist — gather/stage vs generate vs per-day custom clips.  
**Do not** overwrite locked VO / re-TTS while Anya review is open.

### Scene → visual job (edit spine)

| Scene | Beat | VO job | Visual job |
|------:|------|--------|------------|
| 1 | concept_reset | What Doubles are | Brand / group / matrix still |
| 2 | survival_frame | First night / eliminate until one | Survival framing still (group or dorm common OK) |
| 3–5 | cast_intro | Job + place + want stamps | Hero portrait per Double |
| 6 | challenge_teach | Hold for the Shield → Irene wins | Irene + challenge space (optional 1–2s clip) |
| 7 | mid_turn | Ivan hunts; Vince↔Irene talk | Social / night pressure (optional clip) |
| 8 | cost | Six votes; Ivan goes home | Vote / farewell (highest clip priority) |
| 9 | cliff_cta | Trust vacuum + doubland.ai | Irene / cliff + opener end-card pattern |

---

### 1. Ready now (exist on disk — stage into Remotion)

**Cast (baseline cohort `soul15_seed_20260224`)**

| Person | Hero | Portrait | Sketch | Cutout |
|--------|:----:|:--------:|:------:|:------:|
| Ivan Pitts (`42c86639-…fea8`) | ✅ | ✅ | ✅ | ✅ |
| Irene Dove (`eac7be2a-…e9dc`) | ✅ | ✅ | ✅ | ✅ |
| Vince Vale (`69835d95-…845d`) | ✅ | ✅ | ✅ | ✅ |

Paths: `video/assets/cohort/soul15_seed_20260224/{hero,portraits}/<uuid>.png` · sketches `video/assets/users/sketches/` · cutouts `video/assets/users/cutouts/`. Full 15-Double set present in each.

**Group / concept**

- ✅ `group_photo.png` (+ `group_photo_a/b/c.png`, `group_photo_matrix.png`)
- ✅ `relationship_graph.json`, `cast_reference.md`, `manifest.json`

**Places we already have plates for (usable today)**

- ✅ **Hobbs Cafe** — `village/interior/cafe_int_counter.png`, `cafe_int_dining.png` · exterior `village/exterior/hobbs_cafe_exterior_wide.png`
- ✅ **Dorm / night common** (vote / “room” pressure proxy) — `dorm_int_common.png`, `dorm_int_common_vertical.png`, bedrooms/baths
- ✅ **Library** — `library_int_reading.png`, `library_int_stacks.png` · exterior `library_exterior_wide.png`
- ✅ **Oak Hill College classroom** — `college_int_classroom.png` (Vince workplace stamp)
- ✅ **Willows Market & Pharmacy** — `willows_pharmacy_int_counter.png`, `willows_market_int_aisle.png`
- ✅ **Harvey Oak Supply Store** — `supply_int.png`
- ✅ **Rose and Crown Pub** — `pub_int.png`
- ✅ **Apartments 1–5** — `apt{N}_int_main.png` + baths
- ✅ **Houses 1–3 mains** + **Houses 4–6** commons/bedrooms/baths
- ✅ **Artist co-living** — common + studio rooms 1–5 + baths
- ✅ **Johnson Park** (outdoor) — `village/exterior/johnson_park_exterior_wide.png`
- ✅ Phaser property top-downs for the above under `video/assets/phaser/_moodboard/` (manual crops; see that folder’s README)
- Inventory coverage: **57 DONE / 0 TODO / 6 N/A** (`village/interior/_room_inventory.md`)

**Still optional / not blocking Day-1 picture pass**

- [ ] **Oak Hill College exterior** (library exterior ≠ college facade)
- [ ] **Willows exterior** (optional stamp / establish)

**Audio / edit package**

- ✅ Locked narration + timing: `overview_day2&001/audio/narration.mp3`, `narration_timing.json`
- ✅ Mood bed: `audio/music_drama.mp3`
- ✅ Scene list in `script.json` (`locked_human_vo: true`)

**Remotion plumbing (code, not new media)**

- ✅ Daily props path + moment-clip drop-in convention: `video/assets/moment_clips/<sim>/<day>/beat_<scene_id>.mp4`
- ✅ End-card / opener component reuse already wired

**Gaps inside an otherwise-ready package (fix at render time, not new art)**

- [ ] Scenes 6–9 in `script.json` have `hero_path: null` — props builder should resolve from `focus_persona`; verify on first Remotion props build.
- [ ] All scenes have empty `location` — on-screen location labels won’t show until filled (B2); plates can still be chosen manually for clips.
- [ ] **No** `video/assets/moment_clips/` tree yet — expected; clips are optional for first render.

---

### 2. Generate next (Ivan — stills / environment plates) — mostly DONE 2026-07-18

Reusable village plates for Day-1 stamps + future social scenes. Inventory is **0 TODO** interiors.

| Priority | Asset | Status | Paths |
|:--------:|-------|:------:|-------|
| **P0** | Willows Market & Pharmacy interiors | ✅ | `willows_pharmacy_int_counter.png`, `willows_market_int_aisle.png` |
| **P0** | Oak Hill College classroom | ✅ | `college_int_classroom.png` |
| **P1** | Oak Hill College exterior | [ ] optional | Not on disk (library exterior ≠ college) |
| **P1** | Willows exterior | [ ] optional | Not on disk |
| **P2** | Pub · supply · apt/house/artist remaining rooms · Johnson Park outdoor | ✅ | `pub_int.png`, `supply_int.png`, apt/house/artist plates, `johnson_park_exterior_wide.png` |

**Acceptance for #2:** Named stills under `video/assets/village/{interior,exterior}/` with clear filenames; Phaser layout refs under `phaser/_moodboard/`. **Met for all interior TODOs + Johnson Park outdoor (2026-07-18).**

---

### 3. Custom per day / cast (after #2) — moment clips + prompt kit

**What these are:** short **1–2s**, 9:16 cinematic beats (Grok Imagine or hand-made) dropped into  
`video/assets/moment_clips/20260713-1/2/beat_<scene_id>.mp4`  
Rule of thumb: **1–3 clips max** (establishing stamps stay portrait cards).

**Recommended clip slots for this locked VO**

| Clip | Scene | Story moment | Who is on camera | Place plate (after #2) | Character refs (ready now) |
|------|------:|--------------|------------------|------------------------|----------------------------|
| A | 6 | Irene wins Hold for the Shield | Irene (+ optional group) | Dorm common *or* challenge gather space | Irene hero + sketch |
| B | 7 | Ivan reading faces / Vince–Irene talk | Ivan; or Vince+Irene | Dorm common / cafe / Willows (pick one truth) | Heroes for people in frame |
| C | 8 | Votes scatter — Ivan goes home | Ivan (+ Irene if ballot beat) | Dorm common (vote night) | Ivan hero; Irene if needed |

**Resources that are already handy for the prompt (when #2 is done)**

| Input | Source |
|-------|--------|
| Scene action / VO line | `script.json` `narrator_lines` + `VO_LOCKED.md` |
| Who / UUID | `cast_reference.md` + hero/portrait/sketch paths above |
| Place still | Village plates (Willows / Oak Hill classroom / cafe / dorm / etc. now on disk) |
| Facts (winner, boot, messy six) | `fact_ledger.json` |
| Blend grammar | `daily/daily-2D-3D-blend.md` (dive in / fracture out; silent clips; 1–3/day) |
| Drop-in path | `build_day_remotion_props.py` → `moment_clips/<sim>/<day>/beat_<id>.mp4` |

**Generalized recipe (every future daily)**

1. From featured + ledger, pick ≤3 arc beats that change power (challenge outcome, betrayal/hunt, vote/farewell).  
2. For each: **place plate** + **Double photo(s)** + **one plain action sentence** from the VO.  
3. Generate 1–2s 9:16 clip → save as `beat_<scene_id>.mp4`.  
4. Re-run Remotion props/render only (do **not** regenerate locked VO).  
5. Verify: clip plays on the right beat, continuity vs portrait, no audio fight with VO.

**#2 plates are on disk** — confirm Willows + Oak Hill classroom paths, then generate clips A–C and do the first Remotion watch pass.

---

### Tomorrow order of work (suggested)

1. [x] Generate **Willows pharmacy interior** (+ optional exterior still open).  
2. [x] Generate **Oak Hill classroom** (+ optional exterior still open).  
3. [x] Village interior baseline fill (pub, supply, houses, artist studios) + **Johnson Park outdoor**.  
4. [ ] (Optional) Fill `location` on scenes 3–8 in script / props path.  
5. [ ] First Remotion render **without** moment clips (portraits + existing plates only) — baseline watch.  
6. [ ] Generate moment clips A–C → drop in → re-render → compare.  
7. [ ] Only after picture + Anya VO OK: `lock_day_script`.

---

# Daily Trailers — primary work doc

**Updated:** 2026-07-18  
**This file is the primary checklist for finishing [C] Survival dailies.** Contracts stay in `sot-video.md`. Older working docs listed below can move to `video/DONE/` after you skim this once.

**Live package:** `generative_agents/data/20260713-1/overview_day2&001/`  
**VO working file:** `VO_LOCKED.md` — **V3.2 clarity draft** (not yet compress-locked / TTS-locked).  
**Do not** overwrite VO / re-TTS while Anya review is open. **Do not** `lock_day_script` until picture + VO are both accepted.

---

## Now — open checklist

### Gate A — VO (Anya)

- [x] Anya + founder review V0 (2026-07-16): **not approved** — clarity / drama / challenge teach / 15-vs-3 ensemble gaps.
- [x] V1 long-form + V2 clarity revise on package (see `VO_LOCKED.md`).
- [x] Screenwriter **V3** + founder **V3.1 mid-beat** + **V3.2 day-projection stamps** on `VO_LOCKED.md`.
- [x] Eng verify Ivan vote-defense: **NONE** — “keep votes off himself” stays cut.
- [x] DEV ACK compress budget @ 1.2× / ~2.2 wps (2026-07-16).
- [x] First **Short version of Ver.3** compress draft on `VO_LOCKED.md` (~263 words / ~118s est.).
- [ ] Founder → Anya **approve short VO meaning** (then measured TTS @ 1.2×).
- [ ] If measured &gt;120s: trim non-sacred only; re-TTS; then update `script.json` + Remotion.
- [ ] Anya approves compressed spoken VO. Keep Remotion off until text+audio final.

### Gate B — Picture (you — see audit at top)

Village interior plates + Johnson Park outdoor are on disk (inventory **0 TODO**). Remaining picture work:

1. [x] P0 plates: Willows pharmacy interior · Oak Hill classroom.
2. [x] P2 village fill: pub · supply · houses/apts/artist studios · Johnson Park outdoor.
3. [ ] Optional exteriors: Willows · Oak Hill College facade.
4. [ ] Baseline Remotion render (no moment clips) → phone watch.
5. [ ] Moment clips A–C (challenge / hunt / boot) → drop-in → re-render.
6. [ ] Verify props gaps: scenes 6–9 `hero_path` resolve; optional `location` labels.

### Gate C — Lock & prove continuity

- [ ] `lock_day_script` on approved Day 1 package (writes F1 featured history + F3 scar).
- [ ] Only then generate Day 2+ overview for this sim (coverage + scars stay honest).

### Gate D — Product quality (after a green MP4)

- [ ] Owner watch: same-show-as-opener feel; cold viewer can name leads, challenge outcome, who went home, tomorrow’s question.
- [ ] Optional D1: 5-viewer comprehension gate (4/5 pass).
- [ ] Merge daily-trailer branch work to `main` when picture path is product-accepted (ff-only protocol).

### Gate E — Automate daily trailer script gen (after this Day 1 VO is script-locked)

**When:** only after Gate A compress + Anya VO OK **and** Gate C `lock_day_script` on this package — treat V3.2 → compress as the **gold specimen**, not as a one-off rewrite forever.

**Goal:** every Survival day can produce a cold-viewer-safe `[C]` VO draft without repeating the V0→V3.2 human recovery loop.

**Encode lessons from V3.2 lock (do not regress):**

| Lesson | Automation requirement |
|--------|------------------------|
| Long → approve → compress | Optional long/clarity draft mode; ship cut respects L10; never optimize TTS before meaning approve (`vo-long-then-compress`) |
| Leave timing | Same-night elim after tally — never “by morning” (`sot_survival` VOTING) |
| Ensemble | State 15 Doubles / all play + vote; simple trio intro — **no** ranking dump in VO |
| Stamps (L11) | **job + place + day-projection want** (personality × today’s dynamics); vary sentence frames; omit want if thin; **no** durable `scratch.want` required; **no** clinical `innate`; **no** `_default_want_for_role` into fact-locked want |
| Challenge teach | Kid-plain number card hold/fold → Shield = safe **tonight only** before celebrating winner |
| Behavior vs invention | Cite ledger / `day_reasoning` / digest only; eng-verify pattern for soft claims (e.g. Ivan vote-defense = NONE → never invent lobby) |
| Mid beats | Keep cafe/social talk **separate** from vote-scatter; no fused “room never settles on one plan” unless evidenced |
| Cliff | Shield spent after tonight; trust vacuum — no multi-day immunity implication |
| Fact-lock | Messy boards stay messy; no invented blocs / second winners |

**Work items (eng + COS craft):**

- [ ] **E1 — Gold package:** freeze accepted compressed VO as regression gold (`VO_LOCKED.md` / `script.json` + short “why V3.2” notes) under `agents/screenwriter` / package archive.
- [ ] **E2 — Emit day-intro fields:** day-overview packages persist `day_intro_want` (or equivalent) + `source_refs` for featured Doubles; role defaults only as non-authoritative `want_fallback` (or delete); on-disk `stamp_facts.json` matches what VO may cite.
- [ ] **E3 — Narration Writer / showrunner policy:** replace caption-card / role-fallback stamp behavior with V3.2 spine + day-projection stamp rules; bake leave-timing + Shield-tonight-only + ensemble one-liners into prompts/validators.
- [ ] **E4 — Soft-claim gate:** pipeline flags unsupported VO claims (vote-defense, alliances, clean blocs) against ledger/digest; omit or `needs-review` instead of inventing.
- [ ] **E5 — Compress assist (optional):** after meaning approve, suggest L10 cut list from “runtime debt” sacred vs cuttable tags (human still owns final cut for first N days).
- [ ] **E6 — CTO brief:** open `@cto` on `generative_agents` when Gate C green — scope E2–E4 first; E5 later.

**Out of scope for Gate E:** Remotion picture automation (Gate B / B4); `[B] day_normal`; durable soul `scratch.want` schema (not required for day-projection stamps).

### Fast-follow (do not block Gate B)

- [ ] **B4** — automate Grok Imagine moment clips (`generate_moment_clips.py`); manual drop-in is enough for first ship.
- [ ] Intra-card motion / more clips if editorial-motion stays ~3/min (gate is soft; north-star is 6–8/min for dailies).
- [ ] **[B] `day_normal`** stub — out of scope until [C] picture loop works once end-to-end.

---

## Product bar (keep in mind)

| Rule | Target |
|------|--------|
| Format | 9:16 Remotion, same show as opener |
| Runtime [C] | ~100–115s typical; hard cap **under 120s** |
| VO craft | Job+place+**day-projection want** stamps once (varied frames) → first names; kid-plain challenge teach; messy boards stay messy; same-night elim; Shield tonight-only cliff + `doubland.ai` + optional itch |
| Picture | Portraits for stamps; **1–3** silent cinematic clips on arc beats only |
| Continuity | Lock Day N before generating Day N+1 |
| Bad substrate | Never polish creatively on `20260705-or-smoke` |

**VO spine (encoded as `narration_v12`):**  
concept → survival_frame → stamp×N → challenge_teach → mid_turn → cost → cliff → cta_sim → itch?

**2D↔3D blend (summary):** establishing = 2D cards; clips only on pressure / turn / vote-class beats; camera dive in / pixel fracture out; silent clips; ≤3/day. Detail: `daily/daily-2D-3D-blend.md`.

---

## Remotion process (one pass)

1. Frozen VO + `script.json` scenes = edit list.  
2. Stage existing cast/group assets (+ new village plates from audit §2).  
3. Optional: 1–3 moment clips → `video/assets/moment_clips/<sim>/<day>/beat_<scene_id>.mp4`.  
4. Build Remotion props → render MP4 → validators → watch.  
5. Do **not** regenerate Writer VO during picture-only iterations.

---

## Commands (cheat sheet)

```bash
# VO/script only (reuse day_log; avoid --force on locked package)
python -m video.generate_trailer 20260713-1 --mode day_overview --day 2 \
  --output-dir data/20260713-1/overview_day2&001 --skip-render

# After Anya OK — picture render (no --force if script/audio already locked)
# use generate_trailer without --skip-render (or project Remotion entrypoint)

# After picture + VO accepted
python -m video.lock_day_script data/20260713-1/overview_day2&001
```

---

## Living references (do not archive)

| Doc | Role |
|-----|------|
| `video/sot-video.md` | Trailer taxonomy + laws (L8–L13, [C] duration) |
| `video/TODO_video.md` | **This file** — primary daily work |
| [`../20260820_longer_daily.md`](../20260820_longer_daily.md) | Longer daily SKU — Part I production rec (Closer tonight); Part II original inquiry |
| [`../20260821_video_loop.md`](../20260821_video_loop.md) | Agentic cold loop for dailies (incl. longer SKU): **Loop-A** project · **Loop-B** phone taste · **Loop-C** done. Not Path [A]→[E]. |
| Package `VO_LOCKED.md` / `script.json` / `fact_ledger.json` | Locked episode facts + edit spine |
| `generative_agents/video/assets/...` | Heroes, village plates, moment_clips |

## Older working docs (still under `video/` — 2026-07-16)

Canonical living paths (do **not** use a `done/video/` prefix — that folder was never created):

| Doc | Path |
|-----|------|
| 2D↔3D blend grammar | `daily/daily-2D-3D-blend.md` |
| Asset prompt catalog | `prompts.md` |
| 2026-07-10 inquiries (historical) | `daily/20260710_inquiry_*.md` |
| Day-1 VO rewrite brief | package `VO_LOCKED.md` (V0 + expert V1 notes) — supersedes missing `20260715_script*.md` stubs |

---

## DONE (compact — historical)

### Opener & shared stack
- Remotion 9:16 opener pipeline; shared `OpenerTrailer` composition; end-card `questionToUrlTakeover`.
- Cohort assets + Supabase `trailer_asset` read at render; baseline hero fallback for forks.
- Voice: `eleven_v3` warm (daily locked package @ **1.2×**; Doubland TTS fused spelling).

### Daily story engine
- Cast digest + fact ledger + narration fact gate; slim `day_log`.
- Spicy ranking + coverage slot (L12); F1 intro memory + `lock_day_script` (L11); F3 scar cards (L13).
- Challenge card in ledger + teach-vs-short; soft signals; thin-tally `safe_vo`.
- Narration Writer continuous blocks + want stamps (`day_overview_narration_v12`, `video/vo_craft.py`).
- Word-count advisory; duration backstop; workplace stamps over dorm.

### Daily Remotion plumbing
- Day props builder; beat→opener component map; SFX roles; music duck path.
- B1 moment-clip drop-in; B2 location parse/label; B3 baseline photos; B5 blend grammar doc.
- Validators: format, LUFS, narration-fit, asset-presence, editorial-motion (soft).
- Early Day-2/Day-3 renders gate-green on older packages (creative bar still owner-watch).

### Creative locks (this arc)
- Rejected caption-card auto VO on `20260713-1`; human Fact-Locked Five-Beat VO locked in package.
- Chat-probe gold VO shape (Vincent/Max/Olivia) kept as historical craft reference only — **do not** `lock_day_script` that package to seed live history.
- `20260705-or-smoke` = engineering fixture only.

### Explicitly not done (see open checklist)
- Anya VO sign-off on **V3.2** · compress · optional Willows/Oak Hill **exteriors** · moment clips · Remotion watch · `lock_day_script` · D1 comprehension · **Gate E script automation** · B4 clip automation · [B] day_normal.
- Village **interior** plate fill + Johnson Park outdoor: **DONE 2026-07-18** (inventory 57 DONE / 0 TODO).
