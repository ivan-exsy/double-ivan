# Tomorrow check — post RCA-1 fix run (2026-07-10+)

**Sim under test:** `20260709-1` · Started 2026-07-10 ~01:11 UTC on VPS after durable post-vote fix landed.  
**Deploy SHA:** `1db8cbe2` on `railway` (confirmed via `git log -1` on VPS before start).  
**Run params:** baseline `soul15_seed_20260224` · `max_steps=2600` · `generation_mode=sprint` · `diagnostic_mode=true` · PID at start `182024`.  
**Baseline (already green on `20260708-mvp-a` — re-verify on new sim):** first-vote 15/15 · meals 14/14 · sleep 14/14 @ 1050 · P0s GREEN · halluc 0.6% · Class A desk-excl. 15 ≤20.  
**Only known open blocker before this run:** RCA-1 (inquiry: [`20260709_rca1-expert-inquiry.md`](20260709_rca1-expert-inquiry.md) · plan: [`20260709_durable_post-vote_planning_6b81b1b9.plan.md`](20260709_durable_post-vote_planning_6b81b1b9.plan.md)).

**Scored 2026-07-10 evening** from VPS pack `tests/reports/_20260709-1_checklist_pack` + Day-1 snapshot meals query. Sim stopped at step **2489** (`status=stopped`, enough for RCA-1 window; planned max was 2600).

Details / history: [`../double-docs/20260705_close-for-mvp.md`](../double-docs/20260705_close-for-mvp.md). Tick here only.

---

## 0. Deploy + run checkpoint (do first tomorrow morning)

Confirm the overnight proof run is the build we think it is, then score.

- [x] **VPS still on fix** — `cd /var/www/generative_agents && git log -1 --oneline` shows `1db8cbe2`
- [x] **Sim finished or far enough** — status shows `20260709-1` completed / step ≥ 2489 (RCA-1 window needs through midnight) — **stopped @ 2489**
  ```bash
  curl -k https://localhost:8001/api/simulations/20260709-1/status/current | python3 -m json.tool
  ```
- [x] **Sprint stayed on** — `live_mode: false` throughout (if it slept at a chunk boundary, do not treat as a clean RCA-1 proof)
- [x] **RCA-1 scorer first** — `python3 tests/analyze_20260630_1.py 20260709-1`
  - Must **not** print `INCOMPLETE WINDOW` for steps 2,311–2,400
  - Gate text is **vote-prep at Hobbs** (tightened regex — bare “vote has concluded” must not false-fail)
  - Record PASS/FAIL under §A RCA-1 below before running the rest of the suite
  - **Result: PASS** (no incomplete window)

If §0 fails (wrong SHA, incomplete window, or live-mode stall): **stop** — do not tick §A green; diagnose before another fork.

---

## A. MVP sign-off gates (must all pass) — **ALL GREEN on `20260709-1`**

Scorers: `analyze_20260630_1.py` · Day-1 `persona_day_snapshots` meals query · `analyze_action-location.py`

- [x] **RCA-1** — steps 2,311–2,400: **zero** vote-prep **at Hobbs**; **14/14** bed/en-route @ 2,450; **14/14** in bed @ 2,489.  
  Ref: inquiry + plan + [`../double-docs/15sim-polish.md`](../double-docs/15sim-polish.md) §RCA-1 · **FAIL on mvp-a** (Owen @ classroom ×42) → **PASS on this run**
- [x] **First-vote attendance** — **15/15** cast ballots; boot **Ivan Pitts**
- [x] **Meals** — lunch **15/15**, dinner **15/15** from Day-1 snapshots (live `score_rca2_meals.py` at end-of-run reads Day-2 night scratch — ignore that 0/14; also ignore analyze hour-parse 0/15 artifact)
- [x] **Sleep @ 1,050** — **14/14** in bed
- [x] **Closed P0s** — vote gate, labeling, day persistence, elimination wiring, open-ended all **GREEN**
- [x] **Hallucination** — **0.0%** (0/726) — gate &lt; 5%
- [x] **Class A** — raw **24** → desk-excl. **17** ≤20; Class B cross-building 5 (no chaos); full report in pack `13_action_location.txt`

## B. Survival realism (same run if fix is already deployed)

- [x] **Soft day brief** — briefs use soft template + real jobs/lifestyles (“rest of the day should still feel like this person's life”); not the old shared note-spam cue.  
  Ref: [`20260709_survival_realism.md`](20260709_survival_realism.md)
- [x] **Seek → real meet** — seek intents present (`looking for X to talk strategy`) + chats in same windows (159 seek hits / 479 chat payloads sampled).  
  Ref: same · [`../double-docs/sot/sot_survival.md`](../double-docs/sot/sot_survival.md)

## C. Trailer cast / ranking (regen Day 2 / Survival Day 1 digest)

Artifacts: `generative_agents/data/20260709-1/trailer_ready_day2/` (`cast_ranking.json`, `cast_digest.json`, `cast_digest.md`).

- [x] **Chat impact, not chat count** — ranking justifications use `chat_impact` (not count-as-lead); Moments include substantive vote/alliance chats. `conversation_count` is capped diagnostic (25).  
  Ref: [`video/daily/TODO_daily_trailer.md`](video/daily/TODO_daily_trailer.md) · [`20260709_survival_realism.md`](20260709_survival_realism.md)
- [x] **F2 / F2b** — boot **Ivan Pitts = #8** (not auto-#1); justification shows soft `eliminated_today(+2)` only; digest has **Today elimination** section naming Ivan + vote tally.  
  Ref: [`video/daily/TODO_daily_trailer.md`](video/daily/TODO_daily_trailer.md) §F2 / F2b
- [ ] **Challenge card** — **GAP:** `challenge_today: null` / digest header **Challenge: (none)** even though season Day 1 was Limited Immunity (present in chats/schedules + survival export). Fact-ledger challenge card (TODO §E / E1) not populated on this digest.  
  Ref: same §E · [`video/sot-video.md`](video/sot-video.md)
- [x] **Featured cast / VO** (if auto-regen) — digest ranking order is the featured order (Vincent → Max → Olivia …); no VO auto-regen this pass (N/A until `generate_trailer`).  
  Ref: [`video/todo_script_draft.md`](video/todo_script_draft.md) · `generative_agents/data/20260709-1/trailer_ready_day2/`

## Quick commands

```bash
# Status / SHA
curl -k https://localhost:8001/api/simulations/20260709-1/status/current | python3 -m json.tool
cd /var/www/generative_agents && git log -1 --oneline

# MVP scorers (this proof sim)
python3 tests/analyze_20260630_1.py 20260709-1
# Meals: prefer Day-1 persona_day_snapshots (live scratch at end-of-run is Day-2 night)
python3 tests/analyze_action-location.py 20260709-1 > tests/reports/_20260709-1_action_location.txt
python3 -m video.summarize_cast_day 20260709-1 --day 2 --output-dir data/20260709-1/trailer_ready_day2
```

## Out of scope for this checklist

Path B Class A residual · embedding reindex / gateway / retire `OPENAI_API_KEY` (Phase 8) · spicy ranking · observation-queue P1.  
**§A is green** — doc DONE + Step 3 ops (`sot_llm.md`, `railway`→`main`, VPS cleanup) can proceed; §C digest is trailer-only follow-up.

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
`TODO_action-location.md` §B Path B · merge/OpenRouter **Phase 8** · §C digest ticks above.
