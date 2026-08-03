# 20260802 — Checklist: affordance_required loader plumb (piano gates live)

**Purpose:** Score-prove tip **`1c830aec`** turns on starved affordance gates (piano/mic). Re-measure piano vs Pass A baseline; re-census with gates live; decide L1 only after that. **Do not** mix S1 or L1 on this tip.

**Prior paper (compressed):** `20260801_checklist.md` — Pass A @ `be158e24` / `20260801-1` · ship **NO** · enabling defect = loader drop · baseline piano **60 / 96** · honest CD **461**

**Shipped this tip:**
- `_load_registry` copies `affordance_required` into `object_meta`
- `tests/test_maze_registry_loader_contract.py` — real loader + getter↔JSON contract + post-validate leave piano on mismatch

**Out of scope:** Phase-8 special-case · GUARD L1 demote · S1 willingness/seek · Talk Path A · registry generator realignment · normative SOT

**Already proven (regression only):** place-claim bath→Park **0** · dorm-@ **0** · teleports clean · Class P mass reopen absent (soft 9 watch) · CD gap0 collapsed

> **Ship rule:**  
> - **This tip green** = piano V2/emit materially below **60 / 96** (or ≈0) **and** gates matter (any of: sticky skip / contract reject / fallthrough / R6 evidence) **or** residual ≈0 with play-piano still sealing piano.  
> - Prefer **unique persona-steps** (normalize by eligible Hobbs acts), not raw `:piano` log lines.  
> - Do **not** hard-require fallthrough volume (upstream R6 may keep it at 0).  
> - **L1** only from **this** post-flag census. **S1** later, sized off **461**.  
> - Spot-check mic + ~5 oddly phrased piano/mic acts for over-rejection.

**BE tip:** `origin/railway` @ **`1c830aec`**  
**Score sim:** `20260802-1`  
**Baseline / fork:** `soul15_seed_20260224`  
**Target steps:** `≥2600` (clear Day-1 vote **20:00** ≈ step ~2250 on 06:30 start)  
**Env:** `HEADLESS_MOVEMENT_ENABLED=true` · `HEADLESS_STRICT_ABORT=true` · `INTENT_PERSIST_HARD_FAIL=true` · `PLACE_LANGUAGE_API_PREFER_EMIT=true`  
**Posture:** Survival sprint + diagnostic. Do **not** restart `double-api` while this sim is live.

**Launch (VPS):** see chat / §0 below.

---

### 0. Preflight

```bash
# confirm tip + no live runner
cd /var/www/generative_agents
git log -1 --oneline   # expect 1c830aec
curl -k https://localhost:8001/api/simulations/20260801-1/status/current | python3 -m json.tool
# backend_process_active should be false

# fork + start
curl -k -X POST https://localhost:8001/api/simulations/fork \
  -H "Content-Type: application/json" \
  -d '{"sim_code":"20260802-1","baseline":"soul15_seed_20260224","description":"affordance_required loader plumb score","copy_memories":true,"copy_coords":false}' | python3 -m json.tool

curl -k -X POST https://localhost:8001/api/simulations/20260802-1/start \
  -H "Content-Type: application/json" \
  -d '{"action":"start","parameters":{"max_steps":2600,"generation_mode":"sprint","diagnostic_mode":true}}' | python3 -m json.tool

curl -k https://localhost:8001/api/simulations/20260802-1/status/current | python3 -m json.tool
```

- [x] VPS tip **`1c830aec`**; `double-api` active; health healthy
- [x] Flag assert: piano **True** · mic **True** · seating **False** (`PASS: affordance_required live`)
- [x] Prior sim `20260801-1` stopped / no process (`status=stopped`, `backend_process_active=false`)
- [x] Fork + start `20260802-1`; UUID / PID / tip recorded
- [x] Survival armed by ~step 30 (`is_survival=true`) — confirmed @ step **42** · label **Premiere** · engine_day 1

**Recorded:** UUID `62bbdf0e-568e-49b7-86e3-d1d144fbfcf6` · PID `2471155` · tip `1c830aec` · fork `2026-08-03T03:51:18Z` · `curr_time` start `2026-08-02 06:30` · 15 personas · sprint + diagnostic · maze `9e390f7b-…` · max_steps 2600

**Early smoke @ step 42 (`2026-08-03T04:13Z` wall):** `status=running` · PID `2471155` continuous · `is_generating=true` · `last_generated_at` fresh · Survival **Premiere** · `curr_time` `07:13` — **PASS soft; let run.**

**Mid-run @ ~step 698 (`2026-08-03T14:08Z` wall / sim ~18:08):** still generating · bath→Park **0** · addr≠@ **0** · piano V2/non-play **0** · Class P soft **7** (was 4) · play-piano **17** Olivia (**1**/17 sealed `:piano`, rest Hobbs cafe) · CD **171** instrument · cafe lively · vote ~step 810 still ahead.

---

### 1. Early smoke (~steps 50–100)

- [x] Tip still `1c830aec`; runner alive — PID continuous through step **42+** (Supabase AL through **~50**)
- [ ] No `HEADLESS_STRICT_ABORT` / traceback flood *(VPS soak not grepped)*
- [ ] Soft: soak shows `PLACE-CLAIM-DEFER` and/or `TRAVEL-DEFER` *(VPS soak not grepped)*
- [x] Soft: no early stretch-bathroom → Park — sprite **0** through step 45

**Result:** PASS soft @ ~50 — health + Survival + no early bath/stretch→Park. Soak GUARD greps still need VPS.

---

### 2. Held regressions — **must stay green**

*Early read @ steps 0–50 (not final — re-confirm ≥vote hour):*

| Bar | Pass A | This tip @ ~50 | Pass? |
|-----|--------|----------------|-------|
| Place-claim bath→Park | **0** | **0** | early OK |
| Dorm-@ / addr≠@ | **0** | addr≠@ **0** | early OK |
| TELEPORT | clean | none (realism: 1 CD only @45) | early OK |
| Class P named-travel→Park | soft **9** | **4** early rows (Olivia hobbs→Park) | soft watch (same shape; too early for call) |
| Prefer-emit morning | not re-run | _ | soft *(carry)* |

**Result:** Early hold OK — place-claim / addr≠@ / teleport clean through ~50. Class P soft present (4); not a mass reopen. **Re-score at ≥20:00.**

---

### 3. Primary gate — piano with flags live

Baseline = Pass A @ ~1928 (`20260801-1`):

| ID | Pass A | This tip @ ~50 | Pass? |
|----|--------|----------------|-------|
| **PIANO V2** | **60** | **0** | too early — cafe lunch/challenge not hit |
| **PIANO emit** (non-play persona-steps) | **96** | **0** sprite leaf-piano | too early |
| Play-piano still seals `:piano` | n/a | **0** play matches | no signal yet |
| Gate-fired evidence | fallthrough **0** (starved) | _ | needs VPS soak after Hobbs traffic |
| P8→piano (mismatched act) | **17** intros | _ | needs soak |
| Sticky-piano | **4** | _ | needs soak |
| Mic over-rejection (soft) | n/a | _ | later |

**Checks:**
- [ ] Analyzers: AL V2 + sprite non-play emit (persona-steps) — **partial early: V2=0 / emit=0 @~50 only**
- [ ] Soak census (§6) with gates live — do **not** use Pass A bucket table as L1 evidence
- [ ] If residual remains: attribute intros (P8 / GUARD / sticky / LLM); streak↔P8 only if needed
- [ ] Spot: matching "play piano" / mic perform still land on object

**Soft early noise:** APT-N V4 **61** (Olivia morning Apartment-1 text) — record; not ship-blocker. Gap-1/2 **0** so far.

**Result:** **Too early for piano ship call.** Clean so far (no non-play piano). Need Hobbs lunch / challenge / vote window + soak gate evidence.

---

### 4. Social — instrument hold only (S1 not this tip)

| ID | Pass A | This tip | Notes |
|----|--------|----------|-------|
| Chat CD honest | **461** · gap0 **0** | _ | record; do not ship S1 here |
| effective_cd=3 | **17** | _ | carry: mechanism still open (§9.3 prior) |
| Cafe still lively | yes | _ | must not mute |

**Carry from Pass A §9.3 (unverified):**
- [ ] ≥5 eff_cd=3 rows inspected (pair, gap, arena, n_exchanges)
- [ ] One-line S1 problem statement from **this** tip’s honest count (or keep **461** if unchanged)

**Result:** _

---

### 5. Display honesty + Talk Path A

- [ ] Soft morning probe: `api_fail_candidates=[]` *(carry: open)*
- [ ] Talk Path A — **HOLD** (out of scope)

**Result:** _

---

### 6. Analyzers + census (after ≥ vote hour 20:00)

```bash
# local / after export
python tests/analyze_action-location.py 20260802-1 --source supabase
python tests/analyze_sim_realism.py 20260802-1 --source supabase
python tests/analyze_sim_survival.py 20260802-1 --source supabase
```

```bash
# VPS soak census
SIM=20260802-1
LOG=/var/log/soak/${SIM}.log
G="grep -a"
for pat in \
  "POST-VALIDATE affordance fallthrough" \
  "LOCATION STICKY SKIP" \
  "ACTION CONTRACT REJECTED" \
  "affordance_required" \
  "PHASE 8 REDISTRIBUTE" \
  "PHASE 8 STAFF EVICT" \
  "LOCATION STICKY:.*:piano" \
  ":piano"
 do echo -n "$pat: "; $G -cE "$pat" "$LOG" || echo 0; done
echo "P8→piano: $($G -cE 'PHASE 8 (REDISTRIBUTE|STAFF EVICT):.*→.*:piano' "$LOG")"
```

- [ ] AL / realism / survival exported
- [ ] Vote gather @ hour 20 — expect ~15/15 Hobbs *(carry: unproven on Pass A)*
- [ ] Soft: Gap-2 / APT-N / OSC recorded only *(carry: 10 / 68 / low)*
- [ ] Piano census filled (persona-steps + intro attribution if residual)

**Result:** _

---

### 7. Decision gate

| Question | Answer | Next |
|----------|--------|------|
| Piano clear enough with gates live? | _ | If YES → L1 optional; if NO → census owner then dedicated tip |
| Post-flag census says GUARD primary? | _ | Only then size **L1** |
| Honest CD still talk-loop ugly? | _ | **S1** later tip (baseline ≥ Pass A **461**) |
| Held bars (place-claim / dorm / teleport / Class P)? | _ | Must hold |

- [ ] Do **not** green-light L1 from Pass A pre-flag census
- [ ] Do **not** mix S1 on this tip
- [ ] Do **not** special-case Phase 8 unless post-flag census proves need

**Result:** _

---

### 8. Stop + SOT

```bash
curl -k -X POST https://localhost:8001/api/simulations/20260802-1/stop \
  -H "Content-Type: application/json" \
  -d '{"action":"stop","parameters":{"force":false}}' | python3 -m json.tool
```

- [ ] Sim stopped; process gone; final_step recorded
- [ ] No normative SOT until Place+Social green
- [ ] One-line tip + verdict

**Result:** _

---

### Verdict

| Gate | Result | Notes |
|------|--------|-------|
| **0 preflight** | PASS | tip `1c830aec` + flag assert done |
| **1 early smoke** | PASS soft @~50 | bath/stretch→Park 0; soak greps open |
| **2 held regressions** | early OK @~50 | re-score ≥20:00 |
| **3 piano (flags live)** | too early | V2/emit 0 @~50; not ship |
| **4 social instrument** | _ | S1 not ship |
| **5 display / Talk A** | _ / HOLD | |
| **6 analyzers + census** | _ | vote carry |
| **7 decision gate** | _ | L1 / S1 |
| **8 stop** | _ | |
| **This tip ship?** | _ | |
| **Public MVP?** | NO until Place+Social clear | |

---

### Next after this paper

| If… | Then… |
|-----|--------|
| Piano clean | MVP place closer; optional L1 strategic only |
| Residual + census → GUARD | Plan **L1** separate tip |
| Residual + census → Phase 8 / other | Dedicated fix; not piano-only band-aid |
| CD still ugly | **S1** off honest count |
| Generator regen risk | Separate ticket |
| Talk Path A | Still HOLD / separate |
