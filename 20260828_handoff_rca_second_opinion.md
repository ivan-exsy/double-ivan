# Handoff — second opinion on the 11:00 miss RCA (`20260827-1`)

**Date:** 2026-08-28  
**From:** Investigation (first pass)  
**To:** Expert review  
**Ask:** Stress-test the RCA. Do **not** re-score from a blank page unless a number is disputed.

Sim **still running.** Do not stop it. Do not deploy. Do not patch. Do not rewrite SOT.

---

## 1. Mission

First pass collected E1–E10 and wrote an RCA. We want a second opinion on **whether the root-cause mix is right**, not a new occupancy score.

**Done when:** a short written critique exists: agree / disagree / missing, with counts. If you dispute a number, say which table and why.

---

## 2. Hard rules (same as the investigation)

- Leave the runner up. PID **533153** on Hetzner `62.238.113.45`. Unit `api-gateway`. No `git pull` / deploy while it is alive.
- Score **tiles**, not “heading to Hobbs.”
- Reclassify H2/H3 from **05:55** (step 0), not from 09:30.
- Primary compare is **first competitive 11:00 only:** 23-2 **8/15** → 25-1 **9/15** → 27-1 **3/15**. Do not headline 25-1’s second morning 6/14.
- Founder band-aids stay **out:** H3 dest-rewrite, fail-closed, longer pins, fire-when-12.
- Do not rewrite `sot_be-fe.md` §4.7 or `sot_survival.md` gather windows.
- Vote at 20:00 on this run is still ahead — not this review.

---

## 3. What the first pass concluded (to attack)

**Product read:** at 11:00 the viewer sees 3 people on Hobbs (Shepard, Dean, Irene) and 12 still “heading to Hobbs” from college / pub / pharmacy / supply. The Hold board ran.

**Root cause (mixed):**

| Slice | n | Label |
|---|---|---|
| On cafe at fire | 3 | held / last-minute return |
| Sat, then gone **before** 10:30 | 5 | **A** — short lock arrived late (peak **9 at 10:15**, **4 at 10:30**) |
| On cafe in 10:30–11:00, then left | 4 | **B+C+D** — pin leak; STAY text + off-cafe dest; 3/4 `chatting_with` |
| Never on Hobbs 05:55–11:00 | 3 | **E** — Butcher, Ivan, Owen; reachable (~25–30 tiles); WALK text; dest stayed the job |

Mid-run H3 **5** was wrong: Mike and Nick sat at dawn → true never-sit **3**.

Pass 1 made the first competitive morning **worse**, not better. Next bet (not this runner): make the 30-min pin actually hold dest and actually walk; put the appointment in the 10:30 hour of the daily plan. Not a longer curfew.

---

## 4. What to challenge (this is the job)

Read the RCA end to end, then the evidence pack. Then answer:

1. Is **A** really primary? Could the 10:15 peak of 9 be a different class (labels vs tiles, cafe-edge, Irene-as-staff)?
2. Is the **B+C+D** in-window leak over-weighted? 4 leavers cannot explain 3/15 if lock only saw 4.
3. Is **E** a failed WALK, a skip, or a decompose bug (job until 11:00, cafe **after** fire)?
4. Did skip-Premiere do more than we allowed? First pass killed “they never found the cafe.”
5. Is the recommended next experiment the smallest naturalness-first bet — or a silent longer pin / dest-yank?
6. Any number in E2/E3 you would not sign?

If you agree, say so in one paragraph and stop. If you disagree, name the hypothesis letter and the table.

---

## 5. Full links

### This miss — start here

| Doc | Path |
|---|---|
| **RCA (review this)** | [D:\Coding\double-ivan\20260827_RCA_challenge_miss.md](file:///D:/Coding/double-ivan/20260827_RCA_challenge_miss.md) |
| **Evidence pack E1–E10** | [D:\Coding\double-ivan\20260827_challenge_miss_evidence.md](file:///D:/Coding/double-ivan/20260827_challenge_miss_evidence.md) |
| Investigation brief (mission + hypothesis table) | [D:\Coding\double-ivan\20260827_handoff_challenge_miss.md](file:///D:/Coding/double-ivan/20260827_handoff_challenge_miss.md) |
| This second-opinion handoff | [D:\Coding\double-ivan\20260828_handoff_rca_second_opinion.md](file:///D:/Coding/double-ivan/20260828_handoff_rca_second_opinion.md) |
| Mid-run score (H2/H3 provisional) | [D:\Coding\double-ivan\20260827_checklist.md](file:///D:/Coding/double-ivan/20260827_checklist.md) |

### Raw dump (do not treat as the paper)

Folder: [D:\Coding\double-ivan\20260827_challenge_miss_pack](file:///D:/Coding/double-ivan/20260827_challenge_miss_pack)

- [e1_season.json](file:///D:/Coding/double-ivan/20260827_challenge_miss_pack/e1_season.json)
- [e2_trails.json](file:///D:/Coding/double-ivan/20260827_challenge_miss_pack/e2_trails.json)
- [e3_occupancy.json](file:///D:/Coding/double-ivan/20260827_challenge_miss_pack/e3_occupancy.json)
- [e4_leaves_after_1030.json](file:///D:/Coding/double-ivan/20260827_challenge_miss_pack/e4_leaves_after_1030.json)
- [e5_scratch_current.json](file:///D:/Coding/double-ivan/20260827_challenge_miss_pack/e5_scratch_current.json)
- [e6_h3.json](file:///D:/Coding/double-ivan/20260827_challenge_miss_pack/e6_h3.json)
- [e7_fire.json](file:///D:/Coding/double-ivan/20260827_challenge_miss_pack/e7_fire.json)
- [e9_persist.json](file:///D:/Coding/double-ivan/20260827_challenge_miss_pack/e9_persist.json)
- [movement_sample.json](file:///D:/Coding/double-ivan/20260827_challenge_miss_pack/movement_sample.json)

Collectors (print-only; do not import into the runner):

- VPS file collector: [D:\Coding\COS\tasks\2026-08-27-003\collect_challenge_miss.py](file:///D:/Coding/COS/tasks/2026-08-27-003/collect_challenge_miss.py)
- Supabase collector used for this pack: [D:\Coding\COS\tasks\2026-08-27-003\collect_from_supabase.py](file:///D:/Coding/COS/tasks/2026-08-27-003/collect_from_supabase.py)
- CoS task: [D:\Coding\COS\tasks\2026-08-27-003\final.md](file:///D:/Coding/COS/tasks/2026-08-27-003/final.md)

### Priors (compare, do not re-score unless disputed)

| Doc | Path |
|---|---|
| Stay-pin FAIL + §12 trails (25-1) | [D:\Coding\double-ivan\20260825_checklist.md](file:///D:/Coding/double-ivan/20260825_checklist.md) |
| 25-1 score closeout | [D:\Coding\COS\tasks\2026-08-27-001\final.md](file:///D:/Coding/COS/tasks/2026-08-27-001/final.md) |
| Pass 1 cut | [D:\Coding\COS\tasks\2026-08-27-002\mvp-cut.md](file:///D:/Coding/COS/tasks/2026-08-27-002/mvp-cut.md) |
| Launch map | [D:\Coding\double-ivan\20260901_launch.md](file:///D:/Coding/double-ivan/20260901_launch.md) |
| 23-2 first competitive 8/15 | [D:\Coding\double-ivan\done\20260821_checklist.md](file:///D:/Coding/double-ivan/done/20260821_checklist.md) |

### Code on the scored tip (cite, do not edit)

- Gather lock / 30-min window: [D:\Coding\generative_agents\reverie\backend_server\persona\cognitive_modules\plan.py](file:///D:/Coding/generative_agents/reverie/backend_server/persona/cognitive_modules/plan.py) — `_SURVIVAL_GATHER_LEAD_HOURS = 0.5`, `_maybe_apply_gather_lock`
- Challenge fire at declared clock: [D:\Coding\generative_agents\reverie\backend_server\survival\controller.py](file:///D:/Coding/generative_agents/reverie/backend_server/survival/controller.py) — `gate_open_hour=self.challenge_deadline_hour`
- Off-site ritual strip: [D:\Coding\generative_agents\reverie\backend_server\persona\cognitive_modules\action_contract_v1.py](file:///D:/Coding/generative_agents/reverie/backend_server/persona/cognitive_modules/action_contract_v1.py) — `strip_offsite_survival_ritual`

### SOT (live contract vs Desired — do not rewrite)

- [D:\Coding\double-docs\sot\sot_survival.md](file:///D:/Coding/double-docs/sot/sot_survival.md) — written last-**hour** lock; this tip is 30 min + declared 11:00
- [D:\Coding\double-docs\sot\sot_be-fe.md](file:///D:/Coding/double-docs/sot/sot_be-fe.md) — §4.7 still the 25-tile bar on paper; live reject is 6. Do not update until gather **and** start-jump are green.

---

## 6. Known gaps the first pass already named

- VPS `survival_phase_trigger.ndjson` and `[GATHER_LOCK:]` journal were **not** grepped (runner left up). Season + lock **sentences** used instead.
- Coords store `target_zone` bboxes, not `act_address`. Which emit layer dropped the cafe dest for Ivan/Nick/Owen is open.
- Vote **20:00** not scored yet.

Do not treat those gaps as a reason to SSH, stop, or deploy.

---

## 7. Reply shape

Write a short paper in `double-ivan/` (dated). Include:

1. Verdict on the RCA mix (A primary yes/no).
2. Any count you would change.
3. Whether the next experiment is still naturalness-first (or accidentally a band-aid).
4. Open questions only if they change the bet.

Do not ship gather. Do not call Pass 1 green.
