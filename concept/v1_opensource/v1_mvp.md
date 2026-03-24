Below is the fastest path that **reuses what you already built** and adds only the minimum needed to ship a **“light MVP”** aligned with the corrected V1 vision:
**autonomous simulations where Doubles live independently** + a compelling **watch/share** loop.

---

## What you already have that’s MVP-grade

### 1) A solid “World State + Playback” backbone (this is the hard part, and it’s done)

* **Supabase-first SOT** with Realtime + pgvector + RPCs, plus clean separation between frontend and backend. 
* **Production-ready frontend** (Next.js + Phaser) with a “Story Stream” style viewing layer (subtitles, markers, drama filter, etc.). 
* **Replay is cheap** because browser playback uses stored `actual_path[]` (no A* in browser). 

### 2) A working backend surface area you can ship behind

* **FastAPI Gateway** already exposes simulation lifecycle endpoints + status + steps. 
* Headless visualization + rendering exists, but the **light MVP does not require video export** as a user-facing feature.

### 3) The data model already supports autonomous “world state” primitives

You already have:

* **World state primitives** (simulations, personas, coords, step history/playback).
* **Objects + carrying** (`carried_objects`, `pick_up_object`, `put_down_object`) — optional “world texture” for the simulation.
* **Maze chunks/expansion** (`expand_maze`) — useful later, but not required for the light MVP.

---

## Define v1 MVP in one sentence (so you can ship fast)

**A user creates a Double, joins a simulation that runs autonomously without user supervision, watches the story stream/replay, and shares a replay link (no world-building, no video export).**

**Where the fun is** — Observing your Double: how they interact with other Doubles, what choices they make, and what those choices lead to.

**Directed scenarios (in scope for MVP)** — A **simulation director** can impose a scenario that all users abide by. Example: a Survival-like format where Doubles compete in joint events and each night come together to decide who is out. Coalitions, rivalry, and emergent social dynamics are what make the sim interesting.

**Chat with your Double** — A **chat interface in the Personal Card** (frontend) lets users talk to their sprite: check in on how things are going, let the Double share about their virtual life, and give the sprite advice on how to live it.

Everything else (CityKit, creator marketplace, war/police/finance modules, MP4 highlight exports) becomes “v1.x”.

# =================== <Validate sections below to align with updated v1 MVP definition> ==================
---

## The shortest path: 4 workstreams in the right order

### Workstream A — “Launchable deployment” (do first)

Goal: run this as a real product, not a dev stack.

**Minimum moves**

1. Run in **Supabase-first mode** (Supabase as SOT). Keep file fallbacks only for dev.
2. Package the current “three terminal setup” into **one command / one container composition** for internal ops (even if users never see it). 
3. Add a tiny “admin/beta ops” screen:

   * create sim (POST create) 
   * start/stop/pause/resume 
   * (optional) generate a “daily digest” for a simulation

**Done when:** you can onboard a friend and they can watch a simulation without you SSH’ing anything.

---

### Workstream B — “Autonomous simulation runner” (the actual MVP core)

This is the non-negotiable core: **Doubles live independently** in a simulation without the user actively “playing” them.

**What you implement (light MVP)**
* A minimal “simulation scheduler” that advances the simulation on a cadence (or in bursts), without a user clicking play.
* Simulation lifecycle:
  - create simulation
  - activate simulation (starts ticking)
  - pause simulation (stops ticking)
* **Directed scenarios:** A **simulation director** can impose a scenario that all participants abide by (e.g. Survival-like: joint events, nightly “who is out” decisions). Backend supports scenario rules/format so coalitions, rivalry, and emergent social dynamics can emerge.
* A clear budget model (even if rough): ticks/day, max agents, max history retention.

**Key scope cut:** this runner can be dedicated infrastructure (worker/container) rather than a local desktop gateway for MVP speed.

**Done when:** a simulation progresses for hours unattended, remains viewable/replayable, and (when used) a directed scenario runs with Doubles following the imposed format.

---

### Workstream C — “Watch” (story stream + replay as the product)

You already have most of this. The MVP goal is to make it delightful, robust, and sharable. **Where the fun is:** observing your Double — how they interact with other Doubles, what choices they make, and what those choices lead to.

**What you ship**
* Simulation page: live view + replay timeline + scrubbing (so choices and consequences are visible).
* **Chat with your Double** (Personal Card, frontend): chat interface so the user can talk to their sprite — check in on how things are going, Double shares about their virtual life, user can give the sprite advice on how to live it.
* Daily digest (text/storybeats + bookmarks) generated from event/step data.
* “Why it happened” (minimal): show goals/triggers/rules for a moment if available.

**Done when:** watching a simulation feels like consuming a show, not debugging a sim.

---

### Workstream D — “Share” (viral loop without video)

**What you ship**
* Shareable replay link with permissions:
  - unlisted link
  - friends/simulation participants
* “Share moment”: deep link to a specific step window (start_step/end_step).
* Optional cheap artifact: cover PNG (single screenshot) — not a stitched MP4.

**Explicitly not in MVP:** MP4 highlight generation/export.

---

## What we explicitly postpone (to ship 2× faster)

**Postponed**
* **World building / CityKit / publishing** (creator economy comes later).
* **Video highlight reels** (MP4 export + stitching).
* Full economy (markets, listings, prices), war/police/finance modules.
* Peer-to-peer hosting, device-to-device consensus.
* Fully offline shared simulations.

**Optional (can exist internally, not a product promise)**
* Headless rendering/validation may remain as an internal tool, but the MVP does not depend on “video output” for user delight.

---

## A practical “MVP checklist” (binary, launch/no-launch)

**Must-have**

* Create/join simulation + simulation runs autonomously without supervision
* Watch: live view + replay timeline + scrubbing
* Daily digest: a simple “what happened today” feed with deep links to steps
* Share: replay link + “share moment” deep link

**Nice-to-have**

* Double Gateway as optional privacy mode (not required)
* Lightweight “why it happened” explanations for key moments
* Simulation admin controls (pause/resume/schedule)

---

## Ship gates (how we’ll know it’s ready)
* **Autonomy**: a simulation can run unattended for \(N\) hours without manual babysitting.
* **Directed scenario**: when a director imposes a scenario (e.g. Survival-like), Doubles abide by it and emergent social dynamics are visible in the story stream.
* **Chat with your Double**: user can open Personal Card, chat with their sprite, and get/share context about the Double’s virtual life.
* **Replay reliability**: a viewer can scrub across the run without missing steps or desyncing the UI.
* **Share reliability**: a shared moment link loads in <5 seconds and shows the intended window.
* **Cost guardrails**: budgets enforced (ticks/day, retention) to prevent runaway costs.

---

## If you want, I can turn this into an execution board
I can convert this into **epics → tickets → acceptance criteria** (Linear/GitHub/Notion style), and propose the smallest “killer simulation template” for the first public demo.