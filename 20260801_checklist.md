# 20260801 — Checklist: Pass A place + social (L0 / piano parity / S0)

**Purpose:** Score-prove Pass A closes the **proven residual roots** from the deep RCA (+ second-opinion amendments) — without pre-committing L1 GUARD demotion or S1 willingness rewrite.

**Root (unit-green on branch):** `ivan/pass-a-place-social`  
**Prior fail sim:** `20260731-1` · tip `e69a879e` · UUID `e2537b0b-04cb-4041-be38-2929044af5d4` · ~step 2294 / vote hour — piano V2 **64** / emit **212**; chat CD **946** (inflated); stretch→Park residual; Class P + dorm-@ held  
**Baseline artifacts (recompute):** `generative_agents/environment/frontend_server/storage/20260731-1/analysis/` (`summary.json`, `sprite_steps.json`)

**Archived context (moved under `done/` — do not re-open as live plans):**
- `done/20260731_RCA.md` — charter / Desired outcomes (Tracks L+S); this Pass A is the narrow first slice only  
- `done/20260801_deep_RCA.md` — full mechanism + §10 advisor pack; second opinion: piano “GUARD intro” unproven without census; **946 mostly measurement** → S0 is the instrument  
- `done/20260730-1_MVP_RCA.md` — prior surgical roots (sticky/CD-floor/travel-defer); partially right, incomplete  
- `done/20260731-1_checklist.md` — failed residual score paper @ `e69a879e`  
- `done/20260801_deepseek_v4-new.md` — optional Tier B 0731 pilot (separate tip only; sketch in §Next below)

**Shipped to score (this tip):**
- **L0 PLACE-CLAIM:** GUARD defers in-place bathroom / bed / home / kitchen claims (closes “Stretching in the bathroom” → Park; prior residual was **Owen-only** stretch loop)
- **PIANO PARITY:** Affordance check on GUARD **anchor-first** object seal; post-validate **fallthrough → arena** when remap fails (do not keep `:piano`)
- **S0 END-CD:** `end_conversation` floors CD ≥5 **after** cafe mod (stops 5−2→3)
- **S0 GREETING ID:** Stable shared `conversation_id` on greetings
- **S0 ANALYZER:** Missing conv-id → pair/step merge + adjacent fragment merge (honest CD counter)

**Already proven (do not re-litigate):**
- Class P named-travel wrong sector ≈0 (`20260730-1` / `20260731-1`) — **wrong leaf at Hobbs ≠ Class P**
- Class D prefer-emit / emit_honesty morning probe
- Travel-like GUARD defer (`walking to bathroom` → Park = 0 on prior tip)
- Dorm-@ presence gate = 0 on `20260731-1`
- Vote gather 15/15 @ hour 20 on `20260731-1` (do not score gather before hour 20 — prior FP)
- Teleports / wait-wrap / Gap-1 staff kitchen held on residual tip

**Out of scope this paper (decision gate after score):**
- **L1** wholesale GUARD nearest-arena demotion → curated Tier B (needs piano **source census** if residual remains)
- **S1** willingness-first full chat + generalized seek (size after honest CD baseline — do **not** use pre-S0 ≪946)
- Tier B Flash-0731 model pilot (separate tip)
- Talk Path A creator learning
- Muting cafe globally · mass maze retile · mixing L1 + model slug + S1 on one tip · deleting world-law gates

**Carry-forward HOLD:**
- Talk Path A — live `auto_applied: true` / life-chapter bump
- Piano **source census** if V2/emit still dirty after this tip (hard gate before L1)
- Soft watch only (not ship-blockers): APT-N paint (was V4 **96**, often honest transit); STAFF-CTR Gap-2 (was **1**); OSC idle bands

**Process lesson (charter):** Unit-green ≠ ship. Close out only after Survival soak through vote hour.

**BE tip to deploy:** `origin/railway` @ **`be158e24`** (Pass A — merged from `ivan/pass-a-place-social`)  
**Posture:** Survival sprint; stop prior score sim `20260731-1` before restarting `double-api` if needed. Do **not** restart API while this score sim is live.

**Score sim:** `20260801-1`  
**Baseline / fork from:** `soul15_seed_20260224`  
**Target steps:** `≥2600` (clear Survival Day 1 **vote deadline 20:00** ≈ step **~2250** on 06:30 start)  
**Start:** `2026-08-02 06:30` · runner PID `2378819` · UUID `e09ffe02-64c3-42ff-9d92-fa742424ae96`  
**Env:** `HEADLESS_MOVEMENT_ENABLED=true` · `HEADLESS_STRICT_ABORT=true` · `INTENT_PERSIST_HARD_FAIL=true` · `PLACE_LANGUAGE_API_PREFER_EMIT=true`  
**Watch:** Survival armed by step ~30 (`is_survival=true`, Premiere). Vote-gather remains in-scope for §6.

**Unit proof already green (local):**
- `tests/test_travel_anchor_destination_authority.py::TestGuardTravelDefer`
- `tests/test_affordance_required.py` (anchor-first + fallthrough)
- `reverie/backend_server/tests/test_cooldown_unification.py` (end-path floor)

> **Ship rule:**  
> - **Pass A green** = §2–§4 below (Class P regression + piano ↓ + place-claim Park = 0 + honest CD ↓ + cafe still lively).  
> - **Decision gate:** if piano residual remains → census before L1; if honest CD still ugly → size S1.  
> - Public MVP playback = Place + Social green (+ held bars). Pass A alone does not claim public MVP if residuals remain.  
> - Normative SOT only after green A/B (optional Current vs Desired soften only).

**Probe:** `python scripts/score_sim_probe.py 20260801-1 --morning-day1`

---

### 0. Preflight

- [x] Merge / push `ivan/pass-a-place-social` → `railway` @ **`be158e24`** *(local→origin done 2026-08-01)*
- [x] VPS `git pull` → tip **`be158e24`**; `systemctl restart double-api`
- [~] Prior score sim `20260731-1` — runner **gone** after API restart (`backend_process_active=false`); DB status still showed `running` / `is_generating` (stale) @ launch
- [x] Fork + start `20260801-1`; UUID / PID recorded
- [x] Survival season armed (`is_survival=true`) — confirmed by step ~30 · label **Premiere** · engine_day 1

**Recorded:** UUID `e09ffe02-64c3-42ff-9d92-fa742424ae96` · PID `2378819` · tip `be158e24` · fork `2026-08-02T00:15:58Z` · `curr_time` start `2026-08-02 06:30` · 15 personas · sprint + diagnostic · maze `605c06ea-…`

---

### 1. Early smoke (~steps 50–100)

- [x] Tip correct; API active; runner alive — tip `be158e24`; PID `2378819` continuous; step **30** @ `07:01` · `is_generating=true` · `last_generated_at` fresh *(checkpoint ~30; target band was 50–100)*
- [ ] No `HEADLESS_STRICT_ABORT` / traceback flood *(not re-grepped this checkpoint)*
- [ ] Soft: soak shows `GUARD PLACE-CLAIM-DEFER` and/or `GUARD TRAVEL-DEFER` *(soak not scanned)*
- [ ] Soft: no early stretch-bathroom → Park *(too early / no analyzer yet)*

**Result:** PASS soft on health — runner + Survival OK at step 30. Soft GUARD/Park checks still open until soak/analyzer.

---

### 2. Class P regression — **must stay green**

**Pass bar (same as `20260731-1` §2):**
1. Named-travel wrong sector ≈ **0** for Willows / Oak Hill / Rose & Crown / Hobbs / Harvey.
2. Vince Day 1 morning Hobbs commute green.
3. Soft: real park visits still seal Park.
4. Soft: presence-on-Park while heading to named venue = transit paint, not dest overwrite.

**Checks:**
- [ ] Named travel→Park (Market/Oak/Pub/Hobbs) ≈ **0**
- [ ] Soft: prefer-emit / authority still healthy on morning sample

**Result:** _

---

### 3. Pass A primary gates — **this paper’s ship**

Baseline to beat (`20260731-1` @ ~2294):

| ID | Baseline | This run @ vote hour | Pass? |
|----|----------|----------------------|-------|
| **PIANO V2** | **64** | _ | Target ≪64; ideal near 0 non-play |
| **PIANO emit** (sprite non-play `:piano`) | **212** (all Hobbs) | _ | Target ≪212 |
| **PLACE-CLAIM** stretch-bath→Park | **6** sprite (Owen) / checklist 17 auth | _ | **0** |
| **CHAT-CD (honest)** | **946** (inflated; gap=0 was 335) | _ | Material ↓; report gap=0 share |
| **effective_cd=3** | **229** | _ | ≈ **0** (end floor shipped) |
| **DORM-@** | **0** | _ | Stay **0** |
| **TELEPORT** | none in realism summary | _ | Stay clean |

**Checks:**
- [ ] PIANO — V2 and emit both ↓; spot no multi-step walk/order/eat on `:piano`
- [ ] If piano residual > small: **run source census** (GUARD / anchor-first / sticky / contract / LLM) before any L1 plan
- [ ] PLACE-CLAIM — stretch/in-bathroom → Park = **0**; travel-to-bath stays 0
- [ ] CHAT-CD — count with new analyzer; gap=0 cluster collapsed; cafe still has real chats (not muted)
- [ ] Spot: end-path stamps ≥5 after cafe mod (`COOLDOWN SET` / no systematic CD=3)
- [ ] Do not treat Irene↔Max as the volume story (was only 18/946); watch cafe pairs broadly

**Soft watch:**
- [ ] STAFF-CTR Gap-2 (prior **1**) / APT-N V4 (prior **96**) / OSC — record only; not ship-blockers

**Result:** _

---

### 4. Display honesty regression (soft)

- [ ] Morning probe optional: `api_fail_candidates=[]`
- [ ] Soft: prefer-emit travel-safe on Hobbs morning sample

**Result:** _

---

### 5. Talk Path A — **HOLD** (out of scope)

- [ ] Not required for Pass A ship call

**Result:** HOLD

---

### 6. Standard analyzer suite (after tip ≥ vote hour 20:00)

```bash
python tests/analyze_action-location.py 20260801-1 --source supabase
python tests/analyze_sim_realism.py 20260801-1 --source supabase
python tests/analyze_sim_survival.py 20260801-1 --source supabase
```

Optional emit piano probe (local artifacts after analysis export):
- Non-play `:piano` in `sprite_steps` / movement planned leaf

- [ ] Action-location: V2 piano recorded; addr≠@ = 0
- [ ] Realism: CD violations + gap=0 share recorded; no TELEPORT reopen
- [ ] Survival: vote gather hour 20 — expect ~15/15 Hobbs (not incomplete-window FP)

**Result:** _

---

### 7. Decision gate (after §3–§6)

| Question | Answer | Next |
|----------|--------|------|
| Piano cleared enough for MVP taste? | _ | If NO → **census** then consider L1; if YES → L1 optional/strategic only |
| Honest CD baseline still “talk-loop” ugly? | _ | If YES → size **S1**; if NO → S1 can wait |
| Class P / dorm-@ / teleports held? | _ | Must YES |

- [ ] Do **not** green-light L1 without census if piano residual remains
- [ ] Do **not** use pre-S0 “≪946” as S1 prove bar — use **this** tip’s honest count
- [ ] Do **not** mix L1 + 0731 model + S1 on one unreadable tip

**Result:** _

---

### 8. Stop hygiene + SOT

- [ ] Sim stopped / completed when scoring done
- [ ] If §3 green: optional soften SOT Current vs Desired only; **normative SOT after L1/S1 green** (charter rule)
- [ ] One-line tip + verdict → Pass A ship? Gate outcome?

**Result:** _

---

### Verdict

| Gate | Result | Notes |
|------|--------|-------|
| **0 preflight** | _ | tip / UUID / PID |
| **1 early smoke** | _ | |
| **2 Class P regression** | _ | must HOLD |
| **3 Pass A (piano / place-claim / S0 CD)** | _ | primary |
| **4 display soft** | _ | |
| **5 Talk Path A** | HOLD | |
| **6 analyzers ≥20:00** | _ | |
| **7 decision gate** | _ | L1 / S1 sized here |
| **8 stop + SOT** | _ | |
| **Pass A ship?** | _ | |
| **Public MVP?** | NO until Place+Social gate clear | |

---

### Next after this paper

| If… | Then… |
|-----|--------|
| Piano residual + census shows GUARD ownership | Plan **L1** (flagged demote + curated Tier B) on separate tip |
| Piano residual = anchor/other leak | Fix leak; do **not** sell L1 as piano fix |
| Honest CD still spammy | Plan **S1** willingness + seek |
| Both clean | MVP playback closer; Talk Path A still separate |
| Cost/parse concern for L1 | Optional **0731** pilot on its own tip first |

**0731 pilot sketch** (from archived brief — separate tip only):
- `LLM_MODEL_TIER_B=deepseek/deepseek-v4-flash-0731`; keep Tier A on current Flash; reasoning **off**; halved complex `max_tokens`
- Do **not** set `TIER_C_ENABLED=true` for this experiment (Chat Tier C is gateway-only)
- Pass draft: no retry/empty storms; location parse ≥ prior smoke; Tier B tokens/step ↓ ≥30%; spot-check plan/chat OK
- Rollback: revert Tier B slug + budgets; restart `double-api` between sims
