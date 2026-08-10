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
**Target steps:** `≥2600` planned; **founder stop @ ~1677** after Day-1 vote + Day-2 morning (enough for piano residual + vote gather)  
**Env:** `HEADLESS_MOVEMENT_ENABLED=true` · `HEADLESS_STRICT_ABORT=true` · `INTENT_PERSIST_HARD_FAIL=true` · `PLACE_LANGUAGE_API_PREFER_EMIT=true`  
**Posture:** Survival sprint + diagnostic.

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

**Early smoke @ step 42 (`2026-08-03T04:13Z` wall):** `status=running` · PID `2471155` continuous · Survival **Premiere** · `curr_time` `07:13` — **PASS soft; let run.**

**Mid-run @ ~step 698 (`2026-08-03T14:08Z` wall / sim ~18:08):** bath→Park **0** · addr≠@ **0** · piano V2 **0** · Class P soft **7** · play-piano **17** (1/17 `:piano`) · CD **171** · vote still ahead.

**Final score @ ~step 1677 (`2026-08-04T01:19Z` wall / sim Day-2 ~10:26):** founder stop — past Day-1 20:00 · AL V2 piano **0** · sprite non-play `:piano` **2** · play-piano **44** (**2**/44 `:piano`) · bath→Park **0** · addr≠@ **0** · TELEPORT **0** · Class P soft **34** · CD **307** gap0 **0** · **Hobbs@20:00 peak 8/15** · Gap-2 **1** · APT-N **287**.

**Founder judgment (2026-08-03 evening):** Class P soft, play-seal rarity, grass-stretch@Park, APT-N, Gap-2, soak greps = **non-blocking / soft** for this tip. **Vote gather 8/15 is the serious remaining issue** (Survival format, not this tip’s piano owner).

---

### 1. Early smoke (~steps 50–100)

- [x] Tip still `1c830aec`; runner healthy through **1677**
- [ ] No `HEADLESS_STRICT_ABORT` / traceback flood *(VPS soak not grepped — optional)*
- [ ] Soft: soak shows `PLACE-CLAIM-DEFER` / `TRAVEL-DEFER` *(optional)*
- [x] Soft: no bathroom→Park place-claim — **0** through 1677

**Result:** **PASS.** Optional soak health greps left open; not required for tip call.

---

### 2. Held regressions — **must stay green**

*Final @ steps 0–1676 (past Day-1 20:00):*

| Bar | Pass A | This tip @ ~1677 | Pass? |
|-----|--------|------------------|-------|
| Place-claim bath→Park | **0** | **0** | **PASS** |
| Dorm-@ / addr≠@ | **0** | addr≠@ **0** | **PASS** |
| TELEPORT | clean | **0** | **PASS** |
| Class P named-travel→Park | soft **9** | soft **34** | soft — founder non-blocking |
| Prefer-emit morning | not re-run | _ | soft *(carry)* |

**Result:** **PASS** on hard held bars. Class P soft elevated but accepted as non-blocking for this tip.

---

### 3. Primary gate — piano with flags live

Baseline = Pass A @ ~1928 (`20260801-1`):

| ID | Pass A | This tip @ ~1677 | Pass? |
|----|--------|------------------|-------|
| **PIANO V2** (AL) | **60** | **0** | **PASS** |
| **PIANO emit** (sprite leaf `:piano`, act no piano) | **96** | **2** | **PASS** |
| Play-piano still seals `:piano` | n/a | **2**/44 | soft — founder non-blocking |
| Gate-fired soak evidence | starved on Pass A | not grepped | optional (residual ≈0 accepted) |
| P8 / sticky intro attribution | n/a | skipped | residual too small to require |
| Mic over-rejection | n/a | not spotted | soft / later |

**Checks:**
- [x] Analyzers: AL V2 **0** + sprite emit **2** @ ~1677
- [ ] Soak census — optional now that residual ≈0; do **not** size L1 from Pass A pre-flag table
- [x] Spot: play-piano common; object seal rare — accepted soft for this tip

**Soft noise (non-blocking):** APT-N **287** · Gap-2 **1** · grass-stretch@Park **40** (real park stretch ≠ bath claim).

**Result:** **This tip GREEN on residual** (0/2 vs 60/96). Affordance loader plumb did the job.

---

### 4. Social — instrument hold only (S1 not this tip)

| ID | Pass A | This tip @ ~1677 | Notes |
|----|--------|------------------|-------|
| Chat CD honest | **461** · gap0 **0** | **307** · gap0 **0** | still talk-loop ugly; **S1 later** |
| effective_cd=3 | **17** | **10** | mechanism still open |
| Cafe still lively | yes | yes | held |

**Carry:**
- [ ] ≥5 eff_cd=3 rows inspected *(optional before S1)*
- [x] S1 problem statement: honest CD **307** @1677 with gap0 **0** — size S1 off this (or Pass A **461**); not this tip

**Result:** Instrument only. **S1 not shipped here.**

---

### 5. Display honesty + Talk Path A

- [ ] Soft morning probe: `api_fail_candidates=[]` *(carry)*
- [ ] Talk Path A — **HOLD**

**Result:** Open / HOLD — out of tip scope.

---

### 6. Analyzers + census (after ≥ vote hour 20:00)

- [x] AL / realism exported @ ~1677
- [x] Vote gather @ Day-1 20:00 (~step 810 on 06:30 / 60s-step) — peak Hobbs **8/15**
- [x] Soft Gap-2 / APT-N recorded
- [x] Piano census filled
- [ ] VPS soak greps *(optional / deferred)*

**Serious finding:** **Vote gather failed** — only **8/15** at Hobbs near 20:00 (not full cast). This is a **Survival appointment / gather** issue, **not** owned by the piano loader tip. Carry as **serious** product gap.

**Result:** Score complete enough to stop. Vote gather = open serious carry.

---

### 7. Decision gate

| Question | Answer | Next |
|----------|--------|------|
| Piano clear enough with gates live? | **YES** (residual) | Tip ship; soak optional |
| Post-flag census says GUARD primary? | n/a (residual tiny) | **Do not** auto-size L1 |
| Honest CD still talk-loop ugly? | **yes** (**307**) | **S1** later |
| Held bars? | **PASS** (+ Class P soft accepted) | — |
| Vote gather 15/15? | **NO (8/15)** | **Serious** — separate Survival/gather work |

- [x] Do **not** green-light L1 from Pass A pre-flag census
- [x] Do **not** mix S1 on this tip
- [x] Do **not** special-case Phase 8 unless post-flag census proves need

**Result:** **Tip ship YES.** Public MVP still blocked by gather (serious) + social CD (known).

---

### 8. Stop + SOT

```bash
curl -k -X POST https://localhost:8001/api/simulations/20260802-1/stop \
  -H "Content-Type: application/json" \
  -d '{"action":"stop","parameters":{"force":false}}' | python3 -m json.tool
```

- [x] Founder stop decision @ ~1677 (no need to grind to 2600 for piano call)
- [ ] Confirm process gone + final_step after stop command *(operator)*
- [x] No normative SOT until broader Place+Social / gather green
- [x] One-line tip + verdict: **`1c830aec` piano residual PASS; tip GREEN; MVP not yet (vote 8/15 + CD)**

**Result:** Stop in progress / operator-owned. Paper closed on tip call.

---

### Verdict

| Gate | Result | Notes |
|------|--------|-------|
| **0 preflight** | PASS | tip `1c830aec` + flags live |
| **1 early smoke** | PASS | healthy through 1677 |
| **2 held regressions** | PASS | bath/addr/teleport; Class P soft accepted |
| **3 piano (flags live)** | **PASS — tip GREEN** | V2 **0** / emit **2** vs 60/96 |
| **4 social instrument** | recorded | CD **307** · gap0 **0** · S1 later |
| **5 display / Talk A** | open / HOLD | |
| **6 analyzers + census** | done enough | **vote 8/15 serious** |
| **7 decision gate** | tip YES / MVP NO | |
| **8 stop** | founder stop @ ~1677 | confirm process gone |
| **This tip ship?** | **YES** | affordance loader plumb |
| **Public MVP?** | **NO** | see below |

---

### MVP ready?

**No — not full public MVP yet.**

| Layer | Ready? | Why |
|-------|--------|-----|
| **This tip (piano / place residual)** | **Yes** | Wrong-piano collapsed; held place bars green |
| **Place MVP broadly** | **Mostly** | Piano was the last hard place residual; Class P / play-seal accepted soft |
| **Survival gather (vote)** | **No** | Day-1 20:00 Hobbs peak **8/15** — founder marks **serious** |
| **Social MVP** | **No** | Honest CD still high (**307**); S1 still ahead |

**Call:** Ship / keep **`1c830aec`**. Treat **vote gather** as the next serious product gap (separate from piano). Keep **S1** as the social follow-up. Optional: soak greps later for forensics only.

---

### Next after this paper

| If… | Then… |
|-----|--------|
| Tip green (done) | Keep railway tip; no piano band-aid |
| Vote gather serious | Dedicated Survival/gather investigation (not L1/S1) |
| CD still ugly | **S1** later off **307** (or Pass A **461**) |
| Play-seal / Class P itch later | Optional polish tickets only |
| Soak curiosity | Optional VPS greps — not blocking |
| Talk Path A | Still HOLD / separate |
| Generator regen risk | Separate ticket |
