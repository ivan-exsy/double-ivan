# Production Hardening — Concurrent Simulations, LIVE Mode & Scale

> **Status:** adopted roadmap. **Target:** thousands of always-on doublands (LIVE mode, `20260609_LIVE_mode.md`) and millions of playback viewers, built up cheapest-first from today's single VPS + Vercel + Supabase.
> **History:** rewritten 2026-06-10 — implemented phases compressed to summaries, superseded analysis removed. Earlier revisions held the full investigation (blockers B1–B8, hardening items H0–H8, FE Q&A Q1–Q7, evidence appendix; the scale-up plan lived under "§S"). Recover via git history of this file.
> **Sources:** measured soak results (`done/20260608_FE_MVP_hardening.md`), operator runbook (`20260610_parallel_sim_launch.md`), frontend investigation 2026-05-15 (`double-front`), per-step cost/load measurements 2026-06-10.

---

## Phase tracker

- [x] **Phase 0 — 3-sim MVP hardening** — shipped & soaked 2026-06-09/10 (summary below)
- [x] **Phase 1 — Cost telemetry** — implemented & verified 2026-06-10 (reconciliation exact; summary below); merged to `main` & deployed to VPS 2026-06-11 (`7694f968`)
- [x] **Phase 2 — Publish-don't-serve viewer plane** — CDN step bundles + manifest; this *is* the LIVE-mode delivery mechanism. **Backend complete: publish-on-generation shipped 2026-06-10 (Run A); reveal-gated publishing verified live 2026-06-11 (Run B, §3 below); merged & deployed 2026-06-11 (`7694f968`)**. DP7 reveal-cap FE (DP7-FE-0…5) **closed 2026-06-12** — 4/4 QA PASS on `20260611-2`. **2026-06-12 evening:** FE CDN player implemented, accepted on `20260612-1`, and **flipped live in prod** (`NEXT_PUBLIC_VIEWER_SOURCE=cdn` on Vercel); click-content artifacts (sprite-manifest + day highlights) shipped as CDN files (`b92999b8`, deployed VPS); PL-12 terminal-manifest closed. **2026-06-13:** 6a publisher deploy confirmed live — both artifacts verified CDN-served with REST-parity bodies (`20260612-3/sprite-manifest.json` → 200; `20260611-2/highlights/1.json` → 200 after an end-to-end `build_highlights` run on a real completed day). FE CDN-first fetch of both shipped to prod (+11 FE tests). **Closed 2026-06-16:** FE Step 5.3 retired the gateway viewer path + the `NEXT_PUBLIC_VIEWER_SOURCE` flag (CDN is now the only configured viewer source; 397 tests green; deployed prod), and the soak closed on `20260613-1` (transport plane green throughout — the backend timezone bug that corrupted *content* was a separate, non-blocking BE track, fixed 2026-06-16). PL-12 verified on un-enroll: `final_manifest_status:"stopped"`, `live.json` flipped `running`→`stopped`.
- [x] **Phase 3 — Chunk scheduler + same-day chat injection** — ~100+ always-on doublands on the current box. **Backend complete & verified live 2026-06-11 (Run A chat slice + Run B scheduler, §3 below); merged & deployed 2026-06-11 (`7694f968`)**. Decision 2026-06-11: small-lead strategy, no rollback of unpublished steps (chats land in the next chunk, ≤ ~1h). **2026-06-12:** validation run (`20260612-1`) — machinery + realism + Naturalness Gate PASS vs `20260611-2`; exposed **P3-1** (injected chats reached memory but not behavior). **Fixed same day** (`a6ba597c`, external inbox → perception → `external_replan`). **Accepted 2026-06-12** on live sim `20260612-3`: mundane schedule splice + urgent act-now replan; formal gates green at steps 0–139. Detail: `20260612_todo.md` § P3-1.
- **Phases 4–7 (post-MVP scale roadmap) — moved to `TODO_post_mvp.md` § Scale roadmap (2026-06-15)**: Phase 4 cost levers · Phase 5 browser-free realization · Phase 6 fleet-out · Phase 7 episode factory + at-scale hardening. The strategic rationale stays here — the **bottleneck map (§1)** and the **staged build-up table (§2)** — but the actionable phase detail now lives in the post-MVP doc. **Phase 4 is gated behind `TODO_post_mvp.md` P1** (behaviour changes before cost tuning).

### Where we are (2026-06-12, Phase 3 signed off)

In three days we went from "one hand-started sim at a time" to a working always-on backend: Phase 0 (3 concurrent sims) and Phase 1 (per-doubland cost telemetry, ~$0.005/step measured) are shipped, and the backend halves of Phases 2–3 are built and **verified live** across two runs — Run A added CDN step-bundle publishing and made user chats land in the double's memory; Run B added the stateless chunk scheduler that wakes enrolled sims in bounded bursts (early-waking on chats), publishes only up to the owner-local "now" so viewers can never see the future, and survived a full wake→generate→sleep→publish cycle on a real sim, fixing two latent launch/resume bugs (including PL-6) along the way. **2026-06-11:** the whole stack merged to `main` (`7694f968`), deployed to the VPS, and exercised in the field. MVP operating decisions: Ivan is the sole sim operator, trailers generated manually (DP7-BE-4 Episode cron deferred), `DEFAULT_OWNER_TIMEZONE=America/New_York` on the VPS, reveal cap stays FE-only (`TODO_post_mvp.md` P2). **2026-06-12:** DP7 closed by FE QA (4/4 PASS on `20260611-2`); validation run `20260612-1` passed realism + Naturalness gates; PL-11/PL-12 closed; P3-1 root-caused and fixed (`a6ba597c`); 6a click-content CDN artifacts shipped; **FE CDN player live in prod**. **Phase 3 closed 2026-06-12:** P3-1 acceptance on live sim `20260612-3` — injected chats now change behavior (schedule splice + act-now replan); formal realism/naturalness green at steps 0–139 vs `20260611-2`. **Phase 2 closed 2026-06-16** — soak closed on `20260613-1`, gateway viewer path + `NEXT_PUBLIC_VIEWER_SOURCE` flag retired (FE Step 5.3), PL-12 verified on un-enroll (`final_manifest_status:"stopped"`). **All MVP phases (0–3) now done. Next:** Phase 4 attacks the cost-per-day numbers the telemetry is now measuring. Full ledger: `20260612_todo.md`.

---

## 1. Why we are doing this

The system was built to run **one simulation at a time on one shared machine** — several components silently assumed it. This surfaced when a trailer render crashed a live sim: both workloads fight over one headless browser and one frontend server. Production intent is the opposite: **always-on doublands generating continuously**, viewers watching live and on replay, **Episodes rendered in parallel** — at a unit cost below the subscription price.

**The browser tax is the central technical constraint.** Every step of every sim currently needs a headless Chromium driving the frontend, because movement realization — A\*, collision, and the proximity rules that trigger conversations — lives in frontend code (the `BACKEND_INTENT_ONLY_PATH` contract, `sot_be-fe.md`). Phases 0–4 work *around* the browser; Phase 5 *removes* it.

### Bottleneck map — ranked by when it bites

| # | Bottleneck | Breaks at | The efficient fix |
|---|---|---|---|
| **N1** | **AI cost per sim-day vs price.** A 15-double day costs **~$2–7 in LLM calls** (≈ $60–200/month always-on) — **5–10× over the $10–30 plan price**. | The *business* breaks before any server does. | Cost levers (Phase 4). Target **≤ ~$1 per fully-watched day**. |
| **N2** | **Viewer path through the VPS + per-viewer realtime.** 3-second status polling against the gateway + 2–4 Supabase realtime channels per viewer. | Low thousands of concurrent viewers. | **Publish, don't serve** (Phase 2): immutable step bundles + a manifest on CDN. |
| **N3** | **One Chromium browser per running sim** (~0.8 GB each). | Tens of sims per box; thousands always-on unaffordable. | Chunk scheduling (Phase 3) shares 3 browser slots across ~100+ doublands; browser-free realization (Phase 5) removes Chromium entirely. |
| **N4** | **LLM throughput / rate limits.** ~50k calls per full sim-day; 1,000 sims ≈ hundreds of calls/sec sustained. | High hundreds of sims on one OpenAI org. | Phase 4 levers cut volume 3–5× first; chunk scheduler smooths bursts; multiple orgs/providers only if still needed. |
| **N5** | **Supabase write firehose + memory growth.** One position write per double per step + memory inserts with embeddings → hundreds of writes/sec and millions of memory rows/day at 1,000 sims. | High hundreds of sims. | Batch writes per chunk (array RPCs, Phase 6); memory retention/compaction + partitioning (Phase 7). |
| **N6** | **Episode render farm.** Daily Episode + per-subscriber POV videos per doubland; scene recording needs a real (GPU) browser. | Already strains one local machine; ~hundreds of videos/day is the wall. | Record each moment **once** into a per-day clip library; compose many videos from it; queue + small elastic render pool (Phase 7). |
| **N7** | **Fleet orchestration + observability.** No fleet view, no cross-sim health. | Operating >50 sims blind. | Supabase-backed job queue + leases + one fleet dashboard (Phases 6–7). |

---

## 2. How we are doing it

### Product anchors (decided with Ivan, 2026-06-10)

1. **LIVE mode is a time-synced parallel universe.** Each doubland's day starts 06:30 owner-local and advances one sim-minute per real-minute; viewers are capped at "owner-local now" and can scrub back, never forward. The daily **Episode** drops at 18:30 owner-local.
2. **Same-day influence is required.** What a user says to their double should visibly change its behavior *today* (within hours), not just tomorrow.
3. **Doubland size: 10–20 doubles** (group scale, like the Survival demo).
4. **Two subscription tiers.** Watching and being a double are free. **Admin tier** (~$10–30/month): the doubland owner's plan — creates simulations, includes the daily sim-wide Episode. **Player tier:** any participant can subscribe for a daily video from **their own double's POV**; unlimited chat with your double is also paid. Revenue scales with doubland *size*, not just count.
5. **Viewers consume both formats equally** — the interactive map viewer and the video Episodes/clips.
6. **The visualization engine will change** (Phaser 2D → three.js cinematic 3D). The architecture must treat the engine as swappable (see Phase 2 → renderer-agnostic rules).

### The one insight that makes "millions of viewers" cheap

The live edge advances at **1 sim-minute per real-minute**, and the engine generates a sim-minute in **~7 s wall clock** (VPS, measured 2026-06-10) — generation always outruns the reveal edge. So "live" never means "computed while you watch"; it means a **time-gated reveal of already-generated, never-changing data**. Once a step is inside the visible window it is immutable — the perfect case for a CDN. Viewers are served entirely from cache with **zero load on the VPS, gateway, or Supabase**, whether 100 or 1,000,000 are watching; the only live mechanic is the player polling a tiny cached "what step are we on?" file every ~30–60 s.

This **inverts the old playback design** (every viewer polling the gateway every 3 s + 2–4 realtime channels each), which fails in the low thousands of viewers. It must be replaced (cheap), not scaled (impossible).

Sanity check: a 1× viewer consumes ~10 KB/min of step data plus manifest polls. One million concurrent viewers ≈ ~170 MB/s aggregate — trivial for a CDN, fatal for a VPS.

### The staged build-up (cheapest-first; nothing thrown away)

| Phase | What | Unlocks | Effort | New running cost |
|---|---|---|---|---|
| **0 — done** | 3-sim MVP hardening (prod headless FE, tab reuse, cap + overflow queue) | 3 reliable concurrent sims; the Telegram season | — | — |
| **1 — done** | Cost telemetry: per-doubland daily cost rows + queryable view/endpoint | Pricing and all Phase-4 levers decided on real numbers | — | ~$0 |
| **2 — Viewer plane** | Step bundles + manifest published to storage + CDN; client-side clock gating; retire per-viewer gateway polling + realtime | Playback scales to **millions of viewers**; *is* the LIVE-mode delivery mechanism | ~1–2 wks FE + ~1 wk BE | ~$10s/mo |
| **3 — Chunk scheduler** | Sims wake every 1–2 h, generate, publish, sleep; chats → memory → next chunk; unpublished-buffer invalidation | **~100+ always-on doublands on the current box**; same-day influence ships | ~1–2 wks BE | $0 |
| **4 — Cost levers** | Routine-step fast path, zero-call sleep, quiet-day cadence (product sign-off), batch where eligible | Sim-day cost from ~$4 to **≤ $1 watched / ≤ $0.2 quiet** — makes the $10–30 plan profitable | ~2–3 wks BE, iterative | $0 (saves) |
| **5 — Browser-free realization** | Movement realization extracted to backend; parity oracle over ~1,000 historical steps as the cutover gate | Chromium gone; **thousands of doublands on cheap boxes**; renderer loses authority over sim truth → enables three.js swap | ~4–6 wks FE | $0 |
| **6 — Fleet-out** | Supabase job queue + worker leases; plain worker boxes; batched Supabase writes per chunk; stateless gateway | Hundreds → **thousands of concurrent sims**; everything horizontal | ~2–4 wks BE | ~$50–100/box/mo |
| **7 — Episode factory** | Episode queue + elastic render pool; per-day clip library with in-day incremental recording; memory retention/partitioning; fleet observability | Thousands of Episodes + POV videos/day; sustainable data growth; fleet visible | ~2–4 wks | GPU workers as needed |

**Ordering rationale.** Phases 2–3 are a few weeks of work on today's hardware and deliver the LIVE-mode product at ~100-doubland scale with viewer capacity effectively unlimited. Phase 4 fixes the economics *before* scale multiplies them. Phases 5–7 are the volume plays, paid for by revenue the earlier phases enable. Every phase is a sized-down slice of the target architecture — nothing built is discarded later.

---

## 3. Implemented

### Phase 0 — 3-sim MVP hardening (shipped & soaked 2026-06-09/10)

- **Shipped:** production frontend build for headless (`npm run build:headless` + `start:headless`, systemd `double-front.service`), Playwright tab reuse (no more full page boot per step), enforced 3-sim capacity cap with overflow queue (a 4th start returns `queued_at_capacity: true` and waits instead of OOM-ing the box), `COMPLETED.json` mkdir fix.
- **Verified:** 3 sims × 100 steps on the VPS, no OOM; light soak profile hit 0.6–1.1 s/step; **full operator runs measure ~7 s/step** — use this for capacity planning until generation is accelerated (open decision, not scheduled).
- **Hardware reality that still governs Phases 2–4:** VPS = 4 vCPU / 3.8 GB RAM, **no swap**. A browser-based sim peaks at ~0.8 GB (oscillates per step) → the box holds **~3 concurrent sims**; **RAM-bound, not CPU** (sims mostly idle-wait on LLM calls). A trailer recording ≈ ~1.5 sim-units and draws from the **same** capacity budget — never co-locate with 3 live sims.
- **Open gaps (tracked, not blockers):** PL-1/2/3 (API cold-start) and PL-6 (resume) **closed 2026-06-11** — `POST /fork` → `POST /start` verified in the wild. **PL-4 closed 2026-06-11** (config: `SIM_LOG_DIR=/var/log/soak` — engine log streamed live on `20260611-3`). **PL-11** (fork tz anchor) **closed 2026-06-11** (`1762fca7`, deployed). **PL-10** (`POST /stop` couldn't stop untracked/API-started sims) **closed 2026-06-15** (`ivan/pl10-stop-via-api`). Still open: PL-5, PL-7, PL-8, PL-9 — **`20260610_parallel_sim_launch.md` §5**.
- Detail: `done/20260608_FE_MVP_hardening.md` (soak data), `20260610_parallel_sim_launch.md` (operator runbook).

### Phase 1 — Cost telemetry (§S.10; implemented & verified 2026-06-10, branch `ivan/cost-telemetry`)

- **Table:** `double.sim_cost_daily` — one row per (simulation_id, sim_day = simulated calendar date): `llm_calls` (excludes embeddings), `tokens_in/out`, `cost_usd`, `embedding_calls` (paid), `embedding_cache_hits` (free), `model_breakdown` jsonb, `steps_generated`. Tokens/cost/breakdown *include* embeddings so totals reconcile 1:1 with `LLM_METRIC` lines. Delta-add semantics (re-generated steps add again — measures actual spend).
- **RPC + view:** `upsert_sim_cost_daily(p_sim_code, p_sim_day, …)` (delta-add upsert, service_role only); `double.sim_cost_fleet_daily` adds `cost_per_step_usd`. Migration: `supabase/migrations/20260610120000_sim_cost_daily.sql`.
- **Hook:** one guarded call in `PerformanceLogger.log_api_call` (`gpt_structure.py`) → `cost_telemetry.record_api_call`; accumulator module `persona/prompt_template/cost_telemetry.py` (thread-safe, strict no-op in non-sim processes). Embedding cache hits sampled at flush from `retrieve_double.get_embedding_cache_stats()`.
- **Flush:** `ReverieServer._flush_cost_telemetry` once per step at step end — fire-and-forget, one retry, merge-back on failure, day-rollover safe.
- **Read path:** `GET /api/simulations/{sim_code}/costs`; sample queries in `supabase/db_reference.md` (Cost Telemetry sections). Sample: `SELECT * FROM double.sim_cost_fleet_daily ORDER BY sim_day DESC, cost_per_step_usd DESC NULLS LAST;`
- **Known-uncounted (accepted):** batch API path (`batch_manager.py`); gateway-side LLM calls (card summaries, chat) — separate later spec; video/TTS.
- **Verified 2026-06-10:** migration applied; 6-step reconciliation smoke (sim `20260610-7`): summed log lines vs DB row matched with max delta **0.010%** (gate: 2%). First real datapoint: ~$0.005/step on planning-heavy early steps.

### Run A — Phase 2 backend publisher + Phase 3 chat-injection slice (implemented & verified 2026-06-10, branch `ivan/step-publish-chat-inject`)

- **Step bundle publisher (Phase 2 BE half):** `reverie/backend_server/step_publisher.py`, hooked at step end in `reverie.py` right after the Supabase-SOT/JSON sinks — publishes the same movements payload (`bundle_version: 1`) plus a `live.json` manifest (`manifest_version, sim_code, latest_step, curr_time, day_number, sec_per_step, owner_timezone, start_date, status, updated_at`). Behind `PUBLISH_STEP_BUNDLES` (default **false**; flag-off runs are fully silent). Bucket `step-bundles` (public; created programmatically at init — no migration); objects `{sim}/steps/{N}.json` (cache 1 yr) and `{sim}/live.json` (cache 30 s); both `upsert: true` so re-generated steps overwrite (a pinned stale bundle would be a correctness trap). Fire-and-forget: one retry, never blocks a step; on bundle failure the manifest is skipped that step and self-heals next step. Public URL: `{SUPABASE_URL}/storage/v1/object/public/step-bundles/<path>`.
- **Scope note:** publish-on-generation; reveal/time-gating stays **client-side** (LIVE-mode DP7) until the Phase-3 scheduler adds publish-time withholding of ahead-of-now steps. FE CDN player (DP7-FE-1…5) and retiring per-viewer gateway polling/realtime are the remaining Phase-2 half.
- **Chat → memory injection (Phase 3 slice):** the gateway chat service now also writes each exchange into `dbl_memory` (`memory_type='chat'`, `node_id=gwchat_{thread}_{n}` — collision-proof vs sim node_ids and retry-idempotent; poignancy 7; keywords both parties; 768-d embedding of the full exchange, stored in `dbl_embedding`). Injection never fails the chat response. `created_at` is insert time (the RPC ignores payload values — true for engine writes too), so an injected chat is the persona's most recent memory: the same-day-influence semantic.
- **Verified 2026-06-10:** 5-step sim `20260610-90` — CDN bundle byte-identical to `movement/1.json`, manifest advanced to `latest_step: 4` with correct cache headers; chat POST → row + 768-d embedding (vector-retrievable); continuation run `20260610-91` loaded **chats=2** (the two injected exchanges; all other personas chats=0); unit tests 11 (publisher) + 7 (injection); movement realism 2/2.

### Run B — Chunk scheduler + reveal-gated publishing (implemented & verified 2026-06-11; merged to `main` & deployed 2026-06-11, `7694f968`)

- **Scheduler:** stateless 60s gateway tick (`api_gateway/app/services/live_scheduler.py`, registered in `background_tasks.start_periodic_tasks`) over `live_mode`-enrolled sims. Per sim: compute the DP7 owner-local reveal edge (anchor = `curr_time − total_steps×sec_per_step`, robust to drift corrections; owner_timezone NULL → UTC), publish bundles `published_step+1 … min(reveal, generated_edge)` (≤120/tick) rebuilt from `get_step_positions`, then wake if generated lead < 30 steps or a `gwchat_` memory arrived after `last_generated_at`. Wake = new `live_chunk_start` task → fresh subprocess `ReverieServer(sim, sim).start_server(60)` — deliberately NOT the `continue_simulation` stdin path (assumes a live process). Wakes capped at min(2/tick, free concurrency slots); skipped entirely at 0 slots.
- **Publishing semantics:** watermark (`simulations.published_step`) advances only after the manifest upload succeeds — partial failures re-upsert next tick; missing step below the edge is skipped, missing step at the edge stops the batch (engine write may be mid-flight). Engine `StepBundlePublisher` self-disables for `live_mode` sims (gateway owns the feed; engine publishing would leak future steps). `is_generating` reads use a 3-min heartbeat TTL so a crashed chunk self-heals.
- **Same-day influence (decision 2026-06-11, Ivan):** small-lead, no rollback — generation never runs far ahead of reveal, so chats influence the next chunk (≤ ~1h worst case; chat also triggers an early wake). A chat landing mid-chunk is picked up by the following lead wake. Rollback of unpublished steps deferred.
- **Migration (applied to remote 2026-06-11):** `supabase/migrations/20260611120000_live_mode_chunk_scheduler.sql` — `simulations.live_mode` + `published_step`, gwchat partial index, `list_live_scheduler_sims`/`set_live_mode`/`advance_published_step` (service-role only). Security Advisor clean; `db_reference.md` + `db_schema.sql` regenerated (confirmed 2026-06-11).
- **Operator surface:** `POST /api/simulations/{sim}/live {"enabled": true}`; `/status/current` now returns `live_mode`, `published_step`, `reveal_step`.
- **Wake-path bugs found & fixed during the live smoke (2026-06-11):** (1) the gateway's temp-runner f-string template evaluated `{backend_path}`/`{e}` at build time (NameError) — every fresh-subprocess API launch had been silently broken (prior soaks used stdin continuation / direct launches); braces escaped + a regression test compiling the generated script. (2) **PL-6 closed:** resuming `ReverieServer(sim, sim)` crashed on missing `environment/{N}.json` and then hung on the step loop's file handshake — resume now loads the **last completed step's** positions from Supabase and **materializes** `environment/{N}.json` from the SOT.
- **Verified 2026-06-11 (live, migration applied):** Security Advisor checks clean (3×0 rows). Full cycle on `20260610-90`: tick published steps 0–4 + watermark; wake → fresh subprocess resumed from step 5 with `📦 STEP_PUBLISH: live_mode — gateway owns publishing` (engine self-disable proven with the publish flag forced ON); 60-step chunk completed and slept; next tick published 61 bundles in one pass, `live.json latest_step=65` with correct sim time (07:35), steps publicly fetchable on the CDN, **step 66 not published** (nothing beyond the edge); un-enrollment via `POST /live {"enabled": false}` confirmed. Unit suites: 40 scheduler/routing + 12 engine publisher tests green. Heartbeat-TTL crash recovery exercised for real (stale `is_generating=true` from a killed process self-healed).
- **Remaining for the phases:** ~~consolidated 100–200-step validation run with mid-run chats + realism/naturalness gates~~ **done 2026-06-12** (`20260612-1` machinery + gates; `20260612-3` P3-1 acceptance). FE CDN player shipped and flipped prod.

---

## 4. MVP phases — full context (Phases 2–3)

### Phase 2 — Publish-don't-serve viewer plane

> **Playback is a game engine, not a video.** Each viewer's browser runs the full game engine. The CDN serves the *recorded reality* — positions, actions, conversations — and the viewer's unique experience (camera, zoom, which character they follow, rewind/replay) is computed entirely on their device. That is why this scales: per-viewer uniqueness costs zero server resources because the shared data is identical and immutable. Rewind/jump-to-any-moment is random-access reads of per-step bundles, which CDNs handle natively.

How playback works at any scale (replaces per-viewer gateway polling + realtime):

1. **Publish on generation.** As the backend completes a step (or chunk), it writes a small static "step bundle" — positions, paths, actions, chat lines; the same ~5–15 KB the player already consumes per step — to object storage behind a CDN. Published = inside the visible window = immutable forever.
2. **One tiny manifest per sim** (`live.json`: current visible step, day metadata), republished each minute with a ~30 s cache life. Players poll the manifest — answered from CDN cache, not our servers.
3. **The player clock-gates locally.** It knows "owner-local now," fetches bundles up to that step, and refuses to show the future. Scrub-back fetches older immutable bundles (CDN-cached). The 6×-catch-up-then-1× behavior from the LIVE-mode doc is purely client-side.
4. **Click-content is precomputed.** Persona details and card summaries are identical for every viewer — generate once at publish time (or first request), cache as artifacts. No per-viewer LLM calls in the viewer path.
5. **What stays on servers:** auth, chat-with-your-double (paid, per-user, metered), operator APIs. The gateway leaves the mass-viewer path entirely; Supabase realtime remains for operator/admin views only.

**Same-day influence fits cleanly:** steps generated *ahead* of "owner-local now" stay unpublished. When a chat must alter today, only the unpublished buffer is regenerated — viewers never see a contradiction because nothing visible ever changes.

**Tooling, cheapest-first:** start with Supabase Storage (built-in CDN) or Vercel's edge cache — zero new vendors, days of work. When monthly transfer crosses ~1 TB, move artifacts to **Cloudflare R2** ($0 bandwidth — at millions of viewers the difference between roughly nothing and thousands of dollars/month). The 38 MB map assets follow the same route.

**Renderer-agnostic by design — Phaser today, three.js 3D later.** Three rules make the engine swap a presentation project instead of a system rewrite:

1. **The published data describes the world, not the drawing.** Step bundles stay renderer-neutral — world/tile coordinates, paths, action descriptions, conversations — as a versioned contract. Phaser-2D and three.js-3D become two renderers over the same recorded reality; they can coexist (2D on low-end devices), and **every already-generated sim replays in the new engine for free**.
2. **Simulation truth must never live inside the renderer** — which makes Phase 5 doubly important. Today, movement realization lives inside the Phaser code; if that is still true at swap time, the three.js port would re-run the entire Phase-5 parity risk inside a new engine. Extract realization first; after that the renderer has zero authority over what happens in the world. The world model stays the discrete tile/zone grid; 3D is a *projection* of it.
3. **Recording is renderer-agnostic too.** The clip-library approach (Phase 7) is "recorded reality + camera script → frames → ffmpeg" — that contract survives the swap. three.js even improves the server side (GPU frame rendering without a full browser). Cinematic 3D raises per-clip render cost and asset sizes — the CDN asset path and GPU render workers absorb both.

**Sequencing implication:** do the engine swap **after Phase 5** — then it is a frontend/art project with no simulation risk, and a major Episode-quality upgrade rather than a re-platforming gamble.

### Phase 3 — Chunk scheduler + same-day chat injection

An "always-on" doubland does **not** need a resident process. A scheduler wakes each sim every ~1–2 hours, generates the next 60–120 steps, persists + publishes, and puts it back to sleep. At **~7 s/step** that chunk costs ~7–14 min of wall time; a full sim-day (1,440 steps) ≈ **2.9 h** of compute — revisit if generation is accelerated. Consequences:

- **One generation slot serves ~25–30 always-on doublands at ~7 s/step** (would be ~100–150 at ~1 s/step). The current 3.8 GB box (3 slots) supports chunk-scheduled always-on — browsers only run while a chunk is generating, so at most 3 are alive at once.
- **Chunk size is the same-day-influence dial.** A user chat is written into the double's memory; the next chunk picks it up. 1–2 h chunks ⇒ influence visible within 1–2 h ("within hours" ✓). If a chat invalidates already-generated-but-unpublished steps, the wasted regeneration is bounded by one chunk. (Widening the chunk toward "absorbed overnight" is a product dial, not a rebuild.)
- **Owner-timezone staggering** (06:30 local start) spreads generation load around the clock for free.

> **Phases 4–7 detail moved to `TODO_post_mvp.md` § Scale roadmap (2026-06-15).** The bottleneck map (§1), the staged build-up table (§2), and the guardrails (§5 below) keep the high-level rationale and target architecture; the actionable phase detail now lives in the post-MVP doc. **Phase 4 is gated behind `TODO_post_mvp.md` P1** (behaviour before cost tuning).

---

## 5. Guardrails

**What NOT to build (yet):**

- **No Kubernetes, microservices, or dedicated queue tech (Redis/Celery).** Supabase job rows + plain worker boxes carry this to thousands of sims.
- **No per-viewer WebSocket infrastructure.** The CDN-manifest pattern replaces it; realtime stays for operator/admin views.
- **No multi-region generation.** One generation region + a global CDN serves worldwide viewers fine.
- **No premature database sharding.** Write batching + retention + partitioning inside Supabase first.
- **No on-server episode rendering.** Episodes stay off the generation fleet permanently.

**Risks to keep in view:**

- **Don't scale the shared-frontend model by adding machines** — without per-worker isolation, more machines hitting one frontend just move the contention.
- **Don't co-locate episode recording with active generation** until dedicated render capacity exists — this is the failure that prompted this doc.
- **The post-MVP `sot_sim.md` world model doesn't solve rendering** — it addresses where world facts live, not how movement is realized. The browser dependency must be tackled directly (Phase 5).

---

## 6. Resolved decisions & surviving FE facts

**Resolved (2026-06-10):** render tier split from generation (episodes off-fleet, permanent) · browser-free path is **scheduled** (Phase 5), no longer an open bet · process-per-sim bridge superseded by chunk scheduling (Phase 3) · Supabase-first done for single-host, multi-host remainder lands in Phase 6 · queue = Supabase-backed, revisit only if measured throughput demands · orchestrator = minimal queue + leases first (Phase 6), control plane only with a multi-box render fleet (Phase 7).

**FE facts worth remembering (2026-05-15 investigation, `double-front`):**

- One `next` process safely backs **8–16+ headless browser contexts** — all sim state is per browser realm (`window.__*`, client-bundle singletons); the Next.js server holds no sim state. Pooling is structural, no FE change needed.
- **Per-step cost is dominated by page boot + collision-chunk preload**, not A\* (<1 ms) or animation (~30 ms at 100×). Tab reuse (shipped, Phase 0) and chunk-cache amortization are the levers; per-step telemetry lives in `window.__headlessMetrics`.
- **Headless speed default is 100×** (`lib/headlessConfig.ts`), runtime-overridable via `window.__headlessSpeedMultiplier`.
- **Long-lived tabs need eviction** for `claimedTiles` and `safetyDeferralEvents` (never trimmed per step); Redux/chat buffers are already capped.
