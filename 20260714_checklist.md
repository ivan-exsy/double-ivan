# 2026-07-14 checklist — score Survival fidelity (P0 + Light + gather lock)

**Historical sim (closed):** `20260713-1` — Legs 1–2 scored 2026-07-15 (gather lock soft-fail / sleep-stuck).  
**Next score sim:** fresh Survival sprint after **2026-07-15 sleep-stuck + all-absent fixes** — fill **§11** (do **not** continue Day-5 scratch of `20260713-1`).

**Shipped for this score:**
- P0 Survival fidelity + Challenge Director + Light reason slots (8 IDs)
- **2026-07-14:** Personality attraction (weighted challenge pick / soft priors)
- **2026-07-14:** Gather prewindow lock (soft day outside appointments; hard last-hour cafe destination; seek paused in window; honest spatial absentees; opportunistic Survival talk on natural meet)
- **2026-07-15:** Sleep-stuck RCA fixes — no midnight `post_vote_date` restamp; regenerate plan on empty/all-sleep; gather lock wakes sleepers; all-absent vote fail-closed
- **2026-07-16:** Gather-hour crash pack (`20260715-1` @ step 1650) — word-boundary sleep detection (no `rest`⊂`restock`); gather lock mints complete travel action (never `None` duration); null-safe position reconciler; persist `season.phase` on transition; `/status/current` grace = `Premiere`

**Mode:** normal sprint (`diagnostic_mode: false`) — product data in Supabase / season state is enough  
**Gate triad (scoring only, after unblind):** Ivan · Diana · Mike  

Do **not** expect Remotion / public VO / share CTA from this run.

---

## Run status (ops)

| Leg | Steps | What happened |
|-----|------:|---------------|
| Leg 1 | ~2600 | Grace + Season Day 1 complete (challenge + Ivan elim). Day 1 challenge fired by **deadline** at 11:00 with **8/15 absent** (pre–gather-lock). Stopped overnight before Day 2 challenge (~4h short). |
| Leg 2 (continue) | +~4800 → **7399/7400 completed** | Gather lock + attraction live. Ended Season Day 5 morning (`claim_the_slot` active, unresolved). **Scored 2026-07-15 — FAIL sleep-stuck Days 3–4.** |
| Leg 3 (fresh) | `20260715-1` → **crashed step 1650** @ Day 1 10:00 | Grace OK; Director armed `hold_for_shield`; gather lock opened then **fatal** `act_duration=None` (false sleep on `restock` → WAKE cleared timers → reconciler `None*6`). **Do not score until 2026-07-16 crash pack is deployed**; then continue or fresh Leg 3. |

**Score Day 1 Keep / Director Day 1 from Leg 1.** Score gather lock, Days 2–3 Director, Light, attraction from **Leg 2+** only (historical). **Leg 3:** use §11 as the primary gate before re-opening Light/blind.

### Post-run score (2026-07-15) — verdict

**Gather lock soft-fail + deeper forensics needed.** Director Days 1–3 OK. Day 2 challenge = spatial + mostly real reasons. Days 3–4 = deadline + **everyone still in bed** (`f_daily_schedule = [['sleeping', 1440]]`); gather lock skips sleep so cafe census stayed **0**. Light (`whisper_chain`) ran with **0 real reasons**. Day 3–4 elims have empty tallies/`vote_count: 1`. Do **not** use this run for Light/blind ship call.

---

## Mid-flight check (while a score leg is still running)

Use this **before** the full post-run score. Product data lands when a challenge **resolves** — empty new `challenge_results` mid-day is normal if phase is still `DIRECTIVE` / social. For **Leg 3**, prioritize §11 probes F–H.

### What you can verify mid-flight

| Checklist § | Mid-flight? | Signal |
|-------------|-------------|--------|
| §0 run alive | Yes | step climbing, process alive, `is_survival: true` |
| §1 Director Day 1 | After Day 1 resolve | `used` / results include `hold_for_shield` |
| §1 Days 2–3 | Only after each day resolves | `silent_pact` then `alliance_lock_in` in `used_challenge_ids` / results |
| §2 reason persistence | Only after resolve | `decisions[].reasoning` — expect far fewer `"absent"` on Day 2+ |
| §3 Light soul reasons | Only Day 4+ after resolve | Light IDs in results |
| §8 Gather lock | Yes (Day 2+ challenge/vote windows) | Prefer `spatial_gate`; env census ≥12/15 at Hobbs in prewindow |
| §9 Soft day + talk | Soft | Jobs outside lock; chats may mention challenge/vote when people meet |
| §10 Attraction | After Day 4+ / weighted picks | Not always same high-SC person centered; `choice_reason_plain` if present |
| **§11 Sleep-stuck / all-absent** | **Yes (Leg 3)** | Morning after vote: not all-bed; schedules ≠ sleeping-1440; no empty-tally elim |
| §4 blind sheet / §6 teach | No | post-run trailer package |
| §5 clone smell | Soft | skim soak chat lines; not decisive |

### Copy-paste on VPS

```bash
# A) Pulse
curl -sk https://127.0.0.1:8001/api/simulations/20260713-1/status/current \
  | python3 -c "import sys,json;d=json.load(sys.stdin);print(d['current_step'], d['curr_time'], d['status'], d.get('current_day_label'), d.get('is_generating'), d.get('backend_process_active'))"

# B) Season / director / results (local mirror — usually freshest)
python3 - <<'PY'
import json
from pathlib import Path
p = Path("/var/www/generative_agents/environment/frontend_server/storage/20260713-1/survival/season_state.json")
d = json.loads(p.read_text())
print("phase:", d.get("phase"), "season_day:", d.get("current_day"))
print("active:", d.get("active_challenge_id"))
print("used:", d.get("used_challenge_ids"))
crs = d.get("challenge_results") or []
print("resolved_challenges:", len(crs))
for row in crs:
    dec = row.get("decisions") or []
    with_r = sum(1 for x in dec if isinstance(x, dict) and (x.get("reasoning") or "").strip() and (x.get("reasoning") or "").strip().lower() != "absent")
    absent = sum(1 for x in dec if isinstance(x, dict) and (x.get("reasoning") or "").strip().lower() == "absent")
    cid = row.get("challenge_id") or row.get("type")
    print(f"  day={row.get('day')} id={cid} decisions={len(dec)} real_reasons={with_r} absent={absent}")
    if dec:
        s = next((x for x in dec if isinstance(x, dict) and (x.get("reasoning") or "").strip().lower() not in ("", "absent")), dec[0])
        print("   sample:", {k: s.get(k) for k in ("agent","persona","name","action","bid","side","reasoning","choice_reason_plain") if k in s or s.get(k)})
        print("   reason:", (s.get("reasoning") or "")[:180])
PY

# C) Phase triggers (spatial vs deadline + absent lists)
python3 - <<'PY'
import json
from pathlib import Path
p = Path("/var/www/generative_agents/environment/frontend_server/storage/20260713-1/logs/survival_phase_trigger.ndjson")
for line in p.read_text().splitlines():
    if line.strip():
        print(json.dumps(json.loads(line), sort_keys=True))
PY

# D) Ops-voice smell on reasons
python3 - <<'PY'
import json, re
from pathlib import Path
BAN = re.compile(r"\b(pillar|refill|hardware pair|execute|firm votes|clean window)\b", re.I)
d = json.loads(Path("/var/www/generative_agents/environment/frontend_server/storage/20260713-1/survival/season_state.json").read_text())
hits = total = 0
for row in d.get("challenge_results") or []:
    for x in row.get("decisions") or []:
        if not isinstance(x, dict):
            continue
        r = (x.get("reasoning") or x.get("mark_reasoning") or "").strip()
        if not r or r.lower() == "absent":
            continue
        total += 1
        if BAN.search(r):
            hits += 1
            print("BANHIT", row.get("challenge_id") or row.get("type"), r[:140])
print(f"ban_hits={hits}/{total}" if total else "no reasoned decisions yet")
PY

# E) Hobbs census at a step (gather lock smoke) — set STEP near challenge/vote fire
# STEP=XXXX python3 - <<'PY'
# import json,os
# from pathlib import Path
# step=int(os.environ["STEP"])
# d=json.loads(Path(f"/var/www/generative_agents/environment/frontend_server/storage/20260713-1/environment/{step}.json").read_text())
# cafe=sum(1 for v in d.values() if isinstance(v,dict) and "Hobbs" in str(v.get("address") or ""))
# print(f"step={step} at_hobbs={cafe}/{len(d)}")
# PY
```

### Mid-flight pass bar (Leg 2)

- [ ] Steps advancing past Leg 1 end; backend process alive  
- [ ] Day 2 challenge prefers **`spatial_gate`** (not late deadline with mass `"absent"`)  
- [ ] After Day 2–3 resolve: `silent_pact` then `alliance_lock_in`  
- [ ] Day 2+ reasons mostly real (not `"absent"` placeholders)  
- [ ] Do **not** fail Light / blind triad until Day 4+ exists  

**Leg 1 snapshot (historical):** Day 1 challenge = deadline @11:00, 8/15 absent, 7 real reasons; vote = spatial @19:00; run ended ~01:50 before Day 2 morning.

---

## 0. Before scoring — is the run usable?

- [x] Sim finished (status `completed` / `stopped`; process gone) — Leg 2 end may be **~7400+** steps, not ~2600  
- [x] Season row exists; `challenge_results` has **multiple days** (Day 1 from Leg 1 + Day 2+ from Leg 2)  
- [ ] No mid-run crash that skipped whole challenge days on Leg 2 *(no crash, but Days 3–4 challenge/vote were mass-absent / empty-vote — not clean product days)*  
- [x] Note actual day count completed (need **Day 4+** to see Light IDs; Days 1–3 are Keep) *(Days 1–4 resolved; Day 5 open)*  

**Quick status:**
```bash
curl -sk https://127.0.0.1:8001/api/simulations/20260713-1/status/current | python3 -m json.tool
```

---

## 1. Challenge Director (order lock)

Expected fixed open:

| Season day | Expected ID |
|-----------:|-------------|
| 1 | `hold_for_shield` |
| 2 | `silent_pact` |
| 3 | `alliance_lock_in` |
| 4+ | random without replacement from remaining catalog (attraction-weighted unless flat) |

- [x] Day 1 = `hold_for_shield` *(Leg 1)*  
- [x] Day 2 = `silent_pact`  
- [x] Day 3 = `alliance_lock_in`  
- [x] Later days ≠ repeat of already-played IDs *(Day 4 `whisper_chain`; Day 5 started `claim_the_slot`)*  

---

## 2. Reason persistence (P0 plumbing)

For each completed challenge day in `challenge_results`:

- [x] `decisions[]` present (not just winners / narrative)  
- [ ] Most decision rows have non-empty **real** `reasoning` (not `"absent"`) — **Day 2+ is the bar after gather lock** *(Day 2: 11/14 real; Days 3–4: 0/13 and 0/12 — FAIL)*  
- [ ] If `leaders_burden` ran: `mark` / penalty target **and** `mark_reasoning` present *(N/A — did not run)*  
- [ ] Elimination / vote days: vote reasons present where expected (P0 vote path) *(Days 1–2 OK; Days 3–4 empty tallies/reasons — FAIL)*  

**Pass bar:** reasons exist as first-class data you can read without digging LLM dumps.

**Leg 1 note (do not reopen Day 1 mechanics):** Day 1 had 7/15 real reasons + 8/15 `"absent"` because challenge fired by deadline before gather lock shipped.

---

## 3. Light IDs — soul reasons (main test)

Score only IDs that actually ran. For each, skim 5–10 reasons (or blind sheet — §4).

| ID | What “good” sounds like | Red flags (ops voice) |
|----|-------------------------|------------------------|
| `captains_pick` | Why this color — coalition / fairness / underdog | Herd EV, “optimal side” |
| `whisper_chain` | Why RELAY vs TWIST — fidelity vs theatricality | Chain-EV slang |
| `leaders_burden` | Why this nominee / mark — relationship / fairness / loyalty | execute / pillar / threat matrix |
| `bid_for_vest` | Why this intensity 1–5 — hunger / restraint / uncertainty | Always-5 script for everyone |
| `trial_night` | Why ACQUIT / CONVICT — clarity / fairness / loyalty | Moral scoring for power |
| `vote_heist` | Why this target — grievance / fairness / relationship | Status-heist EV |
| `claim_the_slot` | Why CLAIM vs YIELD — appetite vs quiet restraint | Always-CLAIM lottery script |
| `shared_survival_pool` | Why take 0–5 — restraint / trust / necessity | Pure game-theory script |

**Attractors (highest risk — fail these → escalate that ID only):**

- [ ] `bid_for_vest`: not everyone bidding 5 with identical “max to win” voice  
- [ ] `claim_the_slot`: not everyone CLAIM with lottery/ops voice  

**Keep IDs (Days 1–3 + any other Keep that ran):** skim only — confirm reasons feel personal, not war-room. Do not reopen Day 1 mechanics.

Per Light ID that ran:

- [x] `whisper_chain` — **Fail / unscorable**: 12/12 `"absent"` (cast asleep at fire); no soul reasons to skim  
- [ ] `claim_the_slot` — started Day 5 DIRECTIVE, **not resolved** before step budget end  
- [ ] Attractors `bid_for_vest` / `claim_the_slot` — N/A (no scored Light decisions)  

---

## 4. Blind-choice sheet (creative gate)

After trailer package / day extract for a day that includes Light challenges:

- [ ] `challenge_blind_choice.md` exists — **names stripped** (Agent A/B/…) *(not packaged)*  
- [ ] `challenge_blind_choice.json` exists — **names kept** (ops / unblind) *(not packaged)*  
- [x] Banlist rate reported (ops terms flagged) — note rate; do **not** hard-fail lock on rate alone *(1/18 on reasoned rows; Days 3–4 had none)*  

**Blind score (you + Diana + Mike, before unblind):**

- [ ] From choice + reason alone, can you tell *who this person is* (not just “smart player”)? *(blocked — no Light reasons)*  
- [ ] Pass = wiring enough for that ID · Fail = escalate **that ID only** (no catalog redesign)  

---

## 5. Fidelity / clone smell (P0 overlay)

Spot-check Day 1–2 chat + vote snippets (cast-wide; Overlay A/B not required):

- [ ] Fewer alliance/threat/reputation labels in seek/overlay-style copy *(soft — Day 2 reasons still alliance/trust heavy by design of silent_pact)*  
- [x] Less “pillar / refill / hardware pair / execute / firm votes / clean window” in challenge + vote reasons *(banlist 1/18; Day 2 clean)*  
- [x] Agents still sound like themselves more often than like one shared strategist *(Day 1–2 samples readable as personal; Days 3–4 N/A)*  

Optional: run recognition / clone lexicon helper on a day package if you built one — treat as signal, not ship gate.

---

## 6. Teach cards / package hygiene

- [ ] Teach cards exist for Light IDs that ran (plain-language “what this challenge is”) *(not packaged on VPS storage)*  
- [ ] `day_reasoning` (or equivalent) available for days you care about *(not packaged)*  
- [x] No claim that Remotion / public VO is ready  

---

## 8. Gather prewindow lock (2026-07-14) — Leg 2 primary gate

Score on **Day 2+** challenge/vote only (Day 1 was pre-fix).

- [ ] Challenge (and ideally vote) fires via **`spatial_gate`** more often than late **`deadline`** *(Day 2 chal spatial; Day 2 vote + Days 3–4 chal/vote all deadline — FAIL)*  
- [ ] Env census in last hour before deadline: **≥12/15** at Hobbs (80% quorum) before/at fire *(Day 2 peak ~10/14; Days 3–4 **0/N in bed** — FAIL)*  
- [ ] Far fewer `"absent"` challenge reasons than Day 1’s 8/15 *(Day 2: 3/14; Days 3–4: 13/13 and 12/12 — FAIL overall)*  
- [x] Phase-trigger NDJSON on spatial success lists **true** absentees (may be non-empty even when quorum hits) — not a forced empty list *(Day 2 chal listed 3 absentees)*  
- [ ] Soft hours still show jobs/errands **outside** 10:00–11:00 / 19:00–20:00 windows (personality not fully suspended) *(Day 2 yes; Days 3–4 stuck sleeping all day — FAIL)*  

**Fail this section →** do not call gather lock “shipped”; fix before treating Light score as clean.

---

## 9. Soft day + opportunistic Survival talk (2026-07-14)

- [ ] Outside gather lock windows, Doubles still do real lifestyle blocks (work / school / errands) *(Day 2 soft hours OK; Days 3–5 schedule collapsed to all-day sleep)*  
- [x] Soft brief / plans allow talk about upcoming challenge/vote/alliances when people naturally meet — **not** forced all-day strategy meetings *(briefs present on Day 5 scratch)*  
- [x] Spot-check ≥1 soft-hour chat or plan line that mixes life + game (library / workplace / cafe lunch) without ops register *(Day 2 Hobbs/work memories; barista / lunch)*  

---

## 10. Personality attraction (2026-07-14)

Only once Day 4+ / weighted picks actually run:

- [ ] Challenge centering / pool picks are not “always the same top social-capital Double” *(insufficient clean Light resolves)*  
- [ ] If `choice_reason_plain` (or equivalent) appears on decisions, it reads as soft prior language agents can defy — not a hard scoreboard *(present on Day 2 but often mirrors `reasoning`; Days 3–4 = `"absent"`)*  
- [x] Resolve still does **not** sole-rank primary power by social capital alone *(no evidence of SC-only scoreboard on Day 2 winners)*  

---

## 11. Sleep-stuck + all-absent regression (2026-07-15) — Leg 3 primary gate

**Purpose:** Confirm the RCA fixes on a **fresh** Survival sim before treating Light / blind as scorable again.  
**Do not** continue `20260713-1` Day-5 sleep-stuck scratch.  
**Minimum run:** through **Season Day 3 morning** after Day 2’s vote (ideally Day 4 for Light).  
**Replace `SIM=`** in probes with the new sim code.

### Pass / fail matrix

| Fix | Pass signal | Fail / degradation |
|-----|-------------|--------------------|
| Midnight `post_vote_date` | After a vote overnight, next morning cast is **not** all in bed; schedules multi-block | Cast asleep through 10–11 again; `post_vote_date` equals **new** calendar morning |
| Degenerate-schedule plan | Morning after vote: `daily_req` / hourly plan regenerates (not empty + sleeping-1440) | Same-evening post-vote recovery clobbered into a full-day replan before midnight |
| Gather lock wakes | Day 2–3 challenge (ideally vote) lean **`spatial_gate`**; Hobbs ≥ ~80% in last hour; **no** runner crash at 10:00 / 19:00 | Sleepers ignored; **or** soft-day destroyed; **or** TypeError on `act_duration` (pre–2026-07-16) |
| All-absent fail-closed | If mass-absent: **no** elim with empty tally / `vote_count: 1`; NDJSON `all_absent_no_quorum`; same cast next morning | Phantom lottery elim returns |

### Checkboxes (Leg 3)

- [ ] Fresh sim (new code); not a continue of sleep-stuck `20260713-1`  
- [ ] After Day 1 vote → Day 2 morning: sample scratch schedules **≠** `[['sleeping', 1440]]` for alive cast  
- [ ] `post_vote_date` on survivors stays the **vote calendar date**, not restamped to the next morning  
- [ ] Day 2+ challenge fire prefers **`spatial_gate`** (or deadline with low absent — not 100% bed)  
- [ ] Day 2+ challenge `absent` rate far below Day 1’s 8/15 and **not** all-alive  
- [ ] Soft hours outside 10:00–11:00 / 19:00–20:00 still show jobs / school / errands  
- [ ] No elimination with empty `vote_tally` + `vote_count: 1` while everyone was absent  
- [ ] If `all_absent_no_quorum` appears in phase-trigger NDJSON: remaining cast unchanged that night  
- [ ] Director Days 1–3 still `hold_for_shield` → `silent_pact` → `alliance_lock_in` (regression)  
- [ ] Only if Days 2–3 clean: proceed to Light (§3) / blind (§4) on Day 4+  

### Mid-flight probes (Leg 3) — copy-paste on VPS

```bash
SIM=YYYYMMDD-N   # set to the fresh sim

# F) Schedule shape + post_vote_date (run ~06:30–09:00 after a vote night)
python3 - <<PY
import json
from pathlib import Path
base = Path("/var/www/generative_agents/environment/frontend_server/storage/$SIM")
for pdir in sorted((base / "personas").iterdir()):
    sp = pdir / "bootstrap_memory" / "scratch.json"
    if not sp.exists():
        continue
    s = json.loads(sp.read_text())
    sched = s.get("f_daily_schedule") or []
    labels = [str(x[0])[:36] for x in sched[:4] if isinstance(x, (list, tuple)) and x]
    total = sum(int(x[1]) for x in sched if isinstance(x, (list, tuple)) and len(x) >= 2)
    pv = (s.get("survival") or {}).get("post_vote_date")
    print(f"{pdir.name}: blocks={len(sched)} total={total} post_vote={pv} head={labels}")
PY

# G) Phase triggers — watch spatial vs deadline + all_absent_no_quorum
python3 - <<PY
import json
from pathlib import Path
p = Path("/var/www/generative_agents/environment/frontend_server/storage/$SIM/logs/survival_phase_trigger.ndjson")
if not p.exists():
    print("MISSING", p)
else:
    for line in p.read_text().splitlines():
        if not line.strip():
            continue
        o = json.loads(line)
        print(json.dumps({k: o.get(k) for k in ("day", "phase", "reason", "step", "absent") if k in o or o.get(k) is not None}, sort_keys=True))
PY

# H) Elim integrity — flag empty-tally / vote_count==1 phantoms
python3 - <<PY
import json
from pathlib import Path
d = json.loads(Path("/var/www/generative_agents/environment/frontend_server/storage/$SIM/survival/season_state.json").read_text())
for e in d.get("eliminated") or []:
    tally = e.get("vote_tally") or {}
    reasons = e.get("vote_reasons") or {}
    print({
        "day": e.get("day"),
        "name": e.get("name"),
        "vote_count": e.get("vote_count"),
        "tally_n": len(tally),
        "reasons_n": len(reasons),
        "suspicious": (not tally) and float(e.get("vote_count") or 0) <= 1,
    })
PY
```

### Leg 3 verdict

Pick one:

- [ ] **§11 pass** — sleep-stuck + all-absent gates clear; continue to Light/blind score on this sim  
- [ ] **§11 soft-fail** — gather/census still weak but no all-day sleep; tune lock/quorum before Light  
- [ ] **§11 fail** — sleep-stuck or phantom elim recurred; do not score Light; deeper forensics  

### Leg 3 capture

| Field | Fill in |
|-------|---------|
| New sim code | |
| Days completed (season) | |
| Day 2 morning schedule OK? | yes / no (note sleeping-1440 rate) |
| `post_vote_date` vs next morning | preserved / restamped |
| Day 2+ challenge fires | spatial_gate / deadline (per day) |
| Day 2+ absent rates | |
| `all_absent_no_quorum` seen? | yes / no — elim skipped? |
| Soft-day outside lock OK? | |
| §11 verdict | pass / soft-fail / fail |
| Next action | |

---

## 7. Verdict for tomorrow’s call

**Note:** Checkboxes below record the **Leg 2 (`20260713-1`)** call. For the next ship call, prefer **§11 Leg 3 verdict** after the fresh run.

Pick one:

- [ ] **Ship path OK** — Light wiring + director + persist + gather lock look good enough to keep iterating on fidelity / video gate  
- [ ] **Light re-prompt 1–2 IDs** — list which (usually bid / claim)  
- [x] **Gather lock soft-fail** — Day 2+ still deadline/mass-absent; tune lock before Light ship call *(Day 2 chal OK; Days 3–4 collapse)*  
- [x] **Deeper forensics needed** — only if reasons missing or season/challenge path broken (then consider a short diagnostic re-run) *(all-day `sleeping` schedule + empty Day 3–4 votes)*  

### Capture

| Field | Fill in |
|-------|---------|
| Days completed | Leg 1: 1 · Leg 2: Days 2–4 resolved; Day 5 started (unresolved) · ended step 7399 |
| Light IDs that ran | `whisper_chain` (Day 4, all absent); `claim_the_slot` started Day 5 only |
| Day 2+ challenge fire reason | Day 2: **spatial_gate** @10:33 · Days 3–4: **deadline** @11:00 |
| Day 2+ absent rate | Day 2: 3/14 · Day 3: 13/13 · Day 4: 12/12 |
| Gather lock pass/fail | **FAIL** (post–Day-2 sleep stuck; lock skips sleep → 0 at Hobbs) |
| Soft-day talk spot-check | Day 2 OK; Days 3+ not usable |
| Attraction note | Unscorable — no clean Day 4+ reasoned decisions |
| Blind triad pass/fail | **Blocked** — no package / no Light reasons |
| Worst attractor | N/A |
| Next action | Deploy sleep-stuck + all-absent fixes; fresh diagnostic re-run (do not continue Day-5 sleep-stuck scratch) |
| RCA (2026-07-15) | P0: `_sync_post_vote_markers` runs before `_advance_day` at 00:00 and restamps `post_vote_date` to the **new** calendar date while season day still has yesterday's elim → morning planner skips ("post-vote authoritative") → lifestyle cleared schedule to `[]` → `[['sleeping', 1440]]` → gather lock skips sleep. Continue/code swap made Day 2 look healthy (Leg 1 `post_vote` still prior date) then armed the bug on the first overnight after Day 2 vote under new code. Days 3–4 empty votes = all-absent phantoms. **Fix shipped 2026-07-15:** no midnight restamp; degenerate-schedule plan override; gather lock wakes sleepers; all-absent vote fail-closed. |

---

## Out of scope (do not reopen)

- Day 1 `hold_for_shield` mechanic redesign  
- Catalog Replace / Mechanic tweak  
- Remotion / public VO / share CTA  
- Overlay A/B experiment (unless clone smell is still catastrophic)  
- Changing Director Days 1–3 order  
- Re-scoring Day 1 mass-absent as a gather-lock failure (pre-fix baseline)  
- Self-serve Double / post-chat learning (separate epic — not this sim score)  
- Continuing or “repairing” `20260713-1` Day-5 sleep-stuck scratch to validate §11 (use a fresh sim)  
