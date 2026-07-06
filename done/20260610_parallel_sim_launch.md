# Parallel simulation launch — operator runbook & API implementation request

**Owner:** Ivan · **Filed:** 2026-06-10  
**Status:** Operator runbook (validated on VPS 2026-06-10); API section is an **implementation request** (not normative until merged into `sot/sot_api.md`)  
**Box:** Sim VPS `199.80.55.26` — see `README.md` § Sim VPS — generation deploy  
**Related:** `TODO_production_hardening.md` (Phase 0 / H5), `20260609_LIVE_mode.md` (validation sign-offs), `sot/sot_lifecycle.md` §6 (onboarding finalize + `owner_timezone`)

---

## 1. Purpose

Document how to **launch multiple simulations in parallel** on the generation VPS today, and specify the **API/UX work** needed so future runs do not require Supabase SQL or manual `reverie.py` subprocesses.

**Validated 2026-06-10:** two sims in parallel (`20260610-dp8` × 1500 steps + `20260610-dp7b` × 50 steps) with prod headless FE on `:3000`, ~1 GB RAM used.

### Generation speed (measured — reference for planning)

| Context | Wall-clock pace | When measured | Notes |
|---------|-----------------|---------------|-------|
| **Production VPS — full operator runs** | **~7 s/step** | 2026-06-10 | `20260610-dp8` (Survival, 1500-step run): ~6.5–8 s/step mid-run; ~7 s/step overall. Parallel with a second sim did not materially change this. |
| Soak / H0 hardening (3 × 100 steps) | ~0.6–1.1 s/step | 2026-06-08 | Lighter soak profile after tab reuse + prod headless build — **not** representative of full Survival + cognition on the box today. |

**Planning ETAs at ~7 s/step:** 50 steps ≈ **6 min**; 100 steps ≈ **12 min**; 1500 steps (one sim-day) ≈ **2.9 h**. Acceleration is a separate decision — not scheduled yet.

---

## 2. Prerequisites (generation stack)

All must pass before launching sims.

| Check | Command / action | Pass |
|-------|------------------|------|
| API gateway (HTTPS on VPS) | `systemctl is-active api-gateway` | `active` |
| Headless frontend | `systemctl is-active double-front` | `active` |
| FE responds | `curl -m 5 -sf http://127.0.0.1:3000/ && echo OK` | `OK` |
| Gateway responds (HTTPS) | `curl -sk https://127.0.0.1:8001/health` | JSON health |
| Concurrency slots free | `curl -sk https://127.0.0.1:8001/api/simulations/concurrency` | `slots_available` ≥ N |
| Env | `.env.local` from `.env.local.vps-prod` SOT | `FRONTEND_URL=http://localhost:3000`, `MAX_CONCURRENT_SIMS=3`, `SURVIVAL_MODE_ENABLED=true` (when testing Survival), Supabase-first flags |

**Important:** On the VPS, the gateway listens with **TLS**. Use `https://127.0.0.1:8001` or `https://api.ondouble.com:8001` — **not** `http://127.0.0.1:8001` (empty response / JSON parse errors).

**Frontend script:** Use `npm run build:headless` + **`npm run start:headless`** (not plain `npm run start`). Prefer **`double-front.service`** under systemd — see `README.md` § Sim VPS.

---

## 3. Production provisioning order (target UX)

When API gaps below are closed, the intended flow matches onboarding + generation:

```
1. POST /api/simulations/fork          (or UX “Create from baseline”)
2. POST /api/onboarding/{sim}/finalize (board + owner_timezone for LIVE / DP7)
3. POST /api/simulations/{sim}/start   (max_steps, optional survival flag)
```

**2026-06-11:** steps 1 + 3 work end-to-end via API (`POST /fork` → `POST /start` verified in the wild — PL-1/2/3 closed). SQL fork (§4.1) remains a fallback.  
Owner clock: `DEFAULT_OWNER_TIMEZONE=America/New_York` is set in the VPS `.env.local` — every fresh fork anchors to 06:30 EST until finalize/UI sends a per-sim `owner_timezone` (see `20260609_LIVE_mode.md` DP7).

---

## 4. Operator runbook — today (validated)

### 4.1 Fork sim records (Supabase SQL — fallback)

**Preferred since 2026-06-11: `POST /api/simulations/fork`** (shipped; see §6.1 / §8). SQL fallback if the API is unavailable:

```sql
SELECT fork_simulation(
  'base_family_sim',
  '<YYYYMMDD>-<suffix>',           -- e.g. 20260610-dp8
  'Description',
  true,                            -- copy_memories
  false                            -- copy_coords (fresh spawn)
);

-- fork_simulation currently sets status_id = running — reset before API/direct launch:
SELECT update_simulation_status('<YYYYMMDD>-<suffix>', 'stopped');
```

Verify:

```sql
SELECT s.name, ss.name AS status
FROM double.simulations s
JOIN double.simulation_statuses ss ON ss.id = s.status_id
WHERE s.name = '<sim_code>';
```

Expect **`stopped`**, not `running`.

Owner clock (DP7) — **required order:** fork → `set_owner_timezone` → start. Options for step 2:

```sql
SELECT set_owner_timezone('<sim_code>', 'America/New_York');  -- manual SQL
```

Or set `DEFAULT_OWNER_TIMEZONE=<IANA>` in `.env.local` before direct reverie launch — reverie calls the same RPC automatically after fork (skips if already set).

### 4.2 Launch one or more sims (direct reverie — reliable today)

From `/var/www/generative_agents/reverie/backend_server`:

```bash
mkdir -p /var/log/soak

nohup python3 -u -c "
from reverie import ReverieServer
rs = ReverieServer('<sim_code>', '<sim_code>')
rs.start_server(<max_steps>)
" > /var/log/soak/<sim_code>.log 2>&1 &
```

**Parallel example** (2 sims, different codes):

```bash
# Long validation run (e.g. DP8 — 1500 steps ≈ 2.5–3 h at ~7 s/step)
nohup python3 -u -c "
from reverie import ReverieServer
rs = ReverieServer('20260610-dp8', '20260610-dp8')
rs.start_server(1500)
" > /var/log/soak/20260610-dp8.log 2>&1 &

# Short parallel soak (50 steps ≈ 6 min at ~7 s/step)
nohup python3 -u -c "
from reverie import ReverieServer
rs = ReverieServer('20260610-dp7b', '20260610-dp7b')
rs.start_server(50)
" > /var/log/soak/20260610-dp7b.log 2>&1 &
```

**Do not reuse a sim code** that partially ran and crashed (e.g. missing `environment/N.json` on resume). Fork a **fresh code** (e.g. `dp7b`).

**Survival mode:** server-wide `SURVIVAL_MODE_ENABLED=true` in `.env.local` — applies to all runs on the box.

### 4.3 Launch via API (working since 2026-06-11 — PL-1/2/3 closed; engine logs at `/var/log/soak/{sim_code}.log` since PL-4 closed)

```bash
export API="https://api.ondouble.com:8001"

curl -sk -X POST "$API/api/simulations/<sim_code>/start" \
  -H "Content-Type: application/json" \
  -d '{"action":"start","parameters":{"max_steps":100,"fork_from":"<sim_code>"}}'
```

Requires sim row to exist (`POST /fork` or §4.1) and **`stopped`** status. `POST /stop` reliably stops the sim's process even if the gateway lost track of it (PL-10 closed 2026-06-15). Engine log: `tail -f /var/log/soak/<sim_code>.log`.

### 4.4 Monitor

```bash
# Processes
pgrep -af "<sim_code>"

# Logs
tail -f /var/log/soak/<sim_code>.log

# Status (HTTPS)
curl -sk "$API/api/simulations/<sim_code>/status/current" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['current_step'], d['status'], d.get('is_generating'))"

# Supabase step ceiling
# SELECT MAX(step) FROM double.personas_coords WHERE simulation_id = (SELECT id FROM double.simulations WHERE name = '<sim_code>');
```

**Note:** `backend_process_active: false` on `/status/current` is **expected** for direct `reverie` launches — the gateway only tracks API-spawned subprocesses. Trust `is_generating`, `last_generated_at`, step counts, and logs.

#### Live-mode monitoring — two readings that look like faults but aren't

These bite anyone watching a `live_mode` sim during a soak; **do not alert on them.**

- **`status: "completed"` between chunks ≠ the sim ended.** A live sim runs in 60-step chunks (§4.6); when a chunk's subprocess exits, `/status/current` reads `status: "completed"`, `is_generating: false`, `backend_process_active: false` until the scheduler re-wakes it on the next tick. That is the **sleep state**, not a crash or a finished sim — `live.json` correctly stays `status: "running"` throughout (that's the CDN-viewer-facing truth). **Liveness signal:** `live_mode: true` **and** `current_step` advancing across checks spaced wider than the chunk cadence **and** `last_generated_at` recent during a chunk. A genuinely stuck sim = `live_mode: true` but `current_step` flat for many minutes with no wake (and a free concurrency slot). Don't script alerts on `status == completed` for a live sim.

- **The four watermarks drift 1–3 steps apart transiently — that's normal, not incoherence.** `generated edge` ≥ `reveal_step` ≥ `published_step` (sim row) and `live.json latest_step` are snapshots of a moving pipeline read from different sources a beat apart. Each publish tick uploads bundles → uploads the manifest → **updates the row `published_step` last**, so a fresh `live.json latest_step` can sit a few steps **ahead** of the row's `published_step` (observed: manifest 359 vs published 356). Safe direction — bundles are uploaded before the manifest advertises them; the row watermark just trails. They converge each tick. **What to actually flag:** `published_step` *persistently* falling further behind `live.json latest_step` over time (points at `advance_published_step`), not a few-step transient. During catch-up `reveal_step` ≈ the generation edge (both far below owner-now); the reveal cap only binds once generation reaches owner-local now.

### 4.5 RAM guardrail (3.8 GB box)

| Sims running | Rough RAM |
|--------------|-----------|
| 1 | ~0.8 GB peak |
| 2 | ~1.6 GB peak |
| 3 | ~2.4 GB peak + FE + gateway ≈ 3.3 GB |

Stay at **`MAX_CONCURRENT_SIMS=3`**. Watch `free -h` during parallel runs.

### 4.6 Survival + live-enrolled end-to-end test (one recipe — added 2026-06-13)

Use this to validate the full LIVE/CDN/chat stack on a production-representative (Survival) sim. **Live-enroll, do NOT call `/start`** — the chunk scheduler wakes it. A plain direct-reverie run (§4.2) tests survival + generation only; it does **not** exercise the chunk scheduler, reveal-gated CDN publish, 6a artifacts, P3-1 chat reaction, or PL-12.

```bash
export API="https://api.ondouble.com:8001"
SIM="20260613-1"   # fresh YYYYMMDD-N

# 0. Pre-flight — Survival ON is the switch; engine reads it at process start:
grep SURVIVAL_MODE /var/www/generative_agents/.env.local   # MUST show SURVIVAL_MODE_ENABLED=true
curl -sk "$API/health"
curl -sk "$API/api/simulations/concurrency"                 # need a free slot (cap 3)

# 1. Fork — response MUST contain "owner_timezone":"America/New_York" (PL-11):
curl -sk -X POST "$API/api/simulations/fork" -H "Content-Type: application/json" \
  -d "{\"sim_code\":\"$SIM\",\"baseline\":\"base_family_sim\",\"copy_memories\":true,\"copy_coords\":false}"

# 2. Enroll live — response MUST show "live_mode":true AND "sprite_manifest_published":true (6a):
curl -sk -X POST "$API/api/simulations/$SIM/live" -H "Content-Type: application/json" \
  -d '{"enabled": true}'

# 3. Watch the scheduler wake it (~60s) and confirm Survival initialised:
tail -f /var/log/soak/$SIM.log    # expect "SURVIVAL MODE: Initialized with 4 players"
```

**End-to-end checks (first ~hour, no need to wait for the full season):**
- **6a sprite-manifest:** `GET {SUPABASE_URL}/storage/v1/object/public/step-bundles/$SIM/sprite-manifest.json` → **200** (use GET, not HEAD).
- **CDN publish + reveal cap:** `…/$SIM/live.json` → `latest_step` advances, never past owner-local now; a step beyond the edge 404s.
- **Prod CDN viewer:** `https://double-front.vercel.app/simulations/$SIM` (prod is CDN-served).
- **P3-1 chat → behavior:** send a mundane chat (request anchored ~2 sim-h ahead) and an urgent one to persona `Ivan` (`POST $API/api/simulations/$SIM/personas/Ivan/chat`); the inbox is checked every step, so the reaction lands within the current/next chunk. Write down the step numbers.
- **PL-12:** when done, un-enroll → response carries `final_manifest_status`; `$SIM/live.json` flips to a terminal status.

**Full season + 6a highlights run over real time:** Survival eliminations are 20:00-sim-time-gated and day 1 is the grace day, so the first elimination and the first `highlights/{day}.json` (publishes at a sim-day close) land ~1–1.5 real days out at the live edge. Watch live over days, or check `?source=gateway&raw=1` for the freshest steps, or un-enroll and analyze later.

```bash
# Wrap up (Survival flag can stay true — it's the normal production state):
curl -sk -X POST "$API/api/simulations/$SIM/live" -H "Content-Type: application/json" \
  -d '{"enabled": false}'
```

If you just want a **Survival season to completion for analysis** (no LIVE machinery), use the direct-reverie blast in §4.2 with a high step cap (e.g. `start_server(6000)`); it auto-stops at a winner. To stop early, `POST /{sim}/stop` (PL-10 closed 2026-06-15 — now finds direct/untracked processes too; manual `pkill -f $SIM` + `update_simulation_status('$SIM','stopped')` remains a fallback).

### 4.7 Driving §4.6 from Windows PowerShell (operator's local machine — added 2026-06-13)

> ⚠️ **Run these in a PowerShell window on your own Windows machine — NOT inside an `ssh` session on the VPS.** The VPS shell is bash; pasting `$VAR = "x"` there gives `=: command not found`. If you're already SSH'd into the box (`root@vps-244496:#`), use the **bash** recipe in §4.6 instead — that's how the earlier runs were driven.

The fork / enroll / status / chat calls are HTTPS to the gateway — run them **locally in PowerShell** with `Invoke-RestMethod` (it parses the JSON reply into an object, so you read fields with `.field`). Only two steps touch the Linux VPS (the Survival flag and the engine log) — those go over **SSH**. Replace the SSH target with your VPS login (`root@199.80.55.26`).

> **TLS/PowerShell notes:** `api.ondouble.com` has a valid cert, so no skip flag is normally needed. If a call fails with a cert error on **PowerShell 7**, add `-SkipCertificateCheck`. On **Windows PowerShell 5.1** the simplest fallback is real curl: `curl.exe -sk ...` exactly like the §4.6 bash (mind that JSON bodies need single quotes). `Invoke-RestMethod` throws on 404/400 — for the CDN existence checks, an error just means "not published yet".

```powershell
# --- 0. Session setup (one time per window) ---
$API = "https://api.ondouble.com:8001"
$SB  = "https://jawqllnvvlmosxlwjrei.supabase.co/storage/v1/object/public/step-bundles"  # = SUPABASE_URL/.../public/step-bundles
$SIM = "20260613-1"                                  # fresh YYYYMMDD-N
$VPS = "root@199.80.55.26"                            # your VPS SSH target

# --- 1. Pre-flight ---
ssh $VPS "grep SURVIVAL_MODE /var/www/generative_agents/.env.local"   # MUST be SURVIVAL_MODE_ENABLED=true
#   if it says false:  ssh $VPS "sed -i 's/^SURVIVAL_MODE_ENABLED=false/SURVIVAL_MODE_ENABLED=true/' /var/www/generative_agents/.env.local"
Invoke-RestMethod "$API/health"
Invoke-RestMethod "$API/api/simulations/concurrency"  # need a free slot (cap 3)

# --- 2. Fork (must come back owner_timezone = America/New_York) ---
$forkBody = @{ sim_code=$SIM; baseline="base_family_sim"; copy_memories=$true; copy_coords=$false } | ConvertTo-Json
$fork = Invoke-RestMethod -Method Post -Uri "$API/api/simulations/fork" -ContentType "application/json" -Body $forkBody
$fork.owner_timezone        # -> America/New_York

# --- 3. Enroll live (do NOT call /start — the scheduler wakes it) ---
$enroll = Invoke-RestMethod -Method Post -Uri "$API/api/simulations/$SIM/live" -ContentType "application/json" -Body (@{ enabled=$true } | ConvertTo-Json)
$enroll.live_mode                  # -> True
$enroll.sprite_manifest_published  # -> True   (6a check, for free)

# --- 4a. Watch progress: poll status every 30s (Ctrl+C to stop) ---
while ($true) {
  $s = Invoke-RestMethod "$API/api/simulations/$SIM/status/current"
  "{0}  step={1}  day={2}  gen={3}  reveal={4}  pub={5}  {6}" -f `
    (Get-Date -Format HH:mm:ss), $s.current_step, $s.current_day_number, $s.is_generating, $s.reveal_step, $s.published_step, $s.status
  Start-Sleep 30
}

# --- 4b. Watch progress: live engine log (separate window; confirms Survival init) ---
ssh $VPS "tail -f /var/log/soak/$SIM.log"   # expect: SURVIVAL MODE: Initialized with 4 players

# --- 4c. Watch progress: CDN manifest + 6a artifact (latest_step climbs; sprite-manifest 200) ---
Invoke-RestMethod "$SB/$SIM/live.json"
Invoke-RestMethod "$SB/$SIM/sprite-manifest.json"   # errors until the enroll publish lands; then returns the persona map
#   Viewer (browser): https://double-front.vercel.app/simulations/<SIM>   (add ?source=gateway&raw=1 for freshest steps)

# --- 5. (optional) P3-1 chat test — note current_step first, then send ---
(Invoke-RestMethod "$API/api/simulations/$SIM/status/current").current_step
Invoke-RestMethod -Method Post -Uri "$API/api/simulations/$SIM/personas/Ivan/chat" -ContentType "application/json" `
  -Body (@{ message="Guests are coming at 11:30 — please tidy the living room and prepare some snacks." } | ConvertTo-Json)

# --- 6. Wrap up (Survival flag can stay true; un-enroll fires PL-12 terminal manifest) ---
$end = Invoke-RestMethod -Method Post -Uri "$API/api/simulations/$SIM/live" -ContentType "application/json" -Body (@{ enabled=$false } | ConvertTo-Json)
$end.final_manifest_status   # -> completed/stopped
```

---

## 5. Known gaps (bugs & debt) — implementation backlog

These were hit during the 2026-06-10 VPS session. Track in `TODO_production_hardening.md` until closed; **normative API behaviour** belongs in `sot/sot_api.md` once shipped.

| ID | Issue | Impact | Proposed fix |
|----|--------|--------|--------------|
| ~~**PL-1**~~ | ~~`POST /start` on a **new sim code** runs living-area guard before sim exists~~ | — | **CLOSED 2026-06-11** — API-only cold-start (`POST /fork` → `POST /start`) verified in the wild |
| ~~**PL-2**~~ | ~~`fork_simulation` RPC sets **`status = running`** immediately~~ | — | **CLOSED 2026-06-11** — verified with PL-1 |
| ~~**PL-3**~~ | ~~**No `POST /api/simulations/fork`**~~ | — | **CLOSED 2026-06-11** — endpoint shipped (merged `7694f968`); SQL path in §4.1 kept as fallback |
| ~~**PL-4**~~ | ~~API-spawned reverie engine output invisible to operators~~ | — | **CLOSED 2026-06-11** — config, not code: `SIM_LOG_DIR=/var/log/soak` set in `.env.local` + gateway restart; verified live (`tail -f /var/log/soak/20260611-3.log` streamed engine output on the scheduler-spawned start). Engine stdout+stderr land in `{SIM_LOG_DIR:-./logs/sims}/{sim_code}.log`; failed tasks return `error_log_tail` (last 40 lines) |
| **PL-5** | Manual / `nohup` reverie **not reflected** in `backend_process_active` | Misleading ops signals | Optional: detect OS processes by sim_code in metadata RPC, or document as API-managed-only |
| ~~**PL-6**~~ | ~~**Resume without local env JSON** → `FileNotFoundError` on `environment/N.json`~~ | — | **CLOSED 2026-06-11** — resume now loads last completed step from Supabase and materializes `environment/N.json` (merged `7694f968`) |
| **PL-7** | VPS gateway **HTTPS-only**; docs/examples used `http://127.0.0.1:8001` | Empty curl / JSON parse errors | Document TLS; optional local HTTP for dev only |
| **PL-8** | **`GET /tasks/{id}`** in-memory only | Task status 404 after gateway restart | Persist tasks or return sync errors in `/start` response body |
| **PL-9** | No **`POST /batch/start`** | N× manual curl/SQL for parallel runs | Batch endpoint respecting `SimConcurrencyGate` |
| ~~**PL-10**~~ | ~~**`POST /{sim}/stop` failed** on an API-started sim; operator had to kill the pid manually + reset the row~~ (hit 2026-06-11) | — | **CLOSED 2026-06-15** (`ivan/pl10-stop-via-api`): `/stop` now also locates the sim's process by an OS scan for `temp_runner_{sim}.py` (not just the in-memory registry), so it stops sims after a gateway restart / direct launch / scheduler chunk. No process found → status left unchanged (SOT policy, `sot_api.md` §1); live sims still stopped by un-enroll. The brittle `list_running_simulations` pre-check (the original 500 source) is gone. Contract: `sot_api.md` §1 (Stop Simulation) |

| ~~**PL-12**~~ | ~~Un-enroll/abort leaves a frozen `live.json`~~ (found by FE 2026-06-12, `20260612_FE_phase2_handover.md` §8.6) | — | **CLOSED 2026-06-12** (`21d0793c`, deployed + verified on VPS: un-enroll `20260612-1` → `final_manifest_status: completed`): `POST /live {"enabled": false}` patches the manifest with a terminal status. Design note: scheduler-side detection is impossible — `completed` is the normal between-chunk sleep state for live sims — so **un-enroll is the end-of-feed signal; abort procedures must un-enroll first**. Contract: `sot/sot_api.md` §9 |

**Watch items (2026-06-11):**

- ~~**PL-11 — owner-tz bootstrap skipped on API/scheduler starts**~~ — **CLOSED 2026-06-11** (`1762fca7`, deployed same evening). Root cause: the engine's new-sim check tests local-folder existence, but `fork_from == sim_code` starts materialize the folder from Supabase first, so fresh forks classified as continuations and skipped the tz bootstrap (hit `20260611-1`, `20260611-3`). Fix: `POST /fork` now anchors `owner_timezone` itself (request field or `DEFAULT_OWNER_TIMEZONE` env) right after the fork RPC and reports it in the response. Guardrail stands: never enroll a sim whose `owner_timezone` is null.
- **Deploy gotcha** — the VPS start snippet only launches uvicorn if port 8001 is free; after `git pull` you must kill the old gateway process explicitly or it keeps serving stale code (bit us 2026-06-11). Fix the snippet or add to the deploy checklist.

---

## 6. Target API (implementation request)

**Promote to `sot/sot_api.md` when implemented.** Shapes are illustrative; final contract is owned by API SOT.

### 6.1 `POST /api/simulations/fork`

Create a sim from a baseline without starting generation.

**Request:**

```json
{
  "sim_code": "20260610-test-1",
  "baseline": "base_family_sim",
  "description": "Optional",
  "copy_memories": true,
  "copy_coords": false
}
```

**Response:** `201` — sim metadata, `status: "stopped"`, fork stats (personas copied, effective_curr_time, etc.).

### 6.2 `POST /api/simulations/{sim_code}/start` (behaviour fixes)

Existing endpoint; fix **PL-1**, **PL-2**, **PL-4**. Body unchanged:

```json
{
  "action": "start",
  "parameters": {
    "max_steps": 1500,
    "fork_from": "20260610-dp8"
  }
}
```

**Rules:**

- If sim does not exist and `fork_from` is a baseline → **fork then start** in one task (or 409 “call /fork first” — pick one and document).
- If `status === "running"` but no managed process and `current_step === 0` → treat as **stale fork status**, proceed.
- On failure, response includes **`error_log_tail`** or task payload with stderr excerpt.

### 6.3 `POST /api/simulations/batch/start`

**Request:**

```json
{
  "runs": [
    { "sim_code": "20260610-a", "fork_from": "base_family_sim", "max_steps": 50 },
    { "sim_code": "20260610-b", "fork_from": "base_family_sim", "max_steps": 1500 }
  ]
}
```

**Response:** `{ "tasks": [...], "queued_at_capacity": false, "concurrency": { ... } }`

### 6.4 `GET /api/generation/health`

Stack check for ops / UX “Launch sim” gate.

**Response:**

```json
{
  "frontend_up": true,
  "frontend_url": "http://localhost:3000",
  "gateway_up": true,
  "headless_build": true,
  "concurrency": { "cap": 3, "active": 1, "slots_available": 2 }
}
```

### 6.5 Owner timezone (existing)

**`POST /api/onboarding/{sim_code}/finalize`** with `owner_timezone` (requires `ENABLE_ONBOARDING_HOST=true`) — production path for DP7. See `sot/sot_lifecycle.md` §6.

Optional later: **`POST /api/simulations/{sim_code}/owner-timezone`** for CLI-only clock anchor without full board.

---

## 7. Validation cross-refs

| Goal | Sim type | Steps | Checklist |
|------|----------|-------|-----------|
| Parallel infra soak | Any baseline fork | 50–100 each × 2–3 | Processes up, RAM OK, steps advance |
| **DP8-QA-1** Survival grace day | `base_family_sim` + Survival env | ~1500 | Day 1 no votes/challenges; day 2 directive — `20260609_LIVE_mode.md`, `sot/sot_survival.md` |
| **DP7 live clock** | finalize + `owner_timezone` | ~50 | `owner_timezone` set, 06:30 owner-local — blocked on FE finalize |
| **DP7-BE-4** Episode cron | — | — | Deferred (scheduler) |

Analysis after long Survival run:

```bash
cd /var/www/generative_agents
python3 tests/analyze_sim_survival.py <sim_code> --source supabase --max-steps 1500
```

---

## 8. CLI examples (after API ships)

```bash
# Health
curl -sk "$API/api/generation/health" | jq .

# Fork + start (future)
curl -sk -X POST "$API/api/simulations/fork" -H "Content-Type: application/json" \
  -d '{"sim_code":"20260611-1","baseline":"base_family_sim","copy_memories":true,"copy_coords":false}'

curl -sk -X POST "$API/api/simulations/20260611-1/start" -H "Content-Type: application/json" \
  -d '{"action":"start","parameters":{"max_steps":100,"fork_from":"20260611-1"}}'

# Batch (future)
curl -sk -X POST "$API/api/simulations/batch/start" -H "Content-Type: application/json" \
  -d '{"runs":[{"sim_code":"20260611-a","fork_from":"base_family_sim","max_steps":50},{"sim_code":"20260611-b","fork_from":"base_family_sim","max_steps":100}]}'
```

---

## 9. Doc maintenance

| When | Update |
|------|--------|
| API endpoints ship | **`sot/sot_api.md`** — normative contracts for §6 |
| Onboarding UX ships | **`sot/sot_lifecycle.md`** §6 — finalize + start order |
| Phase 0 gaps closed | **`TODO_production_hardening.md`** — strike PL-* / B2 caveats |
| Operator steps change | **This doc** + **`README.md`** § Sim VPS post-deploy smoke |
