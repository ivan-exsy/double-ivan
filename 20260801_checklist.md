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
- [~] Named travel→Park (Market/Oak/Pub/Hobbs) ≈ **0** — sprite skim @ ~1928: **9** rows (Hobbs/Pub/Oak Hill act + Johnson Park address). Looks like soft transit paint (§2.4), not mass Class P reopen; **not clean 0** vs prior tip
- [ ] Soft: prefer-emit / authority still healthy on morning sample *(not re-run)*

**Result:** SOFT HOLD — no mass reopen; 9 presence-style rows to watch. Re-check at ≥2600 if needed.

---

### 3. Pass A primary gates — **this paper’s ship**

Baseline to beat (`20260731-1` @ ~2294) · **this export ~step 1928** (past Day-1 20:00 window; sim still running toward 2600):

| ID | Baseline | This run @ ~1928 | Pass? |
|----|----------|------------------|-------|
| **PIANO V2** | **64** | **60** (Owen 42 / Alexis 8 / Vince 6 / Vincent 4) | **NO** — slight ↓ only; still walk/order/eat on `:piano` |
| **PIANO emit** (sprite non-play `:piano`) | **212** (all Hobbs) | **96** (Owen 60 / Vincent 16 / Vince 12 / Alexis 6) | **observation only** — drop **unattributable** to Pass A parity (gates never live; see §9.2a) |
| **PLACE-CLAIM** stretch-bath→Park | **6** sprite (Owen) / checklist 17 auth | **0** (stretch/bath@Park=0; travel-bath@Park=0) | **YES** |
| **CHAT-CD (honest)** | **946** (inflated; gap=0 was 335) | **461** · gap=0 **0** · gap≤1 **10** · cafe **285**/455 | **YES** material ↓ + instrument fixed |
| **effective_cd=3** | **229** | **17** | **partial** ≪229; not ≈0 |
| **DORM-@** / addr≠@ | **0** | **0** | **YES** |
| **TELEPORT** | none in realism summary | none (issues = CD 461 + OSC 1) | **YES** |

**Checks:**
- [x] PIANO — V2 **60** / emit **96** — emit ↓, V2 not materially better; multi-step walk/order/eat on `:piano` still present (Owen-heavy)
- [x] If piano residual > small: **run source census** before any L1 — **REQUIRED** (residual remains)
- [x] PLACE-CLAIM — stretch/in-bathroom → Park = **0**; travel-to-bath stays **0**
- [x] CHAT-CD — honest **461**; gap=0 collapsed; cafe still lively (not muted)
- [~] Spot: end-path stamps ≥5 after cafe mod — eff_cd=3 residual **17** (floor mostly working, not perfect)
- [x] Do not treat Irene↔Max as the volume story — top pairs Irene↔Olivia **49**, Mike↔Owen **23**, cafe-broad

**Soft watch:**
- [x] STAFF-CTR Gap-2 **10** (was 1) / APT-N V4 **68** (was 96) / OSC **1** in realism (+ more in survival-export mix) — record only

**Result:** **MIXED — place-claim + S0 instrument PASS; piano FAIL; CD volume ↓ but still talk-loop ugly; eff3 partial.** Pass A ship = **NO**.

---

### 4. Display honesty regression (soft)

- [ ] Morning probe optional: `api_fail_candidates=[]` *(not run this pass)*
- [ ] Soft: prefer-emit travel-safe on Hobbs morning sample *(not run)*

**Result:** OPEN (non-blocking)

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

- [x] Action-location: V2 piano **60**; addr≠@ = **0**; APT-N **68**; Gap-2 **10**
- [x] Realism: CD **461**; gap=0 **0**; no TELEPORT
- [~] Survival: challenge gather Day1 **15/15** (100%); **vote** `voting_pct: null` — Hobbs presence skim around steps 780–870 ≈ **8–12**/15 (not 15/15). Do not claim vote-gather green yet; re-skim when vote closes / ≥2600

**Result:** Analyzers run @ ~1928. Place/CD instrument readable. Vote-gather **not** proven 15/15.

---

### 7. Decision gate (after §3–§6)

| Question | Answer | Next |
|----------|--------|------|
| Piano cleared enough for MVP taste? | **NO** (V2 60) | **Next:** plumb `affordance_required` + re-soak; **then** re-census before L1 |
| Honest CD baseline still “talk-loop” ugly? | **YES** (461; cafe 62%) | Size **S1** against **461**, not pre-S0 946 — **later tip** |
| Class P / dorm-@ / teleports held? | dorm-@ / teleport **YES**; Class P **soft** (9 park rows) | Hold Class P as watch |

- [x] Do **not** green-light L1 on pre-flag census (gates were off)
- [x] Do **not** use pre-S0 “≪946” as S1 prove bar — use **this** tip’s honest count (**461**)
- [x] Do **not** mix loader plumb + S1 + L1 on one unreadable tip
- [x] Do **not** ship Phase-8-only piano special-case as the next tip (second opinion)

**Result:** Pass A **does not ship**. Next tip = **maze loader `affordance_required` plumb** (+ real-Maze tests) → re-score piano → re-census. S1 later off 461. L1 still gated.

---

### 8. Stop hygiene + SOT

- [x] Sim stopped / completed when scoring done — graceful stop @ step **2147** (`status=stopped`, process gone); see §9.0
- [ ] If §3 green: optional soften SOT Current vs Desired only; **normative SOT after L1/S1 green** (charter rule) — N/A (§3 not green)
- [x] One-line tip + verdict → Pass A ship? **NO** @ `be158e24` / `20260801-1` ~1928: L0 place-claim + S0 instrument worked; piano residual blocks ship; honest CD still needs S1

**Result:** Partial score locked; optional re-confirm piano/CD/vote at final stop step without changing gate call unless numbers swing hard.

---

### Verdict

| Gate | Result | Notes |
|------|--------|-------|
| **0 preflight** | PASS | tip `be158e24` / UUID `e09ffe02-…` / PID `2378819` |
| **1 early smoke** | PASS soft | health OK; soak GUARD lines still unchecked |
| **2 Class P regression** | SOFT HOLD | 9 named-travel@Park (transit-paint shape); dorm-@ 0 |
| **3 Pass A (piano / place-claim / S0 CD)** | **FAIL ship** | place-claim 0; CD 461/gap0 0; piano V2 60 / emit 96 |
| **4 display soft** | OPEN | not probed |
| **5 Talk Path A** | HOLD | |
| **6 analyzers ≥20:00** | PARTIAL | AL+realism done; vote gather not 15/15 yet |
| **7 decision gate** | SET | census → then L1?; S1 off 461 |
| **8 stop + SOT** | STOPPED | step 2147; no SOT |
| **9 RCA evidence** | **AMENDED #2–#4** | Enabling defect = loader drop; Phase 8 introducer unproven-primary; next tip = plumb |
| **Pass A ship?** | **NO** | |
| **Public MVP?** | NO until Place+Social gate clear | |

---

### 9. RCA evidence pack (Pass A residual → next tip)

**Goal:** Attribute remaining piano + CD failures so L1/S1 are sized from **mechanism**, not vibes. Do **not** write L1/S1 code until §9.2 piano source bucket is filled.

**Sim handle:** `20260801-1` · tip `be158e24` · UUID `e09ffe02-64c3-42ff-9d92-fa742424ae96`  
**Local artifacts (already):** `generative_agents/environment/frontend_server/storage/20260801-1/analysis/`  
**VPS soak:** `/var/log/soak/20260801-1.log` · storage `/var/www/generative_agents/environment/frontend_server/storage/20260801-1/`

#### 9.0 Clean stop (VPS)

Graceful first (SIGTERM, up to ~10s, then API may escalate):

```bash
# status before
curl -k https://localhost:8001/api/simulations/20260801-1/status/current | python3 -m json.tool

# graceful stop — body MUST include action (parameters-only body 422s)
curl -k -X POST https://localhost:8001/api/simulations/20260801-1/stop \
  -H "Content-Type: application/json" \
  -d '{"action":"stop","parameters":{"force":false}}' | python3 -m json.tool

# confirm stopped (backend_process_active should be false)
curl -k https://localhost:8001/api/simulations/20260801-1/status/current | python3 -m json.tool
```

If process still alive after ~15s:

```bash
curl -k -X POST https://localhost:8001/api/simulations/20260801-1/stop \
  -H "Content-Type: application/json" \
  -d '{"action":"stop","parameters":{"force":true}}' | python3 -m json.tool
```

*(Empty body also works for graceful stop; `parameters` alone fails validation because `action` is required.)*

**Do not** `systemctl restart double-api` just to kill the sim — use `/stop`. Restart only between tips after stop is confirmed.

**Record after stop:** `final_step=2147` · `total_steps=2148` · `status=stopped` · `backend_process_active=false` · `curr_time=2026-08-03T18:18:00+00:00` · `engine_day=2` · stopped ~`2026-08-03T00:54Z` (graceful; force=false)

#### 9.1 Locked score snapshot (local — already @ ~1928)

Refresh once after stop if final_step ≫ 1928 (same three analyzers as §6); otherwise keep these numbers.

| Signal | Baseline `20260731-1` | This tip @ ~1928 | RCA question |
|--------|----------------------|------------------|--------------|
| Piano V2 | 64 | **60** | Why Pass A parity missed multi-step eat/order/walk seals? |
| Piano emit non-play | 212 | **96** | Same root as V2 or emit-only path? |
| Place-claim bath→Park | 6 | **0** | Closed — keep as regression bar only |
| Chat CD honest | 946 (gap0=335) | **461** (gap0=**0**) | S0 instrument OK; residual = real talk-loop |
| effective_cd=3 | 229 | **17** | End-floor leak or analyzer edge? |
| Dorm-@ / TELEPORT | 0 / clean | 0 / clean | Held |
| Gap-2 staff | 1 | **10** | Soft — Vincent behind counter cluster? |
| APT-N V4 | 96 | **68** | Soft transit paint |
| Vote gather | 15/15 | challenge 15/15; vote **null** / Hobbs skim ≤12 | Final post-stop skim |

**Piano emit streaks already extracted (sprite):**

| Persona | Steps | Len | Dominant act |
|---------|-------|-----|--------------|
| Owen Logan | 366–385 | 20 | eating lunch at cafe seating |
| Owen Logan | 1692–1709 | 18 | highlighting key points |
| Vincent Slater | 1781–1794 | 14 | Unpack and start eating lunch |
| Owen Logan | 1713–1720 | 8 | Receiving challenge instructions |
| Vince Vale | 367–373 | 7 | eating lunch at a table |
| Alexis Reed | 1768–1773 | 6 | ordering lunch at the counter |

Act-family mix on 96 emit hits: eat **40** / other **36** / walk **12** / order **8**. Owen owns **60**/96.

**CD shape (honest):** gaps peak 14/15/6 (not 0); eff_cd peak **28** (cafe mod −2 on long chats); cafe **285**/455; top pair Irene↔Olivia **49**.

#### 9.2 Piano source census (VPS soak — **blocking for L1**)

Attribute each bad `:piano` seal to a **path bucket**. Paste counts into the table after running on VPS.

```bash
SIM=20260801-1
LOG=/var/log/soak/${SIM}.log
G="grep -a"

echo "=== sizes ==="
ls -lh "$LOG"
du -sh /var/www/generative_agents/environment/frontend_server/storage/${SIM} 2>/dev/null

echo "=== diagnostic on? ==="
$G -m3 "LOG MODE ENABLED" "$LOG" || echo "(no LOG MODE line)"

echo "=== path counters ==="
for pat in \
  "GUARD anchor-first" \
  "POST-VALIDATE affordance fallthrough" \
  "POST-VALIDATE keep named dest" \
  "affordance_required" \
  "DETERMINISTIC GUARD" \
  "📍 GUARD:" \
  "PLACE-CLAIM-DEFER" \
  "TRAVEL-DEFER" \
  "STICKY" \
  ":piano"
 do
  echo -n "$pat: "
  $G -c "$pat" "$LOG" || echo 0
done

echo "=== piano lines (sample) ==="
$G -n ":piano" "$LOG" | head -80

echo "=== Owen piano / Hobbs window samples (morning + challenge) ==="
$G -n "Owen Logan" "$LOG" | $G -i "piano\|GUARD\|POST-VALIDATE\|LOCATION" | head -60

echo "=== correlate streak starts (edit steps if final export differs) ==="
for s in 366 1692 1781 1713 367 1768 338; do
  echo "---- near step $s ----"
  $G -n "step[= ]*$s\|Starting step $s\|STEP $s" "$LOG" | head -5
  $G -n ":piano" "$LOG" | $G -E ":?$s[^0-9]|step=$s|step $s" | head -10
done
```

| Bucket | How to recognize in soak | Count | Notes |
|--------|--------------------------|-------|-------|
| A. GUARD activity-type nearest arena → piano leaf | `📍 GUARD:` … → `…:piano` | **ungated** | gate dead — see §9.2a |
| B. GUARD **anchor-first** sealed piano | `GUARD anchor-first` + piano | **439 fires, check dead** | same |
| C. Post-validate fallthrough | `POST-VALIDATE affordance fallthrough` | **0** | **incapable of running** (flag always false) — not “path missed Phase 8” |
| D. Sticky / prior leaf retained | `LOCATION STICKY` … `:piano` | **4** sticky-piano; sticky skip **already coded, starved** | not new work |
| E. LLM/contract | PLAN RESULT play-piano | rare in sample | contract reject also starved |
| G. Phase 8 → piano | `PHASE 8 … → :piano` | **17** (loud logger) | **confirmed introducer in early sample; not proven primary** — R6 inside Phase 8 pick also dead |

**Soak counters (2026-08-03 post-stop):** soak 395M · storage 1023M · `LOG MODE ENABLED` · anchor-first **439** (= all `GUARD anchor-first` logs, **not** 439 piano seals) · post-validate fallthrough **0** · keep-named-dest 12 · affordance_required **0** · DETERMINISTIC GUARD 613 · `📍 GUARD:` 206 · PLACE-CLAIM-DEFER 21 · TRAVEL-DEFER 22 · STICKY 63 · `:piano` 720 · P8→piano **17** · sticky-piano **4**

**Methodology limits (opinions #2–#4):** piano sample was `head -80` / early morning (~11% of 720 lines); late streaks not correlated to P8. Emit 212→96 is **real but unowned** — not Pass A credit or debit. 17 intros vs 720 log lines are different units (one intro can streak). Re-census **after** flag plumbing before L1; prefer **unique persona-steps** (normalize by eligible Hobbs acts), not raw `:piano` line counts.

**Pass A expected vs observed:** parity / sticky skip / contract reject all depend on `get_object_affordance_required` → always **False** in scored run.

- [x] §9.2 soak filled (Phase 8 loud; fallthrough 0)
- [ ] Streak-start ↔ P8 correlate — only worth running **after** post-flag census if P8→piano persists
- [x] Decision **amended by opinions #2–#4** → see §9.2a / §9.6

#### 9.2a Opinions #2–#4 (2026-08-02) — **verified enabling defect: maze loader**

**Consensus:** Agree with opinion **B/#2**. Phase 8 is a **confirmed introducer** (early sample), **not proven primary**. Residual path ownership awaits **post-flag** census.

**Defect (verified @ tip `be158e24` / tree):**  
Registry marks exactly **2**/222 objects `"affordance_required": true` (Hobbs `:piano`, Pub `:microphone`), but `_load_registry()` copies only `label / type / interaction / affordances / duration_range / staff_only` — **omits `affordance_required`**. Getter always `False`. Arena getters fully plumbed (9/9); object level drops **only** this field today.

**Gates starved:** R6 pick filter · GUARD anchor-first parity · post-validate fallthrough · sticky skip · contract reject. Phase 8 already calls pick + post-validate — **no Phase-8-specific bypass**; A's "clear sticky" tip is already coded and starved.

**Test blind spot (understated by #2; sharpened by #4):** affordance tests stub the key by hand; `test_maze_registry*.py` **hand-mirror** the loader instead of calling real `Maze._load_registry` — real omission is invisible to the suite.

**Systemic cousin (#4 — separate ticket, not this tip):** `scripts/generate_maze_registry.py` only emits `type` + `interaction` per object. Regenerating from CSVs would wipe enriched fields (affordances / duration / staff_only / affordance_required). File as follow-up; do **not** block this tip.

**Next tip (narrow):**
1. Plumb `affordance_required` into `object_meta` in `_load_registry()` (one field).
2. Failing-first tests: **real** registry through **real** `_load_registry` — piano/mic `True`, control object `False`; mismatched walk/order leaves piano; matching play remains allowed.
3. Parameterized loader↔JSON contract for every getter-exposed object/arena field (drift class).
4. **Change nothing** in Phase 8 / GUARD / sticky / contract / generator on this tip — revalidate once data arrives.
5. Before soak: assert deployed VPS tip loads both flags.
6. Re-soak through vote hour; re-score piano vs **60 / 96**; re-census with persona-steps. Gate-fired evidence (sticky skip / contract reject / fallthrough / R6) **or** piano residual ≈0 — do **not** hard-require fallthrough volume (upstream R6 may keep it at 0). Then decide L1.
7. Hold **S1** (size off **461**; “real talk-loop” wording still premature until §9.3 filled). Vote-gather separate. Spot-check mic + ~5 oddly phrased piano/mic acts for over-rejection after plumb.

**Implementation (2026-08-02):** coded on `ivan/affordance-required-loader-plumb` — loader plumb + `tests/test_maze_registry_loader_contract.py` (real `_load_registry`, getter↔JSON contract, post-validate with loaded meta). Awaiting merge → VPS deploy → score soak.

#### 9.3 Social residual (honest CD → S1 sizing)

Local already proves gap=0 inflation is gone. Remaining RCA is **why pairs re-open inside deep CD**.

```bash
# VPS soak — cooldown / chat manager
LOG=/var/log/soak/20260801-1.log
G="grep -a"
echo "COOLDOWN SET: $($G -c 'COOLDOWN SET' "$LOG" || echo 0)"
echo "effective / cafe mod samples:"
$G "COOLDOWN SET" "$LOG" | head -40
echo "CM skip reasons:"
$G -E "CONV MANAGER:.*skip" "$LOG" | sed -E 's/.*skip \(([^)]+)\).*/\1/' | sort | uniq -c | sort -rn | head -20
echo "should_chat True count: $($G -cE 'should_chat=True|CM\\.SHOULD' "$LOG" || echo 0)"
echo "GREETING: $($G -c 'GREETING TRIGGERED' "$LOG" || echo 0)"
```

Local follow-ups (after stop, optional re-export):

```bash
python tests/analyze_sim_realism.py 20260801-1 --source supabase
# then parse CD issues: gap hist, eff_cd=3 detail rows, top pairs
```

| Question | Answer (fill) |
|----------|----------------|
| Are eff_cd=3 rows real end-path under-floor, or analyzer mis-read? | _ (17 rows @ ~1928) |
| Do violators share arena (cafe) + short gap with long prior chats? | _ (cafe 62% suggests yes) |
| Is runtime blocking in-cooldown starts, so CD issues = analyzer vs stamp mismatch? | _ |
| S1 lever: willingness gate vs seek vs CD stamp? | _ |

- [ ] eff_cd=3 sample of ≥5 rows inspected (pair, gap, arena, n_exchanges)
- [ ] S1 problem statement written in one sentence from **461**, not 946

#### 9.4 Held / soft bars (quick post-stop)

```bash
# local after re-export
python tests/analyze_action-location.py 20260801-1 --source supabase
python tests/analyze_sim_survival.py 20260801-1 --source supabase
```

- [ ] Place-claim bath→Park still **0** at final_step
- [ ] addr≠@ / dorm-@ still **0**
- [ ] Class P named-travel@Park count at final (_ vs 9)
- [ ] Survival `voting_pct` / Hobbs gather @ hour 20 final read
- [ ] Soft: Gap-2 / APT-N recorded only

#### 9.5 Diagnostic storage (if present)

```bash
SIM=20260801-1
S=/var/www/generative_agents/environment/frontend_server/storage/${SIM}
ls -la "$S/logs" 2>/dev/null | head
ls -la "$S" | head -40
# if diagnostic_mode wrote pipeline:
find "$S" -name 'movement-pipeline.ndjson' -o -name '*llm*' 2>/dev/null | head
```

Copy off-box only what census needs (soak excerpts + analysis JSON). After scoring, optional cleanup per deploy skill (`movement`/`environment` dirs) — **keep** `/var/log/soak/20260801-1.log` until §9.2 done.

#### 9.6 RCA verdict → next tip

| Finding | Next tip |
|---------|----------|
| **Loader drops `affordance_required`** (#2–#4 consensus) | **Plumb flag + real-loader tests + getter↔JSON contract**; re-soak; re-census before L1 |
| Phase 8 loud in early sample | Do **not** change Phase 8 this tip — already gated; revalidate post-flag |
| Census with gate off | Cannot decide L1 until post-flag re-census |
| Generator cannot emit enriched fields | **Separate ticket** (not this tip) |
| Honest CD ~461 | **S1** later tip only (§9.3 still open) |
| Place-claim / dorm / teleport reopen | Stop — regression RCA before new work |

**One-line RCA:** Registry marks piano/mic `affordance_required`, but maze loader never copies the field into `object_meta` — Pass A / sticky / contract / Phase-8 R6 gates were starved in `20260801-1` (**verified enabling defect**; residual path mix awaits post-flag census). Phase 8 is a confirmed introducer under that defect, not proven primary.

---

### Next after this paper

| If… | Then… |
|-----|--------|
| **Loader flag dead (confirmed)** | Ship **affordance_required plumb** + real-loader + contract tests; VPS flag assert; re-soak; re-census; **then** decide L1 |
| Piano residual + post-flag census shows GUARD ownership | Plan **L1** on separate tip |
| Piano residual = Phase 8 / other with gates live | Fix that owner; do **not** special-case piano-only in Phase 8 first |
| Honest CD still spammy after §9.3 | Plan **S1** willingness + seek (off **461**) |
| Both clean | MVP playback closer; Talk Path A still separate |
| Registry regen risk | Separate generator↔enriched-fields ticket |
| Cost/parse concern for L1 | Optional **0731** pilot on its own tip first |

**0731 pilot sketch** (from archived brief — separate tip only):
- `LLM_MODEL_TIER_B=deepseek/deepseek-v4-flash-0731`; keep Tier A on current Flash; reasoning **off**; halved complex `max_tokens`
- Do **not** set `TIER_C_ENABLED=true` for this experiment (Chat Tier C is gateway-only)
- Pass draft: no retry/empty storms; location parse ≥ prior smoke; Tier B tokens/step ↓ ≥30%; spot-check plan/chat OK
- Rollback: revert Tier B slug + budgets; restart `double-api` between sims
