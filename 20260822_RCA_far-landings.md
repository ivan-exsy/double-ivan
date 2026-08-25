# RCA — Refused far landings / walk loop (`20260822-2`)

**Date:** 2026-08-22  
**Status:** Run stopped. Not a patch ticket. Not SOT.  
**Tip:** `fcf5717f` (start-jump persist) on Survival `059e3f0e`  
**Sim:** `20260822-2` · soul15 · Survival sprint · diagnostic off · stopped @ step **46** (Premiere **07:16**)  
**Checklist:** `20260821_checklist.md` — **does not pass**

---

## Verdict

The persist rule is doing its job. The walk loop is not.

People do **not** stay at a blink in the saved world. The viewer still reports them at **home / spawn**. Most steps then have only **0–5 of 15** valid walks. That fails the ship rule for this tip.

**Smoke 2026-08-23:** `20260823-1` on tip **`53ace4c5`** with tab reuse **off** and live inject path strip: **30/30** steps, rejects **0**, STRICT **0**, saved walks **15/15** every step. Keep tab reuse off for the next long score until on-box FE snaps sprites.

---

## What we scored

| Gate | Bar | `20260822-2` @ 46 | Pass? |
|------|-----|-------------------|-------|
| Early smoke — no STRICT storm | optional, but required for a score run | **34** STRICT from step **5** | **FAIL** |
| Far landing refused | guard must fire | **22** rejects, jump **7–31**, `max=6` | **PASS** (guard) |
| Headless 15/15 after a blink | required | typical **0–5/15**; never 15/15 after step 4 | **FAIL** |
| FE stops far / home reports | required for loop | reports sit near **spawn**, not this-step start | **FAIL** |
| Survival gather | engine day ≥2 | Premiere 07:16 | **N/A** |
| Apt / process death | `20260822-1` class | runner force-stopped on purpose | n/a |

Traceback: **1** — asyncio “event loop is closed” on stop. Not the movement defect.

---

## What the village did

Step **1** was healthy: all **15** walks were saved. Paths were short (≤7 points).

From step **5** the pattern is the same for six people (Nick, Max, Vince, Andrew, Irene, Owen):

- Backend start is the real last tile (Nick **61,65**, Vince **119,22**, Max mid-walk **108,33**).
- Frontend report is a tile next to **that person’s home** (Nick **52,71**, Vince **95,29**, Max **109,55**, Andrew **17,19**, Irene **124,50**, Owen **57,16**).
- Jump is **7–31** tiles. Backend refuses. Saved position does **not** jump.
- The same people fail again on the next step. Frontend is still walking from home.

Nick at step 5 is the cleanest case: backend says **stay** at **61,65** (already in the zone). Frontend reports **52,71** (home). That is not “walked too far on a long path.” The sprite never left home.

Most STRICT lines are **missing reports**, not rejects. Only 1–2 names show `implausible_teleport`. The rest have no accepted walk at all. Saved `actual_path` counts match that: 15 → 12 → 5 → 2.

Headless still says “movements completed” every step. The tab is **reused** from step 2 (`tab_reused=True`). Walk time later stretches to **9–16 s**. Some steps finish in **1 ms** (no real walk).

Backend then prints “continue on last good tile” and the clock keeps moving. So the run looks alive while almost nobody has a valid walk.

---

## Inject check (2026-08-22)

On-box `GET /api/simulations/20260822-2/step/5` vs movement JSON:

- Nick start/movement **(61, 65)** → API pixels **(1968, 2096)**. Correct stay. **Not home.**
- Tile → pixel math matches (`*32+16`).
- VPS FE is `next start` on `127.0.0.1:3000`, git **`e5b1868`** (2026-06-28, same as `origin/main`), build 2026-08-21. Tab reuse on.

So the backend **did** inject the right start. The local headless page still reported home.

Two leaks still in **this** project (not Vercel):

1. The step API copies leftover `actual_path` into `path` for replay. Headless uses that same endpoint. Max step 5 got a **home-origin** path injected even though live intent is empty-path.
2. Tab-reuse prepare only clears reports. It does not move sprites. Snap uses `setPosition`, which PathFollower can ignore.

## Root cause

Two defects, one product failure.

### 1. On-box headless walk origin is home, not this-step start (primary)

The live frontend keeps one browser tab across steps. Sprites are not rebuilt from the backend start tile each minute.

If the sprite is still at spawn, the next walk starts at home and the report is a home tile. Backend start is already blocks away. The new ≤6 rule correctly refuses that report.

This is the same class as the late home-snap on `20260822-1` (steps 388–400). It now starts at **step 5**, so we cannot wait it out.

The 6-tile path clamp is not the miss here. Nick was told to stay. The report was still home.

### 2. A refused report zeros the rest of the step (amplifier)

A reject does not become the next start (correct). It also does **not** count as a valid “I stayed here” walk. Required bar is **15/15**. One home report → STRICT fail. Many people then have no saved path, so the next minute has even fewer reports.

Persist stays honest. The loop does not.

This is **not**:

- Ubuntu auto-install (locked this session)
- `HEADLESS_STRICT_ABORT` (log says abort=False; run was not killed by STRICT)
- Local vs VPS env as the first cause (same tip, same home-report class as 22-1)
- A reason to loosen the 6-tile persist rule

---

## Suggested fixes

Do **not** loosen start ≤ 6. Do **not** resume `20260821-1`, `20260822-1`, or `20260822-2`.

### A — Frontend: snap to this-step start, then walk (must)

At the start of every headless step, put the sprite on the backend start tile. Pathfind from that tile. Report only the last tile of a walk of at most 6. Never report spawn.

**Why first:** Fixes the village the viewer sees. Without this, every new run will fail the same way, earlier or later.

**Cost / risk:** Frontend change. Needs a short headless smoke (50 steps, 15/15, zero home reports). Medium risk if we snap in the wrong unit (tiles vs pixels).

### B — Backend: refuse = stay here, and count it (should, small)

When a report is farther than 6, accept a stay at the start tile for that step. Next start stays put. The step can still be 15/15.

**Why:** One leftover blink must not wipe the other 14 walks. Matches the product rule we already wanted: people stay put after a bad blink.

**Cost / risk:** Small backend change. Does **not** replace A. Headless pictures can still show a home blink until A ships.

### C — Do not do

| Option | Why not |
|--------|---------|
| Lower the 15/15 bar | Hides a dead walk loop |
| Turn STRICT abort on | Kills the run; does not fix origin |
| Turn tab reuse off and re-score | Slower; may mask sprite drift; does not prove A |
| Another 2600-step fork on this tip | Will fail the same checklist |

### Recommend

Ship **A + B**. Smoke 50–100 steps. Only then fork a new Survival score (`20260823-1`). Keep gather for engine day 2. Keep S1 later.

---

## Stop record

- Force stop `20260822-2` at **2026-08-22T23:18:31Z**
- Status `stopped` · `is_generating=false` · last step **46**
- Python runner **45888** gone
- Gateway still up (do not restart it)

Status may still show `backend_process_active` while an SSH check is running. Trust the Python runner, not that flag.
