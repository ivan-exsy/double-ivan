# Breakfasts rehearsal — founder TODOs (manual / UX / ops)

**Product MVP is LeaderTalks in Pittsburgh.** These clicks are the Breakfasts rehearsal, not the MVP.

**Progress:** [`BREAKFASTS-BOARD.md`](BREAKFASTS-BOARD.md). **Spec:** [`MVP-breakfasts.md`](MVP-breakfasts.md) (that file wins).  
**Before LeaderTalks Watch cut:** `double-ivan/20260917_pre-MVP.md`. **LeaderTalks + later:** `double-ivan/TODO_post_mvp.md`. Map stamp: [`R3F/TODOs_ivan-nicolas.md`](R3F/TODOs_ivan-nicolas.md).  
**You do these.** Coding does not have your WhatsApp, GoDaddy, Vercel, or ally phones.

**Locked 2026-09-08:** one API (`api.doubland.ai`), production git **`railway`**, maze at sim init. Downtown tiles stay local until you promote them.  
**Locked 2026-09-10:** this sim **stays `the_ville` / Hobbs**. Photo must save to Supabase for later video. Join must pick **home + job** before the body lands.

**Locked A2:** general 10 sliders + 4 life-chapter beats. WhatsApp after 2 allies pass on that door.

Landing portal is **live**. Join shows **role + workplace**. Watch iframe passes `?double=`. First allowlist email: **insert** one row (never PUT replace).

**Auth mail:** Resend, verified domain **`m.doubland.ai`**. Sender `noreply@m.doubland.ai`. Openrouter email send cap **100/hr**. Not `noreply@doubland.ai`.

Allies use **doubland.ai** only. Do not send people to `app.ondouble.com` or `double-front.vercel.app`.

---

## You (still open)

1. **Walk Russian again** — language mirror is live on `railway`; first interviewer line stays English; the **next** prompt must follow them.
2. **Tell Nicolas** — allies watch `https://www.doubland.ai/pittsburgh-business-breakfasts` on the **village**. His Pittsburgh pass is later (`R3F/TODOs_ivan-nicolas.md`).
3. **Allowlist** — insert one Login email per new ally (`double.self_serve_sim_allowlist`). Never PUT replace. Loop in **B2** below.
4. **Next tester wave** — sim **stopped** → they Join (home + job, Look saved) → then tell the agent to Start (sprint + skip-premiere). Play is playback only. Cap **6**. Clicks: [`20260912_Breakfasts/20260912_breakfasts_run.md`](20260912_Breakfasts/20260912_breakfasts_run.md).
5. **WhatsApp** — only after 2 allies pass on the portal. Link = `https://www.doubland.ai` (Login). Not yet.

**Done (do not re-click):** GoDaddy `api` → box (public API is live); landing `API_GATEWAY_URL=https://api.doubland.ai`; A2 onboard + Look persist (2026-09-11); three test Doubles allowlisted/Joined then roster emptied for Saturday. Re-check DNS only if landing 404s.

**Not you:** merging git, restarting the gateway, rewriting Join. **Not this week:** uploading Pittsburgh tiles to Supabase; Google OAuth (post-MVP).

---

## A. Before anyone can join

- [x] **Sim code (locked):** `pittsburgh-business-breakfasts` — matches watch path `/pittsburgh-business-breakfasts`. Do not reuse `20260904-1` or village score sims.
- [x] **Public URLs (locked):**
  - Gate: `https://www.doubland.ai` (Login in the header)
  - Watch: **`https://www.doubland.ai/pittsburgh-business-breakfasts`** (iframe; origin stays doubland.ai)
  - Canvas (not for allies): `https://double-front.vercel.app/simulations/pittsburgh-business-breakfasts?embed=1`
  - Retired: `pittsburgh-business-breakfasts.vercel.app`, `app.ondouble.com` as a door
- [x] **Supabase Auth allowlist** — magic link must land on the **portal**:
  - `https://www.doubland.ai/**`
  - `https://www.doubland.ai/auth/callback`
  - `https://www.doubland.ai/login`
  - `https://www.doubland.ai/onboard`
  - `https://www.doubland.ai/account`
  - local landing `http://localhost:3001/auth/callback` (and `/login`, `/onboard`)
- [x] **Landing env** — Login must **not** send people to `APP_URL=app.ondouble.com`. Portal is doubland.ai.
- [x] **Magic-link email glance** — 2026-09-08: Login on doubland.ai → mail from Doubland / `@m.doubland.ai` → `/auth/callback` on doubland.ai → **`/onboard`** (Build your Double). Not Rehears. Site URL `https://www.doubland.ai`. Do not reuse old emails.
- [ ] **Tell Nicolas** — allies watch **doubland.ai/pittsburgh-business-breakfasts**, not a separate r3f host. Do not block him on portal APIs. Iframe floor: map checklist. Downtown is **not** this cohort.

---

## B. World + access (you)

Join only works when the sim is **stopped or paused**, not generating, not LIVE.

- [x] **Sim named `pittsburgh-business-breakfasts` exists** (created as maze `downtown`, PPG gather). **Empty cast** — do not fork `20260904-1` / `base_family_pittsburgh`. People **join**.
- [x] **This sim maze = `the_ville`.** Confirmed 2026-09-11. Same sim name, Login, onboard, Join, watch URL. Gather = Hobbs. Downtown is **not** this cohort. Not a second API.
- [x] **Set access = private** + joinable + max roster (default cap 15).
- [x] **Start (2026-09-11 test):** sprint + skip-premiere. Saturday empty/reset happened; reuse this watch URL. Clicks: [`20260912_breakfasts_run.md`](20260912_Breakfasts/20260912_breakfasts_run.md). Do not Join while generating.
- [x] **Production is `railway`** (onboard + both mazes). Public API name **`api.doubland.ai`**. Do not add `ENABLE_BREAKFASTS_ONBOARD`. Do not turn on `ENABLE_ONBOARDING_HOST` for this wave.

**Chunk 9:** Join **requires** village home + job before the body lands. No Surprise. Score on first allowlisted Join.

---

## B2. Allowlist — add each member **after they register** (this is the gate)

There is **no** Sep 12 automatic signup rule. A person sees Breakfasts on `/account` only after you put them on this sim’s list.

**Loop (repeat per person):**

1. They tap **Login** on `https://www.doubland.ai` and complete the magic link. (They can start `/onboard` in parallel.)
2. You take the **same email** they used.
3. You **add that email** to this sim’s allowlist (one row, do not wipe others).
4. After `/onboard` (if new), `/account` shows **Join** for `pittsburgh-business-breakfasts`.
5. They Join. You do not Join for them.

If `/account` is empty they can tap **Submit**. Copy is Option A (ready / sorry beta invite-only / ask for a seat). That writes `double.waitlist` with `source=account-join` and their Login email. It does **not** put them on the sim. Still add the allowlist row (B2). Then tell them to refresh `/account`.

**How to add (exists today — use this until coding 4b ships a one-email add):**

1. Supabase → table **`double.self_serve_sim_allowlist`**.
2. Find `simulation_id` for sim name `pittsburgh-business-breakfasts` (table `double.simulations`, column `name`).
3. **Insert** one row: `simulation_id` + `email` (lowercase, the Login email). User id optional.
4. Confirm they are not already on the list (same email twice is noise, not a second seat).

**Do not** use operator `PUT /api/onboarding/{sim}/self-serve-allowlist` for daily adds. That call **replaces the whole list** and sits behind `ENABLE_ONBOARDING_HOST`.

- [ ] **Add yourself** once your Login on doubland.ai exists (so you can Join in C).
- [ ] **Add each Breakfasts member** as soon as they register. Keep a scratch list of emails you already added.
- [ ] If `/account` is empty after they finish onboard — they can Submit a seat request; you still add the Login email (B2), or the email does not match Login.

---

## C. Accounts you must click yourself

Portal routes exist. Funnel is **not** on double-front `/onboard/pgh`.

- [x] **Login on doubland.ai** with your own email. 2026-09-08 round-trip. Not Admin JWT, not `app.ondouble.com`.
- [x] **New user → `/onboard`** (Build your Double). Confirmed 2026-09-08.
- [x] **After Meet/`done` → `/account`** (no Join on Meet). 2026-09-09 A2 walk. Wait UX **Done** on www 2026-09-10.
- [x] **Add your email** to the sim allowlist (B2). Breakfasts is on `/account`. Ivan Double is on the roster.
- [x] **Second account** — Doublandai+20260911 1 onboarded, Joined, on roster. Photo + sprite saved.
- [x] **Third account** — Ip+20260911+1 onboarded, Joined, on roster. Photo + sprite saved.
- [x] **One non-English chat** (Russian #2 on 2026-09-09). Next prompt stayed English. Language mirror **live** on `railway` 2026-09-10 — walk Russian again.
- [ ] Google OAuth later if you want it. Not required for magic link.

---

## D. Copy (locked in the spec — reopen only if you want a change)

Already locked in [`MVP-breakfasts.md`](MVP-breakfasts.md):

- 10 sliders `ipip-mini10-portal-v1` + 4 general beats (not Downtown coffee / Pittsburgh company). Poles = two answers only; no `1`/`5` labels; no Big Five line under the slider. Snapshot/not-diagnosis stays on Meet + consent.
- Empty account (Option A): *Your Double is ready.* / *We’re sorry — you can’t join a simulation just yet. Still in beta. Invite only.* / *Ask for a seat. We’ll email you when it’s open.* Submit ≠ Join.
- Look (chunk **11**, **live** 2026-09-10): photo **saved on the profile** (videos later) + pick an existing map sprite. After chat, before Meet. Persist **verified** 2026-09-11 for three Doubles. www `ivan/portal-a2-look`. API `railway`.
- Meet → **Continue to account**, not Join/Deploy
- Honest line on quiz/Meet = personality snapshot / rehearsal. PPG Survival line = **watch/Join only**
- Consent: snapshot for rehearsal, not diagnosis/therapy; answer about yourself; may run your Double when you Join
- Your Double's name: editable Meet field; email local-part; no company headline on Meet

- [ ] **WhatsApp blast** — wait until 2 allies pass **on the portal**. Link = **`https://www.doubland.ai`** (tap **Login**). ~6 minutes. Tell them you will **unlock Join after they register** (same email). This sim is village / Hobbs.

---

## E. Next tester wave (same watch URL)

Clicks in order: [`20260912_Breakfasts/20260912_breakfasts_run.md`](20260912_Breakfasts/20260912_breakfasts_run.md). Do not mint a second sim.

- [ ] **Sim stopped** before anyone Joins. If a score run is generating, wait or tell the agent to drain — do not Join.
- [ ] **Allowlist:** your real Login email + each tester (one-row insert). Never PUT replace.
- [ ] **Each tester:** Login → onboard (Look photo must save) → you insert email → they Join (home + job) while **stopped** → they see themselves at home.
- [ ] **Cap 6.** Stop adding when six bodies are on the map.
- [ ] **Start** only then — tell the backend agent (sprint + skip-premiere). Not the watch Play button.
- [ ] **Late joiner** — pause, add email if missing, they Join from `/account`, resume. No join while generating.
- [ ] **WhatsApp blast** — wait until 2 allies pass **on the portal**. Link = **`https://www.doubland.ai`**.

**Post-MVP (do not treat as this week):** full-group “sounds like them” (**PM-VIL-2**); B2B line on Watch; daily video; Google OAuth; Downtown tiles in Supabase. See `double-ivan/TODO_post_mvp.md`.

---

## F. Later (not this week)

- [x] When you **Join** (after allowlist): pick a village room + village job (role + workplace). Body lands only after both. Walked 2026-09-11.
- [x] Look (photo + sprite) on A2. Persist verified 2026-09-11.
- [x] Chunk **10** chrome + Option A empty-join. Language + wait shipped 2026-09-10; you still walk Russian.
- [ ] Broader `ondouble.com` leftovers can wait. Downtown tiles stay local until you promote them. L-Talks Telegram remains later.

---

## Waiting on whom

| If this is empty | Who |
|---|---|
| No sim / still LIVE when they Join | You |
| Magic link never arrives / lands on Rehears | You — openrouter Auth + Resend SMTP (`m.doubland.ai`). Glance **passed** 2026-09-08; new fails → SMTP / Site URL |
| They registered but `/account` has no Breakfasts | You — add their Login email (B2) |
| Quiz/chat/done/deploy 404 on the gateway | Coding — VPS not on `railway` tip / landing still on a dead host |
| Merge to railway | **Done 2026-09-08** — production is that line |
| No Login / `/onboard` / `/account` on doubland.ai | **Done** — portal is live on www. If 404 after a promote, that deploy is not current landing. |
| Empty account copy still the short “Ask for a seat” only | **Done 2026-09-09** — Option A on www |
| Magic link opens `/` with a token in the hash | **Done 2026-09-10** — www sends hash `access_token` to `/auth/callback`. Request a new email. |
| No photo / all Doubles look the same on the map | Sprite is the map body. **Photo** persist **verified** 2026-09-11 for Ivan Double, Doublandai+20260911 1, Ip+20260911+1. New Join still waits until photo + sprite exist. Not Nicolas |
| Allowlist add wipes everyone else | Coding — chunk **4b** one-email add; until then use table **insert**, never PUT replace |
| Meet still Joins / opens Vercel | Coding — Meet = `done` only; Join from `/account` |
| Watch URL leaves doubland.ai | Coding — chunk **8** iframe, not a window redirect |
| Bodies on sidewalk `Residence N` | Downtown later (**PM-BFST-1**). This cohort Join uses the village catalogue |
| Chat stays English after they wrote Russian | **Shipped 2026-09-10** on `railway`. First line English is OK; the **next** prompt must follow them. You still walk it. |
| Meet → account looks frozen | **Shipped 2026-09-10** on www. 20–60s is the model; must show *This can take a minute.* You still walk it. |
| Map / iframe still village | **This cohort is village.** Downtown map is later — [`R3F/TODOs_ivan-nicolas.md`](R3F/TODOs_ivan-nicolas.md) · **PM-BFST-1** |
