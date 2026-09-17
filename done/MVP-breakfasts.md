# Breakfasts rehearsal — product spec and implementer brief

**Product MVP is LeaderTalks in Pittsburgh.** This file is the **Breakfasts rehearsal** locks (village / Hobbs). Do not treat this cohort as the MVP.

**Progress:** [`BREAKFASTS-BOARD.md`](BREAKFASTS-BOARD.md) — do not copy status here.  
**Before LeaderTalks Watch cut:** `double-ivan/20260917_pre-MVP.md`. **LeaderTalks + later:** `double-ivan/TODO_post_mvp.md`.  
**Status:** Active spec (locks). Portal chunks 1–11 shipped. Village talk unmute scored Current. Downtown map is **LeaderTalks**, not this watch URL.  
**Founder clicks:** [`MVP-breakfasts_ivan.md`](MVP-breakfasts_ivan.md) · **Map checklist:** [`R3F/TODOs_ivan-nicolas.md`](R3F/TODOs_ivan-nicolas.md)  
**Playable map (Nicolas, `double-r3f`):** locked below §1b. How-to: [`R3F/Pitts_Phaser.md`](R3F/Pitts_Phaser.md) · spatial numbers: [`MVP-0.1.md`](MVP-0.1.md)

Auto-coding agents: this file wins over older “village-first / park APIs until look / ENABLE_BREAKFASTS_ONBOARD” lines in `MVP-0.1.md` or earlier drafts of this spec.

**Locked 2026-09-08 (API):** one backend, maze at sim init, public API **`api.doubland.ai`**. Production git is **`railway`**. Pittsburgh tiles stay local until the map is promoted to Supabase.

**Locked 2026-09-08 (Join place — Option C):** each maze has a **fixed catalogue** of homes and jobs that actually exist on that map. Personality only **ranks** that list (best first). Claims live **per simulation instance** (Breakfasts occupancy does not block another Downtown sim). Do **not** invent roles or buildings at Join.

**Locked 2026-09-10 (home + role before land):** a new Double **picks home and job** on `/account` Join **before** the body is written into the sim. Village catalogue for this cohort. Not during quiz/Meet (`done` still does not Join). Do **not** skip / Surprise / auto-pick for Breakfasts. Auto-pick stays API fallback only if both ids are omitted — landing must send both. **Job step Current (2026-09-11):** UI shows **role** (`career`) with its workplace (e.g. barista · Hobbs Cafe). Same `job_id`. Do not invent roles. Village homes are **unique** (one occupant); hide full rooms. Jobs stay **shared**.

**Locked 2026-09-08 (portal profiling — A2):** instrument `ipip-mini10-portal-v1` (10 cited Mini-IPIP/IPIP markers, 2/domain) + chat `double-portal-interview-v1` (4 general adult beats). Keep short slider + short chat **shape**. Situational left/right poles only — **not** Strongly disagree/agree on the same slider. Do **not** print `1` / `5` on the poles. Do **not** put a Big Five / “public-domain markers” explanation under the slider (founder 2026-09-09). Do **not** claim the result *is* IPIP-BFM-25 or a full Mini-IPIP. Village 25-item path on double-front unchanged; if both exist, village **supersedes** portal means for `innate`. Brief: `COS/tasks/2026-09-08-003`.

**Locked 2026-09-07 (portal):** the address bar stays on **doubland.ai**. Canvas stays on double-front, **embedded**. Do not send allies to `app.ondouble.com` or to a raw Vercel sim URL.

**Locked 2026-09-09 (Look — photo + Phaser sprite):** every Double needs **both** before Breakfasts is a proper run. **Photo** = one still of the person, **saved on the profile in Supabase** (`persona_sprite_assets.profile_image_path`) so **later videos / trailers reuse it**. Browser preview is not enough. Not drawn on the map. **Sprite** = pick from the **existing** Phaser atlases already used at Join (`m1`–`m13`, `f1`–`f11` in `shared-assets`). Do not draw new pixel art. Do not hash a default from the name once they picked. Step sits on `/onboard` **after chat, before Meet**. Landing must `POST /api/me/double/photo` after sprite save. Missing look on an already-ready account: show Look on `/account`; Join waits; Watch is OK if they already joined. **Not** Nicolas / not the map checklist.

**Locked 2026-09-10 (Breakfasts world):** sim `pittsburgh-business-breakfasts` **stays** maze **`the_ville` / Hobbs**. Same Login, onboard, Join, and watch URL. Pittsburgh Downtown map is **not** this cohort’s world this wave (map will not be ready in time). Join follows this sim’s maze = **village catalogue**. Downtown / PPG remains later product work on a **different** sim or a later cut — not a rename of this watch URL.

**Locked 2026-09-09 (empty `/account` — Option A copy, live on www):** profile complete, no allowlisted sim → one **Submit**. Uses the Login email. Writes `double.waitlist` with `source=account-join`. On-screen: *Your Double is ready.* / *We’re sorry — you can’t join a simulation just yet. Still in beta. Invite only.* / *Ask for a seat. We’ll email you when it’s open.* After submit: *We’ll email you. You are not in a simulation yet.* **Not Join.** Does not name Breakfasts. Does not auto-allow. Founder still inserts the allowlist row. Landing ship date: `ivan/portal-a2-look` @ `22bf441` (Option A). That hash is **not** the live tip — see current www deploy.

---

## Public host (locked)

`https://www.doubland.ai` is the **public gate** and the **product surface** (login, onboard, account, watch).  
`https://double-front.vercel.app` is the **canvas only**. Allies never need that host in the address bar.

| Surface | Public URL (address bar) | What actually runs |
|---|---|---|
| Home / marketing | `https://www.doubland.ai` | Landing. Demo sim stays an iframe (existing). **Login** in the header. |
| Login | `https://www.doubland.ai/login` | Magic link. One Doubland Auth. Not Rehears / `app.ondouble.com`. |
| Auth callback | `https://www.doubland.ai/auth/callback` | Completes the email link. |
| Onboard (new profile) | `https://www.doubland.ai/onboard` | Personality test + chat + Look (photo + sprite) + Meet. |
| Account | `https://www.doubland.ai/account` | Dashboard. Joinable sims. Empty list: Submit asks for a seat (not Join). Join: pick **home + job**, then land. |
| Watch this cohort | **`https://www.doubland.ai/pittsburgh-business-breakfasts`** | Full-page iframe of the canvas. Origin stays doubland.ai. |
| Canvas (not public) | `https://double-front.vercel.app/simulations/pittsburgh-business-breakfasts` | Phaser player. Landing embeds it with `embed=1`. Do not add a second Vercel app. |

Local Ivan: landing `http://localhost:3001` with the same paths; iframe may point at local double-front. Do not hardcode localhost for allies.

**SOT lag:** `sot_lifecycle.md` §6 still treats account + profile-capture as deferred. This charter is **Desired** for the portal. Do not rewrite that SOT until the portal scores green.

---

## Public API (locked 2026-09-08)

One process. Maze is a **sim setting**, not a second product.

| Decision | Choice |
|---|---|
| Public name | **`https://api.doubland.ai`** (HTTPS 443). Retire `api.ondouble.com` after clients move. |
| Git | `generative_agents` **`railway`**. Onboard + village + Downtown live on this line. |
| Maps | `the_ville`, `downtown`, later mazes — pick at sim init. No extra API per map. |
| Pittsburgh files | **Local CSVs** while the map is still being edited. Later: same Supabase shelf as village. |
| Breakfasts world | **Saturday default:** `the_ville` / Hobbs on this same cohort. **Later:** Downtown / PPG when the map is ready. |
| Restart | VPS may restart while idle. Keep the Breakfasts sim **stopped** until the first wave has joined. |

Do not run two public API brands. Do not add `ENABLE_BREAKFASTS_ONBOARD`.

---

## Portal workflow (general) — Breakfasts is the first cohort

This is a **general Doubland process**. Pittsburgh Business Breakfasts are the first real users, not a one-off mini-app.

```
www.doubland.ai  →  Login (magic link to email)
        →  click link
        →  if no completed profile  →  /onboard  (quiz + chat + Look + Meet / done)
        →  if profile complete      →  /account  (dashboard)
        →  dashboard lists sims this user may join
        →  if the list is empty: ask for a seat (waitlist `source=account-join`, Login email).
           This does **not** Join. Founder still allowlists.
        →  Join  →  pick home + job from this maze’s catalogue (ranked)
                 →  POST /api/onboard/deploy with those ids (auto-pick if skipped)
        →  after this wave’s Doubles are on board, watch
              https://www.doubland.ai/pittsburgh-business-breakfasts
```

| Rule | Choice |
|---|---|
| Address bar | Always `www.doubland.ai`. Never bounce the browser to `double-front.vercel.app` or `app.ondouble.com`. |
| Login | Header **Login**. Email magic link. Same Supabase Auth as Doubland. |
| After the link | **New user** (no completed personality profile) → `/onboard`. **Returning user** (profile already complete) → `/account`. |
| Profile complete | `prediction_ready` from `POST /api/onboard/done`. Village 25-item quiz on double-front does **not** count as this portal’s onboard. |
| Meet vs join | Meet / `done` **only compiles** the Double. Join is **from the dashboard list**, not a Deploy button that leaves Meet for a Vercel URL. |
| Join list | Users with a profile see sims they may join. Later waves add rows. This wave has one row (below). Empty list: **ask for a seat** (same waitlist table, `source=account-join`, no second email). Not auto-allow. |
| Watch | Iframe on the pretty path. Start generation only after the first wave has joined (founder). |
| Old portal | `https://app.ondouble.com/` (Rehears) is retired as a door. Quarry copy only. No submodule. |

### First cohort — Pittsburgh Business Breakfasts

| Field | Value |
|---|---|
| Sim code | `pittsburgh-business-breakfasts` |
| Watch path | `/pittsburgh-business-breakfasts` |
| World | **Saturday default:** maze `the_ville`, gather **Hobbs Cafe**. Same sim name and portal. **Later:** `downtown` / PPG when the map is ready. Join follows the sim’s maze. |
| Who may join | Sim is **private**. You **add each Breakfasts member to this sim’s allowlist as soon as they register** (email they used on Login). Then `/account` shows this sim. Not a Sep 12 date rule. Not “anyone who signed up that day.” |
| Onboard instrument | 10 English Likert `ipip-mini10-portal-v1` + 4-beat `double-portal-interview-v1` (language-mirroring). Replaces `pgh-micro-v1`. Loop stays. |

### Allowlist process (this wave)

Join already checks `self_serve_sim_allowlist`. Keep that. **Do not** auto-allow by signup date.

```
Member taps Login on doubland.ai  →  magic link  →  account exists
        →  you add their Login email to this sim’s allowlist  (same day is fine)
        →  they finish /onboard if new
        →  /account shows pittsburgh-business-breakfasts
        →  they Join
```

**You, this week (exists now):** Supabase table `double.self_serve_sim_allowlist` — insert one row per person: this sim’s `simulation_id` + their **email** (lowercase). You may add the email as soon as they register; you do not need their user id.

**Do not** call the existing operator `PUT .../self-serve-allowlist` unless you resend **every** email already on the list. That PUT **replaces** the whole list (wipe risk). It also sits behind `ENABLE_ONBOARDING_HOST` — do not turn that flag on for Breakfasts.

**Coding 4b:** portal `GET` join list (reuse `list_joinable_sims` / `GET /api/me/double/bind/sims`) + a **safe add-one-email** operator call that does **not** wipe and is **not** gated by `ENABLE_ONBOARDING_HOST`. Until that ships, use the table insert.

---

## Build status

Live checkboxes: [`BREAKFASTS-BOARD.md`](BREAKFASTS-BOARD.md). Chunks **1–11**, wait UX, language mirror, role+workplace job picker, and watch `?double=` shipped. Photo persist **verified** 2026-09-11 for three Doubles (roster was later emptied; new Join still needs Look). This sim is **`the_ville` / Hobbs**. Map §1b is later, not this watch URL. **4b leftover:** join list live; founder still **inserts** allowlist rows (PUT replace banned) — daily add UI is post-MVP. Ops: [`MVP-breakfasts_ivan.md`](MVP-breakfasts_ivan.md). Do not implement the funnel on double-front.

---

## 0. What we are trying to achieve

**Cohort:** WhatsApp “Pittsburgh Business Breakfasts.” Warm network, not ads. They are the **first users of the general portal**, not a special host.

**Why before L-Talks:** Proof that peers recognize Doubles, follow Survival, and ask *“Can we run this for our company?”*

**This slice:** Login on doubland.ai → ~6 minute onboard if new → dashboard join list → pick **home + job** → English soul, no Ivan in the loop → Double on this cohort’s Survival sim. **This sim:** maze `the_ville` / Hobbs. Downtown map is later, **not** this watch URL. Watch at the pretty URL with the address bar on doubland.ai.

**Success:**

1. Phone on **doubland.ai**: Login → magic link → 10 English sliders → 4-beat chat (any language) → Look (photo saved + sprite) → Meet (`done`) → account → pick home + job → Join Breakfasts → body on the **stopped** village sim. Watch at `https://www.doubland.ai/pittsburgh-business-breakfasts`.
2. Soul = their life chapter from the general chat (work if they volunteered it). Sliders write `innate` only. Do not overwrite soul with a catalogue job title. Place = village home + walkable village job **they picked**.
3. Survival 11:00 / 20:00 at **Hobbs Cafe**. 80% bar = **joiners only** (empty world, no family plant).
4. Two allies pass on a phone before the WhatsApp blast.
5. Returning users with a profile land on `/account`, not the quiz again.

---

## 1. Locked product decisions

| Decision | Choice |
|---|---|
| Engine | Survival as shipped. No breakfast-club ruleset. |
| World | This sim: maze **`the_ville`**, gather **Hobbs Cafe**. Downtown / PPG is **not** `pittsburgh-business-breakfasts` this wave. |
| Flag | **No** `ENABLE_BREAKFASTS_ONBOARD`. Production BE is **`railway`**. Village 25-item quiz + 5-item form stay on double-front as they are. |
| BE git | `generative_agents` **`railway`**. |
| Roles | Life chapter in **soul text** (Meet compile; work if they volunteered). Place at Join = **Option C**, **required pick** of home + job before the body lands. This sim: village catalogue (Hobbs may be a job). **Not** `Residence 1`–`15`. |
| Identity vs place | Who they are on the person. Home / job / today written **at join** (`sot_lifecycle.md` §6.5). |
| Onboarding | **A2:** 10 English situational sliders `ipip-mini10-portal-v1` + 4-beat `double-portal-interview-v1` + English compile. Not `pgh-micro-v1`. Not village IPIP-BFM-25. |
| Meet vs join | **`done` compiles + `prediction_ready` only.** Join is from `/account`. Empty join list: Submit = waitlist `account-join` (Login email). Not Join; founder still allowlists. Second `done` does not clone a person. Join fails if LIVE or generating. |
| Display name | Editable on Meet as **Your Double's name**; prefill email local-part (or Auth first name if present). Map label = that name. Life chapter from chat lives in the English soul after `done` — **not** a Meet headline. |
| Consent | Required. *I understand this quiz and chat create a personality snapshot for Doubland rehearsal. They are not a medical or mental-health diagnosis, and not therapy. I agree to answer about myself (not someone else). Doubland may use these answers to create and run my Double when I Join a simulation.* |
| Honest line (quiz/Meet) | *This short quiz and chat build a personality snapshot so your Double can rehearse with you. Survival sims are real when you Join one from your account. Place and art details depend on the sim you join.* |
| Honest line (Breakfasts watch/Join only) | *This is Survival: Doubles share a day — they meet, take a challenge, and vote. Your Double plays it for you. Goal: still be in the game with the group. You gather at Hobbs Cafe.* |
| Look | **Required.** Photo **persisted** on the profile (videos later) + pick an existing Phaser sprite (map). After chat, before Meet. Do not skip; do not invent sprites. Browser preview ≠ saved. |
| Chat beats | General adult (§5d). No required company name, GPS, Downtown spot, or Pittsburgh identity. |
| Auth | Doubland Supabase magic link. One IdP. Redirects = **`https://www.doubland.ai`** (callback `/auth/callback`). Not `app.ondouble.com`. Canvas host does not need to be the magic-link landing. |
| Rehears | Quarry only. No submodule, no second login. Do not send Breakfasts users to `https://app.ondouble.com/`. |
| Portal FE | **`double-landing-page`** (prod `www.doubland.ai`). Branch `ivan/breakfasts-portal`. Do **not** copy Pittsburgh stems from `double-r3f` funnel.ts. |
| Canvas FE | **double-front** at `/simulations/pittsburgh-business-breakfasts`, **iframe only**. Not a second Vercel app. Onboard agent: **no** Phaser/CSV in the portal pass. Nicolas: playable map §1b on `double-r3f`. |
| Cast | Dedicated Survival instance, **no** leftover plant (`20260904-1` / `base_family_pittsburgh` / village family seed). Founder provisions; people **join**. Saturday maze = `the_ville`. |
| create-sim | Production village path unchanged. Do not retarget create-sim. |
| Playable map | Nicolas §1b. Cap **6**, scale **4:1**, no door teleport. **Ground floor only**; village-sized people/doors on the floor plan are OK. If art and walk disagree: **fix the draw**, or ping Ivan **before** changing collision. Interior walls and extra home doors: Nico **proposes** cells; **Ivan stamps** occupancy — do not draw walls only in Tiled. |

---

## 1b. Playable map (Nicolas) — locked 2026-09-07 · homes layout **2026-09-09**

Repo `double-r3f`, branch `pittsburgh` (first-pass rooms on `pittsburgh-rooms`). Draw on the ingested Downtown grid. Reuse **`the_ville` furniture/objects** as a **kit**, not a stamp. Object CSVs for Downtown are **empty until export** — write what you place into them.

### 1) Five commercial enterables

Interiors + village furniture, laid out on the Pittsburgh pads:

| Sim name | Host pad | Role |
|---|---|---|
| **PPG Cafe** | One PPG Place | Gathering / 11:00 / 20:00 |
| **Fifth Avenue Market** | Fifth Avenue Place | Enterable store |
| **EQT Supply Store** | EQT Plaza | Enterable supply |
| **O'Reilly Pub** | O'Reilly Theater | Enterable pub |
| **Penn College** | Penn Avenue Place | Enterable classroom |

ASCII apostrophe: `O'Reilly Pub`. Do not stretch PPG Cafe to village Hobbs walkable count.

### 2) Homes (these five pads) — livable units (locked 2026-09-09)

Same five host pads. **Do not pick new OSM buildings.** Star Loft is not a home. Do **not** split First & Market into Apt 1–5.

| Sim name | Host pad | This wave |
|---|---|---|
| **First & Market Apartments** | First & Market Apartments | **One** apartment (too small for two) |
| **Midtown Tower** | Midtown Towers | **One** apartment |
| **Gateway Tower** | Gateway Towers | **Two** independent apartments **if** each gets a street door + bath; else one |
| **Roosevelt Building** | Roosevelt Arms | **Two** if they fit; else one |
| **Encore on 7th** | The Encore on 7th | **Two** if they fit; else one |

**Livable, not density-stamped.** Nicolas plans the layout from the pad: living by the entrance, desk on a wall, bed private, bath behind a wall. Village table-chair recipes yield if they put a bed on the door or a table in the only aisle.

**Splits and bathroom walls are occupancy.** Nico sends the wall/door cells. **Ivan stamps** collision / `paint.json` / extra street doors, re-ingests, then Nico furnishes. Do not draw walls only in Tiled (Doubles would walk through). Shop doors stay put.

**PPG Cafe:** keep it a cafe; leave a visible aisle from the door through seating (hand pass). Do not reshape the diamond pad.

`Residence 1`–`15` are **spawn markers only**. Join **binds `living_area` to §1b apartment units** (one row per independent apartment, unique bind). Not `Residence N`. **Current** Join catalogue is the five pads until chunk 9.

### 3) Point State Park (outdoor)

Fountain, grass, paved trails, trees. Not a hollowed interior.

### Everything else

Sealed pads or walkable hollow. **Do not hollow yet:** Wood Street Studios, Academic Hall Dorm, YWCA, Penn Avenue Library, Star Loft, and any other reserved pad.

**Invariants:** one maze indoors+outdoors; cap 6; 1 cell = 4 Pittsburgh metres; doors are walk, not teleport. Village names must not appear on Downtown labels.

**This pass (ground-floor floor plan):** every enterable is **ground floor only**. Door and interior floor meet the **street**. No upper floors, no elevators, no fake tower interiors. Height / façades stay later (`Pitts_Phaser.md` Vision §1–2) — do not build them for Breakfasts.

**4:1 is the world:** Doubles and doors stay **village-sized**. On a compressed Pittsburgh footprint they will look large / chunky next to real building scale. That is accepted. Do not shrink sprites, do not make “realistic tiny doors,” do not grow pads to match Google Earth. A cell is a table-area, not a real-world chair.

**Do not hollow the skyline.** Only the named shops + homes in this section. Reserved pads stay sealed.

## 2. Current vs desired

| Piece | Current | Desired |
|---|---|---|
| Public gate | Login on **doubland.ai**. Rehears door retired | Same |
| Magic link | Landing `/login` + `/auth/callback`; mail from `@m.doubland.ai` | Same |
| After login | No profile → `/onboard`. Profile → `/account` | Same |
| 25-item IPIP + form interview | Shipped on double-front | **Keep** there. Portal onboard = `ipip-mini10-portal-v1` + 4 general beats (chunk 10). Village 25 **supersedes** portal `innate` if both exist |
| Bind / join | **Option C live:** ranked village home + job (role + workplace). Claims per sim. Omit ids → auto-pick fallback only | Same. Breakfasts landing always sends both ids |
| Join list API | `GET /api/me/double/bind/sims` (filters private by allowlist) | Portal `/account` uses that list. Public watch path on the Breakfasts row |
| Funnel UI | Live on **landing** `/onboard` (A2 + Look). Meet does not join | Same |
| Watch | **`https://www.doubland.ai/pittsburgh-business-breakfasts`** (iframe; `?double=` this user; origin stays doubland.ai) | Same |
| This cohort’s maze | **`the_ville` / Hobbs** (confirmed 2026-09-11) | Downtown / PPG later, **not** this watch URL |
| Five commercial interiors | Hollowed in occupancy; object lists empty; rooms often hidden under roofs | Visible interiors + `the_ville` furniture written into object CSVs |
| Homes | Five pads hollowed, open-plan first pass | Livable units: bath walls; two apartments on a large pad only if each has a street door (§1b 2026-09-09) |
| Point State Park | Green OSM blob | Fountain, grass, trails, trees |

Research: [`MVP-0.1.md`](MVP-0.1.md) §2.

---

## 3. Architecture

```
WhatsApp  →  https://www.doubland.ai   (Login)
        →  magic link email
        →  /auth/callback
        →  /onboard   if not prediction_ready
              POST /api/onboard/quiz
              POST /api/onboard/chat     stream; first bot line English, then mirror
              Look                     photo + existing Phaser sprite (chunk 11)
              POST /api/onboard/done     English soul + prediction_ready  (no join)
        →  founder adds Login email to this sim’s allowlist
        →  /account
              GET  joinable sims         (allowlist ∩ not yet bound)
              GET  bind options          (this maze’s catalogue, ranked, claimed hidden)
              POST /api/onboard/deploy   Join + home/job ids
        →  watch https://www.doubland.ai/pittsburgh-business-breakfasts
              (iframe → double-front /simulations/pittsburgh-business-breakfasts?embed=1)
```

**Reuse:** gateway JWT; `user_personality_profiles` + adapter / ISS; existing join (do not invent a second join); landing iframe helper (`embed=1`). Do **not** copy Breakfasts-flavored `funnel.ts` stems into the general door.

**Shipped 2026-09-11:** Look photo POST persists in Supabase (three Doubles verified). Join sends home + job (role + workplace). Maze **is** `the_ville`. Watch iframe passes `?double=`. **Still you:** keep sim stopped until you tell the backend agent to Start; WhatsApp after two allies see themselves at home.

---

## 4. Funnel copy

**Welcome:** **Build your Double** — not “Pittsburgh Business Breakfasts” as the personality product. Breakfasts is a join-list row.

**Quiz:** 10 sliders, one at a time, Back/Next. Show `situational_stem` + **left/right answers only**, larger type. Scale is still 1–5 (`1` = left, `5` = right) for scoring and screen readers. Do **not** print `1` / `5` on the poles. Do **not** also label Strongly disagree/agree. Do **not** put a Big Five / test-explanation paragraph under the slider. Honest “snapshot / not diagnosis” stays on **Meet** + consent, not under each item.

**Beats:** `beat-background`, `beat-rhythm`, `beat-friction`, `beat-aim` (§5d). First interviewer line English; then mirror. Soft min ~20 characters (warn) / hard min 8. **Current miss (2026-09-09 walk):** Russian on chat #2 did not make the next prompt Russian. **Live 2026-09-10 (`railway`):** after a non-English user line, do not replace the next bot line with the English beat. Founder walk still needed.

**Wait (live 2026-09-10, not instant):** Chat Send and **Continue to account** wait on the model (`done` may retry English). Show a waiting line immediately (*This can take a minute*). Do not leave the button looking dead. Do not double-submit. Founder: do not treat 20–60s on Meet→account as a hang. Founder walk still needed.

**Look:** after chat, before Meet. One **photo** (camera or upload) **saved to the profile** for later video — not the Phaser body. Browser preview is not enough. Then pick one **existing** map sprite (`m1`–`m13` / `f1`–`f11`). Required. **Back** → chat. Then Meet.

**Meet:** **Meet your Double**; **Your Double's name**; three English snapshot lines from the 10 **scored** domain means (general trait copy, not Breakfasts deals). Consent §1. **Back** → Look. **Continue to account**. Honest line = general portal line (§1). PPG line = watch/Join only.

**Never print on this door:** “IPIP-BFM-25,” “Mini-IPIP complete,” percentiles, diagnosis, “scientifically validated Doubland test,” “Jordan Peterson says…”.

---

## 5. API contract

Bearer required (same as `/api/me/quiz`). **No feature flag.**

### `POST /api/onboard/quiz`

`{ "instrument": "ipip-mini10-portal-v1", "answers": [ { "item_id", "value": 1-5 } ] }` — exactly the 10 `mini10-*` ids. Persist. Not `prediction_ready` alone. Reject `pgh-*` ids on this instrument. Do not silently re-score old Pittsburgh items as Mini-IPIP.

### `GET /api/onboard/quiz`

Auth required. Returns `{ "instrument", "answers": [ { "item_id", "value" } ] }` from the active **portal** quiz. Prefer `ipip-mini10-portal-v1`. Empty list if none. If the only row is legacy `pgh-micro-v1` and they are already `prediction_ready`, they stay on `/account` (no forced retake). Mid-funnel incomplete `pgh-*` answers are **not** mapped onto `mini10-*` — start the new bank.

### `POST /api/onboard/chat`

JSON. Server holds beat index + transcript. First interviewer line **English**. After the user speaks, **stay in their language**. Beats: `beat-background` → `beat-rhythm` → `beat-friction` → `beat-aim`. After beat 4, interview complete (client calls `done`). Reload / resume: if any answers are saved, return them (`answers: [{ beat_id, prompt, answer }]`) instead of “interview is complete”. Client shows an edit form; `{ "answers": [...] }` replaces the four user lines. Not Talk-to-Double.

### `POST /api/onboard/done`

Quiz + transcript → **English** soul. **`innate` = deterministic template from scored means only** (overwrite any LLM `innate`). Chat fills `learned` / `currently` / `lifestyle` / `goals`. Sets `prediction_ready`. **Does not join.** Idempotent (no second persona). One English retry if the first compiler pass is invalid or not English. If the model returns blank, English fallback from quiz template + chat text. No barista/librarian unless they said it.

### `POST /api/onboard/deploy`

Join remains `POST /api/me/double/bind/{sim}/join` from **dashboard Join**, wrapped as `POST /api/onboard/deploy` `{ "sim_code", "home_id"?, "job_id"? }`: **maze = this sim’s maze**; sim `stopped`/`paused`, not generating, not LIVE; capacity; one bind; home/job must be in this maze’s catalogue and still claimable. If omitted: auto-pick from remaining (backward compat). If `downtown`: work ≠ PPG Cafe; living_area = a stamped §1b apartment unit. If `the_ville`: village catalogue (Hobbs may be a job).

**Eligibility:** private allowlist on this sim. Keep LIVE/generating/capacity/one-bind gates. No signup-date gate.

### 5c. Maze catalogues + ranked picker (chunk 9, Option C — locked 2026-09-08)

**Catalogue = maze**, not each sim fork. Files (or equivalent tables) for `downtown` and `the_ville` only this wave. New maze later = new file.

**Claims = this simulation.** Occupancy on `persona_scratch.living_area` / `work_area` for this `simulation_id`.

**Personality = sort.** Show the catalogue (minus full/claimed slots), best-fit first. Do not add a place the map does not have. **No LLM at Join** (deterministic rank from the existing profile). **No free-text.**

| Maze | Homes | Jobs | Claim rule |
|---|---|---|---|
| `downtown` | **Current:** five §1b pads (`Downtown:<name>:apartment`). **Desired:** one catalogue row per independent apartment (Roosevelt / Encore / Gateway may be two). Not Star Loft. Not `Residence N`. | Fifth Avenue Market, EQT Supply Store, O'Reilly Pub, Penn College. **Not PPG Cafe.** | **Current:** share OK up to `max_occupants` (default 3). **Desired:** unique `living_area` per stamped unit. Jobs: shared workplaces OK. |
| `the_ville` | Private rooms from the village map (House / Apartment / dorm **room**, not kitchens). | Walkable workplaces already on the map (Hobbs, Oak Hill, Willows, Harvey Oak, Rose and Crown). No `remote`. | Homes: **unique** `living_area`. Jobs: unique title if the list is long enough; else shared workplace OK. |

**Do not** turn on `ENABLE_ONBOARDING_HOST`. Do not send portal users to double-front `/onboarding/join-world`. Do not call the LLM career suggester at Join.

Reuse the finalize **writes** (`living_area`, `work_area`, `curr_tile`, `daily_plan_req`). Do **not** overwrite Meet `currently` / ISS soul with a catalogue barista line.

### 5b. Join list + allowlist add (chunk 4b)

**`GET` joinable sims** — Auth required. Reuse `list_joinable_sims` (already `GET /api/me/double/bind/sims`). Portal may wrap as `GET /api/onboard/sims`. Returns sims this user may join (on the allowlist, not yet bound). Breakfasts row includes public path `/pittsburgh-business-breakfasts`. After join, watchable on that path, not joinable again.

**Safe add (operator):** append **one** email (or user id) to `pittsburgh-business-breakfasts` without deleting existing rows. Not `ENABLE_ONBOARDING_HOST`. Do not use today’s `PUT` replace as the daily add. Until this ships, founder inserts a row in `double.self_serve_sim_allowlist`.

**Empty `/account` (Option A copy, 2026-09-09):** profile complete, no allowlisted sim → one Submit, Login email, `POST /api/waitlist` with `source=account-join`. Copy: *Your Double is ready.* / *We’re sorry — you can’t join a simulation just yet. Still in beta. Invite only.* / *Ask for a seat. We’ll email you when it’s open.* After submit: **We’ll email you. You are not in a simulation yet.** Does not Join. Does not name Breakfasts. Founder still inserts the allowlist row (filter waitlist on `source=account-join`). Live on www `ivan/portal-a2-look` @ `22bf441`. Do not Promote Look PR #2 over this.

Do not invent a catalog CMS. Do not auto-insert by Sep 12. Do not generate jobs at Join.

### 5d. Portal profiling A2 (chunk 10 — locked 2026-09-08)

Ship **after** chunk 9. Source report: `COS/agents/jordanpeterson/kb/raw/task-deliverables/2026-09-08-portal-general-audience-profiling.md`. Founder lock includes the slider-chrome correction below.

**Quiz id:** `ipip-mini10-portal-v1`. **Chat id:** `double-portal-interview-v1`. Replaces `pgh-micro-v1` / `beat-role|cadence|conflict|morning` for **new** onboard. Keep historical `pgh-micro-v1` rows.

**UI:** one item at a time; 5-point; show **situational_stem + left_anchor / right_anchor only** (larger type). Raw `1` = left, `5` = right. Do **not** print `1` / `5` on the poles. Do **not** put a Big Five explanation under the slider. Backend: if `reverse`, scored = `6 - raw`, then domain mean of 2 items (1 decimal). Bands ≤2.5 lower / ≤3.5 typical / else higher. **No percentiles.** Do **not** put Strongly disagree/agree on the same control. IPIP `question_text` is citation only (not on the phone).

**Hard wording bans on this door:** Pittsburgh, Downtown, PPG, breakfast, founders, “this quarter,” required company name, GPS/pin, teen/school.

| order | id | trait | reverse | situational_stem | left (1) | right (5) |
|------:|----|-------|---------|------------------|----------|-----------|
| 1 | `mini10-e-1` | extraversion | false | At a casual gathering with people I don’t know well, I usually… | stay quiet on the edge | energize the room and pull people in |
| 2 | `mini10-e-2` | extraversion | true | In a small-group discussion at work or among friends, I usually… | talk as much as anyone | say very little |
| 3 | `mini10-a-1` | agreeableness | false | When someone close to me is clearly upset, I usually… | keep emotional distance | feel with them and show I care |
| 4 | `mini10-a-2` | agreeableness | true | When a colleague or friend starts sharing a personal problem, I usually… | listen and engage | want to move on quickly |
| 5 | `mini10-c-1` | conscientiousness | false | When ordinary tasks pile up at home or work, I usually… | put them off | knock them out promptly |
| 6 | `mini10-c-2` | conscientiousness | true | After I use something, I usually… | put it back where it belongs | leave it wherever it landed |
| 7 | `mini10-n-1` | neuroticism | false | When a plan falls through without warning, I usually… | stay even | get upset quickly |
| 8 | `mini10-n-2` | neuroticism | true | Across a normal week, my baseline is usually… | tense or on edge | relaxed most of the time |
| 9 | `mini10-o-1` | openness | false | When I have quiet time alone, I usually… | stick to concrete to-dos | drift into vivid ideas and possibilities |
| 10 | `mini10-o-2` | openness | true | In a conversation that turns theoretical or abstract, I usually… | lean in with interest | lose interest and steer back to the practical |

Cite internally: IPIP Mini-IPIP scoring key; Donnellan et al. (2006). This is **10 of 20** markers — a coarse prior.

**Chat English first lines**

| # | id | First line | ISS |
|---|-----|------------|-----|
| 1 | `beat-background` | What do you do day to day, and what are you mainly focused on in this chapter of your life? | `learned` + short `currently` |
| 2 | `beat-rhythm` | In a typical week, how do you spend your energy — work, people, quiet time, side projects, home? | `lifestyle` |
| 3 | `beat-friction` | Tell a recent real situation where something got hard (work, friends, or home). What did you want, what did you do, and how did it turn out? | append pattern to `learned` |
| 4 | `beat-aim` | Looking about 6–12 months ahead, what would “better” look like in concrete terms — one aim you’re willing to own? | `goals` + Aim: in `currently` |

Helpers (optional): beat 3 “One short story beats vague traits.” Beat 4 “Ship X / repair Y / build a weekly habit — not a vague wish.”

**`innate` (overwrite LLM):**

```
Disposition snapshot (self-report Big Five markers from a short public-domain set, scale means 1–5 — not a clinical diagnosis; not the full IPIP-BFM-25):
Openness {O_band} ({O_mean}); Conscientiousness {C_band} ({C_mean}); Extraversion {E_band} ({E_mean}); Agreeableness {A_band} ({A_mean}); Emotional variability {N_band} ({N_mean}).
Bands are relative to this questionnaire’s 1–5 scale (lower / typical / higher), not population percentiles. Instrument: ipip-mini10-portal-v1 (coarse prior).
```

**Village 25:** unchanged on double-front; does not skip portal `/onboard`. If both exist, village means **supersede** portal for temperament/`innate`. Store both; do not average. Runtime supersede may wait until someone can complete both on one account — **lock the rule now**.

**Overlay beat:** optional, not in v1. Do not bake Breakfasts into the general bank.

**Retake:** new users get A2. Existing `prediction_ready` on `pgh-micro-v1` stay on `/account`. Optional later CTA: refresh snapshot.

---

## 6. Work to build

Chunks; narrowest test; stop on fail.

| Chunk | Behaviour | Repo | Check |
|---|---|---|---|
| **1** | ~~`pgh-micro-v1` + `POST /api/onboard/quiz`~~ **Done** | `generative_agents` `breakfasts` | pytest scoring + 401 |
| **2** | ~~4-beat chat~~ **Done.** Language follow **live** on `railway` | same | beat advance; non-English user → do not swap in the English beat. Founder walk still needed |
| **3** | ~~`done` → English soul + ready, no join~~ **Done** | same | keys present; no barista job. Meet→account **slow** (LLM) — wait UX **live** on www |
| **4** | ~~Deploy join downtown~~ **Done** (pad is still `Residence N` until §1b homes exist) | same | join blocked if LIVE/generating |
| **4b** | Join list for portal + **add-one-email** allowlist (no wipe) | leftover | List live. Founder still **inserts** rows. Daily UI = **PM-BFST-7**. PUT replace still banned |
| **5** | ~~Login + callback + router~~ **Done** | `double-landing-page` | New user → `/onboard`; returning `prediction_ready` → `/account` |
| **6** | ~~`/onboard` quiz/chat/Meet/`done`~~ **Done** (A2 on www). Look is chunk **11** (**Done**) | landing | Phone walk 2026-09-09: Meet does not join. Founder still walks Russian |
| **7** | `/account` join list + Join | same | Empty list: Option A + Submit **Done**. Allowlisted Join **walked** (three Doubles on roster 2026-09-11; roster later emptied) |
| **8** | ~~Pretty watch iframe~~ **Done** | same | `https://www.doubland.ai/pittsburgh-business-breakfasts` stays on that origin. `?double=` this user **Done** |
| **9** | Maze catalogues + ranked home/job picker + claims | BE + landing (`/account` Join) | **Done.** Required village home + job; job step shows **role + workplace**. This sim = `the_ville` catalogue. Downtown apartments = **PM-BFST-3** |
| **10** | ~~A2 general quiz + chrome + Option A empty-join + wait UX~~ **Done on www** | landing + BE | No Pittsburgh chrome; no Big Five under slider. Wait line on Send / Continue. Language mirror is BE (founder walk) |
| **11** | ~~Look screen: photo + existing Phaser sprite~~ **Done on www** (3×4 stills, camera/gallery). **BE live** | landing | Sprite + photo persist **verified** 2026-09-11. Join 409 until both |

**Branches:** BE production **`railway`**. Portal FE is on www (A2 + Look shipped). Old hashes `22bf441` / `6fd96b30` are **ship dates**, not live tips. Do not Promote an older Look PR over current www. Not frozen village `main`. Not double-front `/onboard/pgh`. Onboard agent does not edit Nicolas Phaser/CSV. Nicolas playable map is §1b on `double-r3f` `pittsburgh`.

**Prompts:** `prompt-verify` after chunk **10** interviewer/compiler (chunks 2–3 were the Breakfasts-flavored bank).

**Tests:** missing slider; extra id; join while generating; second `done` no-op; Russian (or similar) transcript → English soul; not on allowlist → cannot join; add-one email does not wipe; login router both arms.

---

## 7. Survival

Use shipped Survival. **Saturday:** `the_ville` / Hobbs. **Later:** Downtown / PPG Cafe. Compiler fills life-chapter ISS from general chat (work if volunteered). Fourth wall stays. Founder starts generation **after** the first wave has joined.

Daily video = founder/ops after the funnel works.

---

## 8. Out of scope

Rehears / `app.ondouble.com` as front door; claiming portal scores *are* IPIP-BFM-25 or full Mini-IPIP; percentiles; diagnosis; teen banks; public paid Doubland; cloning `base_family_pittsburgh`; hollowing Wood Street Studios / Academic Hall Dorm / YWCA / Penn Avenue Library / Star Loft (and other reserved pads); treating Residence 1–15 as apartments; splitting First & Market into Apt 1–5; a **second** public API; Find My Double on village player; late join while LIVE; raising cap 6 or changing 4:1 without Ivan; `ENABLE_BREAKFASTS_ONBOARD`; funnel screens on double-front; a second Vercel app; browser redirect that leaves doubland.ai; **new** Phaser sprite sheets; using the profile photo as the map body. Full façade-town height (Pitts_Phaser 1–2) is **parallel**, not a gate on onboard APIs. Do not rescale Doubles or doors to real Pittsburgh metres. Do not hollow every OSM pad. Do not upload Downtown tiles to Supabase while the map is still being edited.

---

## 9. Definition of done

Ally-ready when:

1. Phone on **doubland.ai**: Login → magic link → quiz → 4-beat chat (one non-English) → Look (photo + sprite) → Meet (`done`) → account → Join → Double on the **stopped village** sim. Watch at **`https://www.doubland.ai/pittsburgh-business-breakfasts`** with the address bar still on doubland.ai.  
2. Returning user with a profile skips onboard and sees the join (or watch) list. Empty list: Submit asks for a seat (`source=account-join`); still not Join until you allowlist.  
3. After you add their Login email to this sim’s allowlist, they can join `pittsburgh-business-breakfasts` from `/account`.  
4. English soul matches their life chapter (work if they said it). `innate` matches the 10 scored means, not a chat paraphrase. Quiz/Meet copy has no Pittsburgh/PPG.  
5. Founder starts sim **after** the first wave has joined and each sees themselves at home; 11:00 / 20:00 at **Hobbs Cafe** for the **joiner** roster. (Downtown / PPG is a later sim, not this watch URL.)  
6. No hand-authored ISS.  
7. Village quiz/interview unchanged. Production API is **`railway`** / `api.doubland.ai`.

**WhatsApp-showable map** (Nicolas, §1b): five commercial interiors furnished (PPG with an aisle); livable homes on the five pads (splits/bath walls after Ivan stamps); Point State Park readable as a park; object CSVs no longer empty for what was placed.

WhatsApp blast still needs [`MVP-breakfasts_ivan.md`](MVP-breakfasts_ivan.md). Blast link = `https://www.doubland.ai` (Login), not a Vercel URL.

---

## 10. Cloud Agent kickoff (paste)

Portal chunks **1–8**, **10**, and **11** already shipped. **Chunk 9 (Option C):** `COS/tasks/2026-09-08-001/final.md` — coded, not founder-scored. Do not reuse the block below (original portal funnel).

```text
You are implementing the Doubland portal workflow. Pittsburgh Business Breakfasts is the first cohort.

## Goal
Login on www.doubland.ai (magic link). New users complete /onboard (10 sliders + 4-beat multilingual chat); done compiles English soul (no join). Returning users go to /account. Dashboard lists joinable sims (private allowlist). Founder adds each registrant’s email to pittsburgh-business-breakfasts. Watch at https://www.doubland.ai/pittsburgh-business-breakfasts (iframe; address bar stays).

## Context
- double-docs/MVP-breakfasts.md (this file wins)
- sot_lifecycle.md §6.5 (join write); §6 account phases are Desired until scored
- quiz_profile_service.py, interview_soul.py, self_serve_bind_service.py, auth.py
- double-r3f/lib/onboard-pgh/funnel.ts
- double-landing-page (portal). Canvas = double-front iframe only.

## Constraints
- BE production `railway`. Do not add ENABLE_BREAKFASTS_ONBOARD.
- done does not join. Join from /account via existing deploy/join. Maze = this sim (`the_ville`; Downtown later).
- No Rehears submodule. Do not send users to app.ondouble.com.
- Address bar stays on doubland.ai. Do not redirect the browser to double-front.vercel.app.
- Do not add a second Vercel host. Portal pass: no Phaser/CSV. Homes = §1b list, not Residence N.
- Do not build /onboard/pgh on double-front.

## Acceptance
- quiz / chat / done as specified; join blocked if LIVE
- GET joinable sims (allowlist) + safe add-one-email; no Sep 12 date gate
- Watch URL https://www.doubland.ai/pittsburgh-business-breakfasts stays on that origin
- Tests per MVP-breakfasts.md §6

## Out of scope
railway as a second product, family-plant clone, daily trailers, Rehears port
```
