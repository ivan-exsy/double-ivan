# AI Skills Governance Policy (v1)

## Purpose
- Keep AI agent output consistent, safe, and reviewable.
- Reduce regressions by enforcing a small set of strict rules.
- Create one operating model that also aligns with `double-landing-page` and `double-docs`.

## Scope
- Applies to all AI-agent-authored changes in this repository.
- Applies to planning, code edits, docs edits, and PR descriptions.
- Human-authored work is encouraged to follow this policy, but CI enforces agent-facing files and standards.

## Audience
- Primary audience: AI coding agents.
- Secondary audience: engineering reviewers.

## Precedence (Order of Truth)
1. Repository-local governance files (this document + fastpath + scorecard).
2. Repository-local product/architecture intent.
3. Project skills and AGENTS guidance.
4. Generic external best-practices packs.

When guidance conflicts, follow the highest-priority source and note the conflict in the PR summary.

## Strict Operating Rules
1. **No silent assumptions**: if a requirement is missing, choose the safest default and state it.
2. **Small blast radius**: prefer small, reviewable changes over broad refactors.
3. **No hidden behavior changes**: call out behavior-impacting changes explicitly.
4. **No speculative dependencies**: do not add packages unless required for the task.
5. **No destructive git operations**: never force-reset or discard unrelated work.
6. **Verification required**: run the narrowest meaningful checks before handoff.
7. **Deterministic output**: avoid nondeterministic scripts and unstable formatting.
8. **Traceability required**: every non-trivial change must include rationale and validation notes.

## Exception Policy
- Exceptions are allowed only when blocking delivery or safety.
- Each exception must include:
  - reason,
  - risk,
  - rollback plan,
  - owner (you).
- Exceptions are temporary and should be removed in the next cycle.

## CI Gate Policy (Lightweight, Day-One)
- CI checks that governance files exist and include required sections.
- CI is intentionally lightweight: no new dependencies, fast execution.
- PRs fail if required sections are missing.

## Review Cadence
- Weekly: quick compliance scan (10 minutes).
- Monthly: complete scorecard update by owner (you).
- Quarterly: refresh fastpath rules based on defect and rework data.
