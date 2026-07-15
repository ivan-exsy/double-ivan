# Expert inquiry — Week 3.3 post-chat profile learning (behavior science)

**To:** Behavior science / assessment specialist (Doubland team)  
**From:** Ivan / product + engineering (self-serve Double epic)  
**Date:** 2026-07-14  
**Status:** **Accepted 2026-07-14** — engineering may implement Week 3.3 from §9 (COS `2026-07-14-003`); FE confirm UI required before Path A apply  
**Epic:** `EPIC_self-serve-double.md`  
**Related:** Week 3 interview inquiry (accepted); Week 3.1 identity publish (Path A); Week 3.2 Talk-to-my-Double **API** (BE wire; FE deferred)  
**Audience:** Subject-matter expert (not engineering). Engineering will implement your recommendations as specified under **Week 3.3**.

---

## 1. Why we are asking you

Users will soon chat with **their own Double** (creator-mode rehearsal). Each session is a rich sample of how the person describes themselves, corrects the Double, reveals priorities, and reacts under low-stakes conversation.

We want a responsible **post-session assessment loop**:

> After a chat-with-my-Double session, analyse the transcript for **reliable, non-clinical** signal that should update the Double’s psychological / life profile so future chat and (later) in-sim predictions improve.

**Engineering owns:** when to trigger jobs, storage, auth, identity publish into scratch ISS, chat plumbing.  
**We need you to own:** what may be inferred, what must never be inferred, evidence thresholds, how updates merge with quiz/interview chapters, user consent/transparency, and product copy.

We will **not** ship automatic profile mutation from chat without your report.

---

## 2. What is already shipped (context only — do not redesign unless blocking)

| Piece | Status | Notes |
|-------|--------|--------|
| IPIP-BFM-25 quiz | Live | Domain means 1–5; bands lower/typical/higher; not clinical |
| Interview v1 (`double-interview-v1`) | Live | Expert-approved; maps to `innate` / `learned` / `currently` / `lifestyle` / `goals` |
| `prediction_ready` | Live | Hard gate for “my Double” claims |
| Identity publish (Week 3.1 Path A) | Live | Active chapter → scratch ISS + profile docs; retakes archive prior chapters |
| Creator chat | Live (API) | Same chat stack as cast Doubles; creator framing when owner + ready |
| Talk-to-my-Double **API** (Week 3.2) | In progress | `GET/POST /api/me/double*`; personal host sim; **no FE button yet** |
| Talk-to-my-Double **UI** | Deferred (D1-FE) | Not in this inquiry’s critical path |

**Identity model (locked product framing):**

- **Temperament** (slow): largely quiz → `innate`  
- **Life chapter** (faster): interview → `learned` / `currently` / `lifestyle` / `goals`  
- **Lived memory**: sim steps + chat memory injection (episodic) — separate from ISS  
- **One active chapter** at a time; retakes supersede and archive  

Post-chat learning must fit this model without creating a silent third personality system.

---

## 3. Product intent for Week 3.3 (content is yours)

**Goal:** After a creator chat session ends (or on a clear trigger you define), produce a **structured, reviewable assessment** that may:

1. Propose updates to the Double’s profile (which fields, what text, what confidence).  
2. Optionally write **episodic** memories (“what we talked about”) without changing ISS.  
3. Improve future creator chat and, later, in-sim decisions via Path A publish when an update is accepted.

**Success criterion for engineering:** we can open tickets and ship Week 3.3 without inventing psychological rules.

**Explicit non-goals for this inquiry**

- Clinical diagnosis, therapy, risk scoring for self-harm, or medical claims  
- Secretive profile changes the user cannot understand or undo  
- Replacing quiz/interview as primary assessment instruments  
- Full continuous “always-on surveillance” of every message without a session boundary  
- Teen instruments  

---

## 4. Decisions we need from you

Please structure the reply so engineering can implement without reinterpretation. Prefer **concrete artifacts** (decision trees, field-level rules, copy strings, schemas) over abstract theory alone.

### A. Purpose and constructs

1. What is the scientific/product purpose of post-chat learning in one paragraph?  
2. Which constructs may chat legitimately update vs must **never** update from chat alone?  
   - e.g. Big Five means, life aims, lifestyle, speaking style, values, relationships, health, trauma  
3. How does this relate to interview “life chapter” vs quiz “temperament”?

### B. Session boundary and triggers

1. When does a “session” end? (idle timeout, explicit “end chat”, message count, user leaves page, daily batch)  
2. Minimum transcript length / turns before any analysis runs?  
3. Max frequency (e.g. once per session, at most N/day) to avoid over-updating?  
4. Should analysis run **async after session** only, or also mid-session (we prefer after-session for v1 unless you require otherwise)?

### C. Evidence rules

1. What counts as **sufficient evidence** to propose a profile change (direct self-statement vs model inference vs contradiction of prior chapter)?  
2. Handling of **jokes, hypotheticals, roleplay, and “what if”** — how do we avoid false learning?  
3. Handling of **corrections** (“No, I don’t work in finance anymore”) — priority over older interview text?  
4. Multi-session consistency: require repeated signal vs single clear statement?  
5. Confidence levels you want engineering to store (e.g. low / medium / high) and what each may auto-apply vs require user confirm.

### D. Output schema (what the model must return)

Please specify a **versioned JSON schema** for the post-chat assessment, e.g. fields such as:

- `proposed_soul_patches` (per ISS field: new text or null, rationale, evidence quotes, confidence)  
- `proposed_memory_nodes` (episodic only)  
- `do_not_update` reasons  
- `user_facing_summary` (what we tell the user we learned)  
- `safety_flags` (only non-clinical product safety you endorse — or “none; escalate to human policy”)

Engineering will not invent this schema without you; a draft we can rubber-stamp is ideal.

### E. Apply policy (human-in-the-loop vs automatic)

1. **Default for v1:** we lean **propose → user confirm → Path A publish**, not silent overwrite. Confirm or revise.  
2. Which low-risk updates (if any) may auto-apply without confirmation?  
3. How do confirmed updates interact with **identity_revision** / chapter archive (same as interview retake, or a distinct `source=post_chat` chapter)?  
4. Should quiz scores ever move from chat? (We assume **no** unless you say yes with strong justification.)

### F. Ethics, consent, transparency

1. Consent copy at first creator chat and/or after session.  
2. What the user sees after analysis (“We noticed… Update your Double?”).  
3. Opt-out: disable post-chat learning entirely.  
4. Retention: how long raw transcripts and assessment artifacts are kept; what must not enter public trailers/sims.  
5. Sensitive topics: exclusion list and “refuse to learn” rules aligned with interview inquiry.

### G. Prompting / model use (high level)

1. Should assessment use a **different model tier** or temperature than in-character chat? (Engineering can implement; you set quality bar.)  
2. Must the assessor model **not** roleplay as the Double (separate system prompt)?  
3. Any required disclaimers in the assessor prompt (practice mirror, not diagnosis)?

### H. Evaluation

1. How do we know post-chat learning helps? (e.g. user rates “more like me”, blind A/B on next session, expert rubric)  
2. Failure modes to monitor (sycophancy, over-updating from one vent, stereotype injection).

---

## 5. Engineering constraints (for your awareness)

- Chat already injects exchanges into memory for **same-day sim influence** (episodic) — separate from ISS.  
- Path A publish writes active `soul_seeds` → scratch ISS; retakes archive to `user_identity_versions`.  
- Creator chat is private to the owner; still treat free text as sensitive.  
- No FE for “Talk to my Double” yet; analysis can be API-triggered when session ends even before UI polish.  
- Prefer **no new env flags** unless you require a kill switch name; product default can be code-level until you specify.

---

## 6. What to deliver (report checklist)

- [ ] Purpose paragraph + construct allow/deny list  
- [ ] Session trigger rules + frequency caps  
- [ ] Evidence / confidence rules  
- [ ] Versioned assessment JSON schema  
- [ ] Apply policy (confirm vs auto) + interaction with identity chapters  
- [ ] User-facing copy (consent, summary, confirm, opt-out)  
- [ ] Safety / sensitive-topic rules  
- [ ] Evaluation criteria for “learning helped”  
- [ ] Explicit **Week 3.3 implementation order** (what eng ships first)

---

## 7. Timeline note

| Track | Status |
|-------|--------|
| Week 3.2 Talk-to-my-Double **API** | Engineering implementing now |
| Week 3.2 Talk-to-my-Double **UI** | Deferred (D1-FE) |
| Week 3.3 post-chat learning | **Blocked on this report** |

Please mark your reply **Accepted** with a COS-style id when ready for implementation, same pattern as the Week 3 interview inquiry.

---

## 8. One-line ask

**Tell us what we may learn from creator chat, how sure we must be, what we show the user, and how updates become the Double’s next living chapter — without turning rehearsal into covert assessment or clinical claims.**
---

## 9. Expert recommendations — jordanpeterson (COS)

**Source:** COS task `2026-07-14-003` · specialist `jordanpeterson` (Peterson-informed; not Jordan Peterson)  
**Date:** 2026-07-14  
**Risk:** high (chat-derived psychographic updates) — **founder approved 2026-07-14**; mitigated by user verify + mandatory FE review UI before Path A.  
**Canonical copy:** `d:\Coding\COS\tasks\2026-07-14-003\final.md` · KB: `agents/jordanpeterson/kb/raw/task-deliverables/2026-07-14-week33-post-chat-learning.md`

**Task:** `2026-07-14-003`  
**Specialist:** jordanpeterson (Peterson-informed; not Jordan Peterson)  
**Date:** 2026-07-14  
**Inquiry:** `double-ivan/rehears-double/20260714_behavior_science_inquiry_week3_3_post_chat_learning.md`  
**Status:** Draft for COS review → founder `pending_approval`  
**Prior lock:** Week 3 interview + Path A identity publish (`raw/task-deliverables/2026-07-14-week3-interview-recommendations.md`; `wiki/decision/self-serve-interview-v1.md`)

---

## Meta

| Field | Value |
|-------|--------|
| Epistemic posture | Formal claims labeled **Measured** / **Evidence-based** / **Peterson-informed** / **Agent hypothesis**. Product copy stays plain-language. |
| Risk | **High** — chat-derived psychographic updates on real adult users. Escalates to COS `pending_approval`. |
| Audience | Adult Doubland owners only; English; creator-mode rehearsal chat. |
| Instrument lock | IPIP-BFM-25 + `double-interview-v1` remain primary assessment instruments. Chat is a **profile-update** channel (raw/00 Mode 8), not a new trait instrument. |
| Routing used | A0 → A12 → A1 (reliability/validity), A5 (aims/listening), A3 (prediction humility); B2 lightly (truth/speech, listening). |
| Product framing | Double as practice mirror / rehearsal — not clinical therapy (aligned Week 3 §D1; A5 method analogy ≠ product claim). |
| Locked identity model | **Temperament (slow):** quiz → `innate`. **Life chapter (faster):** interview → `learned` / `currently` / `lifestyle` / `goals`. **Lived memory:** episodic via P3-1 chat write-back — **not** ISS. One active chapter; Path A publish; retakes archive. |

**Evidence categories used below:** SELF-REPORT (user chat utterances), OBSERVED (transcript structure / correction speech acts), DIGITAL TRACE (session metadata), INFERRED (assessor compression), SPECULATIVE (forbidden as apply signal in v1).

**Hard product rule (this report):** Chat must **not** move Big Five means/bands or rewrite `innate` in v1. No blocking justification exists to override that default (see §A2, §E4).

### Founder product lock (2026-07-14) — user verify + FE required

**Privacy / trust mitigation is the confirm step itself:** the owner reviews and accepts (or edits/dismisses) every life-chapter patch before Path A publish. That is the elegant path — not silent inference.

| Rule | Spec |
|------|------|
| ISS / soul_seeds mutation | **Forbidden** until the owner confirms via a **first-class FE review UI** (not API-only, not toast-only) |
| FE scope for Week 3.3 | Ship a **Post-chat update review** surface (see §F2 / §FE): consent, summary, per-field before/after, edit, save, dismiss, opt-out. May live on Talk-to-my-Double or Profile; **must not wait** on full village polish. |
| Talk-to-my-Double chat UI (D1-FE) | Still may be thin; **confirm UI is not optional** for enabling auto-assess → apply in product |
| API-only phase | Assessor may run and **store** proposals for smoke; **no Path A apply in user-facing product** until confirm FE is live |

---

## A. Purpose and constructs

### A1. Purpose (one paragraph)

**Peterson-informed + Evidence-based.** Post-chat learning exists so that when an adult owner rehearses with their own Double, explicit self-descriptions, corrections, and concrete life-chapter updates in the transcript can be turned into a **reviewable, non-clinical proposal** to refresh the Double’s *life chapter* fields (`learned` / `currently` / `lifestyle` / `goals`) — and optionally to propose episodic memory nodes — without inventing a third personality system or silently mutating temperament scores. The quiz remains the MEASURED baseline-trait channel (trait ≈ sub-personality within a diverse unity — raw/A1; raw/A12 §Trait); the interview remains the structured chapter intake; chat is Mode-8 **profile update** evidence: high-signal when the user corrects or renames their present chapter, low-signal when they joke, roleplay, vent once, or speculate (raw/00; raw/A1 demand for behavioral evidence before trait ratings). Reliability requires stable measurement across occasions (raw/A1); a single chat turn is usually too thin to rewrite disposition. Validity requires measuring what we claim (raw/A1) — here we claim “user-stated life chapter updates,” not “new Big Five scores from casual talk.” Prediction humility (raw/A3): match the Double’s *situation language* to what the person says now; do not remake temperament from rehearsal banter.

### A2. Construct allow / deny list

#### May update from chat (life chapter + episodic only)

| Construct | ISS / store target | Allowed? | Notes |
|-----------|-------------------|----------|-------|
| Background / how they see the world (self-described) | `learned` | **Yes — propose only** | Prefer user nouns/verbs; append or revise chapter text; never invent childhood trauma |
| Current life chapter / pressures | `currently` | **Yes — propose only** | Align with interview chapter language (building / stabilizing / transition / etc.) when possible |
| Day-to-day rhythm | `lifestyle` | **Yes — propose only** | Concrete schedule/energy patterns the user asserts as typical *now* |
| Near-term aims the user owns | `goals` (+ `currently` Aim clause) | **Yes — propose only** | Subject-defined “better” (raw/A5); voluntary responsibility framing internal only |
| Explicit corrections of prior chapter text | same fields | **Yes — high priority** | “No, I don’t work in finance anymore” outranks older interview text when confirmed |
| Episodic “what we talked about” | `dbl_memory` / proposed_memory_nodes | **Yes** | Separate from ISS; P3-1 already writes chat exchanges — assessor may propose *curated* episodic summaries, not duplicate every turn |
| Speaking style / voice quirks | — | **No as ISS field in v1** | Do not create a parallel “voice profile” personality system; optional open research |

#### Must never update from chat alone (v1)

| Construct | Why denied |
|-----------|------------|
| Big Five domain means (1–5) | MEASURED only via IPIP-BFM-25; chat lacks reliability/validity for score mutation (raw/A1) |
| Band labels on OCEAN (`lower`/`typical`/`higher`) | Derived from quiz means only |
| `innate` soul text | Deterministic quiz template only (Week 3 §B); chat must not rewrite |
| Aspect-level claims (e.g., industriousness vs orderliness) | Not scored by IPIP-BFM-25 (Week 3 §D3; A6) |
| Clinical diagnoses, disorder labels, therapy plans | Out of scope; not clinicians (Week 3 §A6/§F) |
| Trauma / abuse inventories; PTSD; self-harm risk scores | Hard exclusion aligned Week 3 §A6 |
| Medical diagnoses, medications, disability deep-detail | Same |
| Illegal activity / substance-dependence screening as profile fact | Same |
| Sexual history / forced orientation disclosure | Same |
| Politics / culture-war identity tests | Same |
| Third-party personality profiles (partner, boss, friend) | Consent + weaponization guard (raw/00); Week 3 §A6/§F1 |
| IQ / intelligence scores | Not measured (raw/A3) |
| Population percentiles | No norms table |
| Covert “true personality” inferred against user’s self-description | Speculative; fails honesty + listening posture (raw/A5; B2 Rule 9 lightly) |

### A3. Relation to interview “life chapter” vs quiz “temperament”

```
Quiz (slow)          → innate          → temperament / baseline traits
Interview (medium)   → learned|currently|lifestyle|goals → life chapter v1 seed
Creator chat (fast)  → propose patches to life chapter fields + episodic memory
                     → user confirm → Path A publish (new identity_revision)
                     → does NOT replace quiz; does NOT auto-rerun interview
```

- **Temperament** stays quiz-owned. Chat may *mention* traits (“I’m shy”) — treat as SELF-REPORT color for `learned`/`currently` wording only if user wants that language in chapter text; **never** as a score change.  
- **Life chapter** is the only ISS surface chat may propose to change.  
- **Lived memory** remains episodic (P3-1 / proposed_memory_nodes) — not a silent third ISS personality layer.  
- Completeness / `prediction_ready` gate from Week 3 §C is a **prerequisite** for running post-chat learning (no learning on incomplete owned Doubles).

---

## B. Session boundary and triggers

### B1. When a “session” ends (v1)

Use **any** of the following as a session-end trigger (first that fires):

| Trigger | Spec | Priority |
|---------|------|----------|
| Explicit end | Client calls `POST .../session/end` (or equivalent) with `thread_id` | Preferred when UI exists |
| Idle timeout | No new user message for **15 minutes** after last user message | Default for API-only phase |
| Thread message cap | Thread hits existing max (**25** messages — `sot_chats.md` §6.7) | Treat as session end |
| User leaves (best-effort) | `visibilitychange` / unload beacon when FE exists | Nice-to-have; not required for v1 API |

**Do not** treat each message as a learning session.

### B2. Minimum transcript before analysis

| Gate | v1 requirement |
|------|----------------|
| Min user turns | **≥ 3** user messages in the session window |
| Min user chars (aggregate) | **≥ 120** characters across user messages |
| Owned + ready | `prediction_ready === true`; creator-mode / owner auth |
| Opt-out | Skip if `post_chat_learning_enabled === false` |

If gates fail: write assessment with `status: "skipped"`, empty patches, reason in `do_not_update`.

### B3. Frequency caps

| Cap | Value |
|-----|-------|
| Per session | **At most 1** assessment job |
| Per user per UTC day | **At most 3** assessments that produce non-empty `proposed_soul_patches` |
| Per user per UTC day (any assessment including empty) | **At most 6** jobs (cost guard) |
| Concurrent | One in-flight assessment per `thread_id` |

If over cap: skip with `do_not_update.reason_code = "frequency_cap"`.

### B4. Async vs mid-session

**v1: async after session only.**  
No mid-session ISS proposals. Mid-session learning would blur rehearsal with covert assessment and increase over-update risk from a single vent (raw/A1 reliability).  
Episodic P3-1 write-back of raw exchanges may continue as today — that is **not** this assessor loop.

---

## C. Evidence rules

### C1. Sufficient evidence to propose a profile change

Use a **speech-act + evidence-tier** model. Assessor must classify each candidate claim:

| Tier | Definition | May propose ISS patch? | Confidence ceiling |
|------|------------|------------------------|--------------------|
| **E0 — Non-evidence** | Joke, sarcasm, roleplay, hypothetical, “what if”, quoting others, Double’s words treated as user fact | **No** → `do_not_update` | — |
| **E1 — Soft self-description** | Vague trait adjectives without concrete life fact (“I’m chaotic”) | **No** for ISS in v1 (may note in summary as “heard but not applied”) | — |
| **E2 — Concrete self-statement** | Present-tense fact about work, place, rhythm, aim, relationship *role* (not third-party profile) | **Yes** | `medium` max unless also E3 |
| **E3 — Explicit correction / directive** | “Actually…”, “No, I don’t…”, “Update my Double…”, “I no longer…” | **Yes — priority** | `high` allowed |
| **E4 — Repeated across sessions** | Same concrete fact in ≥2 sessions within 14 days | **Yes** | `high` allowed |
| **E5 — Model-only inference** | Assessor invents motive/diagnosis/trait score from tone | **Never** apply; if emitted, strip in validator | — |

**Minimum to emit a `proposed_soul_patches[]` item:**

1. Tier **E2+** (or E3/E4), and  
2. At least **one verbatim evidence quote** from a **user** message (not assistant), and  
3. Quote length ≥ 12 chars, and  
4. Target field in allow list (§A2), and  
5. Patch does not introduce deny-list content (§A2 / §F5).

**Contradiction of prior chapter:** If new E2/E3 conflicts with active `learned`/`currently`/`lifestyle`/`goals`, propose a **replace** or **revise** op with `rationale` naming the conflict. Do not silently merge incompatible facts.

### C2. Jokes, hypotheticals, roleplay, “what if”

| Pattern | Detection cue (non-exhaustive) | Action |
|---------|--------------------------------|--------|
| Joke / sarcasm | “lol”, “jk”, “not really”, hyperbolic absurdity | `do_not_update`; reason `nonliteral` |
| Hypothetical | “what if”, “suppose”, “imagine if” | `do_not_update`; reason `hypothetical` |
| Roleplay | “pretend you are”, “let’s act like”, in-character scenario play | `do_not_update`; reason `roleplay` |
| Quoting Double back as self | User repeats Double’s invented bio | Prefer prior chapter + user corrections only; do not learn Double→user |

Default when uncertain: **do_not_update** (fail closed).

### C3. Corrections — priority

| Rule | Spec |
|------|------|
| Priority | E3 corrections **outrank** older interview text and earlier chat proposals for the same field |
| Scope | Only the contradicted clause/field — not a full chapter wipe unless user asks |
| Quiz | Corrections about “I’m not introverted” still **do not** move quiz means; offer user-facing note: “Temperament scores change only if you retake the quiz.” |
| Confirm UX | Show before/after for the touched field |

### C4. Multi-session consistency

| Confidence | Consistency rule (v1) |
|------------|------------------------|
| `low` | Single E2 statement, or weak wording — **propose only**; never auto-apply (v1 has no auto ISS apply anyway) |
| `medium` | Clear E2 with concrete nouns; or E2 + supporting context in same session |
| `high` | E3 explicit correction **or** E4 repeated across sessions **or** user said “please update my Double to …” |

**v1 does not require** two sessions before proposing — a single clear E3 is enough to *propose*. Auto-apply remains off for all ISS patches (§E).

### C5. Confidence storage and apply gates

| Confidence | Store? | Auto-apply ISS? (v1) | User confirm? |
|------------|--------|----------------------|---------------|
| `low` | Yes | **Never** | Required to apply; UI may de-emphasize |
| `medium` | Yes | **Never** | Required |
| `high` | Yes | **Never** for ISS in v1 | Required (still) |
| Episodic memory proposals | Yes | **Optional auto** only for non-sensitive curated memory nodes (§E2) | Soft; can default-on with toast |

---

## D. Output schema (versioned JSON)

**Schema id:** `double-post-chat-assessment-v1`  
**Version:** `2026-07-14`

### D1. TypeScript-like schema (implement exactly)

```typescript
/** double-post-chat-assessment-v1 — 2026-07-14 */

type AssessmentStatus =
  | "proposed"      // has reviewable patches and/or memory nodes
  | "empty"         // ran; nothing safe to propose
  | "skipped"       // gates/caps/opt-out
  | "refused";      // safety refuse (sensitive / clinical / third-party)

type SoulField = "learned" | "currently" | "lifestyle" | "goals";
// NOTE: "innate" is intentionally absent — chat must not patch it.

type PatchOp = "replace" | "append" | "revise_clause";
type Confidence = "low" | "medium" | "high";
type EvidenceTier = "E0" | "E1" | "E2" | "E3" | "E4" | "E5";

type DoNotUpdateReasonCode =
  | "insufficient_turns"
  | "insufficient_chars"
  | "frequency_cap"
  | "opt_out"
  | "not_prediction_ready"
  | "nonliteral"
  | "hypothetical"
  | "roleplay"
  | "inference_only"
  | "trait_score_forbidden"
  | "sensitive_topic"
  | "third_party"
  | "clinical_content"
  | "no_concrete_signal"
  | "assessor_error";

type SafetyFlagCode =
  | "none"
  | "sensitive_disclosure_present"  // store; do not learn into ISS
  | "third_party_mention"
  | "clinical_sounding_language"
  | "self_harm_language_present"    // do not diagnose; escalate to product safety policy — assessor must not risk-score
  | "illegal_activity_mention";

interface EvidenceQuote {
  message_id: string;          // user_chat_messages id
  speaker: "user";             // assistant quotes forbidden as sole evidence
  quote: string;               // verbatim substring ≤ 280 chars
  evidence_tier: EvidenceTier;
}

interface ProposedSoulPatch {
  field: SoulField;
  op: PatchOp;
  /** Full proposed field text after op (not a diff hunk). Must respect char caps. */
  proposed_text: string;
  /** Active chapter text before patch (echo for UI diff). */
  previous_text: string;
  rationale: string;           // ≤ 280 chars; plain language
  evidence: EvidenceQuote[];   // ≥ 1 for every patch
  confidence: Confidence;
  /** If true, conflicts with active chapter; UI must highlight. */
  conflicts_with_active: boolean;
}

interface ProposedMemoryNode {
  /** Curated episodic summary — not a trait claim. */
  summary: string;             // ≤ 400 chars
  evidence: EvidenceQuote[];
  confidence: Confidence;
  /** Hint for eng: memory_type to use when writing (default "chat" or "thought"). */
  suggested_memory_type: "chat" | "thought" | "event";
  poignancy: number;           // integer 1–10; default 5 for curated summaries
  sensitive: boolean;          // if true, never auto-apply; never public surfaces
}

interface DoNotUpdateItem {
  reason_code: DoNotUpdateReasonCode;
  detail: string;              // ≤ 200 chars
  related_quote?: string;
}

interface PostChatAssessmentV1 {
  schema_id: "double-post-chat-assessment-v1";
  schema_version: "2026-07-14";
  assessment_id: string;       // uuid
  status: AssessmentStatus;

  subject: {
    user_id: string;
    persona_id: string;
    thread_id: string;
    session_id: string;        // eng-defined session grouping id
    identity_revision_at_assess: number;
  };

  timing: {
    session_ended_at: string;  // ISO-8601
    assessed_at: string;       // ISO-8601
    user_turn_count: number;
    user_char_count: number;
  };

  /** What we tell the user we noticed — never clinical. */
  user_facing_summary: string; // ≤ 500 chars; empty if skipped/refused with no UI

  proposed_soul_patches: ProposedSoulPatch[];
  proposed_memory_nodes: ProposedMemoryNode[];
  do_not_update: DoNotUpdateItem[];

  safety_flags: {
    codes: SafetyFlagCode[];
    /** Free text for eng logs only — not shown in public UI. */
    notes_internal: string;
  };

  /** Assessor must always declare innate untouched. */
  innate_policy: {
    touched: false;
    note: "Chat assessment must not modify innate or Big Five means/bands.";
  };

  model_meta: {
    assessor_model: string;
    temperature: number;
    prompt_version: string;    // e.g. "post-chat-assessor-v1"
  };
}
```

### D2. JSON Schema (draft-07 style, concrete)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://doubland.local/schemas/double-post-chat-assessment-v1.json",
  "title": "double-post-chat-assessment-v1",
  "type": "object",
  "required": [
    "schema_id",
    "schema_version",
    "assessment_id",
    "status",
    "subject",
    "timing",
    "user_facing_summary",
    "proposed_soul_patches",
    "proposed_memory_nodes",
    "do_not_update",
    "safety_flags",
    "innate_policy",
    "model_meta"
  ],
  "properties": {
    "schema_id": { "const": "double-post-chat-assessment-v1" },
    "schema_version": { "const": "2026-07-14" },
    "assessment_id": { "type": "string", "format": "uuid" },
    "status": {
      "enum": ["proposed", "empty", "skipped", "refused"]
    },
    "subject": {
      "type": "object",
      "required": [
        "user_id",
        "persona_id",
        "thread_id",
        "session_id",
        "identity_revision_at_assess"
      ],
      "properties": {
        "user_id": { "type": "string" },
        "persona_id": { "type": "string" },
        "thread_id": { "type": "string" },
        "session_id": { "type": "string" },
        "identity_revision_at_assess": { "type": "integer", "minimum": 0 }
      }
    },
    "timing": {
      "type": "object",
      "required": [
        "session_ended_at",
        "assessed_at",
        "user_turn_count",
        "user_char_count"
      ],
      "properties": {
        "session_ended_at": { "type": "string", "format": "date-time" },
        "assessed_at": { "type": "string", "format": "date-time" },
        "user_turn_count": { "type": "integer", "minimum": 0 },
        "user_char_count": { "type": "integer", "minimum": 0 }
      }
    },
    "user_facing_summary": { "type": "string", "maxLength": 500 },
    "proposed_soul_patches": {
      "type": "array",
      "maxItems": 4,
      "items": {
        "type": "object",
        "required": [
          "field",
          "op",
          "proposed_text",
          "previous_text",
          "rationale",
          "evidence",
          "confidence",
          "conflicts_with_active"
        ],
        "properties": {
          "field": {
            "enum": ["learned", "currently", "lifestyle", "goals"]
          },
          "op": { "enum": ["replace", "append", "revise_clause"] },
          "proposed_text": { "type": "string", "maxLength": 600 },
          "previous_text": { "type": "string", "maxLength": 600 },
          "rationale": { "type": "string", "maxLength": 280 },
          "evidence": {
            "type": "array",
            "minItems": 1,
            "items": {
              "type": "object",
              "required": ["message_id", "speaker", "quote", "evidence_tier"],
              "properties": {
                "message_id": { "type": "string" },
                "speaker": { "const": "user" },
                "quote": { "type": "string", "minLength": 12, "maxLength": 280 },
                "evidence_tier": {
                  "enum": ["E0", "E1", "E2", "E3", "E4", "E5"]
                }
              }
            }
          },
          "confidence": { "enum": ["low", "medium", "high"] },
          "conflicts_with_active": { "type": "boolean" }
        }
      }
    },
    "proposed_memory_nodes": {
      "type": "array",
      "maxItems": 3,
      "items": {
        "type": "object",
        "required": [
          "summary",
          "evidence",
          "confidence",
          "suggested_memory_type",
          "poignancy",
          "sensitive"
        ],
        "properties": {
          "summary": { "type": "string", "maxLength": 400 },
          "evidence": { "type": "array", "minItems": 1 },
          "confidence": { "enum": ["low", "medium", "high"] },
          "suggested_memory_type": {
            "enum": ["chat", "thought", "event"]
          },
          "poignancy": { "type": "integer", "minimum": 1, "maximum": 10 },
          "sensitive": { "type": "boolean" }
        }
      }
    },
    "do_not_update": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["reason_code", "detail"],
        "properties": {
          "reason_code": { "type": "string" },
          "detail": { "type": "string", "maxLength": 200 },
          "related_quote": { "type": "string", "maxLength": 280 }
        }
      }
    },
    "safety_flags": {
      "type": "object",
      "required": ["codes", "notes_internal"],
      "properties": {
        "codes": {
          "type": "array",
          "items": {
            "enum": [
              "none",
              "sensitive_disclosure_present",
              "third_party_mention",
              "clinical_sounding_language",
              "self_harm_language_present",
              "illegal_activity_mention"
            ]
          }
        },
        "notes_internal": { "type": "string", "maxLength": 500 }
      }
    },
    "innate_policy": {
      "type": "object",
      "required": ["touched", "note"],
      "properties": {
        "touched": { "const": false },
        "note": { "type": "string" }
      }
    },
    "model_meta": {
      "type": "object",
      "required": ["assessor_model", "temperature", "prompt_version"],
      "properties": {
        "assessor_model": { "type": "string" },
        "temperature": { "type": "number", "minimum": 0, "maximum": 1 },
        "prompt_version": { "type": "string" }
      }
    }
  }
}
```

**Field char caps when applying (align Week 3 §B2):**

| Field | Max chars after patch |
|-------|----------------------|
| `learned` | 600 |
| `currently` | 400 |
| `lifestyle` | 400 |
| `goals` | 400 |

Validator must reject patches that exceed caps or include `innate` / trait scores / deny-list phrases (disorder labels, etc.).

### D3. Worked example (fake transcript → assessment)

**Synthetic user only — not a real person.** Persona continues Week 3 fixture spirit (`Sam Calder` fictional).

**Active chapter (before):**

- `currently`: `Current chapter: Building something (career, skill, project, business). Shipping a self-serve product path at work. Aim: In 9 months, lead a small team shipping a stable onboarding funnel without burning weekends.`
- `lifestyle`: `Day-to-day: Work or study takes most of my energy; I protect a lot of solo / quiet time; Side projects or hobbies eat real hours.`
- `goals`: `In 9 months, lead a small team shipping a stable onboarding funnel without burning weekends.`

**Fake session transcript (user turns only shown):**

1. User: “You’re still talking like I lead a team. I don’t — I’m an IC again as of last month.”  
2. User: “lol yeah if I were CEO I’d ban meetings forever — kidding.”  
3. User: “Real update: weekdays are meeting-heavy now; I only get deep work late evening. Please make my Double match that.”  
4. User: “What if I moved to Lisbon next year?”  

**Expected assessment (abridged, valid shape):**

```json
{
  "schema_id": "double-post-chat-assessment-v1",
  "schema_version": "2026-07-14",
  "assessment_id": "11111111-2222-4333-8444-555555555555",
  "status": "proposed",
  "subject": {
    "user_id": "c2677e73-0000-4000-8000-000000000001",
    "persona_id": "persona-sam-calder-fake",
    "thread_id": "dddddddd-eeee-4fff-8111-222222222222",
    "session_id": "sess-2026-07-14-demo-001",
    "identity_revision_at_assess": 2
  },
  "timing": {
    "session_ended_at": "2026-07-14T18:20:00Z",
    "assessed_at": "2026-07-14T18:20:45Z",
    "user_turn_count": 4,
    "user_char_count": 268
  },
  "user_facing_summary": "You corrected that you’re an IC again (not leading a team), and said weekdays are meeting-heavy with deep work late evening. We also ignored a joke about banning meetings and a hypothetical about Lisbon.",
  "proposed_soul_patches": [
    {
      "field": "currently",
      "op": "revise_clause",
      "previous_text": "Current chapter: Building something (career, skill, project, business). Shipping a self-serve product path at work. Aim: In 9 months, lead a small team shipping a stable onboarding funnel without burning weekends.",
      "proposed_text": "Current chapter: Building something (career, skill, project, business). Shipping a self-serve product path at work as an IC (not leading a team). Aim: In 9 months, ship a stable onboarding funnel without burning weekends.",
      "rationale": "Explicit correction: no longer leading a team; still building the onboarding path.",
      "evidence": [
        {
          "message_id": "msg-u-1",
          "speaker": "user",
          "quote": "You’re still talking like I lead a team. I don’t — I’m an IC again as of last month.",
          "evidence_tier": "E3"
        }
      ],
      "confidence": "high",
      "conflicts_with_active": true
    },
    {
      "field": "goals",
      "op": "revise_clause",
      "previous_text": "In 9 months, lead a small team shipping a stable onboarding funnel without burning weekends.",
      "proposed_text": "In 9 months, ship a stable onboarding funnel without burning weekends.",
      "rationale": "Aim updated to remove team-lead claim after IC correction.",
      "evidence": [
        {
          "message_id": "msg-u-1",
          "speaker": "user",
          "quote": "I’m an IC again as of last month.",
          "evidence_tier": "E3"
        }
      ],
      "confidence": "high",
      "conflicts_with_active": true
    },
    {
      "field": "lifestyle",
      "op": "revise_clause",
      "previous_text": "Day-to-day: Work or study takes most of my energy; I protect a lot of solo / quiet time; Side projects or hobbies eat real hours.",
      "proposed_text": "Day-to-day: Work takes most of my energy; weekdays are meeting-heavy; deep work is mostly late evening; side projects still take real hours.",
      "rationale": "User asked Double to match meeting-heavy weekdays and late deep work.",
      "evidence": [
        {
          "message_id": "msg-u-3",
          "speaker": "user",
          "quote": "weekdays are meeting-heavy now; I only get deep work late evening. Please make my Double match that.",
          "evidence_tier": "E3"
        }
      ],
      "confidence": "high",
      "conflicts_with_active": true
    }
  ],
  "proposed_memory_nodes": [
    {
      "summary": "Creator corrected role: IC again since last month; weekdays meeting-heavy with deep work late evening.",
      "evidence": [
        {
          "message_id": "msg-u-3",
          "speaker": "user",
          "quote": "Please make my Double match that.",
          "evidence_tier": "E3"
        }
      ],
      "confidence": "high",
      "suggested_memory_type": "thought",
      "poignancy": 6,
      "sensitive": false
    }
  ],
  "do_not_update": [
    {
      "reason_code": "nonliteral",
      "detail": "Joke about banning meetings if CEO — not a lifestyle fact.",
      "related_quote": "if I were CEO I’d ban meetings forever — kidding."
    },
    {
      "reason_code": "hypothetical",
      "detail": "Lisbon move framed as what-if — not current chapter.",
      "related_quote": "What if I moved to Lisbon next year?"
    }
  ],
  "safety_flags": {
    "codes": ["none"],
    "notes_internal": ""
  },
  "innate_policy": {
    "touched": false,
    "note": "Chat assessment must not modify innate or Big Five means/bands."
  },
  "model_meta": {
    "assessor_model": "gpt-5.2",
    "temperature": 0.2,
    "prompt_version": "post-chat-assessor-v1"
  }
}
```

---

## E. Apply policy

### E1. Default for v1 (locked lean — confirmed)

**Propose → user confirm or revise → Path A publish.**  
No silent ISS overwrite in v1.

| User action | Effect |
|-------------|--------|
| **Confirm** | Apply selected patches to active `soul_seeds` → bump `identity_revision` → archive prior chapter to `user_identity_versions` → Path A publish to scratch ISS / profile (same machinery as interview retake) |
| **Revise** | User edits proposed text (or rejects individual fields) → store rationale optional → then publish as above |
| **Dismiss** | Persist assessment as `dismissed`; no ISS change |
| **Confirm memory only** | Allow applying episodic nodes without ISS patches |

### E2. What may auto-apply without confirmation (v1)

| Update type | Auto-apply? |
|-------------|-------------|
| Any `proposed_soul_patches` | **No** |
| `innate` / quiz means | **No** (forbidden) |
| Curated `proposed_memory_nodes` with `sensitive=false` and confidence ≥ `medium` | **Yes, optional** — product may auto-write ≤1 node per session **or** wait for confirm; recommend **auto-write curated non-sensitive memory** only if eng wants continuity without UI; show toast: “Saved a short note from this chat for your Double’s memory.” |
| Raw P3-1 per-turn chat memory | Already shipped — unchanged; not this assessor |

**Agent hypothesis (non-blocking):** Later, high-confidence E3 with user phrase “update my Double” could soft-auto ISS after explicit in-chat consent utterance — defer; not v1.

### E3. Interaction with identity_revision / chapters

| Rule | Spec |
|------|------|
| Source tag | Confirmed post-chat chapter writes `source = "post_chat"` on the new `user_identity_versions` row (interview keeps `source = "interview"`; quiz `source = "quiz"` for innate-only republish) |
| Chapter model | Still **one active chapter**. Confirming post-chat patches **archives** the prior active chapter and publishes a new revision — same Path A as interview retake, not a parallel live chapter |
| Partial field update | Allowed: only patched fields change; unpatched fields copy forward from previous active chapter |
| Quiz interaction | Post-chat confirm **must not** rewrite `innate`; quiz retake remains separate |
| Interview interaction | Post-chat is **not** an interview retake; user may still retake `double-interview-v1` anytime (Week 3 §A7). Later interview retake supersedes life-chapter fields again |
| Stale assessment | If `identity_revision_at_assess` ≠ current revision at confirm time → require re-assess or show “chapter changed since this suggestion” and block blind apply |
| `prediction_ready` | Remains true if chapter still complete after patch; if user clears a required field via edit, re-run completeness checklist (Week 3 §C) |

### E4. Quiz scores from chat?

**No.** Default stands with **no blocking justification** to override.

- Chat lacks a reliable multi-item instrument for domain means (raw/A1).  
- Remaking temperament from situation talk violates prediction humility (raw/A3: match career/situation to temperament rather than rewriting temperament from noise).  
- If user insists they “aren’t like the quiz,” product copy: retake the questionnaire; do not shadow-edit scores from chat.

---

## F. Ethics, consent, transparency

### F1. Consent copy

**First creator-chat session (or first time learning enabled) — checkbox, unchecked by default:**

> **Post-chat updates**  
> After you chat with your Double, we may suggest updates to its **life chapter** (background, current focus, day-to-day, aims) based on what *you* said. Suggestions won’t change your quiz temperament scores. Nothing applies until you review it. This is for rehearsal—not a medical or mental-health diagnosis or therapy.  
> ☐ I want post-chat suggestions for my Double.

**If learning already enabled — lightweight session-end reminder (optional toast):**

> We’ll review this chat for possible Double updates you can accept or ignore.

Align tone with Week 3 interview consent (snapshot / rehearsal; answer about yourself) — Week 3 §F2.

### F2. After-analysis user summary + confirm

**FE is mandatory for v1 privacy posture.** User self-verification is the control that makes post-chat learning acceptable: the owner sees what we think we learned, edits if needed, and only then updates the Double. Engineering must ship a corresponding interface — not “API confirm only” for production apply.

#### FE surface — `Post-chat Double updates` (required)

| Element | Requirement |
|---------|-------------|
| Entry | After creator session ends (or from Profile → “Pending Double updates”); deep-link from session-end toast |
| Layout | Single review card/page — not buried in settings |
| Summary | Show `user_facing_summary` |
| Per-field review | For each `proposed_soul_patches[]`: field name, **before**, **after** (editable textarea), confidence, expandable evidence quote |
| Actions | **Save selected** · **Edit then save** · **Dismiss all** · **Turn off suggestions** (opt-out) |
| Empty / skipped | If `status` is `empty`/`skipped`/`refused`: short “Nothing to update” / soft safety message — no fake patches |
| Gate | Disable **Save** until at least one field is selected or all dismissed; never background-apply ISS |

**Card title:** `Update your Double?`

**Body template:**

> {user_facing_summary}  
>  
> These changes would update your Double’s life chapter (not your quiz scores). **Nothing changes until you save.** Review each suggestion. You can edit the text before saving.

**Per-patch row:** field label · before · after · confidence badge (`low`/`medium`/`high`) · evidence quote (collapsed).

**Primary CTA:** `Save updates to my Double`  
**Secondary:** `Edit` · `Not now` · `Don’t suggest from chat` (opt-out)

**Success:**

> Saved. Your Double’s chapter was updated for future rehearsal. Previous chapter kept in history.

### F3. Opt-out

| Control | Spec |
|---------|------|
| Setting | `post_chat_learning_enabled` boolean on profile (default **true** after first consent; **false** until consent if eng prefers stricter — **recommend: false until first consent checkbox**) |
| Effect when false | No assessor jobs; P3-1 raw chat memory may still run (separate); document that distinction in settings |
| Re-enable | Settings toggle + re-ack short consent |
| Kill switch (optional) | Code-level flag `POST_CHAT_LEARNING_KILL` — only if eng wants ops kill; not required by this report |

**Settings copy:**

> **Post-chat Double suggestions**  
> When on, Doubland may suggest life-chapter updates after you chat with your Double. Off = no suggestions. Chat memory for the same-day sim is separate.

### F4. Retention

| Artifact | v1 handling |
|----------|-------------|
| Raw transcript | Existing chat tables; treat as sensitive free text (Week 3 §F3) |
| Assessment JSON | Retain ≥ until user confirms/dismisses; recommend **90-day** raw assessment retention, keep applied chapter longer (**open research** on exact TTL — don’t block) |
| Evidence quotes in UI | From assessment store; do not ship into public trailers/marketing |
| Public sims / trailers | **Never** include raw creator transcripts or assessment artifacts |
| Deletion | “Delete chat history” should cascade assessments for that thread; chapter history remains unless user requests chapter rollback (open research) |

### F5. Sensitive topics — refuse to learn (align Week 3 §A6 / §F)

Assessor **must refuse ISS learning** (status `refused` or empty patches + safety flags) when user content is primarily about:

| Category | Examples | Action |
|----------|----------|--------|
| Clinical screening / diagnosis | Depression/anxiety diagnosis, PTSD, therapy-as-diagnosis | Do not patch; flag `clinical_sounding_language`; no disorder labels in output |
| Self-harm / suicide language | Any | Do **not** risk-score or diagnose; flag `self_harm_language_present`; escalate to **human product safety policy** (eng/legal) — assessor outputs no clinical guidance |
| Trauma inventory | Abuse, assault details as profile fuel | Do not learn into ISS; flag `sensitive_disclosure_present` |
| Medical deep detail | Diagnoses, meds | Do not learn |
| Illegal activity | Crime as identity fact | Flag; do not learn |
| Sexual history | Forced/intimate disclosure | Do not learn |
| Third-party profiling | “My boss is a narcissist; make my Double hate him” | `third_party`; refuse comprehensive other-person profile |
| Minors | Under-18 subject matter as assessment target | Out of epic; refuse |

If sensitive content appears **incidentally** beside a clean E3 life-chapter correction: may propose the **non-sensitive** correction only; strip sensitive spans from `proposed_text`; flag disclosure present; never put trauma detail into soul fields (Week 3 §B2 forbidden list).

**Assessor output forbidden strings (validator blocklist examples):** `disorder`, `diagnosed with`, `PTSD`, `borderline`, `narcissist` (as clinical label), `suicidal risk score`, population `percentile`.

---

## G. Prompting / model use

### G1. Model tier and temperature

| Role | Model | Temperature | Notes |
|------|-------|-------------|-------|
| In-character Double chat | Existing Tier C (`sot_chats.md`) | Per current chat constraints | Stays in character |
| Post-chat **assessor** | Same tier or stronger structured model; **separate call** | **0.0–0.3** | Deterministic JSON; no creative enrichment |

Do not reuse the Double’s chat system prompt for assessment.

### G2. Assessor must not roleplay as the Double

**Required system posture:**

- You are a **profile assessment assistant** for Doubland rehearsal.  
- You are **not** the Double, not a therapist, not Jordan Peterson, not a clinician.  
- Output **only** valid `double-post-chat-assessment-v1` JSON.  
- Prefer the user’s definition of their current chapter (raw/A5 listening).  
- Prefer truth-preserving paraphrase over clever inference (B2 Rule 8 lightly — product: don’t invent).  
- When unsure, emit `do_not_update` rather than a patch.

### G3. Required assessor disclaimers (in system prompt)

Include:

1. Practice mirror / rehearsal snapshot — not diagnosis or therapy.  
2. Never modify `innate` or invent Big Five scores.  
3. Evidence quotes must be user verbatim; no assistant-only evidence.  
4. Jokes / hypotheticals / roleplay → do not update.  
5. Refuse clinical, trauma-as-profile, illegal, and third-party profiling learning.  
6. Char caps on field texts.  
7. Epistemic humility: insufficient evidence → empty proposal.

### G4. Inputs to pass the assessor

- Session user+assistant transcript (cap: last **N** turns; recommend full session ≤ 25 msgs)  
- Active chapter texts: `innate` (read-only context), `learned`, `currently`, `lifestyle`, `goals`  
- `identity_revision`  
- Instrument ids: `ipip-bfm-25`, `double-interview-v1`  
- This schema version string  

Do **not** pass other users’ data.

---

## H. Evaluation

### H1. How we know learning helped

| Method | v1? | Spec |
|--------|-----|------|
| User rating after confirm | **Yes** | 1–5: “Does this update make your Double more like you?” + optional free text |
| Confirm / dismiss / edit rates | **Yes** | Track % confirmed, % edited, % dismissed per week |
| Next-session creator judgment | **Yes (light)** | After next chat: “Felt more accurate than last time?” Y/N/Skip |
| Blind A/B (with/without applied patches) | **Later** | Open research; don’t block v1 |
| Expert rubric (Peterson-informed) | **Spot-check** | Sample 10 assessments/month: evidence tier correct? innate untouched? sensitive refuse working? |

**Success bar for Week 3.3 ship:** eng can run session-end → assessment JSON → confirm → Path A publish on a smoke user; ≥1 synthetic fixture test (Sam-style) passes validator.

### H2. Failure modes to monitor

| Failure mode | Signal | Mitigation |
|--------------|--------|------------|
| Sycophancy / flattery patches | Patches echo Double’s compliments as user facts | User-only evidence rule; validator |
| Over-update from one vent | Many fields change from single emotional turn | Max 4 patches; prefer E3; frequency caps |
| Stereotype injection | Gender/culture tropes not in user text | Forbid inventing; quote-required |
| Joke leakage | Nonliteral → ISS | E0 → do_not_update |
| Trait-score drift | `innate` or means changed | Hard deny + `innate_policy.touched=false` check in CI |
| Sensitive leakage to public | Trailer/sim contains creator assessment | Pipeline allowlist: never |
| Chapter thrash | Daily revision spam | Daily caps; confirm UX friction |
| Stale apply | Confirm after newer interview retake | revision check at apply time |

---

## Week 3.3 implementation order

Ship in this order so engineering never invents psychological rules mid-flight. **Product apply is gated on FE confirm UI** (founder lock).

1. **Persistence + flags** — `post_chat_learning_enabled` (default false until consent); store assessment rows; link `thread_id` / `session_id`.  
2. **Session-end trigger** — idle 15m + explicit end + thread cap; frequency caps; min turns/chars; `prediction_ready` gate.  
3. **Schema validator** — `double-post-chat-assessment-v1`; reject `innate`; char caps + blocklist.  
4. **Assessor prompt + job** — separate non-roleplay model; async only; **store proposals only** (no Path A yet).  
5. **Confirm API** — accept/edit/dismiss; stale `identity_revision` guard; `source=post_chat` + Path A (reuse 3.1) — callable only after user action from FE.  
6. **FE — Post-chat update review UI (required for v1)** — consent checkbox, pending-updates entry, before/after per field, edit, save, dismiss, opt-out (§F2). Do **not** treat D1-FE (full Talk-to-my-Double shell) as a blocker; this review UI can ship on Profile or a minimal chat-complete screen.  
7. **Wire apply** — FE Save → Confirm API → Path A; block any server path that publishes ISS without `confirmed_by_user_id` + timestamp.  
8. **Memory path** — optional curated memory node (distinct from P3-1); prefer confirm or soft toast, never silent ISS.  
9. **Safety flags routing** — map `self_harm_language_present` etc. to human product safety policy (no clinical scoring).  
10. **Eval** — confirm/dismiss/edit rates + post-save 1–5 “more like me?”  
11. **Smoke** — Sam-style fixture → assessment → **FE confirm** → revision bump → ISS updated; `innate` unchanged; dismiss path leaves ISS unchanged.

---

## Open research (do not block v1)

1. Exact retention TTL / user deletion UX for assessments vs chapters.  
2. Soft-auto ISS apply after explicit in-chat “update my Double” utterance.  
3. Speaking-style / voice profile as a non-ISS optional layer.  
4. Blind A/B on next-session “more like me.”  
5. Multi-session E4 reinforcement UI (“you’ve said this twice”).  
6. Whether curated memory auto-write should default on or off.  
7. Stronger nonliteral detectors (model + heuristics).  
8. Chapter rollback UX from `user_identity_versions`.  
9. Teen instruments (out of epic).  
10. Local predictive validity study (Double behavior vs user ratings) — aligns Week 3 open research.

---

## Guardrail note

This report is **Peterson-informed psychometric product design**, not a clinical assessment, not legal advice, and not Jordan Peterson’s personal endorsement. No claims here are a diagnosis. Chat-derived updates are conditional SELF-REPORT chapter revisions with explicit user confirm — not covert surveillance and not temperament remakes. Named real-person psychographics were not produced (synthetic fixture only). Boundaries respected: no realitytv format design, no engagement KPIs, no willwright simulation-system invention; ISS targets match existing soul fields (`sot_chats.md`) plus episodic memory separate from ISS (P3-1).

---

## Source grounding

| Claim cluster | Sources |
|---------------|---------|
| Method, epistemic labels, profile-update mode, consent/third parties | `raw/00_custom_gpt_instructions.md` |
| Routing | `raw/A0_Peterson_Index.md` |
| Trait as sub-personality; reliability/validity | `raw/A1_2017_Big_Five_Intro.md`; `raw/A12_Peterson_Glossary.md` §Trait |
| Aims, listening, structure / subject-defined better | `raw/A5_Clinical_Listening_and_Value.md` |
| Prediction humility; don’t remake temperament from noise | `raw/A3_2017_Performance_Prediction.md` |
| Truthful update / listening (light product ethics) | `raw/user-provided/B2_12_Rules_7_to_12.md` (Rules 8–9) |
| Prior interview allow/deny, soul map, completeness, ethics | `raw/task-deliverables/2026-07-14-week3-interview-recommendations.md` §A6 §B §C §F |
| Decision lock | `kb/wiki/decision/self-serve-interview-v1.md` |
| ISS fields, chat caps, P3-1 episodic write-back | `double-docs/sot/sot_chats.md` §6 |
| Epic Week 3.1–3.3 Path A / post-chat intent | `double-ivan/rehears-double/EPIC_self-serve-double.md` |

### Quotes used (from pack `## Quotes` only)

> "Think of a trait as an element of personality; and I think the best way to think about a trait is as a sub-personality." — `raw/A1_2017_Big_Five_Intro.md`

> "A reliable measure is one that measures the same way across multiple measurements." — `raw/A1_2017_Big_Five_Intro.md`

> "Valid… means that it actually has to measure what it purports to measure." — `raw/A1_2017_Big_Five_Intro.md`

> "My basic practise with people is to say… obviously you are here because you would like things to be better… We can use your definition of what constitutes better." — `raw/A5_Clinical_Listening_and_Value.md`

> "Match the career you pursue to your temperament, rather than trying to adjust the latter." — `raw/A3_2017_Performance_Prediction.md`

> "Tell the truth. Or, at least, don't lie." — `raw/user-provided/B2_12_Rules_7_to_12.md`

> "Assume that the person you are listening to might know something you don't." — `raw/user-provided/B2_12_Rules_7_to_12.md`

---

## Acceptance self-check (specialist)

| Criterion | Met? |
|-----------|------|
| Purpose + construct allow/deny | Yes §A |
| Session trigger + frequency caps | Yes §B |
| Evidence / confidence rules | Yes §C |
| Versioned assessment JSON schema + worked example | Yes §D |
| Apply policy + identity chapter interaction | Yes §E |
| User-facing copy (consent, summary, confirm, opt-out) | Yes §F |
| Safety / sensitive-topic rules aligned Week 3 interview | Yes §F5 / §A2 |
| Evaluation criteria | Yes §H |
| Explicit Week 3.3 implementation order | Yes |
| Epistemic labels + pack citations; quotes only from `## Quotes` | Yes |
| No clinical diagnosis; guardrail note | Yes |
| `innate` / Big Five never from chat (default held) | Yes |
| Inquire A–H fully answered | Yes |

**Recommended COS status after founder approve:** mark inquiry **Accepted** with id `2026-07-14-003` (same pattern as Week 3 interview).

