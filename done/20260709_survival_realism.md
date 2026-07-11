# 2026-07-09 — Survival realism (day personalization + intentional seek)

## Problem
Cast digests for Survival Day 1 showed nearly identical schedules: everyone “reviewing challenge notes/rules,” little job/hobby personality, and alliance drama mostly in thoughts — not in who people tried to find.

Root cause: the shared survival day brief suspended normal duties and listed generic prep (“review notes…”), while plan prompts forbade naming people. Chance proximity chats still formed alliances, but Doubles rarely *intended* to hunt allies.

## What we shipped
1. **Soft day brief** — Challenge + vote stay mandatory; leftover hours pull from each Double’s real lifestyle again. Dropped “jobs suspended” / shared note-spam cue.
2. **Survival plan wording** — Daily/hourly survival prompts may include seek intent (“try to find X…”) and discourage generic note filler; still no locked two-person appointments.
3. **Structured seek-to-person** — Once per day, pick a preferred target (ally → trust → another alive Double), walk toward them for a time-boxed window. Chat still starts only when they get close (existing proximity path).

## Trailer digest follow-up (same day)
Seek should create more *meaningful* chats; the digest used to only count how many chats happened. That underweighted alliance/vote talk for script grounding.

**Shipped (trailer-side, no engine memory rewrite):**
- Ranking uses **chat content impact** (top transcripts: length/depth + vote/alliance keywords from on-screen `movement.chat`), not chat count.
- Cast digest Moments can include up to two substantive chat beats (short transcript snippets), alongside events and thoughts.
- Chat *count* stays as a diagnostic field only.

Engine “make chat memories the dramatic-moments source” (`PM-MEM-*`) stays post-MVP — trailers already treat movement transcripts as the authoritative chat source.

## SOT
- `double-docs/sot/sot_survival.md` — soft brief, structured seek, conversation priors clarified.
- `double-docs/sot/sot_chats.md` — seek ≠ new chat trigger.
- `double-ivan/video/sot-video.md` + `daily/TODO_daily_trailer.md` — cast ranking/digest chat-content rule.
- `double-docs/TODO_post_mvp.md` — near-term trailer mitigation note updated.

## Verified
Unit tests + `tests/smoke_social_seek.py` (brief text, seek redirect, expiry). Digest/ranker chat-content tests in `video/test_day_overview_facts.py`.

**Live proof (2026-07-10) on `20260709-1`:** soft briefs include real jobs/lifestyles; seek intents + chats observed in movement windows; cast digest ranking uses `chat_impact`. Checklist §B ticked. Residual schedule lines that still say “reviewing challenge notes” are LLM activity phrasing, not the old shared brief — optional polish only.

**Status:** **DONE** — archived to `double-ivan/done/` (2026-07-10).
