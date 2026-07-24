#!/usr/bin/env python3
"""Local helper: probe VPS for 20260723-1 and optionally stop on fatal.

Usage:
  python ops_watch_20260723-1.py probe
  python ops_watch_20260723-1.py stop [--force]
  python ops_watch_20260723-1.py evaluate  # probe + print fatal/checkpoint verdict JSON
"""
from __future__ import annotations

import json
import os
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

SIM = "20260723-1"
VPS = "root@199.80.55.26"
KEY = str(Path.home() / ".ssh" / "id_ed25519_vps")
REMOTE_PROBE = f"/tmp/_probe_{SIM}.py"
LOCAL_PROBE = Path(r"d:\Coding\generative_agents\scripts\_probe_20260723-1.py")
STATE = Path(r"d:\Coding\double-ivan\ops\20260723-1_watch_state.json")
CHECKLIST = Path(r"d:\Coding\double-ivan\20260723-1_checklist.md")

SSH_BASE = [
    "ssh",
    "-i", KEY,
    "-o", "BatchMode=yes",
    "-o", "IdentitiesOnly=yes",
    "-o", "ConnectTimeout=20",
]


def scp_probe() -> None:
    subprocess.check_call(
        [
            "scp",
            "-i", KEY,
            "-o", "BatchMode=yes",
            "-o", "IdentitiesOnly=yes",
            "-o", "ConnectTimeout=20",
            str(LOCAL_PROBE),
            f"{VPS}:{REMOTE_PROBE}",
        ]
    )


def probe() -> dict:
    if not LOCAL_PROBE.exists():
        raise SystemExit(f"missing probe script: {LOCAL_PROBE}")
    scp_probe()
    out = subprocess.check_output(SSH_BASE + [VPS, f"python3 {REMOTE_PROBE}"], text=True)
    return json.loads(out)


def stop(force: bool = True) -> dict:
    force_json = "true" if force else "false"
    cmd = (
        "curl -sk -X POST "
        f"https://127.0.0.1:8001/api/simulations/{SIM}/stop "
        "-H 'Content-Type: application/json' "
        f"-d '{{\"parameters\":{{\"force\":{force_json}}}}}'"
    )
    out = subprocess.check_output(SSH_BASE + [VPS, cmd], text=True)
    try:
        return json.loads(out)
    except Exception:
        return {"raw": out}


def parse_ts(s: str | None):
    if not s:
        return None
    try:
        return datetime.fromisoformat(s.replace("Z", "+00:00"))
    except Exception:
        return None


def evaluate(data: dict, state: dict) -> dict:
    st = data.get("status") or {}
    step = st.get("current_step")
    active = st.get("backend_process_active")
    status = st.get("status")
    last_gen = st.get("last_generated_at")
    now = datetime.now(timezone.utc)

    fatals = []
    warnings = []

    # Completed / stopped normally — not fatal
    if status in ("completed", "stopped") and not active:
        return {
            "fatal": False,
            "fatals": [],
            "warnings": ["sim_terminal"],
            "step": step,
            "status": status,
            "new_checkpoints": [],
            "terminal": True,
        }

    # Status API flake alone is not fatal if the runner process is still alive.
    if st.get("error"):
        if data.get("backend_pid_alive"):
            warnings.append(f"status_api_error: {st.get('error')}")
        else:
            fatals.append(f"status_api_error: {st.get('error')}")

    if active is False and status == "running":
        fatals.append("backend_dead_while_running")

    if data.get("backend_pid_alive") is False and active:
        fatals.append("backend_pid_missing")

    if data.get("oom_hints"):
        fatals.append("oom_or_kill_hints_in_journal")

    avail = data.get("host_avail_mb")
    if isinstance(avail, int) and avail < 200:
        fatals.append(f"host_avail_critical_{avail}mb")

    # Stall: no generation progress for >= stall_minutes
    stall_min = int(state.get("stall_minutes") or 15)
    prev_step = state.get("last_step")
    prev_gen = parse_ts(state.get("last_generated_at"))
    cur_gen = parse_ts(last_gen)
    if prev_step is not None and step is not None and step == prev_step:
        # Prefer last_generated_at age; else probe time gap via stored last_probe
        ref = cur_gen or prev_gen
        last_probe = parse_ts((state.get("last_probe") or {}).get("probe_utc"))
        age_min = None
        if ref is not None:
            age_min = (now - ref.astimezone(timezone.utc)).total_seconds() / 60.0
        elif last_probe is not None:
            age_min = (now - last_probe).total_seconds() / 60.0
        if age_min is not None and age_min >= stall_min:
            fatals.append(f"stall_step_{step}_for_{age_min:.0f}m")

    # Hygiene fatals for this score run
    png = int(data.get("png_count") or 0)
    if png >= 50:
        fatals.append(f"screenshots_growing_png_count_{png}")
    elif png > 0:
        warnings.append(f"png_count_{png}")

    chrome = int(data.get("chrome_count") or 0)
    if chrome >= 40:
        fatals.append(f"chrome_pileup_{chrome}")
    elif chrome >= 25:
        warnings.append(f"chrome_high_{chrome}")

    if not data.get("rss_monitor"):
        warnings.append("rss_monitor_not_running")

    # Checkpoints newly crossed
    done = set(state.get("completed_checkpoints") or [])
    new_cps = []
    if isinstance(step, int):
        for cp in state.get("checkpoints") or []:
            cid = cp["id"]
            if cid not in done and step >= int(cp["min_step"]):
                new_cps.append(cp)

    return {
        "fatal": bool(fatals),
        "fatals": fatals,
        "warnings": warnings,
        "step": step,
        "status": status,
        "active": active,
        "last_generated_at": last_gen,
        "new_checkpoints": new_cps,
        "terminal": False,
        "chrome_count": chrome,
        "png_count": png,
        "host_avail_mb": avail,
        "csv_lines": data.get("csv_lines"),
        "recycle_log_tail": data.get("recycle_log_tail") or "",
        "csv_tail": data.get("csv_tail") or "",
    }


def load_state() -> dict:
    return json.loads(STATE.read_text(encoding="utf-8"))


def save_state(state: dict) -> None:
    STATE.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")


def main() -> int:
    # Ensure probe exists
    writer = Path(r"d:\Coding\generative_agents\scripts\_write_probe_20260723-1.py")
    if writer.exists():
        subprocess.check_call([sys.executable, str(writer)])

    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    cmd = sys.argv[1]
    if cmd == "probe":
        print(json.dumps(probe(), indent=2))
        return 0
    if cmd == "stop":
        force = "--force" in sys.argv or True
        print(json.dumps(stop(force=True), indent=2))
        return 0
    if cmd == "evaluate":
        state = load_state()
        data = probe()
        verdict = evaluate(data, state)
        state["last_probe"] = {
            "probe_utc": data.get("probe_utc"),
            "verdict": {k: verdict[k] for k in ("fatal", "fatals", "warnings", "step", "status", "new_checkpoints")},
        }
        if verdict.get("step") is not None:
            state["last_step"] = verdict["step"]
        if verdict.get("last_generated_at"):
            state["last_generated_at"] = verdict["last_generated_at"]
        for cp in verdict.get("new_checkpoints") or []:
            if cp["id"] not in state["completed_checkpoints"]:
                state["completed_checkpoints"].append(cp["id"])
        if verdict["fatal"]:
            state["fatal_stopped"] = True
            state["notes"].append(
                {
                    "utc": data.get("probe_utc"),
                    "action": "fatal_detected",
                    "fatals": verdict["fatals"],
                }
            )
        save_state(state)
        print(json.dumps({"probe": data, "verdict": verdict, "state": state}, indent=2))
        return 0
    print("unknown command", cmd)
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
