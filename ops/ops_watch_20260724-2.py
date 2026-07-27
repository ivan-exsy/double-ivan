#!/usr/bin/env python3
"""Local helper: probe VPS for 20260724-2 and optionally stop on fatal.

Usage:
  python ops/ops_watch_20260724-2.py probe
  python ops/ops_watch_20260724-2.py stop [--force]
  python ops/ops_watch_20260724-2.py evaluate
"""
from __future__ import annotations

import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

SIM = "20260724-2"
VPS = "root@199.80.55.26"
KEY = str(Path.home() / ".ssh" / "id_ed25519_vps")
REMOTE_PROBE = f"/tmp/_probe_{SIM}.py"
LOCAL_PROBE = Path(r"d:\Coding\generative_agents\scripts\_probe_20260724-2.py")
STATE = Path(r"d:\Coding\double-ivan\ops\20260724-2_watch_state.json")

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
    body = json.dumps({"action": "stop", "parameters": {"force": force}})
    # Write remote JSON to avoid shell quoting issues
    remote = (
        f"printf '%s' {json.dumps(body)} > /tmp/stop_{SIM}.json && "
        f"curl -sk -X POST https://127.0.0.1:8001/api/simulations/{SIM}/stop "
        f"-H 'Content-Type: application/json' -d @/tmp/stop_{SIM}.json"
    )
    # Simpler: embed force flag only
    cmd = (
        "curl -sk -X POST "
        f"https://127.0.0.1:8001/api/simulations/{SIM}/stop "
        "-H 'Content-Type: application/json' "
        f"-d '{{\"action\":\"stop\",\"parameters\":{{\"force\":{force_json}}}}}'"
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
    hl = data.get("headless") or {}

    fatals = []
    warnings = []

    if status in ("completed", "stopped") and not active:
        return {
            "fatal": False,
            "fatals": [],
            "warnings": ["sim_terminal"],
            "step": step,
            "status": status,
            "new_checkpoints": [],
            "terminal": True,
            "chrome_count": int(data.get("chrome_count") or 0),
            "png_count": int(data.get("png_count") or 0),
            "host_avail_mb": data.get("host_avail_mb"),
            "csv_lines": data.get("csv_lines"),
            "headless": hl,
        }

    if st.get("error"):
        if data.get("backend_pid_alive"):
            warnings.append(f"status_api_error: {st.get('error')}")
        else:
            fatals.append(f"status_api_error: {st.get('error')}")

    if active is False and status == "running":
        fatals.append("backend_dead_while_running")

    if data.get("backend_pid_alive") is False and active:
        fatals.append("backend_pid_missing")

    # OOM journal noise is common from one-off probes; only fatal if host is
    # critically low or the score runner itself looks dead.
    if data.get("oom_hints"):
        avail = data.get("host_avail_mb")
        runner_ok = bool(data.get("backend_pid_alive")) and active is not False
        if avail is not None and float(avail) < 200:
            fatals.append("oom_or_kill_hints_in_journal")
        elif not runner_ok:
            fatals.append("oom_or_kill_hints_in_journal")
        else:
            warnings.append("oom_journal_noise_runner_ok")

    avail = data.get("host_avail_mb")
    if isinstance(avail, int) and avail < 200:
        fatals.append(f"host_avail_critical_{avail}mb")

    stall_min = int(state.get("stall_minutes") or 15)
    prev_step = state.get("last_step")
    prev_gen = parse_ts(state.get("last_generated_at"))
    cur_gen = parse_ts(last_gen)
    if prev_step is not None and step is not None and step == prev_step:
        ref = cur_gen or prev_gen
        last_probe = parse_ts((state.get("last_probe") or {}).get("probe_utc"))
        age_min = None
        if ref is not None:
            age_min = (now - ref.astimezone(timezone.utc)).total_seconds() / 60.0
        elif last_probe is not None:
            age_min = (now - last_probe).total_seconds() / 60.0
        if age_min is not None and age_min >= stall_min:
            fatals.append(f"stall_step_{step}_for_{age_min:.0f}m")

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

    rss = str(data.get("rss_monitor") or "")
    if SIM not in rss and "monitor_reverie_rss" not in rss:
        warnings.append("rss_monitor_not_running")

    # Headless integrity (P0 gate for this score run).
    # Ignore the current in-flight step: ACCEPTED lines stream in before
    # "Headless execution completed", so a partial count is not a failure.
    # After Day-1 elim, alive agents = 14 — set expected_accepted=14 in state.
    # strict_failures is cumulative in the soak log; baseline ignores pre-resume aborts.
    expected = int(state.get("expected_accepted") or 15)
    strict_baseline = int(state.get("strict_failures_baseline") or 0)
    strict_n = int(hl.get("strict_failures") or 0)
    if strict_n > strict_baseline:
        fatals.append(
            f"headless_strict_failures_{strict_n}_above_baseline_{strict_baseline}"
        )
    recent = hl.get("recent_accepted_by_step") or {}
    completed_n = int(hl.get("headless_completed") or 0)
    finished = {}
    for k, v in recent.items():
        try:
            s = int(k)
        except Exception:
            continue
        # completed_n is count of completions; steps are 0-indexed, so
        # completions cover steps 0..completed_n-1 when starting at 0.
        if s < completed_n:
            finished[s] = int(v)
    bad = {s: n for s, n in finished.items() if n < expected}
    if bad:
        min_acc = min(bad.values())
        fatals.append(
            f"headless_accepted_lt_{expected}_finished_steps_{len(bad)}_min_{min_acc}"
        )
    elif finished:
        min_acc = min(finished.values())
        if min_acc < expected:
            fatals.append(f"headless_accepted_min_{min_acc}")

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
        "headless": hl,
    }


def load_state() -> dict:
    return json.loads(STATE.read_text(encoding="utf-8"))


def save_state(state: dict) -> None:
    STATE.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")


def main() -> int:
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    cmd = sys.argv[1]
    if cmd == "probe":
        print(json.dumps(probe(), indent=2))
        return 0
    if cmd == "stop":
        print(json.dumps(stop(force=True), indent=2))
        return 0
    if cmd == "evaluate":
        state = load_state()
        data = probe()
        verdict = evaluate(data, state)
        state["last_probe"] = {
            "probe_utc": data.get("probe_utc"),
            "verdict": {
                k: verdict[k]
                for k in ("fatal", "fatals", "warnings", "step", "status", "new_checkpoints")
            },
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
