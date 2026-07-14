# 2026-07-14 checklist — score `20260713-1` (P0 + Light)

**Sim:** `20260713-1`  
**Shipped yesterday:** P0 Survival fidelity + Challenge Director + Light reason slots (8 IDs)  
**Mode:** normal sprint (`diagnostic_mode: false`) — product data in Supabase / season state is enough  
**Gate triad (scoring only, after unblind):** Ivan · Diana · Mike  

Do **not** expect Remotion / public VO / share CTA from this run.

---

## Mid-flight check (while sim still running)

Use this **before** the full post-run score. Product data lands when a challenge **resolves** — empty `challenge_results` mid-day is normal if phase is still `DIRECTIVE` / social.

### What you can verify mid-flight

| Checklist § | Mid-flight? | Signal |
|-------------|-------------|--------|
| §0 run alive | Yes | step climbing, process alive, `is_survival: true` |
| §1 Director Day 1 | Yes | `active_challenge_id` or `used_challenge_ids[0]` = `hold_for_shield` |
| §1 Days 2–3 | Only after each day resolves | next IDs appear in `used_challenge_ids` / `challenge_results` |
| §2 reason persistence | Only after resolve | `challenge_results[].decisions[].reasoning` |
| §3 Light soul reasons | Only Day 4+ after resolve | Light IDs in results |
| §4 blind sheet / §6 teach | No | post-run trailer package |
| §5 clone smell | Soft | skim soak chat lines; not decisive |

### Copy-paste on VPS

```bash
# A) Pulse
curl -sk https://127.0.0.1:8001/api/simulations/20260713-1/status/current \
  | python3 -c "import sys,json;d=json.load(sys.stdin);print(d['current_step'], d['curr_time'], d['status'], d.get('current_day_label'), d.get('is_generating'))"

# B) Season / director / results (local mirror — usually freshest)
python3 - <<'PY'
import json
from pathlib import Path
p = Path("/var/www/generative_agents/environment/frontend_server/storage/20260713-1/survival/season_state.json")
d = json.loads(p.read_text())
print("phase:", d.get("phase"), "season_day:", d.get("current_day"))
print("active:", d.get("active_challenge_id"))
print("used:", d.get("used_challenge_ids"))
crs = d.get("challenge_results") or []
print("resolved_challenges:", len(crs))
for row in crs:
    dec = row.get("decisions") or []
    with_r = sum(1 for x in dec if isinstance(x, dict) and (x.get("reasoning") or "").strip())
    print(f"  day={row.get('day')} id={row.get('challenge_id')} decisions={len(dec)} with_reasoning={with_r}")
    if dec:
        s = dec[0]
        print("   sample:", {k: s.get(k) for k in ("agent","persona","name","action","bid","side","reasoning") if k in s or s.get(k)})
        print("   reason:", (s.get("reasoning") or "")[:180])
PY

# C) Optional: same via Supabase RPC (should match)
# python3 one-liner using load_survival_season_state — or just trust season_state.json mid-run

# D) When first row appears — ops-voice smell on reasons
python3 - <<'PY'
import json, re
from pathlib import Path
BAN = re.compile(r"\b(pillar|refill|hardware pair|execute|firm votes|clean window)\b", re.I)
d = json.loads(Path("/var/www/generative_agents/environment/frontend_server/storage/20260713-1/survival/season_state.json").read_text())
hits = total = 0
for row in d.get("challenge_results") or []:
    for x in row.get("decisions") or []:
        if not isinstance(x, dict):
            continue
        r = (x.get("reasoning") or x.get("mark_reasoning") or "").strip()
        if not r:
            continue
        total += 1
        if BAN.search(r):
            hits += 1
            print("BANHIT", row.get("challenge_id"), r[:140])
print(f"ban_hits={hits}/{total}" if total else "no reasoned decisions yet")
PY
```

### Mid-flight pass bar (early)

- [ ] Steps still advancing; backend process alive  
- [ ] Season `used_challenge_ids` starts with `hold_for_shield`  
- [ ] After Day 1 resolves: `challenge_results` has 1 row + mostly non-empty `reasoning`  
- [ ] After Day 2–3 resolve: `silent_pact` then `alliance_lock_in`  
- [ ] Do **not** fail Light / blind triad until Day 4+ exists  

**Snapshot 2026-07-14 ~10:27 ET (~step 1692):** Survival still **Day 1** / phase **DIRECTIVE** / active **`hold_for_shield`** / `challenge_results` **empty**. Calendar time can be Day 2 while season challenge is still open — wait for resolve before scoring §2–§3.

---

## 0. Before scoring — is the run usable?

- [ ] Sim finished (status `completed` / `stopped` near `~2600` steps; process gone)
- [ ] Season row exists; `challenge_results` has multiple days (not empty)
- [ ] No mid-run crash that skipped whole challenge days
- [ ] Note actual day count completed (need **Day 4+** to see Light IDs; Days 1–3 are Keep)

**Quick status:**
```bash
curl -k https://localhost:8001/api/simulations/20260713-1/status/current | python3 -m json.tool
```

---

## 1. Challenge Director (order lock)

Expected fixed open:

| Season day | Expected ID |
|-----------:|-------------|
| 1 | `hold_for_shield` |
| 2 | `silent_pact` |
| 3 | `alliance_lock_in` |
| 4+ | random without replacement from remaining catalog |

- [ ] Day 1 = `hold_for_shield`
- [ ] Day 2 = `silent_pact`
- [ ] Day 3 = `alliance_lock_in`
- [ ] Later days ≠ repeat of already-played IDs

---

## 2. Reason persistence (P0 plumbing)

For each completed challenge day in `challenge_results`:

- [ ] `decisions[]` present (not just winners / narrative)
- [ ] Most decision rows have non-empty `reasoning`
- [ ] If `leaders_burden` ran: `mark` / penalty target **and** `mark_reasoning` present
- [ ] Elimination / vote days: vote reasons present where expected (P0 vote path)

**Pass bar:** reasons exist as first-class data you can read without digging LLM dumps.

---

## 3. Light IDs — soul reasons (main test)

Score only IDs that actually ran. For each, skim 5–10 reasons (or blind sheet — §4).

| ID | What “good” sounds like | Red flags (ops voice) |
|----|-------------------------|------------------------|
| `captains_pick` | Why this color — coalition / fairness / underdog | Herd EV, “optimal side” |
| `whisper_chain` | Why RELAY vs TWIST — fidelity vs theatricality | Chain-EV slang |
| `leaders_burden` | Why this nominee / mark — relationship / fairness / loyalty | execute / pillar / threat matrix |
| `bid_for_vest` | Why this intensity 1–5 — hunger / restraint / uncertainty | Always-5 script for everyone |
| `trial_night` | Why ACQUIT / CONVICT — clarity / fairness / loyalty | Moral scoring for power |
| `vote_heist` | Why this target — grievance / fairness / relationship | Status-heist EV |
| `claim_the_slot` | Why CLAIM vs YIELD — appetite vs quiet restraint | Always-CLAIM lottery script |
| `shared_survival_pool` | Why take 0–5 — restraint / trust / necessity | Pure game-theory script |

**Attractors (highest risk — fail these → escalate that ID only):**

- [ ] `bid_for_vest`: not everyone bidding 5 with identical “max to win” voice
- [ ] `claim_the_slot`: not everyone CLAIM with lottery/ops voice

**Keep IDs (Days 1–3 + any other Keep that ran):** skim only — confirm reasons feel personal, not war-room. Do not reopen Day 1 mechanics.

Per Light ID that ran:

- [ ] Pass / Soft fail / Fail — and one-line note

---

## 4. Blind-choice sheet (creative gate)

After trailer package / day extract for a day that includes Light challenges:

- [ ] `challenge_blind_choice.md` exists — **names stripped** (Agent A/B/…)
- [ ] `challenge_blind_choice.json` exists — **names kept** (ops / unblind)
- [ ] Banlist rate reported (ops terms flagged) — note rate; do **not** hard-fail lock on rate alone

**Blind score (you + Diana + Mike, before unblind):**

- [ ] From choice + reason alone, can you tell *who this person is* (not just “smart player”)?
- [ ] Pass = wiring enough for that ID · Fail = escalate **that ID only** (no catalog redesign)

---

## 5. Fidelity / clone smell (P0 overlay)

Spot-check Day 1–2 chat + vote snippets (cast-wide; Overlay A/B not required):

- [ ] Fewer alliance/threat/reputation labels in seek/overlay-style copy
- [ ] Less “pillar / refill / hardware pair / execute / firm votes / clean window” in challenge + vote reasons
- [ ] Agents still sound like themselves more often than like one shared strategist

Optional: run recognition / clone lexicon helper on a day package if you built one — treat as signal, not ship gate.

---

## 6. Teach cards / package hygiene

- [ ] Teach cards exist for Light IDs that ran (plain-language “what this challenge is”)
- [ ] `day_reasoning` (or equivalent) available for days you care about
- [ ] No claim that Remotion / public VO is ready

---

## 7. Verdict for tomorrow’s call

Pick one:

- [ ] **Ship path OK** — Light wiring + director + persist look good enough to keep iterating on fidelity / video gate
- [ ] **Light re-prompt 1–2 IDs** — list which (usually bid / claim)
- [ ] **Deeper forensics needed** — only if reasons missing or season/challenge path broken (then consider a short diagnostic re-run)

### Capture

| Field | Fill in |
|-------|---------|
| Days completed | |
| Light IDs that ran | |
| Blind triad pass/fail | |
| Worst attractor | |
| Next action | |

---

## Out of scope tomorrow (do not reopen)

- Day 1 `hold_for_shield` mechanic redesign  
- Catalog Replace / Mechanic tweak  
- Remotion / public VO / share CTA  
- Overlay A/B experiment (unless clone smell is still catastrophic)  
- Changing Director Days 1–3 order  
