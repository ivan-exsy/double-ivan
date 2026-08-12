# CapCut bar → Post-Production — detail brief (2026-08-11)

**Owner:** founder (Ivan)  
**Agent home:** prefer **`double-video`** multi-root (`generative_agents-ivan-dev` + `double-ivan`)  
**Status:** P0 applied to `edit_script.json` (~22:02); **founder Rebuild [B] next**  
**SOT checklist:** [`video/TODO_video.md`](video/TODO_video.md) ← mark status there; keep field actions / evidence here.

**Plan order (locked):** **[A]** polish → **[B]** Rebuild proof → **[C]** eng learn → **[D]** cold auto → **[E]** migrate gen into `double-video`

Evidence archives (do not re-debate from scratch):

| Research | Role |
|----------|------|
| [`video/daily/gold/…/20260811_dynamism_gap_20260724-2.md`](video/daily/gold/20260713-1_day1_anya/20260811_dynamism_gap_20260724-2.md) | First watch pass + top-10 gaps |
| [`video/daily/gold/…/20260811_opus_second_opinion_p0_bake.md`](video/daily/gold/20260713-1_day1_anya/20260811_opus_second_opinion_p0_bake.md) | Second opinion on fresh bake + freeze measure |
| Frames | `…/teardown/opus_20260811/` · `…/teardown/watch_pass_20260811_*` |

---

## Inputs

| Role | Path |
|------|------|
| **Craft bar (Anya)** | `D:\Coding\generative_agents-ivan-dev\data\20260713-1\trailer_ready_day2\clip_kit\video\0720(1).mp4` (~88.2s) |
| **Our package** | `D:\Coding\generative_agents-ivan-dev\data\20260724-2\trailer_ready_day2\` |
| **Polish SOT** | `…\edit_script.json` (last save ~20:10 tonight) |
| **Last bake** | `…\output\trailer_9x16.mp4` (~21:03 — first Rebuild since Aug 7) |
| **Product** | Post-Production @ `D:\Coding\double-video` |

Different sims — compare **craft grammar**, not Peak/Cost cast.

---

## Verdict (merged)

Anya feels more alive because of **cut rate + short holds + SFX-on-beat + short type + living plates** — not music alone.

**Harder number (Opus, same freezedetect filter both films):** Anya **0s** frozen picture centre · ours **37.8s (39%)** · worst freeze **9.5s**. Root cause is often **short source in long window** (e.g. `hobbs_gather.mp4` ≈ **2.04s** inside a **17.0s** cut) — not only “too few cuts.”

**Tonight’s bake already shipped:** photo→matrix wipe + opener roster/badges. **Still open:** wrong-cast Phaser on elim beat, long freezes, black holes, flat music, overscanned ALLIANCES card.

**Credibility > dynamism tonight:** elim ~70.7–74.1 shows **Irene / Ivan** labels under VO “VINCENT IS GONE.” First report wrongly blessed that shot.

---

## P0 — Live tonight (~30–45 min, survives Rebuild)

**Applied 2026-08-11 ~22:02** on package SOT (not yet Rebuild-proven).  
**Rollback snapshot:** `edit_script.pre_p0_dynamism_20260811_220017.json`  
**Do next:** open Post-Production → confirm Live → **Rebuild once** → phone-watch.

| # | Action | Status | What landed |
|---|--------|--------|-------------|
| **1** | Phaser elim credibility | **Done (A)** | `cost_phaser_bridge` → label-free `signature_flyover.mp4`; marker `debt_phaser_elim_cast` @ 70.7 |
| **2** | Unfreeze challenge bed | **Done** | `challenge_gather` `speed: 0.12` |
| **3** | Fill black holes + door | **Done** | `hook_census`→16.9 + speed 0.782; door start 87.5 op **0.85** speed 1.5; cliff→87.55; lockup 91.5 |
| **4** | Peak + habitats + want_cost | **Done** | peak `speed: 0.38`; habitat PNG Ken Burns; habitat mp4 speeds; `want_cost` 28.0–31.6 |
| **5** | ALLIANCES readable | **Done** | `scaleFrom: 1.15` → `scaleTo: 1` |
| **6** | Music duck | **Done** | 6 bed segments; teach duck gain **0.08** |
| SFX joins | primary cut hits | **Done** | 9× `sfx_p0_*` whoosh/swoop |

### Still open after Rebuild proof

- Peak **evidence** asset (P1) — cheer plate still no card.  
- Correct-cast Phaser elim (P1 B or capture C).  
- Challenge teach bed ≥6s motion (P1).  
- Tie “3 vs 3” readability (later).

### Do **not** (tonight)

- Rewrite captions as primary work (mean words already competitive).  
- Commission Vincent “PLAYER OBJECTIVE” HUD — already ships as `want_cost` (timing only).  
- Reopen opener wipe / roster (tonight’s win).  
- Force-materialize this package (props at `source.propsPath` were overwritten by Rebuild).  
- Start **[C]** learn or **[E]** bulk migrate.  
- Trust `nightly_run_report` green as dynamism (gates miss long beds / black holes).

### FX note (corrected)

`edit_script.fx[]` **does** reach Rebuild via `build_nightly_remotion_props` — but recipe still **appends** extra punches, and **`enabled: false` is ignored**. Prefer picture/SFX/speed work tonight; FX polish after eng honours disable + stops silent extras.

---

## P1 — assets (commission / capture)

Any motion clip must be **longer than the window it fills** (or set `loop` / `speed`). A 2s clip in a 17s window freezes again.

| Priority | Asset | Spec |
|----------|-------|------|
| **1** | Correct-cast Phaser elim for `20260724-2` | Vincent + relevant peer labels · see § Phaser |
| **2** | Challenge teach bed | Card table / hands — **≥6s** source motion |
| **3** | Peak evidence | Alexis + readable winning card — **≥3s** motion |
| Later | Hero-grade namecards · readable tie “VOTING TARGET” card (grey “3 vs 3” is phone-unreadable) | |

---

## Phaser elim beat — decision

**What it is today:** founder-made Phaser-style illustration, imported into `20260724-2`. Labels read **Irene / Ivan** (Anya sim). It is **not** a live capture from this night’s FE Phaser viz.

**Proper workflow (Desired):** at the critical elim moment, capture a snapshot from the **frontend Phaser visualization** for *this* sim (correct doubles + scene), stage into `F_phaser` / `imported`, wire `cost_phaser_bridge`.

| Option | When | Trade-off |
|--------|------|-----------|
| **A — Temporary plug** | Tonight | Remove wrong-name plate or swap to label-free (`signature_flyover` / door still). Ship credibility. Mark debt. |
| **B — Imagine now** | Parallel to P0 | Prompt with this night’s doubles + scene refs; optionally attach current Irene–Ivan plate as style ref only — **do not** ship Anya names. |
| **C — Capture pipeline** | After P0 bake accepted | Product/eng: “snapshot at elim” from FE Phaser → kit bin → edit_script. Real unlock for every night. |

**Founder default for tonight:** **A** (or B if Imagine is already warm). **C** is the durable fix — schedule after [B], do not block tonight’s dynamism pass.

---

## P2 — eng (only after founder accepts a P0 bake)

1. Honour `fx[].enabled` + stop always-append recipe FX when polish `fx[]` present (or document extras).  
2. Gate: warn when `window > 1.25 × source duration` without `loop`/`speed`.  
3. Gate: picture coverage every second (opacity ≥0.5) — catch black holes.  
4. Hold gates: measure **picture** freezes; don’t exempt all beds / count caption starts as picture events.  
5. Guard kit import by sim code; surface specimen challenge pack status in UI.  
6. Optional: keep `*.base.json` so force-materialize doesn’t fold polish into base.

---

## Where to improve code — extract now?

**Already in `double-video`:** Post-Production (Live, edit_script, inspector, kit import). **Keep doing P0/P1 polish here.**

**Still in eng (`generative_agents` `video/`):** cold recipe, props apply, Remotion encode, gates, learn loop.

| Move | Reasonable now? |
|------|-----------------|
| Further **polish UX / edit_script** work in `double-video` | **Yes** — that’s the product home |
| **Bulk extract / migrate** eng `video/` gen into `double-video` (**[E]**) | **Not yet** — dual maintenance while freezes, wrong Phaser, and gates are open slows [A]→[B]→[C] |
| Read-only migration inventory + thin `ENG_ROOT` bridge | **Yes** — docs only; no code move |
| First **slice** of schema/`edit_script` apply into monorepo | Only after **[B]** green + at least one **[C]** E0/E1 pass (prd §22.1 gate) |

**Recommendation:** document Phaser debt (§ above) → finish P0 Live → Rebuild [B] → then decide Imagine vs capture pipeline. **Do not** pull full gen migration forward so “improvements live in one repo”; you’ll pay dual-path tax on every Rebuild while taste is still moving. When [B]+[C] are green, [E] staged slices are the right unlock.

**SOT status checklist:** [`video/TODO_video.md`](video/TODO_video.md).

---

## Explicit do not (global)

- CapCut XML archaeology restart · VO rewrite · CapCut parity for its own sake  
- Recast to Anya faces · treat 88s vs 97s as the gap  
- “Add more of everything” without the freeze / credibility order above  
- Commission clips shorter than their windows  
