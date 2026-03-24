# Double v1 — Local-First Social Simulation Universe (New Concept)

## 0) One-sentence description
**Double** is a local-first social simulation app where users create a “Double” (a personal AI agent) that lives inside a **safe virtual universe**. Doubles can build cities, form companies, trade, govern, and fight wars—while users watch daily highlight stories and can gently steer outcomes.

---

## 1) What changes vs the original Double vision
### Original strengths we keep
- **Bingeable entertainment loop**: daily highlight reels of “what our Doubles did”.
- **Group dynamics**: Doubles interact in shared realms with real friend groups.
- **Light steering**: users can influence outcomes without direct control.

### New paradigm (this v1)
- **Local-first Doubles**: the primary agent runs on the user’s device via a simple “Double Gateway” install.
- **World-first freedom**: Doubles have **full autonomy in the virtual world**, but **zero default access** to the real world (messages, files, accounts).
- **Creator-driven worlds**: users can build and publish cities/world templates; the platform becomes a world marketplace.
- **Always-on as a paid upgrade**: users can run an always-online “Double Node” in the cloud (managed or BYOC).

---

## 2) Target audience & positioning
### Initial target (practical launch)
- Social, game-curious users who like watching stories: teens/young adults + friend groups.
- Early adopters: creators who want to design worlds, events, and economies.

### Positioning
- “**Your squad, but as autonomous characters in a living world**.”
- Not “productivity agents.” It’s entertainment + identity + social dynamics.

---

## 3) Product pillars

### Pillar A — Doubles as local agents (Local-First)
- Install **Double Gateway** (like Zoom): one installer, sign-in, immediate use.
- Local Gateway hosts:
  - the Double agent runtime,
  - a privacy/permissions control panel,
  - the world sandbox (simulation),
  - encrypted local storage for memory/state.

**Free tier behavior**
- When the device is on, the Double is active.
- When off, the Double sleeps; events/messages queue and sync later.

**Paid behavior (always-on)**
- An always-online “Double Node” runs the same gateway code in a dedicated cloud environment.
- Local device can still connect and take over (handoff).

### Pillar B — Progressive profiling (lower entry friction)
- No heavy quiz gate.
- Start with a fast “seed” (3–5 choices).
- Improve accuracy over time via:
  - micro-decisions in the world,
  - user corrections (“that’s not me”),
  - optional “data packs” explicitly provided by the user (imports/uploads).

### Pillar C — Safe World Sandbox (maximum freedom, zero real-world impact)
- The Double has unlimited freedom **inside the world** (economy, war, police, markets).
- Real-world integrations are separate capabilities and default to OFF.
- World actions are governed by validated rules + budgets (no runaway mods).

### Pillar D — Creator ecosystem (scale through composition)
- Worlds are built from primitives + modules (economy, law, war, finance).
- Creators publish world templates, “rule packs,” and content packs.
- Users remix and share.

---

## 4) The core user loops

### Loop 1: Watch → React → Share
1. Daily highlight reel drops (60–120 seconds).
2. User taps into a moment for context (“why did this happen?”).
3. User shares the highlight or invites friends to the realm.

### Loop 2: Build → Simulate → Publish
1. User builds a city/world with CityKit (templates + primitives).
2. Runs the simulation with their friend group’s Doubles.
3. Publishes a version (“Mall Town v3”, “Cold War Realm”, “Startup City”).

### Loop 3: Steer (light control)
- “Night Whisper” / “Dream” interventions:
  - suggestions, priorities, moral constraints, personal goals,
  - never direct joystick control (keeps stories surprising).

---

## 5) Privacy, safety, and trust model (must be productized)
### Default promise
- **World-only**: Doubles can do everything in the virtual world.
- They do **nothing** to real accounts, real messages, or real files by default.

### Permissions UX (capability-based)
- World Sandbox: ON
- Media Pack (user-imported photos/video): OFF by default
- Notes Pack: OFF by default
- Messaging Draft Mode (requires approval): OFF by default
- Messaging Autopilot (rare/high risk): strongly gated

### Transparency UX
Every major highlight scene has:
- **Why it happened** (goals, triggers, rules)
- **What data was used** (world-only vs optional packs)
- **Correct my Double** (feedback that updates persona)

---

## 6) High-level architecture (v1)

### Client side (local)
- **Double Gateway** (desktop app + background service)
  - Identity, pairing/allowlists, permission controls
  - Agent runtime (local model or API calls)
  - Tool router (World APIs only by default)
  - Encrypted local storage
- **World Sandbox**
  - Deterministic simulation engine
  - CityKit editor + renderer
  - Append-only event log + snapshots
- **Highlight Generator**
  - Converts event log → story beats → short video

### Cloud side (minimal for v1)
- Auth & device registry
- Encrypted queue (store-and-forward while offline)
- World template marketplace + updates
- Optional: safety scanning for published templates (not personal data)

### Paid always-on
- **Double Node** (dedicated cloud instance per user or realm)
- Encrypted replication with local devices
- Realm hosting and scheduling

---

## 7) Monetization
- Free: World-only doubles, limited realms, limited highlights, basic CityKit.
- Paid:
  - always-on Double Node,
  - more realms & larger worlds,
  - advanced creator tools,
  - premium “steering” controls,
  - higher simulation budgets (more NPCs, larger districts).

---

## 8) Open-source strategy (build an ecosystem without losing monetization)

### 8.1 Goals
- **Attract builders** to accelerate tools, templates, and modules needed for the full vision.
- **Preserve product trust**: users can audit core safety boundaries (world-only by default).
- **Preserve monetization leverage**: keep the “always-on hosting + marketplace distribution + premium infra” advantages.
- **Avoid ecosystem fragmentation**: define stable extension points and clear compatibility rules.

### 8.2 Open-core boundary (what is open vs proprietary)
**Open (permissive OSS)**
- **Client viewer/player**: replay/story stream UI, realtime subscriptions, simulation playback.
- **SDK + contracts**: event log schema, world/module interfaces, API types, example clients.
- **World authoring tools**: validators, template builder utilities, rule-pack linting/testing harness.
- **Reference modules/templates**: curated starter worlds and official “safe primitives” modules (non-premium).

**Proprietary (monetization + safety moat)**
- **Always-on orchestration**: realm scheduling, runner fleet management, multi-tenant resource isolation, abuse controls.
- **Hosted marketplace**: payments, moderation, trust scoring, discovery algorithms.
- **Premium highlight pipeline**: high-quality story selection, large-scale rendering/export infrastructure (optional later).
- **Anti-cheat / safety enforcement**: production-grade detectors, rate limiting, anomaly flags, incident tooling.

This split keeps the ecosystem open where contributions are most valuable, while retaining the operational advantages required to run worlds reliably at scale.

### 8.3 Licensing (recommended)
- **Permissive licenses** (MIT or Apache-2.0) for open repos to maximize adoption and contributions.
- If a “server runner” repo is ever published, consider **source-available** (e.g., BSL) rather than permissive, to prevent commodity clones of the hosted always-on business.

### 8.4 Governance that still feels “open”
- Use a maintainer model: **public issues/roadmap**, but the core team retains final merge rights on canonical repos.
- Require a lightweight **DCO** (Developer Certificate of Origin) or a **CLA**:
  - DCO = easiest for contributors.
  - CLA = best if you may dual-license later.
- Publish a clear **security policy** (private vulnerability reporting) so “world safety” issues are handled responsibly.

### 8.5 Trademark + “official distribution” policy (subtle control)
- Keep **“Double”** name/logo as a trademark and publish a simple policy:
  - Forks are allowed, but cannot present themselves as the official product.
  - “Official marketplace” and “official hosted nodes” remain controlled distributions.
This preserves brand trust without restricting code collaboration.

### 8.6 Ecosystem architecture: extensions without forks
To prevent chaos, define a small number of stable extension mechanisms:
- **World Templates**: data-first packages (maps, initial entities, rules config) with strict versioning.
- **Modules**: add entities/events/reducers/validators with sandboxed budgets.
- **Content Packs**: art/text/audio assets and non-privileged content.

All extensions must:
- run inside the **World Sandbox** capability boundary,
- declare required **budgets/limits**,
- pass automated validation before “publish.”

### 8.7 Suggested repo split (conceptual)
- `double-client` (OSS): viewer/player, replay UX, realtime hooks
- `double-sdk` (OSS): schemas, types, module/template interfaces
- `double-world-tools` (OSS): validators, pack builder, testing harness
- `double-reference-worlds` (OSS): starter templates/modules
- `double-runner` (private): always-on orchestration + scheduling + safety/ops
- `double-marketplace` (private): payments, moderation, discovery

### 8.8 How open source supports monetization (the “fair deal”)
- Users get transparency and portability (schemas + client are open).
- Developers get clear extension points and distribution channels.
- The business earns via **hosting always-on compute** and **marketplace distribution**, aligned with real costs.

---

## 8) MVP scope (ship fast)
### MVP must include
- Local Double Gateway install + sign-in
- World Sandbox (small realm, limited districts)
- Primitives: space, actors, items, recipes, ownership, trade
- Daily highlight reel generation (even if basic)
- CityKit v0 (place buildings, define recipes, simple events)

### MVP explicitly excludes
- Real-world messaging integrations
- Full stock exchange order book (use simple marketplace first)
- Large-scale wars (start with small faction conflict)

---

## 9) Risks & mitigations
- **Privacy trust**: solve with world-only default + visible permission panel + local encryption.
- **Cheating/consistency**: use deterministic simulation + authoritative host + event log.
- **Creator chaos**: validate rules/mods, cap budgets, and moderate published templates.
- **Complexity creep**: build primitives + modules, not one-off features.

---

## 10) Open questions to answer next
- What is the first “killer world template” that makes people invite friends?
- How do we keep highlights consistently entertaining (story selection, pacing)?
- What is the best initial platform (Windows/macOS first)?
- What is the simplest paid always-on offering: managed dedicated node vs BYOC?
