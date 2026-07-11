# 2026-07-11 — Verify Survival catalog on `20260710`

## Closed yesterday (2026-07-10)

1. **Locked Survival challenge catalog** — product-locked 14 challenges for **new sims only**; random rotation (no repeats until pool exhausted); legacy sims unchanged.
2. **Cast digest challenge card** — end-of-day digest no longer blanks after scratch clears; reads season `challenge_results` instead.
3. **VPS re-score on `20260709-1` Day 2** — **PASS**: `Limited Immunity — winners: Alex Butcher, Diana Ogden` (was `(none)`).
4. **MVP doc closure** — polish / RCA-1 / close-for-mvp archived under `done/`; `sot_llm.md` v1.7 OpenRouter posture.
5. **`railway` → `main`** — treat as **done** (promoted).

## Deployed (VPS)

- Build includes catalog + digest fix (`2729b4a8` on `railway` / now on `main`).
- `double-api` restarted after pull.
- Ready for new sim **`20260710`**.

---

## A. Verify on `20260710` (mid-flight + after first Survival morning)

Engine day 2 = Survival day 1 for digests/trailers.

- [ ] **Sim healthy** — status climbing / completed; `live_mode: false` if sprint; no unexpected stall.
- [ ] **Locked pool only** — first challenge id is from the locked catalog (not legacy-only ids outside the 14).
- [ ] **No Limited Immunity / Reputation Tax on new sim** — those stay legacy-only; new run should not schedule them.
- [ ] **Random + no immediate repeat** — if a second challenge fires in-window, it differs from the first; `used_challenge_ids` grows in season state.
- [ ] **Catalog version** — season shows `challenge_catalog_version` / locked catalog path for new sim.
- [ ] **Digest challenge card** — after Survival morning resolves, cast digest shows real challenge name + winners (not `(none)` / null).
  ```bash
  python3 -m video.summarize_cast_day 20260710 --day 2 --output-dir data/20260710/trailer_ready_day2
  ```
- [ ] **Legacy still fine** — no need to re-break `20260709-1`; that path already re-scored PASS.

## B. Ops hygiene (same day if bandwidth)

- [ ] **VPS diagnostic cleanup** — after you’re done inspecting `20260709-1`, trim large diagnostic storage (movement/environment/logs) so disk doesn’t fill. Keep Supabase as SOT.
  ```bash
  du -sh /var/www/generative_agents/environment/frontend_server/storage/20260709-1
  # only after scoring is locked:
  # rm -rf .../storage/20260709-1/{movement,environment}
  ```
- [ ] **Confirm `main` on VPS** — `git log -1 --oneline` matches the promoted tip you expect (catalog + digest fix present).
- [ ] **24h smoke glance** — after promote/restart, one status check that `double-api` is healthy and `20260710` (or next run) is progressing.

## C. Not tomorrow morning (parked)

- Day-1 Limited Immunity **redesign** (COS `2026-07-10-002`) — design only; not in this deploy.
- **OpenRouter Phase 8** — embedding reindex (dry-run → full), gateway Chat-with-Double validation, retire `OPENAI_API_KEY` (`done/20260627_openrouter.md`).
- **Path B Class A residual** — computers / cafe counter / fridge / piano (`TODO_action-location.md`).
- Trailer Supabase migrations (`featured_history`, `day_scar`) — only if those features are used.
- Daily trailer CupCat / Day-0 script work (`20260713_launch.md`).
