# 20260825 — Checklist: stay at Hobbs until the event fires

**Purpose:** Score-prove tip **`4ab4f5be`** (stay-pin). On `20260823-2`, people reached Hobbs, then walked out before challenge / vote. This tip must keep them **in the cafe** until **that** event fires. Chat quality is the next ship — do not mix it here.

**Prior paper:** `20260821_checklist.md` — tip **`53ace4c5`** / `20260823-2` · start-jump **GREEN** · gather **FAIL** day-1 challenge **8/15** + minority board · day-1 vote **12/15** · day-2 chal+vote **11/14** · present-only / overlay **PASS** · **Public MVP NO**

**Shipped this tip:**
- On cafe, reject a leave dest (college / park / pub / home) until that event fires
- In-cafe sit, stand, talk, piano, coffee stay allowed
- Vote **lock** starts at deadline−2 (**18:00**); vote **gate** still **19:00**
- Morning lock releases on `challenge_resolved_date` (same shape as `post_vote_date`)
- Stand if the 11 seats are full — any Hobbs tile still counts

**Out of scope:** S1 / Talk Path A · dest/path leak for people who never sit · fail-closed if sit is still under 80% · FE home-snap · normative SOT §4.7 (still live **25**) · deploy onto a live runner

> **Ship rule:**  
> - **Stay-pin green** = on a competitive day (engine day **≥2**), people who were on Hobbs in the lock window are still on Hobbs at fire. Challenge **and** vote occupancy **≥80%** (12/15, or 11/14 after one elim), **or** fail-closed. Score **tiles**, not “heading to Hobbs.”  
> - Premiere (engine day 1) is **grace**. Do not score gather on Premiere.  
> - Start-jump must stay green (TELEPORT **0** and persist >6 **0**).  
> - **Public MVP** still needs gather **and** S1.

**BE tip:** `origin/railway` @ **`4ab4f5be`**  
**Failed / closed priors:** `20260821-1` · `20260822-1` · `20260822-2` · `20260823-2` (stopped @ **3690** to deploy) — **do not resume**  
**Score sim (live):** `20260825-1` — 4000 sprint · `HEADLESS_TAB_REUSE=false` · diagnostic **off**  
**Baseline / fork:** `soul15_seed_20260224` · `copy_memories=true` · `copy_coords=false`  
**Env:** `HEADLESS_MOVEMENT_ENABLED=true` · `HEADLESS_TAB_REUSE=false` · `INTENT_PERSIST_HARD_FAIL=true` · `MAX_TILES_PER_STEP=6` · `SURVIVAL_MODE_ENABLED=true`  
**Posture:** Survival sprint. VPS `api-gateway` · HTTP `127.0.0.1:8001`. Do **not** restart the gateway while this run is live.

---

### 0. Preflight

- [x] VPS tip **`4ab4f5be`**; `api-gateway` active
- [x] `20260823-2` stopped @ 3690 / no runner
- [x] Fork + start `20260825-1`; PID **264748**; 15 personas; sprint; diagnostic **off**
- [x] Survival armed — **Premiere** · engine day **1** (grace)
- [x] `HEADLESS_TAB_REUSE=false`

**Recorded:** fork `2026-08-25T01:26:17Z` · `curr_time` start `2026-08-25 06:30` · maze `4699f26f-…` · max_steps 4000 · UUID `dfecc191-819d-4b6b-9591-d99474678a4e`

---

### 1. Early smoke (~steps 50–100)

- [ ] Tip still `4ab4f5be`; 15/15 persona-steps
- [ ] No traceback flood
- [ ] No `HEADLESS_STRICT_ABORT` storm
- [ ] Soft: bath→Park **0**

**Result:** _open_

---

### 2. Primary — stay until the event (the fix)

`20260823-2` miss class: **H2 sat-then-left**. Day-1 challenge **5 of 7** absentees had already sat. Day-2 challenge **3/3** sat ~10:23–10:44 then left. Day-2 vote Mike / Shepard sat, then walked to the pub **before 19:00**; the vote fired at 19:00.

Score **tiles** from `survival_phase_trigger.ndjson` (not action text).

| ID | Bar | `20260823-2` | `20260825-1` | Pass? |
|----|-----|--------------|--------------|-------|
| Premiere no challenge / vote | required | grace | grace | |
| Day-1 challenge sit ≥12/15 @ ~11:00 | ≥80% or fail-closed | **8/15** `deadline` · minority Hold board | **9/15** `deadline` · 5 H2 + 1 H3 | **No** |
| Day-1 vote sit ≥12/15 @ ~19:00 | ≥80% or fail-closed | **12/15** `spatial_gate` | **12/15** `spatial_gate` 19:49 · 3/3 H2 | **Yes** |
| Day-2 challenge sit ≥11/14 | ≥80% | **11/14** @ 10:52 | | |
| Day-2 vote sit ≥11/14 | ≥80% | **11/14** @ 19:00 | | |
| H2 leavers still on Hobbs at fire | the fix | 5 + 3 + Mike/Shepard left | chal 5 left; vote 3 left ~19:18 | **No** |
| Off-cafe in window still force-walked | keep | yes (text lied) | | |
| Absentees cannot win | keep | **PASS** | | |

**How to classify a miss (same as 23-2):**

- **H2** — on a Hobbs tile in the lock window, off at fire. Stay-pin should have stopped this.
- **H3** — never on a Hobbs tile. Not this tip (see §6).
- Action text “heading to Hobbs” is **not** occupancy.

**Lock windows to use when reading trails:**

| Appointment | Lock on | Fire may run | Release |
|---|---|---|---|
| Challenge | 10:00 | 80% sit or 11:00 | `challenge_resolved_date` |
| Vote | **18:00** | 80% sit from **19:00**, or 20:00 | `post_vote_date` |

- [x] Day-1 challenge occupancy + H2/H3 split — **9/15** `deadline` 11:00 step 1710. **H2:** Andrew, Diana, Ivan, Nick, Owen. **H3:** Shepard (library whole window). See §12.
- [x] Day-1 vote occupancy + H2/H3 split — **12/15** `spatial_gate` 19:49 step 2239. **H2:** Shepard, Alexis, Ivan (sat ~18:09–19:18, then left). **H3:** none.
- [ ] Day-2 challenge occupancy + H2/H3 split (if reached)
- [ ] Day-2 vote occupancy + H2/H3 split (if reached)
- [ ] No H2 leave-after-arrival at fire — **FAIL** day-1 (same class as 23-2). Product follow-up: §12, not more blocks on this runner.

**Result:** _open_

---

### 3. Release + 18:00 vote lock

| ID | Bar | `20260823-2` | `20260825-1` | Pass? |
|----|-----|--------------|--------------|-------|
| After challenge fire, they may leave (lunch / jobs) | required | lock already no-op’d (bug) | | |
| `challenge_resolved_date` stamped the fire calendar day | new | n/a | | |
| Vote lock already on at 18:00 (force-walk / pin) | new | lock started 19:00 = fire | | |
| Vote does **not** fire before 19:00 | keep | fired 19:00 | | |
| After vote fire, they may go home | keep | `post_vote_date` | | |
| Premiere unlocked | keep | no lock on grace day | | |

- [ ] Scratch / season shows `challenge_resolved_date` after first competitive challenge
- [ ] No vote `spatial_gate` before 19:00
- [ ] Trails show cafe sit/stand from 18:00, not only from 19:00
- [ ] Post-fire they walk off cafe (not held until 11:00 / 20:00)

**Result:** _open_

---

### 4. Stand if seats are full

Hobbs has **11** customer seats. A full cast is **15**. Gather already counts **any** Hobbs tile.

| ID | Bar | `20260823-2` | `20260825-1` | Pass? |
|----|-----|--------------|--------------|-------|
| Bodies on piano / counter / floor count as present | keep | yes (piano leaf used) | | |
| On cafe + dest still Hobbs → no rewrite to seating | new | n/a (lock no-op’d) | | |
| Full chairs do not push people out of Hobbs | new | n/a | | |

- [ ] Occupancy uses tiles, not “seated in a chair”
- [ ] No bounce-out because dest was forced back onto a full seat

**Result:** _open_

---

### 5. Held bars (regression only)

Must stay green. Do not treat §6 as a fail of this tip.

| Bar | `20260823-2` @ 3173 / 3632 | `20260825-1` | Pass? |
|-----|----------------------------|--------------|-------|
| TELEPORT (bar 10) | **0** | | |
| Persist start→end >6 | **0** / 46746 then 0/6426 | | |
| bath→Park | **0** | | |
| addr≠@ | **0** | | |
| Wait-wrap | **0** | | |
| Present-only / overlay | **PASS** | | |

- [ ] Start-jump still green at first competitive morning
- [ ] Start-jump still green at first competitive vote
- [ ] Overlay still names played / absent / winners / last elim

**Result:** _open_

---

### 6. Not fixed on this tip — compare worse / better

Do **not** block stay-pin ship on these. Record the same way as `20260823-2` so we can see direction.

| Issue | `20260823-2` baseline | `20260825-1` | Worse / same / better |
|---|---|---|---|
| **H3 never sit** (dest says cafe, body goes park / college / dorm) | Day-1: Shepard (park→library, min 6 then 38) + Diana (supply→college). Day-2 vote: Ivan pharmacy→dorm, never on cafe after 17:30 | Day-1 chal: **Shepard only** (library, dest library). Diana was **H2** this run (cafe 09:49–10:15 then left) | chal H3 better (1 vs 2); still open |
| **Action text lie** | Fire steps said “heading to Hobbs” while tiles were off-cafe | **Same** — every absentee fire row still “heading to Hobbs”; dest often library / pub / dorm / classroom | same |
| **Fail-closed** | Day-1 challenge **8/15** still ran a 3-person Hold board | | |
| **Piano V2** (gather leaf, not play-piano) | **53** @ 3173 (Shepard 28 + Mike 25) | | |
| **Talk loop CD** | **607** @ 3173 · Irene↔Max | | |
| **Same house voice / fourth-wall** | prior chat pass ~29% fourth-wall | | |
| **Chat fact-rot** | not re-scored | | |
| **FE 1-point home-snap** | residual open (no blink on 23-2) | | |
| **APT-N / Class P / Gap-1–2** | 528 / 48 / 17+18 @ 3173 | | |
| **Naturalness Gate** | not official GO (no paired baseline) | | |
| **Lock-In WEIGHT_UP ×2** | not reached before 4000 | | |

Chat / S1 is the next ship. Size it off this run’s CD if it moved.

---

### 7. Decision

| Question | Answer | Next |
|----------|--------|------|
| Did H2 leavers stay for the event? | Day-1 **No** (5 chal + 3 vote). Posture: §12 | next sim, not this runner |
| Challenge **and** vote ≥80% on a competitive day? | Day-1 chal **No** 9/15 · vote **Yes** 12/15 | day-2 still open |
| 18:00 vote lock on, 19:00 fire not early? | Fire 19:49 (not early). 18:00 dinner pin fights naturalness — §12 | |
| Start-jump still green? | | |
| H3 / text-lie / CD — worse, same, or better? | | §6 only |
| Public MVP? | | gather + S1 |

- [ ] Do **not** rewrite SOT §4.7 until start-jump **and** gather are green on this run
- [ ] Do **not** mix S1 on this tip
- [ ] Do **not** resume 21-1 / 22-1 / 22-2 / 23-2
- [ ] Do **not** stop `20260825-1` for a mid-run score — leave it to 4000 unless the walk loop dies

**Result:** _open_

---

### MVP ready?

**Not yet — score first.**

| Layer | `20260823-2` | This tip when green |
|---|---|---|
| Start-jump persist | Yes | must hold |
| Stay until event (H2) | **No** | this paper |
| Never-sit dest leak (H3) | No | follow-up |
| Social / S1 | No | next ship |

**Call:** Keep **`4ab4f5be`**. Leave **`20260825-1`** running. Score gather from engine day **2**. Compare §6 to 23-2; do not treat those rows as this tip’s fail.

---

### 8. Follow-up — test start: skip Premiere

Do **not** build this on the live `20260825-1` runner. Next test sim only.

- [ ] **Test-only start:** first clock is **engine day 2 at 05:55** (or **06:00**). Survival Directive at 06:00. Not 05:55 on calendar day 1 — that is still Premiere; grace lasts the whole first day.
- Isolated start flag only (same shape as diagnostic). Omit = normal Premiere sim. Not `.env.local`. Not a DB/scratch bit that the next start can inherit.
- Live / production start ignores or refuses it.
- Keeps full competitive days (chat / afternoon / night still run). Skips only the ~20 h grace day (~15–20 h wall).

**Trap:** day-1 06:00 does **not** turn Survival on.

---

### 9. Follow-up — Supabase RLS on public tables

Do **not** apply while `20260825-1` is live. After score.

Advisor ERROR `0013_rls_disabled_in_public` on live `double.*` (anon can hit these via PostgREST). Repo already documents Pattern A; this project did not get the `ENABLE`.

Tables: `day_highlights` · `persona_day_snapshots` · `survival_agent_state` · `survival_season_state` · `cohort_trailer_cast` · `cohort_trailer_config` · `trailer_asset` · `video_narration_cache` · `dbl_memory` · `maze_bounds` · `address_translations` · `sim_cost_daily`

- [ ] One migration: `ENABLE ROW LEVEL SECURITY` on those 12. **No** new policies (service_role bypass; browser stays on existing RPCs / gateway).
- [ ] Re-run advisor; smoke memory write + survival persist + play/highlights.
- Do not add “allow all” policies to silence the lint.

---

### 10. Follow-up — Supabase advisor WARNs (after score)

Source: `Supabase Performance Security Lints (kkjhsozszgoorwehhsdg).csv` — **236 WARN**, all SECURITY. Do **not** apply while `20260825-1` is live. Same clone-drift as §9: repo already has the RPC lockdown; this project did not get it.

| Lint | Count | Verdict |
|---|---|---|
| Anon/auth can EXECUTE SECURITY DEFINER RPCs | 108 + 108 | **Do** — real hole (fork, `dbl_raw_query`, memory/scratch/survival writes) |
| RLS policy `USING (true)` ALL | 16 | **Do** a subset; rest defer |
| Public bucket listing | 2 | Skip — maps/sprites are meant public |
| `vector` extension in `public` | 1 | Skip — moving pgvector is high risk, low gain |
| Leaked-password protection off | 1 | Optional dashboard toggle |

**Do**

- [ ] **RPC lockdown:** re-apply `20260609130000` (idempotent). Revoke anon/auth EXECUTE on every definer RPC, then re-grant only the **13** viewer reads (maze + playback). Engine/gateway stay on service_role. Smoke: play map still loads.
- [ ] **Open table policies (anon / no-role):** drop or narrow `asset_assignments_all` (admin UI must write via gateway first) and waitlist **UPDATE** `USING (true)` (keep landing **INSERT**).
- [ ] **Lint-only cleanup:** drop redundant `TO service_role USING (true)` policies (`carried_objects_service`, maze instance `*_service_all`, scratch/profile/sprite `*_service_role_all`, `sim_persona_state_service_all`). Bypass already exists.

**Defer (auth onboarding)** — `persona_profile_*_authenticated_all`, `persona_sprite_assets_authenticated_all`, `user_chat_*` `USING (true)`. Named “owner” but any logged-in user can read/write all rows. No end-user auth yet.

**Skip** — `vector` in public; listing on `shared-assets` / `simulation-maps`; HIBP passwords (dashboard, anytime).

Do not grant “allow all” to silence remaining WARNs on the 13 allowlisted RPCs — those WARNs are expected.

---

### 11. Follow-up — Supabase disk 8GB → 12GB (optimize, do not buy more)

Email: Pro auto-expand at 90%. **Already on 12GB** (you are already paying the extra). Next jump is **18GB**. Do **not** resize while `20260825-1` is live. Prefer delete/vacuum over another expand.

Live counts (read-only, this project): **57** sims · **421k** memories + **421k** embeddings (768-d, stored twice) · **1.04M** `personas_coords` (one row per persona per step, plus `movement` jsonb) · **1.14M** `grid_deltas`. Maze tiles are small (14k). Old June–July OpenRouter test sims are still in the pile.

- [ ] After score: list sims to **keep** (baselines + current score + any trailer source). Delete the rest (cascade coords, deltas, memories). Do not delete `20260825-1` until scored.
- [ ] `VACUUM` (not `VACUUM FULL` unless you accept a lock). Re-check disk in the dashboard. Ask support to **shrink** only if usage stays well under 8GB — auto-expand often does not shrink by itself.
- [ ] Later (not this score): stop double-storing 768-d vectors on both `dbl_memory` and `dbl_embedding`; for throwaway tests consider `copy_memories=false`.

Do **not** manually expand “just in case.” That spends the 24h resize budget and locks in a higher bill.

---

### 12. Follow-up — gather vs naturalness (after this score)

Founder lock: **naturalness first.** Tolerate some absentees if they look like life. Do **not** add more hard blocks on `20260825-1`. Do not dest-rewrite never-sits. Do not fail-closed to force a full room.

Day-1 trails (cafe **label** tiles, bbox 72–83 × 19–30; text “heading to Hobbs” is **not** occupancy):

**Challenge 11:00 · 9/15 FAIL `deadline`**

| Who | Class | Before | At fire (body / dest) | After |
|---|---|---|---|---|
| Shepard | **H3** | Library all morning | Library / **library** | 11:15 pub “secret card”; **11:35 first cafe**; 12:00 lunch |
| Andrew | **H2** | Co-living breakfast | Brief cafe 09:39–09:45; street / dest **cafe** (walking back) | 11:15 cafe; 11:30 co-living “card round”; 12:00 lunch |
| Diana | **H2** | Dorm breakfast; 09:30 library “rules” | Cafe 09:49–10:15 then dorm; fire **library / library** | Pub hold/fold |
| Ivan | **H2** | Dorm then pharmacy | Cafe 10:05–10:40 “waiting”; fire **dorm / dorm** | 11:15 dorm hold/fold; 12:00 lunch cafe |
| Nick | **H2** | Home → college lecture | Cafe 10:27–10:54; left 10:55; fire **pub / pub** | Pub hold/fold |
| Owen | **H2** | Apartment → market shift | Cafe 10:05–10:28 then college; fire **classroom / classroom** | **11:15 back at cafe** (too late) |

**Vote 19:49 · 12/15 PASS `spatial_gate`** — 3/3 **H2**, no H3. All three sat ~18:09–19:18 (dinner), left, fire 31 min later. Shepard + Ivan dest **cafe** (walking back). Alexis dest **classroom**. Back at cafe ~20:04–20:19 (Ivan “casting vote” after fire).

**Read:** Vote miss is life (waited, dinner done, 12th not there yet, left; 12 stayed). Challenge miss is early sit + long wait until 11:00, then daily plan won. Fake parts are the **heading-to-Hobbs lie** and **hold/fold / vote verbs off-site**.

**Posture (next ship, not this runner):** appointment with a cost, not a curfew. 80% stays the TV target. Present-only stays. Missing is allowed. Stay-pin scores as **“the room does not empty after the round starts”**, not **“nobody is ever absent.”**

**Tolerate (do not chase):**
- Job / home skip when dest **and** text match the job (Shepard library)
- Late walker whose dest is already cafe
- Vote dinner-leave when 12 others stayed

**Do not treat as life:**
- “Heading to Hobbs” for 45+ min while dest is library / pub / dorm
- Secret-card / hold-fold / vote lines at the pub or dorm
- 1–2 hour sit-still through breakfast or dinner

- [ ] **No new blocks** — no dest-rewrite for H3 never-sits; no fail-closed if sit < 80%; no longer pins; no sleep-wake hunts. Leave `20260825-1` as-is.
- [ ] **Short call window** — hard pin only the last ~20 min, or from the moment 12 are already seated. Sit / stand / talk / piano still allowed. Walk to class or pub is not.
- [ ] **Vote lock at 19:00, not 18:00** — 18:00–19:00 is dinner. 18:00 pin is what made them stand up at 19:18.
- [ ] **Fire when the room is ready** — challenge may already fire on 12 seated. Use that. Do not hold early arrivals until 11:00 and then count them absent.
- [ ] **Honest text** — if dest is not cafe, do not write “heading to Hobbs.” Librarian at library reads as librarian.
- [ ] **No ritual off-site** — leaving is fine. Challenge / vote verbs only on Hobbs tiles.
- [ ] **Keep cost, allow skip** — present-only scoring; skip = you do not play that round; no invented cards.
- [ ] Re-score stay-pin on the **next** sim against this posture (room holds after the round starts + 80% as target, not as a freeze). Not a mid-run patch on `20260825-1`.
