# 2026-07-14 checklist — score Survival fidelity (P0 + Light + gather lock)

## Status snapshot (2026-07-19) — read this first

**Active score sim:** `20260717-1` (Leg 3b) — **still running** at last check (~step **5172**, Season Day 3 **~20:42 VOTING**, same PID **1108378**).  
**§11 (sleep-stuck / all-absent / gather lock regression): PASS** mid-flight. **Day 2–3 full fire path (chal + vote) all `spatial_gate`.** Safe to continue into Day 4+ for Light/blind.

### Still failing / not tested / needs confirm

| Item | Status | Notes |
|------|--------|--------|
| **§3 Light soul reasons** | **Not tested** | No Light ID has resolved yet on `20260717-1` (Days 1–3 = Keep only). Wait for Day 4+. |
| **§4 Blind triad** (Ivan · Diana · Mike) | **Not tested** | Needs Light day package + unblind sheet after Day 4+ resolve. |
| **§6 Teach cards / day package** | **Absent (expected)** | VPS check 2026-07-18: `survival/` = `season_state.json` + `agents/` only — no blind/teach/day_reasoning/trailer/package files. Generate after Light day. |
| **§10 Attraction (weighted Day 4+ picks)** | **Not tested** | Needs Day 4+ catalog picks; Keep days alone are insufficient. |
| **Day 3 vote resolve / elim #3** | **In progress** | Vote **opened** `spatial_gate` @5072 (3 absents). Phase still **VOTING** at step ~5172 — confirm final elim tally when phase leaves VOTING. |
| **Day 4+ Director** (no ID repeat) | **Pending** | Days 1–3 order OK; confirm first Light ID is new + reasoned. |
| **Prewindow Hobbs ≥80% at fire step** | **Soft / not fully instrumented** | Fire log proves `spatial_gate` D2–D3 chal+vote; optional disk census at 3145 / 3630 / 4585 / **5072**. |
| **§9 Soft-hour chat mix (life + game)** | **Soft PASS** | 2026-07-18 skim: movement chat payloads 0 on disk; persona act/memory lines mix cafe life + challenge/vote (see §9). Cast-wide dialogue still thin. |
| **Ship call (§7)** | **Blocked on Light** | Plumbing + gather + §11 + soft-day + Keep spatial arc look shippable; **do not** call full fidelity/Light ship until Day 4+ reasons + blind triad. |
| Historical Leg 2 (`20260713-1`) | **Closed FAIL** | Sleep-stuck Days 3–4 — do not re-score or continue. |
| Crashed Leg 3a (`20260715-1`) | **Closed** | Step-1650 `act_duration=None`; crash pack deployed before Leg 3b. |

### What’s already good on `20260717-1` (do not re-litigate)

- Director Days 1–3: `hold_for_shield` → `silent_pact` → `alliance_lock_in`
- **All Day 2–3 challenges and votes:** **`spatial_gate`** (only D1 challenge = deadline)
- Day 3 vote open: **spatial_gate @5072**, absents Mike / Nick / Vince (3) — not mass-absent
- Real challenge reasons: D1 10/15 · D2 11/14 · D3 10/13 — **not** mass-absent
- Elims real so far: Vincent D1 (tally 14), Ivan D2 (tally 13) — no phantom `vote_count: 1` (Day 3 elim still pending mid-vote)
- Sleep-stuck fixed: `sleeping_1440_like=0`; `post_vote_date` preserved (`2026-07-18` on survivors)
- Banlist: **0/31** on reasoned challenge rows
- No runner crash through Day 3 evening vote
- §9 soft-day: multi-block schedules + cafe act lines mix breakfast/lunch/people-watching with challenge notes / vote (Alex Butcher sample)
- §6 package: confirmed **not on disk yet** (expected pre-Light)

**Mode:** normal sprint (`diagnostic_mode: false`) — product data in Supabase / season state is enough  
**Gate triad (scoring only, after unblind):** Ivan · Diana · Mike  

Do **not** expect Remotion / public VO / share CTA from this run.

---

**Historical sim (closed):** `20260713-1` — Legs 1–2 scored 2026-07-15 (gather lock soft-fail / sleep-stuck).  
**Crashed attempt:** `20260715-1` — Leg 3a fatal @ step 1650 (pre–crash-pack).  
**Current score sim:** `20260717-1` — Leg 3b after sleep-stuck + crash-pack fixes — **§11 PASS mid-flight 2026-07-18**.

**Shipped for this score:**
- P0 Survival fidelity + Challenge Director + Light reason slots (8 IDs)
- **2026-07-14:** Personality attraction (weighted challenge pick / soft priors)
- **2026-07-14:** Gather prewindow lock (soft day outside appointments; hard last-hour cafe destination; seek paused in window; honest spatial absentees; opportunistic Survival talk on natural meet)
- **2026-07-15:** Sleep-stuck RCA fixes — no midnight `post_vote_date` restamp; regenerate plan on empty/all-sleep; gather lock wakes sleepers; all-absent vote fail-closed
- **2026-07-16:** Gather-hour crash pack (`20260715-1` @ step 1650) — word-boundary sleep detection (no `rest`⊂`restock`); gather lock mints complete travel action (never `None` duration); null-safe position reconciler; persist `season.phase` on transition; `/status/current` grace = `Premiere`

---

## Run status (ops)

| Leg | Steps | What happened |
|-----|------:|---------------|
| Leg 1 | ~2600 | Grace + Season Day 1 complete (challenge + elim). Day 1 challenge fired by **deadline** at 11:00 with mass absent (pre–gather-lock era / historical). Stopped overnight before Day 2 challenge. |
| Leg 2 (continue) `20260713-1` | +~4800 → **7399/7400 completed** | Gather lock + attraction live. Ended Season Day 5 morning (`claim_the_slot` active, unresolved). **Scored 2026-07-15 — FAIL sleep-stuck Days 3–4.** |
| Leg 3a (fresh) `20260715-1` | **crashed step 1650** @ Day 1 10:00 | Grace OK; Director armed `hold_for_shield`; gather lock opened then **fatal** `act_duration=None` (false sleep on `restock`). Superseded by crash pack + Leg 3b. |
| **Leg 3b (fresh) `20260717-1`** | **~5172+ running** @ Day 3 ~20:42 **VOTING** | **Mid-flight 2026-07-19:** §11 PASS. Director D1–3 OK. Spatial D2–D3 **chal + vote** (D3 vote @5072). Real reasons ~10–11/cast. 2 real elims so far. No sleep-1440. **Need Day 3 vote resolve + Day 4+ Light.** |

**Scoring authority now:** use **`20260717-1` (Leg 3b)** for gather lock, §11, Director, Keep reasons. Historical Leg 1–2 only for closed RCA. Light/blind only after Day 4+ on Leg 3b.

### Post-run score (2026-07-15) — Leg 2 verdict (closed)

**Gather lock soft-fail + deeper forensics needed** on `20260713-1`. Director Days 1–3 OK. Day 2 challenge = spatial + mostly real reasons. Days 3–4 = deadline + **everyone still in bed** (`f_daily_schedule = [['sleeping', 1440]]`); gather lock skips sleep so cafe census stayed **0**. Light (`whisper_chain`) ran with **0 real reasons**. Day 3–4 elims have empty tallies/`vote_count: 1`. **Do not use Leg 2 for Light/blind ship call.**

### Mid-flight score (2026-07-18 → 2026-07-19) — Leg 3b verdict (open run)

**§11 PASS on `20260717-1`.** Sleep-stuck + phantom-elim + Day 2–3 spatial gather look fixed. **2026-07-19:** Day 3 vote opened via **`spatial_gate` @5072** (3 absents); phase still **VOTING** at ~5172 — Keep spatial arc complete through vote *open*. Keep Director + reason persistence good enough to proceed. **Light / blind / attraction still blocked until Day 4+.** Keep process running; do not restart `double-api` mid-run.

---

## Mid-flight check (while a score leg is still running)

Use this **before** the full post-run score. Product data lands when a challenge **resolves** — empty new `challenge_results` mid-day is normal if phase is still `DIRECTIVE` / social. For **Leg 3b**, prioritize Day 3 vote **resolve** + Day 4+ Light after §11 and Day 3 vote *open* already cleared.

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

### Copy-paste on VPS (`SIM=20260717-1`)

```bash
SIM=20260717-1
BASE=/var/www/generative_agents/environment/frontend_server/storage/$SIM

# A) Pulse
curl -sk https://127.0.0.1:8001/api/simulations/$SIM/status/current \
  | python3 -c "import sys,json;d=json.load(sys.stdin);print(d['current_step'], d['curr_time'], d['status'], d.get('current_day_label'), d.get('is_generating'), d.get('backend_process_active'))"

# B) Season / director / results
python3 - <<PY
import json
from pathlib import Path
p = Path("$BASE/survival/season_state.json")
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

# C / G) Phase triggers (spatial vs deadline + absent lists)
python3 - <<PY
import json
from pathlib import Path
p = Path("$BASE/logs/survival_phase_trigger.ndjson")
for line in p.read_text().splitlines():
    if line.strip():
        print(json.dumps(json.loads(line), sort_keys=True))
PY

# D) Ops-voice smell on reasons
python3 - <<PY
import json, re
from pathlib import Path
BAN = re.compile(r"\b(pillar|refill|hardware pair|execute|firm votes|clean window)\b", re.I)
d = json.loads(Path("$BASE/survival/season_state.json").read_text())
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
# STEP=4585 python3 - <<'PY'
# import json,os
# from pathlib import Path
# step=int(os.environ["STEP"])
# d=json.loads(Path(f"/var/www/generative_agents/environment/frontend_server/storage/20260717-1/environment/{step}.json").read_text())
# cafe=sum(1 for v in d.values() if isinstance(v,dict) and "Hobbs" in str(v.get("address") or ""))
# print(f"step={step} at_hobbs={cafe}/{len(d)}")
# PY
```

### Mid-flight pass bar

**Leg 2 (closed FAIL):** sleep-stuck Days 3–4 — see historical capture below.

**Leg 3b (`20260717-1`) mid-flight 2026-07-19:**

- [x] Steps advancing; backend process alive (PID 1108378 through ~5172+)
- [x] Day 2+ challenge **and vote** prefer **`spatial_gate`** (D2 + D3 chal; D1–3 votes spatial)
- [x] After Day 2–3 resolve: `silent_pact` then `alliance_lock_in`
- [x] Day 2+ reasons mostly real (D2 11/14, D3 10/13 — not `"absent"` mass)
- [ ] Do **not** fail Light / blind triad until Day 4+ exists *(still waiting)*

**Leg 3b fire log (as of Day 3 VOTING ~20:42 / step 5172):**

| Day | Phase | Reason | Step | Absents (n) |
|----:|-------|--------|-----:|------------:|
| 1 | challenge | deadline | 1710 | 5 |
| 1 | voting | spatial_gate | 2190 | 1 |
| 2 | challenge | spatial_gate | 3145 | 3 |
| 2 | voting | spatial_gate | 3630 | 1 |
| 3 | challenge | spatial_gate | 4585 | 3 |
| 3 | voting | **spatial_gate** | **5072** | **3** (Mike Hooks, Nick Miller, Vince Vale) |

---

## 0. Before scoring — is the run usable?

### Leg 2 `20260713-1` (closed)

- [x] Sim finished (status `completed` / `stopped`; process gone) — ended **~7399** steps  
- [x] Season row exists; `challenge_results` has **multiple days**  
- [ ] No mid-run crash that skipped whole challenge days *(no crash, but Days 3–4 mass-absent / empty-vote — not clean product days)*  
- [x] Day count noted *(Days 1–4 resolved; Day 5 open — unusable for Light)*  

### Leg 3b `20260717-1` (active)

- [ ] Sim finished — **still running** at last check (~5172, Day 3 **VOTING** ~20:42)  
- [x] Season row exists; `challenge_results` has Days **1–3** Keep IDs resolved  
- [x] No mid-run crash through Day 3 evening vote open (past Leg 3a step-1650 failure)  
- [x] Day count so far: **Season Day 3** (3 challenges resolved; Day 3 vote **in progress**; Day 4+ still needed for Light)  
- [x] §11 primary gate cleared mid-flight — OK to treat this run as the score carrier  
- [x] Day 3 vote **opened** via spatial_gate @5072 (3 absents) — resolve/elim still pending  

**Quick status:**
```bash
curl -sk https://127.0.0.1:8001/api/simulations/20260717-1/status/current | python3 -m json.tool
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

- [x] Day 1 = `hold_for_shield` *(Leg 3b confirmed)*  
- [x] Day 2 = `silent_pact` *(Leg 3b confirmed)*  
- [x] Day 3 = `alliance_lock_in` *(Leg 3b confirmed; still `active` during Day 3 VOTING)*  
- [ ] Later days ≠ repeat of already-played IDs *(pending Day 4+ on Leg 3b; Leg 2 had Day 4 `whisper_chain` / Day 5 `claim_the_slot` but unscorable)*  

---

## 2. Reason persistence (P0 plumbing)

For each completed challenge day in `challenge_results`:

- [x] `decisions[]` present (not just winners / narrative)  
- [x] Most decision rows have non-empty **real** `reasoning` (not `"absent"`) — **Day 2+ bar** *(Leg 3b: D1 10/15, D2 11/14, D3 10/13 — PASS; Leg 2 Days 3–4 were 0/N — closed FAIL)*  
- [ ] If `leaders_burden` ran: `mark` / penalty target **and** `mark_reasoning` present *(N/A — has not run on Leg 3b)*  
- [x] Elimination / vote days: vote reasons present where expected *(Leg 3b Days 1–2: tallies 14 and 13, reasons_n match; Day 3 vote opened spatial @5072 — final tally/reasons pending mid-VOTING)*  

**Pass bar:** reasons exist as first-class data you can read without digging LLM dumps.

**Leg 3b samples (Keep — skim only):** personal fold on low card; protect on neutral trust; mutual lock with active ally — not ops register. `choice_reason_plain` often mirrors `reasoning` (soft note).

**Leg 1/2 note (closed):** Day 1 historically high absent before gather lock; Leg 2 Days 3–4 mass-absent after sleep-stuck.

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

**Keep IDs (Days 1–3):** Leg 3b skim OK (personal, alliance-aware by design of Keep). Do not reopen Day 1 mechanics.

Per Light ID that ran:

- [ ] **Leg 3b:** no Light ID resolved yet — **pending Day 4+**  
- [x] Leg 2 only (closed, unscorable): `whisper_chain` — 12/12 `"absent"` (cast asleep); `claim_the_slot` started Day 5 unresolved  
- [ ] Attractors `bid_for_vest` / `claim_the_slot` — **not tested on Leg 3b**  

---

## 4. Blind-choice sheet (creative gate)

After trailer package / day extract for a day that includes Light challenges:

- [ ] `challenge_blind_choice.md` exists — **names stripped** (Agent A/B/…) *(not packaged — pending Light day)*  
- [ ] `challenge_blind_choice.json` exists — **names kept** (ops / unblind) *(not packaged)*  
- [x] Banlist rate reported on Keep reasons — Leg 3b challenge reasons **0/31**; do **not** hard-fail lock on rate alone  

**Blind score (you + Diana + Mike, before unblind):**

- [ ] From choice + reason alone, can you tell *who this person is* (not just “smart player”)? *(blocked — no Light reasons on Leg 3b yet)*  
- [ ] Pass = wiring enough for that ID · Fail = escalate **that ID only** (no catalog redesign)  

---

## 5. Fidelity / clone smell (P0 overlay)

Spot-check Day 1–2 chat + vote snippets (cast-wide; Overlay A/B not required):

- [ ] Fewer alliance/threat/reputation labels in seek/overlay-style copy *(soft — Keep IDs are alliance-heavy by design; Leg 3b act skim is cafe life+game, not full dialogue)*  
- [x] Less “pillar / refill / hardware pair / execute / firm votes / clean window” in challenge + vote reasons *(Leg 3b banlist **0/31**; Leg 2 was 1/18 on reasoned rows)*  
- [x] Agents still sound like themselves more often than like one shared strategist *(Leg 3b Keep samples readable as personal)*  

Optional: run recognition / clone lexicon helper on a day package if you built one — treat as signal, not ship gate.

---

## 6. Teach cards / package hygiene

- [ ] Teach cards exist for Light IDs that ran (plain-language “what this challenge is”) *(pending Light day)*  
- [ ] `day_reasoning` (or equivalent) available for days you care about *(pending Light day)*  
- [x] No claim that Remotion / public VO is ready  
- [x] **Leg 3b package absence confirmed (2026-07-18):** `find` for `*blind* / *teach* / *day_reasoning* / *trailer* / *package*` under sim storage → **empty**. `survival/` listing = `season_state.json` + `agents/` only. **Expected** until a Light day is packaged; not a product fail.  

---

## 8. Gather prewindow lock (2026-07-14)

Score on **Day 2+** challenge/vote only (Day 1 deadline baseline is OK / out of scope as gather-lock fail).

### Leg 3b `20260717-1` (authoritative)

- [x] Challenge (and votes so far) fire via **`spatial_gate`** more often than late **`deadline`** *(D2 chal, D2 vote, D3 chal, **D3 vote** = spatial; only D1 chal = deadline)*  
- [ ] Env census in last hour before deadline: **≥12/15** at Hobbs at **fire** step *(not fully captured on disk; spatial_gate implies quorum path; optional census at 3145 / 3630 / 4585 / **5072**. Midday SOCIAL sample ~10/13 after D3 chal — not the prewindow bar.)*  
- [x] Far fewer `"absent"` challenge reasons than historical Day 1 mass-absent *(Leg 3b D2 3/14, D3 3/13 — PASS)*  
- [x] Phase-trigger NDJSON on spatial success lists **true** absentees (non-empty OK) *(D3 vote listed 3)*  
- [x] Soft hours still show multi-block lifestyle schedules outside lock windows *(Leg 3b: 39–80 blocks/day, not sleeping-1440)*  

**Leg 3b gather lock:** **PASS mid-flight** through full Keep chal+vote arc (spatial Day 2–3). Optional fire-step Hobbs census still nice-to-have.

### Leg 2 `20260713-1` (closed FAIL)

- Day 2 chal spatial; Day 2 vote + Days 3–4 chal/vote deadline; Days 3–4 **0 at Hobbs** / all bed — **FAIL** (superseded by Leg 3b).

**Fail this section →** do not call gather lock “shipped”; fix before treating Light score as clean.  
**Current call:** gather lock **shippable on plumbing** from Leg 3b (D3 vote open confirmed spatial). Still confirm D3 vote **resolve**/elim integrity + optional fire-step census.

---

## 9. Soft day + opportunistic Survival talk (2026-07-14)

- [x] Outside gather lock windows, Doubles still have multi-block lifestyle schedules *(Leg 3b — not collapsed to all-day sleep; Leg 2 Days 3–5 failed)*  
- [x] Soft brief / plans allow game inside a normal day — **not** forced all-day strategy meetings *(Leg 3b brief: challenge/vote are fixed calendar events; rest of day should still feel like this person)*  
- [x] Spot-check ≥1 soft-hour plan/act line that mixes life + game without ops register *(Leg 3b 2026-07-18 — **soft PASS**)*  

**Leg 3b soft skim notes (2026-07-18):**
- Movement JSON on disk: `movement_chatish_hits=0` (no chat payloads in sampled movement files — common on lean/supabase runs; not a fail alone).
- Persona memory/act strings (Alex Butcher sample, 25 lines): **life** — walk to Hobbs, order breakfast/coffee, lunch, people-watching, iced tea, dinner after vote; **game at cafe** — challenge notes/strategy, alliance lock-in rehearsal, silent negotiation, handshake pact, evening vote, challenge briefing/results.
- Limits: one-persona heavy sample; act/plan lines more than full dialogue transcripts; cast-wide chat skim still thin.
- **Call:** §9 **soft PASS** on Leg 3b — enough for soft-day; does **not** unlock Light (§3), blind (§4), or ship (§7).

---

## 10. Personality attraction (2026-07-14)

Only once Day 4+ / weighted picks actually run:

- [ ] Challenge centering / pool picks are not “always the same top social-capital Double” *(not tested — no Day 4+ on Leg 3b yet)*  
- [ ] If `choice_reason_plain` appears, it reads as soft prior language agents can defy — not a hard scoreboard *(present on Keep days; often mirrors `reasoning` — soft; Day 4+ still needed)*  
- [x] Resolve still does **not** sole-rank primary power by social capital alone *(no SC-only scoreboard signal on Keep resolves)*  

---

## 11. Sleep-stuck + all-absent regression (2026-07-15) — Leg 3 primary gate

**Purpose:** Confirm the RCA fixes on a **fresh** Survival sim before treating Light / blind as scorable again.  
**Do not** continue `20260713-1` Day-5 sleep-stuck scratch.  
**Minimum run:** through **Season Day 3 morning** after Day 2’s vote (ideally Day 4 for Light).  
**Sim code:** `20260717-1`

### Pass / fail matrix

| Fix | Pass signal | Fail / degradation |
|-----|-------------|--------------------|
| Midnight `post_vote_date` | After a vote overnight, next morning cast is **not** all in bed; schedules multi-block | Cast asleep through 10–11 again; `post_vote_date` equals **new** calendar morning |
| Degenerate-schedule plan | Morning after vote: `daily_req` / hourly plan regenerates (not empty + sleeping-1440) | Same-evening post-vote recovery clobbered into a full-day replan before midnight |
| Gather lock wakes | Day 2–3 challenge (ideally vote) lean **`spatial_gate`**; Hobbs ≥ ~80% in last hour; **no** runner crash at 10:00 / 19:00 | Sleepers ignored; **or** soft-day destroyed; **or** TypeError on `act_duration` (pre–2026-07-16) |
| All-absent fail-closed | If mass-absent: **no** elim with empty tally / `vote_count: 1`; NDJSON `all_absent_no_quorum`; same cast next morning | Phantom lottery elim returns |

### Checkboxes (Leg 3b — `20260717-1`, mid-flight 2026-07-19)

- [x] Fresh sim (new code); not a continue of sleep-stuck `20260713-1`  
- [x] After vote nights → next days: sample scratch schedules **≠** `[['sleeping', 1440]]` for alive cast *(0× sleeping-1440-like; 39–80 blocks)*  
- [x] `post_vote_date` on survivors stays the **vote calendar date**, not restamped to the next morning *(survivors `post_vote=2026-07-18` during Day 3; not restamped to 2026-07-19)*  
- [x] Day 2+ challenge fire prefers **`spatial_gate`** (D2 + D3)  
- [x] Day 2+ **votes** fire prefers **`spatial_gate`** (D1–D3; D3 vote @5072, 3 absents)  
- [x] Day 2+ challenge `absent` rate far below mass-absent / not all-alive *(3/14, 3/13)*  
- [x] Soft hours outside lock windows still multi-block (jobs/school/errands shape)  
- [x] No elimination with empty `vote_tally` + `vote_count: 1` *(Vincent D1 tally_n=14; Ivan D2 tally_n=13; Day 3 elim not yet written mid-VOTING)*  
- [x] `all_absent_no_quorum` **not** seen (and no phantom elim)  
- [x] Director Days 1–3 still `hold_for_shield` → `silent_pact` → `alliance_lock_in`  
- [ ] Only if Days 2–3 clean: proceed to Light (§3) / blind (§4) on Day 4+ — **Keep days clean through D3 vote open; Light still pending; confirm D3 elim when VOTING ends**  

### Mid-flight probes (Leg 3) — copy-paste on VPS

```bash
SIM=20260717-1

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

- [x] **§11 pass** — sleep-stuck + all-absent gates clear; continue to Light/blind score on this sim  
- [ ] **§11 soft-fail** — gather/census still weak but no all-day sleep; tune lock/quorum before Light  
- [ ] **§11 fail** — sleep-stuck or phantom elim recurred; do not score Light; deeper forensics  

### Leg 3 capture

| Field | Fill in |
|-------|---------|
| New sim code | **`20260717-1`** (Leg 3b; Leg 3a `20260715-1` crashed @1650) |
| Days completed (season) | **3 challenges resolved**; Day 3 vote **opened** spatial @5072; still **VOTING** at ~step 5172 / Day 3 ~20:42; Day 4+ pending |
| Day 2 morning schedule OK? | **yes** — `sleeping_1440_like=0`; multi-block schedules |
| `post_vote_date` vs next morning | **preserved** (`2026-07-18` on survivors during Day 3) |
| Day 2+ challenge fires | D2 chal **spatial_gate** @3145 · D2 vote **spatial_gate** @3630 · D3 chal **spatial_gate** @4585 · D3 vote **spatial_gate** @5072 |
| Day 2+ absent rates | D2 chal **3/14** · D3 chal **3/13** · D3 vote open **3** absents (Mike/Nick/Vince); D1 chal 5/15 deadline baseline |
| `all_absent_no_quorum` seen? | **no** |
| Soft-day outside lock OK? | **yes** — schedules multi-block; §9 soft skim **PASS** (cafe life + challenge/vote acts); package still absent |
| §11 verdict | **pass** |
| Next action | Wait for Day 3 VOTING to **resolve** (elim integrity) → **Day 4+ Light**; package blind sheet; Ivan/Diana/Mike triad; then §7 ship call |

---

## 7. Verdict for tomorrow’s call

**Note:** Leg 2 checkboxes below are **historical**. Current ship posture is driven by **Leg 3b §11 PASS** + pending Light.

Pick one (update after Day 4+ Light):

- [ ] **Ship path OK** — Light wiring + director + persist + gather lock look good enough to keep iterating on fidelity / video gate *(plumbing/gather/§11 look ready; Light not scored yet)*  
- [ ] **Light re-prompt 1–2 IDs** — list which (usually bid / claim)  
- [ ] **Gather lock soft-fail** — *(cleared on Leg 3b; Leg 2 historical only)*  
- [ ] **Deeper forensics needed** — *(not indicated on Leg 3b mid-flight)*  

**Historical Leg 2 call (closed):** gather lock soft-fail + deeper forensics (sleep-stuck Days 3–4).

### Capture

| Field | Leg 2 (closed) | Leg 3b (active) |
|-------|----------------|-----------------|
| Days completed | Days 2–4 resolved; Day 5 started; ended step 7399 | Days 1–3 challenges resolved; D3 vote **open** spatial @5072; running ~5172 Day 3 **VOTING** |
| Light IDs that ran | `whisper_chain` all-absent; `claim_the_slot` unresolved | **none yet** |
| Day 2+ challenge fire reason | D2 spatial; D3–4 deadline | D2–D3 chal+vote all **spatial_gate** |
| Day 2+ absent rate | D2 3/14; D3–4 13/13, 12/12 | D2 3/14; D3 chal 3/13; D3 vote open 3 absents |
| Gather lock pass/fail | **FAIL** (sleep-stuck) | **PASS** mid-flight (full Keep arc) |
| Soft-day talk spot-check | D2 OK; D3+ unusable | **Soft PASS** (2026-07-18 act/memory skim); movement chats 0 on disk |
| Teach / blind package | Not packaged | **Absent** on VPS (`season_state` + `agents` only) — expected pre-Light |
| Attraction note | Unscorable | **Not tested** (need Day 4+) |
| Blind triad pass/fail | **Blocked** | **Blocked** until Light package |
| Worst attractor | N/A | N/A |
| Next action | Deploy fixes; fresh sim | **Continue `20260717-1` → D3 vote resolve → Day 4+ Light + blind triad** |
| RCA (2026-07-15) | Midnight `post_vote_date` restamp → sleeping-1440 → gather skip → phantom elims. **Fix shipped 2026-07-15 + crash pack 2026-07-16.** | Leg 3b validates fixes mid-flight (§11 pass); D3 vote open spatial 2026-07-19. |

---

## Out of scope (do not reopen)

- Day 1 `hold_for_shield` mechanic redesign  
- Catalog Replace / Mechanic tweak  
- Remotion / public VO / share CTA  
- Overlay A/B experiment (unless clone smell is still catastrophic)  
- Changing Director Days 1–3 order  
- Re-scoring Day 1 mass-absent / deadline as a gather-lock failure (baseline / out of Day 2+ bar)  
- Self-serve Double / post-chat learning (separate epic — not this sim score)  
- Continuing or “repairing” `20260713-1` Day-5 sleep-stuck scratch to validate §11 (use fresh sim — done: `20260717-1`)  
- Re-scoring crashed `20260715-1` (superseded by crash pack + Leg 3b)  
