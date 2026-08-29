# 20260827 — Checklist: Pass 1 skip-Premiere score

**Purpose:** Score Pass 1 on a **new** fork with Premiere skipped. Challenge occupancy at **11:00**, vote at **20:00**. Do not resume `20260825-1`.

**Prior:** `20260825-1` stay-pin **FAIL** (challenge 9/15 then 6/14). Start-jump **PASS**. Tip then `4ab4f5be`.

**This tip:** `origin/railway` @ **`266aa54f`** (Pass 1: 30-min lock both appointments; fire at 11:00 / 20:00; honest dest text; thin town talk; skip-Premiere)

**Score sim:** `20260827-1` · UUID `a31712bf-8b45-46fa-8fd8-56ba7c3d6058` · `HEADLESS_TAB_REUSE=false` · diagnostic **off** · skip-Premiere **on**
**Baseline / fork:** `soul15_seed_20260224` · `copy_memories=true` · `copy_coords=false`
**Env:** `HEADLESS_MOVEMENT_ENABLED=true` · `HEADLESS_TAB_REUSE=false` · `INTENT_PERSIST_HARD_FAIL=true` · `MAX_TILES_PER_STEP=6` · `SURVIVAL_MODE_ENABLED=true`

**Score at tiles, not labels.** Premiere is off this run (engine jumped day 1 → day 2 05:55). Step 0 = Aug 28 05:55. Denom: day 1 **/15**; day 2 **/14** (Alex Butcher out). 80% bar = **12** then **11**.

> **Verdict @ step 1850 (`2026-08-28`, clock Aug 29 12:45):** Pass 1 gather **FAIL**. Start-jump **PASS so far**. Public MVP **NO**. Day-2 vote **not yet** (20:00 = step 2285). Do not ship gather. Do not stop the runner. Do not patch. Do not rewrite SOT §4.7.
>
> | Layer | Call |
> |---|---|
> | Skip-Premiere | **PASS** — first clock is competitive day 2 05:55; `start_date` still Aug 27 |
> | Challenges ≥80% @ 11:00 | **FAIL** — **3/15** then **6/14**, both `deadline` |
> | Votes ≥80% @ 20:00 | **FAIL** day 1 **8/15** `deadline`. Day 2 **wait** |
> | Start-jump | **PASS so far** — persist >6 **0/26819**; consecutive-step >6 **0**. TELEPORT not re-grepped (runner left alone) |
> | Honest dest text | **FAIL** — bodies off Hobbs still say they are heading there |
> | Spoken fourth wall (simulation / AI / backend) | **PASS** — **0** lines. Two in-world “Doubland” place-name lines |
> | Sofa / re-greet | **FAIL** — same pairs re-open with “Morning” a minute later |
> | Present-only / absentees cannot win | **PASS** — winners sat; board rows match who was in the cafe |
>
> Vs `20260823-2` / `20260825-1`: first competitive 11:00 went **8/15 → 9/15 → 3/15**. Day-2 morning matches 25-1 (**6/14**), not 23-2’s 11/14. Day-1 vote went **12/15 → 12/15 → 8/15**.

**Cause (already closed):** lock writes the sentence, not the walk — and freezes arrivals while it is on. Paper: `20260827_gathering_issue_RCA+recommendations.md` §§1–11. Do not re-litigate here.

**Out (band-aids):** H3 dest-rewrite, fail-closed, longer pins, fire-when-12.

---

### 0. Preflight

- [x] VPS tip **`266aa54f`**; `api-gateway` active
- [x] No prior runner; `20260825-1` completed — not resumed
- [x] Fork + start `20260827-1`; PID **533153**; 15 personas; sprint; diagnostic **off**; `skip_premiere: true`
- [x] Engine clock jumped `2026-08-27 06:30` → **`2026-08-28 05:55`** (day 2); `start_date` unchanged; step **0**
- [x] `HEADLESS_TAB_REUSE=false`

**Recorded:** fork `2026-08-27T19:30:23Z` · maze `f61c750d-…` · max_steps 4000 · UUID `a31712bf-8b45-46fa-8fd8-56ba7c3d6058`

---

### Clock map

| Event | Clock | Step |
|---|---|---|
| Day-1 challenge | 11:00 Aug 28 | **305** |
| Day-1 vote | 20:00 Aug 28 | **845** |
| Day-2 05:55 | Aug 29 | **1440** |
| Day-2 challenge | 11:00 Aug 29 | **1745** |
| Day-2 vote | 20:00 Aug 29 | **2285** (not on disk) |
| `max_steps` | | 4000 |

This score freeze: **step 1850**, `curr_time` **2026-08-29 12:45**, still generating. 14 alive.

---

### 1. Skip-Premiere

Engine started on Survival day 1 (label) / engine day **2** at 05:55. No grace-day challenge or vote. `start_date` still **2026-08-27**.

**Cost (not a fail of the skip):** the first 11:00 is also the first morning they ever planned. Job blocks still put cafe **after** 11:00 for several people. That is why this morning is thinner than 25-1’s first competitive 11:00 — see RCA. The skip itself did what we asked.

- [x] First scored challenge is 11:00 Aug 28 (step 305), not a Premiere dummy
- [x] Cast of 15 at that fire; Alex Butcher out after the 20:00 vote

**Result:** **PASS**

---

### 2. Primary — occupancy at the declared clock

Score **tiles**. “Heading to Hobbs” is not sitting. Fires below 80% are **`deadline`** (room never hit the gate).

| ID | Bar | `20260823-2` | `20260825-1` | `20260827-1` | Pass? |
|----|-----|--------------|--------------|--------------|-------|
| Skip-Premiere / no Premiere board | required | grace day 1 | grace day 1 | skip on | **Yes** |
| Day-1 challenge sit ≥12/15 @ **11:00** | ≥80% | **8/15** `deadline` | **9/15** `deadline` | **3/15** `deadline` step **305** | **No** |
| Day-1 vote sit ≥12/15 @ **20:00** | ≥80% | **12/15** `spatial_gate` ~19:00 | **12/15** `spatial_gate` ~19:49 | **8/15** `deadline` step **845** | **No** |
| Day-2 challenge sit ≥11/14 @ **11:00** | ≥80% | **11/14** | **6/14** `deadline` | **6/14** `deadline` step **1745** | **No** |
| Day-2 vote sit ≥11/14 @ **20:00** | ≥80% | **11/14** | **11/14** | **wait** step 2285 | wait |
| H2 leavers still on Hobbs at fire | the pin | No | No | No — room thins inside the 30-min lock | **No** |
| Absentees cannot win | keep | PASS | PASS | **PASS** (below) | **Yes** |

**How to classify a miss**

- **H2** — on a Hobbs tile that morning / evening, **off at fire**. Pin should have stopped this.
- **H3** — never on a Hobbs tile in that window. Founder: do not yank.
- Classify H2/H3 from **05:55**, not lock−60. Mid-run “H3 = 5” was wrong (Mike and Nick sat at dawn).

#### Day-1 challenge 11:00 — **3/15 FAIL**

On cafe: **Alex Shepard, Dean Sanford, Irene Dove**. Board still ran (Hold; Dean won).

**H2 (9):** Alexis Reed, Andrew Abrams, Diana Ogden, Max Shoemaker, Olivia King, Vince Vale, Vincent Slater, Mike Hooks, Nick Miller.

**H3 never-sit (3):** Alex Butcher, Ivan Pitts, Owen Logan — all reachable in 30 min; they did not start.

Curve: peak **9 at 10:15** → **4 at 10:30 lock** → **3 at 11:00** → 8 at 11:10 (too late). Same shape as later appointments: usable room **before** the short lock, thin **at** the clock, surge **after**.

#### Day-1 vote 20:00 — **8/15 FAIL**

On cafe: Alex Butcher, Diana Ogden, Irene Dove, Ivan Pitts, Max Shoemaker, Mike Hooks, Olivia King, Vince Vale.

Those **8** were the **8** voters. Butcher voted out **while present**.

Curve: **10 at 19:10** → **8 at 20:00** → **11 at 20:10 → 12 at 20:15**. Hit 12 fifteen minutes late. 25-1 hit 12 under a longer evening invitation.

H2 in the 19:00 hour (sat, then gone at fire): Dean, Nick, Owen. Never in that hour: Shepard, Alexis, Andrew, Vincent.

#### Day-2 challenge 11:00 — **6/14 FAIL**

On cafe: **Irene Dove, Ivan Pitts, Max Shoemaker, Nick Miller, Olivia King, Vince Vale**.

**H2 (7):** Alexis, Andrew, Dean, Diana, Mike, Owen, Vincent. **H3:** **Shepard only**.

Curve: peak **9 at 10:15** → **5 at 10:30 lock** → **6 at 11:00** → **10 at 11:05**. Matches 25-1’s second morning (6/14), not 23-2’s 11/14.

Silent Pact. Winners Irene, Olivia, Max — all sat.

- [x] Day-1 challenge occupancy + H2/H3 from 05:55 — **3/15**; H2 **9**; H3 **3** (not the mid-run 7/5)
- [x] Day-1 vote occupancy — **8/15**; present-only match
- [x] Day-2 challenge occupancy + H2/H3 — **6/14**; H3 Shepard only
- [ ] Day-2 vote — wait for step 2285

**Result:** **FAIL gather.** Both scored challenges missed. Day-1 vote missed. The 30-min lock arrived to a thinning room and did not walk the job bodies in.

---

### 3. Start-jump (must stay green)

| Bar | Through step 1850 | Call |
|---|---|---|
| Persist `start_pos` → tile >6 | **0 / 26819** persona-steps | **PASS so far** |
| Consecutive step → step >6 | **0** | **PASS so far** |
| TELEPORT log | mid-run **0**; not re-opened on the live PID | do not SSH |

Sim still running. Re-check persist if we score again after 4000. Do not treat this as a finished-run persist until then.

**Result:** **PASS so far**

---

### 4. Honest dest text

Bar: no “heading to Hobbs” / challenge / vote verbs on bodies that are **off** the cafe.

Through step 1850 (cafe rectangle 72–83 × 19–30, same bbox as 25-1 trails):

| Signal | Off-cafe | All |
|---|---|---|
| “heading to Hobbs…” | **930** | 1212 |
| “waiting at Hobbs…” | 6 | — |
| Challenge / vote ritual verbs | **13** | 200 |

**At the fire clocks**

| Fire | Off-cafe “heading to Hobbs” |
|---|---|
| Day-1 challenge 305 | **11 / 12 absentees** (Vince “walking to Hobbs”; Irene on-cafe was cleaning the counter) |
| Day-1 vote 845 | **7 / 7 absentees** — all seven said heading to Hobbs (pub / co-living / supply) |
| Day-2 challenge 1745 | **2** with that exact phrase; others already said college / pub / sofa — emit changed, occupancy still missed |

Ritual off-site (same lie, different verb): challenge briefing at the pub and walking in from college; “Casting vote” while still on the pub walk (steps 859–861). Inside Hobbs, “casting vote” / “listening to the briefing” is fine.

**Result:** **FAIL.** Pass 1 asked for honest text. The sentence still advertises Hobbs while the body stays at the job. That is the lock writing `act_address` / the caption, not the walk.

---

### 5. Thin town talk

#### Spoken fourth wall

Bar: no **simulation / Doubland / backend / as an AI** in talk.

- **simulation / as an AI / backend:** **0**
- **Doubland as a place name:** **2** lines (Owen: “the most stable thing in Doubland right now”; Andrew: “the next frontier of Doubland politics”). Not “I am in a simulation.”

Identity seed is a different surface: every `currently` line is still **“On premiere day in Doubland with the full cohort of fifteen…”** (including eliminated Alex Butcher). Skip-Premiere did not refresh that seed. That is overlay / inner identity, not a spoken line.

**Result:** **PASS** on spoken meta. Flag the two town-name lines and the premiere `currently` seed — do not mix them into the occupancy fail.

#### Sofa / re-greet

Bar: one sofa = one talk until someone leaves. No new “Morning!” on the same pair a minute later.

Through step 1850:

| Signal | This run |
|---|---|
| Distinct chat opens (new first-line clock) | **917** |
| Opens that start with Hey / Morning / What’s up | **218** |
| Greeting re-open within **30** steps of the last talk | **72** (many **gap = 1** minute) |
| Longest pair (approx. talk-minutes) | Irene ↔ Olivia **~89** (23-2’s Irene ↔ Max was **607**) |
| Same pair, many opens | Irene ↔ Olivia **54** opens; Shepard ↔ Alexis **45** |

Example: Irene ↔ Max, steps 1456–1460 — five separate “Morning, Irene / Morning, Max” opens, one per minute, without leaving. Shepard ↔ Alexis still does “Hey! What’s up?” as a new talk.

This is **not** the 23-2 endless-sofa CD. Talks are short and chopped. Pass 1 sofa-persist did not hold.

**Result:** **FAIL** sofa / re-greet.

---

### 6. Present-only / overlay

**Present-only (season rows vs tiles) — PASS**

| Event | Sitters | Board |
|---|---|---|
| Day-1 challenge | 3 on tiles | 3 played; 12 `reasoning: absent`. Winner **Dean** sat |
| Day-1 vote | 8 on tiles | **8** LLM ballots, same 8 names. Butcher out while present |
| Day-2 challenge | 6 on tiles | 6 played; 8 absent. Winners **Irene, Olivia, Max** all sat |

Absentees did not win. Hold and Silent Pact both ran with a thin room — that is a gather miss, not a present-only miss.

**Overlay prompt strings — not scored this pass**

`dbl_memory` has **14** “vote has concluded” / Butcher-eliminated lines (the 14 survivors). **0** memories say “you played” / “you were absent” / “Last eliminated”. Those injections were counted on 25-1 from **VPS LLM logs**. We are not opening logs while PID **533153** is alive. Do not claim 519/519.

`currently` is still the premiere-day seed (above). Lifestyle is the Survival Day 2 brief, not the played/absent overlay paragraph.

**Result:** present-only **PASS**. Overlay copy **partial / unverified** (memories have last elim; `currently` still premiere; prompt injections not grepped).

---

### 7. Decision

| Question | Answer | Next |
|----------|--------|------|
| Challenge **and** vote ≥80% on a competitive day? | **No.** 3/15, 8/15, 6/14. Day-2 vote not in yet | gather not green |
| Did the 30-min lock keep H2? | **No.** Peak before lock, thin at the clock, surge after | do not lengthen the pin |
| Start-jump still green? | **Yes so far** (persist 0/26819) | keep the 6-tile reject; leave the runner |
| Honest text? | **No** | lock caption ≠ walk |
| Sofa persist? | **No** — greeting mill, short chopped talks | S1 still red |
| Public MVP? | **No** | gather + S1 |

- [x] Do **not** rewrite SOT §4.7 — start-jump green so far, gather **not**
- [x] Do **not** dest-rewrite H3, fail-closed, longer pins, or fire-when-12
- [x] Do **not** stop `20260827-1` — day-2 vote still to score
- [x] Do **not** resume 21-1 / 22-1 / 22-2 / 23-2 / 25-1

**Result:** **Start-jump YES so far / Pass 1 gather NO / sofa NO / Public MVP NO.**

The room is not “they never came.” They sit, they wait, the daily plan wins, the caption still says Hobbs. First competitive 11:00 is the worst of the three score sims (**3/15**). Day-2 morning is the same class as 25-1 (**6/14**).

**Do not:** call Pass 1 green · ship gather · patch this live runner · rewrite SOT §4.7 · SSH/journalctl on PID 533153.

**If there is a next fork (not this runner):** restore planner presence `lead_hours` to **1.0** (decoupled from the 30-min lock); fix travel-anchor inheritance; then either give the lock zone authority or delete it. Add `target_zone` to gather-lock tests. Invitation restore is the next product move — not a harder pin.

---

### MVP ready?

**No.**

| Layer | `20260823-2` | `20260825-1` | `20260827-1` @ 1850 |
|---|---|---|---|
| Start-jump persist | Yes | Yes | **Yes so far** |
| Gather at the declared clock | **No** | **No** | **No** (worse first 11:00) |
| Honest caption | No | No | **No** |
| Social / S1 sofa | No | not re-scored | **No** (re-greet mill) |

**Call:** Keep the start-jump reject. Do not call Pass 1 green. Leave **533153** up through 20:00 (and to 4000 unless you say stop). After day-2 vote lands, append occupancy only — do not reopen H-A vs H-B.

---

### Still waiting

- Day-2 vote occupancy @ **20:00** (step **2285**)
- Overlay LLM “you played / you were absent / Last eliminated” counts — only after the runner is gone
- TELEPORT journal on this PID — only after the runner is gone
- Full-run persist at 4000

---

### Papers (do not duplicate)

| Paper | Owns |
|---|---|
| `20260827_gathering_issue_RCA+recommendations.md` | **Everything.** Pass 1 = §§1–11. 1-A = §12. |
| `20260827_challenge_miss_pack/` | Day-1 11:00 tiles. Read with that paper’s §11B |
| `20260828_verify_pack/` | Occupancy curves, V4 66/589, scratch snapshot |
| `20260825_checklist.md` | Stay-pin score (9/15, 6/14) |
