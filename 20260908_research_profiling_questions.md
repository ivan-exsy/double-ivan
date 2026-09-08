# Expert inquiry — General-audience profiling for the Doubland portal

**To:** Behavior science / assessment specialist (`jordanpeterson` — Peterson-informed; not Jordan Peterson)  
**From:** Ivan / product  
**Date:** 2026-09-08  
**Status:** Draft — run this **on the heels of** the accepted Rehears Week 3 work. Do not reopen that lock unless you find a **blocking** validity/ethics problem.  
**Predecessor (accepted 2026-07-14):** [`rehears-double/20260714_behavior_science_inquiry_week3.md`](rehears-double/20260714_behavior_science_inquiry_week3.md)  
**Related:** [`rehears-double/20260714_fe_request.md`](rehears-double/20260714_fe_request.md) · [`rehears-double/20260714_behavior_science_inquiry_week3_3_post_chat_learning.md`](rehears-double/20260714_behavior_science_inquiry_week3_3_post_chat_learning.md)  
**Product spec (portal, not village):** [`double-docs/MVP-breakfasts.md`](../double-docs/MVP-breakfasts.md)  
**Audience for this doc:** Subject-matter expert. Engineering will implement your report as specified. Do not invent a new unpublished test if a public-domain / previously accepted bank can do the job.

---

## 1. Why we are asking you (again)

The **Doubland portal** is live on [www.doubland.ai](https://www.doubland.ai): Login → onboard → account → Join. Pittsburgh Business Breakfasts is the **first cohort**, not a one-off mini-app.

Founder just walked the 10 sliders. Two product problems:

1. **The items feel written for him** (Doubland founder, Breakfasts member, Pittsburgh operator) — not for *any* adult who will later use the same door.  
2. He wants the **psychometric / behavior-science foundation** made explicit, and he wants us to **tap the Rehears research that already locked a serious instrument**, instead of shipping a homemade Breakfasts quiz as if it were that work.

This inquiry is the next research question after Week 3. It is **not** “redesign personality from scratch.” It is: **what general-audience instrument + chat belong on the Doubland portal**, given IPIP-BFM-25 + Week 3 interview already exist.

Engineering owns APIs, storage, UI shell, Back/Next.  
**You own:** item wording, which instrument, what we may claim, what we must not claim.

---

## 2. What Week 3 already locked (do not casually undo)

From the accepted Week 3 report:

| Lock | Value |
|---|---|
| Trait instrument | **IPIP-BFM-25** (public domain) |
| Audience | Adult / general (not high school, not teen norms) |
| Presentation | One item at a time, **5-point Likert**, situational stem + left/right anchors, **Back / Next** |
| Scoring | Domain **means 1–5** only; coarse bands lower / typical / higher; **no population percentiles** |
| Copy | Personality snapshot for a Double — **not** diagnosis, therapy, or “scientifically proven you” |
| Chat vs scores | Interview / chat fills life chapter (`learned` / `currently` / `lifestyle` / goals). Chat must **not** silently rewrite Big Five means / `innate` |
| Village 25-item | Shipped on **double-front**. Keep it there. Completing it does **not** count as this portal’s onboard |

**Open from Week 3 (still open):** full stem-by-stem psychometric sign-off of the adult IPIP situational rewrite was **deferred**. If this inquiry is the right moment to finish that audit, say so.

---

## 3. What actually shipped on the portal (the drift)

Breakfasts wave used a **different** instrument for speed (~60 seconds):

| Piece | What shipped | Problem |
|---|---|---|
| Instrument id | `pgh-micro-v1` | Homemade 10-item OCEAN (2 items per domain). **Not** IPIP-BFM-25. Must not be described as the Rehears quiz. |
| Wording | Pittsburgh / breakfast / founders / “this quarter” / Downtown | Cohort-flavored. Founder: feels like it was written for him. |
| Chat | 4 beats: company in Pittsburgh, partner style, tough negotiation, morning before 10 / Downtown coffee | Same cohort flavor. Spec allowed “Downtown habit OK”; that is **not** a general Doubland door. |
| Time budget | ~6 minutes total (sliders + chat) | Still the product constraint unless you raise it with a reason. |
| Storage | `POST /api/onboard/quiz` → profile persist; chat then `done` compiles English soul; Join is later from `/account` | Keep this **loop**. You may change instrument id / item bank / beats. |

**Founder direction (2026-09-08):** keep the **short slider + short chat** *shape* unless you show that shape is scientifically unacceptable. Replace **stems and beats** with **general adult** wording grounded in the Rehears / IPIP work. Do not claim the result *is* IPIP-BFM-25 unless it actually is.

UI **Back** on the sliders is an engineering change in parallel (does not wait on this report).

---

## 4. Product intent for this inquiry

A non-operator adult (Breakfasts member **or** a later wave) can:

1. Finish a **general** snapshot that is honest about what it measures.  
2. Talk for a few minutes in **any language**; we compile an **English** soul.  
3. Own a Double they can Join into a sim from `/account`.

Breakfasts remains the **first list they may Join**. The **questions must not assume** they are a Pittsburgh founder.

**Explicit non-goals**

- Clinical diagnosis, therapy, IQ, aspects not scored by the chosen instrument  
- Teen / school banks  
- Replacing IPIP-BFM-25 on **double-front** village quiz  
- Reopening Week 3 interview as a 25-minute form  
- Inventing a new unpublished trait model (HEXACO, Enneagram, etc.) unless you argue IPIP cannot serve this door  
- Full re-norming study (same as Week 3) unless you specify a **minimal responsible** path  
- Changing Login / allowlist / Join / watch URLs  
- Pittsburgh map / Phaser look

---

## 5. Decisions we need from you

Write so engineering can implement without reinterpretation. Prefer **final wording** over theory-only.

### A. Trait snapshot (Likert)

1. **Which instrument for the portal?** Pick one and justify:
   - **A1.** Use **IPIP-BFM-25** as-is (25 sliders; longer; already locked).  
   - **A2.** Keep **10 items / ~60s**, but every stem is a **cited** public-domain or Week 3 adult IPIP marker (name the source item).  
   - **A3.** Another **published** short Big Five you name (BFI-10, etc.) — only if A1/A2 fail a **blocking** bar.  
2. If A2 or A3: **full item bank** — id, trait, prompt, left anchor, right anchor, reverse-key yes/no. Adult, **general audience**, English. No city, no “founders,” no breakfast club, no “this quarter” unless the person could be anyone.  
3. **What we may print in the UI** (one line under the quiz).  
4. **What we must never print** (extend Week 3 §D3).  
5. Scoring: confirm **means 1–5**, bands, no percentiles — or specify the exception.  
6. Relationship to village IPIP-BFM-25: same person later takes both — **same scores, conflict rule, or “portal is a coarse prior”?**

### B. Chat / interview (the 4 beats)

Week 3 recommended **5 structured interview prompts** mapping to `learned` / `currently` / `lifestyle` / goals / one vignette (`double-interview-v1`). Portal shipped **4 free-text beats** that are Breakfasts-flavored.

1. For a **~4–6 minute** chat after the sliders, which wins: adopt/shorten `double-interview-v1`, keep 4 beats with **new general wording**, or a mix?  
2. **Final beat prompts** (English interviewer first line). User may answer in any language.  
3. What each beat writes into ISS (`innate` is **not** from chat — hold Week 3).  
4. What must **not** be asked (clinical, illegal, third-party secrets, GPS, company name required).  
5. Optional **cohort overlay**: may Breakfasts add **one** extra beat (“what brought you to this breakfast”) **after** the general bank, or must all waves share one script?

### C. Honesty & consent

1. Confirm or rewrite the Meet honest line for a **general** portal (today it names Downtown / PPG Cafe — that can stay **Breakfasts-only** on Meet if you split copy).  
2. Consent checkbox: keep, tweak, or replace Week 3 language.  
3. FAQ line if someone asks “how accurate is my Double?” — reuse Week 3 §D4 or revise for a 10-item prior.

### D. Versioning

1. New instrument id? (`portal-micro-v1` vs keep `pgh-micro-v1` with new stems vs `IPIP-BFM-25`)  
2. People who already stored `pgh-micro-v1` — retake required?  
3. Engineering may ship general stems under a **new** id without waiting on village 25-item changes — confirm.

---

## 6. Constraints (engineering / product)

| Constraint | Detail |
|---|---|
| Time | Prefer ≤6 minutes sliders+chat unless you raise it |
| Loop | Login → onboard → `/account` → Join stays |
| Language | Sliders English; chat any language → English soul |
| Back | Slider Back is engineering (this week). Say if chat also needs Back (server beat index makes that harder). |
| Storage | Gateway already persists quiz then compile on `done` |
| Claims | No diagnosis; no “this quiz is IPIP” unless it is |

---

## 7. Current copy to replace (do not keep for a general door)

### 7a. `pgh-micro-v1` sliders (2 per OCEAN)

| id | trait | prompt | left | right |
|---|---|---|---|---|
| pgh-o-1 | openness | When a new Pittsburgh project appears, I want to try an unproven approach. | Stick to what works | Try the new path |
| pgh-o-2 | openness | I enjoy wide-ranging ideas in a breakfast conversation. | Keep it practical | Explore freely |
| pgh-c-1 | conscientiousness | I finish the plan I committed to this quarter before I add new work. | I switch often | I finish first |
| pgh-c-2 | conscientiousness | My calendar is a contract, not a suggestion. | Flexible | Strict |
| pgh-e-1 | extraversion | After a long day I still want one more conversation with peers. | I need quiet | I want people |
| pgh-e-2 | extraversion | In a room of founders I speak early. | I listen first | I speak first |
| pgh-a-1 | agreeableness | In a tough deal I look for a win both sides can live with. | Protect my side | Find the win-win |
| pgh-a-2 | agreeableness | When a partner is wrong I still keep the relationship warm. | Name it plainly | Keep it warm |
| pgh-n-1 | neuroticism | A sudden setback stays in my body for the rest of the day. | I recover fast | It lingers |
| pgh-n-2 | neuroticism | Before a high-stakes meeting I feel tense. | Steady | Tense |

### 7b. Chat beats (interviewer)

| id | Current prompt |
|---|---|
| beat-role | What company or project are you running in Pittsburgh, and what is your focus this quarter? |
| beat-cadence | When working with partners or clients, what is your communication style — straight to the point, structured process, or highly informal? |
| beat-conflict | Think about a tough business negotiation. What is your go-to move when someone pushes you into a corner? |
| beat-morning | What's your typical morning before 10 AM? Coffee order, favorite Downtown spot? |

---

## 8. How to structure your report

Match Week 3: short written report, labeled **Measured / Evidence-based / Peterson-informed / Agent hypothesis**. Cite predecessor sections. **Assess, don’t diagnose.**

Include:

1. Instrument choice (A1 / A2 / A3) + one-paragraph why  
2. Full slider bank **or** “use IPIP-BFM-25, here is the portal UX (25 vs 10)”  
3. Full chat beat list + ISS mapping  
4. UI strings: intro, honest line, consent, accuracy FAQ  
5. Version id + retake rule  
6. Risks (top 3) + what engineering must not claim  
7. Open research (may defer; do not block a general-stem ship if you can give v1 wording)

**Risk of this inquiry:** high (real-adult psychographics, “this is my Double”). COS: `pending_approval` before public claims.

---

## 9. What engineering will do after you accept

| If you pick | Engineering |
|---|---|
| A1 IPIP-BFM-25 on portal | Reuse village item bank + `/api/me/quiz` pattern on landing onboard; longer UX |
| A2 10 cited markers | Replace `pgh_micro_v1.json` + landing `MICRO_QUIZ_ITEMS`; new instrument id if you say so |
| New beats | Replace `CHAT_BEATS` + interviewer prompts; `prompt-verify` |
| Breakfasts overlay beat | Optional 5th beat gated by cohort, not in the general bank |

Do **not** implement copy from this inquiry until Ivan accepts your report.

---

## 10. Founder note (context, not your job to debate)

Login on doubland.ai works (2026-09-08). Snapshot **save** currently 404s because live gateway is village `railway`, not `breakfasts` APIs — separate ops. This research is so the **next** successful onboard is a **general** Double, not a Breakfasts-only personality sketch.
