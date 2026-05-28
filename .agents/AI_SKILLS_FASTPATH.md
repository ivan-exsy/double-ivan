# AI Skills Fastpath (Strict Agent Checklist)

Use this as the enforceable "top rules" subset for everyday work.

## 10 Non-Negotiable Rules
1. Confirm scope in one sentence before major edits.
2. Change only files needed for the requested outcome.
3. Prefer existing patterns over introducing new architecture.
4. Avoid duplicate logic; extract only when reuse is clear.
5. Validate with focused checks (lint/test/build as applicable).
6. Document behavior changes and migration impact.
7. Keep commits and PRs small enough for quick review.
8. Do not touch secrets, auth, or infra behavior without explicit request.
9. Never overwrite unrelated local changes.
10. End with a clear outcome: what changed, why, and how it was verified.

## Repo-Type Guardrails
- **Application repos**: run code quality checks relevant to edited files.
- **Documentation repos**: validate links/structure and avoid breaking navigability.
- **Concept/strategy repos**: keep naming, structure, and traceability consistent.

## PR Handoff Template (Required)
- Goal:
- Scope changed:
- Risks:
- Verification run:
- Follow-ups:
