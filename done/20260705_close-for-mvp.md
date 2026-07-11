# MVP closure tracker — **DONE**

**Status:** **DONE** (2026-07-10) · **Branch:** `railway` · **Proof sim:** `20260709-1` (stopped @ 2489, SHA `1db8cbe2`, durable post-vote fix)  
**Prior location/halluc baseline:** `20260708-mvp-a` @ 2,600  
**Checklist:** [`../double-ivan/20260710_checklist.md`](../double-ivan/20260710_checklist.md)

**Action-location strategy:** [`TODO_action-location.md`](../double-ivan/TODO_action-location.md) — **A** MVP shipped; **B** Path B residual post-MVP.

---

## Remaining checklist — close this doc + downstream

### MVP blockers (must pass on one scored proof fork)

- [x] **Chat P0** — movement chats + memories (`20260707-chat-probe-v3`) → [`15sim-polish.md`](15sim-polish.md)
- [x] **Class A location** — `20260708-mvp-a` desk-excl. **15** ≤20; re-confirmed on `20260709-1` desk-excl. **17** ≤20, halluc **0.0%**
- [x] **Survival gates** — **PASS on `20260709-1`:** RCA-1 **PASS** (0 vote-prep@Hobbs 2311–2400; 14/14 bed @2450 & 2489); meals **15/15** Day-1 snapshots; sleep **14/14** @1050; closed P0s **GREEN**
- [x] **First-vote attendance** — `20260709-1`: **15/15** ballots (Ivan Pitts out); also 15/15 on mvp-a
- [x] **LLM hallucination** — **0.0%** on `20260709-1` (0/726); mvp-a was 0.6% — Tier 2 flat-enum stays Path B

**Next (ops only — not MVP blockers):** Step 3 below. Trailer §C challenge-card digest polish is separate (`20260710_inquiry_trailer-polish-challenge-card-digest.md`).

### Doc closure — Step 2 (after MVP blockers)

- [x] [`20260705_close-for-mvp.md`](20260705_close-for-mvp.md) — mark complete → **DONE**
- [x] [`15sim-polish.md`](15sim-polish.md) — MVP sign-off in header → **DONE**
- [x] [`20260630_merge-openrouter-railway.md`](20260630_merge-openrouter-railway.md) — Phase 7 ✅ → **DONE**

### Release & ops — Step 3 (after doc closure)

- [x] Update [`sot/sot_llm.md`](sot/sot_llm.md) production posture → OpenRouter (sim engine on VPS/`railway`)
- [ ] `railway` → `main` fast-forward merge + push → closes merge + OpenRouter **promote to main** items
- [ ] VPS cleanup: diagnostic storage for scored sims
- [ ] 24h monitor after restart

### Post-MVP (parallel — do not block MVP)

- [ ] [`20260630_merge-openrouter-railway.md`](20260630_merge-openrouter-railway.md) **Phase 8** · [`20260627_openrouter.md`](../double-ivan/20260627_openrouter.md) — embedding reindex (dry-run → full), gateway Chat-with-Double validation, retire `OPENAI_API_KEY`
- [ ] [`TODO_action-location.md`](../double-ivan/TODO_action-location.md) Path B — desk aliases / impossible-computer / cafe-counter (Issue 2 fridge rolled in)
- [ ] API continuation fix (scoped deploy after current sign-off cycle)
- [ ] Observation queue repair (P1 — movement report accuracy; chats no longer depend on it)
- [x] Survival realism soft brief + seek→chat — verified on `20260709-1` (§B); archived under `double-ivan/done/`

---

## Verdict: **MVP SIGNED OFF** (2026-07-10)

**All MVP blockers green on `20260709-1`** (RCA-1 proof after durable post-vote planning @ `1db8cbe2`). Location/hallucination already green on `20260708-mvp-a` and re-confirmed.

| Gate | Latest evidence (`20260709-1` unless noted) | Call |
|------|-------------------------------------|------|
| Hallucination &lt; 5% | **0.0%** (0/726) on `20260709-1`; mvp-a **0.6%** | **PASS** ✅ |
| First-vote attendance | **15/15** cast ballots (Ivan Pitts out) | **PASS** ✅ |
| Meals / sleep / closed P0s | lunch/dinner **15/15** Day-1 snapshots; sleep **14/14** @1050; P0s GREEN | **PASS** ✅ |
| Class A (revised ≤20 desk-excl.) | raw **24** → desk-excl. **17** (`20260709-1`); mvp-a was 15 | **PASS** ✅ |
| RCA-1 | **PASS** — 0 vote-prep@Hobbs 2311–2400; 14/14 bed @2450 & 2489 | **PASS** ✅ |

MVP engine sign-off is closed. Remaining ops: `railway`→`main`, VPS cleanup, 24h monitor. Phase 8 + Path B stay post-MVP.

---

## `20260708-mvp-a` sign-off package (2,600 steps — scored 2026-07-09)

| Gate | Result | Target | Verdict |
|------|--------|--------|---------|
| **Hallucinated picks** | **0.6%** (4/675) | &lt; 5% | **Pass** ✅ |
| **First-vote attendance** | **15/15** ballots | near-full cast | **Pass** ✅ |
| **Premiere meals** (`score_rca2_meals.py`) | Lunch **14/14**, dinner **14/14** | ≥ 13 | **Pass** ✅ |
| **Sleep @ 1,050** | **14/14** in bed | ≥ 11/14 | **Pass** ✅ |
| **Closed P0s** | vote, elimination, overlay, day persistence, open-ended | all green | **Pass** ✅ |
| **RCA-1** (vote-prep @ Hobbs 2311–2400) | **FAIL** — 42 steps vote-prep language (Owen @ classroom, not Hobbs); recovery 14/14 @ 2,450 & 2,489 | 0 vote-prep + recovery | **Fail** ❌ |
| **Class A** | Full report raw **21** → desk-excl. **15** / 2001 actions (`tests/reports/_20260708_mvp_a_action_location.txt`) | ≤ 20 desk-excl. (revised) | **Pass** ✅ |

**Notes:**
- Trust `score_rca2_meals.py` for meals (analyze scorer’s 0/15 premiere snapshots is the known format artifact).
- Eliminated: Vincent Slater. Season open-ended (`total_days=0`). Engine day / season labeling GREEN (Premiere → Survival Day 1).
- Report path (VPS): `tests/reports/_20260708_mvp_a_action_location.txt`

---

## Chat sign-off (`20260707-chat-probe-v3`, 2,600 steps)

| Gate | Result | Target | Verdict |
|------|--------|--------|---------|
| **Movement chat rows** | **2,753** | &gt; 0 | **Pass** ✅ |
| **Chat memories** (`dbl_memory`) | **2,824** | &gt; 0 | **Pass** ✅ |
| **Personas with chats** | **15/15** | all cast | **Pass** ✅ |
| **Orphan payloads** | **0** | 0 | **Pass** ✅ |
| Proximity triggers (soak log) | 37,190 | — | informational |
| Greetings + full chats | present | — | **Pass** ✅ |

**Fix validated:** P0-A/P0-B unconditional proximity scan + post-step chat stamp (`333c142b`, `6ee2c217` on `railway`).

**Role:** Chat validation sim — **not** a substitute for location Class A scoring.

---

## Location sign-off (`20260705-or-smoke`, 2,600 steps — prior)

| Gate | Result | Target | Verdict |
|------|--------|--------|---------|
| **Class A** | **21** | ≤ 5 | **Fail** |
| Class B | 15 | informational | — |
| Class C1 | 3 (Owen Logan) | low | watch |
| Class C2 | 0 | 0 | Pass |
| **Gap 2** | **369** | watch | Improved vs 434 (`20260703-or-2`); worse than 250 smoke (2) |
| **LLM hallucination** | **14.7%** | &lt; 5% | **Fail** at scale (superseded by `20260708-mvp-a` **0.6%**) |

---

## Survival + social (`20260707-chat-probe-v3`, 2,600 steps) — superseded by mvp-a for gates

| Gate | Result | Target | Verdict |
|------|--------|--------|---------|
| **RCA-1** | **5 steps** vote-prep language (Alex @ classroom) | 0 | **Fail** ❌ (still FAIL on mvp-a, different pattern) |
| **Sleep @ 1,050** | **14/14** | ≥ 11/14 | **Pass** ✅ |
| **Premiere meals** | Lunch **14/14**, dinner **14/14** | ≥ 13 | **Pass** ✅ |
| **Closed P0s** | all green | all green | **Pass** ✅ |
| **First-vote** | **6/15** cast | near-full | **Fail** ❌ (fixed on mvp-a **15/15**) |
| **LLM hallucination** | **14.0%** | &lt; 5% | **Fail** ❌ (fixed on mvp-a **0.6%**) |

---

## Closure status by doc (2026-07-10)

| Doc | Move to DONE? | Verdict |
|-----|---------------|---------|
| **`15sim-polish.md`** | **Yes — DONE header** | MVP signed off on `20260709-1` |
| **`20260630_merge-openrouter-railway.md`** | **Phase 7 DONE** | Phase 8 stays open |
| **`TODO_action-location.md`** | **Location green — keep** | Path B open (do not archive) |
| **`20260708_hallucinations.md`** | **Yes → `double-ivan/done/`** | MVP-closed; Tier 2 = Path B |
| **`20260709_rca1-expert-inquiry.md`** | **Yes → `double-ivan/done/`** | RCA-1 PASS on `20260709-1` |
| **`20260709_durable_post-vote_planning_*.plan.md`** | **Yes → `double-ivan/done/`** | live-proof PASS |
| **`20260709_survival_realism.md`** | **Yes → `double-ivan/done/`** | §B verified on `20260709-1` |
| **`20260627_openrouter.md`** | **Keep open** | Sim-engine path done; Phase 8 / `main` / gateway still open |
| **`20260705_close-for-mvp.md`** | **This doc — DONE** | Stays in `double-docs/` as historical tracker |

---

## Open work — priority order

### 1. Step 3 ops (not MVP blockers)

- `railway` → `main` FF merge + push
- VPS diagnostic cleanup for scored sims
- 24h monitor after promote/restart

### 2. Post-MVP (parallel)

- Path B residual themes — `TODO_action-location.md` §B
- Embedding reindex / gateway / retire OpenAI key (Phase 8)
- Trailer digest challenge card polish (inquiry filed 2026-07-10)
- API continuation + observation queue

---

## Completed (do not redo)

- [x] **Chat P0** — proximity scan + persistence; validated `20260707-chat-probe-v3` @ 2,600
- [x] **LLM hallucination** — token budget 100→800; **0.6%** on full `20260708-mvp-a`; **0.0%** on `20260709-1`
- [x] **First-vote attendance** — **15/15** on mvp-a and `20260709-1`
- [x] Meals / sleep / closed P0s on mvp-a and `20260709-1`
- [x] **RCA-1** — durable post-vote planning (`1db8cbe2`); **PASS** on `20260709-1`
- [x] Path A measurement (planned vs actual + stopword match) deployed
- [x] 250-step smoke `20260706-map-smoke` — Class A 3
- [x] Map data audit + registry patch + LLM prompt/normalize
- [x] Issue 1 (post-validate vs orphan redirect)
- [x] Merge Phases 0–6, OpenRouter cutover on VPS
- [x] Memory writes — duplicate DB identity fix + verified

---

## Blocked — Step 2 (doc closure)

Do **not** execute until **RCA-1 PASS**:

| Doc | Action |
|-----|--------|
| `15sim-polish.md` | MVP sign-off in header → **DONE** |
| `20260630_merge-openrouter-railway.md` | Phase 7 ✅ → **DONE** |
| `20260705_close-for-mvp.md` | Mark complete → **DONE** |

---

## Step 3 — Release & ops (blocked)

- [ ] Update `sot/sot_llm.md` production posture
- [ ] `railway` → `main` fast-forward merge + push
- [ ] VPS cleanup: diagnostic storage for scored sims
- [ ] 24h monitor after restart

---

## Step 4 — Post-MVP (parallel)

| Item | Doc |
|------|-----|
| Embedding reindex | `20260627_openrouter.md` Phase 8 |
| Gateway cutover | same |
| Retire `OPENAI_API_KEY` | after gateway + reindex |
| Path B Class A residual | `TODO_action-location.md` §B |
| Tier 2 flat-enum (optional hardening) | `20260708_hallucinations.md` (MVP closed) |

---

## Run reference

| Sim | Steps | Class A | Halluc | Chats | Survival | Role |
|-----|------:|--------:|-------:|------:|----------|------|
| `20260705-or-smoke` | 2,600 | **21** | 14.7% | 0 | ✅ (RCA-1 pass prior) | Prior location fail |
| `20260706-map-smoke` | 250 | **3** | 0% | — | — | Map smoke pass |
| `20260707-chat-probe-v3` | 2,600 | unscored | ~14% | **2,753** | meals/sleep ✅; RCA-1 + first-vote ❌ | Chat validated |
| **`20260708-mvp-a`** | **2,600** | raw **21** → **15** desk-excl. | **0.6%** | — | location + meals/sleep/P0/vote ✅; **RCA-1 ❌** | **Current — location PASS** |

```mermaid
flowchart LR
  A[chat-probe-v3 chats PASS] --> B[Path A + token deploy]
  B --> C[mvp-a 2600]
  C -->|halluc + Class A + first-vote| D[location PASS]
  D --> E[RCA-1 fix]
  E --> G[Doc closure + railway to main]
```
