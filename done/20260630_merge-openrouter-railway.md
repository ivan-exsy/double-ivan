# Merge Plan — OpenRouter × Railway Integration

**Created:** 2026-06-30 · **Owner:** Ivan · **Priority branch:** `railway` (deployed, running `20260630-1`)

## Progress (updated 2026-07-10 — MVP signed off on `20260709-1`)

| Phase | Status | Notes |
|---|---|---|
| 0 — Trailers on `railway` | ✅ Done | Trailer commit `85849fc2` landed on `railway`. |
| 1 — Cherry-picks to `railway` | ⏭️ Skipped (Option B) | Everything comes over in one shot via the rebase instead. |
| 2 — Integration branch + rebase | ✅ Done | `ivan/openrouter-railway-merge` at `d81262f6` in worktree `D:\Coding\generative_agents-merge`. 11/11 OpenRouter commits replayed onto `railway` (`85849fc2`). |
| 3 — Resolve conflicts | ✅ Done | Only 2 conflicts (predicted up to 6). `tests/analyze_action-location.py` → Option 2; `.gitignore` → Option 1. `plan.py`, `reverie.py`, `run_gpt_prompt.py` auto-merged cleanly. |
| 4 — Score `20260630-1` + unified TODO | ✅ Done | Run 1 scored 2026-07-01: partial pass (RCA-1 12/14, dinner 5-6/15, sleep + 5 P0s green). Decision: merge first, investigate residuals after Run 2. |
| 5 — Combined validation on integration branch | ⏭️ Skipped (revised) | Waived per polish doc decision. Run 2 (2,600-step OpenAI, same seed) serves as A/B merge-regression check vs Run 1 instead — validates the merge + establishes the residual baseline in one run. |
| 6 — Merge to `railway` + deploy | ✅ Done | `--no-ff` merge commit `a7cff6bc` on `railway`, pushed to origin. Deployed to VPS 2026-07-01 (`git pull` + `systemctl restart double-api`); `double-api` healthy on HTTPS. Note: `uvicorn` on VPS serves HTTPS only — use `curl -k https://localhost:8001`. |
| 7 — Tier 1.5 location + survival MVP | ✅ **DONE** | Location PASS on `20260708-mvp-a` (halluc 0.6%, Class A desk-excl. 15). Survival MVP PASS on `20260709-1` (RCA-1 + meals/sleep/P0s/vote/halluc/Class A). |
| 8 — Embedding reindex + gateway cutover | ⏳ Deferred | Irreversible; own budget; post-MVP. |

**MVP closed 2026-07-10.** Remaining: Phase 8 · `railway`→`main` · VPS cleanup. Tracker: `20260705_close-for-mvp.md` → DONE.

### `20260703-or-2` full validation scored (2026-07-04)

2,600 steps, DeepSeek, duplicate Supabase, sprint + diagnostic. **Merge-side gates all green; Tier 1.5 location gate fails — no MVP sign-off yet.**

| Gate | Result | Verdict |
|---|---|---|
| Premiere meals | lunch **14/14**, dinner **14/14** (dedicated scorer; survival scorer's 0/15 is the known format artifact) | ✅ dinner handover fix confirmed (was 7/15 on Run 2) |
| Sleep @ 1,050 | 14/14 in bed | ✅ |
| RCA-1 recovery @ 2,450 / 2,489 | 14/14 / 14/14 | ✅ (strict zero gate still fails, but mostly scorer false positives + post-vote dinner-at-Hobbs = intended push-later; 1 genuine lingerer — pre-existing) |
| 5 closed P0s | all green | ✅ |
| Gap 2 staff zones (first honest number, real `work_area`) | 434 | improved vs 891 inflated |
| **Class A** | **70** (gate ≤5) | ❌ blocks sign-off — see Phase 7 row |

Sign-off items: **MVP closed on `20260709-1` (2026-07-10).** Remaining ops: `sot_llm.md` updated · `railway`→`main` · VPS cleanup. Location Class A ship call closed earlier on mvp-a.

### `20260704-or-smoke` location re-smoke (2026-07-04)

250 steps, DeepSeek, duplicate Supabase, sprint + diagnostic. Post orphan-anchor redirect only (pre post-validate fix).

| Gate | Result | Verdict |
|---|---|---|
| Class A | **9** / 250 steps (gate ≤5 extrapolated) | 🔄 improved from 70; post-validate fix landed same day — superseded by `20260705-or-smoke` |
| Class B / C1 / C2 | 0 / 0 / 0 | ✅ |
| Gap 2 | 1 (Owen Logan, pub counter) | improved vs 434 full-run |

8/9 Class A cases: post-validate bounced legitimately redirected home addresses (`parent_location_inherit_v1`). 1/9: missing maze fixture (cafe refrigerator) — deferred.

### `20260705-or-smoke` location smoke — PASSED (2026-07-05)

250 steps, DeepSeek, duplicate Supabase, sprint + diagnostic. Post orphan-anchor redirect **and** post-validate exemption on VPS (`railway`).

| Gate | Result | Verdict |
|---|---|---|
| Class A | **2** / 250 steps (gate ≤5) | ✅ **smoke gate passed** (was 9 pre post-validate, 70 on full run) |
| Class B / C1 / C2 | 1 / 0 / 0 | ✅ |
| Gap 2 | 2 (Owen Logan, pub counter) | known deferred pattern; not a smoke fail |
| V1–V3, Bug B/C | clean | ✅ |

Remaining 2 Class A: Alexis Reed library inherit cases (`parent_location_inherit_v1`) — not the bed/closet bounce pattern Issue 1 targeted. Report: `tests/reports/_20260705_or_smoke_action_location_vps.txt`.

### `20260706-map-smoke` location smoke — PASSED (2026-07-06)

250 steps, DeepSeek, duplicate Supabase, sprint + diagnostic. Post map registry alignment + LLM prompt/normalize (`railway`).

| Gate | Result | Verdict |
|---|---|---|
| Class A | **3** / 250 steps (gate ≤5) | ✅ **smoke gate passed** (was 2 on `20260705-or-smoke`) |
| Class B / C1 / C2 | 1 / 0 / 0 | ✅ |
| Gap 2 | **0** | ✅ (was 2 on prior smoke) |
| LLM hallucination | **0%** (0/6 calls) | ✅ at smoke N — monitor at 2,600 |
| V1–V3, Bug B/C | clean | ✅ |

All 3 Class A: `parent_location_inherit_v1` (bookshelf @ library ×2, refrigerator @ dorm desk). Report: `tests/reports/_20260706_map_smoke_action_location_vps.txt`.

### `20260706-map-signoff` — IN FLIGHT (2026-07-06)

Fresh 2,600-step fork after map/prompt fixes. **MVP gate** — score Class A + survival + Gap 2 + hallucination when complete. Do not restart VPS API mid-run.

### Run 2 verdict + OpenRouter cutover — DONE (2026-07-03)

- **Run 2 (`20260701-1`) completed 2,600 steps and scored clean vs Run 1** — no merge regression. RCA-1: 11/14 immediate, 3 lingered but all cleared by ~step 2,353 (vs Run 1's lingerers to 2,420); recovery 14/14 @ 2,450 and 2,489 (better than Run 1's 13/14). Sleep @ 1,050: 12/14 (pass). Meals (scored @ 863): lunch 13/15, dinner 7/15. All 5 P0s green. Strict RCA-1 zero gate + dinner shortfall confirmed **pre-existing** → fix on unified branch.
- **OpenRouter cutover LIVE on VPS** — env block applied, `systemctl restart double-api`, smoke `20260703-or-1` (250 steps, DeepSeek V4 Flash confirmed in LLM dumps, duplicate Supabase, sprint mode via the new default). Engine healthy: 15/15 sprite coverage, no LLM errors, completed.
- **Smoke scores:** Class A **6** (gate ≤5 — fail by 1; was 10 pre-merge on DeepSeek), Class B 3, C1/C2 0/0, Gap 2 staff hits 891 (known, Tier 1.5 scope).
- **Remaining to MVP sign-off (not merge work):** ~~Tier 1.5 Class A ≤5 smoke~~ ✅ (`20260705-or-smoke`, Class A 2); **2,600-step sign-off run**; Gap 2 cascade (deferred); then `sot_llm.md` update + `railway`→`main`.
- Fork-default-sprint fix committed + pushed (`0b045c6d`); fork now defaults to sprint even with `DEFAULT_OWNER_TIMEZONE` set — verified on the smoke fork.

### Run 2 — A/B merge-regression check (LAUNCHED 2026-07-01)

**Sim code: `20260701-1`** — forked from `soul15_seed_20260224`, started 2,600 steps, OpenAI, on the merged code (`a7cff6bc`). `backend_process_active: true`, PID 3183641. ~20h, fire-and-forget overnight → scores ~2026-07-02. Sprint mode confirmed (`live_mode: false`, ~24 sec/step wall).

⚠️ **Two issues hit this run — both diagnosed, run resumed 2026-07-02:**

1. **Live-chunking stall (not an OpenAI quota issue).** The fork applied a `live_mode: true` generation profile by default, so the sim ran in live/chunked mode instead of sprint. It generated to step 847 (+90 steps ahead of owner-now), ended its chunk, marked `COMPLETED.json`, and waited for the scheduler to re-wake it — which never happened. Process died, status `sleeping`, idle ~16h. All 847 steps persisted safely (15/15 personas). OpenAI was healthy throughout (all LLM metrics `ok=True`).
2. **Diagnostic mode didn't activate on the first chunk.** The live-mode continuation branch in `background_tasks.py` dropped `parameters`, so `diagnostic_mode` never reached the runner. No `logs/` dir for steps 0–847.

**Fixes:**
- `api_gateway/app/services/background_tasks.py` — pass `parameters` through in the live-mode continuation branch. Tested (`test_live_scheduler.py`). Not deployed (not needed for the resume — sprint mode bypasses that branch).
- **Resume (2026-07-02 15:17 UTC):** restarted with `generation_mode: "sprint"`, `diagnostic_mode: true`, `max_steps: 1753` (847 → 2,600). Verified: step climbing past 846, `live_mode: false`, `logs/` now collecting (`llm/`, `fe-forensics/`, `movement-pipeline.ndjson`), no `LIVE BUFFER` re-chunking. Sprint pace ~24–34 s/step → finishes late 2026-07-02 / early 2026-07-03 ET. Steps 0–847 have no forensic logs; steps 848–2,600 do (covers RCA-1 linger 2,311–2,489 + dinner regression).

**The A/B merge-regression scoring still works** — RCA-1 linger, premiere meals, sleep @ 1,050, and the 5 P0s are all derivable from Supabase + transport JSON (collected throughout). The resumed diagnostic capture adds LLM-level forensics for the deep-dive cases.

### Partial A/B — premiere meals (scored 2026-07-02 at step 863, before run completion)

Scored with `tests/score_rca2_meals.py 20260701-1` (premiere day plan still live in scratch at step 863 / sim time 20:37):

| Metric | Run 1 (`20260630-1`, pre-merge `66331d37`) | Run 2 (`20260701-1`, merged `a7cff6bc`) | Verdict |
|---|---|---|---|
| Lunch | 12/15 | **13/15** | ✅ No regression — slightly better, meets target |
| Dinner | 5–6/15 | **7/15** | ✅ No regression — comparable/slightly better, both fail 13/15 target |

**Conclusion (partial):** The merge did **not** introduce a premiere-meal regression. The dinner shortfall is **confirmed pre-existing** (already failing on Run 1's pre-merge code) → it's a fix item on the unified branch, not merge-caused. This greenlights the dinner fix + low-risk deploys now, but the **definitive merge verdict still needs the full run** — the merge's riskiest changes (`work_area` auto-assign, Tier 1 reconcile) manifest at the vote/elimination (~step 2,310) and RCA-1 linger (2,311–2,489), none of which are reachable at step 863. Do not start Tier 1.5 or sign off until those are scored.

Run 2 = the single 2,600-step VPS run on the merged code (`a7cff6bc`), OpenAI, fresh fork of `soul15_seed_20260224`. Compares against Run 1 (`20260630-1`, pre-merge code `66331d37`):

- **Metrics roughly similar** → merge is clean; the RCA-1 linger (Olivia/Andrew) + dinner regression are pre-existing → investigate each in detail from Run 2 Supabase data, then fix on the unified branch.
- **Metrics degrade** → the merge introduced a regression (likely from work_area or Tier 1 reconcile) → roll back the merge commit (`git revert a7cff6bc`) or fix forward.

Run 2 must be OpenAI (not OpenRouter) for the A/B to be valid — same model as Run 1. ~20h on VPS, fire-and-forget overnight. Score with the same metrics as Run 1 (RCA-1 linger window 2,311-2,489, premiere meals, sleep @ 1,050, closed P0s).

**Launch commands (VPS, HTTPS — `uvicorn` rejects plain HTTP):**

```bash
# Fork
curl -k -X POST https://localhost:8001/api/simulations/fork \
  -H "Content-Type: application/json" \
  -d '{"sim_code":"20260701-1","baseline":"soul15_seed_20260224","description":"Run 2 — A/B merge-regression check vs 20260630-1, merged code a7cff6bc, OpenAI, diagnostic mode","copy_memories":true,"copy_coords":false}' | python3 -m json.tool

# Start (diagnostic_mode captures LLM dumps + movement JSON + FE forensics)
curl -k -X POST https://localhost:8001/api/simulations/20260701-1/start \
  -H "Content-Type: application/json" \
  -d '{"action":"start","parameters":{"max_steps":2600,"diagnostic_mode":true}}' | python3 -m json.tool

# Status
curl -k https://localhost:8001/api/simulations/20260701-1/status/current | python3 -m json.tool
```

**Post-run cleanup TODO:** diagnostic mode produces large forensic logs (LLM dumps, movement JSON, FE forensics) on the VPS under the sim's storage path. After scoring Run 2, remove these from the server to reclaim disk:

```bash
# Review size first, then remove diagnostic artifacts for 20260701-1
du -sh /var/www/generative_agents/environment/frontend_server/storage/20260701-1
rm -rf /var/www/generative_agents/environment/frontend_server/storage/20260701-1/{movement,environment}
# Also clear any LLM prompt/forensic dumps under reverie backend_server diagnostic dirs
```

### OpenRouter cutover — ready to deploy after Run 2 (verified 2026-07-02)

**Duplicate Supabase project is cutover-ready** (project `kkjhsozszgoorwehhsdg`). Verified:
- Baseline `soul15_seed_20260224` present, `is_baseline=true`; 15 personas + 15 scratch rows.
- `dbl_memory.embedding` column is `vector(768)` — accepts Gemini embeddings.
- `public.fork_simulation(...)` works: test fork `20260702-or-smoke` succeeded (`personas_copied=15`, `scratch_rows_copied=15`, `maze_template_found=true`). `memories_copied=0` / `survival_*_copied=0` expected (baseline has no seed memories; survival state created fresh on start — same as Run 2).
- Test sim `20260702-or-smoke` is a leftover stopped fork — clean up or ignore.

**The cutover is env-driven, no code change** (merged `model_router.py` routes on `LLM_PROVIDER`): set `LLM_PROVIDER=openrouter` → cognition to DeepSeek V4, embeddings auto-switch to `google/gemini-embedding-2`. `OPENAI_API_KEY` stays dormant (ignored when provider is openrouter); retire post-MVP.

**Cutover env block (apply to VPS `.env.local` at deploy time):**
```bash
LLM_PROVIDER=openrouter
LLM_MODEL_TIER_A=deepseek/deepseek-v4-flash
LLM_MODEL_TIER_B=deepseek/deepseek-v4-flash
LLM_MODEL_TIER_C=deepseek/deepseek-v4-pro
TIER_C_ENABLED=false
EMBEDDING_MODEL=google/gemini-embedding-2
OPENROUTER_API_KEY=<key>
SUPABASE_URL=<duplicate project URL>
SUPABASE_ANON_KEY=<duplicate>
SUPABASE_SERVICE_ROLE_KEY=<duplicate>
```

**Deploy sequence (when Run 2 completes + scores clean):**
1. Score full A/B (RCA-1 linger 2,311–2,489, sleep @ 1,050, vote ~2,310, 5 P0s) from Supabase. If merge clean → proceed.
2. Commit + push: diagnostic-`parameters` fix + fork-default-sprint fix (both staged locally; pass `generation_mode:"sprint"` explicitly on start as a belt-and-suspenders until the sprint fix ships).
3. VPS: `git pull` → update `.env.local` with the cutover block above → `systemctl restart double-api`.
4. Fork a fresh sim on the duplicate (e.g. `20260702-or-1`) + start with `generation_mode:"sprint"`, `diagnostic_mode:true`, ~250 steps. Confirms merged code runs on DeepSeek + gives the Class A baseline for Tier 1.5. (~$0.50, ~20 min.)
5. Apply the dinner fix on DeepSeek (tuned on the production model) + validate with a full run (~$2.50 vs ~$14 on OpenAI).

**Non-blockers (do not gate the cutover):** gateway chat-with-double / card summary (viewer features, not used in headless generation); Tier 1.5 Class A ≤5 (blocks sign-off, not the cutover — the 250-step smoke gives the number); dinner fix (applied after cutover); `OPENAI_API_KEY` retirement (post-MVP).

**Remaining roadblock:** only Run 2 + the merge verdict (~11h). Everything else is prepped.

### Verification (Phase 2-3 exit check)

Merged branch confirmed coherent on both sides:

| Suite | Result | Confirms |
|---|---|---|
| OpenRouter full suite (client, structured adapter, embeddings, provider prefs, replay-tolerant, cost telemetry, model router) | **39 passed** | OpenRouter plumbing survived the merge |
| OpenRouter reasoning control | **7 passed** | Run 1c Tier B config intact |
| `test_label_anchor_reconcile` | runs, reconcile fires | Tier 1 location logic operational |
| `test_daily_plan_cleanup` (railway) | **6 passed** | No-crutch meal logic intact after `plan.py` merge |
| `test_survival_rca_refix_20260630` (railway) | **2 passed** | Survival controller / vote supersession intact |

Worktree env notes (local-dev only, no code impact): `.env.local` copied into the worktree for imports; tests need `PYTHONUTF8=1` + `PYTHONPATH=<worktree root>` on Windows.

---

## Goal

Unify the two parallel workstreams into a single branch:

- **`railway`** (26 commits since fork) — 15-person Survival MVP polish on OpenAI: vote supersession, meal stack, daily-plan cleanup, hourly FOLLOW THE PLAN, crutch removal, survival controller, open-ended seasons, operator labeling, API/OpenAPI types, diagnostics. **Deployed and trailer-priority.**
- **`ivan/openrouter-deepseek-v4`** (11 commits since fork) — OpenRouter + Gemini embeddings plumbing, Tier 1 label↔anchor reconcile, work_area auto-assign, reindex scripts.

**Common ancestor:** `4a1752fb` (2026-06-27 14:58). Neither branch is an ancestor of the other.

**Tie-break rule on conflicts:** prefer the `railway` version, unless a fix is on the explicit "bring over" list below.

---

## Conflict surface (verified)

Only 5 files overlap. Everything else is disjoint (survival code/prompts/tests only on `railway`; model router, embeddings, reindex, OpenRouter tests only on `openrouter`).

| File | Conflict risk | Notes |
|---|---|---|
| `.gitignore` | Trivial | Both add lines |
| `reverie/backend_server/reverie.py` | **Real** | Railway refactors env-overrides into `log_collection_profile` and drops `SURVIVAL_TOTAL_DAYS`; OpenRouter adds `_auto_assign_work_areas` (different regions — likely clean) and OpenRouter env wiring |
| `reverie/backend_server/persona/cognitive_modules/plan.py` | **Real** | Railway *removed* the `_ensure_meal_blocks` crutch; OpenRouter *added* `_reconcile_anchor_with_label` in the same file (different functions — reconcilable) |
| `reverie/backend_server/persona/prompt_template/run_gpt_prompt.py` | Possible | Both touch `max_tokens` / cleanup hooks |
| `tests/analyze_action-location.py` | Possible | Railway expanded it ~290 lines; OpenRouter made a 5-line tweak |

---

## OpenRouter branch — commit-by-commit review (manual)

Full 11-commit inventory with a recommendation for each. **"Cherry-pick now"** = safe, self-contained improvement that benefits `railway` independent of OpenRouter. **"Defer to integration"** = needs the OpenRouter plumbing or conflicts with railway's plan.py. **"Skip"** = noise or no-op on railway.

### A. Cherry-pick to `railway` NOW (pure improvements, no OpenRouter dependency)

| Commit | What it does | Recommendation | Conflict risk on railway |
|---|---|---|---|
| `9ed13e65` — work area auto-assignment | Adds `_auto_assign_work_areas()` to `ReverieServer`; assigns non-residential sectors to personas missing `work_area`. Fixes "missing work_area on forked baselines" — root-cause contributor to Gap 2 staff-zone violations. 34 lines, self-contained. | **Cherry-pick now** — highest-value fix on the OpenRouter branch for railway. | **Likely clean** — touches `reverie.py` at lines ~1716, ~1806, ~2382; railway's reverie.py edits are at ~1740 and ~6928 (different regions). Verify during cherry-pick. |
| `d1fdceae` — suppress cosmetic WebGL errors | 11 lines in `headless_visualization.py` filtering non-critical Three.js/Phaser WebGL context messages from headless Chrome logs. | **Cherry-pick now** — low-risk log hygiene. | **Clean** — `headless_visualization.py` not touched by railway. |
| `f0cccc1c` — `.gitignore` hunk only | Adds ignores for `supabase/_tmp_*` scratch files so they can't be re-committed. | **Cherry-pick the .gitignore hunk now** — trivial, prevents future accidents. | **Clean** (additive). |

### B. Defer to integration branch (OpenRouter-specific or conflicts with railway plan.py)

| Commit | What it does | Why defer |
|---|---|---|
| `9df9107f` — OpenRouter support + embeddings | The foundational commit: OpenRouter client factory, reasoning control, structured-output adapter, provider prefs, cost telemetry, embedding switch, `reindex_embeddings.py`, `openrouter_spike.py`. 16 files. | OpenRouter plumbing — no value without the rest of the migration. Comes over during rebase. |
| `344fdb80` — `encoding_format="float"` | Mandatory param for Gemini embedding endpoint. 4 files, 14 lines. | Tied to OpenRouter embeddings. |
| `1d49906f` — Tier B complex handling | Disables Tier B allowlist post-spike; defaults to `effort=none`. | OpenRouter reasoning control. |
| `bedf7317` — Tier B allowlist + max_tokens | Run 1c allowlist (6 hard prompts with thinking on) + token bumps. Also adds `tests/reports/_build_rca_data.py` and `_patch_naturalness_report.py` (report builders — could be cherry-picked separately if wanted). | OpenRouter reasoning. **The two report-builder scripts are independent and could be cherry-picked to railway now if useful for run analysis** — they have no conflicts. |
| `36596443` — embedding upsert for reindex | 8-line `reindex_embeddings.py` improvement (upsert vs update). **The rest of this commit is `_tmp_*` scratch files that were later deleted by `e42efccd` — net effect on the branch is just the 8-line reindex change.** | Tied to reindex. Comes over during rebase; the `_tmp_*` noise is already gone. |
| `be0f64a8` — reindex multi-target | Refactors `reindex_embeddings.py` for `dbl_embedding` + `dbl_semantic_facts` targets; adds `reindex_embeddings_reverse.py`. | Tied to reindex. |
| `f0cccc1c` — `plan.py` reconcile (the plan.py hunk) | `_reconcile_anchor_with_label` + inherit post-validate + `test_label_anchor_reconcile.py`. Tier 1 location accuracy. **Insufficient alone** (Class A 10 vs ≤5 target on `20260630-1-deep`), but foundation for Tier 1.5. | **Conflicts with railway's plan.py** (railway removed `_ensure_meal_blocks` from the same file). Resolve during rebase — keep both: railway's no-crutch state AND OpenRouter's reconcile function (different functions). |

### C. Skip (noise or no-op on railway)

| Commit | Why skip |
|---|---|
| `e42efccd` — Remove temp Supabase files | Pure deletion of `_tmp_*` scratch files that railway never had. No-op on railway; harmless during rebase. |
| `e4faa987` — "WebGL error handling" | Misleading message — this commit is almost entirely accidentally-committed `supabase/_tmp_*` files (11k+ lines) later deleted by `e42efccd`. The real headless-visualization change is in `d1fdceae` (already cherry-picked above). Nothing real to bring. |

### D. The "new Supabase project with re-done embeddings" — IMPORTANT NOTE

This is **infrastructure, not code in the branch**. The OpenRouter branch carries the *reindex scripts* (`scripts/reindex_embeddings.py`, `scripts/reindex_embeddings_reverse.py`) that target the new project. The actual Supabase project with Gemini-embedded data is an external operational artifact Ivan set up.

**Implication:** merging the branch brings the *scripts*, not the *cutover*. Switching production retrieval to the new embeddings is a separate, **irreversible** operational step (Phase 8 below) — the reindex is the point of no return.

---

## Step-by-step integration plan

**Key insight — what waits for the score vs. what doesn't:**

| Work | Depends on `20260630-1` score? | Affects the running VPS sim? |
|---|---|---|
| Phase 1 cherry-picks to `railway` | No | No (local commits; VPS runs deployed snapshot `66331d37`) |
| Phase 2 create integration branch + rebase | No (needs Phase 1 done) | No |
| Phase 3 resolve conflicts | No (needs Phase 2 done) | No |
| Phase 5 combined validation on integration branch | No (needs Phase 3 done; can overlap with Phase 4) | No (separate branch) |
| Phase 4 score `20260630-1` + unified TODO | — (the score itself) | No (read Supabase) |
| Phase 6 merge to `railway` + **deploy** | **Yes** — and must wait for sim to finish (don't restart `double-api` mid-run) | **Yes** — deploy is the one VPS-touching step |
| Phase 7 Tier 1.5 priorities | Informed by Phase 4 TODO | No |

So **Phases 1 → 2 → 3 can run now, in parallel with the sim and with trailer work.** Only the deploy (Phase 6) and the Tier 1.5 prioritization (Phase 7, fed by Phase 4) genuinely wait for the score.

### Phase 0 — Today (Tue Jun 30): video trailers on `railway` (Ivan, ongoing)

- Work on opening + daily trailers for `20260628-4` directly on `railway`.
- Trailer work commits land on `railway` as normal forward commits.
- **Do not rebase or force-push `railway`** — `20260630-1` is running on the VPS at railway HEAD `66331d37`. Forward commits are fine; history rewrites are not.
- Coordinate with Phase 1 so cherry-picks don't race trailer commits (sequence them, or do cherry-picks when Ivan isn't pushing).

### Phase 1 — Cherry-pick the three "bring over now" fixes to `railway` (NOW)

Self-contained improvements that benefit `railway` regardless of OpenRouter. These are **local forward commits on `railway`** — they do NOT redeploy the VPS and do NOT affect `20260630-1`.

1. `git cherry-pick 9ed13e65` — work_area auto-assignment (verify reverie.py applies cleanly; expected yes — touches different region than railway's edits).
2. `git cherry-pick d1fdceae` — WebGL cosmetic log suppression.
3. Apply just the `.gitignore` hunk from `f0cccc1c` (and the two `tests/reports/_build_rca_data.py` + `_patch_naturalness_report.py` scripts if wanted for run analysis).
4. Run the relevant tests (`tests/test_*.py` touching work_area / headless viz) + a quick 50-step smoke on `railway` to confirm no regression.
5. **Do NOT redeploy `double-api`** — let `20260630-1` finish on the deployed `66331d37` (clean OpenAI baseline, no confound). The cherry-picks land on the branch and ride along with the next deploy (Phase 6).

### Phase 2 — Create the integration branch + rebase OpenRouter onto railway (NOW, after Phase 1)

Needs Phase 1 done so the rebase base includes the cherry-picks.

```
git checkout -b ivan/openrouter-railway-merge ivan/openrouter-deepseek-v4
git rebase railway
```

- Rebase the **smaller branch** (OpenRouter, 11 commits) onto the **larger/deployed branch** (railway). Railway history stays linear and untouched.
- Do **not** rebase `ivan/openrouter-deepseek-v4` directly — it's a shared remote; use the fresh branch so the original stays as fallback.

### Phase 3 — Resolve conflicts (NOW, after Phase 2; hand back to Ivan)

Expected conflicts, in priority order:

1. `reverie/backend_server/reverie.py` — highest risk. Railway refactored env-overrides into `log_collection_profile`; OpenRouter adds OpenRouter env wiring + `_auto_assign_work_areas` (the latter already cherry-picked in Phase 1, so this hunk should drop out of the rebase). **Keep railway's env refactor; layer OpenRouter's env vars on top.**
2. `reverie/backend_server/persona/cognitive_modules/plan.py` — keep **both**: railway's no-crutch state (no `_ensure_meal_blocks`) AND OpenRouter's `_reconcile_anchor_with_label` + inherit post-validate. They live in different functions.
3. `run_gpt_prompt.py` — reconcile `max_tokens` bumps (OpenRouter) with cleanup hooks (railway).
4. `tests/analyze_action-location.py` — keep railway's expansion, fold in OpenRouter's 5-line tweak.
5. `.gitignore` — both additive, trivial.

**Hard rule:** stop on the first non-trivial conflict and surface it to Ivan with a recommended resolution. Do not resolve autonomously.

### Phase 4 — Score `20260630-1` + build the unified TODO (Wed Jul 1, when the sim completes ~3 AM)

- Analyze `20260630-1` results from Supabase (RCA-1 vote supersession, meals, sleep at step 1,050).
- Combine remaining items from `15sim-polish.md` (RCA-1 end-to-end confirm, dinner salience follow-up) and `20260627_openrouter.md` (Tier 1.5 location pass, Gap 2 staff cascade, embedding reindex, gateway cutover).
- Output: a single prioritized TODO list for the unified branch. **This feeds Phase 7 (Tier 1.5 priorities) and the deploy decision (Phase 6), not the merge mechanics.**

### Phase 5 — Combined validation on the integration branch (after Phase 3; can overlap with Phase 4)

Before promoting anywhere:

- **250-step OpenRouter smoke** on `soul15_seed` — confirms the Run 1c config survived the merge (OpenRouter plumbing + embeddings intact).
- **Survival checklist** — confirms railway's vote supersession + meal stack + hourly FOLLOW THE PLAN still green on the merged code (run on OpenAI to avoid model confound, or accept the confound and run on OpenRouter per the Run-3-failed branch of `15sim-polish.md`).
- **Tier 1 location gate** — re-measure Class A on the merged branch. Expected still ~10 (Tier 1.5 not yet built). This is the baseline for Phase 7.

### Phase 6 — Merge to `railway` + deploy (only after Phase 5 passes AND `20260630-1` has finished)

**Two gates, both must be satisfied:**
1. Phase 5 validation on the integration branch passes.
2. `20260630-1` has completed and been scored — **never restart `double-api` while the sim is running.**

```
git checkout railway
git pull --ff-only
git merge --no-ff ivan/openrouter-railway-merge
git push origin railway
```

- `--no-ff` preserves the integration history (per git rules: never merge without `--ff-only` or `--no-ff`).
- **No force-push, ever.**
- Deploy to VPS; run a short smoke to confirm the deploy serves the merged code.

### Phase 7 — Tier 1.5 location pass (on the unified branch; priorities from Phase 4 TODO)

Not in either branch yet. Class A 10 failed the ≤5 gate on `20260630-1-deep`. Build the post-contract location pass using the meal-pass pattern from `15sim-polish.md` RCA-2:

- After `_contextual_rows_to_contract_pairs`: if sub-task label names object X and parent arena contains `:X` → force resolved address to `:X`.
- If label names X but arena has no X → detach + independent `generate_action_location`.
- If non-worker on `staff_only` leaf → cascade off counter (inherit currently skips filtered tree).

Re-validate 250 on `soul15_seed`. Gate: Class A ≤5.

### Phase 8 — Deferred (post-MVP, own budget, irreversible)

Per `20260627_openrouter.md` "Path to migration complete":

1. Embedding reindex — `reindex_embeddings.py --dry-run` → full run. **Point of no return.** Rollback requires re-reindex.
2. Gateway cutover — Chat with Double (Tier C Pro) + card summary validation on OpenRouter.
3. Full validation + Naturalness Gate; update `sot_llm.md`.
4. Railway deploy with OpenRouter env; retire `OPENAI_API_KEY`; 24h monitor.

---

## What we are NOT doing before/during the merge

- Force-pushing any branch (hard rule).
- Resolving conflicts autonomously (hand back to Ivan).
- Full `dbl_memory` reindex before the sim engine is signed off (irreversible).
- Tier 2 strict location enum — only if Class A > 5 **after** Tier 1.5 at 250+ steps.
- Promoting to `main` or **redeploying `railway`** until Phase 5 validation passes AND `20260630-1` has finished.
- Rebasing or force-pushing `railway` (forward commits only while the sim runs).

> **Note:** local forward commits to the `railway` branch (e.g. Phase 0 trailer work) are safe while `20260630-1` runs — the VPS executes a deployed snapshot and does not hot-reload from the branch. The rebase itself ran in a separate worktree (`D:\Coding\generative_agents-merge`), so the main checkout and the running trailer process were never disturbed. The only VPS-touching action is a deploy + `double-api` restart, which is Phase 6.

---

## Open questions for Ivan

1. ~~Phase 1 cherry-picks~~ — **Resolved 2026-06-30:** Option B — bring everything over in one shot during the rebase. No pre-cherry-picks. (Phases 2-3 done.)
2. ~~Report-builder scripts~~ — **Resolved:** came along with the rebase (rode with `bedf7317`); both `tests/reports/_build_rca_data.py` and `_patch_naturalness_report.py` are on the integration branch.
3. **Phase 5 survival checklist model** — run on OpenAI (clean signal, ~$14) or OpenRouter (confound risk, ~$2.50)? Recommendation: OpenAI for the survival gates (matches the RCA baseline), OpenRouter for the 250-step plumbing smoke.
4. ~~Start Phase 1 today alongside trailer work~~ — **Moot:** Phase 1 skipped (Option B); trailer work committed first (`85849fc2`), then rebase ran in a separate worktree so the trailer session was never disturbed.

**Next decision point:** Phase 4 — once `20260630-1` scores, draft the unified TODO (remaining `15sim-polish.md` items + `20260627_openrouter.md` items) to drive Phase 7 (Tier 1.5) priorities.
