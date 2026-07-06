# VPS Generation Deploy Topology — Sim Box (`199.80.55.26`)

> **Date:** 2026-06-09 · **Revised:** 2026-06-10 (root-cause + deploy ground rules)  
> **Status:** Authoritative for production **generation** on the 3.8 GB sim VPS.  
> **Supersedes:** The mistaken assumption that headless generation can target Vercel (`https://double-front.vercel.app`) instead of a local prod FE on `:3000`.

---

## Root cause (2026-06-09 incident)

The P0 symptoms were **ops/configuration**, not standing BE/Supabase defects:

| Symptom | Cause |
|---|---|
| Ghost duplicate uvicorn on `:8001` | Manual `uvicorn` start during soak (not systemd) |
| `.env.local` clobbered (Vercel `FRONTEND_URL`, wrong flags) | Soak operator copied **local laptop env** over prod — mitigated by `.env.local.vps-prod` SOT + timestamped backup rule |
| Headless dead (`movement_reports_handled: 0`) | Soak operator's shell-owned FE on `:3000` was **killed when they stepped off** — dependency left with the person, not a code regression |
| Unknown code on disk (e.g. incomplete `main.py`) | Deploy used **`rsync` from laptop**, not `git pull` — can overwrite tracked files silently; git won't warn like a merge would |

**P0-1 (memory)** was a false alarm on investigation: keys and RPCs were fine once env was read correctly.

**Prior soak pass (2026-06-09 a1/b1/c1) is invalidated** for sign-off — it ran on rsync'd code, env overlay, parallel manual processes, not the locked production configuration.

---

## Executive summary

| P0 | Verdict | Action |
|---|---|---|
| **P0-1 Memory writes** | **Closed** | No BE change. Keys (`sb_secret_…`), agent lookup, and `dbl_store_memory_dev` all verified for `base_family_sim` personas. Soak log: zero `Memory store failed`. |
| **P0-2 Headless movement** | **Closed** (2026-06-09 sign-off) | Local prod FE on `:3000` via **systemd** (`double-front.service`). `FRONTEND_URL=http://localhost:3000`. |

**Hard rule:** Headless **generation** requires the **local** prod frontend service. The **Vercel** deployment serves end-user playback only — HTTP 200 from Vercel does **not** mean the headless movement loop is engaged.

---

## Deploy topology

```
┌─────────────────────────────────────────────────────────────────┐
│  Sim VPS (199.80.55.26) — GENERATION                           │
│                                                                 │
│  reverie.py ──Playwright──► double-front.service (:3000)       │
│       │                         │                               │
│       │                         └── movement + observations     │
│       │                              POST back to API           │
│       └── RPC ──► Supabase (memory, coords, scratch)           │
│                                                                 │
│  api-gateway.service (:8001 TLS) ◄── headless movement reports │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│  Vercel (double-front.vercel.app) — PLAYBACK ONLY              │
│  End users, landing, browser viewer — NOT sim generation       │
└─────────────────────────────────────────────────────────────────┘
```

### Why Vercel cannot drive generation

1. **Baked env at build time** — `NEXT_PUBLIC_*` (API gateway URL, headless flags, speed multiplier) is fixed in the Vercel build. The VPS headless loop must talk to **this box's** API gateway (`localhost:8001` or `api.ondouble.com`), not whatever the Vercel bundle was built with.
2. **Movement report path** — Playwright runs on the VPS, executes `__executeMovementsForStep`, and posts movement reports to the **local** API gateway. A remote Vercel page does not participate in that loop.
3. **Evidence** — Passing 3-sim soak (2026-06-09) used `FRONTEND_URL=http://localhost:3000` + `npm run start:headless`. Re-pointing at Vercel with no local FE yielded `movement_reports_handled: 0` and `headless_validation_ms: 0`.

---

## Required systemd services (generation box)

Both services must be **systemd-managed** — no manual shell-owned `uvicorn` or `npm start` (avoids ghost processes like the 2026-06-09 duplicate listener).

| Unit | Working dir | Purpose |
|---|---|---|
| `api-gateway.service` | `/var/www/generative_agents/api_gateway` | REST + WebSocket; TLS on `:8001` |
| `double-front.service` | `/var/www/double-front` | Prod `next start` headless FE on `:3000` |

### `double-front.service` (install once)

Adjust `ExecStart` if `npm` is not `/usr/bin/npm` (`which npm` on box).

```ini
[Unit]
Description=Double Frontend (headless prod, :3000)
After=network-online.target

[Service]
Type=simple
WorkingDirectory=/var/www/double-front
ExecStart=/usr/bin/npm run start:headless
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

```bash
sudo cp /var/www/generative_agents/scripts/deploy/double-front.service /etc/systemd/system/
# or: sudo bash /var/www/generative_agents/scripts/deploy/install-double-front-service.sh
sudo systemctl daemon-reload
sudo systemctl enable --now double-front.service
sleep 10
curl -s -o /dev/null -w "FE HTTP:%{http_code}\n" http://localhost:3000/
```

`api-gateway.service` already uses `ExecStartPre=pkill` to prevent duplicate uvicorn — confirm exactly **one** process before smoke: `pgrep -af uvicorn`.

---

## Env SOT — `.env.local` / `.env.local.vps-prod`

**Backup before any edit.** `.env.local.vps-prod` is the canonical snapshot; keep it aligned with generation reality.

### Required for generation (sim VPS)

```bash
FRONTEND_URL=http://localhost:3000          # NOT Vercel
API_GATEWAY_URL=https://api.ondouble.com    # or http://localhost:8001 for local-only tests
ENABLE_HEADLESS_VALIDATION=true
HEADLESS_MOVEMENT_ENABLED=true
HEADLESS_BLOCKING_MODE=true
SKIP_ENV_JSON_WRITE=false                   # required for multi-step progression
```

### Keys (verified 2026-06-09)

- Use Supabase **new-format** secrets (`sb_secret_…` service, `sb_publishable_…` anon).
- `DBL_WORKER_KEY` may equal `SUPABASE_SERVICE_ROLE_KEY` — both valid on this box.
- **Diagnose keys with Python `dotenv_values()`** — never `source .env.local` in bash (truncates / misreports lengths).

### Wrong snapshot to fix

If `.env.local.vps-prod` has `FRONTEND_URL=https://double-front.vercel.app`, that was a **playback-oriented** mistake for generation. Update the SOT to `http://localhost:3000`.

After env change: `sudo systemctl restart api-gateway` (if gateway reads env at start).

---

## Deploy ground rules (team)

| Rule | Detail |
|---|---|
| **No rsync to VPS** | Deploys are **`git pull` only** (BE + FE). Rsync from a laptop can silently diverge from `origin/railway` / `main` with no merge warning. |
| **No env clobber** | Never copy a developer's local `.env.local` over prod. Use `.env.local.vps-prod` SOT; timestamped backup before any edit. Personal overrides → separate overlay file, not prod SOT. |
| **No manual processes** | Gateway + FE = **systemd only**. No parallel manual `uvicorn`, `npm start`, or soak-owned FE that dies when the operator logs off. |
| **Code integrity before smoke** | Run the check below; restore clean tree if tracked files differ from remote. |

---

## Code integrity check (before sign-off smoke)

Run **before** the 3-step smoke. We cannot assume on-disk code matches `railway @ 5a0f7da4` after rsync deploys.

```bash
cd /var/www/generative_agents
git fetch origin
git status --short              # expect empty (besides known untracked)
git diff --stat origin/railway  # expect no output

cd /var/www/double-front
git fetch origin
git status --short
git log --oneline -1            # record for sign-off
```

If either repo shows **modified tracked files**: inspect, then clean restore (`git checkout -- .` after confirming nothing valuable is uncommitted) or `git pull` to known good ref — **do not trust rsync'd content**.

---

## Generation box deploy protocol (BE + FE)

The sim VPS is **not** a backend-only deploy target. Headless generation needs **both** repos at known commits. Ops runbook: **`README.md` § Sim VPS — generation deploy (operators)**.

### Which deploy path?

| Change touches | Action |
|---|---|
| `generative_agents` only | BE pull + restart `api-gateway` if gateway/env changed |
| `double-front` only | FE pull + `npm ci && npm run build:headless` + restart `double-front` |
| Both (movement, headless, paired flags) | FE deploy then BE deploy (or both before smoke) |

### Backend deploy

```bash
cd /var/www/generative_agents
git fetch origin && git pull origin railway
git diff --stat origin/railway    # expect no output
sudo systemctl restart api-gateway.service   # if api_gateway/ or .env.local changed
pgrep -af uvicorn                 # exactly one systemd-owned process
```

`reverie.py` loads on next sim start — no restart needed for cognition-only BE changes.

### Frontend deploy (generation dependency)

Because generation depends on the **local** FE build, every FE deploy to the sim VPS must be explicit:

1. **Record current commit** before change:  
   `git -C /var/www/double-front log --oneline -1`
2. **`git pull`** on `main` — **not rsync**
3. **Rebuild** (`NEXT_PUBLIC_*` is baked at build time):  
   `npm ci && npm run build:headless`
4. **Restart** FE service:  
   `sudo systemctl restart double-front.service`
5. **Record new commit** in sign-off / soak meta
6. Smoke: `curl -sf http://localhost:3000/` → 200

Pin **both** FE + BE commits in soak logs and release gate notes.

---

## Sign-off sequence (owners)

### 1. Ivan — production-generation sign-off

**Status: SIGNED OFF 2026-06-09** — smoke `signoff-20260609-2350` · meta: `/var/log/soak/signoff-20260609-2350-meta.json`

| Artifact | Value |
|---|---|
| BE commit | `5a0f7da4` (`origin/railway`) |
| FE commit | `21371fa` (`origin/main`) |
| Headless | `reports_submitted: 4` on steps 0–2 |
| Memory failures | 4 × transient `Server disconnected` (not permission/key defect) |

Steps taken: code integrity → `double-front.service` → env SOT → 3-step smoke → meta file.

### 2. Nicolas — Item 2 soak re-run (after Ivan sign-off)

Re-run on the **signed-off config** only:

- Git-pulled code (no rsync)
- No prod env edits (overlay file if personal values needed; timestamped backup if anything touches prod)
- Systemd gateway + FE only (no manual processes)

Soak results are meaningful **only** on the configuration that will run production — the re-run is not punitive, it re-establishes evidence on the locked stack.

---

## Production-generation sign-off checklist

Run after code integrity + P0-2 restore (local FE systemd + env). Fresh 3-step smoke from a `base_family_sim` fork.

### Infrastructure (must pass)

| Check | Expected |
|---|---|
| `git diff --stat origin/railway` (BE) | no output |
| `git status --short` (BE + FE) | clean tracked tree |
| `pgrep -af uvicorn` | exactly 1 (systemd-owned) |
| `curl localhost:3000` | 200 |
| `systemctl is-active double-front` | active |
| FE + BE commits recorded | meta JSON or soak log header |

### Headless + movement (authoritative grep — do **not** rely on `OBS_PIPE_STEP_SUMMARY` alone)

`OBS_PIPE_STEP_SUMMARY` can show `movement_reports_handled: 0` and `headless_validation_ms: 0` even when headless succeeded (direct API report submission path; step profiler counters not attached in some runs). **Use these instead:**

```bash
LOG=/var/log/soak/<sim_code>.log
grep "reports_submitted" "$LOG"          # expect 4 per step (family sim)
grep "Headless execution completed" "$LOG"  # expect one line per step 0..N-1
ls storage/<sim_code>/rendered/step-*.png   # screenshots prove Playwright ran
grep 'metric_group.*store.*status.*ok' "$LOG"  # Supabase coord writes
```

| Check | Expected |
|---|---|
| `reports_submitted` per step | = persona count (4 for `base_family_sim`) |
| `Headless execution completed` | one per step |
| Rendered PNGs | one per step |
| Steps complete without stall | 3/3 (or target N) |

### Memory (monitor, not a standing config gate if probes passed)

| Check | Expected |
|---|---|
| Isolated `dbl_store_memory_dev` probe | OK (run before smoke) |
| `Memory store failed` in smoke log | **0 ideal**; transient `Server disconnected` under parallel load has been observed — investigate if repeated, not the old P0-1 permission bug |

### FE git access on VPS

`generative_agents` uses a deploy key scoped to that repo only. `double-front` needs its **own** deploy key + SSH config host alias (`github.com-double-front`) — see ops runbook in sign-off session 2026-06-09.

Record sign-off metadata:

```bash
cat > /var/log/soak/<sim_code>-meta.json <<EOF
{ "sim_code": "...", "be_commit": "...", "fe_commit": "...",
  "reports_submitted_per_step": [4,4,4], "headless": "pass", ... }
EOF
```

---

## P0-1 investigation notes (2026-06-09) — for the record

**Ruled out:**

- Migration `20260609130000` blocking write RPC EXECUTE — dev RPC runs with current service key.
- Invalid / placeholder worker key — `sb_secret_…`; identical to service role key.
- Missing `dbl_agent` rows for family personas — all four doubles resolve and write.

**Red herring:** `Access denied for agent` from `dbl_store_memory` when dev path fails first — do **not** patch prod function auth.

**P2 (non-blocking):** `COMPLETED.json` write fails when `SKIP_MOVEMENT_JSON_WRITE=true` (no `movement/` dir) — mkdir before write or relocate marker; small BE fix.

---

## Related docs

- `README.md` § Sim VPS — generation deploy (operators) — BE-only / FE-only / paired runbook
- `20260608_FE_MVP_hardening.md` — Item 1 H0 soak (local `:3000` config that passed)
- `TODO_production_hardening.md` — full hardening analysis
- `sot/sot_be-fe.md` — FE-BE movement contract
