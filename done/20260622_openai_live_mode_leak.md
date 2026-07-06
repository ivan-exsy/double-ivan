# Incident: OpenAI Spend Spike — Live Mode Scheduler Leak

**Date:** 2026-06-22  
**Incident window:** 2026-06-17 through 2026-06-20 (peak 2026-06-19)  
**Affected sim:** `20260615`  
**Infrastructure:** VPS (`api.ondouble.com`, `double-api.service`)  
**Status:** Mitigated and **guards deployed** (2026-06-22) — `sleeping` migration applied; no `live_mode` enrollments in prod

---

## Summary

OpenAI spend spiked to **~$15.63 (Jun 19)** and **~$8.77 (Jun 20)** without the operator starting new jobs. **~100% of Jun 19 Responses API usage** came from the VPS production key (`key_5aagQmVEzBywhIO4`), ~1,200–1,300 calls/hour sustained.

**Root cause:** Sim `20260615` stayed enrolled in **`live_mode = true`**. The VPS **Run B live chunk scheduler** (`double-api.service`, 60 s tick) kept auto-waking generation in 60-step bursts to maintain a buffer ahead of the owner-local clock (`America/New_York`). The sim was marked **`completed`** in Supabase, but the scheduler only skips **`paused`** sims — not terminal statuses — so generation continued with no manual intervention.

**Not the cause:** Vercel frontend, Railway, local dev machine, or a long-running `reverie.py` on VPS. Generation ran via ephemeral `temp_runner_{sim}.py` subprocesses spawned by the scheduler (often invisible in `ps` between chunks).

**Mitigations applied (2026-06-22):**

| Action | Result |
|--------|--------|
| `set_live_mode('20260615', false)` | Live enrollment disabled |
| Heartbeat verified | `last_generated_at` frozen at **2026-06-22 16:02:42 UTC**, `total_steps` = **10354** |
| VPS frontend repair | Cleared orphan `next-server` on port 3000; `double-front.service` active |

OpenAI VPS key disabled mid-incident (Jun 20). Re-enable only after spend caps/alerts or key rotation.

---

## Symptoms

| Symptom | Detail |
|---------|--------|
| Unexpected OpenAI bill | ~$24 over Jun 19–20 vs ~$2/day baseline for an active sim |
| Steady API volume | ~27,923 Responses + ~2,853 Embeddings on Jun 19; single VPS key |
| Sim looked idle | `is_generating = false` between chunks; `status = completed` |
| Sim still generating | `last_generated_at` advancing; `total_steps` ≈ 10,354 at mitigation |
| Critical inconsistency | **`completed` + `live_mode = true`** — scheduler still eligible to wake |
| Cost telemetry gap | `sim_cost_daily` last updated ~2026-06-16 while OpenAI billing continued |
| Poor observability | No `logs/sims/20260615.log` on VPS for scheduler-driven chunks |

**Operator mental model vs system:** “Sim completed” meant “story done.” In live mode, **`completed` is the normal between-chunk sleep state** — the scheduler re-wakes on the next tick. Only **`set_live_mode(false)`** reliably ends the feed.

**Auto-enrollment:** Production sims with `owner_timezone` are auto-enrolled in live mode on first run (`reverie.py` `_init_live_pacing`) — no explicit enroll step required.

---

## Implementation & test summary

**Shipped:** commit `72973865` on `railway` / VPS `/var/www/generative_agents` · migration `20260622120000_live_mode_terminal_guards.sql`

### What we built (PM-LIVE-1)

Fixed the overloaded `completed` status by introducing **`sleeping`** for live chunk sleep, and blocking runaway scheduler wakes on true terminal states.

| Area | Change |
|------|--------|
| **Database** | New `sleeping` status; `update_simulation_status` auto-clears `live_mode` on `completed` / `stopped` |
| **Engine** | Live chunk exit → `sleeping` (not `completed`); survival / true finish → `completed` |
| **Scheduler** | Wakes only `running` \| `sleeping`; skips `paused`, `completed`, `stopped` |
| **Gateway** | Chunk monitor preserves `sleeping`; `/stop` with no process auto-unenrolls + terminal manifest |
| **Observability (partial P1)** | JSON `live_chunk_start` logs; structured cost-telemetry flush-failure logs |

```
Chunk ends (live)  → sleeping,  live_mode true   → scheduler may re-wake
Feed ends          → completed/stopped, live_mode false → scheduler never wakes
```

### Automated tests

| Suite | Result |
|-------|--------|
| `api_gateway/tests/test_live_scheduler.py` | 60 passed — `sleeping` wakes; `completed`/`stopped`/`paused` do not |
| `api_gateway/tests/test_stop_endpoint.py` | 7 passed — live `/stop` auto-unenrolls when no local process |

### Production verification (2026-06-22)

| Check | Result |
|-------|--------|
| Migration: `sleeping` in `simulation_statuses` | OK |
| No enrolled sims: `live_mode = true` | 0 rows |
| Incident sim `20260615` | `live_mode = false`; heartbeat frozen |
| VPS `double-api` restart after deploy | OK |

One-time cleanup SQL (only if needed):

```sql
SELECT public.set_live_mode(s.name, false)
FROM double.simulations s
JOIN double.simulation_statuses st ON st.id = s.status_id
WHERE s.live_mode = true AND st.name IN ('completed', 'stopped');
```

Not required when no `live_mode = true` rows exist.

### Still open (ops / P1)

| Item | Status |
|------|--------|
| OpenAI org spend cap + email alert | Pending |
| Separate VPS vs local dev API keys | Pending |
| VPS `SIM_LOG_DIR` + logrotate | Pending |
| Daily `sim_cost_daily` vs OpenAI reconciliation script | Pending |
| Jun 17 `double-api` restart RCA | Pending |

### Runbook: fully stop a live sim

1. `POST /api/simulations/{sim}/live` `{"enabled": false}` — or `POST /{sim}/stop` (auto-unenrolls when no process)
2. Optionally `update_simulation_status(sim, 'stopped')`
3. Wait 5+ min; confirm `last_generated_at` and `total_steps` unchanged
4. `journalctl -u double-api \| grep live_chunk_start` — no new wakes for `{sim}`

---

## Related docs

- `sot/sot_lifecycle.md` — LIVE lifecycle (Run B)
- `sot/sot_api.md` — status / `live_mode` definitions
- `sot/sot_llm.md` — LLM cost posture
- `TODO_post_mvp.md` — PM-LIVE-1

---

## Open questions (RCA)

| Question | Finding |
|----------|---------|
| When was `live_mode` enabled for `20260615`? | Auto-enrolled on first production run when `owner_timezone` was set |
| Why did `sim_cost_daily` stop after 2026-06-16? | Unconfirmed without VPS sim logs; P1 adds flush logging + reconciliation |
| Jun 17 `double-api` restart cause? | Unknown — needs `journalctl` / deploy records (Ops O3) |
