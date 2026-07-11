# Inquiry — Trailer polish: cast digest challenge card blank on proof sim

**To:** Eng / video pipeline (daily trailer)  
**From:** Product (Ivan)  
**Date:** 2026-07-10  
**Priority:** Trailer polish (does **not** block MVP engine sign-off — §A on `20260709-1` is green)  
**Sim under test:** `20260709-1` (VPS proof run, SHA `1db8cbe2`, stopped @ step 2489)

---

## 1. One-line ask

On Survival Day 1 digests, **always name today’s challenge in plain language** (and who came out ahead when known) — even when the run has already moved past the challenge into night / post-vote.

Today the cast digest header prints **`Challenge: (none)`** while the same day clearly had **Limited Immunity**.

---

## 2. Why this matters

Cold viewers (and writers using the digest) should answer in one glance:

1. What was today’s challenge?  
2. Who got protected / came out ahead?  
3. How does that set up tonight’s vote?

Ranking, chat-impact Moments, and boot handling already look good on this sim. The missing piece is the **challenge card on the digest** (feeds fact ledger → VO).

---

## 3. Evidence from `20260709-1` (scored 2026-07-10)

### What already passes (do not regress)

| Check | Result on this sim |
|-------|--------------------|
| Chat impact ranking | **PASS** — scores use `chat_impact`; Moments include vote/alliance chats |
| F2 / F2b boot ranking | **PASS** — **Ivan Pitts = #8** (not auto-#1); soft `eliminated_today(+2)` only |
| Boot named in digest | **PASS** — “Today elimination (survival day 1)” names Ivan + tally |
| Featured order | **PASS** — digest ranking = featured order (Vincent → Max → Olivia …) |
| Engine MVP (§A) | **PASS** — RCA-1, meals 15/15, sleep, P0s, halluc 0%, Class A desk-excl 17≤20 |

Artifacts (local + VPS):

```
generative_agents/data/20260709-1/trailer_ready_day2/
  cast_ranking.json
  cast_digest.json
  cast_digest.md
```

Checklist: `double-ivan/20260710_checklist.md` §C.

### What’s broken

| Field / surface | Observed |
|-----------------|----------|
| `cast_digest.json` → `challenge_today` | **`null`** |
| `cast_digest.md` header | **`Challenge: (none)`** |
| Same day’s season truth | Survival Day 1 = **Limited Immunity**; winners **Alex Butcher**, **Diana Ogden**; 15/15 claimants (from survival export / season state) |
| Chats / schedules in digest | Still talk about immunity tokens / challenge — so story fuel exists, but the **structured card is empty** |

**Likely cause (for eng):** `video/summarize_cast_day.py` fills `challenge_today` only from **live persona scratch** (`survival.challenge_today` / `current_challenge`). After the challenge window (and especially at end-of-run / night), that scratch field is cleared → digest says “(none)” even though `survival_season_state.challenge_results` still has the day’s result.

Fact ledger E1 (`build_fact_ledger._build_challenge_card`) already knows how to read **`challenge_results`** — the digest is not handing it a type/name up front.

---

## 4. Desired behaviour

For engine day **2** (= Survival Day 1) on this sim family:

1. Digest header names the challenge in plain language, e.g. **“Limited Immunity”** (not only `limited_immunity`).  
2. Digest (or linked fact ledger card) includes:
   - short brief / how-to-compete one-liner (catalog)  
   - **winners** from `challenge_results` (not “claimed_immunity” activity flags alone)  
   - claimants count when available  
3. Regenerating the digest **after** the sim has stopped at midnight must still show the card (end-of-run scoring is the normal ops path).  
4. When there truly was no challenge that day (e.g. grace/premiere), `(none)` remains correct.

**Out of scope for this inquiry**

- Redesigning Limited Immunity itself → separate COS task `2026-07-10-002` / `20260710_inquiry_redesign-day1-immunity-challenge.md`  
- Re-opening MVP engine gates (RCA-1 / meals / location)  
- Full VO rewrite / Remotion render (can follow once the card is populated)  
- Spicy ranking / Path B Class A

---

## 5. Suggested fix direction (eng — not prescriptive)

Prefer **season SOT over live scratch** when building the digest challenge field:

1. Resolve survival day for the digest’s engine day.  
2. Read `challenge_results` row for that day (same source as E1).  
3. Map `type` → catalog **name + brief** (reuse fact-ledger helpers if possible).  
4. Fall back to scratch `challenge_today` only if results are missing (in-progress day).  
5. Keep markdown header + JSON `challenge_today` in sync (object or plain name — pick one shape and document it).

Acceptance test on this package:

```bash
python3 -m video.summarize_cast_day 20260709-1 --day 2 --output-dir data/20260709-1/trailer_ready_day2
# expect challenge_today non-null; cast_digest.md header ≠ "(none)"
# expect winners include Alex Butcher & Diana Ogden for Limited Immunity
```

Optional follow-up: regenerate fact ledger for the same day and confirm `today.challenge.name` / `winners` match.

---

## 6. Secondary polish notes (same sim — optional, lower priority)

Observed while scoring; **not** required to close this inquiry:

1. **Schedule lines still say “reviewing challenge notes”** for some Doubles even though soft day briefs now pull real jobs. Digest schedules are activity text from the run — may be residual LLM phrasing, not the old shared brief. Worth a glance when touching survival realism, not a digest blocker.  
2. **Boot card Moments** — Ivan’s JSON `top_moments` looked empty while other cast cards had chat Moments; elimination is covered in the global “Today elimination” section. Nice-to-have: ensure boot still gets at least one farewell-relevant moment for writers.  
3. **`score_rca2_meals.py` at end-of-run** reads Day-2 night scratch → false 0/14. Meals were **15/15** on Day-1 snapshots. Trailer-adjacent ops note: document “score meals from Day-1 snapshots after stop,” or point the scorer at snapshots.

---

## 7. References

| Doc / artifact | Role |
|----------------|------|
| `double-ivan/20260710_checklist.md` §C | Gate that stayed open: challenge card |
| `double-ivan/video/daily/TODO_daily_trailer.md` §E (E1) | Challenge card in fact ledger — shipped; digest feed still thin |
| `double-ivan/20260709_survival_realism.md` | Soft brief + chat-impact ranking (already verified on this sim) |
| `generative_agents/data/20260709-1/trailer_ready_day2/` | Digest package to re-score after fix |
| `generative_agents/tests/reports/_20260709-1_checklist_pack/` | Full MVP + realism pack from VPS |

---

## 8. Done when

- [ ] Re-run `summarize_cast_day` on `20260709-1` day 2 → header names **Limited Immunity** (plain language)  
- [ ] Winners/claimants match season `challenge_results` for that day  
- [ ] Fact ledger (if regenerated) shows the same challenge card  
- [ ] Tick §C **Challenge card** on `20260710_checklist.md`  
- [ ] No regression on F2 / chat-impact / elimination section
