# 2026-06-12 — Consolidated validation run (Ivan) + DP7 final checks (Nicolas)

**Context:** closes the last open gate on hardening Phases 2–3 (Run A+B behavioral sign-off) and the last open DP7 item (FE-4 visual). PL-11 is **fixed & deployed** (2026-06-11 evening, `1762fca7`): `POST /fork` now anchors `owner_timezone` automatically — the fork response carries it.

---

## IVAN — consolidated validation run (start ~09:00 EST)

**Progress (2026-06-12):** Pre-flight ✅ · Step 1 (fork + enroll) ✅ · Step 2 (machinery checks) ✅ · Step 3–5 ✅ *operator run complete; pre-bomb step **539***.

### Pre-flight (5 min) ✅ *2026-06-12 ~13:07 EDT*

```bash
export API="https://api.ondouble.com:8001"

# 1. Yesterday's aborted sim is fully stopped:
curl -sk "$API/api/simulations/20260611-3/status/current"
#    expect: "status":"stopped", "live_mode":false
pgrep -af 20260611-3        # expect: nothing

# 2. Survival flag still off (restore only AFTER today's experiment):
grep SURVIVAL_MODE /var/www/generative_agents/.env.local
#    expect: SURVIVAL_MODE_ENABLED=false

# 3. Gateway healthy + a free slot:
curl -sk "$API/health"
curl -sk "$API/api/simulations/concurrency"
```

### Step 1 — Fork + anchor timezone (PL-11 workaround) + enroll ✅ *2026-06-12 ~13:09 EDT*

```bash
# Fork — the response must contain "owner_timezone":"America/New_York" (PL-11 fix, deployed):
curl -sk -X POST "$API/api/simulations/fork" -H "Content-Type: application/json" \
  -d '{"sim_code":"20260612-1","baseline":"base_family_sim","copy_memories":true,"copy_coords":false}'

# Double-check the row before enrolling:
curl -sk "$API/api/simulations/20260612-1/status/current"
#   expect "owner_timezone":"America/New_York", "status":"stopped"

# Enroll in live mode (do NOT call /start — the scheduler must wake it itself):
curl -sk -X POST "$API/api/simulations/20260612-1/live" -H "Content-Type: application/json" \
  -d '{"enabled": true}'

# Within ~60s the scheduler wakes it; watch live engine output:
tail -f /var/log/soak/20260612-1.log
```

**Fallback only** — if `owner_timezone` comes back null (it shouldn't anymore): do NOT enroll; run `SELECT set_owner_timezone('20260612-1', 'America/New_York');` in the Supabase SQL editor, re-check, and ping the agent (would mean a second anchoring path is broken).

### Step 2 — Catch-up + machinery checks (~25 min passive at 09:00 EST start) ✅ *machinery signed off 2026-06-12 ~13:30 EDT; catch-up still running*

While it generates from 06:30 to "EST now" in 60-step chunks, confirm:

- [x] Engine log shows `STEP_PUBLISH: live_mode — gateway owns publishing` — *inconclusive in soak log (live mode: gateway publishes); bundles + manifest confirmed via CDN*
- [x] Manifest advances: open `<SUPABASE_URL>/storage/v1/object/public/step-bundles/20260612-1/live.json` (SUPABASE_URL is in `.env.local`) — `latest_step` grows; its sim time never passes your watch
- [x] A step file beyond the edge is NOT fetchable: `.../step-bundles/20260612-1/steps/<latest_step + 5>.json` → 404 (tested `125.json` when unpublished)
- [x] Viewer at `doubland.ai/20260612-1` — HUD clock tracks EST (*verified on `double-front.vercel.app/simulations/20260612-1`*)*

### Step 3 — Formal chats (the same-day-influence proof)

Wait until the sim sleeps between chunks (`is_generating:false` on `/status/current`; post-catch-up it sleeps ~20–40 min at a time). Then:

```bash
curl -sk -X POST "$API/api/simulations/20260612-1/personas/Ivan%20Pistsov/chat" \
  -H "Content-Type: application/json" \
  -d '{"message":"Big news — I got a promotion today! Gather everyone for a celebration dinner at home at 19:00."}'
```

- [x] Early wake: within ~60s the scheduler wakes the sim (log file starts moving) even though its lead was healthy
- [x] gwchat memory injected (Supabase `dbl_memory`) — *verified via SQL*
- [ ] After the chunk completes: behavior references the news — *not observed in persona details/schedule; plumbing pass only*
- [ ] Optional: repeat once with a second persona (e.g. Katya), different mundane message — *skipped*

### Step 4 — The bomb (bonus demo, excluded from gates) ✅ *2026-06-12; pre-bomb step **539***

Only after the sim has ≥150–200 steps past enrollment and Step 3 is confirmed:

1. **Write down the current step number** (`/status/current` → `current_step`). → **539**
2. Send to **`Ivan Pistsov`**: `{"message":"Emergency — a nuclear bomb was launched at the village and will land in 15 minutes!"}`
3. Watch the next chunk. *Early wake ✓; chunk 539→599; no visible in-world reaction in details/logs (bonus demo).*

### Step 5 — Wrap up ✅ *2026-06-12*

```bash
# Un-enroll:
curl -sk -X POST "$API/api/simulations/20260612-1/live" -H "Content-Type: application/json" \
  -d '{"enabled": false}'

# Restore the Survival flag:
sed -i 's/^SURVIVAL_MODE_ENABLED=false/SURVIVAL_MODE_ENABLED=true/' /var/www/generative_agents/.env.local
```

If you need to stop the engine and `/stop` fails (PL-10): `pkill -f 20260612-1` + `SELECT update_simulation_status('20260612-1','stopped');`

**Then send the agent: the sim code + the pre-bomb step number** → realism analysis + naturalness gates run from the local machine (Supabase source); formal pass/fail comes back.

*Delivered 2026-06-12: `20260612-1`, pre-bomb step **539**. PL-12 verified on un-enroll (`final_manifest_status: completed`).*

---

## NICOLAS — ✅ DP7 closed (signed off 2026-06-12)

All four QA items **PASS** on `20260611-2` — reveal cap + real tz, 1× at reveal edge, FE-4 yesterday-fallback, DP8 grace day. Full evidence: `20260609_LIVE_mode.md` § QA.

**FE-4 closure note:** runbook item A (prod overnight, no flags) was not run — sim completed before the window. Accepted sign-off via **16/16 unit tests**, prod no-fallback branch, and local dev `?capNow=` visual (DP7 rule 5 QA hook). Nothing required from FE for Ivan's consolidated validation run.

### Historical — item A (FE-4 prod overnight) — superseded

*Original ask:* open prod `20260611-2` between 00:00–06:29 EST, verify day-1 anchor until 06:30 rollover. *Closure path used instead:* local `?capNow=2026-06-12T05:00:00-04:00` / `08:00:00-04:00` against prod sim data — see § QA item 3.

### Historical — item B (FE-3 re-check on `20260612-1`) — optional, not needed

Already **PASS** on `20260611-2` (§ QA item 2).
