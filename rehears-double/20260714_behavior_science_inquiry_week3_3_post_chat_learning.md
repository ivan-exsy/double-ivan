# Expert inquiry — Week 3.3 post-chat profile learning (behavior science)

**To:** Behavior science / assessment specialist (Doubland team)  
**From:** Ivan / product + engineering (self-serve Double epic)  
**Date:** 2026-07-14  
**Status:** **OPEN — awaiting specialist report** (engineering must not invent assessment content or update rules)  
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