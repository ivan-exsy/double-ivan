# Action-Location Mid-Flight Decision Report

**Date:** 2026-07-09  
**Audience:** Action-location lead (next-step owner)  
**Author context:** Ivan / MVP closure  
**Live sim:** `20260708-mvp-a` — still finishing (~1,843 / 2,600 at report time; leave it running)  
**Tracker:** [`TODO_action-location.md`](TODO_action-location.md) · [`double-docs/20260705_close-for-mvp.md`](../double-docs/20260705_close-for-mvp.md)

---

## 1. Executive verdict (read this first)

| Gate | Mid-flight @ ~1,843 | MVP target | Verdict |
|------|--------------------:|------------|---------|
| **LLM location hallucination** | **0.6%** (3 / 508 picks) | &lt; 5% | **PASS — treat as fixed** |
| **Class A (wrong object for action)** | **18** | ≤ 5 | **FAIL — will not clear on this run** |
| Runtime / scoring hygiene | Running, diagnostic on, `action_id` present | Required | **PASS** |

**What worked:** measurement + matching fix (planned vs actual + stopword-safe label match) removed the false-positive Class A flood. Token-budget fix (`max_tokens` 100→800) collapsed hallucination from ~14% to &lt;1%.

**What did not:** remaining Class A is dominated by **impossible / synonym objects** we explicitly deferred from MVP path A (computer @ store/pharmacy, desk≠table/podium, cafe counter vs seating). That residual is large enough to miss ≤ 5.

**Recommendation while this sim finishes:**
1. **Do not abort** `20260708-mvp-a` — finish for a clean full-run package (hallucination lock-in + complete Class A inventory).
2. **Do not mark Class A MVP green** on this run.
3. Decide among the three options in §6 before starting another 2,600.

---

## 2. What we shipped into this run

Deployed on VPS as `railway` @ `7396f0c3` (plus prior `7bc8ef94` token-budget commit).

### Path A — measurement + matching (this deploy)

| Change | Intent |
|--------|--------|
| Planned vs actual address | Class A scores the **planned** object, not the empty floor tile the sprite stands on during hop/patrol |
| Stopword-safe label matching | Stop scoring “the” / place names as object matches |
| Exact object-name boost | Prefer real maze object when the action names it |

### Already on the box before Path A

| Change | Intent |
|--------|--------|
| `max_tokens` 100→800 on unified location | Stop truncated / garbage picks that looked like hallucinations |
| Map registry cleanup + prompt grounding | Tier 1 hallucination work |
| Post-validate / orphan redirect (Issue 1) | Earlier Class A path fixes |

### Explicitly **not** in this deploy

- Impossible-object policy (computer where no computer fixture exists)
- Desk / cafe-counter synonym map
- Tier 2 flat-enum location pick
- Retiring band-aids (repoint / reconcile / force / orphan)

---

## 3. Scoreboard (context)

| Run | Code | Steps | Class A | Hallucination | Notes |
|-----|------|------:|--------:|--------------:|-------|
| `20260705-or-smoke` | pre-A | 2,600 | **21** | 14.7% | Last full dual fail |
| `20260706-map-smoke` | map/prompt | 250 | 3 | 0% | Smoke only |
| `20260707-chat-probe-v3` | chat fix | 2,600 | unscored | ~14% | No `action_id` in monitoring |
| `20260708-mvp-signoff` | token fix only | ~384 abort | 8 mid | 0.6% | Aborted to deploy Path A |
| **`20260708-mvp-a`** | **Path A + token** | **~1,843 / 2,600** | **18** | **0.6%** | **Current — finish it** |

### Mid-flight Class A trajectory on `20260708-mvp-a`

| Step | Class A | Unique actions (approx) |
|-----:|--------:|------------------------:|
| ~70 | 0 | — |
| ~167 | 3 | ~158 |
| ~298 | 6 | ~272 |
| **~1,843** | **18** | **~1,465** |

Rate is roughly **~1.2% of unique actions**, not a late cliff. Linear “3 @ 167 ⇒ 15 @ 2600” was directionally right; we are already at 18 with ~750 steps left, so final Class A will almost certainly stay **well above 5** (likely high teens / low twenties unless growth flattens hard).

**Important metric note:** Class A counts **unique bad actions** (persona + `action_id`), not bad steps. One mismatch lasting 20 steps = 1 Class A.

**Scoring note:** use `--max-steps 2000` (or omit) once past step 200. Mid-flight greps with `--max-steps 200` under-read later in the run.

---

## 4. Hallucination — closed for MVP purposes

| Evidence | Detail |
|----------|--------|
| Rate | **0.6%** (3 / 508 LLM location picks) |
| Prior scale | ~14–15% on two full 2,600 runs |
| Sample failures | 1 early parse garbage (`e.</think>Oak Hill…`); 2 invented arena shape (`supply store counter:supply store counter`) |
| Gate | &lt; 5% — **comfortably met** |

**Implication for Tier 2 flat-enum (`20260708_hallucinations.md`):**  
**Do not prioritize Tier 2 for MVP.** Token-budget + Path A already cleared the hallucination gate. Flat-enum remains a **long-term / Path B** hardening item (and still useful if we want zero invented addresses by construction), but it is **not** the next Class A lever.

---

## 5. Class A — residual inventory @ ~1,843

**18 cases.** Sources: `llm_location_v1` **14**, `parent_location_inherit_v1` **4**.

### Theme clusters (decision-relevant)

| Theme | ~Count | Player-visible? | Fix class |
|-------|-------:|-----------------|-----------|
| **Computer** where arena has no computer (supply / pharmacy / library table) | 5 | Yes — “on computer” at a counter/table | Impossible-object policy +/or map fixtures |
| **Desk** synonym (desk → library table / podium / student seating) | 5 | Soft — often same room, wrong leaf | Synonym / alias table or prompt grounding |
| **Cafe counter** vs seating / wrong venue | 3 | Yes for “order at counter” | Counter preference + inherit detach |
| **Bed** still in desc after transition (bathroom / cafe) | 2 | Soft / transition noise | Description vs current-action timing (may be scorer or plan lag) |
| **Refrigerator** inherit miss (pub seating) | 1 | Yes | Inherit + missing fixture (Issue 2 adjacent) |
| **Piano** @ bar seating | 1 | Yes | Classic affordance miss |

### Representative cases (full list in VPS `/tmp/mvp_a_al3.txt` or re-run analyzer)

```
Alex Butcher     computer @ supply store counter
Dean Sanford     computer @ supply (×2)
Owen Logan       computer @ pharmacy counter
Andrew Abrams    library computer @ library table
Alex Shepard     library desk @ library table
Nick / Vince     classroom desk @ podium / student seating
Diana            student desk @ dorm sofa; cafe counter @ dorm cooking area
Max              refrigerator @ pub seating
Mike / Vincent   cafe counter @ seating / wrong place
Olivia           bed in desc @ cafe cooking area
Owen             piano @ bar seating
```

### What this means about Path A

- Path A **succeeded at its job**: we are not drowning in false “bookshelf on empty library floor” Class A.
- Path A **cannot** get us to ≤ 5 alone. The residual is product/world-truth debt we deferred on purpose.

---

## 6. Decision options (pick one before next 2,600)

### Option 1 — Patch the top residual themes, then re-sign-off (recommended if Class A must stay ≤ 5)

**Scope (surgical, 1–2 days engineering):**
1. **Impossible computer:** when action names `computer` and arena has none → nearest valid work surface **and** rewrite/normalize description, **or** block computer language in those arenas at plan time.
2. **Desk aliases:** treat `desk` as satisfied by `library table`, `classroom podium`, `classroom student seating` (and document aliases in SOT).
3. **Cafe counter preference:** “order / at the counter” must prefer counter leaf over customer seating on inherit + LLM paths.

**Then:** 250 smoke → new 2,600 with diagnostic + `action_id`.

**Pros:** Keeps the ≤ 5 gate honest; highest chance of true MVP green.  
**Cons:** Another ~1 day of sim wall-clock after the patch.

### Option 2 — Loosen Class A gate for MVP; ship with known debt

**Example product gate:** ≤ 20 @ 2,600 **and** no cross-building chaos **and** hallucination &lt; 5%, with an explicit backlog of computer/desk/counter.

**Pros:** Fastest path to “location doesn’t block launch.”  
**Cons:** Players will still see wrong furniture for work/order actions; debt becomes launch debt.

### Option 3 — Jump to Path B (world truth + flat enum) now

**Pros:** Architecturally correct long-term.  
**Cons:** Too large for “ASAP MVP”; delays launch more than Option 1.

### Explicit non-options right now

- Abort `20260708-mvp-a` early — wastes a nearly complete hallucination proof + Class A inventory.
- Re-run Path A alone hoping for ≤ 5 — evidence says no.
- Start Tier 2 flat-enum **as the Class A fix** — wrong tool for the residual themes.

---

## 7. Suggested next-step plan (while sim finishes)

### Now → sim complete (~few hours)

- [ ] Leave `20260708-mvp-a` running to 2,600.
- [ ] Owner reads this report + picks **Option 1 / 2 / 3**.
- [ ] Optional: skim soak for unrelated red flags (`Memory store failed` was seen at boot — not Class A blocking, but note for chat/memory lead).

### On completion (same day)

```bash
# On VPS
curl -sk https://localhost:8001/api/simulations/20260708-mvp-a/status/current | python3 -m json.tool
python3 tests/analyze_action-location.py 20260708-mvp-a > tests/reports/_20260708_mvp_a_action_location.txt 2>&1
grep -E "Class A real bugs|Hallucinated picks|Class B" tests/reports/_20260708_mvp_a_action_location.txt
```

Also score survival / RCA-1 on the same run (MVP tracker still needs those gates).

### Update docs after final numbers

- [`TODO_action-location.md`](TODO_action-location.md) — final scoreboard row + chosen option  
- [`double-docs/20260705_close-for-mvp.md`](../double-docs/20260705_close-for-mvp.md) — Class A / hallucination checkboxes  
- If Option 1: open a short implementation brief (computer / desk alias / cafe counter) before coding

---

## 8. Path B reminder (post-MVP architecture)

Do **not** block the Option 1/2 decision on this. Order when we get there:

1. Keep planned vs actual as measurement contract  
2. World truth (complete arena object lists)  
3. Flat-enum LLM pick  
4. Retire band-aids that only paper over the old picker  
5. Formal impossible-object product policy  

Details: [`TODO_action-location.md`](TODO_action-location.md) §B · [`TODO_pure-llm-resolver-research.md`](TODO_pure-llm-resolver-research.md) · [`20260708_hallucinations.md`](20260708_hallucinations.md)

---

## 9. Ask for the lead

Please reply with one of:

1. **Option 1** — I will implement computer / desk-alias / cafe-counter patch after final score  
2. **Option 2** — Propose a revised Class A MVP number and ship criteria  
3. **Option 3** — Start Path B design now (accept longer delay)

Plus any disagreement with the theme clustering in §5 (especially whether desk→table should count as Class A at all).

---

## Appendix — how to re-pull the Class A list

```bash
cd /var/www/generative_agents
python3 tests/analyze_action-location.py 20260708-mvp-a --max-steps 2000 \
  | sed -n '/Class A (anchor/,/Class B/p'
```

Diagnostic confirmation already done for this run: soak banner “Diagnostic mode…”, `logs/llm/`, `monitoring/step_*.json` with `traceability.contract.action_id` on 15/15 personas.
