# 2026-07-14 checklist — score Survival fidelity (P0 + Light + gather lock)

## Brief summary

**Leg 3b (`20260717-1`) is done.** It closed the big Survival plumbing gates: gather lock, sleep-stuck / phantom-elim (§11), Keep Director order, and real challenge/vote reasons through Season Day 3. Three boots were real votes (Vincent → Ivan → Mike). The run stopped on the **~5200 step budget** during Day 3 elimination night — clean complete, not a crash — so **Day 4+ Light never ran**.

| Closed (ship plumbing) | Still open (need longer run) |
|------------------------|------------------------------|
| Gather lock Day 2–3 (spatial chal+vote) | Light soul reasons (§3) |
| Sleep-stuck + empty-tally elim | Blind triad Ivan/Diana/Mike (§4) |
| Director Days 1–3 Keep IDs | Teach / day package (§6) |
| Keep reason persistence | Attraction Day 4+ (§10) |
| Soft-day shape (soft pass) | Full fidelity/Light ship call (§7) |

Movement/body jank (teleports, staff-zone, labels) is a **separate** track: `TODO_action-location.md` — not a Survival checklist fail.

Earlier legs: Leg 2 (`20260713-1`) FAIL sleep-stuck · Leg 3a (`20260715-1`) crash @1650 — superseded.

---

## What’s next

1. **Do not** continue or “repair” completed `20260717-1` for Light.
2. **Start a fresh Survival sprint** (new sim code) with a **higher step budget** — aim **≥7500–9000** steps so the run clears Day 4–5 Light with margin (this Leg died ~Day 3 night at 5200).
3. On that run, score in order:
   - Day 4+ Director (no ID repeat) + first Light resolve  
   - §3 Light soul reasons (skim; watch bid/claim attractors)  
   - Package blind/teach sheets → **§4 triad** (Ivan · Diana · Mike) before unblind  
   - Only then update §7 full ship call  
4. Optional polish only: fire-step Hobbs census; cast-wide chat skim (§5).
5. In parallel (different workstream): action-location RCA from `TODO_action-location.md` if playback immersion is the next product pain.

**Mode for next score leg:** normal sprint, `diagnostic_mode: false`, same Keep→Light checklist below.

---

## Status snapshot (2026-07-19) — **POST-RUN** (detail)

**Score sim:** `20260717-1` (Leg 3b) — **`completed`** at step **5199/5200** (~budget end), sim clock Day 3 **~21:10**, process gone.  
**Final season snapshot (Supabase `load_survival_season_state`):** phase **`ELIMINATION`**, day **3**, status still `running` in season row (engine stopped mid-elim ceremony), **12 remaining**, **3 eliminated**.

### Post-run verdict (Leg 3b) — one screen

| Gate | Result | Notes |
|------|--------|--------|
| **§0 usable Keep run** | **PASS** | Finished cleanly (budget), no crash; 3 Keep days + 3 real elims |
| **§1 Director Days 1–3** | **PASS** | `hold_for_shield` → `silent_pact` → `alliance_lock_in` |
| **§2 reason persistence** | **PASS** | D1 10/15 · D2 11/14 · D3 10/13 real; vote tallies real all 3 days |
| **§8 Gather lock** | **PASS** | D2–D3 chal+vote all **`spatial_gate`**; only D1 chal = deadline |
| **§9 Soft day** | **Soft PASS** | Multi-block schedules + cafe life/game acts (earlier skim) |
| **§11 Sleep-stuck / phantom elim** | **PASS** | No sleeping-1440; no empty-tally elim; D3 Mike Hooks 5.0 / tally_n **10** |
| **§3 Light soul reasons** | **NOT TESTED** | Step budget ended **before Day 4** — no Light ID ran |
| **§4 Blind triad** | **NOT TESTED** | Blocked on Light + package |
| **§6 Teach / package** | **NOT TESTED** | No Light day to package |
| **§10 Attraction** | **NOT TESTED** | Needs Day 4+ weighted picks |
| **§7 Full ship (Light/fidelity)** | **BLOCKED on Light** | Plumbing + Keep + gather + §11 **shippable**; Light/blind need a **longer** run (or continue/fork with higher `max_steps`) |
| **Movement realism (separate)** | **Open RCA** | See `TODO_action-location.md` — teleports / staff-zone / label drift (not Survival checklist fail) |

### Still open / next action

| Item | Status | Notes |
|------|--------|--------|
| **§3 / §4 / §6 / §10 / Light ship** | **Blocked** | Need **Day 4+** on a fresh or continued Survival sprint with **>5200** steps (this run used ~5200 ≈ stop mid Day-3 elim night) |
| **Prewindow Hobbs census at fire step** | **Soft / optional** | Spatial_gate is authority; disk census never fully captured |
| **§5 cast-wide chat fidelity** | Soft | Keep reasons OK; full dialogue skim not required for §11 |
| Historical Leg 2 / Leg 3a | Closed | FAIL sleep-stuck / crash — superseded |

### What’s closed on `20260717-1` (do not re-litigate)

- Director Days 1–3 Keep order  
- Gather lock Day 2–3 full arc (chal **and** vote spatial)  
- Sleep-stuck + all-absent / phantom-elim regression  
- Challenge reason plumbing on Keep days  
- Three real boots: **Vincent D1 (5.0, tally 14)** · **Ivan D2 (4.5, tally 13)** · **Mike D3 (5.0, tally 10)**  
- Gathering compliance analyzer: **100%** chal+vote Days 1–3  
- No runner crash (unlike `20260715-1`)

**Mode:** normal sprint (`diagnostic_mode: false`) — product data in Supabase / season state is enough  
**Gate triad (scoring only, after unblind):** Ivan · Diana · Mike  

Do **not** expect Remotion / public VO / share CTA from this run.

---

**Historical sim (closed):** `20260713-1` — Legs 1–2 scored 2026-07-15 (gather lock soft-fail / sleep-stuck).  
**Crashed attempt:** `20260715-1` — Leg 3a fatal @ step 1650 (pre–crash-pack).  
**Score sim (completed):** `20260717-1` — Leg 3b — **§11 + gather + Keep Director PASS post-run 2026-07-19**; Light unscored (budget).

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
| **Leg 3b (fresh) `20260717-1`** | **5199/5200 completed** @ Day 3 ~21:10 **ELIMINATION** | **Post-run 2026-07-19:** §11 + gather + Director Keep **PASS**. Spatial D2–D3 chal+vote. Reasons real. 3 real elims (Vincent, Ivan, **Mike Hooks**). Budget stopped before Day 4 → **Light unscored**. |

**Scoring authority:** **`20260717-1`** closes gather lock + §11 + Keep Director/reasons. Light/blind need a **new longer** Survival sprint (recommend `max_steps` ≥ **7500–9000** to clear Day 4–5). Do not continue this completed process; fork fresh or start new sim code.

### Post-run score (2026-07-15) — Leg 2 verdict (closed)

**Gather lock soft-fail + deeper forensics needed** on `20260713-1`. Director Days 1–3 OK. Day 2 challenge = spatial + mostly real reasons. Days 3–4 = deadline + **everyone still in bed** (`f_daily_schedule = [['sleeping', 1440]]`); gather lock skips sleep so cafe census stayed **0**. Light (`whisper_chain`) ran with **0 real reasons**. Day 3–4 elims have empty tallies/`vote_count: 1`. **Do not use Leg 2 for Light/blind ship call.**

### Post-run score (2026-07-19) — Leg 3b verdict (**closed for Keep/§11; open for Light**)

**§11 PASS · gather lock PASS · Keep Director + reasons PASS** on `20260717-1`.  
Day 3 vote resolved: **Mike Hooks** eliminated (votes **5.0**, tally_n **10**, reasons_n **10**, not suspicious). Season left in **ELIMINATION** because step budget hit ~5200 during/after elim — engine completed; season row not advanced to Day 4.  
**Light / blind / attraction / full fidelity ship: NOT TESTED** — need longer run. Movement/body jank tracked in `TODO_action-location.md`, not a Survival gate fail.

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

### Leg 3b `20260717-1` (completed 2026-07-19)

- [x] Sim finished — status **`completed`**, process gone, **5199/5200** steps (~21:10 Day 3)  
- [x] Season row exists; `challenge_results` has Days **1–3** Keep IDs resolved  
- [x] No mid-run crash (past Leg 3a step-1650 failure); stopped on **step budget**, not fatal error  
- [x] Day count: **Season Day 3 complete** (3 challenges + 3 elims); **no Day 4** — Light not reachable on this budget  
- [x] §11 primary gate **PASS** — score carrier for gather/sleep-stuck/Keep  
- [x] Day 3 vote opened spatial @5072 **and resolved** — Mike Hooks elim (5.0, tally 10)  
- [ ] Day 4+ / Light — **not reached** (ops: raise `max_steps` next Leg)  

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
- [x] Elimination / vote days: vote reasons present where expected *(Leg 3b: D1 tally 14 · D2 tally 13 · D3 Mike Hooks tally **10** / reasons **10** — all non-suspicious)*  

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
**Current call:** gather lock **shipped on plumbing** from Leg 3b post-run (full Keep chal+vote spatial + D3 elim real). Optional fire-step Hobbs census still nice-to-have only.

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
- [x] No elimination with empty `vote_tally` + `vote_count: 1` *(Vincent D1 tally 14; Ivan D2 tally 13; Mike D3 tally **10** — all real)*  
- [x] `all_absent_no_quorum` **not** seen (and no phantom elim)  
- [x] Director Days 1–3 still `hold_for_shield` → `silent_pact` → `alliance_lock_in`  
- [ ] Only if Days 2–3 clean: proceed to Light (§3) / blind (§4) on Day 4+ — **Keep clean; Light not reached (step budget)**  

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
| Days completed (season) | **Season Day 3 complete** (3 chal + 3 elims). Engine **completed** 5199/5200 @ ~21:10 Day 3 **ELIMINATION**. **No Day 4.** |
| Day 2 morning schedule OK? | **yes** — `sleeping_1440_like=0`; multi-block schedules |
| `post_vote_date` vs next morning | **preserved** (`2026-07-18` on survivors during Day 3) |
| Day 2+ challenge fires | D2 chal **spatial_gate** @3145 · D2 vote **spatial_gate** @3630 · D3 chal **spatial_gate** @4585 · D3 vote **spatial_gate** @5072 |
| Day 2+ absent rates | D2 chal **3/14** · D3 chal **3/13** · D3 vote open **3** absents (Mike/Nick/Vince); D1 chal 5/15 deadline baseline |
| `all_absent_no_quorum` seen? | **no** |
| Soft-day outside lock OK? | **yes** — schedules multi-block; §9 soft skim **PASS** |
| §11 verdict | **pass** |
| Elims | D1 Vincent 5.0 (tally 14) · D2 Ivan 4.5 (tally 13) · D3 **Mike Hooks 5.0 (tally 10)** — none suspicious |
| Next action | **New longer Survival sprint** (`max_steps` ≥ 7500–9000) for Day 4+ Light + blind triad. Keep/§11/gather closed on this sim. |

---

## 7. Verdict for tomorrow’s call

**Note:** Leg 2 = historical FAIL. Leg 3b = **Keep/§11/gather ship path OK**; full product ship still waits on Light.

Pick one:

- [x] **Ship path OK (plumbing only)** — director + persist + gather lock + §11 good enough to stop re-proving Keep nights; iterate fidelity/video separately  
- [ ] **Ship path OK (full Light/fidelity)** — **not yet** (Light unscored)  
- [ ] **Light re-prompt 1–2 IDs** — N/A until Light runs  
- [ ] **Gather lock soft-fail** — *(cleared on Leg 3b post-run)*  
- [ ] **Deeper forensics needed** — not for Survival gates; movement RCA is `TODO_action-location.md`  

**Historical Leg 2 call (closed):** gather lock soft-fail + deeper forensics (sleep-stuck Days 3–4).

### Capture

| Field | Leg 2 (closed) | Leg 3b (completed) |
|-------|----------------|--------------------|
| Days completed | Days 2–4 resolved; Day 5 started; ended step 7399 | **Days 1–3** Keep complete; engine **5199/5200 completed** @ Day 3 ELIMINATION ~21:10 |
| Light IDs that ran | `whisper_chain` all-absent; `claim_the_slot` unresolved | **none** (budget) |
| Day 2+ challenge fire reason | D2 spatial; D3–4 deadline | D2–D3 chal+vote all **spatial_gate** |
| Day 2+ absent rate | D2 3/14; D3–4 13/13, 12/12 | D2 3/14; D3 chal 3/13; D3 vote open 3 |
| Gather lock pass/fail | **FAIL** (sleep-stuck) | **PASS** post-run |
| Soft-day talk spot-check | D2 OK; D3+ unusable | **Soft PASS** |
| Teach / blind package | Not packaged | **Absent** — expected (no Light) |
| Attraction note | Unscorable | **Not tested** |
| Blind triad pass/fail | **Blocked** | **Blocked** |
| Elims | D3–4 phantoms | Vincent / Ivan / **Mike Hooks** — all real tallies |
| Worst attractor | N/A | N/A |
| Next action | Deploy fixes; fresh sim | **New longer sprint** for Day 4+ Light + blind; Keep/§11 closed |
| RCA (2026-07-15) | Midnight restamp → sleep-1440 → phantom elims. Fix + crash pack shipped. | Leg 3b **validates** fixes post-run (§11 pass). |

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
