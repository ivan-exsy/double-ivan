# Inquiry — Longer daily trailers (keep short + long)

**Date:** 2026-08-20  
**Status:** Founder inquiry for the expert council. Formalize vision, requirements, and implementation notes. **Do not implement** until this round is accepted.  
**Audience:** `realitytv` · `screenwriter` · `videoproducer` · `engagement` · `ux` (2D↔3D / watch craft)  
**Specimen season:** simulation `20260724-2` (Soul-15 Survival). Survival Day N = engine `--day` N+1.  
**Locked decision:** we will **keep both** a short daily and a longer daily for MVP audience tests. One format may win. Both may stay. Do not silently replace short.

---

## 1. One-sentence ask

Design a **second daily SKU** — a longer Tonight’s Scar — that still feels like a fast phone video, still fact-locks to the sim, still teaches Survival without becoming a Wikipedia recap, and uses **more 2D↔3D (Phaser ↔ cinematic)** so watching Phaser feels like watching *real* events — while the current **short** daily stays the default ship.

---

## 2. Why this exists

The current auto-gen pipeline (almost) ships **neat short dailies**. That format is already doing its job: one unfinished social pressure, one Peak, one Cost, one Door to [doubland.ai](https://doubland.ai).

It is **not** doing a second job we now need:

- Share **enough of the day** that a cold viewer can **fall into the format**.
- Create **emotional attachment to particular Doubles** (not only “the Shield winner” and “the person who left”).
- Make the audience **wait for tomorrow’s trailer**.
- Make them **poke the live simulation** — follow any Double, any chat, any vote, any event — because the trailer proved those details exist and matter.

Short trailers starve that loop. If we only ever show two featured people and a one-line challenge, the village stays abstract. If we dump the whole day, we kill pace and we compete with the product (why click through if the trailer already showed everything?).

We want the **best of Reality TV craft** (character, leftover heat, alliance weather, vote reads, unfinished threads) **and** the **new grammar of fast-pace vertical video** (mute-safe hook, kinetic type, no dead air, cut on meaning). Those two traditions fight. Your job is to negotiate them into one long SKU that still ships every night.

---

## 3. Dual-SKU experiment (locked)

| SKU | Job | Runtime today (SOT) | Status |
|-----|-----|---------------------|--------|
| **Short D1** | Tonight’s Scar — unfinished pressure → return itch → one Door | Target 45–60s; warn >90s; **hard max 120s**. Day-1 gold ~88s accepted. This sim: Day 1 polish closed; Day 2 ~97s accepted; Day 3 ~62s prove | **Keep. Default ship.** |
| **Long D1** | Same night, **deeper** featured character + social weather + more of the day’s texture | SOT strawman only: warn >150s / hard **180s** until founder locks. Flag already exists as `length_mode=long` | **New editorial format.** Today the flag is mostly a **Remotion duration lane**, not a second story. |

**Experiment intent**

- Ship **both** to the MVP audience (L-Talks / early watchers).
- Measure which format (or which pairing) drives: completion, next-day return, click-through to doubland.ai, follow of a named Double, time-in-sim after the trailer.
- Fine-tune one, the other, or both. Do **not** assume long replaces short.

**What “long” is not**

- Not `[B] day_normal` (cast directory). That type stays **paused**.
- Not a full-day encyclopedia. SOT §1 already killed `concept_reset → stamps×N → full-day recap` as the **default**.
- Not CapCut as a product path. Remotion stays production; CapCut stays gold forensics.
- Not `[E]` migrate (`eng video/` → `double-video`). That stays parked.

---

## 4. What success looks like (product, not craft jargon)

After a **long** daily, a first-time watcher can:

1. Name **more than two** Doubles as people (job, place, want, or a social tell) — without the video feeling like a roster.
2. Feel **one relationship weather** (trust, leftover heat, lock-in, “the room cannot read them”) as if they were in the house.
3. Visualize **at least one beat as a real-life event** because Phaser and cinematic traded places on that beat (not a decorative flyover).
4. Want **tomorrow’s trailer** for a specific unfinished thread (not generic “someone else leaves”).
5. Know **where to go** — [doubland.ai](https://doubland.ai) — to follow that Double, that chat, that vote, that challenge, live.

After a **short** daily, they still get the current job: Peak, Cost, challenge meaning, census N→N−1, Door. Short must not get worse while we invent long.

---

## 5. Constraints that do not move

Copy these into every recommendation.

| Constraint | Why |
|------------|-----|
| **Fact-lock** | Spoken claims must match `fact_ledger.json` + picker. No invented votes, shields, or jobs. |
| **Teen dignity** | No humiliation-as-entertainment. Cost is leave/boot with respect. |
| **Personality-led challenge drama** | People attract situations; chance is seasoning. Do not frame games as RNG spectacle. |
| **Sacred later-night kit (short lane)** | Doubles opener · `{N} still in Survival mode` · Peak then Cost **job+place every later night** · catalog challenge in steps-board order · `{N} become {N−1}` · catalog Door. N = `15 −` prior boots (same math as G7 pictures). |
| **Never promote `clip_kit/imported/`** | Polish-only until Wave 2 auto-kit can make equivalents. |
| **Human bar = final MP4** | Phone-watch the master. Not Live-only, not props JSON. |
| **Do not overwrite Day 1 or Day 2 masters** on `20260724-2`. |
| **G7 census** | Identity-card grid (`CensusMatrix`). Not grey-wash. Not `imported/`. Prior boots already `DISCONNECTED`. |
| **Alliance Lock-In ≠ Shield vest** | Catalog fact. Day 3 VO already teaches this. |
| **VO lock** | Do not clobber `vo_locked.txt` unless `--replace-vo-lock`. Long SKU may need a **second** lock file — propose the name; do not reuse short lock. |

---

## 6. Current short pipeline (as of 2026-08-20)

One-liner:

**Sim (Supabase) → cast digest + fact ledger → Peak/Cost picker → lock VO → TTS if missing → picture kit (G1–G8) → Remotion `NightlySurvival` → phone-watch MP4.**

### 6.1 Nightly command (eng)

Cwd: `D:\Coding\generative_agents-ivan-dev` (clone of [ivan-exsy/generative_agents](https://github.com/ivan-exsy/generative_agents); active branch `ivan/dev`).

```text
python -m video.run_tonight_scar 20260724-2 --day <engine_day> --length-mode short
```

| Survival day | `--day` | Package |
|--------------|---------|---------|
| 1 | 2 | `data/20260724-2/trailer_ready_day2` |
| 2 | 3 | `data/20260724-2/trailer_ready_day3` |
| 3 | 4 | `data/20260724-2/trailer_ready_day4` |

`--length-mode long` already exists on that CLI. Today it stretches the **same** five-beat spine toward the 180s strawman. It does **not** yet mean “second editorial format.” Treat that gap as the design problem.

Related bake (picture + Remotion, often after scar lock):

```text
python -m video.run_nightly_survival <package> --length-mode long --force --no-auto-picture --require-picture-ready
```

(`--length-mode long` here is the **composition clock**, historically used even for the short story so picture holds can breathe. Do not confuse with the new long SKU.)

### 6.2 What already ships in short

| Stage | Module (eng) | What it does |
|-------|----------------|--------------|
| Cast-wide day brief | `video/summarize_cast_day.py` | One positions fetch → `cast_digest.md` / `.json` (writer fuel). Not a full per-persona RIR extract. |
| Per-protagonist log | `video.extract_day_log` | Optional deep log: `python -m video.extract_day_log <sim> <persona> --day N`. **Only Day 3 package currently has `day_log.json` on disk.** |
| Ledger | `video/build_fact_ledger.py` | Writer SOT: challenge, winners, named ballots, elim, census math. |
| Picker | `tonight_scar_picker.json` | Peak, Cost, Door, leftover thread. |
| VO | `video/draft_tonight_scar_vo.py` | Auto-lock when `vo_locked.txt` missing; fail-closed on wrong remaining-count; never overwrite lock unless `--replace-vo-lock`. |
| Pictures | N3 kit + `nightly_craft.py` | G1–G8 bins. G7 census stills rendered on bake from sibling `trailer_ready_day*` priors. |
| Phaser elim | `video.capture_phaser_elim` | Playwright `?recording=true` still at last in-world vote step → `F_phaser/{cost}_leave_phaser.png`. |
| Compose | `NightlySurvival` (Remotion 4.0.380) | Same composition as gold replay. Live preview in Post-Production (`double-video` / `apps/trim-board`). |
| Polish | `{package}/edit_script.json` | Timing/look. Schema SOT: eng `video/nightly_edit_script.py`. |

### 6.3 Short story grammar (do not throw away)

Fact-Locked Five-Beat Spine (screenwriter doctrine): **want → pressure → turn → cost → honest open question.**

Picture bins (SOT §10): **A hook → B stake → C pressure → D peak → E cliff+door** (+ **F Phaser** literacy). Mute hook. Census HUD `15→14→1` on Day 1 / when VO says it. Later nights: identity-card G7.

### 6.4 Path A→E (short quality bar — closed through [D])

| Step | Status |
|------|--------|
| [A] Polish Live | Accepted |
| [B] Rebuild = Live | Done |
| [C] Eng learn priors | Done (8 taught looks) |
| [D] Cold auto vs [A] on those looks | Accepted 2026-08-18 |
| [E] Migrate `video/` → `double-video` | **Do not pull** |

Short is **good enough to experiment against**. Long is a **new product lane**, not a polish pass.

### 6.5 Known short-lane limits (the problem statement)

- **Coverage queue is empty** on all three specimen nights (`satellite_ids: []`, `coverage_queue: []`). The machine is built to feature two people.
- **Later-night VO is tight** (~134–210 words). Day 3 is the tightest (~62s picture). There is little room for a third Double, a second social beat, or a confession-style tell.
- **2D↔3D is a ship gate, not a language.** SOT requires Phaser plant + one Peak/Cost dive + Door Phaser tease, and **caps cinematic punctuations at ≤3**. That was correct for short. It is **too thin** for “I am watching real life through the sim.”
- **Product teaching is end-CTA only.** `sot-video.md` already flags the tension: every daily that re-explains doubland.ai dilutes the episode; every daily that never reminds treats us as “just another reality clip.”
- **`length_mode=long` is not a script.** Stretching the same VO with slower picture is not the long SKU.

---

## 7. 2D↔3D — current vs desired

**Current (mandatory on every short D1):** [`daily-2D-3D-blend.md`](https://github.com/ivan-exsy/double-ivan/blob/main/video/daily/daily-2D-3D-blend.md) and SOT-new-daily §3.6 / §12.

| # | Gate today |
|---|------------|
| 1 | **Phaser plant** — ≥1 early beat of live sim look (top-down / sprites). Silent. |
| 2 | **Peak/Cost bridge** — ≥1 camera **dive** 2D → cinematic (prefer Cost on leave). Optional pixel fracture back. |
| 3 | **Door tease** — short Phaser under Door so destination matches the watch surface. |
| 4 | **Cap** — ≤3 silent cinematic punctuations. Namecards / census / end-card stay 2D. |
| 5 | **Fail** — all-cinematic cut (zero Phaser). |

**Desired on the long SKU (founder intent — you must specify how):**

Use **more** 2D↔3D transitions so the audience **visualizes real-life events while watching Phaser**. Phaser is not a cute game overlay. It is the **window**. Cinematic is the **felt life** on the other side of the glass. The cut should teach: *this sprite conversation is a real conversation; this vote step is a real vote.*

Please propose:

- A **transition grammar** for long (when to dive, when to fracture, when to hold Phaser under VO, when cinematic is a lie).
- Whether the **≤3 cinematic cap stays on short only**.
- How to avoid “all movie, no sim” (kills the product) and “all HUD, no life” (kills attachment).
- Shot-level examples mapped to **this sim’s Day 1–3** (Hold for the Shield / Silent Pact / Alliance Lock-In; Alexis–Vincent; Irene–Alex Butcher leftover heat; Irene–Olivia lock-in / Alex Shepard boot).

Proven CapCut pattern (different sim `20260713-1`, Day 1 V6): plant on flyover → Cost dive on `ivan_leave_phaser` → Door Phaser tease. Use as craft evidence, **not** as this sim’s names (this sim Day 1 is Alexis / Vincent, not Irene / Ivan).

---

## 8. Reality TV + fast-pace video (what to steal, what to refuse)

**Steal from Reality TV (format, not copycat shows):**

- Leftover heat (Day 2 already does this well in short: “last night he walked a tie”).
- Alliance weather you can *feel* in 10 seconds (Day 3 lock-in is the mechanic; the **relationship** is still thin).
- Vote reads that name **social reason**, not only tally.
- Recurring characters across nights (Irene returns Day 2 and Day 3 — use that; do not reset her to a job stamp every time unless the long lane needs a cold-drop primer).
- Unfinished threads that make tomorrow’s episode a **appointment**.

**Steal from current short-form (Reels / Shorts / TikTok craft, 2024–2026):**

- Hook that works **muted** in the first 1–2s.
- Cut on new information; no “and then they walked.”
- On-screen type that **adds** meaning (census, DISCONNECTED, challenge steps) — not karaoke of the VO.
- Pattern interrupt (2D↔3D is our interrupt — use it as story, not decoration).

**Refuse:**

- Confession-cam that invents inner life not in the ledger.
- Recap host explaining the app for 20s in the middle of the vote.
- Encyclopedia of all 15 (or 12) people every night.
- Stretching short VO with freeze-frames to hit 3 minutes.

---

## 9. Specimen nights — sim `20260724-2`

**Clock reminder:** Survival Day 1 = engine day 2 = package `trailer_ready_day2`.

These packages live on the **local eng clone** (usually **not** on GitHub — `data/` is gitignored). Experts with only GitHub still have locked VO, picker, and SOT below; founders / local agents have the full kit.

### 9.1 Survival Day 1 — Hold for the Shield

| | |
|--|--|
| Package | `D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day2\` |
| Peak / Cost | Alexis Reed (Shield) / Vincent Slater (boot, tie then tiebreak vs Alex Butcher) |
| Challenge | Hold for the Shield |
| Spoken lock | ~210 words · 16 lines |
| Picture bar | Closed. Polish snapshot `output/trailer_9x16_20260812_003937_e1_cold.mp4` (**filename tag `e1_cold` is wrong — it is the polish bake**). Do not overwrite. |
| `day_log.json` | **Missing on this package.** Use `cast_digest.md` + `fact_ledger.json`. Optional: regenerate via `python -m video.extract_day_log 20260724-2 "<persona>" --day 2`. |

**Locked VO (this sim — not Anya V6 names):**

> These are Doubles — AI versions of real people, making choices no one wrote for them.  
> Fifteen of them entered Survival mode: someone is voted out every night until one remains.  
> Today we are following two of them.  
> Alexis Reed is a research assistant at the Oak Hill library.  
> Alexis plays for cover before the first night's vote.  
> Vincent Slater develops curriculum in the Oak Hill classroom.  
> Vincent tracks the room — who is signaling, and who is counting votes.  
> At 11am, a daily challenge begins - "Hold for the Shield" - each Double gets a secret card: hold to stay in the fight, or fold and sit out. Highest card remaining wins the Shield — and immunity from tonight's vote.  
> Alexis got the highest card. She wins the Shield and is safe tonight.  
> As the day continues, conversations turn into alliances. Alliances turn into votes.  
> At the end of the day, every Double casts a ballot.  
> Tonight, Vincent Slater and Alex Butcher tie at three votes each. After the tiebreak, Vincent is gone.  
> Just like that, fifteen become fourteen.  
> Tomorrow, the Shield is gone. New alliances will form. New targets will emerge.  
> And another Double will leave the game.  
> Watch every conversation, challenge, and vote live at doubland.ai.

**Open question (picker):** Who does the room trust after Vincent Slater went home?

### 9.2 Survival Day 2 — Silent Pact + leftover heat

| | |
|--|--|
| Package | `D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day3\` |
| Peak / Cost | Irene Dove (stronger vote, **not** a Shield) / Alex Butcher (5.5 votes) |
| Challenge | Silent Pact |
| Spoken lock | ~192 words |
| Picture bar | Founder “Perfect!” wave22 ~97s. Master `output/trailer_9x16.mp4`. Archive `*_20260820_161636_wave22.mp4`. Do not overwrite. |
| `day_log.json` | **Missing.** Same fallback as Day 1 (`cast_digest.md`, `--day 3`). |

**Locked VO:**

> These are Doubles — AI versions of real people, making choices no one wrote for them.  
> Fourteen still in Survival mode. Someone is voted out every night.  
> Irene Dove is a barista at Hobbs Cafe.  
> Irene wants a read she can trust before she commits.  
> Alex Butcher is a logistics coordinator at Harvey Oak Supply Store.  
> Alex is hard to pin down — last night he walked a tie.  
> Tonight's game is Silent Pact. Secretly paired. You do not see their pick. Protect or Expose. Both Protect — luck gives one of you a stronger vote. Only you Expose — you can win a Shield you can give away. Both Expose — you are both weaker.  
> Irene and her partner both Protect. Luck gives Irene the stronger vote. Not a Shield — her ballot just counts more.  
> Tonight the vote splits. Five people name Alex. They cannot read where he stands. Irene's stronger ballot is one of them. Alex is gone.  
> Fourteen become thirteen.  
> Last night he walked a tie. Tonight the leftover name went home. Who actually has the room now?  
> Watch every conversation, challenge, and vote live at doubland.ai.

**Unfinished thread (picker):** Last night Alex walked a tie with Vincent. Tonight the room still could not read him.

This is the **best short-lane proof** that leftover heat works. Long should **expand** this class of beat (more of *why* the room cannot read someone; one more named alliance or chat) without turning Day 2 into a Day-1 rules dump.

### 9.3 Survival Day 3 — Alliance Lock-In

| | |
|--|--|
| Package | `D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day4\` |
| Peak / Cost | Irene Dove (mutual lock with Olivia, double vote) / Alex Shepard (4 votes) |
| Challenge | Alliance Lock-In — **no Shield vest** |
| Spoken lock | ~134 words (tightest) |
| Picture bar | wave25 ~61.6s. Master `output/trailer_9x16.mp4`. Census **13→12** (Vincent + Alex Butcher already DISCONNECTED, then Shepard). Phaser elim on disk. |
| `day_log.json` | **Present** (`day_log.json`, ~248 KB). Also `cast_digest.md`. |

**Locked VO:**

> These are Doubles — AI versions of real people, making choices no one wrote for them.  
> Thirteen still in Survival mode. Someone is voted out every night.  
> Irene Dove is a barista at the Hobbs Cafe.  
> Alex Shepard is an archivist at the Oak Hill library.  
> Tonight's game is Alliance Lock-In.  
> Pick one person to lock with.  
> If they pick you back, you both double your vote tonight.  
> If not — everyone sees you got left hanging.  
> There is no Shield vest.  
> Irene locks with Olivia. Mutual. Both ballots count as two tonight.  
> That's the challenge. Then the vote.  
> Tonight the vote splits. Four people name Alex Shepard. Alex is gone.  
> Thirteen become twelve.  
> Who does the room trust after Alex Shepard went home?  
> Watch every conversation, challenge, and vote live at doubland.ai.

**Coverage gap for long:** Olivia is **spoken as a lock partner** but never stamped as a person. Shepard is Cost with job+place but little social weather. Irene is Peak **again** (Day 2 and Day 3) — long should decide how returnees work vs first features.

### 9.4 Package files to open (all three nights)

On each `trailer_ready_day{2,3,4}`:

| File | Role |
|------|------|
| `vo_locked.txt` | Spoken gold for **short** |
| `script.json` | Showrunner / beat script |
| `fact_ledger.json` | Writer SOT |
| `tonight_scar_picker.json` | Peak / Cost / Door / leftover |
| `scar.json` | Locked thesis |
| `cast_digest.md` + `cast_digest.json` | Cast-wide day log (human) |
| `cast_ranking.json` | Ranker output |
| `edit_script.json` | Picture timing (Post-Production) |
| `clip_kit/` | Bins A–F, Phaser, census stills |
| `output/trailer_9x16.mp4` | Phone-watch master |
| `day_log.json` | **Day 3 only** today |

### 9.5 Survival Day 4 — not a trailer yet

Season still running (12 remaining as of 2026-08-20 inquiry). **No** `trailer_ready_day5`. Do not invent a Day-4 Scar. Use Days 1–3 only as specimens.

---

## 10. Gold forensics (different sim — craft only)

Anya CapCut Survival Day 1 is sim **`20260713-1`**, Peak **Irene Dove**, Cost **Ivan Pitts**, ~**88.2s**. That VO lives in [`VO_LOCKED.md`](https://github.com/ivan-exsy/double-ivan/blob/main/video/daily/VO_LOCKED.md) §V6. **Do not copy those names onto `20260724-2`.**

Use gold for: kinetic type density, 2D↔3D plant/dive/door, mute hook, challenge teach length, end lockup.

Hub: [`GOLD.md`](https://github.com/ivan-exsy/double-ivan/blob/main/video/daily/gold/20260713-1_day1_anya/GOLD.md).

---

## 11. Product Door we must not forget

Public promise (landing + `sot-video.md` open questions):

- Watch live 24/7  
- Follow any Double  
- Replay / zoom any event  
- Chat with any Double  
- Create your Double + invite your group  

Trailers today mostly **end-CTA** this. Long dailies will be tempted to **mid-story teach** the product. That can save cold viewers or kill drama. **engagement** owns the experiment design; **screenwriter** owns whether a line earns its seconds; **ux** owns whether a Phaser beat already *is* the teaching.

Live ship snapshot for landing (beats versioned docs when they disagree): `D:\Coding\double-ivan\20260721_ux_landing_todays_implementation.md` (if present in workspace) plus [landing outline](https://github.com/ivan-exsy/double-docs/blob/main/landing/0.landing-page.md).

---

## 12. Questions by specialist

Answer in your normal output format. Cite SOT / raw KB. Flag `needs-review` when evidence is missing.

### `realitytv` (format — Burnett / de Mol / Parsons)

1. For a **long** daily, what is the **repeatable sequence** every night (the “shape”) so week 2 is still the same show?
2. How many featured Doubles is the **maximum** before the format becomes a directory? How do returnees vs first features work?
3. Where do **confession / leftover / alliance table / vote read** sit vs challenge teach vs census?
4. What must stay **only in the live sim** (never in the trailer) so the Door still has a job?
5. Dual-SKU: is long a **superset** of short, a **sibling cut** from the same ledger, or a **different night job** (e.g. character episode vs boot episode)?

### `screenwriter`

1. Draft the **spoken contract** for long (not a full VO yet unless you can do Day 2 as a specimen rewrite). How does the Five-Beat Spine stretch without becoming an encyclopedia?
2. What is **sacred** vs **flexible** vs **short-only** in the later-night kit?
3. How do we stamp a **third** person (Olivia on Day 3; Alex Butcher on Day 1 tie) without two cold openers?
4. Propose a **second lock filename** (`vo_locked_long.txt` or similar) and fail-closed facts unique to long.

### `videoproducer`

1. Shot-level **2D↔3D grammar** for long (more transitions). Map to Days 1–3 specimens.
2. Pace: how does a 2–3 minute vertical still feel **fast**?
3. What picture kit **adds** (G-bins, Phaser captures, chat plates, alliance stills) vs what short already has?
4. Fail states: all-cinematic; freeze-to-fill; imported media; grey-wash census.

### `engagement`

1. Dual-SKU **experiment**: what we ship where, what we measure, what would make us kill long or kill short.
2. Trailer → doubland.ai **core loop**: which mid-body vs end-CTA product reminders belong on long vs short.
3. Appointment viewing: what unfinished thread types actually pull **next day** vs vanity metrics.
4. Teen / adult-MVP guardrails: no dark-pattern “watch or you’ll miss your friend forever.”

### `ux`

1. When Phaser is on screen, what must be **readable in 9:16** so it reads as “live world” not “minimap”?
2. How should 2D↔3D support **follow this Double** without a UI lecture?
3. Watch UX: short vs long on the same landing / Telegram drop — labels, default autoplay, “full recap” vs “tonight’s scar.”

---

## 13. Deliverables we need back

One coordinated packet (COS can merge). Include:

1. **Vision** — one page: what the long daily *is* in the Doubland show bible.
2. **Requirements** — must / should / must-not. Separate **short** vs **long**. Explicit runtime recommendation (replace or keep the 150/180 strawman).
3. **Editorial spec** — beat sheet for long (hook → … → Door) with time boxes.
4. **2D↔3D spec** — grammar + whether short keeps ≤3 cinematic cap.
5. **Implementation notes for eng** (not code): new files, picker fields (`satellite_ids`, `coverage_queue`), VO lock, picture jobs, validators, how `length_mode=long` should change meaning.
6. **Specimen rewrite (optional but high value):** Day 2 **or** Day 3 as a long spoken outline + picture beat list, fact-locked to that night’s ledger. Prefer Day 2 (leftover heat already works).
7. **MVP experiment plan** — how we run both SKUs for L-Talks without confusing the audience.

---

## 14. Out of scope for this inquiry

- Baking / re-TTS / overwriting Day 1–2 masters.
- Inventing Survival Day 4.
- Migrating `video/` to `double-video` ([E]).
- Reopening `[B] day_normal` as the long SKU.
- Impersonating Anya / Natasha / Vadik. Use COS specialists.

---

## 15. Reference appendix — full links

Use **GitHub** when the file is tracked. Use **local Windows paths** for packages and anything gitignored. `file:///` links work in a local browser.

### 15.1 This inquiry

- Local: `D:\Coding\double-ivan\20260820_longer_daily.md`
- GitHub (after commit): [https://github.com/ivan-exsy/double-ivan/blob/main/20260820_longer_daily.md](https://github.com/ivan-exsy/double-ivan/blob/main/20260820_longer_daily.md)

### 15.2 Video SOT and production notes (`double-ivan`)

| Doc | GitHub | Local |
|-----|--------|-------|
| Video taxonomy [A]/[B]/[C] | [sot-video.md](https://github.com/ivan-exsy/double-ivan/blob/main/video/sot-video.md) | `D:\Coding\double-ivan\video\sot-video.md` |
| Daily SOT (Tonight’s Scar) | [SOT-new-daily.md](https://github.com/ivan-exsy/double-ivan/blob/main/video/daily/SOT-new-daily.md) | `D:\Coding\double-ivan\video\daily\SOT-new-daily.md` |
| 2D↔3D blend | [daily-2D-3D-blend.md](https://github.com/ivan-exsy/double-ivan/blob/main/video/daily/daily-2D-3D-blend.md) | `D:\Coding\double-ivan\video\daily\daily-2D-3D-blend.md` |
| Anya V6 VO lock (`20260713-1`) | [VO_LOCKED.md](https://github.com/ivan-exsy/double-ivan/blob/main/video/daily/VO_LOCKED.md) | `D:\Coding\double-ivan\video\daily\VO_LOCKED.md` |
| North-star TODO / Wave log | [TODO_video.md](https://github.com/ivan-exsy/double-ivan/blob/main/video/TODO_video.md) | `D:\Coding\double-ivan\video\TODO_video.md` |
| Gold hub | [GOLD.md](https://github.com/ivan-exsy/double-ivan/blob/main/video/daily/gold/20260713-1_day1_anya/GOLD.md) | `D:\Coding\double-ivan\video\daily\gold\20260713-1_day1_anya\GOLD.md` |
| Gold paths | [CANONICAL_PATHS.md](https://github.com/ivan-exsy/double-ivan/blob/main/video/daily/gold/20260713-1_day1_anya/CANONICAL_PATHS.md) | `D:\Coding\double-ivan\video\daily\gold\20260713-1_day1_anya\CANONICAL_PATHS.md` |
| CapCut breakdown | [capcut_project_breakdown.md](https://github.com/ivan-exsy/double-ivan/blob/main/video/daily/gold/20260713-1_day1_anya/capcut_project_breakdown.md) | `D:\Coding\double-ivan\video\daily\gold\20260713-1_day1_anya\capcut_project_breakdown.md` |
| Beat map | [gold_beat_map.md](https://github.com/ivan-exsy/double-ivan/blob/main/video/daily/gold/20260713-1_day1_anya/gold_beat_map.md) | `D:\Coding\double-ivan\video\daily\gold\20260713-1_day1_anya\gold_beat_map.md` |
| Daily SOT history | [archive/SOT-new-daily-history.md](https://github.com/ivan-exsy/double-ivan/blob/main/video/daily/archive/SOT-new-daily-history.md) | `D:\Coding\double-ivan\video\daily\archive\SOT-new-daily-history.md` |
| CapCut vs Post-Prod brief | [20260811_capcut-vs-post-prod.md](https://github.com/ivan-exsy/double-ivan/blob/main/20260811_capcut-vs-post-prod.md) | `D:\Coding\double-ivan\20260811_capcut-vs-post-prod.md` |

**SOT sections to read first:** `SOT-new-daily.md` §1 Intent · §2 length table (short vs long strawman) · §3.6 2D↔3D · §8 picker · §9 VO · §10 bins G1–G8 · §11.4 auto-gen · §12 validators. `sot-video.md` “Open questions for expert review” (product teaching vs episode).

### 15.3 Concept / mission

| Doc | GitHub | Local |
|-----|--------|-------|
| Concept map | [concept/index.md](https://github.com/ivan-exsy/double-ivan/blob/main/concept/index.md) | `D:\Coding\double-ivan\concept\index.md` |
| Mission | [mission.md](https://github.com/ivan-exsy/double-ivan/blob/main/concept/mission.md) | `D:\Coding\double-ivan\concept\mission.md` |
| North star | [vision/north-star.md](https://github.com/ivan-exsy/double-ivan/blob/main/concept/vision/north-star.md) | `D:\Coding\double-ivan\concept\vision\north-star.md` |

### 15.4 Engineering SOT (`double-docs`)

| Doc | GitHub | Local |
|-----|--------|-------|
| SOT index | [sot/index.md](https://github.com/ivan-exsy/double-docs/blob/main/sot/index.md) | `D:\Coding\double-docs\sot\index.md` |
| Survival runtime | [sot_survival.md](https://github.com/ivan-exsy/double-docs/blob/main/sot/sot_survival.md) | `D:\Coding\double-docs\sot\sot_survival.md` |
| Challenge catalog | [sot_challenges.md](https://github.com/ivan-exsy/double-docs/blob/main/sot/sot_challenges.md) | `D:\Coding\double-docs\sot\sot_challenges.md` |
| Landing outline | [0.landing-page.md](https://github.com/ivan-exsy/double-docs/blob/main/landing/0.landing-page.md) | `D:\Coding\double-docs\landing\0.landing-page.md` |
| Eng worklog | [WORKLOG.md](https://github.com/ivan-exsy/double-docs/blob/main/WORKLOG.md) | `D:\Coding\double-docs\WORKLOG.md` |

### 15.5 Eng pipeline (`generative_agents`)

Repo: [https://github.com/ivan-exsy/generative_agents](https://github.com/ivan-exsy/generative_agents)  
Local clone: `D:\Coding\generative_agents-ivan-dev` (branch `ivan/dev`).

| Module | GitHub (main; confirm on `ivan/dev` if missing) | Local |
|--------|--------------------------------------------------|-------|
| Tonight’s Scar runner | [run_tonight_scar.py](https://github.com/ivan-exsy/generative_agents/blob/main/video/run_tonight_scar.py) | `D:\Coding\generative_agents-ivan-dev\video\run_tonight_scar.py` |
| VO draft + census gate | [draft_tonight_scar_vo.py](https://github.com/ivan-exsy/generative_agents/blob/main/video/draft_tonight_scar_vo.py) | `D:\Coding\generative_agents-ivan-dev\video\draft_tonight_scar_vo.py` |
| Nightly bake | [run_nightly_survival.py](https://github.com/ivan-exsy/generative_agents/blob/main/video/run_nightly_survival.py) | `D:\Coding\generative_agents-ivan-dev\video\run_nightly_survival.py` |
| Craft / G7 | [nightly_craft.py](https://github.com/ivan-exsy/generative_agents/blob/main/video/nightly_craft.py) | `D:\Coding\generative_agents-ivan-dev\video\nightly_craft.py` |
| Fact ledger | [build_fact_ledger.py](https://github.com/ivan-exsy/generative_agents/blob/main/video/build_fact_ledger.py) | `D:\Coding\generative_agents-ivan-dev\video\build_fact_ledger.py` |
| Cast digest | [summarize_cast_day.py](https://github.com/ivan-exsy/generative_agents/blob/main/video/summarize_cast_day.py) | `D:\Coding\generative_agents-ivan-dev\video\summarize_cast_day.py` |
| Day log extract | [extract_day_log.py](https://github.com/ivan-exsy/generative_agents/blob/main/video/extract_day_log.py) | `D:\Coding\generative_agents-ivan-dev\video\extract_day_log.py` |
| Phaser elim capture | [capture_phaser_elim.py](https://github.com/ivan-exsy/generative_agents/blob/main/video/capture_phaser_elim.py) | `D:\Coding\generative_agents-ivan-dev\video\capture_phaser_elim.py` |
| Agent memory (video learnings) | [AGENTS.md](https://github.com/ivan-exsy/generative_agents/blob/main/AGENTS.md) | `D:\Coding\generative_agents-ivan-dev\AGENTS.md` |

**Local packages (gitignored — not on GitHub):**

```
D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day2\
D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day3\
D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day4\
```

**Day logs:** there is **no** `overview_day*` dump for this sim on disk. Human day coverage = `cast_digest.md`. Machine day coverage = `fact_ledger.json`. Deep per-persona = `extract_day_log` (Day 3 already materialized as `trailer_ready_day4\day_log.json`). Season state is Supabase RPC `load_survival_season_state` (`p_sim_name`: `20260724-2`), not a markdown file.

Gold CapCut master (other sim):  
`D:\Coding\generative_agents-ivan-dev\data\20260713-1\trailer_ready_day2\clip_kit\bins\video\0720(1).mp4`

### 15.6 Post-Production (`double-video`)

| Doc | GitHub | Local |
|-----|--------|-------|
| PRD (CapCut map §21 · migrate §22) | [prd.md](https://github.com/ivan-exsy/double-video/blob/main/prd.md) | `D:\Coding\double-video\prd.md` |
| Agent notes | [AGENTS.md](https://github.com/ivan-exsy/double-video/blob/main/AGENTS.md) | `D:\Coding\double-video\AGENTS.md` |

UI: `D:\Coding\double-video\apps\trim-board\` (product name Post-Production). Live preview overlays `edit_script.json` onto nightly props.

### 15.7 COS specialists (how to answer)

Repo: [https://github.com/ivan-exsy/cos](https://github.com/ivan-exsy/cos)  
Local: `D:\Coding\COS`

| Specialist | Agent brief | Local |
|------------|-------------|-------|
| Reality TV | [agents/realitytv/agent.md](https://github.com/ivan-exsy/cos/blob/main/agents/realitytv/agent.md) | `D:\Coding\COS\agents\realitytv\agent.md` |
| Screenwriter | [agents/screenwriter/agent.md](https://github.com/ivan-exsy/cos/blob/main/agents/screenwriter/agent.md) | `D:\Coding\COS\agents\screenwriter\agent.md` |
| Video producer | [agents/videoproducer/agent.md](https://github.com/ivan-exsy/cos/blob/main/agents/videoproducer/agent.md) | `D:\Coding\COS\agents\videoproducer\agent.md` |
| Engagement | [agents/engagement/agent.md](https://github.com/ivan-exsy/cos/blob/main/agents/engagement/agent.md) | `D:\Coding\COS\agents\engagement\agent.md` |
| UX | [agents/ux/agent.md](https://github.com/ivan-exsy/cos/blob/main/agents/ux/agent.md) | `D:\Coding\COS\agents\ux\agent.md` |
| Project context registry | [config/project_context.md](https://github.com/ivan-exsy/cos/blob/main/config/project_context.md) | `D:\Coding\COS\config\project_context.md` |

**Default chain for `[C] day_survival`:** `realitytv` (format open) → `screenwriter` → `engagement` → `videoproducer` → `ux` (2D↔3D / watch). Do not skip engagement on this inquiry — dual-SKU is a retention experiment.

### 15.8 Product URL

- [https://doubland.ai](https://doubland.ai)

---

## 16. Suggested first read order (experts)

1. This file (§1–§5, §9 specimens).  
2. [SOT-new-daily.md](https://github.com/ivan-exsy/double-ivan/blob/main/video/daily/SOT-new-daily.md) §1, §2, §3.6, §9, §11.4.  
3. [daily-2D-3D-blend.md](https://github.com/ivan-exsy/double-ivan/blob/main/video/daily/daily-2D-3D-blend.md).  
4. [sot-video.md](https://github.com/ivan-exsy/double-ivan/blob/main/video/sot-video.md) open questions (product teaching).  
5. Night packages: `vo_locked.txt` + `fact_ledger.json` + `cast_digest.md` (and Day 3 `day_log.json`).  
6. Phone-watch MP4s if local.  
7. Then specialist KB + this inquiry’s question list.

---

*End of inquiry. Reply with the packet in §13. Founder keeps short as default until the experiment says otherwise.*
