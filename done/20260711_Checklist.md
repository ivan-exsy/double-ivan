# 2026-07-13 — Verify Survival catalog on `20260711-1`

Proof sim: **`20260711-1`** (post challenge-persist fix `6bb60115`).  
(Checklist originally said `20260710`; that run was aborted — this is the scored proof.)

## Closed earlier

1. Locked Survival challenge catalog + random rotation (new sims).
2. Cast digest challenge card from season `challenge_results`.
3. Challenge **persist-after-resolve** (so mid-flight / end digests see results).
4. Stop-API fix (undefined `parameters`).
5. Schedule-integrity fix (Dean midnight `IndexError`) — code on VPS.

## Deployed (VPS)

- Tip: **`83f9913e`** on `railway` (schedule integrity). Prior proof tip was `6bb60115`.
- Proof run (pre-fix): `20260711-1`, sprint + diagnostic, requested 2600 steps — stopped @ 2489 on Dean midnight crash.
- **Post-fix deploy (2026-07-13):** `git pull` → `83f9913e`; `sudo systemctl restart api-gateway.service` → **active**. Ready for a new midnight re-proof sim (not started yet).

---

## A. Verify on `20260711-1` — scored 2026-07-13

Engine day 2 = Survival day 1 for digests/trailers.

- [x] **Sim healthy** — ran through grace + Survival day 1 + into Survival day 2 night; `live_mode: false`. Stopped @ step **2489** (see stop note below).
- [x] **Locked pool only** — day-1 challenge = **`roll_for_shield`** (locked catalog).
- [x] **No Limited Immunity / Reputation Tax** — not scheduled.
- [x] **Random + used ids** — `used_challenge_ids=['roll_for_shield']`; only one challenge in window (repeat N/A).
- [x] **Catalog version** — `challenge_catalog_version=locked_v1`.
- [x] **Digest challenge card** — **PASS**
  ```
  Challenge: Roll For Shield — winners: Diana Ogden
  ```
  JSON: type `roll_for_shield`, winners `[Diana Ogden]`, claimants `15`.
- [x] **Persist fix** — season disk had full `challenge_results` (name, winners, public_board) before night-only flush would have been required.
- [x] **Elimination path** — Ivan Pitts booted Survival day 1 (9 votes); 14 remain.
- [x] **Legacy still fine** — prior `20260709-1` Limited Immunity re-score unchanged.

### Stop @ 2490 (not 2600) — RCA + fix (post-fix state)

| Signal | Reading |
|--------|---------|
| Requested | 2600 steps |
| Actual | **2490** (= `06:30` Jul 11 → `00:00` Jul 13 exactly) |
| Season status | still **`running`** (not `completed`) |
| Winner / ended_day | **None** |
| Phase at stop | **NIGHT**, `current_day=2` |
| `COMPLETED.json` | **missing** |

**Root cause (confirmed):** not Survival auto-stop / stall-safety / last-standing. Process crashed on **Dean Sanford** at **23:59** with `IndexError: list index out of range` while reading the next hour of his day plan. After the vote, his plan was short of a full day (sleep tail missing), so looking ahead near midnight walked off the end of the list.

**Fix:** keep every day plan exactly 24h via a sleep pad/trim; never wipe a plan slot with an empty breakdown; clamp plan-index reads; do not force a replan while someone is already sleeping. **On VPS @ `83f9913e` + api-gateway restarted.** Catalog/digest PASS above still stands. **Midnight re-proof sim still pending.**

### Challenge story (Survival day 1)

- **Roll for the Shield** — Diana Ogden won (kept a 6; several others risked and tied/lost).
- Full public board persisted (dice + keep/risk) — trailer-legible.

---

## B. Ops hygiene

- [x] **VPS diagnostic cleanup** — done 2026-07-13: trimmed `movement`+`environment` on `20260709-1` (~1.1G→725M) and `20260711-1` (~1.1G→731M). Disk ~39% used / 54G free — not tight. Optional later: same trim on other ~1G finished diagnostics (`20260708-mvp-a`, `20260703-or-2`, `20260705-or-smoke`, …).
- [x] **OpenRouter key rotate** — done 2026-07-13 (between runs; do not restart API mid-sim).
- [x] **24h smoke** — `20260711-1` progressed and finished scoring window.
- [x] **Ship schedule-integrity tip** — VPS @ `83f9913e`; api-gateway restarted / active.
- [ ] **Midnight re-proof** — new sim (sprint + diagnostic, ~2600 steps); confirm a post-vote night crosses midnight without Dean-class IndexError / early stop at day boundary.

## C. Parked

- Day-1 Limited Immunity redesign (COS) — separate from this locked-catalog proof.
- OpenRouter Phase 8 / Path B Class A / trailer CupCat (`20260713_launch.md`).
