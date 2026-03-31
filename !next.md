## *MVP*

1. Sprite cards+chats; 
  - TODO for Nicolas

2. Survival

3. Video

4. Rehears >> Onboarding

5. Venture Bridge && Tartans

===================================================================================



## *Post-MVP*


<https://github.com/666ghj/MiroFish>


### **Persistent persona-day thread ("doubles as agents"):** 
- Introduce reusable persona-day context thread with compaction, TTL boundaries, and stateless fallback.
- Relevant context is added to this thread (i.e. added as RAG / db access) depending on the task
- Optimize chat gen as direct exchange of messages between threads (in openai assistant api terms - as if assistants were talking directly)
- WATCH FOR: memory compacting (every new message added to context >> increases token usage for consecuent calls??);
- TurboQuant: Explore Google Research's TurboQuant (Mar 2026) for efficient vector quantization of embeddings. Achieves 3-3.5 bits/dim compression with near-zero loss in similarity search/recall. High priority for long-run memory compaction without degrading retrieval quality or persona naturalness.  manage irrelevant content - e.g. previous chat with person A should not creep into a chat with person B; 
`Compare our memory processing vs. OpenClaw`
<https://github.com/martian-engineering/lossless-claw>

### **Planned Chats**
*Planned chats occur when a sprite decides he needs to speek to a specific sprite and seeks to meet them.*
These are high-value chats, so decision and the chat itself should be processed by smart model (tier_c)
- **Status:** Current chats are observation-driven only. But we need to allow sprites to initiate chats with who they NEED/WANT to talk to.
The desire to talk to someone specific should create an intention to seek meeting with them. On approach - proximity should trigger conversation.
- **Gap (2026-03-30 analysis):** The 3-link chain (plan visit → move to person → talk) is broken at link 2.
  - Link 1 works: LLM planner can generate social actions ("discuss X with Katya"); `social_touch` mode + persona-name anchors recognized in task decomp.
  - **Link 2 broken:** `plan.py` resolves the persona-name anchor against the static location tree (LLM guesses "Katya's room"), never looking up the target's live position. `execute.py` has working `<persona>` pathfinding (routes to `curr_tile` of target), but `plan.py` never produces a `<persona>` format address — dead infrastructure.
  - Link 3 works conditionally: `_has_deliberate_pair_chat_intent()` in `reverie.py` detects intent keywords + target name in `act_description` and forces "full" chat tier on proximity — but only fires if they happen to be co-located.
  - **Fix:** When `subactivity_mode == "social_touch"` and anchor is a known persona name, bypass `generate_action_location()` and set address to `<persona> {name}` so `execute.py` pathfinds to their live tile.

### **Home Assignment** 
*Phase 2 (Post-MVP UI + hardening)*
  - **Status:** Post-MVP candidate after Phase 1 API-first mandatory home assignment is stable.
  - **Reason:** Phase 1 removes clustering risk with low blast radius; Phase 2 focuses on operator UX and assignment reliability.
  - **Post-MVP scope:**
    - Add admin onboarding UI for `auto` and `manual` home assignment flows.
    - Add searchable/filterable available-home list (zone, occupancy, basic features).
    - Add assignment conflict prevention and clearer operator error states.
    - Add assignment audit trail (who assigned what, when) and basic operational metrics.
    - Keep runtime behavior unchanged; this phase should not alter chat trigger precedence or FE/BE movement contracts.
  - **Validation target:** faster onboarding (<5 min for 15 sprites), zero duplicate home assignments, no missing `living_area` at start.

*Phase 3 (Post-MVP experimental "find-your-home")*
  - **Status:** Post-MVP experimental track behind feature flags.
  - **Reason:** This mode touches planning, chat, observation, and claim persistence; higher behavior/cost risk than Phase 1-2.
  - **Post-MVP scope:**
    - Introduce optional `find-your-home` mode where sprites begin unhoused and claim homes through guided exploration + chat.
    - Add claim workflow persistence (claim attempts, success/failure, timeout fallback to auto-assign).
    - Add explicit safety limits: bounded search window, no deadlock loops, deterministic fallback after timeout.
    - Run A/B evaluations vs Phase 1-2 on realism, token cost, and simulation stability before defaulting on.
  - **Product note:** do not promote to default until movement quality and cost KPIs are met across multi-step runs.

### **Atlas selection**
- *Sprite Publication Policy (Atlas Uploads)*
  - Decide whether uploaded atlases are immediately usable or require moderation/approval workflow.
  - Define policy gates (owner-only, admin approval, automated checks) and audit trail requirements.

- *Runtime Atlas Switching*
  - Decide behavior for changing persona atlas while simulation is actively running.
  - Define contract for when change takes effect (immediate vs next step vs next run) and replay consistency impact.

### **Observation Queue Migration (pending.json -> Supabase-native queue)**
- **Status:** Post-MVP scalability hardening.
- **Reason:** `pending.json` is a good MVP bridge but does not scale cleanly for many concurrent multi-step sims or multi-instance deployment.
- **Post-MVP scope:**
  - Introduce append-only observation queue table in Supabase with idempotency key `(sim_code, step, persona, type)`.
  - Add worker-safe claim/ack flow (`queued -> processing -> processed/failed`) with retry metadata.
  - Keep `POST /api/simulations/{sim_code}/observations` backward-compatible during migration.
  - Add optional `/observations/batch` ingest path and controlled parallel processing path.
  - Add queue retention policy (TTL/archival) and operational dashboards (queue depth, lag, retry rate, p95).
  - Roll out with feature flags and staged migration (`file queue`, `dual-write`, `db-primary`).
- **Acceptance target:**
  - p95 ingest and processing latency stable as step count grows.
  - no increase in duplicate/missing movement reports.
  - replay continuity unchanged in strict mode.
  - safe rollback to file-queue path in one flag change.

#### *Post-MVP Tickets Opened (from Track C release decision)*

*`PMVP-OBS-001` — Workers=4 Throughput Canary*
  - **Priority:** P1
  - **Owner:** Backend
  - **Goal:** Validate whether `SUPABASE_POSITION_WRITE_MAX_WORKERS=4` can improve throughput without p95 regressions.
  - **Scope:** 15p canary run (10-15 steps), then one full run (>=30 steps) only if short run is stable.
  - **Acceptance:** no duplicate/missing reports, strict integrity unchanged, p95 for processing/store metrics stable or improved vs workers=2.

*`PMVP-LLM-001` — Prompt Budget and Token Clamp*
  - **Priority:** P1
  - **Owner:** Backend + Prompting
  - **Goal:** Reduce per-step token usage while preserving behavior quality.
  - **Scope:** tighten profile-context/task budgets, reduce verbose prompt blocks, add per-step token telemetry guardrails.
  - **Acceptance:** average tokens/step reduced to target envelope with no replay continuity regressions.

*`PMVP-MOVE-001` — Spawn Diversity and Park-Bias Reduction*
  - **Priority:** P1
  - **Owner:** Simulation + PM
  - **Goal:** Reduce clustering/jitter from shared/distant spawn behavior.
  - **Scope:** expand deterministic home assignment quality, improve destination ranking, keep movement contracts unchanged.
  - **Acceptance:** fewer persistent stationary/jitter flags in >=30-step 15p runs with stable correctness.

*`PMVP-OBS-002` — `pending.json` to Supabase Queue Migration*
  - **Priority:** P2
  - **Owner:** Backend + Supabase
  - **Goal:** Replace file queue bridge with DB-native observation queue for multi-instance scale.
  - **Scope:** dual-write migration, idempotency keys, claim/ack flow, retention and dashboards.
  - **Acceptance:** sustained p95 stability as run length grows; one-flag rollback path validated.