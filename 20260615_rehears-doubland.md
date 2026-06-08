# Rehears → Doubland Integration Plan (Post-MVP)

**Goal:** Enable users who create rich personality profiles ("doubles") on ondouble.com to seamlessly access and use them inside doubland.ai simulations, using the same credentials.  
**Approach:** Option A — Shared Supabase project (ondouble as identity + profile authority).  
**Timing:** After MVP Telegram Survival demo (operator-driven, manual claim). Self-serve auth/quiz flows are explicitly deferred until this integration ships.  
**Owner:** Ivan (overall) + Rehears team (auth/profile side) + Nicolas (FE flows in doubland)

---

## Phase 0 — Alignment & Decisions (1 week, pre-kickoff)

1. **Confirm direction**  
   - Both teams agree on Option A (shared Supabase) vs. Option B (API layer).  
   - Document decision and rationale in this file.

2. **Define product boundaries**  
   - ondouble.com = "build & understand your double" (profile engine, quiz, summaries, insights).  
   - doubland.ai = "live with your double in simulations" (simulation layer).  
   - Decide on visible branding: "Powered by Double" treatment inside doubland, or fully separate visual identity?

3. **Answer open questions from Rehears proposal**  
   - Should doubland have its own lightweight signup that immediately redirects to ondouble for profile creation, or require a completed profile first?  
   - Long-term: stay on Supabase or plan external IdP (Clerk/Auth0) once 3+ apps exist?

4. **Success metrics** (lock these before starting)  
   - % of doubland users who arrive with an existing ondouble profile.  
   - Time from doubland signup to first simulation using real personality data.  
   - Reduction in duplicate profile creation attempts.  
   - User feedback on "my double feels consistent across apps."

---

## Phase 1 — Shared Supabase Auth Setup (Week 1)

1. **Configure Supabase project for multi-domain use**  
   - Add doubland.ai (and any subdomains) to allowed redirect URLs in Supabase Auth settings.  
   - Configure CORS origins for both domains.  
   - Verify Google OAuth and magic-link flows work from doubland.ai.

2. **Session / token strategy**  
   - Choose explicit Authorization header + PKCE flow (recommended for cross-domain).  
   - Document cookie limitations and why header-based is safer.  
   - Test session persistence across ondouble.com → doubland.ai handoff.

3. **RLS & access patterns**  
   - Confirm `user_profiles` table + `personality_summary` remain the single source of truth.  
   - doubland reads via service role (or narrowly scoped RLS policies) — never writes to core profile tables.  
   - Create a dedicated `doubland` schema for simulation-specific state (scratch, sim metadata, etc.).

4. **Smoke test**  
   - Register on ondouble → complete personality quiz → log in to doubland with same credentials → confirm profile data is readable.

---

## Phase 2 — Profile Import & Gate Flow (Week 2)

1. **"Double profile ready" gate in doubland**  
   - On first doubland visit: check if authenticated user has a completed `user_profiles` record.  
   - If yes → import latest personality summary + OCEAN percentiles (read-only).  
   - If no → show clear call-to-action: "Create your Double first on ondouble.com" with deep link + return URL.

2. **Graceful account linking / creation flow**  
   - Handle users who land on doubland first (lightweight signup → immediate redirect to ondouble quiz).  
   - After quiz completion, seamless return to doubland with profile loaded.

3. **Data surface for simulations**  
   - Expose (or directly read) the stable personality payload:  
     - OCEAN percentiles + raw scores  
     - `personality_summary` (AI-generated)  
     - Assessment metadata (completion date, version)  
   - Version this payload so future doubland features can request v1, v2, etc.

4. **Local testing harness**  
   - Build a simple "import profile" dev tool that pulls from the shared Supabase for a test user.

---

## Phase 3 — End-to-End User Journey & Polish (Week 3)

1. **Full happy-path test**  
   - New user: ondouble signup → quiz → personality complete → doubland login → first simulation using real traits.  
   - Returning user: doubland login → profile auto-import → simulation.

2. **Error & edge handling**  
   - Profile incomplete / quiz in progress.  
   - Auth token expiry / refresh across domains.  
   - "Double not found" states with clear recovery paths.  
   - Quota / rate-limit messaging (reuse existing Rehears patterns).

3. **UX micro-copy & visual treatment**  
   - Decide on any shared "Double" branding element visible inside doubland.  
   - Add "Your Double" context panel or badge in simulation UI showing key traits.

4. **Monitoring & observability**  
   - Add Sentry breadcrumbs for cross-app auth events.  
   - Track the success metrics defined in Phase 0.

---

## Phase 4 — Production Hardening & Documentation (Week 4)

1. **Security & compliance review**  
   - Re-audit RLS policies for the shared project.  
   - Document data flow for legal / COPPA review (centralized auth + profile storage).  
   - Confirm age/consent handling stays in ondouble.

2. **Operational runbook**  
   - How to add new redirect URLs when new doubland subdomains appear.  
   - How to debug "user logged in on one app but not the other."  
   - Rollback plan if shared Supabase causes issues (fallback to Option B API layer).

3. **Future escape hatch**  
   - Sketch the minimal "Double API" surface (JWT-validated) that would allow Option B decoupling later.  
   - Keep core trait + summary schema stable; any simulation-specific extensions live in doubland tables only.

4. **Handover & sign-off**  
   - Both teams review live flow together.  
   - Update this doc with any deviations or learnings.  
   - Announce to Telegram alumni group / early users.

---

## Open Decisions (to resolve before Phase 1)

- Exact redirect URL list for doubland.ai domains.
- Whether doubland shows any "Powered by Double" visual treatment.
- Long-term IdP strategy (stay Supabase or move to Clerk/Auth0 at 3+ apps).
- Whether the quiz completion gate is hard (block simulation) or soft (allow limited sims with synthetic profile).

---

## References

- Rehears proposal (2026-06-08) — the source of Option A/B analysis and 4-week timeline.
- `sot_lifecycle.md` §6 — current operator-driven onboarding wizard (will be replaced/augmented by this self-serve flow post-MVP).
- MVP Release Gate (`20260605_mvp-release-gate.md`) — explicit scope guard: self-serve auth/quiz deferred until after Telegram Survival demo.

**Next step after MVP:** Schedule 30-minute technical walkthrough with Rehears team to map exact Supabase config changes.