# FE Phase 2 — CDN viewer plane: implementation report (FE → BE)

**From:** Ivan (FE implementation) · **Date:** 2026-06-12 · **For:** BE team / Nicolas
**Status:** FE half **implemented** on `double-front` branch `ivan/cdn-player` (commits `4a8c59f` CDN player, `95a4c09` Tier-3 UX, `edcc950` clock parity fix). Not merged, not deployed — pending acceptance run on a live-enrolled sim (§7) and the BE TODOs (§8).
**Replaces:** the original BE→FE handover of the same filename (recoverable via git history of this file).
**References:** `TODO_production_hardening.md` §3–4 (Phase 2) · `20260609_LIVE_mode.md` DP7 · worklog 2026-06-12.

---

## 1. What was built

The browser viewer can now run entirely off the published CDN artifacts: it polls `{sim}/live.json` (45 s), fetches `{sim}/steps/{N}.json` bundles for replay batches, LIVE prefetch, scrub jumps, and hover previews, and clock-gates locally with the unchanged DP7 reveal logic. In this mode the viewer opens **zero** Supabase realtime channels and makes **zero** per-viewer gateway calls for steps/status.

Three new FE modules form the seam:

| Module | Role |
|---|---|
| `lib/viewerSource.ts` | Source selection: `NEXT_PUBLIC_VIEWER_SOURCE=cdn\|gateway` env flag, `?source=` per-session override, per-sim gateway fallback (§3) |
| `lib/cdnViewer.ts` | Manifest + bundle client: validation, tile→pixel conversion, LRU cache (200 bundles) + inflight dedupe; emits the **exact** `getStep`/`fetchSteps` output contracts |
| `lib/viewerSteps.ts` | Routing functions (`viewerGetStatus/GetStep/FetchSteps`) used by every step/status consumer: `usePlayback` batches + prefetch, `liveStepBuffer` (LIVE), `useSimulation` load/warmup, `useStatusPolling`, timeline hover previews |

Everything else consumes these; no rendering/Redux/Phaser contract changed. Renderer-agnostic rule respected: the FE only ever interprets world data (tiles, paths, descriptions, conversations) from the bundles.

## 2. Key implementation decisions

1. **Flag default is `gateway`.** With the env var unset, every seam delegates to the identical pre-CDN gateway/Supabase calls — deploying the branch changes nothing until the var is set on Vercel. Rollback = unset the var. (Decision confirmed with Ivan 2026-06-11.)
2. **All conversion happens client-side, pinned to gateway parity.** Bundles are raw tiles (the movement payload); the gateway REST `/step/{n}` serves pixels. The FE mapper reproduces the gateway transform exactly — unit tests pin against the real `/step/5` response of `20260611-3` (e.g. tile `[106,39]` → px `[3408,1264]`; `target_zone` px + `target_zone_tiles` preserved).
3. **Path priority `actual_path` > `path` > stationary** — same rule as the Supabase RPC replay branch, so the parser covers **both bundle writers** (engine publisher emits `path`; gateway scheduler rebuilds may carry `actual_path`). `bundle_version: 1` and `manifest_version: 1` are validated hard; unknown versions throw rather than guess.
4. **Manifest → `/status/current` mapping**: `total_steps = latest_step + 1`, `current_step = latest_step`, clock fields (`owner_timezone`, `start_date`, `sec_per_step`, `day_number`) pass through, `websocket_available: false`. This let `loadSimulation`/`useStatusPolling` consume the manifest unchanged — `revealStep.ts` needed **zero logic changes**, exactly as the handover predicted. Unknown manifest `status` values map to `running` (see TODO 6).
5. **Manifest poll cadence 45 s** (inside the 30–60 s window); gateway mode keeps 10 s. The poll also feeds `latestStepTimestamp` (clock pill / timeline end label) from manifest `curr_time` — replacing the retired `sim-step` realtime channel (`edcc950`).
6. **LIVE edge guard skipped in CDN mode.** The legacy 2-step guard protected against half-written steps on REST; per Run B watermark semantics ("`published_step` advances only after the manifest upload succeeds") a published step is committed, so the LIVE loop consumes up to `min(latest_step, reveal_step)` directly. **This leans on the watermark guarantee — flag immediately if that semantic ever weakens** (TODO 5).
7. **Per-sim gateway fallback on manifest 404.** Pre-Phase-2 sims have no bundles; with the flag globally `cdn`, a missing manifest marks that sim gateway-served for the session (loud console warning) instead of breaking history. Non-404 CDN errors propagate — no silent fallback that would mask CDN outages.
8. **In-memory caps**: raw-bundle LRU bounded at 200; existing Redux/chat caps untouched. (`claimedTiles`/`safetyDeferralEvents` eviction for long-lived tabs remains the known open item — unchanged by this work.)
9. **QA bypasses kept**: `?raw=1` / `?capNow=` work as before. As designed, for live-enrolled sims `?raw=1` can only reveal what's on the CDN; raw inspection of just-generated steps stays a gateway-side operator tool (`?source=gateway&raw=1`).

## 3. What is retired in CDN mode (and only in CDN mode)

Per-viewer traffic gated off when the source is `cdn` — gateway mode runs the exact pre-CDN code paths, nothing was deleted:

- Supabase realtime channels: `coords-{uuid}`, `sim-step-{sim}`, `carried_objects_{uuid}`, `maze-expansions-{id}`
- Gateway WebSocket + the legacy meta polling loop (`useRealtime`)
- Supabase RPC playback branch in `usePlayback` (bundles are the batch source) and the clock-meta enrichment RPCs on load
- File-watcher auto-set (both viewer pages)
- **Browser-side observation POSTs** (`/observations` movement + proximity reports). The headless generation run is the spatial authority (`sot_be-fe.md`); per-viewer reports were redundant writes that could not scale. **BE: confirm nothing consumes browser-origin observation rows** (TODO 7).

**Still gateway-served for CDN viewers** (request-driven click-content, per handover scope): auth, chat-with-your-double, persona details, card summaries, `sprite-manifest`, `day/{n}/highlights`. These are the "publish click-content as artifacts" follow-up (TODO 3).

## 4. Behavior deltas in CDN mode (accepted, reviewable)

| Delta | Detail | Verdict |
|---|---|---|
| LIVE edge latency | Realtime pushed steps within seconds; manifest poll discovers them every ≤45 s. At the 1 step/min edge mostly invisible; a viewer can run up to ~45 s further behind owner-now | Accepted (poll can drop to 30 s if wanted) |
| Carried objects static | Load once via RPC; no realtime updates, bundles don't carry them | Accepted MVP gap — real fix is object state in bundles (TODO 4) |
| Maze expansions | No live refresh for viewers (admin-triggered, rare; admin views unaffected) | Accepted |
| Status text | "Live (Polling / Reconnecting…)" instead of "Connected" | Same as today's prod HTTP-only mode |
| LIVE timeline event markers | Not accumulated during LIVE | Same as today's prod (they were WS-fed only) |

## 5. Tier-3 UX fold-in (also in this branch)

- **Issue 3** — auto-follow now **opt-in** (defaults `false` in `uiSlice`, `MainScene`, `CameraController`). Trailer/`?recording=true` verified unaffected: the Director API drives the camera via the tracking path (`__followPersona` → `startTracking`), never idle centroid follow. *(Applies in both viewer sources.)*
- **Issues 7 & 8** — were already closed on `main` (`ca60123`, `32ede66`); verified, no changes needed.
- **`stopped` semantics** — `lib/playbackSemantics.ts` separates `isGenerationIdle` (stopped/completed) from `isTimelineExhausted` (step-based); unified at the timeline 100%-pin (now also covers `completed` sims) and the event-marker click handler.
- **`?step=N` smoke** — `resolveInitialViewerStep` extracted to `lib/replayUrl.ts` + 9 Vitest cases (reveal-ceiling clamp, legacy `?step=`, `?raw=1`, embed exclusion). Browser-level Playwright smoke deliberately stays backlog (repo has no Playwright test infra; decision 2026-06-11).

## 6. Verification done

- **Unit/contract**: +58 passing tests vs `main`, 0 new failures, 0 new tsc/lint findings. Bundle parsing validated against real fixtures from `20260611-3` (engine-published) with gateway-parity pixel assertions; manifest mapping, source routing, 404 fallback, LRU/dedupe, CDN edge-guard skip all covered.
- **Network smoke** (`scripts/cdn-smoke.mjs`, real CDN + dev server, `20260611-3?source=cdn`): **PASS** — 22 bundle + 8 manifest fetches from CDN, **0** disallowed gateway requests, **0** realtime sockets, LIVE loop advancing from bundles (step 98→102 over 60 s).
- **Not yet verified**: parser against a **gateway-scheduler-rebuilt** bundle, and the full live-enrolled acceptance (catch-up → 1× at edge → scrub → JTL with server-side reveal gating) — both blocked on `20260612-1` publishing (TODO 2).

## 7. Acceptance checklist (run once TODO 1–2 land)

`node scripts/cdn-smoke.mjs 20260612-1` + a manual pass on `/simulations/20260612-1?source=cdn`:

1. Open → catch-up → LIVE 1× at edge → scrub back → jump-to-live, with no gateway/realtime traffic except the allowlisted content endpoints (§3)
2. Manifest poll ≤60 s cadence; `latest_step` never exceeds owner-local now (server gating) and the FE clamp agrees ±1 step
3. Reveal cap behaviour identical to gateway mode on the same sim; `?raw=1` shows at most the CDN content
4. Completed-sim replay works from bundles alone (kill the gateway locally to prove it)
5. Parser handles a gateway-rebuilt bundle (chat lines, `actual_path`) — extend `__tests__/fixtures/cdn/` with one once available

After sign-off: flip `NEXT_PUBLIC_VIEWER_SOURCE=cdn` on Vercel; after a soak, retire the gateway viewer path + flag per the original plan (don't leave both alive longer than the transition).

### §7 results (run 2026-06-12 against `20260612-1`, live during catch-up + post-un-enroll)

| Item | Verdict | Evidence |
|---|---|---|
| 1 — catch-up → 1× at edge → scrub → JTL | **PASS with documented gap** | Catch-up LIVE loop: `cdn-smoke.mjs` PASS (36 bundles + 9 manifests CDN-only, 0 disallowed gateway, 0 realtime sockets, steps 386→390). Scrub + return: `cdn-scrub-audit.mjs` PASS (seek −100 fetched from CDN, edge return served from LRU cache). **Gap:** true 1× at the reveal edge + JTL on a real-time-paced sim was not re-run — the sim was un-enrolled (post-bomb-demo) while still in catch-up pacing. Accepted for MVP per Ivan (2026-06-12) on the strength of DP7 item-2 PASS on `20260611-2` (same reveal logic, zero changes in CDN mode) + the catch-up LIVE-loop evidence. **Re-verify 1×-at-edge + JTL during a short window on the next live-enrolled sim.** |
| 2 — manifest poll ≤60 s; server gating; FE clamp ±1 | **PASS (gating observed), clamp re-check with item 1 gap** | 45 s poll cadence observed in smoke; gateway status during the run showed `reveal_step: 453` < `current_step: 459` (server-side gating active). FE-clamp ±1 agreement deferred to the same next-live-sim window. |
| 3 — reveal cap parity + `?raw=1` | **PASS (pre-acceptance evidence)** | Reveal logic unchanged between sources (`revealStep.ts` untouched, §2.4); `?step=N`/`?raw=1` covered by the `lib/replayUrl.ts` unit suite + `95a4c09` smoke. No CDN-specific delta observed. |
| 4 — completed-sim replay, gateway killed | **PASS** | `cdn-completed-replay.mjs` on `20260612-1` after un-enroll, local gateway down: load → seek 250 → play advances 250→253 in 30 s (Standard Playback 1 step/10 s) → scrub to 100; 23 bundle fetches, 0 gateway, 0 sockets. Bonus: terminal manifest from PL-12 verified live (`status: "completed"`, `latest_step: 507`). |
| 5 — second-writer bundle fixture | **PASS (writers swapped per §10)** | `20260611-3` fixtures are the gateway-rebuilt writer; added **engine-published** fixture `engine-step40.json` (`20260610-90` step 40): `path: null` + engine-only fields (`realism_trace`, `stationary_intent`, `pronunciatio`); 3 new tests, suite 19/19. Note: all 65 published `20260610-90` steps are stationary — engine-writer chat/walking coverage rests on shape identity between writers. |

Cache headers re-verified with **GET** per §10.1: bundle `max-age=31536000`, `live.json` `max-age=30` — §8.1 closed, no BE change needed.

## 8. TODO requests for the BE team

1. **Fix CDN cache headers (blocks the scale property).** Every `step-bundles` object — bundles *and* `live.json`, both sims checked — currently serves `Cache-Control: no-cache` instead of the documented 1-year-immutable / 30 s. The publishers' `cacheControl` isn't reaching the storage response. Until fixed, every viewer request hits Supabase storage origin: functionally fine, but "zero load at a million viewers" does not hold. (FE deliberately sends plain `fetch`, so the fixed headers will be honored by browser + CDN with no FE change.)
2. **Publish `20260612-1`** (or any live-enrolled sim): as of 2026-06-12 it has no bundles/manifest on the CDN. Needed for the acceptance checklist (§7) and the dual-writer parser validation.
3. **Click-content as published artifacts** (next Phase-2 slice): `sprite-manifest`, `day/{n}/highlights`, persona details / card summaries → static CDN artifacts generated at publish time. These are the only non-auth/chat gateway calls a CDN viewer still makes. Suggested order: `sprite-manifest` first (fetched on every viewer load), highlights second.
4. **Carried-object state in bundles** (or explicit acceptance of the gap): CDN viewers see carried objects frozen at load time. If the feature matters for LIVE viewing, add object state to the bundle payload (renderer-agnostic: object name + holder + tile).
5. **Confirm the watermark guarantee is contractual.** FE consumes published steps with no edge guard on the strength of "manifest advances only after its bundles upsert" (Run B). If a writer ever violates this, FE must re-add the guard.
6. **Document the manifest `status` value set.** FE maps known values (`running/stopped/paused/completed/error/loading`) and defaults unknown → `running`. Related: an aborted sim (`20260611-3`) reports `status: "running"` with a frozen `updated_at` forever — viewers will sit in LIVE "waiting" indefinitely. Either publish a terminal status on abort, or tell FE to apply an `updated_at` staleness heuristic.
7. **Confirm nothing consumes browser-origin `/observations` rows.** CDN viewers no longer POST movement/proximity reports (headless generation is the authority). If any analytics/realism tooling reads browser-mode reports, it should be told.
8. **PL-11 reminder (pre-existing, surfaces here):** the chunk-scheduler wake path skips the `DEFAULT_OWNER_TIMEZONE` bootstrap — `20260611-3`'s manifest shows `owner_timezone: null`. Null tz makes the FE reveal clock fall back to UTC: fine for QA sims, wrong for owner-local reveal on real ones.

## 9. Usage quick reference

| Need | How |
|---|---|
| Enable CDN player | `NEXT_PUBLIC_VIEWER_SOURCE=cdn` (env) — prod rollback = unset |
| Force per session (QA) | `?source=cdn` / `?source=gateway` on any viewer URL |
| Raw generation edge (operator) | `?source=gateway&raw=1` (CDN + raw shows only published content) |
| Freeze reveal "now" (QA) | `?capNow=<ISO>` (dev builds), unchanged |
| Old sims without bundles | automatic per-sim gateway fallback, console-warned |
| Headless / recording | always backend-driven via the gateway path, flag ignored |
| Network smoke | `node scripts/cdn-smoke.mjs <simCode> [baseUrl]` (needs `npm i --no-save playwright` + `npx playwright install chromium`, dev server running) |

---

## 10. BE response to §8 (BE agent · 2026-06-12)

Per-item, all verified live against the real bucket today:

1. **Cache headers — false alarm, no BE change needed.** The `no-cache` you saw comes from **HEAD** requests (`curl -I`) — a Supabase storage HEAD-handler quirk. Real **GET**s (what browsers/CDNs send) return the documented headers and are already edge-cached: step bundle → `Cache-Control: public, max-age=31536000` + `CF-Cache-Status: HIT`; `live.json` → `public, max-age=30` + `HIT`. Object metadata confirmed (`cacheControl: max-age=31536000`). Re-test with GET; the million-viewer property already holds.
2. **`20260612-1` publishing** — that sim *is* today's Phase-3 validation run (`20260612_validation_runbook.md` § IVAN): it will be forked with a real tz (PL-11 fix), live-enrolled, and gateway-published. Run §7 acceptance against it once enrolled — one sim closes both gates.
3. **Click-content artifacts** — agreed as the next Phase-2 BE slice; `sprite-manifest` first, highlights second. Not yet scheduled.
4. **Carried objects in bundles** — product call for Ivan; gap accepted for MVP unless he says otherwise.
5. **Watermark guarantee — confirmed contractual.** Run B semantics: `published_step` advances only after the manifest upload succeeds; a missing bundle at the edge stops the batch. Keep consuming without the edge guard. Follow-up: record this + the bundle/manifest contract in `sot/sot_api.md` (currently absent there).
6. **Frozen manifest on abort — confirmed real** (`20260611-3` `live.json`: `status:"running"`, `updated_at` frozen at 2026-06-11). BE bug, tracked as **PL-12** (`20260610_parallel_sim_launch.md` §5): un-enroll/abort must publish a terminal manifest. Until it ships, an `updated_at` staleness heuristic (status `running` + manifest older than ~10 min ⇒ treat as stalled, fall to DP6 surface) is a reasonable FE belt-and-braces — your call.
7. **Browser-origin `/observations` — confirmed safe to retire.** The only consumer is the engine's step loop (per-sim pending queue read during generation; processed entries archived for forensics; realism tooling reads `personas_coords`, never observations). Retiring viewer POSTs is actually a correctness *improvement* — a browser viewer watching a generating sim could previously inject movement reports into the live queue.
8. **PL-11 — stale, already fixed & deployed** 2026-06-11 evening (`1762fca7`): `POST /fork` anchors `owner_timezone` (request field or `DEFAULT_OWNER_TIMEZONE` env) and reports it in the response. `20260611-3` is a pre-fix artifact and stays un-enrolled; new sims carry the tz from fork.

**One correction to §6:** `20260611-3` was live-**enrolled**, so all 117 of its bundles were published by the **gateway scheduler** (the engine self-disables for live sims). Your fixtures therefore already cover the gateway-rebuilt writer; the writer still *missing* from your fixture set is the **engine-published** one (non-live sims with `PUBLISH_STEP_BUNDLES=true` — e.g. `20260610-90`'s Run-A steps). Same shape contract either way, but grab one engine-published fixture before sign-off.

---

## 11. BE update — TODO 3 shipped (Step 6a · 2026-06-12)

Click-content artifacts are now published to the same bucket (`branch ivan/cdn-click-content`):

| Artifact | URL | Cache |
|---|---|---|
| Sprite manifest | `.../step-bundles/{sim}/sprite-manifest.json` | `public, max-age=300` |
| Day highlights | `.../step-bundles/{sim}/highlights/{day}.json` | `public, max-age=300` |

**FE wiring is one line per fetch:** both bodies are **byte-identical to the REST responses you already parse** (`/{sim}/sprite-manifest`, `/{sim}/day/{day}/highlights`) — fetch CDN-first, keep your existing per-sim gateway fallback on 404 (pre-feature sims, dev sims, days whose highlights aren't generated yet; no backfill job). They are **mutable** (5-min cache), unlike step bundles. Sprite manifest publishes on live enroll (+ scheduler backfill); highlights publish at each day close. Persona detail cards stay gateway-served (deferred). Full contract: `sot/sot_api.md` §9.
