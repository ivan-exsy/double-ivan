# 20260821 — Checklist: Survival gather + start-jump reject

**Purpose:** Score-prove tip **`fcf5717f`** (on `059e3f0e` Survival occupancy / present-only scoring). Two product questions: (1) do people **stay put** after a bad headless blink, (2) do they **sit Hobbs** for challenge + vote once Premiere ends. **Do not** mix S1 or Talk Path A on this tip.

**Prior paper:** `20260802_checklist.md` — tip **`1c830aec`** / `20260802-1` · piano **GREEN** (V2 **0** / emit **2**) · ship **YES** for piano · **Public MVP NO**

**Failed / unverified carried from `20260802`:**
- **Vote gather 8/15** — serious (Survival appointment, not piano)
- Honest CD still talk-loop ugly (**307** @1677, gap0 **0**) — **S1 later**
- Prefer-emit morning probe — not re-run
- Talk Path A — **HOLD**
- Display honesty `api_fail_candidates=[]` — carry
- Mic over-rejection — not spotted
- ≥5 `eff_cd=3` rows inspected — optional before S1
- VPS soak greps / `HEADLESS_STRICT_ABORT` flood — optional
- Class P named-travel→Park — soft **34** accepted
- Play-piano seal rarity — soft accepted

**Shipped this tip:**
- Gather lock uses **tile occupancy**, not a Hobbs address string
- Challenge scores **only who sat**; absentees cannot win; Lock-In is **WEIGHT_UP** ×2 tonight, not a Shield vest
- Overlay after resolve: played / absent, public names, last elim (still no alliance/threat lists)
- Movement report accept only if Manhattan(`start_pos`, `actual_pos`) ≤ **6**; rejected report does **not** become next start

**Out of scope:** S1 willingness/seek · Talk Path A · normative SOT §4.7 (still live **25** until green long score) · L1 GUARD demote · video / Closer SKU

**Already proven (regression only):** piano residual · place-claim bath→Park **0** · dorm-@ **0** · CD gap0 collapsed · affordance flags live

> **Ship rule:**  
> - **Start-jump green** = analyzer TELEPORT **0** (threshold 10) **and** no persisted start→end > **6**, even when FE still emits a far 1-point path.  
> - **Survival gather green** = on a competitive day (engine day **≥2**), challenge **and** vote peak Hobbs **≥12/15** alive (80%), **or** fail-closed (no minority board). Absentee rows must not win.  
> - Premiere (engine day 1) is **grace** — no challenge, no vote. Do not score gather on Premiere.  
> - **Public MVP** still needs gather **and** S1. This tip cannot close those alone.

**BE tip:** `origin/railway` @ **`53ace4c5`** (live inject strip + start-jump) on **`059e3f0e`** (Survival occupancy)  
**Failed prior score:** `20260821-1` — stopped @ **125** after TELEPORT **84** (42 paired blinks); old 25-tile nearest-anchor bar  
**Score sim 1:** `20260822-1` — persist green @ 400; runner killed by apt; late 0/15  
**Score sim 2:** `20260822-2` — **stopped @ 46** (force). Walk loop **FAIL** from step 5. RCA: `20260822_RCA_far-landings.md`  
**Score sim 3:** `20260823-2` — stopped @ **3690**/4000 to deploy stay-pin · tip **`53ace4c5`** · do **not** resume  
**Score sim 4 (live):** `20260825-1` — 4000 sprint · tip **`4ab4f5be`** (`ivan/gather-stay` on `railway`) · `HEADLESS_TAB_REUSE=false` · diagnostic **off**  
**Baseline / fork:** `soul15_seed_20260224` · `copy_memories=true` · `copy_coords=false`  
**Target steps:** `4000` sprint · **`diagnostic_mode=false`**  
**Env:** `HEADLESS_MOVEMENT_ENABLED=true` · `HEADLESS_TAB_REUSE=false` · `HEADLESS_STRICT_ABORT` default **false** · `INTENT_PERSIST_HARD_FAIL=true` · `MAX_TILES_PER_STEP=6`  
**Posture:** Survival sprint, diagnostics **off**. VPS `api-gateway.service` (not `double-api`) · HTTP `127.0.0.1:8001`. Do **not** restart the gateway while this run is live.

**Launch (VPS):** see §0.

---

### 0. Preflight

```bash
cd /var/www/generative_agents
git log -1 --oneline   # expect fcf5717f
curl -sS http://127.0.0.1:8001/api/simulations/20260821-1/status/current
# backend_process_active should be false

# fork + start (do not resume 20260821-1)
curl -sS -X POST http://127.0.0.1:8001/api/simulations/fork \
  -H "Content-Type: application/json" \
  -d '{"sim_code":"20260822-1","baseline":"soul15_seed_20260224","description":"Survival scoring rerun after start-jump reject","copy_memories":true,"copy_coords":false,"generation_mode":"sprint"}'

curl -sS -X POST http://127.0.0.1:8001/api/simulations/20260822-1/start \
  -H "Content-Type: application/json" \
  -d '{"action":"start","parameters":{"max_steps":2600,"generation_mode":"sprint","diagnostic_mode":false}}'
```

- [x] VPS tip **`fcf5717f`**; `api-gateway` active; health healthy
- [x] Prior sim `20260821-1` stopped / no process (step **125**, Premiere 08:35)
- [x] Fork + start `20260822-1`; UUID / PID / tip recorded
- [x] Survival armed (`is_survival=true`) — label **Premiere** · engine_day **1** (grace; no challenge)
- [x] 15 personas · sprint · diagnostic **off**

**Recorded:** UUID `8855348c-d27d-4917-8752-5b53ac511d94` · first PID `14735` · tip `fcf5717f` · fork `2026-08-22T00:42:11Z` · `curr_time` start `2026-08-22 06:30` · maze `6221df54-…` · max_steps 2600 · Survival init **15** players

**Stop / stall @ step 400 (`2026-08-22T06:47Z` wall / sim 13:11):** runner gone. Last log is step 400 headless 0/15 + continuity fallback. Status API still says `running` / `is_generating` (stale). **Do not treat as a live run.**

**Score sim 2 `20260822-2`:** forked after apt lock. Force-stopped **2026-08-22T23:18:31Z** @ step **46** (Premiere 07:16). **22** far-landing rejects from step **5**. STRICT **34**. Accepted typically **0–5/15**. Does **not** pass this paper. See `20260822_RCA_far-landings.md`. **Do not resume.**

**Smoke after inject+tab-reuse fix:** `20260823-1` · tip **`53ace4c5`** · `HEADLESS_TAB_REUSE=false` · 30 steps **completed**. Rejects **0** · STRICT **0** · `actual_path` **15/15** every step. Not a gather score.

**Score sim 3 `20260823-2`:** forked **2026-08-23T00:45:51Z** from `soul15_seed_20260224`. Started **00:46:03Z**. Runner PID **51617** · `rs.start_server(4000)` · Survival **Premiere** · engine day **1** · 15 personas · sprint · diagnostic **off**. Do **not** resume 21-1 / 22-1 / 22-2. Gather only after engine day **2**. Wall clock ~**31 h** at ~28 s/step.

**Mid-run health @ step 1494 (`2026-08-23T17:56Z` wall / sim Aug 24 07:23):** still generating. Engine day **2** / season day 1 morning — **do not score gather yet**. Analyzers: TELEPORT **0** · persist start→end >6 **0/22425** (max **6**) · bath→Park **0** · piano V2 **0** · wait-wrap **0** · addr≠@ **0** · headless accepted **22424/22425** · `tab_reused=False` all 1495. Soft/known: CD **213** (S1 later) · APT-N **475** · Gap1 **17** / Gap2 **13**.

**Score freeze `20260823-2` @ step 3173 (`2026-08-24T16:08Z` wall / sim Aug 25 11:24):** still generating (PID **51617**, 4000 sprint). Engine day **3** / season day **2** CHALLENGE. Day-1 challenge + vote are on disk. Day-2 vote is not. Gate A + day-1 Gate B scored below. Run left live.

**Day-2 vote freeze `20260823-2` @ step 3634 (`2026-08-25T00:12Z` wall / sim Aug 25 19:04):** still generating (PID **51617**, ~47 h). Engine day **3** / season day **2** VOTING. Day-2 vote **fired** @ step **3630** (`spatial_gate`, 19:00). Occupancy + overlay + present-only path scored below. Official vote tally / night elim not on disk yet (LLM collection in flight; elim phase 21:00). Run left live to **4000**.

---

### 1. Early smoke (~steps 50–100)

- [x] Tip still `fcf5717f`; 15/15 persona-steps through **400**
- [x] No traceback flood (0 `Traceback` in runner log)
- [x] Soft: no bathroom→Park place-claim — **0** through 400
- [ ] Soft: soak `PLACE-CLAIM-DEFER` / `TRAVEL-DEFER` *(diagnostic off — not grepped)*
- [ ] No `HEADLESS_STRICT_ABORT` storm — **FAIL late** on `20260822-1` (8 @ 388–400); **FAIL from step 5** on `20260822-2` (34)

**Result:** **PASS early; FAIL late headless** on `20260822-1`. **`20260822-2` FAIL from step 5** (home reports, 0–5/15). Same class, earlier.

---

### 2. Held regressions — **must stay green**

*Mid-run @ steps 0–400 (Premiere 06:30–13:11):*

| Bar | `20260802-1` @ ~1677 | This tip @ 400 | Pass? |
|-----|----------------------|----------------|-------|
| Place-claim bath→Park | **0** | **0** | **PASS** |
| Dorm-@ / addr≠@ | addr≠@ **0** | addr≠@ **0** | **PASS** |
| TELEPORT (analyzer, bar 10) | **0** | **0** | **PASS** |
| Piano V2 (AL) | **0** | **0** | **PASS** |
| Gap-1 / Gap-2 staff | 0 / **1** | **0** / **0** | **PASS** |
| Class P named-travel→Park | soft **34** | soft **4** (Olivia Hobbs walk via Park garden, steps 23–26) | soft — same class, smaller |
| APT-N | **287** | **10** (Vince / Vincent / Dean commute paint) | soft |
| Prefer-emit morning | not re-run | not re-run | soft *(carry)* |

**Result:** **PASS** on hard held bars through 400. Class P / APT-N still soft.

*`20260823-2` @ 3173 (AL + persist on movement / Supabase):*

| Bar | @ 1494 | @ 3173 | Pass? |
|-----|--------|--------|-------|
| Place-claim bath→Park | **0** | **0** | **PASS** |
| Dorm-@ / addr≠@ | **0** | **0** | **PASS** |
| TELEPORT (analyzer, bar 10) | **0** | **0** | **PASS** |
| Piano V2 (AL) | **0** | **53** (Alex Shepard 28 + Mike Hooks 25; gather walk parked on cafe `:piano` leaf; play-piano **0**) | **FAIL** held bar |
| Gap-1 / Gap-2 staff | 17 / 13 | **17** / **18** | soft — same class |
| Class P named-travel→Park | soft | soft **48** (4 people, Hobbs walk via Park) | soft |
| APT-N | 475 | **528** | soft |
| Wait-wrap | **0** | **0** | **PASS** |

**Result @ 3173:** hard place / addr / TELEPORT / wait-wrap still **PASS**. Piano V2 **no longer 0** — cafe gather used the piano leaf. Not a play-piano leak.

---

### 3. Primary gate A — start-jump (new)

Baseline = `20260821-1` @ 88: analyzer TELEPORT **84** (42 paired blinks). FE 1-point landings 11–23 tiles away; BE accepted under the old 25-tile nearest-anchor bar; next start jumped.

| ID | Fail sim `20260821-1` | This tip @ 400 | Pass? |
|----|----------------------|----------------|-------|
| Analyzer TELEPORT | **84** | **0** | **PASS** |
| Persisted start→end Manhattan >6 | common | **0** / 6015 rows | **PASS** |
| Reject far landing (Dean-style) | accepted | 37 `implausible_teleport` rejects (max=6) | **PASS** (guard fired) |
| Rejected report does not become next start | fail | implied by TELEPORT **0** | **PASS** |
| Headless still 15/15 after a blink | n/a | **0/15** @ 388–400 | **FAIL** |
| FE stops emitting far 1-point paths | n/a | still snaps home (e.g. Alexis 119,28 → 26,32 jump **97**) | **FAIL** (FE residual) |

**What happened @ 388–400:** FE reported almost the whole cast back at **home / spawn** tiles while `start_pos` was still on the walk (Hobbs / Oak Hill / dorm quad). BE refused every landing >6. Continuity kept last good tile. Then headless marked the step 0/15 and the runner died.

**Checks:**
- [x] Analyzers: TELEPORT **0** · no persisted >6
- [x] Guard rejects logged (37) with `max=6`
- [ ] Headless stays 15/15 after a reject — **FAIL**
- [ ] FE 1-point far path gone — **FAIL** (separate FE ticket)

**Result:** **BE persist GREEN. Loop not green.** People no longer *stay* at the blink, but the step no longer has a valid walk report. Need FE to stop the home-snap **or** a continuity report that still counts as accepted.

**`20260822-2` @ 46 (same tip):** 22 rejects (jump 7–31, home/spawn tiles) from step 5. STRICT 34. Accepted 0–5/15. Persist guard still correct. Loop **FAIL** earlier than 22-1. RCA `20260822_RCA_far-landings.md`.

**`20260823-2` score @ 3173 (movement files 3174 · 46746 start/end rows · tip `53ace4c5`):**

| ID | Fail sim `20260821-1` | `20260823-2` @ 3173 | Pass? |
|----|----------------------|---------------------|-------|
| Analyzer TELEPORT (bar 10) | **84** | **0** (realism issues = CD only) | **PASS** |
| Persisted start→end Manhattan >6 | common | **0** / **46746** (max **6**; 5535 rows at the cap) | **PASS** |
| Cross-step start vs last end >10 | common | **0** | **PASS** |
| Reject far landing | accepted | **0** `implausible_teleport` · **0** `Rejecting movement_report` | **PASS** (no blink this run) |
| Rejected report does not become next start | fail | implied by TELEPORT **0** + persist **0** | **PASS** |
| Headless after a blink | 0/15 | no blink; **0** STRICT; **0** Traceback; `tab_reused=False` all **3174** steps; OBS accepted **46596**, no reject status | **PASS** this run |
| FE stops emitting far 1-point paths | n/a | not proven; no home-snap landed in persist | residual **open** (not scored fail) |

**Result @ 3173:** **Start-jump GREEN.** Persist held through two competitive mornings. Walk loop stayed up (unlike 22-1 / 22-2). Do **not** rewrite SOT §4.7 until the 4000 sprint finishes green.

**Persist recheck 3174–3632:** **6426** start→end rows · over-6 **0** · max **6**. Start-jump still green through the day-2 vote fire.

---

### 4. Primary gate B — Survival gather + present-only (new)

Carry: `20260802-1` Day-1 20:00 Hobbs **8/15** (serious). RCA `20260821_RCA_realism.md` #2 ghosting.

Premiere = engine day 1 = **grace**. Season state @ 400:

- `current_day=1` · `phase=SLEEP` · `challenge_results=[]` · `eliminated=[]`
- Analyzer gather: `challenge_pct=null` · `voting_pct=null` — **correct**

| ID | Bar | This tip @ 400 | `20260823-2` day 1 | Pass? |
|----|-----|----------------|--------------------|-------|
| Premiere has no challenge / vote | required | empty board | engine day 1 grace (Aug 23) | **PASS** (grace) |
| Challenge Hobbs ≥12/15 (engine day ≥2, ~11:00) | ≥80% or fail-closed | **not reached** | occupancy **8/15** @ 11:00 step **1710** (`deadline`, 7 absent) · minority board ran (3 holders) | **FAIL** |
| Vote Hobbs ≥12/15 (engine day ≥2, ~20:00) | ≥80% or fail-closed | **not reached** | occupancy **12/15** @ 19:00 step **2190** (`spatial_gate`, 3 absent) | **PASS** |
| Absentees cannot win / no fake cards | RCA #2 | **not reached** | 7 challenge absentees folded `absent` (no card) · 3 vote absentees `voted=false` + `phantom_applied` with **0** phantom votes in the tally · winner Ivan present · elim Alex Butcher present (6.0) | **PASS** |
| Lock-In is WEIGHT_UP not Shield | Day 3 | **not reached** | Day 2 Silent Pact already wrote `WEIGHT_UP` **1.5** (not ×2) + Vince `IMM_TRANSFER` | not the Lock-In day |
| Overlay names played / absent / last elim | after first resolve | **not reached** | public board has holders + winner; absent rows exist | **PASS** (see day-2 overlay) |
| Chat fact-rot (RCA #3) | after first resolve | **not reached** | not re-scored this pass | unverified |
| Same voice / empty social SOT (RCA #4–5) | later | **not reached** | prior chat pass: same house voice | **S1** later |

**Day-1 occupancy (controller `survival_phase_trigger.ndjson`, tiles not address):**

- Challenge 11:00: absent Alex Shepard, Alexis Reed, Dean Sanford, Diana Ogden, Mike Hooks, Nick Miller, Vince Vale → **8 sat / 15**. Address labels at that step said **15/15 at Hobbs**. Score the tiles.
- Vote 19:00: absent Alexis Reed, Dean Sanford, Vince Vale → **12 sat / 15**. Tally has those 12 only.
- Day 2 challenge 10:52: `spatial_gate` **11/14** absent Diana Ogden, Nick Miller, Owen Logan. Those three have `reasoning: absent` (no real Silent Pact card). **PASS** occupancy (`int(14*0.8+0.5)=11`).
- Day 2 vote 19:00 step **3630**: `spatial_gate` **11/14** absent Alex Shepard, Ivan Pitts, Mike Hooks. Tiles confirm the same three off Hobbs (Rose / dorm / Rose). Action text said **14/14 heading to Hobbs**. Score the tiles. **PASS** occupancy.

**Day-2 present-only / overlay (vote fire, tally still pending):**

- Vote LLM log @ 3630: **11** `vote_decision` **entry** lines — the 11 sitters only. No entries for Shepard / Ivan / Mike. Path is present-only. Official tally + night elim not persisted yet (`phase=VOTING`, `eliminated` still only Alex Butcher).
- Overlay on disk: sitters read “you played”; day-2 challenge absentees (Diana / Nick / Owen) read “you were absent (you did not sit).” Winners + public names + last elim **Alex Butcher** + remaining **14**. Shepard missed the vote but sat the challenge, so his overlay still says he played — that is the challenge board, not the vote.

**Result:** **Gather NOT green.** Ship rule is challenge **and** vote ≥80% **or** fail-closed. Day-1 challenge missed (**8/15**) **and** still ran a 3-person Hold board. Day-1 vote **12/15**, day-2 challenge **11/14**, day-2 vote **11/14** all hit the bar. Present-only and overlay did what we asked. 8/15 carry is still the measured fail.

---

### 5. Social — instrument hold only (S1 not this tip)

| ID | `20260802-1` @ ~1677 | This tip @ 400 | `20260823-2` @ 3173 | Notes |
|----|----------------------|----------------|---------------------|-------|
| Chat CD honest | **307** · gap0 **0** | **102** · gap0 **0** | **607** (realism-only issue type) · Irene↔Max cafe loop dominates | still talk-loop ugly; **S1 later** |
| Cafe still lively | yes | yes | yes (Hobbs still the social room) | held |
| ≥5 `eff_cd=3` inspected | open | not done | not done | optional |

**Carry:**
- [ ] ≥5 `eff_cd=3` rows inspected *(optional before S1)*
- [x] S1 problem statement: **102** CD / 400, then **213** / 1494, now **607** / 3173. Size S1 off this. Not this tip.

**Result:** Instrument only. **S1 not shipped here.**

---

### 6. Display honesty + Talk Path A

- [ ] Soft morning probe: `api_fail_candidates=[]` *(carry)*
- [ ] Talk Path A — **HOLD**

**Result:** Open / HOLD — out of tip scope.

---

### 7. Analyzers + census

- [x] AL / realism / survival exported @ **400** (`exports/20260822-1`, `exports/20260822-1-survival`)
- [x] `20260823-2` @ **3173**: persist on VPS movement · `analyze_sim_realism.py` supabase (export `tests/_tmp_realism_20260823-2_score`) · `analyze_action-location.py` supabase · `analyze_sim.py` supabase `--profile long` · controller `survival_phase_trigger.ndjson`
- [x] TELEPORT **0** · persist >6 **0/46746** · bath→Park **0** · addr≠@ **0** · wait-wrap **0**
- [x] Piano V2 **53** · play-piano AL **0**
- [x] Day-1 vote gather scored (occupancy **12/15**)
- [x] Day-1 challenge gather scored (occupancy **8/15**, not fail-closed)
- [x] Day-2 vote (~20:00 season day 2) — occupancy **11/14** @ 3630 (`spatial_gate`); tally pending 21:00
- [ ] VPS soak greps *(diagnostic off)*

**Result:** Long-score census **done** through 3173. Day-2 vote occupancy scored @ **3630**. Sprint still running to 4000.

---

### 8. Decision gate

| Question | Answer | Next |
|----------|--------|------|
| Did start-jump stop persisted snaps? | **YES** @ 3173 | Keep BE rule |
| Did the walk loop stay healthy? | **YES** this run (0 reject, 0 STRICT, runner live) | Keep `HEADLESS_TAB_REUSE=false` |
| Piano / place bars held? | place/addr **YES**; piano V2 **NO** (53 gather-leaf) | note only |
| Vote gather ≥12/15? | Day-1 vote **YES 12/15**; day-2 vote **YES 11/14**; day-1 challenge **NO 8/15**; day-2 challenge **YES 11/14** | gather investigation (day-1 chal) |
| Honest CD still talk-loop ugly? | **yes** (**607**/3173) | **S1** later |
| Public MVP? | **NO** | gather + S1 |

- [x] Do **not** rewrite SOT §4.7 yet (sprint not finished; gather not green)
- [x] Do **not** mix S1 on this tip
- [x] Do **not** call Survival gather from Premiere
- [x] Do **not** stop `20260823-2` for this score — day-2 vote now scored; leave live to 4000

**Result:** **Start-jump YES / day-1 gather NO / day-2 gather YES / MVP NO.**

---

### 9. Stop + SOT

```bash
# status is stale — confirm no runner before anything else
pgrep -af temp_runner_20260822
curl -sS -X POST http://127.0.0.1:8001/api/simulations/20260822-1/stop \
  -H "Content-Type: application/json" \
  -d '{"action":"stop","parameters":{"force":true}}'
```

- [x] `20260822-1` / `20260822-2` already dead — **do not resume**
- [x] `20260823-2` left **running** after this score (day-2 vote scored; 4000 not done)
- [x] No normative SOT until gather is also green

**Result:** Paper scored on start-jump + day-1 gather + day-2 vote occupancy. Official night tally still pending. Runner left live.

---

### 10. Realism + naturalness (`20260823-2` @ 3173)

Scored with `analyze_sim_realism.py` (supabase, every step), `analyze_sim.py` `--profile long`, and `analyze_action-location.py`. Official Naturalness Gate still needs a paired 60–100 baseline — **not GO**. Numbers below are this run only.

**Realism (movement truth)**

| Check | @ 3173 | Call |
|-------|--------|------|
| TELEPORT / persist >6 / cross-step start jump | **0** / **0/46746** / **0** | **PASS** |
| Movement std dev | **2.0** tiles | healthy walk, not blink |
| bath→Park | **0** | **PASS** |
| addr≠@ | **0** | **PASS** |
| Wait-wrap | **0** | **PASS** |
| Piano V2 / play-piano | **53** / **0** | gather leaf only; not play-piano |
| REACHABILITY_OVERRIDE | **1557** | FE/BE reroute noise; not a teleport |
| LONG_STATIONARY_STREAK | **915** | sleep + cafe sit; expected in a 2-day sit |
| PING_PONG / POSITION_OSCILLATION | **5** / **76** | soft |
| Context carry-forward | overall **79** · movement **100** · followthrough **94** · memory **100** · actions **0** | actions=0 is the long-sit formula (915 stalls), not “no plans” |
| Coverage gap 46746/47610 | Alex Butcher rows stop @ 2309 after elim | not a write hole |

People move in 1–6 tile steps. They sleep, commute, sit Hobbs, then walk again. They do not jump the map. Labels at 11:00 said everyone was at Hobbs; tiles said 8 sat. That is the gather miss, not a teleport miss.

**Naturalness Gate (6 criteria — official GO blocked, no paired baseline)**

| # | Metric | This run | vs mid-run @1494 | Notes |
|---|--------|----------|------------------|-------|
| 1 | Subactivity switches / 60 steps | **110.43** | 113.86 | High; cannot call 2× baseline without the pair |
| 2 | Overdue ratio | **0.0** | 0 | **PASS** vs any sane bar |
| 3 | Stall / forced replan | **0.0** | 0 | **PASS** |
| 4 | Stationary-progressing | **0.79** | 0.69 | Sitting still does work (cafe / sleep / challenge wait) |
| 5 | Chat integrity (structured) | **1.0** | 1.0 | Payload timestamps still ugly (**961** `timestamp count (0) != utterances`) |
| 6 | Multi-venue | engine day 1 **5–8** (mean 6.5) · day 2 **5–8** (mean 6.7) · day 3 morning **3–6** | day 1 5–8 | Present. Day 3 is only to 11:24 |

**Talk / social (not the Gate, but the product feel)**

- CD **607** and rising (Irene↔Max cafe loop). S1 later.
- Prior chat pass on this sim: many pairs share one house voice; ~29% fourth-wall. Structured chat is intact; the words are not life-like.
- Cafe stays lively. That is not the same as natural speech.

**Call:** movement realism **green** for start-jump. Naturalness Gate **not official GO** (no baseline pair + talk still ugly). Survival gather **fail** on day-1 challenge occupancy.

---

### Verdict

| Gate | Result | Notes |
|------|--------|-------|
| **0 preflight** | PASS | tip `53ace4c5` + fork `20260823-2` |
| **1 early smoke** | PASS on 23-2; prior 22-1/22-2 FAIL | 23-1 smoke 30 steps also green |
| **2 held regressions** | MIXED @ 3173 | bath / addr / TELEPORT / wait-wrap **PASS**; piano V2 **53** |
| **3 start-jump persist** | **PASS** | TELEPORT **0**; >6 persist **0/46746** |
| **3b headless after reject** | **PASS this run** | 0 reject · 0 STRICT · runner live |
| **4 Survival gather** | **FAIL** day-1 challenge **8/15** + minority board; day-1 vote **12/15 PASS**; day-2 chal+vote **11/14 PASS** | present-only **PASS** (day-2 tally pending) |
| **5 social instrument** | recorded | CD **607** · S1 later |
| **6 display / Talk A** | open / HOLD | |
| **7 analyzers** | scored @ 3173 | sprint still running |
| **8 decision** | persist YES / gather NO | |
| **10 realism / naturalness** | movement green; Gate not official GO | see §10 |
| **This tip ship?** | **partial** | keep BE reject + occupancy; do not call gather done |
| **Public MVP?** | **NO** | see below |

---

### MVP ready?

**No — not full public MVP yet.**

| Layer | Ready? | Why |
|-------|--------|-----|
| **Start-jump persist** | **Yes @ 3173** | Blink does not become next start; no blink this run |
| **Walk loop after a blink** | **Yes this run** | No reject storm; runner still generating |
| **Place MVP** | **Mostly** | bath / addr green; piano V2 53 gather-leaf |
| **Survival gather (vote / challenge)** | **No** | Day-1 challenge **8/15** and the board still ran. Day-2 chal+vote both **11/14** |
| **Social MVP** | **No** | CD **607**; same-voice / fourth-wall still open |

**Call:** Keep **`53ace4c5`**. Leave **`20260823-2`** running to **4000**. Do **not** resume 21-1 / 22-1 / 22-2. Do **not** rewrite SOT §4.7. Next Survival ticket is the stay-until-event pin (day-1 8/15 leavers). Keep **S1** as the social follow-up.

---

### Next after this paper

| If… | Then… |
|-----|--------|
| Resume 21-1 / 22-1 / 22-2 | **No** |
| Day-2 vote on this run | **Scored** @ 3630: occupancy **11/14 PASS**. Official tally / night elim still pending 21:00 |
| Gather still <12/15 on a challenge | Dedicated Survival/gather investigation (lock retain, not L1/S1) |
| CD still ugly | **S1** later off **607**/3173 |
| Talk Path A | Still HOLD / separate |
| Long score green on start-jump **and** gather | Then update SOT §4.7 (25 → 6) |


# -- Plan — Stay at the appointment until the event fires --

**Repo:** `generative_agents` · feature branch `ivan/gather-stay` (do not touch live `20260823-2` / do not restart the gateway)  
**Paper:** after lock-in, add a TODO section to `D:\Coding\double-ivan\20260821_checklist.md`  
**No code until you lock the two product calls below.**

---

## What broke on `20260823-2`

The last-hour lock already walks people to Hobbs. Once a body is on a cafe tile, the lock **stops**. The daily plan then sends them to Oak Hill or the pub. The lock puts the sentence “heading to Hobbs” back on, but the body keeps walking. Five of the seven 11:00 absentees had already sat.

Premiere is safe: Survival is dormant on engine day 1 (`survival_mode` stays false), so this lock does not run on the grace day.

---

## Product calls to lock

### 1. Stay in the cafe, do not freeze the tile

They may sit, order coffee, use the piano, and talk **inside Hobbs**. They may not leave Hobbs for college, park, pub, or home until the appointment they came for has fired.

Freeze-on-tile would turn the hour into statues and would kill cafe chat. That is not the rest of the sim.

### 2. Release when **that** event fires, not when the clock hits the hour

| Appointment | Hold window | Release |
|---|---|---|
| Challenge | 10:00 → fire | Fire = 80% sit **or** 11:00 deadline. Then free (lunch / jobs). |
| Vote | **18:00** → fire | Fire = 80% sit (from **19:00**) **or** 20:00 deadline. Then free (go home). Vote already has this via `post_vote_date`. Lock starts at 18:00 so 19:00 fire cannot beat the walk. |

If we hold until 11:00 after a 10:52 fire, that is only eight extra minutes. If we hold until 20:00 after a 19:00 vote, that is a wasted hour after the vote. Same rule for both: **event done → lock off.**

We do **not** hold for the whole Challenge phase (08:00–12:00). That would trap them all morning and break jobs.

---

## What we will not mix into this slice

- Shepard / Diana never sat (walk said cafe, body went park / college). That is a dest/path leak **after** they left the cafe set. Stay-on-arrival stops the five leavers. The two who never arrived stay a **follow-up**, not this TODO.
- S1 chat voice, Talk Path A, SOT §4.7 rewrite, new env flags.

---

## How it fits the rest of the sim

| System | Keep working |
|---|---|
| Cafe chat | If they are talking, do not rewrite the action. Both stay in the cafe, so talk can finish. |
| Social seek | Already paused in this hour. Keep that. |
| Piano / coffee / seating | If the destination is still Hobbs, leave it. |
| Challenge / vote scoring | Occupancy is snapshotted **before** resolve, then people may walk away. Present-only scoring unchanged. |
| Post-vote go-home | Existing `post_vote_date` already turns the lock off. Keep that. |
| Lunch / afternoon | Challenge stamp turns the lock off. 12:00 Social phase is free either way. |
| Premiere | `survival_mode` false. No lock. |
| Sleep override | Keep: a sleeper in this hour is still woken and sent to the cafe. |

---

## Implementation (after lock-in)

One behaviour change, three files.

**Controller** — each step, if today’s challenge row already exists on the season, stamp `scratch.survival["challenge_resolved_date"]` with today’s calendar date (same shape as `post_vote_date`). Resume-safe: the row lives on the season, not only in memory.

**Gather lock** (runs at the end of every `plan()`, after the planner):

1. Window = current last hour **and** that appointment is not yet resolved (no today’s challenge stamp / no today’s post-vote stamp).
2. Off cafe → keep today’s force-walk to cafe seating.
3. On cafe + destination still Hobbs → do nothing (in-cafe life).
4. On cafe + destination would leave Hobbs → pin destination back to cafe seating, clear the leftover college/pub path, use a stay sentence (not “heading to”).
5. On cafe + currently chatting → do not touch the action.

**Tests** (`tests/test_survival_gather_lock.py`):

- On cafe + college dest → dest stays Hobbs; path cleared.
- On cafe + cafe dest → no rewrite.
- On cafe + chatting → action unchanged.
- After `challenge_resolved_date` today → lock off (they may leave).
- Existing off-site force-walk, premiere/outside-window, seek-paused, sleep-wake tests still pass.

Check after the chunk: `python -m pytest tests/test_survival_gather_lock.py -v`

Then `/verify` only if we also touch execute/movement. This slice should not.

**SOT:** live contract stays Current until a green gather score. Optional later: `sot_survival` “stay until fire, not until first touch.”

---

## Checklist TODO

Coded on `ivan/gather-stay`. Do **not** deploy onto live `20260823-2`.

- [x] Stay pin: on cafe, reject leave dest until that event fires
- [x] Challenge stamp `challenge_resolved_date` (resume-safe)
- [x] Vote still releases on `post_vote_date`
- [x] Vote lock starts at 18:00; vote **gate** still 19:00
- [x] In-cafe sit / stand / chat / piano still allowed (11 seats; stand if full)
- [x] Premiere still unlocked
- [x] Unit tests green (`tests/test_survival_gather_lock.py` 18 passed)
- [ ] Re-score gather on a new competitive-day run (do not resume 21-1 / 22-1 / 22-2 / 23-2)

---

## Risks

- Bathroom is not inside Hobbs. One hour without a toilet is acceptable.
- If dest pin fights place-language the same way the off-site “heading to Hobbs” walk already does, sitters are still safe; walkers remain the follow-up.
- Do not deploy onto the live 23-2 process. New branch, new fork after this run ends.
