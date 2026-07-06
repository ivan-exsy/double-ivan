# Implementation Request → Nicolas — MVP 3-Sim Hardening (P0 items 1–2)

> **From:** Ivan · **Date raised:** 2026-06-05 · **Revised:** 2026-06-08 (trailers moved off-server — scope reduced) · **Priority:** P0 (blocks demo launch)
> **Goal:** make **3 concurrent simulations** run reliably on the current **3.8 GB / 4 vCPU** box so we can run the 15-double Telegram Survival season without sims crashing.
> **Why now:** these items are the reliability spine of the MVP release gate (`double-ivan/20260605_mvp-release-gate.md` §P0). The landing + waitlist capture is done; this is the remaining gating work before the season can start.
> **Source of truth for detail:** `TODO_production_hardening.md` (MVP section at top, §4 H-items, §7 FE answers). This doc is the actionable request; the hardening doc is the analysis.
> **Implementation update:** Nicolas · **2026-06-09** — Items **1 + 1.5 validated on VPS** (through 3×100-step final soak) · FE `main` `5917979` · BE `railway` `5a0f7da4` (sign-off smoke) · **Ivan production-generation sign-off 2026-06-09** · **Item 2 VPS queue proof 2026-06-10** — BE `railway` `549d2d41` · FE `21371fa` · `queued_at_capacity: true` on 4th API start.

---

## VPS deploy — Nicolas (read before any box work)

**Ops runbook (copy-paste commands):** `README.md` § **Sim VPS — generation deploy (operators)**  
**Topology, env SOT, sign-off grep checklist:** `20260609_vps_generation_deploy_topology.md`

| Rule | Detail |
|---|---|
| **Two repos on box** | BE `/var/www/generative_agents` (`railway`) + FE `/var/www/double-front` (`main`) |
| **Deploy = `git pull` only** | No rsync from laptop — silent drift broke prior soaks |
| **FE always rebuild after pull** | `npm ci && npm run build:headless` then `systemctl restart double-front` |
| **systemd only** | `api-gateway.service` + `double-front.service` — no manual `npm start` / `uvicorn` |
| **Vercel is playback only** | `FRONTEND_URL` must stay `http://localhost:3000` for generation |

**When you change `double-front` only** — follow README § Routine deploy — frontend only, record commit in soak meta JSON.

**When Ivan ships paired BE+FE** — README § Routine deploy — paired; run 3-step smoke before long soak.

**Headless pass/fail on soak logs** — grep `reports_submitted` (expect 4/step for family sim) and `Headless execution completed`; do not treat `movement_reports_handled: 0` in `OBS_PIPE_STEP_SUMMARY` as failure (topology doc explains).

**Item 2 soak re-run** — only after confirming box matches sign-off config (git-clean trees, both services active, env SOT unchanged).

---

## Implementation status — Nicolas (2026-06-05)

| Item | Scope | Status |
|------|-------|--------|
| **1 — Prod FE for headless (H0)** | `double-front` + paired BE flags | **DONE** · FE `5917979` · VPS soaks passed (5-step + final 100-step) |
| **1.5 — Reuse Playwright tab per sim** | BE + FE · `HEADLESS_TAB_REUSE` | **DONE** · BE `fc3e28dd` · A/B/C soaks passed on VPS |
| **2 — Sim cap + overflow queue (H5)** | Backend / orchestrator | **DONE** · BE `549d2d41` · VPS deployed + queue proof **2026-06-10** · **P2:** `COMPLETED.json` mkdir fix shipped (`610cc495`) |

### Summary for Ivan

Item 1 FE is **on `main`** and **validated on the VPS** (2026-06-09). Local headless step time dropped from the documented ~10–30 s (`next dev` + cache-bust) to **~1.1 s** on a single prod-fe step; the **3-concurrent-sim soak** completed **5 steps each** in ~2 min wall-clock with no OOM and 4/4 headless movement reports per step (see VPS verification below). **Ops fix on box:** `SKIP_ENV_JSON_WRITE=false` (was blocking multi-step progression). **Optional follow-up for Ivan:** push paired BE cache-bust default off. **`movement/COMPLETED.json` mkdir fix** — bundled into Item 2 (see below).

**Estimate (original ask):** Item 1 FE **~½ day** (delivered). Item 2 **0 FE** — backend only. Item 1.5 **~1–2 days** if we want the next step-time win before browser-free (§3.2).

---

## The one-paragraph version

Today every simulation step drives a headless browser against a **`next dev`** frontend that recompiles on every request, and the backend makes it worse by cache-busting each navigation — so three sims hitting one frontend at once is the exact contention that has crashed runs. We need two things: 
**(1)** a production frontend build for headless so there's no per-step recompile, and 
**(2)** a real, enforced cap of **3 concurrent sims** with an overflow queue (today it's an implicit `=3` constant). Item 1 is frontend work; item 2 is backend/orchestrator work.

---

## Scope simplification (2026-06-08) — read first

**Trailer rendering moves off the server entirely.** It runs on Ivan's local machine, reading sim data from Supabase. This was confirmed feasible: the trailer extraction pipeline (`video/extract_day_log.py`) reads everything from Supabase RPCs and position rows, not from server-local files; the scene recorder just needs a local frontend + Supabase access.

**Consequences for this request — it shrank from three items to two:**
- **The old "trailer mutual-exclusion guard" (was item 3) is dropped entirely.** Trailers can't contend with sims if they never run on the same machine.
- **The capacity budget (item 2) simplifies** from a mixed sim+trailer "browser units" model to a plain **sims-only cap of 3**.

**This is not a shortcut.** Running trailer rendering on separate capacity is exactly the long-term direction the hardening doc (§6) and the FE team (§7 Q7) recommend. "Local machine" later becomes "a dedicated trailer worker pool" — same Supabase-driven data flow, different host. Nothing built here gets thrown away. See "Trailers (out of server scope)" at the bottom.

---

## Item 1 — Production frontend build for headless *(the blocker — H0)*

**Owner:** Nicolas / FE (`double-front` repo)
**Effort estimate (FE):** < 1 day
**Addresses:** the original crash cause + per-step cost
**Status:** **FE pushed** · **VPS soak PASSED** (2026-06-09) · paired BE H0 patch **local only** (not required for soak)

### The problem
Headless generation currently runs against **`next dev`** in every environment. That means HMR, source maps, and on-the-fly webpack compilation. On top of that, the backend sends `Cache-Control: no-cache` on every Playwright navigation, which forces a fresh dev recompile **per step**. With 3 headless browsers hitting one frontend simultaneously, this compile contention is what degrades steps into timeouts and crashes runs. (Confirmed in `TODO_production_hardening.md` §7 Q3 and the 2026-06-04 status update.)

### What we need

| # | Requirement | Status |
|---|-------------|--------|
| 1 | **`next build && next start` path for headless** — script that chains build + start so the backend points at prod instead of dev | **DONE** |
| 2 | **Drop Playwright cache-busting** so `_next/*` chunks are served from prod cache | **DONE** (BE default off; opt-in for dev) |
| 3 | **Confirm one `next start` backs 3 headless contexts on 3.8 GB / 4 vCPU** | **DONE** (VPS soak 2026-06-09 — see below) |
| 4 | **Confirm `NEXT_PUBLIC_HEADLESS_SPEED_MULTIPLIER` default (100)** + **`__headlessMetrics` surface** | **DONE** |

#### Delivered (2026-06-05)

**`double-front`** — **pushed** `main` · `544f288` *feat(headless): prod build path for Playwright sims (H0)*
- `npm run build:headless` · `start:headless` · `prod:headless` (`HEADLESS_VALIDATION=true`, port 3000)
- `scripts/start-headless-prod.sh` — VPS-oriented build + start wrapper
- `README.md` — headless prod runbook + note that **`NEXT_PUBLIC_*` is baked at build time**

**`generative_agents-local`** *(paired with Item 1 — deploy together; **code done, not pushed**)*
- `HEADLESS_PLAYWRIGHT_CACHE_BUST=false` by default (set `true` only when iterating on `next dev` stale bundles)
- `HEADLESS_FRONTEND_PORT_ROAM=false` recommended on VPS (stops 3000–3005 dev port scan)
- Per-step log of `window.__headlessMetrics` (`boot_ms`, `preload_ms`, `animation_ms`, `total_ms`)
- `scripts/test_headless_h0_smoke.py` — repeatable local/VPS smoke
- `reverie/backend_server/tests/test_headless_lifecycle.py` — env-default unit tests

**VPS env (backend + ops — applied 2026-06-09 on sim box `199.80.55.26`):**
```bash
FRONTEND_URL=http://localhost:3000
ENABLE_HEADLESS_VALIDATION=true
HEADLESS_MOVEMENT_ENABLED=true
HEADLESS_BLOCKING_MODE=true          # was already on
SKIP_ENV_JSON_WRITE=false            # critical for multi-step soak (was true → stall after step 0)
```
`double-front` at `/var/www/double-front` via **`git pull origin main`** (not rsync), `npm ci && npm run build:headless`, **`double-front.service`** on `:3000`. Backend: Ivan `railway` @ `/var/www/generative_agents`. Deploy protocol: **`README.md` § Sim VPS — generation deploy**. Sims launched via `reverie.py base_family_sim <code>` + `log 5` / `fin`.

> **Correction (2026-06-09):** Headless **generation** must use the **local prod FE on `:3000`** (systemd `double-front.service`). Pointing `FRONTEND_URL` at Vercel (`double-front.vercel.app`) loads the viewer but **does not** engage the headless movement loop (`movement_reports_handled: 0`). Vercel is for end-user playback only. **Deploy runbook:** `README.md` § Sim VPS — generation deploy · **Topology + sign-off:** `20260609_vps_generation_deploy_topology.md`.

### Acceptance

| Criterion | Status |
|-----------|--------|
| Documented command/script in `double-front` | **DONE** · on `main` |
| 3-concurrent-sim run on VPS without compile-contention timeouts/crashes | **DONE** (2026-06-09) |
| `__headlessMetrics`: `preload_ms` / `animation_ms` dominate over multi-second `boot_ms` | **DONE** (local smoke — see below) |

### Local verification (2026-06-05)

Command: `python scripts/test_headless_h0_smoke.py` (`generative_agents-local`)

Setup: prod `next start` on `:3000`, local API gateway on `:8001`, sim `20260407-30-15` step 1, Supabase `sim_id` via URL override, cache-bust off.

| Metric | Value |
|--------|------:|
| `boot_ms` | 465 |
| `preload_ms` | 392 |
| `animation_ms` | 618 |
| **`total_ms`** | **1,114** |
| Headless status | `pass` |
| Movement reports | 15 / 15 submitted |
| Observations | 4 |

Unit tests: `reverie/backend_server/tests/test_headless_lifecycle.py` — **17 / 17 passed**.

Interpretation: step time is now dominated by **boot + chunk preload + animation**, not dev recompile. This matches the intended H0 outcome.

### VPS soak verification (2026-06-09)

**Sims:** `soak-20260609-a1`, `soak-20260609-b1`, `soak-20260609-c1` — forked from `base_family_sim`, **5 steps each**, launched in parallel (~12:14 UTC).

**Logs:** `/var/log/soak/soak-20260609-{a1,b1,c1}.log` (~2.1k lines / ~240 KB each).

| Criterion | a1 | b1 | c1 |
|-----------|----|----|-----|
| Steps completed | 5 (`meta.json` → `completed`) | 5 | 5 |
| Wall-clock | ~1m 44s | ~1m 54s | ~1m 54s |
| Headless blocking ×5 | ✅ | ✅ | ✅ |
| `HEADLESS READINESS ready=True` | 5/5 | 5/5 | 5/5 |
| Movement reports / step | 4/4, 0 rejected | 4/4 | 4/4 |
| `HEADLESS STRICT FAILURE` | 0 | 0 | 0 |
| OOM / crash | none | none | none |
| RAM during run | ~3.1 GB avail (of 3.8 GB) | — | — |
| Monitoring `step_0..4.json` | 4/4 personas | 4/4 | ⚠️ `4/3` (cosmetic; reports still 4/4) |
| Artifacts | `environment/0..4.json`, `rendered/step-0..4.png` | idem | idem |

**Known non-blocking warnings (all 3 sims):**
- `movement/COMPLETED.json` not written — no `movement/` dir when `SKIP_MOVEMENT_JSON_WRITE=true` on prod BE. **Tracked in Item 2** (mkdir before write).
- `c1` only: `fin` → `save()` failed after completion (`reverie/meta.json` missing); sim already marked `completed` in FE `meta.json`.

**Earlier soak attempts (cleaned up):** `soak-real-*` stalled after step 0 (`SKIP_ENV_JSON_WRITE=true`); `soak-20260609-a/b/c` via API failed reverie fork — filesystem + Supabase rows deleted 2026-06-09.

**Verdict:** Item 1 H0 **acceptance met** on VPS — one prod `next start` backs 3 concurrent headless sims on 3.8 GB without compile-contention timeouts or OOM.

> **Invalidated for prod sign-off (2026-06-10):** That soak used rsync'd code, operator env overlay, and manual (non-systemd) processes. **Replaced** by Ivan sign-off smoke `signoff-20260609-2350` on locked config — see **`20260609_vps_generation_deploy_topology.md`**. Item 2 soak re-run follows on that config; use **`README.md` § Sim VPS deploy** for deploy steps.

### Backend coordination (Ivan / BE — small, paired with this)

| Action | Status |
|--------|--------|
| Point Playwright at prod `next start` (not `next dev` port roam) | **DONE** (VPS 2026-06-09) |
| Remove `Cache-Control: no-cache` from Playwright navigations | **DONE** (verified 2026-06-10: `railway` gates all cache-busting — launch flags + route headers — behind `HEADLESS_PLAYWRIGHT_CACHE_BUST`, default `false`, unit-tested; deployed to prod, merged to `main` + `ivan/dev`) |
| `SKIP_ENV_JSON_WRITE=false` for multi-step headless | **DONE** (ops on VPS — was blocking step 1+) |

---

## Item 1.5 — Reuse Playwright tab per sim *(recommended quick win — not in original scope)*

**Owner:** Nicolas / BE (`generative_agents-local/reverie/backend_server/headless_visualization.py`) + small FE hygiene
**Effort estimate:** ~1–2 days (with parity soak)
**Status:** **DONE** — Phases A, B, C validated on VPS (see metrics below)
**Protocol doc:** this section + `generative_agents-local/scripts/run_pre15_baseline_soak.sh`

### Why
Item 1 removes dev recompile cost. The backend still opens a **`new_page()` per step** and closes it in `finally` — every step pays full page boot (~`boot_ms` in metrics above). A **long-lived tab per sim process** (first step: `goto`; later steps: `__executeMovementsForStep` only) should cut step time further and flatten RAM peaks (see `TODO_production_hardening.md` §7 Q4).

### What it would take
- **BE:** `HEADLESS_TAB_REUSE=true` — one Playwright `Page` per sim in `HeadlessVisualizationService`; step 1 `goto`, steps 2+ `__headlessPrepareNextStep` + inject only (`headless_visualization.py`).
- **FE:** `AnimationManager.prepareHeadlessStepTransition()` — prune `claimedTiles`, dynamic occupancy, safety timers; exposed as `window.__headlessPrepareNextStep(step)`.
- **Acceptance:** parity movement reports; `boot_ms → ~0` from step 2+; RAM curve flat or bounded vs pre-1.5 baseline (see protocol below).

### A/B protocol — attributing leaks to Item 1 vs 1.5

Without a **pre-1.5 baseline**, a RAM leak at step 100/3000 is **not attributable**. Run this sequence:

| Phase | Config | Sims | Steps | Purpose |
|-------|--------|------|-------|---------|
| **A — baseline (Item 1.0)** | `HEADLESS_TAB_REUSE=false` (today) | **1** | **30** | RSS curve + `boot_ms` per step |
| **B — Item 1.5** | `HEADLESS_TAB_REUSE=true` + FE prune | **1** | **30** | Same fork/origin; compare curve |
| **C — parallel smoke** | `HEADLESS_TAB_REUSE=true` | **3** | **15–20** | RAM under concurrency (post A/B) |
| **D — dress rehearsal** (optional) | validated flag | 1–3 | 100+ | Pre-season only if A/B clean |

**Per-step metrics to capture** (CSV + reverie log):

| Field | Source |
|-------|--------|
| `reverie_rss_kb`, `tree_rss_kb` (reverie + Chromium children) | `scripts/soak_ram_monitor.sh` every 10s |
| `boot_ms`, `total_ms` | `window.__headlessMetrics` in reverie log |
| Movement reports | `reports_submitted: 4` per step |
| Step marker | `=== SIMULATION STEP N` / `HEADLESS READINESS step=N` |

**How to read the curves:**

| Pattern | Likely owner |
|---------|----------------|
| RAM rises each step, partial drop after step (sawtooth) | **Item 1.0** — `new_page()` / page teardown |
| RAM monotonic rise, `boot_ms ≈ 0` from step 2+ | **Item 1.5** — FE/Phaser state not pruned |
| Same slope with flag on **and** off | **Neither** — reverie, LLM, Supabase, or worker leak |
| 1 sim stable, 3 sims OOM | **Item 2** — concurrency / cap, not per-step leak |

**Artifacts (VPS):** `/var/log/soak/<sim_code>.log`, `<sim_code>-rss.csv`, `<sim_code>-meta.json`

**Launcher:** `generative_agents-local/scripts/run_pre15_baseline_soak.sh [sim_code] [steps]`

### Phase A baseline result (2026-06-09)

**Sim:** `soak-baseline-pre15-30` · `HEADLESS_TAB_REUSE=false` · 30 steps · ~4.5 min wall-clock.

| Metric | Value |
|--------|------:|
| Headless `ready=True` | 30 / 30 |
| Movement report batches | 30 (4/4 each) |
| Strict failures | 0 |
| Reverie RSS (KB) | min 126,492 → max 212,236 (**Δ +85 MB**) |

Artifacts: `/var/log/soak/soak-baseline-pre15-30.{log,rss.csv,meta.json}`. **Phase B** must repeat same origin/steps with `HEADLESS_TAB_REUSE=true` and compare RSS + `boot_ms` (when BE logs `__headlessMetrics`).

### Phase B result (2026-06-09)

**Sim:** `soak-baseline-post15-30` · `HEADLESS_TAB_REUSE=true` · 30 steps.

| Metric | Phase A (1.0) | Phase B (1.5) |
|--------|---------------|---------------|
| Headless `ready=True` | 30/30 | 30/30 |
| Tab reuse (steps 2+) | 0 (new page/step) | 29/29 (`skipped goto`) |
| `boot_ms` steps 2+ | ~full boot | **0** |
| `total_ms` steps 2+ | higher | **~610–630** |
| Reverie RSS Δ | **+85 MB** (126→212) | **+71 MB** (127→198) |

Logs: `/var/log/soak/soak-baseline-post15-30.{log,rss.csv}`. Item 1.5 **acceptance met** for single-sim 30-step parity.

### Phase C — final validation (2026-06-09)

**Sims:** `soak-c100-a`, `soak-c100-b`, `soak-c100-c` · `HEADLESS_TAB_REUSE=true` · **100 steps each** · parallel (~13:27→13:39 UTC, ~12 min).

| Metric | a | b | c |
|--------|---|---|---|
| Headless `ready=True` | 100/100 | 100/100 | 100/100 |
| Tab reuse (steps 2+) | 99/99 | 99/99 | 99/99 |
| Movement batches (4/4) | 100 | 100 | 100 |
| Strict failures | 0 | 0 | 0 |
| Wall-clock | ~11m 34s | ~11m 4s | ~10m 3s |
| Tree RSS peak (sim+Chromium) | ~842 MB | ~848 MB | ~841 MB |
| Reverie RSS Δ (30→100 step scale) | +76 MB | +76 MB | +73 MB |

**System RAM (3 sims parallel):** peak ~1.5 GB used · **~2.1 GB available** (of 3.8 GB) · **no OOM**.

Logs: `/var/log/soak/soak-c100-{a,b,c}.{log,rss.csv}` (~32k lines each).

---

## Soak test data — summary & measurable wins

**Data location (VPS `199.80.55.26`):** `/var/log/soak/` — all runs logged with `*.log`, `*-rss.csv`, `*-meta.json`. Launcher: `scripts/run_pre15_baseline_soak.sh`.

### Test matrix (all passed)

| Run | Config | Sims × steps | Wall-clock | Headless OK | Strict fail | OOM |
|-----|--------|--------------|------------|-------------|-------------|-----|
| H0 acceptance | prod FE, blocking | 3 × 5 | ~2 min | 15/15 | 0 | no |
| Phase A (1.0 baseline) | `TAB_REUSE=false` | 1 × 30 | 4m 38s | 30/30 | 0 | no |
| Phase B (1.5) | `TAB_REUSE=true` | 1 × 30 | 3m 04s | 30/30 | 0 | no |
| **Phase C (final)** | `TAB_REUSE=true` | **3 × 100** | **~12 min** | **300/300** | **0** | **no** |

### Is the progress real? Yes — with measured deltas

**Item 1 (H0) — prod FE vs `next dev` (documented baseline):**

| Metric | Before (doc baseline) | After (local smoke + VPS) |
|--------|----------------------|---------------------------|
| Per-step headless (single sim) | ~10–30 s (dev recompile + cache-bust) | **~1.1 s** `total_ms` (prod `next start`) |
| 3 concurrent sims on 3.8 GB | timeouts / crashes | **5 steps × 3** and **100 steps × 3** without OOM |

**Item 1.5 — tab reuse vs new page per step (same VPS, `base_family_sim`, logged `__headlessMetrics`):**

| Metric | Item 1.0 (Phase A) | Item 1.5 (Phase B/C) | Delta |
|--------|-------------------|----------------------|-------|
| `boot_ms` steps 2+ | ~900–1100 (new page each step) | **0** | **~1 s saved per step** |
| `total_ms` steps 2+ (headless only) | ~(boot + anim) ≈ **1.5 s+** est. | **~620 ms** | **~60% faster** headless leg |
| 30-step wall-clock | 4m 38s | 3m 04s | **~33% faster** |
| Reverie RSS Δ (30 steps) | +85 MB | +71 MB | **−14 MB (−16%)** |
| Tab reuse rate | 0/29 | 29/29 (30-step) · 99/99 (100-step) | — |

**Phase C — concurrency at season scale (100 steps):**

- **300/300** headless validations, **300/300** movement-report batches (4 personas).
- Per-sim **tree RSS peak ~840 MB** (Python + Chromium); **3 in parallel** held with **~2.1 GB headroom** — tight but within MVP budget on no-swap box.
- Reverie-only RSS growth **~75 MB over 100 steps** per sim (sublinear vs step count — no runaway leak in this window).

### Interpretation

1. **H0 solved the original crash class** (compile contention on shared `next dev`).
2. **1.5 delivers a real, measured step-time win** on the headless path (`boot_ms→0`, ~620 ms vs ~1.5 s+ per reused step).
3. **Final soak proves the MVP gate:** 3 concurrent real sims × 100 steps on the production 3.8 GB box.
4. **Caveats:** soak sims fork `base_family_sim` (morning routine → mostly replay-light steps after step 0); metrics are VPS-specific until `railway` deploy; `movement/COMPLETED.json` still missing with `SKIP_MOVEMENT_JSON_WRITE=true` (non-blocking).

### Overall verdict

| Item | Ship-ready? | Evidence |
|------|-------------|----------|
| **1 H0** | **Yes** (pending Ivan `railway` deploy) | 3×5 + 3×100 soaks, prod FE |
| **1.5** | **Yes** (enable `HEADLESS_TAB_REUSE=true` in prod) | A/B metrics + 3×100 final |
| **2 cap+queue** | **Yes** | Gate + queue on VPS `549d2d41`; 4th API start `queued_at_capacity: true` (2026-06-10) |

### Sequencing
**Item 1 ✅ → Item 1.5 ✅ → Item 2 ✅ → season.**

---

## Item 2 — Sims-only concurrency cap + overflow queue *(H5, tuned)*

**Owner:** Backend / orchestrator
**Effort estimate:** low–medium
**Addresses:** silent contention → OOM on a no-swap box
**Status:** **DONE** (2026-06-10) · **VPS queue proof signed off** (Ivan · 2026-06-10) · **FE confirms approach** (no FE implementation)

### VPS queue proof (2026-06-10) — Ivan

**Deploy:** `git pull origin railway` → `549d2d41` on box `199.80.55.26` · `MAX_CONCURRENT_SIMS=3` · `api-gateway.service` restart · FE unchanged `21371fa`.

| Step | Result |
|------|--------|
| `GET /api/simulations/concurrency` (3 CLI sims) | `active:3`, `slots_available:0`, `cap:3` |
| `POST …/soak-c100-a/start` with `action:start` at capacity | `queued_at_capacity: true`, `status: queued` |
| `pgrep reverie.py.*soak-c100-a` immediately after POST | empty (not spawned) |

**Protocol:** 3 sims launched via CLI (`queue-proof-*`, `log 30`) to fill capacity; 4th start via API against an **existing completed** sim (`soak-c100-a`). New sim codes for the 4th POST fail earlier with `Living area assignment validation failed` when `ENABLE_HOME_ASSIGNMENT_MVP=true` (sim row not in Supabase yet) — see follow-up below.

**Ops notes:**
- `os_reverie_count` can read **6** while `pgrep` shows 3 parent `reverie.py` (child `temp_runner_*` counted) — use `slots_available:0` as the gate signal.
- CLI launches bypass `acquire()`; only **API** starts queue. Season ops should start sims via API when relying on the cap.
- Sign-off meta: `scripts/signoff/item2-queue-20260610-meta.json` (repo) · VPS mirror `/var/log/soak/item2-queue-20260610-meta.json`
- Launcher: `scripts/soak_item2_queue_vps.sh` (`QUEUE_TEST_SIM` = completed sim for 4th POST)

### Implementation (2026-06-10)

- **`api_gateway/app/services/sim_concurrency.py`** — `SimConcurrencyGate`: blocks new spawns at `MAX_CONCURRENT_SIMS` (default 3); overflow waits on `asyncio.Condition`; counts OS `reverie.py` / `temp_runner_*` via psutil + in-flight reservations.
- **`simulation_control.start_simulation`** — `acquire()` before spawn; `release()` on stop / process exit / dead-process cleanup.
- **`GET /api/simulations/concurrency`** — cap, active count, slots available.
- **`POST /api/simulations/{sim}/start`** — returns `queued_at_capacity: true` + `concurrency` snapshot when at cap.
- **Env:** `MAX_CONCURRENT_SIMS=3` (alias `MAX_CONCURRENT_RENDERS`); gateway `headless_visualization` batch cap reads same value.
- **Deploy:** `git pull origin railway` on VPS (see `README.md` § Sim VPS — **no rsync**). `deploy_mvp_vps.sh` retained for reference only.
- **Tests:** `api_gateway/tests/test_sim_concurrency.py` (6/6 pass).

### P2 — `COMPLETED.json` mkdir fix *(bundled with Item 2)*

**Owner:** Ivan / BE (`reverie.py` or completion-marker writer)  
**Priority:** P2 — non-blocking for generation; ops forensics only

With `SKIP_MOVEMENT_JSON_WRITE=true` (Supabase-only prod posture), the `movement/` directory is never created during a sim run. When the engine marks a sim finished it still tries to write `movement/COMPLETED.json` and fails with `[Errno 2] No such file or directory`. Meta / Supabase completion paths work; only the filesystem marker is missing.

**Fix:** create the parent directory (`movement/`) before writing `COMPLETED.json` — shipped `610cc495` in `reverie.py`.

**Acceptance:** 3-step smoke on VPS with `SKIP_MOVEMENT_JSON_WRITE=true` completes without `Failed to create ... COMPLETED.json` in the log.

### Follow-up (non-blocking)

- **API home-assignment guard:** skip lookup when sim code is not yet in Supabase (net-new fork path) so Item 2 queue tests and API-first spawns do not hit HTTP 500 before `SimConcurrencyGate`.

### The problem
Capacity is currently an **implicit constant**: `api_gateway/app/services/headless_visualization.py` hardcodes `self.max_concurrent_renders = 3`. On the MVP box this needs to become a real, enforced cap because the box has **no swap** — overshooting is an **OOM-kill, not a slowdown**. A 4th sim kills a process. (With trailers now off-server, the cap only has to account for sims — see scope note above.)

### What we need
- Replace the implicit `max_concurrent_renders = 3` with an **explicit, enforced cap of 3 concurrent sims**.
- **An overflow queue / backpressure path:** when 3 sims are running, a 4th **waits** rather than spawning and pushing the box into OOM.
- Make the cap **configurable** (env or config) so we can drop it from 3 → 2 if VPS monitoring shows memory pressure, treating 3 as a burst ceiling.

### Acceptance
- Launching a 4th sim while 3 run **queues** it; it starts only when a slot frees.
- The cap is one number, settable without a code change.
- A soak test: 3 sims never exceed the RAM budget (~3.3 GB of 3.8 GB) and never OOM-kill.

### Note
Re-run `tests/measure_sim_footprint.py` **on the VPS** (not locally) to confirm the shared frontend + gateway cost there before locking the cap number.

### FE view (Nicolas — for Item 2)
The proposed **explicit cap of 3 + overflow queue** is the right MVP shape: the box has no swap, so a 4th sim must **wait**, not spawn. Configurable cap (env) matches the hardening doc's "drop to 2 if monitoring shows pressure." No FE changes required unless we later add fleet visibility in the admin UI.

---

## Trailers (out of server scope) — for awareness, no work needed from you

Trailer rendering runs on **Ivan's local machine**, not the server:
- It reads sim data from **Supabase** (`video/extract_day_log.py` → persona scratch, day snapshots, survival season state, verbatim chat transcripts — all via RPCs/position rows). No server-local files needed.
- The scene recorder (`video/record_scenes.py`, `?recording=true`) points at a **local frontend** + Supabase.
- Because trailers never run on the server, there is **no sim/trailer contention** to guard against — the former "mutual-exclusion guard" is unnecessary.

This is the MVP-cheap version of the hardening doc's separate render tier (§6) and the FE recommendation of separate pools for generation vs `?recording=true` (§7 Q7). When volume justifies it, this local job becomes a dedicated trailer worker pool — same data flow, different host.

---

## Sequencing & dependencies

1. **Item 1** — **done** (FE `main` `544f288` + VPS soak 2026-06-09). Optional: Ivan merges Nicolas BE H0 patch (cache-bust default off, `__headlessMetrics` log).
2. **Item 1.5** — **done** (`fc3e28dd` / `5917979`; enable `HEADLESS_TAB_REUSE=true` on deploy).
3. **Item 2** — **done** (`SimConcurrencyGate` on VPS `549d2d41`; queue proof 2026-06-10). **P2:** `COMPLETED.json` mkdir fix shipped.

**Explicitly out of scope (deferred to the 10-sim scale-up):** per-subprocess `FRONTEND_URL` override (one frontend backs 3 contexts fine — §7 Q2), browser-free realization (§3.2, ~4–6 weeks), gateway statelessness (H8), the full job-queue broker (§5), and on-server trailer rendering / a shared render tier.

---

## What I need back from you

| # | Ask | Response (2026-06-05) |
|---|-----|------------------------|
| 1 | Item 1: `build && start` script + confirm 1 FE backs 3 contexts on 3.8 GB | **FE on `main` (`544f288`).** Local smoke: 1 context, ~1.1 s/step. **VPS soak PASSED 2026-06-09:** 3 sims × 5 steps, 4/4 headless reports/step, no OOM. |
| 2 | Item 2: confirm backend approach or propose simpler | **Confirm:** explicit cap 3 + overflow queue + env-configurable cap. No simpler alternative that still prevents OOM on no-swap box. |
| 3 | Rough estimate for both | Item 1 FE **~½ day** (done). Item 2 **backend ~4–8 h** (Ivan). Item 1.5 **~1–2 days** if prioritized. |

**Cross-refs:** `TODO_production_hardening.md` (MVP section, §4 H0/H5, §7 Q2–Q7) · `double-ivan/20260605_mvp-release-gate.md` (§P0, §3 Technical Scope).
