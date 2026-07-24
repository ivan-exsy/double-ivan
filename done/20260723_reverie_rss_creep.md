# Handoff — Reverie RSS creep investigation (next VPS score run)

**Date:** 2026-07-23  
**Owner:** Ivan (product) · **Implement / ship:** BE/ops on `ivan/*` or `nicolas/*` → merge to production (`railway` / VPS deploy)  
**Status:** Scripts checked into `ivan/headless-memory-hygiene` (`scripts/monitor_reverie_rss.sh`, `scripts/snapshot_sim_chrome_mem.sh`). Run procedure also on `20260723-1_checklist.md` §10.  
**Related:** `double-docs/20260720-1_RCA.md` (OOM) · `TODO_post_mvp.md` PM-INFRA-1 / Phase 7 assoc-stream cap  
**Scripts:** `generative_agents/scripts/monitor_reverie_rss.sh` · `generative_agents/scripts/snapshot_sim_chrome_mem.sh`

---

## 1. Why this exists

After the `20260720-1` OOM (Playwright Chrome under `double-api`), we took two memory snapshots ~1h apart on the resumed run:

| | Snapshot A | Snapshot B | Δ (~116 steps) |
|--|------------|------------|----------------|
| Chrome family RSS | ~636 MB | ~648 MB | **+12 MB** (almost flat) |
| Reverie (`temp_runner`) RSS | ~314 MB | ~345 MB | **+31 MB** |
| Host available | ~2.6 GB | ~2.6 GB | flat |
| On-disk assoc memory (all personas) | — | ~12–13 MB total | **cannot** explain 345 MB RSS |

**Conclusions so far:**

- Chrome recycle-every-N is **not** the urgent finding from the 1h window (browser nearly flat; tab reuse OK).
- Per-step **screenshots** are still on and remain the obvious Chrome/disk tax (separate track).
- **Reverie RSS creep** is real in that window and needs a **full-run time series** on the next production sim — not another one-off `ps` glance.
- Assoc-memory **folders on disk** are tiny; do not assume “nodes.json growth” equals RSS. In-process growth may be elsewhere (Python baseline, caches, embeddings in RAM, allocator).

**Product constraint:** headless Phaser validation stays **ON** for legitimate generation. This investigation does **not** recommend turning headless off.

---

## 2. Goal of the next production run

After **dev → production deploy**, start a new long Survival (or score) sim and collect a CSV:

```text
stamp_utc, step, backend_alive, backend_pid,
reverie_rss_mb, chrome_rss_mb,
host_used_mb, host_avail_mb,
assoc_disk_mb, rendered_disk_mb, png_count
```

**Answer these questions:**

1. Does `reverie_rss_mb` climb linearly with `step`, plateau, or jump in bands?
2. Does `assoc_disk_mb` track reverie RSS (or stay flat while RSS climbs)?
3. Does `chrome_rss_mb` stay flat over multi-thousand steps (confirm A→B)?
4. Does `rendered_disk_mb` / `png_count` stay 1:1 with steps (screenshot tax still armed)?

**Out of scope for this handoff:** implementing assoc-stream cap, Chrome recycle, cgroup split (those are backlog). This is **instrument + observe** only.

---

## 3. Dev branch / worktree deliverables

Ship in `generative_agents` (author-prefixed branch, e.g. `ivan/reverie-rss-monitor`):

| Deliverable | Notes |
|-------------|--------|
| `scripts/monitor_reverie_rss.sh` | Loop sampler; env: `SIM`, `INTERVAL_SEC` (default 300), `API`, `OUT`, `STORAGE` |
| `scripts/snapshot_sim_chrome_mem.sh` | Optional one-shot forensics (already drafted locally) |
| Short README blurb under `scripts/` **or** comment header only | How to run under `tmux` on VPS after deploy |
| **Do not** change headless defaults or screenshot behavior in this PR unless separately agreed | Keep the next run comparable |

**Acceptance for the PR:**

- [ ] Scripts executable, `bash -n` clean, no secrets.
- [ ] Default paths match VPS layout:  
  `STORAGE=.../environment/frontend_server/storage/$SIM`  
  `API=https://127.0.0.1:8001`
- [ ] CSV header matches §2.
- [ ] Documented: start within ~5 minutes of sim start; detach with tmux.

Merge to the branch that VPS pulls (`railway` / production deploy path per `deploy-railway` skill). **Do not** restart `double-api` while a score sim is generating unless ops window allows.

---

## 4. VPS procedure (after deploy)

### 4.1 Start the score sim (ops)

- Survival or body-gate sim as needed; **headless ON** (current product posture).
- Prefer `diagnostic_mode:false` for long sprints.
- Note `sim_code` (e.g. `20260724-1`).

### 4.2 Start the monitor (same host, tmux)

```bash
cd /var/www/generative_agents   # or wherever scripts landed
tmux new -s rss
SIM=YYYYMMDD-N INTERVAL_SEC=300 bash scripts/monitor_reverie_rss.sh
# Ctrl-B D to detach
```

Confirm:

```bash
tail -f /tmp/reverie_rss_YYYYMMDD-N.csv
```

### 4.3 During / after run

- Leave monitor for the **full** sprint (or until OOM/stop).
- On stop: copy `/tmp/reverie_rss_YYYYMMDD-N.csv` off-box (or into `storage/$SIM/analysis/`).
- Optional mid-run: `bash scripts/snapshot_sim_chrome_mem.sh` if Chrome topology looks weird.

### 4.4 Handoff back to product

Deliver:

1. CSV file  
2. Sim code + step range + whether headless/screenshots were on  
3. One-paragraph read: slope of `reverie_rss_mb` vs `step`; chrome flat/not; assoc_disk flat/not  

---

## 5. How to interpret (quick guide)

| Pattern | Likely meaning | Follow-up |
|---------|----------------|-----------|
| Reverie flat after warmup | A→B +31 MB was noise / short window | Deprioritize engine leak hunt |
| Reverie ↑ vs step, assoc_disk flat | In-process / allocator / non-disk caches | Profile next (not this PR) |
| Reverie ↑ and assoc_disk ↑ together | Memory streams contributing | Pull forward assoc-stream cap (Phase 7) |
| Chrome ↑ steeply | Revisit recycle / screenshots | Tie to RCA §12 |
| png_count ≈ step | Screenshots still every step | Screenshot off/sample PR |

---

## 6. Related backlog (do not block this monitor)

| ID / doc | Item |
|----------|------|
| `20260720-1_RCA.md` §12 | Screenshot off/sample; swap; Chrome recycle (deferred); PM-INFRA-1 |
| `TODO_post_mvp.md` **PM-INFRA-1** | Full sim/Chrome split outside `double-api` cgroup |
| `TODO_post_mvp.md` Phase 5 | Browser-free realization |
| `TODO_post_mvp.md` Phase 7 | Assoc-stream cap (~500–1000 nodes/persona) |

---

## 7. Success criteria for *this* workstream

- [x] Monitor script merged into BE branch for next production pull (`ivan/headless-memory-hygiene`)  
- [ ] Next long sim has a continuous CSV from near step 0 → end (≥1500 steps preferred; longer better)  
- [ ] Product can decide: “reverie creep is real / not real / only with screenshots / only after day N” without another emergency SSH archaeology session  

**Non-goals:** fixing creep in the same PR; changing Survival Light scoring; disabling headless.

**Ops reminder:** after deploy + sim start, run §4 / checklist §10 before walking away.