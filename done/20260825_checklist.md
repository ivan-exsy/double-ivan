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
**Score sim (done):** `20260825-1` — 4000 completed `2026-08-27T07:47Z` · `HEADLESS_TAB_REUSE=false` · diagnostic **off** · engine day **4** 01:10 · Survival Day 3 SLEEP  
**Baseline / fork:** `soul15_seed_20260224` · `copy_memories=true` · `copy_coords=false`  
**Env:** `HEADLESS_MOVEMENT_ENABLED=true` · `HEADLESS_TAB_REUSE=false` · `INTENT_PERSIST_HARD_FAIL=true` · `MAX_TILES_PER_STEP=6` · `SURVIVAL_MODE_ENABLED=true`  
**Posture:** Survival sprint completed. VPS `api-gateway` · HTTP `127.0.0.1:8001`. Runner gone. Do not resume this sim.

> **Verdict @ 4000 (`2026-08-27`):** Stay-pin **FAIL**. Start-jump **PASS**. Public MVP **NO**. Do not ship gather. Do not patch this run. Do not rewrite SOT §4.7.
>
> | Layer | Call |
> |---|---|
> | Stay until the event | **FAIL** — pin walked people in; did not keep them |
> | Votes ≥80% | **PASS** — 12/15, 11/14 (dinner-leave; room still full enough) |
> | Challenges ≥80% | **FAIL** — 9/15, then **6/14** (worse than 23-2 day-2 11/14) |
> | Start-jump | **PASS** — TELEPORT **0**, persist >6 **0/58060** |
> | Present-only / overlay | **PASS** |
> | Stand if seats full | **PASS** |
> | Lock timing / release | **PASS** — 18:00 pin fills by 18:30; dinner then wins. Do not pin harder. |
>
> Vs `20260823-2`: votes same class. Day-2 challenge **worse**. H3 **better**. Heading-to-Hobbs lie unchanged. Next sim: §12 only.

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

- [x] Tip still `4ab4f5be`; 15/15 persona-steps through 500 (7500 coords)
- [x] No traceback flood — `journalctl -u api-gateway` since Aug 25 **0** (no runner stdout file left)
- [x] No `HEADLESS_STRICT_ABORT` storm — journal **0**
- [x] Soft: bath→Park **0** / 58060

**Result:** **PASS**

---

### 2. Primary — stay until the event (the fix)

`20260823-2` miss class: **H2 sat-then-left**. Day-1 challenge **5 of 7** absentees had already sat. Day-2 challenge **3/3** sat ~10:23–10:44 then left. Day-2 vote Mike / Shepard sat, then walked to the pub **before 19:00**; the vote fired at 19:00.

Score **tiles** from `survival_phase_trigger.ndjson` (not action text).

| ID | Bar | `20260823-2` | `20260825-1` | Pass? |
|----|-----|--------------|--------------|-------|
| Premiere no challenge / vote | required | grace | grace | **Yes** |
| Day-1 challenge sit ≥12/15 @ ~11:00 | ≥80% or fail-closed | **8/15** `deadline` · minority Hold board | **9/15** `deadline` · 5 H2 + 1 H3 | **No** |
| Day-1 vote sit ≥12/15 @ ~19:00 | ≥80% or fail-closed | **12/15** `spatial_gate` | **12/15** `spatial_gate` 19:49 · 3/3 H2 | **Yes** |
| Day-2 challenge sit ≥11/14 | ≥80% | **11/14** @ 10:52 | **6/14** `deadline` 11:00 step 3150 · 8/8 H2 | **No** (worse) |
| Day-2 vote sit ≥11/14 | ≥80% | **11/14** @ 19:00 | **11/14** `spatial_gate` 19:48 step 3678 · 3/3 H2 | **Yes** |
| H2 leavers still on Hobbs at fire | the fix | 5 + 3 + Mike/Shepard left | chal 5+8 left; vote 3+3 left ~19:02–19:18 | **No** |
| Off-cafe in window still force-walked | keep | yes (text lied) | yes (text still lied) | keep |
| Absentees cannot win | keep | **PASS** | **PASS** (Hold + Silent Pact winners all sat) | **Yes** |

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
- [x] Day-2 challenge occupancy + H2/H3 split — **6/14** `deadline` 11:00 step 3150. **H2 all 8:** Alexis, Dean, Diana, Irene, Ivan, Nick, Owen, Vincent. **H3:** none. See §12.
- [x] Day-2 vote occupancy + H2/H3 split — **11/14** `spatial_gate` 19:48 step 3678. **H2:** Shepard, Andrew, Dean (dinner sit then left ~19:02–19:17). **H3:** none. Shepard was then voted out while absent.
- [x] No H2 leave-after-arrival at fire — **FAIL** both competitive days (same class as 23-2). Product follow-up: §12. Runner already finished 4000.

**Result:** **FAIL stay-pin.** Votes hit 80%. Both challenges missed (9/15, 6/14) and still ran a board. The pin walked people in and did not keep them.

---

### 3. Release + 18:00 vote lock

| ID | Bar | `20260823-2` | `20260825-1` | Pass? |
|----|-----|--------------|--------------|-------|
| After challenge fire, they may leave (lunch / jobs) | required | lock already no-op’d (bug) | day-1 +5 min 8/15 still on cafe; +60 min lunch 11 | **Yes** |
| `challenge_resolved_date` stamped the fire calendar day | new | n/a | stamped; living rows **2026-08-28** after last fire **Aug 27** (midnight restamp) | mixed |
| Vote lock already on at 18:00 (force-walk / pin) | new | lock started 19:00 = fire | 18:00→18:30 bbox **6→14** then **7→11** | **Yes** |
| Vote does **not** fire before 19:00 | keep | fired 19:00 | **19:49** and **19:48** | **Yes** |
| After vote fire, they may go home | keep | `post_vote_date` | living `post_vote_date=2026-08-27` | **Yes** |
| Premiere unlocked | keep | no lock on grace day | no NDJSON on engine day 1 | **Yes** |

- [x] Scratch / season shows `challenge_resolved_date` after first competitive challenge — yes; living stamp is next calendar day (see mixed bar)
- [x] No vote `spatial_gate` before 19:00
- [x] Trails show cafe sit/stand from 18:00, not only from 19:00 — lock pulled a full room by 18:30, then dinner-leave
- [x] Post-fire they walk off cafe (not held until 11:00 / 20:00)

**Result:** **PASS** lock timing / release. 18:00 dinner pin still fights naturalness (§12). Stamp restamp is a note, not this tip’s ship gate.

---

### 4. Stand if seats are full

Hobbs has **11** customer seats. A full cast is **15**. Gather already counts **any** Hobbs tile.

| ID | Bar | `20260823-2` | `20260825-1` | Pass? |
|----|-----|--------------|--------------|-------|
| Bodies on piano / counter / floor count as present | keep | yes (piano leaf used) | Shepard day-2 chal on `:piano`; Alexis day-2 vote on piano; Olivia day-1 vote behind counter | **Yes** |
| On cafe + dest still Hobbs → no rewrite to seating | new | n/a (lock no-op’d) | sitters stayed on cafe tiles (seating / piano / counter) | **Yes** |
| Full chairs do not push people out of Hobbs | new | n/a | 15 then 14 bodies; overflow used piano / counter; leavers were dest-leave not seat-bounce | **Yes** |

- [x] Occupancy uses tiles, not “seated in a chair”
- [x] No bounce-out because dest was forced back onto a full seat

**Result:** **PASS**

---

### 5. Held bars (regression only)

Must stay green. Do not treat §6 as a fail of this tip.

| Bar | `20260823-2` @ 3173 / 3632 | `20260825-1` | Pass? |
|-----|----------------------------|--------------|-------|
| TELEPORT (bar 10) | **0** | **0** / 58060 | **Yes** |
| Persist start→end >6 | **0** / 46746 then 0/6426 | **0** / 58060 (max **6**) | **Yes** |
| bath→Park | **0** | **0** | **Yes** |
| addr≠@ | **0** | **0** | **Yes** |
| Wait-wrap | **0** | **0** | **Yes** |
| Present-only / overlay | **PASS** | **PASS** — LLM overlay “you played” / “you were absent” / “Last eliminated” all present; winners sat | **Yes** |

- [x] Start-jump still green at first competitive morning
- [x] Start-jump still green at first competitive vote
- [x] Overlay still names played / absent / winners / last elim — prompt injections **519 / 519 / 559**; Shepard + Butcher frozen overlays name winners + public board

**Result:** **PASS** held bars (start-jump still green at 4000)

---

### 6. Not fixed on this tip — compare worse / better

Do **not** block stay-pin ship on these. Record the same way as `20260823-2` so we can see direction.

| Issue | `20260823-2` baseline | `20260825-1` | Worse / same / better |
|---|---|---|---|
| **H3 never sit** (dest says cafe, body goes park / college / dorm) | Day-1: Shepard (park→library, min 6 then 38) + Diana (supply→college). Day-2 vote: Ivan pharmacy→dorm, never on cafe after 17:30 | Day-1 chal: **Shepard only**. Day-2 chal **0 H3**. Day-2 vote **0 H3** (Ivan sat) | **better** |
| **Action text lie** | Fire steps said “heading to Hobbs” while tiles were off-cafe | Day-1 absentees still “heading to Hobbs”. Day-2 chal mixed: Alexis dest=library (honest walk); Dean/Irene/Nick/Owen **challenge verbs off-site**; Diana street “heading to Hobbs” | same / slightly mixed |
| **Fail-closed** | Day-1 challenge **8/15** still ran a 3-person Hold board | Day-1 **9/15** ran **4-person** Hold (Olivia won). Day-2 **6/14** still ran Silent Pact | **worse** (room smaller, board still ran) |
| **Piano V2** (gather leaf, not play-piano) | **53** @ 3173 (Shepard 28 + Mike 25) | piano leaf **199** · play-piano **182** (Vincent 81, Alexis 33, Mike 25, …). In-cafe piano is allowed | worse count; not a leave |
| **Talk loop CD** | **607** @ 3173 · Irene↔Max | not re-scored at 4000 | unverified |
| **Same house voice / fourth-wall** | prior chat pass ~29% fourth-wall | not re-scored | unverified |
| **Chat fact-rot** | not re-scored | not re-scored | unverified |
| **FE 1-point home-snap** | residual open (no blink on 23-2) | persist still 0; FE snap not re-scored | unverified |
| **APT-N / Class P / Gap-1–2** | 528 / 48 / 17+18 @ 3173 | APT-N **5523** / 4000 (soft; more apartment hours). Class P / Gap not re-scored | APT-N worse (soft) |
| **Naturalness Gate** | not official GO (no paired baseline) | not official GO | same |
| **Lock-In WEIGHT_UP ×2** | not reached before 4000 | lifestyle already **Alliance Lock-In** on Day 3; sim ended **01:10** before 11:00. Silent Pact leftovers: Andrew/Mike `WEIGHT_UP` **1.5**, Max transferred shield to Olivia | not reached |

Chat / S1 is the next ship. Size it off this run’s CD if it moved.

---

### 7. Decision

| Question | Answer | Next |
|----------|--------|------|
| Did H2 leavers stay for the event? | **No** — day-1 5+3; day-2 **8+3**. Pin walked them in, did not keep them | §12 short window on the **next** sim |
| Challenge **and** vote ≥80% on a competitive day? | **No.** Votes **Yes** (12/15, 11/14). Challenges **9/15** and **6/14** | gather not green |
| 18:00 vote lock on, 19:00 fire not early? | **Yes.** Fires 19:49 / 19:48. 18:00–18:30 fills the room, then dinner-leave | §12: move lock to 19:00 |
| Start-jump still green? | **Yes** — TELEPORT **0**, persist >6 **0/58060** | keep BE reject; still do not rewrite SOT §4.7 until gather is also green |
| H3 / text-lie / CD — worse, same, or better? | H3 **better**. Text-lie **same**. Fail-closed **worse**. CD not re-scored | §6 only |
| Public MVP? | **No** | gather + S1 |

- [x] Do **not** rewrite SOT §4.7 until start-jump **and** gather are green — start-jump green on this run, gather **not**. Founder 2026-08-27: rewrite §4.7 **after** a successful next score, not on this paper.
- [x] Do **not** mix S1 on this tip
- [x] Do **not** resume 21-1 / 22-1 / 22-2 / 23-2
- [x] Do **not** stop `20260825-1` for a mid-run score — left to 4000; completed `2026-08-27T07:47Z`

**Result:** **Start-jump YES / stay-pin NO / Public MVP NO.**

Stay-pin failed. Start-jump held. Do not ship gather. Do not patch this run. The 80% miss is not “they never came” — almost every absentee sat, then left. Challenge leavers left ~10:06–10:54; board still fired at 11:00 (4-person Hold, then Silent Pact with 6). Vote leavers left ~19:02–19:18 after dinner; eleven stayed — that is life. Shepard was voted out while absent — that cost is correct. 18:00 vote lock filled the room by 18:30, then dinner won — do not pin harder.

**Do not:** call stay-pin green · rewrite SOT §4.7 before a green next run · add longer pins / dest-rewrites / fail-closed · resume this sim.

**Founder 2026-08-27:** H3 dest-rewrite, fail-closed, and longer pins are **out**. They are a curfew band-aid: they hide the real miss (early sit → long wait → daily plan wins; text lies off-site) by forcing a full room. Naturalness first. **Do not** fire the challenge early when 12 are seated — it fires at the **declared time** (11:00). Short ~30 min walk-in + pin until that clock; vote lock **19:00**; honest text.

**Next:** §12 on the **next** sim only — ~30 min walk-in, challenge at declared 11:00 (not spatial-early), vote lock at **19:00**, honest text, no challenge/vote lines off-site, skips allowed. Ops §8–11 now unblocked; they are not gather. After that run is **green** on start-jump **and** gather, update SOT §4.7 (25 → 6). Not before.

---

### MVP ready?

**No.**

| Layer | `20260823-2` | `20260825-1` @ 4000 |
|---|---|---|
| Start-jump persist | Yes | **Yes** |
| Stay until event (H2) | **No** | **No** — day-2 chal **worse** (6/14 vs 11/14) |
| Never-sit dest leak (H3) | No | **better**, still open |
| Social / S1 | No | No (CD not re-scored) |

**Call:** Keep the start-jump reject. Do **not** call stay-pin green. Do **not** patch this finished runner. Next sim follows §12 (~30 min walk-in, challenge at declared 11:00, vote lock 19:00, honest text). `4ab4f5be` can stay on `railway` as persist safety; it did not keep the room. Ops §8–11 unblocked after this score — not gather.

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

Founder lock: **naturalness first.** Tolerate some absentees if they look like life. Do **not** add more hard blocks on `20260825-1` (already finished).

**Out — band-aids, not the core (founder 2026-08-27):** do **not** dest-rewrite H3 never-sits, fail-closed if sit < 80%, or lengthen the pin. Those force a full room and mask the real miss: people sit, wait through breakfast, then the daily plan wins; action text still lies off-site. A librarian at the library is life. A yanked body and a frozen hour are not.

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

Day-2 (engine day 3) — scored @ 4000 from NDJSON + tiles:

**Challenge 11:00 · 6/14 FAIL `deadline` step 3150** — 8/8 **H2**, no H3. Sitters at fire: Shepard (piano), Andrew, Max, Mike, Olivia, Vince.

| Who | Class | Cafe window | At fire (body / dest) |
|---|---|---|---|
| Alexis | **H2** | 10:10–10:17 | library / walking to college |
| Dean | **H2** | 10:06–10:20 | classroom / **listening to challenge instructions** |
| Diana | **H2** | 10:24–10:34 | street 82,31 / waiting (heading to Hobbs) |
| Irene | **H2** | 09:57–10:17 | classroom / **listening to challenge briefing** (heading to Hobbs) |
| Ivan | **H2** | 10:05–10:18 | street / partner strategy (heading to college) |
| Nick | **H2** | 09:13–10:06 | pub / **listening to challenge instructions** (heading to pub) |
| Owen | **H2** | 08:39–08:48 (pre-lock) | classroom / **reading challenge instructions** |
| Vincent | **H2** | 08:23–08:43 (pre-lock) | apartment blackboard / sketching partner strategies |

**Vote 19:48 · 11/14 PASS `spatial_gate` step 3678** — 3/3 **H2**, no H3. Shepard / Andrew / Dean sat ~17:08–19:17 (dinner), left ~19:02–19:17, fire ~30 min later. Shepard at co-living **bed** (then voted out while absent). Andrew street dest cafe. Dean classroom dest cafe.

**Read:** Vote miss is still dinner-leave with 11 staying — tolerate. Day-2 challenge is the same early-sit + wait + daily plan, **worse room** (6 vs 11). Fake parts unchanged: heading-to-Hobbs lie, challenge verbs at college / pub. Stay-pin did not change the class.

**Posture (next ship, not this runner):** appointment with a cost, not a curfew. Challenge fires at **11:00**, vote at **20:00**, not when the room first hits 12. 80% at that clock is the TV target. Present-only stays. Missing is allowed. Short pin covers the last ~30 min so the room does not empty *before* the clock. Not “nobody is ever absent.”

**Tolerate (do not chase):**
- Job / home skip when dest **and** text match the job (Shepard library; Alexis library walk)
- Late walker whose dest is already cafe
- Vote dinner-leave when 12 (or 11/14) others stayed

**Do not treat as life:**
- “Heading to Hobbs” for 45+ min while dest is library / pub / dorm
- Secret-card / hold-fold / vote / **challenge-instruction** lines at the pub, dorm, or classroom
- 1–2 hour sit-still through breakfast or dinner

- [x] **No new blocks** on `20260825-1` — runner finished 4000 as-is
- [ ] **Short call window** — walk-in + pin only the last ~30 min (challenge **10:30→11:00**, vote **19:30→20:00**). Sit / stand / talk / piano still allowed. Walk to class or pub is not. Not a longer morning or dinner hold.
- [ ] **Vote lock 19:30–20:00** — 18:00–19:30 is dinner. Same 30-min call as challenge. Confirmed on 25-1: 18:00 pin filled the room by 18:30; leavers stood up ~19:02–19:18.
- [ ] **Challenge and vote at declared time** — fire at **11:00** and **20:00**, not when 12 are seated. Founder 2026-08-27: do not pull either appointment forward. Occupancy is scored at those clocks.
- [ ] **Honest text** — if dest is not cafe, do not write “heading to Hobbs.” Librarian at library reads as librarian.
- [ ] **No ritual off-site** — leaving is fine. Challenge / vote verbs only on Hobbs tiles. Day-2 still had “listening to challenge instructions” at college and pub.
- [ ] **Keep cost, allow skip** — present-only scoring; skip = you do not play that round; no invented cards. Held on this run.
- [ ] Re-score on the **next** sim: room holds through the 30-min call until declared **11:00** and **20:00**; 80% is the target, not a freeze. Not a patch on `20260825-1`.

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

**Posture (next ship, not this runner):** appointment with a cost, not a curfew. Challenge fires at **11:00**, vote at **20:00**, not when the room first hits 12. 80% at that clock is the TV target. Present-only stays. Missing is allowed. Short pin covers the last ~30 min so the room does not empty *before* the clock. Not “nobody is ever absent.”

**Tolerate (do not chase):**
- Job / home skip when dest **and** text match the job (Shepard library)
- Late walker whose dest is already cafe
- Vote dinner-leave when 12 others stayed

**Do not treat as life:**
- “Heading to Hobbs” for 45+ min while dest is library / pub / dorm
- Secret-card / hold-fold / vote lines at the pub or dorm
- 1–2 hour sit-still through breakfast or dinner

- [x] **No new blocks** — no dest-rewrite for H3 never-sits; no fail-closed if sit < 80%; no longer pins; no sleep-wake hunts. Leave `20260825-1` as-is. Founder 2026-08-27: these stay **out** (band-aid / curfew).
- [ ] **Short call window** — walk-in + pin only the last ~30 min (challenge **10:30→11:00**, vote **19:30→20:00**). Sit / stand / talk / piano still allowed. Walk to class or pub is not. Not a longer morning or dinner hold.
- [ ] **Vote lock 19:30–20:00** — 18:00–19:30 is dinner. Same 30-min call as challenge. 18:00 pin is what made them stand up at 19:18.
- [ ] **Challenge and vote at declared time** — fire at **11:00** and **20:00**, not when 12 are seated. Founder 2026-08-27: do not pull either appointment forward. Occupancy is scored at those clocks.
- [ ] **Honest text** — if dest is not cafe, do not write “heading to Hobbs.” Librarian at library reads as librarian.
- [ ] **No ritual off-site** — leaving is fine. Challenge / vote verbs only on Hobbs tiles.
- [ ] **Keep cost, allow skip** — present-only scoring; skip = you do not play that round; no invented cards.
- [ ] Re-score on the **next** sim: room holds through the 30-min call until declared **11:00** and **20:00**; 80% is the target, not a freeze. Not a mid-run patch on `20260825-1`.
