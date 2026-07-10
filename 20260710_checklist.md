# Tomorrow check — post RCA-1 fix run (2026-07-10+)

**Sim under test:** `20260709-1` · Started 2026-07-10 ~01:11 UTC on VPS after durable post-vote fix landed.  
**Deploy SHA:** `1db8cbe2` on `railway` (confirmed via `git log -1` on VPS before start).  
**Run params:** baseline `soul15_seed_20260224` · `max_steps=2600` · `generation_mode=sprint` · `diagnostic_mode=true` · PID at start `182024`.  
**Baseline (already green on `20260708-mvp-a` — re-verify on new sim):** first-vote 15/15 · meals 14/14 · sleep 14/14 @ 1050 · P0s GREEN · halluc 0.6% · Class A desk-excl. 15 ≤20.  
**Only known open blocker before this run:** RCA-1 (inquiry: [`20260709_rca1-expert-inquiry.md`](20260709_rca1-expert-inquiry.md) · plan: [`20260709_durable_post-vote_planning_6b81b1b9.plan.md`](20260709_durable_post-vote_planning_6b81b1b9.plan.md)).

Details / history: [`../double-docs/20260705_close-for-mvp.md`](../double-docs/20260705_close-for-mvp.md). Tick here only.

---

## 0. Deploy + run checkpoint (do first tomorrow morning)

Confirm the overnight proof run is the build we think it is, then score.

- [ ] **VPS still on fix** — `cd /var/www/generative_agents && git log -1 --oneline` shows `1db8cbe2`
- [ ] **Sim finished or far enough** — status shows `20260709-1` completed / step ≥ 2489 (RCA-1 window needs through midnight)
  ```bash
  curl -k https://localhost:8001/api/simulations/20260709-1/status/current | python3 -m json.tool
  ```
- [ ] **Sprint stayed on** — `live_mode: false` throughout (if it slept at a chunk boundary, do not treat as a clean RCA-1 proof)
- [ ] **RCA-1 scorer first** — `python3 tests/analyze_20260630_1.py 20260709-1`
  - Must **not** print `INCOMPLETE WINDOW` for steps 2,311–2,400
  - Gate text is **vote-prep at Hobbs** (tightened regex — bare “vote has concluded” must not false-fail)
  - Record PASS/FAIL under §A RCA-1 below before running the rest of the suite

If §0 fails (wrong SHA, incomplete window, or live-mode stall): **stop** — do not tick §A green; diagnose before another fork.

---

## A. MVP sign-off gates (must all pass)

Scorers: `analyze_20260630_1.py` · `score_rca2_meals.py` · `analyze_action-location.py`

- [ ] **RCA-1** — steps 2,311–2,400: **zero** vote-prep **at Hobbs** (tightened scorer: vote-prep intent + Hobbs; not bare `\bvote\b`); ≥10/14 bed/en-route @ 2,450; ≥10/14 in bed @ 2,489.  
  Ref: inquiry + plan + [`../double-docs/15sim-polish.md`](../double-docs/15sim-polish.md) §RCA-1 · **FAIL on mvp-a** (Owen @ classroom ×42)
- [ ] **First-vote attendance** — near-full cast ballots (not thin tally + phantoms).  
  Already ✅ 15/15 on mvp-a — re-check
- [ ] **Meals** — lunch ≥13, dinner ≥13 via `score_rca2_meals.py` (ignore analyze 0/15 artifact)
- [ ] **Sleep @ 1,050** — ≥11/14 in bed
- [ ] **Closed P0s** — vote gate, labeling, day persistence, elimination wiring, open-ended all GREEN
- [ ] **Hallucination** — &lt; 5% (mvp-a was 0.6%)
- [ ] **Class A** — desk-excl. ≤20, no chaos (mvp-a was 15); full report, not `--max-steps 200`

## B. Survival realism (same run if fix is already deployed)

- [ ] **Soft day brief** — leftover hours = jobs/hobbies, not everyone “reviewing challenge notes.”  
  Ref: [`20260709_survival_realism.md`](20260709_survival_realism.md)
- [ ] **Seek → real meet** — some Doubles walk toward a named person, then chat when close.  
  Ref: same · [`../double-docs/sot/sot_survival.md`](../double-docs/sot/sot_survival.md)

## C. Trailer cast / ranking (regen Day 2 / Survival Day 1 digest)

- [ ] **Chat impact, not chat count** — ranking + Moments use substantive vote/alliance talk.  
  Ref: [`video/daily/TODO_daily_trailer.md`](video/daily/TODO_daily_trailer.md) · [`20260709_survival_realism.md`](20260709_survival_realism.md)
- [ ] **F2 / F2b** — boot not auto-#1 from +50; soft +2 only; if boot ∉ top-3, digest still names them + farewell.  
  Ref: [`video/daily/TODO_daily_trailer.md`](video/daily/TODO_daily_trailer.md) §F2 / F2b
- [ ] **Challenge card** — digest / fact ledger names today’s challenge in plain language.  
  Ref: same §E · [`video/sot-video.md`](video/sot-video.md)
- [ ] **Featured cast / VO** (if auto-regen) — follows **current** ranking.  
  Ref: [`video/todo_script_draft.md`](video/todo_script_draft.md) · `generative_agents/data/<sim>/trailer_ready_day2/`

## Quick commands

```bash
# Status / SHA
curl -k https://localhost:8001/api/simulations/20260709-1/status/current | python3 -m json.tool
cd /var/www/generative_agents && git log -1 --oneline

# MVP scorers (this proof sim)
python3 tests/analyze_20260630_1.py 20260709-1
python3 tests/score_rca2_meals.py 20260709-1
python3 tests/analyze_action-location.py 20260709-1 > tests/reports/_20260709-1_action_location.txt
python -m video.summarize_cast_day 20260709-1 --day 2 -o data/20260709-1/trailer_ready_day2
```

## Out of scope for this checklist

Path B Class A residual · embedding reindex / gateway / retire `OPENAI_API_KEY` (Phase 8) · spicy ranking · observation-queue P1.  
Do **not** promote `railway`→`main` until §A all green.

---

## Docs to mark DONE after §A passes on the new sim

| Doc | Action |
|-----|--------|
| [`../double-docs/20260705_close-for-mvp.md`](../double-docs/20260705_close-for-mvp.md) | Mark complete → **DONE** |
| [`../double-docs/15sim-polish.md`](../double-docs/15sim-polish.md) | MVP sign-off in header → **DONE** |
| [`../double-docs/20260630_merge-openrouter-railway.md`](../double-docs/20260630_merge-openrouter-railway.md) | Phase 7 ✅ → **DONE** (Phase 8 stays open / post-MVP) |
| [`TODO_action-location.md`](TODO_action-location.md) | Location MVP already green — confirm final scoreboard; Path B stays open |
| [`20260708_hallucinations.md`](20260708_hallucinations.md) | Already MVP-closed — archive / leave as Path B note |
| [`20260709_rca1-expert-inquiry.md`](20260709_rca1-expert-inquiry.md) | Close when RCA-1 PASS proven on this sim |
| [`20260709_durable_post-vote_planning_6b81b1b9.plan.md`](20260709_durable_post-vote_planning_6b81b1b9.plan.md) | Mark `live-proof` todo completed when scorer PASS |
| [`20260627_openrouter.md`](20260627_openrouter.md) | Sim-engine sign-off path complete; SOT/`main`/Phase 8 still need Step 3 ops |

**Then (Step 3 ops — not “doc DONE” alone):** update `sot/sot_llm.md` · `railway`→`main` · VPS diagnostic cleanup · 24h monitor.

**Keep open after §A (not closed by this run alone):**  
[`20260709_survival_realism.md`](20260709_survival_realism.md) until §B ticks · `TODO_action-location.md` §B Path B · merge/OpenRouter **Phase 8**.
