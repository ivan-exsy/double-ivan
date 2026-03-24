
# Double v1 — Monetization Vision (Fair by default, sustainable, extensible)

## 0) One-sentence strategy
**Free = world-only autonomy while your device is on. Paid = you pay for always-on compute + bigger simulation budgets + creator distribution.**

This keeps the product trustworthy (you’re not selling access to personal data) and aligns revenue with the real variable costs (CPU, storage, bandwidth, support).

---

## 1) Monetization principles (non-negotiables)

### 1.1 Fairness & trust
- Users should never feel “paywalled from their Double.” Paid tiers upgrade **uptime, scale, and convenience**, not ownership.
- **World-only by default**: monetization should not depend on reading private real-world data.
- **Transparent budgets**: users can see what they’re paying for (agents, ticks/day, storage days, render minutes).

### 1.2 Cost coverage by default
- Default paid plan is priced to cover:
  - always-on runner compute,
  - database/realtime,
  - storage (event log + snapshots),
  - egress/bandwidth,
  - observability + support overhead.

### 1.3 Open ecosystem, owned platform
- Encourage external builders via open SDKs/tools/modules.
- Monetize via **hosting + marketplace distribution + premium infrastructure**, not by restricting basic creative expression.

---

## 2) Core value ladder (what users pay for)

### 2.1 What free users get (value without resentment)
**Free = “my Double lives in the world when I’m online.”**
- Double autonomy **runs when the user device is on** (or scheduled “awake windows” while app is open).
- 1 realm, small simulation budget (small number of agents/NPCs, limited ticks/day).
- Story stream / replay viewing + shareable replay link.
- Lightweight daily digest (text storybeats + bookmarks), no video export required.

### 2.2 What paid users get (obvious, fair upgrade)
**Paid = “my Double lives independently 24/7.”**
- Always-on hosting (“Double Node”): the realm advances autonomously even when user devices are offline.
- Larger simulation budgets (more agents/NPCs, bigger worlds, faster tick cadence, longer history retention).
- Reliability & QoL: higher rate limits, faster catch-up, stronger durability guarantees.

### 2.3 What creators pay for (tools + distribution)
**Creator = “I can publish worlds/modules and earn.”**
- Publishing pipeline: template validation, versioning, trust labels.
- Analytics: retention, time spent, moment heatmaps, conversion metrics.
- Revenue share eligibility (see marketplace section).

---

## 3) Tiering model (recommended)

### 3.1 Free (Local-first starter)
Best for curiosity and low-cost onboarding.
- Realm hosting: **device-on only**
- Budgets: low (cap ticks/day, agent count, history retention)
- Sharing: replay link (public/unlisted/friends)
- Support: community only

### 3.2 Plus (Always-on)
The “covers costs” plan.
- Realm hosting: **always-on Double Node**
- Budgets: medium
- Retention: longer
- Priority: higher throughput + fewer queue delays
- Includes: “realm export” tools (event log snapshots) for user trust (even if inconvenient)

### 3.3 Pro (Power users / heavy realms)
For squads, streamers, and long-running worlds.
- Realm hosting: always-on
- Budgets: high (more agents, higher tick rate, larger districts)
- More realms + larger worlds
- Advanced controls: scheduling, realm backups, admin tools

### 3.4 Creator (Publishing + monetization)
For world designers and module authors.
- Publish templates/modules
- Validation + testing harness
- Analytics + A/B rollout tools for templates
- Eligibility for marketplace payouts

---

## 4) Pricing unit: “Simulation Budget” (the fairness mechanism)
Use a simple and visible budget abstraction users can understand:
- **Ticks/day** (time progression)
- **Active agents** (Doubles + NPCs)
- **World size** (district tiles / chunks)
- **Storage retention** (days of replay history)
- **Optional render minutes** (if/when video export returns)

UI should expose:
- Current plan limits
- Current usage
- What happens at limit (pause progression, degrade NPC count, reduced tick rate, etc.)

---

## 5) Marketplace monetization (future upside)

### 5.1 What’s sold
- World templates (scenarios, cities, rulesets)
- Module packs (economy, law, conflict) as optional add-ons
- Cosmetic/story packs (non-core, low-risk)

### 5.2 Platform take rate
- Recommended: **10–20% platform fee** + pass-through payment processing.
- Incentive: lower fee for high-trust creators or exclusives (optional later).

### 5.3 Payout model
- Revenue share to creators based on direct purchases (simple and fair).
- Optional later: usage-based bonuses (watch time, retention) if you can do it without gaming.

---

## 6) “Highlights” monetization (deferred, but planned)
Video highlights are expensive (compute + storage) and should be optional.

### 6.1 MVP baseline (free)
- Text digest + bookmarks (“top 5 moments today”) + share replay link.

### 6.2 Paid upgrades (later)
- One-click rendered clip exports (MP4), watermark-free
- Higher quality story selection / pacing
- Longer exports, higher resolution, more retention

---

## 7) Infrastructure decision note (for always-on hosting)

### Option A (Supabase-native)
- **Why it works**: great for auth, database, realtime, scheduled lightweight jobs.
- **Why it fails**: always-on simulation progression tends to be long-running and CPU-heavy; timeouts and orchestration limits make “24/7 worlds” brittle.

### Option B (Dedicated)
- **Why it’s worth it**: a dedicated runner/worker service makes always-on progression reliable, observable, and cost-controllable per realm.
- **Costs/ops**: you pay for a small always-on service + monitoring, but it maps cleanly to subscription revenue.

### Recommendation
**Use a dedicated always-on runner for paid tiers**; keep Supabase as the SOT for identity, state, realtime, and billing metadata.

---

## 8) Open-source alignment (attract devs without losing monetization)
- Open (permissive) the **SDKs, client viewer, template tooling, validators**.
- Keep proprietary the **production runner/orchestrator**, anti-abuse systems, hosted marketplace, and premium highlight generation pipeline.
- Use a trademark policy to protect the “official Double” brand.

---

## 9) Anti-abuse & reliability (monetization protection)
- Rate limits and budgets are product features, not just infra:
  - cap CPU/tick, events/tick, entities touched/action
  - backpressure + graceful degradation at limits
- Prevent “free plan farming”:
  - restrict number of realms, ticks/day, retention
  - require verification for creator payouts

---

## 10) Rollout plan (phased so you can ship)

### Phase MVP
- Free (device-on) + Plus (always-on) subscriptions
- Replay link sharing + text digest (no video)
- One curated realm template

### Phase V1.1
- Pro tier (bigger worlds + higher budgets)
- Basic marketplace (templates only)

### Phase V1.2+
- Module marketplace + creator analytics
- Paid highlight exports (optional)

