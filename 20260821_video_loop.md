# Eng ↔ production loop — notes and recommendations

**Date:** 2026-08-21  
**Status:** Working notes. Not SOT yet. Not an implement ticket.  
**Ask:** Can we formalize gates **A** (Post-Production project) and **B** (full-video taste) for a loop that sends fails back to **engineering**, and calls **C** only when both pass?

---

## Direct answer

**Yes for Gate A (v1).** We have enough from SOT validators, kit/VO/picture locks, Wave 1.5–1.13 fails, and Post-Production Live behavior to write a fail/pass list a production agent can run **without** inventing taste.

**Loop-B v1 is now a format gate** (RealityTV council, COS `2026-08-21-001`): **Scar Episode Quiz (7 questions, written before the ledger) + 10 closed show fails (HF1–HF10).** Production may not mint an 11th fail mid-loop. Craft / file bugs stay in Loop-A. Untaught looks still need a founder veto (`untaught`).

**Recommendation:** Loop-A v1 and Loop-B v1 stay as written. Day 3 Loop-C is **done** (wave29). Next prove = next night or a new sim, same cold CLI — do not overwrite Day 1–3.

---

## Name collision (read this first)

`TODO_video.md` already uses **Path [A]→[E]** for a *different* program:

| Path letter | Meaning (existing, closed through [D]) |
|-------------|----------------------------------------|
| Path **[A]** | Founder **polish** in Post-Production until Live is phone-OK |
| Path **[B]** | Rebuild MP4 matches Live |
| Path **[C]** | Eng **learn** polish → recipe priors |
| Path **[D]** | Cold auto vs that bar (eight taught looks only) |
| Path **[E]** | Migrate `video/` → `double-video` (parked) |

This new loop is **not** Path A–E. Path A was “polish until it looks good.” This loop is “**cold auto must pass**; production files bugs; eng fixes the generator.”

Use these names in tickets:

| This loop | Job |
|-----------|-----|
| **Loop-A — Project** | Assess the **auto-gen package in Post-Production** (Live + kit + VO/ledger). Fail → eng. |
| **Loop-B — Taste** | Watch the **full MP4** (phone). Fail → eng. |
| **Loop-C — Done** | Same bake passes A and B. Stop. Snapshot. Do not keep polishing. |

Do not say “send it back to A” in chat without saying **Loop-A** or **Path A**.

---

## What this loop is for

**In scope (v1):** short Tonight’s Scar auto-gen on sim `20260724-2` (and later nights of the same recipe). Package in Post-Production → production agent → eng ticket → new cold bake → re-enter Loop-A.

**Out of scope until the longer-SKU packet is accepted:** dual-format long daily (`20260820_longer_daily.md` / COS `2026-08-20-003`). Same loop *shape* can apply later; Gate B runtime and 2D↔3D caps will differ.

**Production does not fix by polishing `edit_script.json` as the win condition.** A Live-only polish that never becomes a recipe/gate is Path A, not this loop. Production may **annotate** (markers, timestamps, stills). Engineering owns the change so night N+1 is clean without a human editor.

**Human bar stays the final MP4.** Live is the Loop-A instrument. Phone MP4 is the Loop-B instrument. If they disagree, Loop-B wins and eng must explain Live↔Rebuild drift (historical Path B — already supposed to be done).

---

## Do we have enough information?

### Loop-A — enough to formalize v1

Evidence we can cite without a new research pass:

- Daily SOT validators (`SOT-new-daily.md` §12) + 2D↔3D (`daily-2D-3D-blend.md`).
- Eng `validate_nightly_survival` / `validate_clip_kit` (fact-lock, VO-lock, bins, literacy *roles*, length bands, picture READY). **Known hole:** report green misses long freezes, black holes, wrong-cast Phaser, wrong plate under VO (`20260811_capcut-vs-post-prod.md`).
- Locked picture/VO laws from Waves 1.8–1.13 (G3 card backs, G7 identity cards, census HUD vs bowl, Phaser elim this-sim, job+place every later night, habitat = this Double’s job, no `imported/` in cold, scar windows = first contiguous teach, Day-1 HUD only when VO says it).
- Post-Production: missing-media banner, Live overlay of `edit_script`, kit rail, role/overlap warnings.

Loop-A is **contract compliance in the editor**, including “does this picture belong under this spoken line?” That last item is why Wave 24 failed and why A is not “validators only.”

### Loop-B — formalized (RealityTV, 2026-08-21)

Council lock: `D:\Coding\COS\tasks\2026-08-21-001\final.md` ([RealityTV](aa1a1602-1dd2-412b-96fd-63b8e0582577)).

**v1 rule:** Loop-B fails only on quiz miss or **HF1–HF10**. Not a growing craft list. `untaught` ≠ fail until founder confirms a new law.

Still residual (not this gate): freeze budget, kinetic type as a number. Day 3 master is **named:** `trailer_ready_day4/output/trailer_9x16.mp4` (wave29; archive `*_20260821_111828_wave29.mp4`).

---

## Recommended Loop-A — Project (v1)

**Where:** Post-Production, package open, **Live** on, wall clock. Scrub allowed. Full 1× watch **not** required.

**Inputs:** `vo_locked.txt`, `fact_ledger.json`, `tonight_scar_picker.json`, `edit_script.json`, `clip_kit/`, Live player, `output/nightly_run_report.json` (advisory only).

**Pass:** zero **hard** fails below. Soft notes may ride along but do not block Loop-B.

### A0 — Package identity

| # | Hard fail if |
|---|--------------|
| A0.1 | Wrong sim / wrong `trailer_ready_day*` for the Survival night under review |
| A0.2 | `vo_locked.txt` missing, or audio missing |
| A0.3 | Picker Peak/Cost ≠ ledger Peak/Cost ≠ spoken names |
| A0.4 | Bake used `clip_kit/imported/` as a **cold** src (polish shelf is OK only if this loop is explicitly a polish package — default: **not OK**) |

### A1 — Spoken kit (machine-checkable)

| # | Hard fail if |
|---|--------------|
| A1.1 | Later night: remaining-count ≠ `15 −` prior boots (same as G7), or “fourteen remain” when N is not 14 |
| A1.2 | Later night: `{Name} is back.` instead of Peak then Cost **job+place** |
| A1.3 | Challenge name / steps-board order / “no Shield vest” (Alliance Lock-In) contradicts catalog + ledger |
| A1.4 | Door missing or not doubland.ai / shipped link |

### A2 — Picture under VO (the Wave 24 class)

| # | Hard fail if |
|---|--------------|
| A2.1 | Habitat / namecard / peak plate is the **other** featured Double while VO names this one |
| A2.2 | Intro plates still running after stake into pressure/peak/cost (scar window not first contiguous run) |
| A2.3 | Challenge **teach** has no challenge clip / table / steps board covering the teach VO |
| A2.4 | Day-1 census HUD (`15→14→1`) playing on a later night whose VO does not say that countdown |
| A2.5 | G7 is grey-wash, `imported/`, or a **previous night’s** mock still; prior boots not already `DISCONNECTED`; tonight’s Cost not the tile that changes; count ≠ spoken N→N−1 |
| A2.6 | Hook “until one remains” is ballots-in-bowl instead of `census_15_to_1` when that beat is in the VO |
| A2.7 | G3 teach shows **phone-readable ranks**; Peak does not own the winning numeral |
| A2.8 | Habitat plate is a generic famous room, not this Double’s **job** interior (fail closed if job/place set and plate missing) |
| A2.9 | Phaser elim still is another sim’s Cost (e.g. Anya Ivan) or a flyover plug when a this-sim `F_phaser/{cost}_leave_phaser` capture was required |

### A3 — Literacy assets (presence, not beauty)

| # | Hard fail if |
|---|--------------|
| A3.1 | No Phaser plant layer / F_phaser plant media |
| A3.2 | No Peak/Cost cinematic bridge layer |
| A3.3 | No Door Phaser tease / lockup |
| A3.4 | Live missing-media for a cut that is on-screen in the body |

### A4 — Live vs bake honesty

| # | Hard fail if |
|---|--------------|
| A4.1 | Live black hole / empty layer in a spoken window |
| A4.2 | Soft-miss media that the recipe claimed to resolve |
| A4.3 | `nightly_run_report` green used as a substitute for this list (report is **not** a pass) |

**Loop-A does not fail on:** short cafe/win loops (Wave 2), 3.5s vs 3.6s want_cost, “slight preference” DOUBLAND.AI vs flyover, music duck “good enough” ([D] closed).

---

## Recommended Loop-B — Taste (v1) — Scar Episode Gate

**Authority:** RealityTV council, COS task `2026-08-21-001` (`final.md`). Full debate lives there. This section is the **operating gate**.

**Owns:** after one watch, is the daily a Survival *episode*? Peak turn, Cost landing, unfinished appointment, social weather when the ledger has it.

**Does not own:** freeze seconds, Ken Burns, `imported/`, wrong habitat file, validator green, kinetic type as a number, Remotion files on disk (Loop-A). Weak-but-present Phaser plant is not a Loop-B fail.

**Pass:** 7/7 quiz (Q6b skip only if ledger has no weather fact) **and** no HF1–HF10.

### Watch protocol

1. Final **MP4** only (named snapshot). Phone 9:16. **1×**, start through Door.
2. Write all 7 answers **before** opening ledger / `vo_locked.txt`.
3. Then score HFs. Unlisted complaint → `untaught`, not a fail.
4. Plate/VO *wrong facts* → Loop-A. Facts true but unreadable → Loop-B.

### Cold quiz (7)

| # | Ask | Pass |
|---|-----|------|
| **Q1** | Peak? Cost? One Door lead? | Both named; one clear Cost/lead |
| **Q2** | What did Cost **do/want tonight** (not job bio)? | Concrete tonight-behavior; skip only if no why-tonight in ledger |
| **Q3** | What did the challenge **do tonight** (not only its name)? | Shield = safe from **tonight’s** vote; Silent Pact Peak = **stronger vote** not a vest; Alliance Lock-In = **no vest**, mutual = **double vote** |
| **Q4** | Peak’s **turn**? | Share-turn stated |
| **Q5** | Who left? Dignified? | Name the boot; no humiliation joke |
| **Q6** | Tomorrow’s unfinished question? **Q6b** leftover heat / lock-in / “room cannot read them” in ≤12 words if that fact exists | Q6 every night; Q6b skip only if ledger has no such fact |
| **Q7** | Where do you go? | doubland.ai (one Door, not create-sermon) |

### Hard fails (closed — no 11th)

| # | Fail if |
|---|---------|
| **HF1** | Cannot name Peak and Cost, or two equal mains / no Door person |
| **HF2** | Hook is a **lecture** (“Doubles are…”) not mute face/move |
| **HF3** | Can name the game but not tonight’s **consequence**; or Lock-In/Silent Pact played as the wrong prize (vest vs vote weight) |
| **HF4** | Peak turn, Cost landing, or tomorrow appointment missing |
| **HF5** | Ledger had leftover heat / lock-in / unreadability and the film skipped it (fix is **not** a 15-person directory) |
| **HF6** | Dignity break (boot as punchline / pile-on) |
| **HF7** | Invented blocs / tallies / second winners a cold viewer would believe |
| **HF8** | All-cinematic bait-and-switch — **no** live-sim window (not “plant was ugly”) |
| **HF9** | Runtime **>120s**, or encyclopedia / “Previously on” / third name with no causal verb |
| **HF10** | Door miss, mid-body product sermon, or dual watch+create CTA |

### Non-fails

Short cafe/win loops until Wave 2. Path **[D]** good-enough flags. Loading-bar poster. Loop-A leaks (wrong file, freeze, `imported/`). Kinetic type as a number. Weak-but-present 2D↔3D.

### Untaught (B4)

Not on the quiz/HF list → label `untaught`. Loop-B **passes** unless you confirm a new law.

### Specimen (what B demands beyond pretty pictures)

- **Day 1:** Alexis Shield = safe **tonight**; Vincent left after a **tie**; 15→14; Door.
- **Day 2:** Irene = **stronger vote not a vest**; leftover heat from the tie is the appointment; no Day-1 “Shield is gone” cards.
- **Day 3:** **No vest**; Irene/Olivia mutual = **double vote**; Cost is Shepard; 13→12.

### This week’s prove

1× phone watch of `trailer_ready_day4/output/trailer_9x16.mp4` (name the wave). Quiz on paper first.

---

## Loop-C — Done

Same `snapshot-tag` / same MP4:

1. Loop-A pass recorded.
2. Loop-B pass recorded (**quiz sheet + no HF**).
3. Master snapshotted; **do not overwrite** accepted Day 1 / Day 2 / Day 3 packages on `20260724-2`.
4. If a new look was confirmed from `untaught`, Path **[C]/E1** learn is a **separate** ticket (allowlist priors only — never imports, VO, ledger).

---

## Handback ticket (production → eng)

One issue per ticket when possible. Template:

```text
Loop: A | B
Package: data/20260724-2/trailer_ready_dayN
MP4 / Live: (wall time + role or cut id)
Symptom: (what we saw)
Expected: (SOT / Wave law — cite)
Do not: (imported, VO rewrite, overwrite Day 1/2/3, …)
Evidence: still / marker / freezedetect if any
```

Eng response is **recipe, validator, or kit job** — not “tweak Live and call it done” unless Live↔Rebuild is the bug.

---

## Agent split (when you automate this)

| Role | Gate | Must not |
|------|------|----------|
| Production agent | Loop-A then Loop-B | Polish as the ship path; rewrite VO; promote `imported/` |
| Engineering agent | Clear Loop-A/B tickets; re-bake cold (`--ignore-edit-script` when proving auto) | Clobber `vo_locked.txt` without `--replace-vo-lock`; overwrite closed masters |
| Founder | B4 untaught veto; Loop-C accept on a new night type | Required on every A tick |

Watch skill / phone-watch: Loop-B. Post-Production Live: Loop-A.

---

## What to write into SOT later (after one clean loop on a night)

Not now. After Loop-C on a **new** night type (Day 4 of this sim, or Episode 1 of another):

1. Add **§ Loop-A / Loop-B** to `SOT-new-daily.md` (or a sibling `daily/LOOP.md`) with the v1 tables.
2. Point `TODO_video.md` Next at that file; keep Path A–E as history.
3. Promote 2–3 Loop-A checks into `validate_nightly_survival` (wrong remaining-count is already VO-side; **plate-under-VO** and **freeze budget** are the next eng P2).

Until then this file is the operating note.

---

## Honest gaps (do not block v1)

| Gap | Effect |
|-----|--------|
| Freeze budget not in nightly gates | Loop-A soft / P2 eng — **not** an HF |
| No ASR/OCR cold quiz | Quiz stays human |
| Day 3 master locked wave29 | Do not overwrite `trailer_ready_day4`; next loop names that night’s MP4 |
| Long SKU 2D↔3D caps not SOT | Do not run this loop on long until that packet is accepted |
| Production-agent prompt not written | This note is the spec; Cursor skill / COS task comes after you say go |

---

## References

- Inquiry (long SKU, separate): `D:\Coding\double-ivan\20260820_longer_daily.md`
- Checklist SOT: `D:\Coding\double-ivan\video\TODO_video.md` · [GitHub](https://github.com/ivan-exsy/double-ivan/blob/main/video/TODO_video.md)
- Daily contract: `D:\Coding\double-ivan\video\daily\SOT-new-daily.md` §9, §10, §11.4, §12
- 2D↔3D: `D:\Coding\double-ivan\video\daily\daily-2D-3D-blend.md`
- Anya rubric: `D:\Coding\double-ivan\video\daily\gold\20260713-1_day1_anya\anya_bar_rubric.md`
- Dynamism / freeze evidence: `D:\Coding\double-ivan\20260811_capcut-vs-post-prod.md`
- Eng nightly gates: `D:\Coding\generative_agents-ivan-dev\video\validate_nightly_survival.py`
- RealityTV Loop-B lock: `D:\Coding\COS\tasks\2026-08-21-001\final.md`

---

*Day 3 Loop-C locked 2026-08-21 (wave29). Auto-gen laws are in SOT §10.1 / §11.4. Next night uses `run_tonight_scar`. Do not implement production agents until you accept the Loop-A/B tables.*
