#!/usr/bin/env bash
# Investigate why 20260713-1 burned 2600 steps without reaching Season Day 2 challenge.
#
# On VPS:
#   bash investigate_20260713-1_day_budget.sh
# Optional compare:
#   SIM=20260712-1 bash investigate_20260713-1_day_budget.sh
#
# Clarification: Day 1 elim DID happen on 20260713-1. This script explains
# WHY the remaining steps after that vote were not enough for Day 2 morning.
set -euo pipefail

SIM="${SIM:-20260713-1}"
ROOT="${ROOT:-/var/www/generative_agents}"
BASE="$ROOT/environment/frontend_server/storage/$SIM"
OUT="${OUT:-/tmp/${SIM}_day_budget_report.txt}"

if [[ ! -d "$BASE" ]]; then
  echo "ERROR: storage folder missing: $BASE" >&2
  exit 1
fi

export SIM ROOT BASE

{
  echo "=============================================="
  echo "DAY-BUDGET INVESTIGATION — $SIM"
  echo "generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "base: $BASE"
  echo "=============================================="

  echo ""
  echo "=== 0) API STATUS ==="
  curl -sk "https://127.0.0.1:8001/api/simulations/${SIM}/status/current" \
    | python3 -m json.tool || echo "API status failed"

  echo ""
  echo "=== 1) META / START CLOCK ==="
  python3 - <<'PY'
import json, os
from pathlib import Path
from datetime import datetime, timedelta

base = Path(os.environ["BASE"])
for rel in ("meta.json", "reverie/meta.json", "COMPLETED.json", "STATUS.json"):
    p = base / rel
    print(f"--- {rel} exists={p.exists()} ---")
    if not p.exists():
        continue
    raw = p.read_text(errors="replace")
    try:
        print(json.dumps(json.loads(raw), indent=2)[:2500])
    except Exception:
        print(raw[:800])

meta = json.loads((base / "reverie" / "meta.json").read_text())
sec = int(meta.get("sec_per_step") or 60)
curr = meta.get("curr_time")
step_meta = json.loads((base / "meta.json").read_text()).get("current_step")

def parse_meta_time(s):
    if not s:
        return None
    s2 = str(s).replace("+00:00", "").replace("Z", "")
    for fmt in ("%B %d, %Y, %H:%M:%S", "%B %d, %Y %H:%M:%S", "%Y-%m-%dT%H:%M:%S"):
        try:
            return datetime.strptime(s2, fmt)
        except Exception:
            pass
    return None

end_dt = parse_meta_time(curr)
print("\nsec_per_step:", sec)
print("meta.start_date:", meta.get("start_date"))
print("meta.curr_time:", curr)
print("storage meta.current_step:", step_meta)
print("persona_count:", len(meta.get("persona_names") or []))
if end_dt and step_meta is not None:
    start_dt = end_dt - timedelta(seconds=sec * int(step_meta))
    print("BACK-CALC start_from_end_minus_steps:", start_dt.isoformat(sep=" "))
    print("engine_span_hours:", round((sec * int(step_meta)) / 3600, 2))
PY

  echo ""
  echo "=== 2) SEASON STATE SNAPSHOT ==="
  python3 - <<'PY'
import json, os
from pathlib import Path

p = Path(os.environ["BASE"]) / "survival" / "season_state.json"
print("exists", p.exists(), "mtime", p.stat().st_mtime if p.exists() else None, "size", p.stat().st_size if p.exists() else 0)
d = json.loads(p.read_text())
for k in ("sim_code", "current_day", "phase", "status", "active_challenge_id",
          "used_challenge_ids", "winner", "ended_day", "total_days", "immunity_holder"):
    print(f"{k}: {d.get(k)}")
print("remaining_players:", len(d.get("remaining_players") or []))
elims = d.get("eliminated") or []
print("eliminated:", len(elims))
for e in elims:
    print("  elim:", {x: e.get(x) for x in ("name", "day", "vote_count")})
crs = d.get("challenge_results") or []
print("challenge_results:", len(crs))
for row in crs:
    dec = row.get("decisions") or []
    real = sum(
        1 for x in dec
        if isinstance(x, dict) and (x.get("reasoning") or "").strip().lower() not in ("", "absent")
    )
    absent = sum(
        1 for x in dec
        if isinstance(x, dict) and (x.get("reasoning") or "").strip().lower() == "absent"
    )
    print(
        f"  day={row.get('day')} type={row.get('type') or row.get('challenge_id')} "
        f"name={row.get('challenge_name')} decisions={len(dec)} "
        f"real_reasons={real} absent={absent} winners={row.get('winners')}"
    )
PY

  echo ""
  echo "=== 3) PHASE TRIGGER LOG (spatial vs deadline) + CLOCK MAP ==="
  python3 - <<'PY'
import json, os
from pathlib import Path
from datetime import datetime, timedelta

base = Path(os.environ["BASE"])
pt = base / "logs" / "survival_phase_trigger.ndjson"
print("path", pt, "exists", pt.exists(), "size", pt.stat().st_size if pt.exists() else 0)
rows = []
if pt.exists():
    for line in pt.read_text().splitlines():
        if line.strip():
            rows.append(json.loads(line))
print("events", len(rows))
for r in rows:
    print(json.dumps(r, sort_keys=True))

meta = json.loads((base / "reverie" / "meta.json").read_text())
sec = int(meta.get("sec_per_step") or 60)
step_end = int(json.loads((base / "meta.json").read_text()).get("current_step") or 0)

def parse_meta_time(s):
    if not s:
        return None
    for fmt in ("%B %d, %Y, %H:%M:%S", "%B %d, %Y %H:%M:%S"):
        try:
            return datetime.strptime(s, fmt)
        except Exception:
            pass
    return None

end_dt = parse_meta_time(meta.get("curr_time"))
if not end_dt:
    print("WARN: could not parse curr_time")
else:
    start_dt = end_dt - timedelta(seconds=sec * step_end)
    print("\nSTEP -> CLOCK")
    print("start:", start_dt.isoformat(sep=" "))
    print("end  :", end_dt.isoformat(sep=" "))
    for r in rows:
        step = r.get("step")
        if step is None:
            continue
        clock = start_dt + timedelta(seconds=sec * int(step))
        print(
            f"  step={int(step):>5}  clock={clock.isoformat(sep=' ')}  "
            f"tod={clock.strftime('%H:%M')}  phase={r.get('phase')}  "
            f"day={r.get('day')}  reason={r.get('reason')}"
        )
PY

  echo ""
  echo "=== 4) BUDGET MATH — why Day 2 morning may have been missed ==="
  python3 - <<'PY'
import json, os
from pathlib import Path
from datetime import datetime, timedelta

base = Path(os.environ["BASE"])
meta = json.loads((base / "reverie" / "meta.json").read_text())
sec = int(meta.get("sec_per_step") or 60)
step_end = int(json.loads((base / "meta.json").read_text()).get("current_step") or 0)

def parse_meta_time(s):
    if not s:
        return None
    for fmt in ("%B %d, %Y, %H:%M:%S", "%B %d, %Y %H:%M:%S"):
        try:
            return datetime.strptime(s, fmt)
        except Exception:
            pass
    return None

end_dt = parse_meta_time(meta.get("curr_time"))
start_dt = end_dt - timedelta(seconds=sec * step_end) if end_dt else None
print(f"steps={step_end} sec_per_step={sec} hours={step_end * sec / 3600:.2f}")
print(f"start={start_dt}")
print(f"end  ={end_dt}")

if start_dt:
    milestones = [0, 360, 720, 1080, 1440, 1710, 1800, 2160, 2190, 2400, 2599]
    print("\nmilestone clocks:")
    for s in milestones:
        if s > step_end:
            continue
        clock = start_dt + timedelta(seconds=sec * s)
        print(f"  step {s:>5}: {clock.isoformat(sep=' ')}  tod={clock.strftime('%H:%M')} date={clock.date()}")

    print("\ncalendar-day first step approx:")
    d0 = start_dt.date()
    for i in range(0, 4):
        day = d0.fromordinal(d0.toordinal() + i)
        first = None
        for s in range(0, step_end + 1, 15):
            c = start_dt + timedelta(seconds=sec * s)
            if c.date() == day:
                first = s
                break
        print(f"  {day}: first_seen_step≈{first}")

pt = base / "logs" / "survival_phase_trigger.ndjson"
actual = []
if pt.exists():
    for line in pt.read_text().splitlines():
        if line.strip():
            actual.append(json.loads(line))
print("\nACTUAL triggers:")
for r in actual:
    print(" ", r)

if start_dt and actual:
    last = actual[-1]
    last_step = int(last.get("step") or 0)
    last_clock = start_dt + timedelta(seconds=sec * last_step)
    rem_h = (step_end - last_step) * sec / 3600
    nxt = last_clock.replace(hour=6, minute=0, second=0, microsecond=0)
    if nxt <= last_clock:
        nxt = nxt + timedelta(days=1)
    need_h = (nxt - last_clock).total_seconds() / 3600
    print(f"\nAfter last trigger ({last.get('phase')} @ {last_clock}):")
    print(f"  remaining sim hours in run: {rem_h:.2f}h")
    print(f"  hours needed to reach next 06:00: {need_h:.2f}h")
    print(f"  gap: {'SHORT' if rem_h < need_h else 'ENOUGH'} "
          f"(remaining - needed = {rem_h - need_h:.2f}h)")

print("""
INTERPRET GUIDE:
- Prior good 2600-step runs: grace day + Season Day 1 challenge/vote finish with
  enough leftover night to still be 'complete Day 1'. Day 2 challenge needs the
  NEXT morning (~06:00), which often falls AFTER step 2600 if Day 1 vote was late.
- If challenge/vote reason=deadline (not spatial_gate), events slid later in the day
  and ate the overnight budget.
- If start clock is later than usual, you get fewer daytime hours inside 2600 steps.
""")
PY

  echo ""
  echo "=== 5) SURVIVAL LLM CALLS (challenge / vote / absent) ==="
  python3 - <<'PY'
import json, collections, os
from pathlib import Path

base = Path(os.environ["BASE"])
p = base / "logs" / "survival_llm_calls.ndjson"
print("exists", p.exists(), "size", p.stat().st_size if p.exists() else 0)
if not p.exists():
    raise SystemExit

by_fn = collections.Counter()
by_day = collections.Counter()
by_status = collections.Counter()
challenge_personas = []
vote_personas = []
other = collections.Counter()
for line in p.read_text().splitlines():
    if not line.strip():
        continue
    o = json.loads(line)
    fn = o.get("function") or o.get("prompt") or "?"
    by_fn[fn] += 1
    by_day[str(o.get("day"))] += 1
    by_status[str(o.get("status"))] += 1
    if fn == "challenge_decision":
        challenge_personas.append((o.get("persona"), o.get("step"), o.get("challenge_id"), o.get("status")))
    elif "vote" in str(fn).lower():
        vote_personas.append((o.get("persona"), o.get("step"), o.get("status"), fn))
    else:
        other[fn] += 1

print("by_function:", dict(by_fn))
print("by_day:", dict(by_day))
print("by_status:", dict(by_status))
print("challenge_decision count:", len(challenge_personas))
for row in challenge_personas:
    print("  ", row)
print("vote-related count:", len(vote_personas))
for row in vote_personas[:40]:
    print("  ", row)
print("other functions:", dict(other))

season = json.loads((base / "survival" / "season_state.json").read_text())
dec = ((season.get("challenge_results") or [{}])[0].get("decisions") or [])
called = {r[0] for r in challenge_personas}
print("\nABSENT vs LLM coverage:")
for x in dec:
    agent = x.get("agent")
    reason = (x.get("reasoning") or "").strip()
    flag = "HAS_LLM" if agent in called else "NO_LLM"
    print(f"  [{flag}] {agent}: action={x.get('action')} reason={reason[:90]}")
PY

  echo ""
  echo "=== 6) REFLECTIONS / POST-VOTE MEMORY SIGNALS ==="
  python3 - <<'PY'
import json, re, os
from pathlib import Path

base = Path(os.environ["BASE"])
needles = re.compile(
    r"reflect|vote_concluded|advance_day|post-vote|eliminat|NIGHT|SLEEP|silent_pact|DIRECTIVE",
    re.I,
)
hits = []
for folder in ("logs", "monitoring"):
    d = base / folder
    if not d.exists():
        continue
    files = sorted(d.glob("*"))
    for p in files[:8000]:
        if not p.is_file() or p.stat().st_size == 0 or p.stat().st_size > 5_000_000:
            continue
        try:
            text = p.read_text(errors="replace")
        except Exception:
            continue
        found = needles.findall(text)
        if found:
            hits.append((str(p.relative_to(base)), len(found), p.stat().st_size))

print("files with reflection/elim keywords (top 40):")
for rel, n, sz in sorted(hits, key=lambda x: -x[1])[:40]:
    print(f"  hits={n:>4} size={sz:>8} {rel}")

print("\npersona memory vote_concluded / eliminated samples:")
count = 0
for nodes_path in (base / "personas").glob("*/bootstrap_memory/associative_memory/nodes.json"):
    name = nodes_path.parent.parent.parent.name
    try:
        data = json.loads(nodes_path.read_text(errors="replace"))
    except Exception:
        continue
    nodes = list(data.values()) if isinstance(data, dict) else list(data)
    for n in nodes:
        if not isinstance(n, dict):
            continue
        desc = str(n.get("description") or "")
        if re.search(r"vote concluded|was eliminated|Survival Day", desc, re.I):
            print(f"  [{name}] {desc[:200]}")
            count += 1
            if count >= 30:
                break
    if count >= 30:
        break
print("printed", count, "memory samples")
PY

  echo ""
  echo "=== 7) GATHERING LOCATIONS AROUND CHALLENGE / VOTE STEPS ==="
  python3 - <<'PY'
import json, collections, os
from pathlib import Path

base = Path(os.environ["BASE"])
mon = base / "monitoring"
if not mon.exists():
    print("no monitoring dir")
    raise SystemExit

wanted = [1700, 1710, 1720, 2180, 2190, 2200, 2300, 2400, 2500, 2590]
printed_keys = False
for step in wanted:
    p = mon / f"step_{step}.json"
    if not p.exists():
        print(f"step {step}: missing")
        continue
    try:
        d = json.loads(p.read_text(errors="replace"))
    except Exception as e:
        print(f"step {step}: parse fail {e}")
        continue
    if not printed_keys:
        print("monitoring top keys:", list(d)[:40])
        printed_keys = True
    locs = collections.Counter()
    personas = d.get("persona") or d.get("personas") or d.get("agents") or {}
    if not isinstance(personas, dict):
        print(f"step {step}: unexpected shape {type(personas)}")
        continue
    for name, info in personas.items():
        if not isinstance(info, dict):
            continue
        loc = (
            info.get("location")
            or info.get("act_address")
            or info.get("address")
            or info.get("curr_tile")
            or info.get("emote")
        )
        if isinstance(loc, list):
            loc = " / ".join(str(x) for x in loc)
        locs[str(loc)[:100]] += 1
    print(f"\nstep {step}: top locations")
    for loc, n in locs.most_common(10):
        print(f"  {n:>2} {loc}")
PY

  echo ""
  echo "=== 8) SUPABASE vs LOCAL SEASON DIFF ==="
  cd "$ROOT/reverie/backend_server"
  python3 - <<'PY'
import json, os, sys
from pathlib import Path
sys.path.insert(0, ".")
from survival.state import SeasonState

base = Path(os.environ["BASE"])
sim = os.environ["SIM"]
local = json.loads((base / "survival" / "season_state.json").read_text())
sb = SeasonState.load_from_supabase(sim)
print(
    "local: day", local.get("current_day"),
    "phase", local.get("phase"),
    "used", local.get("used_challenge_ids"),
    "results", len(local.get("challenge_results") or []),
)
if not sb:
    print("supabase: NO ROW")
else:
    d = sb.to_dict()
    print(
        "supabase: day", d.get("current_day"),
        "phase", d.get("phase"),
        "used", d.get("used_challenge_ids"),
        "results", len(d.get("challenge_results") or []),
    )
    for k in ("current_day", "phase", "status", "active_challenge_id", "used_challenge_ids"):
        if local.get(k) != d.get(k):
            print(f"DIFF {k}: local={local.get(k)!r} supabase={d.get(k)!r}")
PY

  echo ""
  echo "=== 9) RECENT LOG GREP (advance / grace / director / gates) ==="
  python3 - <<'PY'
import re, os
from pathlib import Path

patterns = re.compile(
    r"survival_phase_trigger|advance_day|grace|challenge_director|silent_pact|"
    r"hold_for_shield|spatial_gate|deadline|vote_concluded|Season Day|engine Day|"
    + re.escape(os.environ["SIM"]),
    re.I,
)
roots = [
    Path("/var/www/generative_agents/reverie/backend_server/logs"),
    Path(os.environ["BASE"]) / "logs",
]
shown = 0
for root in roots:
    if not root.exists():
        continue
    files = sorted(
        [p for p in root.glob("*") if p.is_file() and p.stat().st_size > 0],
        key=lambda x: x.stat().st_mtime,
        reverse=True,
    )[:80]
    for p in files:
        if p.stat().st_size > 20_000_000:
            continue
        try:
            with open(p, "rb") as f:
                if p.stat().st_size > 300_000:
                    f.seek(-300_000, 2)
                data = f.read().decode("utf-8", "replace")
        except Exception:
            continue
        lines = [ln for ln in data.splitlines() if patterns.search(ln)]
        if not lines:
            continue
        print(f"\n--- {p} matches={len(lines)} ---")
        for ln in lines[-40:]:
            print(ln[:300])
            shown += 1
            if shown >= 220:
                print("...truncated...")
                raise SystemExit
print("done grep, lines_printed≈", shown)
PY

  echo ""
  echo "=== 10) ONE-PAGE SUMMARY ==="
  python3 - <<'PY'
import json, os
from pathlib import Path
from datetime import datetime, timedelta

base = Path(os.environ["BASE"])
sim = os.environ["SIM"]
meta = json.loads((base / "reverie" / "meta.json").read_text())
step_end = int(json.loads((base / "meta.json").read_text()).get("current_step") or 0)
sec = int(meta.get("sec_per_step") or 60)
season = json.loads((base / "survival" / "season_state.json").read_text())
pt = []
pp = base / "logs" / "survival_phase_trigger.ndjson"
if pp.exists():
    pt = [json.loads(l) for l in pp.read_text().splitlines() if l.strip()]

def parse_meta_time(s):
    if not s:
        return None
    for fmt in ("%B %d, %Y, %H:%M:%S", "%B %d, %Y %H:%M:%S"):
        try:
            return datetime.strptime(s, fmt)
        except Exception:
            pass
    return None

end_dt = parse_meta_time(meta.get("curr_time"))
start_dt = end_dt - timedelta(seconds=sec * step_end) if end_dt else None

print("sim:", sim)
print("steps:", step_end, f"({step_end * sec / 3600:.1f}h)")
print("start~:", start_dt)
print("end  ~:", end_dt)
print(
    "season_day:", season.get("current_day"),
    "phase:", season.get("phase"),
    "used:", season.get("used_challenge_ids"),
)
print("elim_count:", len(season.get("eliminated") or []))
print("challenge_results:", len(season.get("challenge_results") or []))
print("phase_triggers:")
for r in pt:
    clock = "?"
    if start_dt and r.get("step") is not None:
        clock = (start_dt + timedelta(seconds=sec * int(r["step"]))).isoformat(sep=" ")
    print(
        f"  step={r.get('step')} clock={clock} phase={r.get('phase')} "
        f"day={r.get('day')} reason={r.get('reason')}"
    )
if start_dt and end_dt and pt:
    last = pt[-1]
    last_clock = start_dt + timedelta(seconds=sec * int(last["step"]))
    remaining_h = (step_end - int(last["step"])) * sec / 3600
    nxt = last_clock.replace(hour=6, minute=0, second=0, microsecond=0)
    if nxt <= last_clock:
        nxt += timedelta(days=1)
    need_h = (nxt - last_clock).total_seconds() / 3600
    print(f"hours AFTER last trigger ({last.get('phase')}): {remaining_h:.1f}h")
    print(f"hours needed to next 06:00: {need_h:.1f}h")
    print(f"Day2-morning budget: {'SHORT' if remaining_h < need_h else 'ENOUGH'}")
print("\nPaste this whole report back for analysis.")
PY

  echo ""
  echo "DONE"
} | tee "$OUT"

echo ""
echo "Report saved: $OUT"
echo "Fetch locally: scp root@VPS:$OUT ."
