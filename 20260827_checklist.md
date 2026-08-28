# 20260827 — Checklist: Pass 1 skip-Premiere score

**Purpose:** Score Pass 1 on a **new** fork with Premiere skipped. Challenge occupancy at **11:00**, vote at **20:00**. Do not resume `20260825-1`.

**Prior:** `20260825-1` stay-pin **FAIL** (challenge 9/15 then 6/14). Start-jump **PASS**. Tip then `4ab4f5be`.

**This tip:** `origin/railway` @ **`266aa54f`** (Pass 1: 30-min lock both appointments; fire at 11:00 / 20:00; honest dest text; thin town talk; skip-Premiere)

**Score sim:** `20260827-1` · `HEADLESS_TAB_REUSE=false` · diagnostic **off** · skip-Premiere **on**
**Baseline / fork:** `soul15_seed_20260224` · `copy_memories=true` · `copy_coords=false`
**Env:** `HEADLESS_MOVEMENT_ENABLED=true` · `HEADLESS_TAB_REUSE=false` · `INTENT_PERSIST_HARD_FAIL=true` · `MAX_TILES_PER_STEP=6` · `SURVIVAL_MODE_ENABLED=true`

**Score at tiles, not labels.** Premiere is off this run (engine jumped day 1 → day 2 05:55).

---

### 0. Preflight

- [x] VPS tip **`266aa54f`**; `api-gateway` active
- [x] No prior runner; `20260825-1` completed — not resumed
- [x] Fork + start `20260827-1`; PID **533153**; 15 personas; sprint; diagnostic **off**; `skip_premiere: true`
- [x] Engine clock jumped `2026-08-27 06:30` → **`2026-08-28 05:55`** (day 2); `start_date` unchanged; step **0**
- [x] `HEADLESS_TAB_REUSE=false`

**Recorded:** fork `2026-08-27T19:30:23Z` · maze `f61c750d-…` · max_steps 4000 · UUID `a31712bf-8b45-46fa-8fd8-56ba7c3d6058`

API now matches the skip: engine day **2**, label **Survival Season Day 1**, `curr_time` **2026-08-28 12:12**.

---

### Mid-run @ step ~377 (~12:12 day 2) — 2026-08-27 19:33Z wall? scored 23:36Z

Runner PID **533153** still up (~4 h). 15/15 people every step. Traceback **0**. Headless abort **0**. TELEPORT log **0**.

| ID | Bar | This run | Call |
|----|-----|----------|------|
| Skip-Premiere | day 2 05:55, start_date unchanged | API day 2 / Survival Day 1; start_date Aug 27 | **PASS** |
| Challenge sit ≥12/15 @ **11:00** | ≥80% tiles | **3/15** `deadline` step **305** | **FAIL** |
| Vote sit ≥12/15 @ **20:00** | ≥80% tiles | not yet (clock 12:12) | wait |
| Start-jump | TELEPORT 0, persist >6 = 0 | **0/5700** over-6, max 6 | **PASS so far** |
| Honest dest text | no Hobbs/ritual verbs off-cafe | **534** off-cafe “heading to Hobbs…” lies; 11/12 absentees still said it at fire | **FAIL so far** |
| Spoken fourth wall | no simulation / Doubland / backend in talk | **0/2678** utterances | **PASS so far** |
| Sofa / re-greet | one sofa = one talk | not scored yet | wait |

**Challenge 11:00 tiles:** on cafe: Alex Shepard, Dean Sanford, Irene Dove. **H2** (sat, then left): Alexis, Andrew, Diana, Max, Olivia, Vince Vale, Vincent Slater (**7**). **H3** (never sat): Alex Butcher, Ivan, Mike, Nick, Owen (**5**). At 10:30 lock only **4** were on cafe. Same miss class as 25-1: they sit, wait, walk to college/pub/pharmacy; the board still ran.

**Fourth wall caveat:** spoken lines are clean. Identity overlay / self-check still says “premiere day in Doubland” (seed text). That is not the batch-chat template.

**Do not stop the runner.** Vote at 20:00 is the remaining occupancy gate.

**Investigation:** evidence + RCA handoff → `20260827_handoff_challenge_miss.md`. H2/H3 above is provisional (scorer window started 09:30).

**Verify pull (2026-08-28):** `20260828_verdict_authority_hypothesis.md` — day-1 vote **8/15** at 20:00 (12 at 20:15); day-2 challenge **6/14** at 11:00 (10 at 11:05). H-B confirmed as cause.

---

### Still waiting

- Day-2 vote occupancy @ **20:00** (step 2285)
- Sofa persist / re-greet mill
- Overlay / absentees-cannot-win after tonight’s elim
