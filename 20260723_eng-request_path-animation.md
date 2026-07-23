# Eng request — Restore path animation (viewer + generation loop)

**From:** Ivan (product)  
**Date:** 2026-07-23  
**Priority:** P0 for viewer quality / “natural world” feel; tied to headless affordability (see OOM RCA)  
**Score sim evidence:** `20260720-1`  
**Repos:** `generative_agents` (primary) · `double-front` (playback/path consume) · SOT: `sot_be-fe.md`, `sot_realism.md`  
**Related:** `double-docs/20260720-1_RCA.md` §10–12 (OOM + headless-as-core)

---

## 1. Problem (plain language)

On the live score sim, doubles **look like they jump** from tile to tile each step instead of **walking** along a path.

World coordinates are *not* blinking across town (clamp is working). The missing piece is **path animation**: playback has nothing to tween along within a step, so each new step snaps the sprite to a new position (up to ~6 tiles away).

This breaks the MVP “natural world” feel even when action/location counters look good.

---

## 2. Product outcome we need

1. **Viewer / replay:** When watching a sim (live or scrub), agents **animate along a walk path** within each step — not teleport to the step’s end tile.
2. **Generation loop (unchanged product rule):** Backend still sends **intent**; Frontend (headless Phaser) still **realizes** wall-aware movement and reports `actual_pos` / `actual_path`. Turning headless “off forever” is **not** the strategy (locked in RCA §10–12).
3. **Ops:** The path system must be **affordable on the ~4 GB VPS** (Chrome OOM killed `20260720-1` overnight). Screenshots every step are optional; **path + actuals are not**.

---

## 3. Evidence from `20260720-1`

| Check | Result |
|-------|--------|
| Consecutive-step coord jumps ≥10 / ≥15 tiles | **0** (8 living agents, ~60k step-pairs) |
| Max jump per step | **6.0 tiles** (= `MAX_TILES_PER_STEP` speed budget) |
| Realism analyzer TELEPORT @ sample-rate 1 | **0** |
| Movement `path[]` in sampled coords (e.g. Vince 7100–7200) | **Empty on every step** (`path_len=0`) |
| Production posture | `BACKEND_INTENT_ONLY_PATH=true` → BE may emit empty `path[]` + `target_zone`; FE owns A* |

**Conclusion:** R3 clamp is fine. **Path payload / playback path consume is missing or not persisted**, so the viewer can only snap to end tiles.

Headless was **on** during generation (Chrome alive; `rendered/step-7xxx.png` writing) and still OOM’d the host once — so “headless running” ≠ “viewer has smooth paths” until `actual_path` (or equivalent) is stored and consumed correctly.

---

## 4. What “done” looks like (acceptance)

### A. Data contract
- [ ] For every moving step, persisted movement includes a **non-empty walk path** suitable for animation (FE `actual_path` writeback **or** an agreed equivalent stored in Supabase / movement blob).
- [ ] Stationary steps may have empty/short path.
- [ ] Path respects walls / soft obstacles per `sot_be-fe.md` (destination hard-block, intermediate soft).

### B. Viewer behaviour
- [ ] In FE playback, sprites **lerp/tween along path waypoints** within the step duration (or at configured playback speed), not only jump to `actual_pos`.
- [ ] Scrubbing step N→N+1 still looks like a walk when path exists (not a single snap), or documents a deliberate scrub exception.
- [ ] Cross-town travel still takes **many steps** (no regression to whole-map blink).

### C. Generation / headless
- [ ] Intent-only BE emit remains valid; FE still computes A* when `path[]` empty.
- [ ] `actual_path` (or agreed field) is written back every successful headless movement report.
- [ ] Long Survival sprint (≥7k steps) on current VPS class does **not** OOM from Chromium (see efficiency requirements below) **or** has an approved isolated headless worker with memory limits + auto-resume.

### D. Verification
- [ ] Analyzer or script: % of travel steps with `path_len > 0` on a score sim ≥ agreed bar (propose **≥95%** of non-stationary moves).
- [ ] Human playback: 2–3 dorm↔Hobbs / campus↔cafe commutes look continuous.
- [ ] Regression: `analyze_sim_realism … --sample-rate 1` TELEPORT stays near 0; Gap1/2 / place-language not worsened.

---

## 5. Likely workstreams (for eng to sequence — not a mandated design)

Please investigate and propose; pick the smallest path that hits acceptance:

1. **Persist FE paths**  
   Confirm headless reports `actual_path` → BE writeback → Supabase `personas_coords.movement` (or SOT field). Fix any drop on intent-only steps.

2. **Playback consumes paths**  
   `AnimationManager` / replay mode: when stored path exists, animate it; when missing, fall back without pretending.

3. **Headless affordability (blocker for leaving path gen on)** — from RCA §12  
   - Stop or sample PNG screenshots on long sprints (path ≠ screenshot).  
   - Isolate Chromium from `double-api` cgroup / MemoryMax / swap.  
   - Longer-term: lighter FE executor that still runs Phaser spatial logic without full page chrome if needed.

4. **Do not “fix” by having BE emit full A\* under intent-only** unless product/SOT change is approved — that fights `sot_realism.md` / `sot_be-fe.md`.

---

## 6. Explicit non-goals

- Re-litigating staff-zone / piano polish (separate checklist items).
- Fixing chat-cooldown analyzer noise via gather mute.
- Turning off Phaser validation as the permanent solution.
- Requiring pixel-perfect marketing screenshots every step.

---

## 7. Context links

| Doc | Why |
|-----|-----|
| `double-docs/sot/sot_realism.md` | BE intent → FE realize → `actual_path` / `actual_pos` writeback |
| `double-docs/sot/sot_be-fe.md` | Intent-only empty `path[]`; headless observations contract |
| `double-docs/20260720-1_RCA.md` | OOM from Chrome; headless = core; efficiency roadmap |
| Score sim | `20260720-1` (~7500+ steps, Survival) |
| Analyzers | `tests/analyze_sim_realism.py` (0 TELEPORT @ sr1); jump audit: max step delta = 6, `path_len=0` |

---

## 8. Ask back from eng

**BE slice A status (2026-07-23):** Implemented on `ivan/headless-memory-hygiene` + applied RPC migration on shared Supabase.

1. **Root cause:** Intent-only leaves `path: null`. FE `actual_path` was passed as `p_actual_path` but RPC only wrote `movement.path` (not `actual_path`), and intent rewrites could leave path null. Gateway step read also did not surface `actual_path`.
2. **Fix:** RPC merges both `actual_path` + `path`; preserves realized paths on intent-only rewrites; gateway returns `actual_path`; acceptance script `scripts/analyze_travel_path_coverage.py`.
3. **ETA:** BE A done; FE B separate; verify on **new** score run with headless ON.
4. **Risk:** Low to railway; old sims unchanged. New run required for acceptance (≥95% travel path coverage).

---

## 9. Founder one-liner

> Coordinates already walk at 6 tiles/step; the product is missing **animated paths**. Restore FE path realization **and** persist/play those paths without melting the VPS.
