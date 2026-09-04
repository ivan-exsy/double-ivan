# TODO — Post-MVP backlog (prioritized)

> **Updated:** 2026-09-03. Village gather + town talk is **closed**. Score trail: `double-ivan/done/20260910_launch.md`. This file is the living post-MVP backlog. Video craft stays in `double-ivan/video/TODO_video.md`. “That’s me” charter stays in `double-ivan/TODO_realism_matriAIx.md`.
>
> **Renamed from `TODO_be_debt.md` on 2026-06-11.** Triaged against `20260609_LIVE_mode.md` and `TODO_production_hardening.md`: LIVE-mode items moved there; dead items closed (log at the bottom). This doc holds **only work not tracked elsewhere**, in priority order.
>
> **Sequencing rule (agreed 2026-06-11):** hardening Phases 2–3 proceed independently of everything here. **P1 items must land before Phase 4 (cost levers)** — change agent behaviour first, then optimize its cost, so we don't tune twice.

---

## Current state (2026-09-03)

**Village MVP (gather + town talk) is done.** Do not treat the June “3-sim hardening” spine or this file’s older P1 conversation list as the village gate. Those were different bars.

**Now live — do not re-open as post-MVP blockers**

| Item | Proof |
|---|---|
| Bodies stay on the last honest tile (tab-reuse snap) | `20260903-2` @31; box FE `vercel` @ `14dc6ce`; `HEADLESS_TAB_REUSE=true` on localhost |
| Challenge / vote occupancy | 1-B `20260829-1` + leftover cafe stay-keep `20260903-1` (H2 = 0, day-1 11:00 **15/15**) |
| Cafe talk mill + leftover KEEP + stance thought | 2b mill 0; 2B `20260901-1`; 3b `20260902-3` (4 Doubles is enough) |
| Overlay sit + elim | `20260902-4` @2399 |
| Drain / clean restart (launch 7a) | Box `railway` @ `24cc9d94` / drain code `6a9cbd22`; SIGTERM finishes the current minute then `stopped`; `TimeoutStopSec=960`; `KillMode=mixed`; HTTP `127.0.0.1:8001` |
| Backend-table RLS (launch 7c) | Applied on `double-openrouter`, migration `20260903174000` |

**Cut during village — not backlog:** linger, Shepard sleep booking, cafe `study` widen, fire-when-12, fail-closed thin room, longer pins / all-morning curfew, H3 never-sit dest rewrite. Rationale in the archived launch §Decisions Closed.

**Ignore these June facts if they disagree with the box today:** VPS is Hetzner HTTP `127.0.0.1:8001` (not Fozzy TLS `api.ondouble.com`); systemd unit is `api-gateway` (not `double-api`); box FE is branch `vercel` @ `14dc6ce` (do not `git checkout main` on that box). `PM-LIVE-1` (`sleeping` status) already shipped 2026-06-22.

---

## From village launch (moved 2026-09-03)

Clear post-MVP items that lived in `double-ivan/done/20260910_launch.md`. Detail papers stay where they are; this table is the index.

| ID | Item | Status | Notes |
|---|---|---|---|
| **PM-VIL-1** | Seek (everyday + multi) | **Hold** | Own occupancy bet. Satiation is load-bearing. Do not turn seek on to “finish” village. Prior plan (will / linger / seek / sofa / fourth wall): `done/20260825_true_doubles.md` from “Plan: Will, linger, seek”. Linger was later **cut**. |
| **PM-VIL-2** | “That’s me” / quiz twin | Open | Compile quiz/interview into short if–then scene lines; measure express *and* suppress; interview as evidence; human recognition before any public “scientifically you.” **Charter (living):** `TODO_realism_matriAIx.md`. Research KB (not an implement brief): `done/20260825_true_doubles.md`. No paper we reviewed is a proven twin. |
| **PM-VIL-3** | Talk Path A (you ↔ one Double) | Open | Talk tab cadence + anti-loop. Village talk does not prove this. Village leftover process packet (KEEP wave, now Current): `done/20260901_chat_realism.md`. |
| **PM-VIL-4** | Acting-model swap | Parked | Only if village still sounds like one writer after compiled lines. |
| **PM-VIL-5** | Official Naturalness Gate pair, display-honesty probe, MatrAIx catalog / MBTI / fine-tune on private messages | Parked or banned | As in the charter. Do not transplant the MatrAIx catalog. |
| **—** | Daily trailer leftover craft | Open elsewhere | `double-ivan/video/TODO_video.md`. Episode 1 closer auto-gen benchmark is locked. Not a village gate. |

**Parked village watches (not ranked):** new `session=` after a real sit-stop at cafe; action-text leftover on late walk-ins (re-score only if a resolution rewrite returns); optional first 15-person score with tab reuse on (confidence).

---

## Infra hygiene — survival mode as a per-sim field, not a global env flag *(added 2026-06-15; non-blocking)*

**PM-SURV-1.** Move the survival on/off decision (and ideally `total_days`) from the server-global `SURVIVAL_MODE_ENABLED` env flag to a per-sim column on `double.simulations` (mirrors the existing `live_mode` field), read at engine boot instead of the env.

**Why.** Survival-vs-normal is a property of *one sim*, decided at creation — but an env flag is a property of the *server*, so today the whole box is locked to one mode and a survival sim can't run beside a normal one. The flag also lives only in the launched process's environment (each live chunk re-reads `.env.local` from disk), so it drifts silently on a file edit or restart with no audit trail. The survival *game* state already lives in Supabase; the on/off *intent* belongs next to it (Supabase-is-SOT).

**Scope.** One boolean column (default `false` — opt-in); engine reads the sim's row instead of the env at `reverie.py:279`; fork / live-enroll sets it. Optionally migrate `total_days` too (same drift class — `20260613-1` ran with the code default 15, not the intended 3). Retire the env flag as the source of truth; optionally keep it only as a global emergency kill-switch.

**Fit.** Directly enables the Phase-6 fleet-out goal of many mixed sims per box. **Not** the cause of the `20260613-1` survival stall — that was a separate owner-timezone datetime bug in the proximity-observation path (fixed 2026-06-15); this item surfaced during that diagnosis.

---

## Generation-host resilience — sim/Chrome process isolation *(added 2026-07-23; from `20260720-1` OOM RCA)*

**PM-INFRA-1.** **Full split:** run the sim engine (reverie + Playwright/Chromium headless children) **outside** the `api-gateway` systemd cgroup / process tree — API only signals start/stop/status; a separate supervisor owns the sim process and its browser.

**Why.** On `20260720-1`, OOM killed Chrome inside the gateway unit → systemd restarted the API → sim did **not** come back; status stayed falsely “running/generating” for ~15h. Headless Phaser validation stays product-required; isolation does not remove Chrome — it **contains blast radius** so a browser OOM cannot take down the control plane.

**Already shipped (2026-09-03, launch 7a) — not a substitute for the full split:** SIGTERM drain finishes the current minute then marks `stopped`; gateway waits 15 min; `TimeoutStopSec=960`; `KillMode=mixed` on `api-gateway` and `double-front`. Unit name is `api-gateway`, not `double-api`. Do not restore the old 30s kill.

**Scope (full split — still open):**
- Stop spawning reverie via in-process `subprocess.Popen` under uvicorn as the long-term path.
- Introduce a dedicated supervisor (`double-sim@.service`, `systemd-run` scope, or small worker daemon) that owns `temp_runner` / reverie + Chrome grandchildren.
- API becomes a client: enqueue/start/stop/lease via Supabase or local IPC; read status from SOT + process heartbeat.
- Optional: `MemoryMax` on the sim slice only; API slice stays small and restartable independently.
- Auto-resume / stale-`is_generating` reconciliation when the API restarts but the sim slice died (or vice versa).

**Fit.** Prerequisite-friendly for **Phase 6 fleet-out** (stateless gateway + queued sim jobs). Complements near-term ops (screenshot off/sample, swap, Chrome recycle) and **Phase 5 browser-free realization** (which removes Chromium from the hot path entirely — isolation still useful for whatever heavy child remains). Ref: `20260720-1_RCA.md` §4 / §12.

**Effort / risk.** Higher than a unit-file tweak (several days eng + ops); medium risk around start/stop/resume/log paths. The 7a drain/`KillMode=mixed` work is the interim; do not treat it as the full split.

---

## Infra hardening *(added 2026-07-24; post-MVP — VPS + public API, not Vercel)*

Keep **landing + viewer on Vercel** and **generation + API gateway on the sim VPS**. Do **not** put Cloudflare (or a second CDN) in front of Vercel for “security” — Vercel already is the public edge. Harden the box and the API surface instead.

| ID | Idea | Why it matters |
|----|------|----------------|
| **PM-SEC-1** | **Admin via Tailscale (or similar); no public SSH** | Biggest cheap win. Keys only, one key per device; close provider SSH from the open internet once Tailscale SSH works. |
| **PM-SEC-2** | **Tight VPS firewall** | Allow only what production needs inbound (HTTPS to the gateway for Vercel proxies / public read APIs). Drop everything else; keep headless FE on localhost. |
| **PM-SEC-3** | **Optional shield on `api.ondouble.com` only** | Cloudflare (or equivalent WAF/rate-limit) in front of the **API hostname** if abuse shows up — not in front of `ondouble.com` / Vercel. |
| **PM-SEC-4** | **Public API abuse controls** | Rate-limit + bot checks on waitlist and other unauthenticated routes; keep sim start/stop/control behind auth. |
| **PM-SEC-5** | **Write the security model down** | Short note in the VPS deploy runbook: what is public, what is Tailscale-only, what agents must not “fix” (open ports, bind services to `0.0.0.0`, disable firewall). |
| **PM-SEC-6** | **Backups before new services** | Provider snapshots + tested restore of `.env.local.vps-prod` / critical config; don’t add new daemons until restore is boring. |

**Out of scope here:** moving FE/landing onto the VPS; Caddy+SQLite “whole product on one box”; Claude-in-tmux as the primary production admin path. Those fight the current Vercel + VPS + Supabase split.

**Fit.** Complements **PM-INFRA-1** (blast-radius isolation) and Phase 6 fleet-out. None of these block MVP ship; do them before treating the VPS as a multi-tenant always-on fleet.

---

## 🔑 Top economic priority — unit cost per doubland-day *(= hardening Phase 4; recorded here for ranking)*

**The issue.** A fully-watched ~15-double sim-day costs **~$2–7 in LLM calls (~$60–200/mo always-on)** against a **$10–30 admin price → 5–10× underwater**. Cost scales with *doubles × minutes thought*; no server/infra choice fixes it — only how much the sim thinks.

**Confirmed against the real OpenAI bill (2026-06-15).** The `20260613-1` live soak (small ~4–5-double family cast, paced to real time) billed **$0.30 / $0.88 / $0.47** on Jun 13/14/15 ≈ **$0.0007–0.001/step average** — consistent with the measured **$0.005/step planning-peak** (the bill average sits below it because most steps are cheap routine/sleep, and live mode spreads ~1,440 steps across a real day rather than burning them at once). Absolute dollars are tiny at this scale. *(The OpenAI bill runs slightly above our `sim_cost_fleet_daily` telemetry — it also includes gateway card-summaries, chat, and dev calls the telemetry doesn't count.)*

**Verdict / urgency.** **NOT launch-blocking** — at demo/early scale it's a few hundred dollars/month total, easily absorbed. **Scale-blocking** — every new always-on paying doubland loses money until this is fixed; must clear it *before* opening to many paying doublands, not before shipping.

**Fix.** The Phase-4 cost levers — routine-step fast path (3–5×), zero-call sleep (~1.3×), quiet-day cadence (needs Ivan sign-off), caching + token trims — full spec in **§ Scale roadmap → Phase 4** below (moved here from the hardening doc 2026-06-15). Target **~$0.5–1 watched / ~$0.1–0.2 quiet per day ≈ $5–15/mo per doubland — inside price.** All levers tuned against the live Phase-1 telemetry, not estimates.

**Where to start — ranking against the backlog:** this is the **#1 economic item**, but it is deliberately **gated behind P1 below** (finalize agent behaviour first, then tune cost once — the sequencing rule above). So execution order is **P1 conversation-quality → Phase 4 cost levers.** Nothing here precedes P1.

---

## LIVE mode — `20260611-2` QA follow-ups *(2026-06-12; **DP7 closed** — 4/4 PASS)*

Full sign-off table: `20260609_LIVE_mode.md` § QA.

### Post-MVP follow-ups

| ID | Item | Owner | Status |
|---|---|---|---|
| **PM-DP7-1** | `owner_display_name` on sim metadata + `/status/current` | BE | open |
| **PM-DP7-2** | Wire owner name into `OwnerClockStrip` | FE | open (blocked on PM-DP7-1) |
| **PM-DP7-5** | Server-side reveal enforcement (DP7-BE-5) | BE | open — also P2 below |
| **PM-DP7-6** | 18:30 Episode cron (DP7-BE-4) | BE | open |
| **PM-ROUTE-1/2** | `doubland.ai` routing + landing embed sim | Infra | open — Ivan: manual embed swap OK for now |
| **PM-CDN-1** | Carried-object state in step bundles (CDN viewer) | BE | open — **MVP gap accepted 2026-06-12** (`20260612_todo.md` Step 6b): CDN viewers load held objects once at page open; publish object name + holder + tile per step in bundles for step-accurate LIVE/replay. Ref: `20260612_FE_phase2_handover.md` §4, §8.4. |
| **PM-LIVE-1** | Distinct `sleeping` status for live sims between chunks | BE | **done 2026-06-22** — migration `20260622120000_live_mode_terminal_guards.sql`; chunk exit → `sleeping`; scheduler wakes `running`/`sleeping` only; `completed`/`stopped` auto-unenroll. Ref: `20260622_openai_live_mode_leak.md`. |

---

## P1 — Before hardening Phase 4 (behaviour changes first)

Village mill / leftover KEEP / stance thought are **Current** (2026-09-02/03). The open P1 rows below are still post-MVP cognition work — they are not the village mill.

- [ ] **Conversation quality — Step 2: personas take stock of their day** — periodic self-check feeding planning so the day develops a natural arc; flag-gated, default on. *(Step 1 — survival becomes context, not command — landed 2026-05-22. The deterministic small-cast planner guidance + post-process plan audit were removed, replaced by cognition — do not re-implement. Still in place: force-replan `_is_small_cast`, partner-block cap=1, OPENER STYLE branches, analyzer chat-cooldown dedup.)*

- [ ] **Conversation quality — Step 3: conversations remember themselves** — recent openers/topics fed into the conversation prompt to break repetition.

- [ ] **Conversation quality — verification** — one full survival sim after Step 3. Do **not** use `20260521-2` as the village talk bar; mill + KEEP already scored on `20260831-2` / `20260901-1` / `20260902-3`. Natural vehicle: a later cognition pass, not a village occupancy re-score.

- [x] **Action-location — orphan-anchor + post-validate exemption** — superseded the old bed-only redirect item. Shipped: `_redirect_orphan_anchor_object` (cross-arena, all anchors), `_action_names_address_object` (post-validate stands down when action names object), `_repoint_arena_to_anchor_object` Stage 1+2, dorm-rest redirect, analyzer Class A fixes. SOT: `sot_action-location.md`. Village occupancy **PASS** on 1-B `20260829-1` (whitelist must not relocate). Leftover cafe stay-keep **PASS** on `20260903-1`. The old “250-step Class A ≤5 smoke” is no longer the gate.

---

## Memory quality cleanup *(added 2026-07-09 — post-MVP; surfaced by daily-trailer ranking)*

Trailer cast ranking exposed that **memory write/read quality** is noisy for “most dramatic events of the day”:

- Perceived actions re-store the **same moment many times** (immunity rounds counted 2×+ in top-5).
- **Eliminated Doubles often lack an end-of-day snapshot**, so consumers fall back to an unscoped memory window.
- Canonical survival tags (`vote_cast`, elimination, challenge outcome) sit at fixed **p=6–8**, while ambient “competing / waiting” LLM scores hit **9–10** — plot beats lose to action spam.
- `dbl_get_sim_memories` used by the trailer ranker **does not return keywords**, so survival tags are hard to prefer without content heuristics.
- Chats (often the real drama) are a separate stream from event intensity metrics in the engine; trailer digest now scores movement.chat **content** separately (not a substitute for durable chat-memory quality).

**Post-MVP work (engine / memory, not trailer band-aids):**

| ID | Item |
|----|------|
| **PM-MEM-1** | Deduplicate or coalesce near-identical perceived events before durable write (or mark superseding `node_id`). |
| **PM-MEM-2** | Always write end-of-day snapshots for eliminated personas (or a sim-level day cutoff) so day windows stay hard. |
| **PM-MEM-3** | Rebalance survival `tag_event` / broadcast poignancy vs perceived challenge steps so vote/boot ≥ ambient “waiting/competing”. |
| **PM-MEM-4** | Expose `keywords` (and preferably `meta`) on `dbl_get_sim_memories` for downstream consumers. |
| **PM-MEM-5** | Optional: one durable “day highlight” memory per persona (vote / challenge / elim) for trailers and FE. |

**Near-term trailer mitigation (shipped separately):** ranker dedupes content, hard day window, boosts survival-plot text, and scores **chat transcript impact** into ranking + digest Moments — does **not** replace the engine cleanup above.

---

## Context + memory engineering (post-SOT-release) *(added 2026-08-08)*

> **Do not start until after the active SOT release.** Desired-only note lives in `sot/sot_memory.md` §7. Complements **PM-MEM-1..5** (write quality) and **Phase 4 cost levers** (routine fast path / caching) — this track is specifically *what enters the prompt, in what form/order, on repetitive steps*, not only store hygiene or model tier.

External framing (context engineering vs memory engineering): memory = what persists; context = what each inference call sees and where it sits; they meet at retrieval. Current stack already has hybrid retrieve + budgets + compact packing; the gaps below are write governance, placement, maintenance, and **token/cache efficiency on similar steps without hurting Double awareness**.

| ID | Item |
|----|------|
| **PM-MEM-CTX-1** | **Write policy table** — what/who/trust/TTL/conflict rules by memory class (engine vs gateway namespaces); pair with PM-MEM-1 coalesce. |
| **PM-MEM-CTX-2** | **Context assembly contract** — per prompt-type order + placement (stable constraints/profile prefix → task → budgeted memories near query); budget allocated *before* retrieve fill. |
| **PM-MEM-CTX-3** | **Compress on arrival** — stage-boundary compact forms for perceive/chat/tool-like inputs; rich text stays in DB. |
| **PM-MEM-CTX-4** | **Maintenance** — decay on volatile claims; episodic cluster compress beyond reflection; optional TTL on working items. |
| **PM-MEM-CTX-5** | **Repetitive-step context delta** — on low-novelty / same-act consecutive steps, reuse or delta-pack prior context instead of full re-retrieve + full rebuild. |
| **PM-MEM-CTX-6** | **Prompt-cache utilization** — byte-stable prefixes; volatile memory after stable block; track cache hit rate + tokens/routine-step next to Section 9. |
| **PM-MEM-CTX-7** | **Awareness under smaller windows** — prefer structured scratch/schedule/partners/inbox for routine steps; spend episodic retrieve on plan/chat/reflect and novelty spikes. |

**Success criteria (when scheduled):** lower tokens and higher cache hits on routine stretches; equal or better naturalness and Double situational awareness (who/what/where now); no forced-fallback or freshness regressions. Validate with §4 safe tuning loop in `sot_memory.md`.

**Fit.** Feeds Phase 4 economics after P1 behaviour work; does not replace PM-MEM-1..5 trailer-facing write cleanup.

---

## Owned Double UX (self-serve identity)

- [ ] **PM-OWN-1 — “What my Double knows about me”** — Self-serve surface to read / edit / remove life-chapter notes (`learned` / `currently` / `lifestyle` / `goals`) anytime. Complements consent-based auto-learn from Talk (End session Path A). Not medical/therapy framing. Owner: Ivan (product) + FE when scheduled.

---

## P2 — Fold into other workstreams (owner noted per item)

- [ ] **Viewer UX Tier 3+ → Nicolas, with the Phase-2 CDN player** — don't fix the current player twice; fold into the CDN player rework:
  - Issue 7 — wheel-zoom consistency (`CameraController.onWheel`: always `enterManualMode()` or visible tracking indicator)
  - Issue 8 — scrub error cleanup (`TimelineControls.tsx`: reset drag refs in `finally`)
  - Issue 3 — auto-follow opt-in by default (`MainScene.autoFollowEnabled` default `false`; confirm trailer / `?recording=true`)
  - `simulationStatus === 'stopped'` semantics — unify timeline-exhausted vs recorded-idle
  - Tier 4 — Playwright smoke test for `?step=N`

- [ ] **FE verify (from the original checklist) → fold into FE QA** — timeline: local timezone / day in timeline; sprite cards: accurate & timely info.

- [ ] **DP7-BE-5 — server-side reveal enforcement → Ivan (BE)** — the reveal cap is FE-only by **deliberate MVP decision (2026-06-11)**: `?raw=1` / direct `GET /step/{n}` stay open as dev tools for quick assessment of freshly generated sims. Close before monetisation or spoiler-sensitive audiences: API computes `reveal_step` server-side and gates `GET /step/{n}` for viewers (owner/admin exempt; generation never throttled). Full spec: `20260609_LIVE_mode.md` DP7-BE-5.

- [ ] **BE-3 — sprite-freeze root cause → unlock 1× default playback** — personas occasionally freeze (assigned target + empty `path` under `BACKEND_INTENT_ONLY_PATH`); masked today by 2×–6× catch-up defaults, visible at the forced 1× live edge. Needs a state capture at the freeze instant — log `(sim_code, step, persona)` whenever a freeze is spotted during MVP viewing. Fixing it makes a calm 1×-default viewer experience viable (LIVE doc §7.1).

- [ ] **§7.6 — `mood` + `arena` step-payload fields** — expose showrunner mood; server-set `arena` per persona on step payload (`action_family` / `curr_time` / `day_number` shipped; mood/arena did not). Neither LIVE doc nor hardening doc tracks this.

- [ ] **Persona/world authoring via Open Knowledge Format (OKF) → fold into custom-sim / onboarding workstream** — today a persona's identity and the world map are scattered across the seed CSV (`agent_history_init_n3.csv`) + per-persona `scratch.json` + `spatial_memory.json`: machine-shaped, hard to read/diff/hand-edit. OKF (Google's markdown-+-YAML-frontmatter knowledge-bundle spec, `github.com/GoogleCloudPlatform/knowledge-catalog/okf`) is a clean fit for this static, human-/LLM-authored layer — author `personas/<name>.md` + `world/<place>.md` cross-linked into a graph, compile to the engine's JSON at bootstrap (markdown becomes SOT, JSON an artifact). Payoff: version-controllable, diffable, LLM-draftable persona/world definitions — only worth the loader work when user-authored doubles are actually on the roadmap (sot_lifecycle §6 onboarding). **Not** for the episodic memory engine (high-volume, vector-searched, Supabase-SOT — OKF is a doc/interchange format, not a retrieval engine; our memories already form a graph via s-p-o + `filling`). Investigated 2026-06-13. Optional low-risk side-quest (diagnostics bucket, anytime): export an agent's memory as an OKF bundle to render in OKF's bundled single-file HTML graph viewer — a real forensics/demo tool, no engine changes.

*(BE memory #1 — assoc-stream cap — moved to `TODO_production_hardening.md` Phase 7 on 2026-06-11: always-on doublands make 5,000+-step lifetimes the default.)*

---

## P3 — Realism polish (rare, viewer-visible; no schedule)

- [ ] **#B — Class A kitchen-object anchor → adjacent `cooking area`** — persona lands in the right kitchen but at `cooking area` instead of the named `refrigerator`/`toaster` (2 of 7 Class A on `20260525-5`; Gosha 690–709, Katya 671–680, both `source=llm_location_v1`, anchor='kitchen'). Fix paths, cheapest-first: (1) wiring audit — is `_repoint_arena_to_anchor_object` wired on `llm_location_v1`? (2) new `_repoint_to_named_kitchen_object` helper mirroring orphan-bed/closet; (3) Group B — extract the named object as anchor at decomp time (architecturally cleanest). Branch when picked up: `ivan/class-a-kitchen-object-anchor`.

- [ ] **Depth-1 truncation** — Katya 1036–1050 on `20260519-1`: planner finalised `the Ville` (world-only). Investigate why; separate from call-site coverage.

- [ ] **Sub-bug B — task-decomp anchor vs description** — anchor disagrees with sub-action description; fix belongs in `task_decomp_contextual_v1` prompting; needs LLM-dump inspection.

- [ ] **Cross-arena Class A** — within-arena repoint only today; cross-arena needs sibling-arena lookup — only if count stays high after Sub-bug B.

- [ ] **Phase B (structural)** — split `act_internal_state` / `act_display_text` per `done/20260504_action-location-observations_v2.md` §4.6; only if display leaks reproduce after Phase A stable.

---

## Track-only — act on trigger, not proactively

- [ ] **LLM hallucination — strict-schema enum** — in scope only if the rate crosses the **5% gate** again (`20260521-2`: 4.5%). Free checkpoint: the consolidated validation run.

- [ ] **#C — hourly-LLM verb stochasticity (pre-event slot)** — Day-1 challenge miss on `20260525-5` (Luba "arriving at" = transit vs "settling in at" = present); did **not** recur on `20260610-dp8b` (survival analysis clean, gathering 100% all nights). Act only if a future run misses a challenge again. Recommended fix then: hybrid — restricted-verb prompt rule + deterministic post-LLM rewrite guardrail (~50 lines). Branch: `ivan/hourly-verb-stochasticity`.

- [ ] **`PLAN_STALL`** — Katya 99-step repeat pre-elim on `20260519-1`; pull `monitoring/step_2211.json` if it recurs.

---

## Scale roadmap — Phases 4–7 *(moved from `TODO_production_hardening.md` 2026-06-15)*

> Physically relocated here on 2026-06-15 — `TODO_production_hardening.md` now reads as **Phases 0–3 = 3-sim reliability spine complete** (June Telegram-demo bar). That is **not** the same as the village gather+talk gate, which closed 2026-09-03. The high-level rationale (the **bottleneck map N1–N7** and the **staged build-up table**) stays in that doc's §1–2; this section holds the actionable phase detail. **Sequencing:** remaining P1 conversation-quality items above land **before Phase 4** (behaviour first, then cost tuning — see the Top economic priority block). The strategic overview, target architecture, and guardrails remain in the hardening doc.

- [ ] **Phase 4 — Cost levers** — routine fast path, zero-call sleep, quiet-day cadence; iterates against Phase-1 telemetry; quiet-day needs Ivan's sign-off. **Pre-req:** land P1 above first (behaviour changes before cost tuning, so levers are tuned once against final behaviour). *(This is the unit-economics fix — see the Top economic priority block at the top of this doc.)*
- [ ] **Phase 5 — Browser-free realization** — removes Chromium from generation; prerequisite for the Phaser → three.js swap
- [ ] **Phase 6 — Fleet-out** — Supabase job queue + worker boxes + batched writes + stateless gateway
- [ ] **Phase 7 — Episode factory + at-scale hardening** — clip library, elastic render pool, partitioning, fleet observability

### Phase 4 — Cost levers

Measured (group-scale doubland, ~15 doubles): ~2–3 LLM calls per double per step, ~1,000–1,500 tokens, already mostly on the cheapest model tiers ⇒ **~$2–7 per fully-generated sim-day** = $60–200/month always-on against a $10–30 price. No server choice fixes this; the levers are in how much the sim *thinks*:

| Lever | Idea | Est. saving |
|---|---|---|
| **Routine-step fast path** | Most sim-minutes are "keep doing what I'm doing." Skip LLM calls entirely when nothing new is perceived and the current action persists (the P2 flags already lean this way). | **3–5×** on call volume |
| **Zero-call sleep** | ~7.5 h/night ≈ 450 of 1,440 daily steps — make sleeping steps literally zero-call. | ~1.3–1.4× |
| **Quiet-day cadence** | When neither owner nor any viewer has opened a doubland recently, generate at coarse cadence (e.g., 5-minute steps) or as a cheap summary day, returning to full fidelity when someone comes back. Presentation stays always-on; computation doesn't. **Product dial — needs Ivan's explicit sign-off.** | 3–10× on dormant doublands |
| **Caching + token trims** | Embedding cache already hits ~70%; trim prompt/token budgets; precompute card summaries once per step-window instead of per click. | 1.2–1.5× |
| **Batch processing** | Segments generated >1 h ahead of visibility qualify for discounted batch LLM pricing (~50% off). Same-day influence limits eligibility — minor lever. | up to 2× on eligible segments |

**Realistic blended outcome:** fully-watched days ~**$0.5–1**, quiet days ~**$0.1–0.2** ⇒ a typical mixed month lands around **$5–15 per doubland** — inside the $10–30 admin price, with margin improving as levers compound.

**The two-tier model helps structurally:** generation cost grows with the number of doubles, and so does revenue — every double is a potential player-tier subscriber. The admin subscription covers *base* generation cost; player subscriptions are high-margin add-ons whose marginal cost (compose from the shared clip library + metered chat) is small and tied to its own revenue.

All lever decisions iterate against the **Phase-1 telemetry** (`double.sim_cost_daily` / `sim_cost_fleet_daily`) — real numbers, not estimates.

### Phase 5 — Browser-free realization (the thousands-unlock)

Extract A\*/collision/occupancy/proximity out of the browser into an engine-neutral backend service — no Phaser, no Chromium. This collapses per-step realization cost from browser-bound to milliseconds, removes the ~0.8 GB browser per running sim (N3), turns chunk jobs into pure Python mostly waiting on LLM responses (one 8–16 GB worker box runs ~20–40 chunk jobs → thousands of doublands on a handful of cheap boxes), and decouples sim truth from the renderer — **the prerequisite for the three.js swap**. After Phase 5 the render tier exists for *episode recording only*.

**FE verdict (2026-05-15, re-audited 2026-06-04): feasible; the risk is parity, not feasibility.** The algorithms are already pure TypeScript inside the Phaser class; ~300 lines lift directly into a `MovementRealizer`, ~2,500 lines of per-step orchestration port to a non-animated `realizeStep()`. Estimated **~4–6 weeks**:

| Slice | Effort | Risk |
|---|---|---|
| Lift pure algorithms into `MovementRealizer` | 2–3 days | Low |
| Port orchestration to `realizeStep() → { actuals, observations }` | 2–3 weeks | Medium (edge cases; covered by tests) |
| Proximity as path-vs-path time sampling | 3–5 days | Low |
| Wire as service from `reverie.py` | 1–2 weeks | Low–medium |
| Parity gate vs ~1,000 historical steps | 1 week | Safety net |

**The sharpest parity risks** (a reimplementation must reproduce the battle-tested output *exactly*, or encounters → conversations → memories all diverge):

1. **Agent ordering + tile-claiming.** Agents claim tiles as they resolve paths, so results depend on per-step processing order; there's a hand-tuned `+10` soft-obstacle penalty validated against a 300-step sim. Replay order and tuning identically.
2. **Proximity (the conversation trigger) is measured *between* animation frames** — at 100× speed agents jump ~50 px/frame, so a naive point-to-point backend will miss real encounters and invent fake ones. Sample intermediate points along each path.
3. **Collision data has a silent-failure mode** — an unloaded chunk defaults to "blocked", quietly rerouting agents. Use the same Supabase source and surface load failures loudly.

**What lowers the risk:** the headless path is already discrete (100×, snaps to tiles) and already reads collision from Supabase — the backend reproduces the narrow *headless branch*, not the full render branch. **Non-negotiable de-risking: the parity oracle** — diff old-vs-new over ~1,000 historical steps as the pass/fail cutover gate, and **preserve the `AnimationManager*` headless tests as the parity spec**. Keep the FE headless path as a parity oracle for one–two release cycles after cutover. Net: medium execution risk, low architectural risk.

**Recording stays separate.** `?headless=true` (Phaser.HEADLESS, no assets/GPU, Supabase collision) and `?recording=true` (full renderer, ~38 MB assets, GPU context, tilemap collision) are different workloads — never mix modes in one context; size any combined pool for the recording profile. Episode recording keeps a browser; generation loses it.

### Phase 6 — Fleet-out

Target architecture (the north star — every earlier phase is a sized-down slice of it):

```
                         ┌─────────────────────────┐
        job: "run sim X" │   Orchestrator / Queue   │ job: "render episode, sim X day N"
        ─────────────────▶  (Supabase-backed)       ◀───────────────────────
                         └────────────┬────────────┘
                       pull           │            pull
              ┌─────────────────┐     │     ┌──────────────────────┐
              │ Sim-cognition   │     │     │ Episode-render        │
              │ workers (pool)  │     │     │ workers (pool)        │
              │ - reverie loop  │     │     │ - extraction/LLM/TTS  │
              │ - LLM cognition │     │     │ - compose (ffmpeg)    │
              └────────┬────────┘     │     └──────────┬───────────┘
                       │ (browser-free after Phase 5)  │ render-scene job → GPU render pool
                       ▼                              ▼
              ┌──────────────────────────────────────────────┐
              │  Supabase — SOT + coordination plane          │
              │  data, sim status, job queue, worker leases   │
              └──────────────────────────────────────────────┘
```

- **Job queue:** Supabase-backed (job rows + worker leases — "worker W owns sim X until time T"), grown from the existing `SimConcurrencyGate` + `TaskManager`. Plain worker boxes (e.g., Hetzner) added one at a time. Sim runs and episode renders both become *queued jobs*, not hand-started processes.
- **Request API (self-service):** `POST /simulations` with `{origin, target, days, priority, owner}` → job ID + status URL; broker validates against baselines/capacity/policy, then enqueues — no direct process spawn. Every job has a Supabase row with state, progress, lease, errors. A day-completion hook enqueues episode jobs.
- **Batch Supabase writes per chunk** (array RPCs) — addresses the write firehose (N5) before it bites.
- **Stateless gateway:** move WebSocket fan-out to a shared bus (Supabase realtime or Redis pub/sub), per-sim queue/lease state to Supabase — unblocks running >1 gateway instance. (The gateway is the easy-to-forget stateful singleton in the middle.)
- **PM-INFRA-1 (sim/Chrome full split)** — see § Generation-host resilience above; fold into fleet-out so sim jobs are never children of the API process tree.
- Close the Phase-0 leftover orchestration gaps (PL-5/7/8/9, below) as part of this phase if not done earlier.

### Phase 7 — Episode factory + at-scale hardening

- The Episode pipeline already reads everything from Supabase and renders **off the generation server** (release-gate decision — keep it that way permanently); it needs **a queue and worker machines instead of Ivan's laptop**.
- **Every video is unique, but the moments aren't.** The sim-wide Episode and each player's POV video are distinct artifacts — different moment selection, story, narration — but they draw on the same day's events. The heavy step (scene recording on a GPU browser) builds a **per-doubland-day clip library**: record each notable moment **once**, compose every video from it with its own LLM story + TTS narration + cheap ffmpeg assembly. N subscribers ≈ **M shared recordings + N cheap compose jobs**. A bounded clip budget (top ~10–20 sim-wide moments + a few personal moments per subscriber) keeps the recording bill predictable.
- **Spread recording across the day instead of spiking at 18:30.** As each generation chunk publishes (Phase 3), candidate highlights are enqueued and recorded immediately; by 18:30 owner-local only story selection, narration, and assembly remain — minutes of cheap work. Timezone staggering levels render load again.
- **Reduce per-clip cost (FE investigation flag):** recording currently captures playback in real time on a GPU browser; a frame-by-frame render (step the engine clock, snapshot frames, ffmpeg) is not bound to real time and parallelizes freely. *(TTS + render cost per video still needs measurement.)*
- **POV videos are generated only for player-tier subscribers**, each funded by its own subscription. Scene recording stays on dedicated render workers, separate from generation.
- **At-scale data hygiene:** memory retention/compaction + memory-table partitioning inside Supabase (N5). Includes the in-process side: **cap associative-memory streams** — `seq_event`/`seq_thought`/`seq_chat` + `kw_to_*` grow unbounded for the life of a sim (~1–2 KB/node), and every chunk-scheduler wake reloads them, so always-on doublands pay growing RAM + wake time. Intended fix: tail-drop eviction, monotonic node-ID counter, cap ~500–1000 per persona per stream (four interlocking changes in `associative_memory.py`; **silent failure mode — test carefully**); multi-org LLM keys only if N4 still demands it after Phase-4 levers; fleet observability dashboard (N7). If the multi-box render fleet needs central tuning, add the small template-driven control plane (poll Supabase state → push worker config) — only at this phase, not before. *(This is the memory-cap watch-item: soaks ran 5,000+ steps with no blow-up, so it isn't biting — do not pull forward pre-MVP.)*

### Residual Phase-0 ops debt (PL-5 / PL-7 / PL-8 / PL-9)

Detail + workarounds in `20260610_parallel_sim_launch.md` §5; fold into Phase 6 orchestration if not done earlier. All have workarounds; none block MVP.

- **PL-5** — manual/`nohup` reverie not reflected in `backend_process_active` (misleading ops signal).
- **PL-7** — **Stale.** Current Hetzner box is HTTP `127.0.0.1:8001` (no public TLS on the gateway). Do not restore the old Fozzy Let's Encrypt unit. Document the localhost-only topology; do not “fix” this by opening `:8001` on the cloud firewall.
- **PL-8** — `GET /tasks/{id}` in-memory only → task status 404 after gateway restart (persist tasks or return sync errors in the `/start` response).
- **PL-9** — no `POST /batch/start` → N× manual curl/SQL for parallel runs (batch endpoint respecting `SimConcurrencyGate`).

*(PL-10 closed 2026-06-15; PL-1/2/3/4/6/11/12 closed earlier.)*

---

## Closed 2026-06-11 (triage log)

- **#A — Scenario C clean-experiment revert (`20260525-6`)** — CLOSED, not run. Purpose was to learn whether the 5/25 prompt rework was over-engineering; since then the baseline was promoted, Survival validated end-to-end (`20260610-dp8b`), and the prompts caused no new failures. ~5h sim + revert work to maybe simplify ~80 lines is no longer a good trade. Full experiment design in git history of `TODO_be_debt.md`.
- **FE memory closure (Windows prod re-run + dev-run checks)** — CLOSED. VPS soaks answered it: production headless FE ran parallel sims 5,000+ steps with no memory blow-up (`20260610_parallel_sim_launch.md`). Investigation verdict stands: dev-mode artefact; `stepBufferRef` rolling window landed (HOOKS-007).
- **Check sim `20260521` results** — CLOSED, stale; overtaken by the `20260525-5` baseline promotion.
- **BE memory #1 (assoc-stream cap)** — MOVED to `TODO_production_hardening.md` Phase 7.
- **LIVE mode + Episode cadence section** — RETIRED; shipped or tracked in `20260609_LIVE_mode.md`. **DP7 MVP closed** on `20260611-2` QA (4/4 PASS). Post-MVP items in table above.
- **Village launch post-MVP list** — MOVED 2026-09-03 from `double-ivan/20260910_launch.md` into **PM-VIL-1..5** (Seek Hold, “That’s me”, Talk Path A, acting-model swap, MatrAIx parked/banned). Village gather+talk closed the same day.
- **PM-DP7-4 FE-4 visual** — **closed** 2026-06-12: 16/16 unit tests + prod no-fallback + local `?capNow=` visual; prod overnight window (runbook item A) not run — sim completed first; gap accepted per DP7 rule 5 QA hook.
- **DONE archive + retrospective tables** — removed; the load-bearing "do not re-implement" notes are kept inline above. Full records in git history, the worklog, and per-sim reports under `environment/frontend_server/storage/<sim>/`.
