# Inquiry → FE — Home reports on live headless (Hetzner)

**From:** Ivan  
**To:** Nicolas / FE  
**Date:** 2026-08-22  
**Priority:** Blocks the next Survival score  
**Channel:** Draft only — paste to Upwork when you send it  
**Related:** `20260822_RCA_far-landings.md` · checklist `20260821_checklist.md`

---

## Paste-ready message

Hi Nicolas —

We stopped scoring sim `20260822-2` on the new Hetzner box. Backend persist is fine. The live walk loop is not.

We think this may still be **the same `double-front` code that ran well on Fozzy**. Please do not treat this as “you shipped a bad commit.” We need you to check what on the **VPS frontend process** would produce the reports below — code, build, env, or how the reused headless tab treats start position.

### How generation talks to FE (so we share one picture)

This is **not** Vercel and not a remote FE.

On the generation VPS, every sim step:

1. Backend Playwright opens **local** `http://127.0.0.1:3000/simulations/<sim>?step=N&headless=true` (same box, `double-front.service`).
2. It injects that step’s people into `window.__executeMovementsForStep`.
3. It waits for movement reports (`actual_pos` / `actual_path`).
4. From step 2 the **same browser tab is reused** (`tab_reused=True`). The page is not reloaded each minute.

So: we do call FE on every step, and that FE is the VPS build. If Fozzy was healthy with the same git tip, something on this host or in this payload is making that build report **home** instead of **this-step start**.

This box, today:

- FE repo `/var/www/double-front` · branch `main` · `e5b1868` (“Revert experimental R3F village spike from main”)
- Please confirm this SHA (and the **built** `.next`, not only git) against the last Fozzy generation FE that you trust.

### What we saw

Sim `20260822-2`, Survival, 15 people, diagnostic off. Stopped at step **46**.

- Step **1**: all **15** walks saved. Short paths. Healthy.
- From step **5**: frontend reports sit next to **that person’s home / spawn**, while backend start is already the real last tile.
- Backend now refuses any landing more than **6** tiles from start. That guard is new. It fired **22** times (jumps **7–31**). Saved positions did **not** jump.
- After that, most minutes have only **0–5 of 15** accepted walks. Headless still says “movements completed.”

Clean case — **Nick Miller, step 5:**

- Backend: stay at **(61, 65)** (already in the zone).
- Frontend report: **(52, 71)** — his home from spawn.
- That is not “walked too far.” The body never left home.

Same pattern: Vince **(119,22) → (95,29)**, Max mid-walk **(108,33) → (109,55)**, Andrew **(27,25) → (17,19)**, Irene toward **(124,50)**, Owen toward **(57,16)**. All home-neighborhood tiles.

`20260822-1` on the same tip did the same class of home report at steps **388–400**. This run does it at breakfast. We cannot wait it out.

### What we are *not* asking you to own

- Backend persist (start → end ≤ 6; refused report does not become next start). That is working.
- Ubuntu auto-updates. Locked. Not this failure.
- Survival gather / vote. Not reached.

### Please answer

1. **Is `e5b1868` the same FE you last ran a long healthy generation on Fozzy?** If not, what SHA was Fozzy? Was the **production build** (`npm run build:headless` + `next start`) rebuilt after that commit?
2. On a reused headless tab (`?headless=true`, no reload after step 1), **what tile do you pathfind from** — injected `start_pos`, or the sprite’s last pixel (often still spawn)?
3. For a **stay** step (start = movement, already in `target_zone`), why would the report be **home** instead of start?
4. After one bad report, why would **most other people** stop emitting an accepted path the same minute? (We see 15 → 12 → 5 → 2 saved paths.)
5. Any VPS-only FE env that Fozzy did not have (`NEXT_PUBLIC_*`, headless speed, maze chunks, collision)? We already set `HEADLESS_FRONTEND_PORT_ROAM=false` on this box so we do not roam onto a stray Next port.

### Done looks like

A short written cause: “same SHA, and here is why this host reports home” **or** “SHA/build/env drifted, here is the fix.”

If it is FE: sprites must start each live step on the backend start tile, walk at most 6, and never report spawn. A 50–100 step smoke with **15/15** and **zero** home reports is enough for us to fork the next score.

We will not start another 2600-step run until this is named.

Thanks —  
Ivan

---

## Operator notes (do not paste)

- Do not message Nicolas until Ivan sends this.
- Headless path of record: BE `reverie/backend_server/headless_visualization.py` → local `FRONTEND_URL` (default `http://localhost:3000`) → `double-front.service`.
- Fozzy “ran well” may still be true **and** home reports existed under the old **25-tile** accept bar. `20260802-1` had analyzer TELEPORT **0**, so a real Fozzy SHA compare still matters.
- BE follow-up (reject = stay and count 15/15) is ours. Do not put that on FE.
