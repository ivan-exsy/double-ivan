# Doubland: phased plan to open to the public and earn revenue alongside L-Talks
*2026-10-14. Draft for Ivan Pistsov (solo founder). Built from the growth & income inquiry, both expert rounds, Ivan's round-2 feedback, Wright's lens, and the CTO's solo-entry report. Every price is a proposed band, not data. Nothing has been sold. Adults 18+ only. Nothing here edits the SOT.*

**Expert tags:** [PLG], [Mon] Monetization, [Chen] Andrew Chen, [VC], [Wright] Wright lens, [Eng] Engagement and [RTV] Reality TV (both cited only through the merged answers; there are no raw reply files for them), [CTO] solo-entry report, [R1]/[R2] merged answers, [Brief] inquiry, [Ivan] locked decision.

---

## 1. One-page summary

**How we make money, in one sentence [R2]:** "Friend groups play free with their Showrunner as our partner; companies pay for a private season for their team; and anyone in a season can buy their own Double's cuts."

**Locked by Ivan (these override expert suggestions):**
- Friend groups are free. Showrunners are partners and pay nothing. At 5+ members with profiles they earn recognition and a non-cash bonus (cash only after legal review). They get free personal daily trailers and pick each day's trailer slot.
- **First paid product: Corporate Team Season.** A private sim on a team-only page, priced above $299 with added perks. The experts suggested $2,000–5,000 [R2, Chen].
- **Second paid product: Member Season Cut** at $9–15.
- **Solo entry:** solo users join the featured sim only at season boundaries (no mid-run join in Survival). A private town sleeps at zero compute until 3 real people join with profiles, and goes dormant after 14 days without quorum.

**The path, in four phases:**
| Phase | When | Main job | Revenue |
|---|---|---|---|
| 0 | This week, up to L-Talks premiere | Launch L-Talks free, set up measurement, approve the CTO plan, start legal review, draft the team page | None |
| 1 | L-Talks nights 1–15 | Public open: free sleeping friend towns, solo queue for next season, partner ladder, team page and target list ready | None shown to the L-Talks cohort (see Decision D1) |
| 2 | From night 15 to 60 days after the first charge | First Team Season sale, Season Cut from group two, kill-line check at 60 days | Team Seasons first, then Season Cuts |
| 3 | After the 60-day check passes | Overflow towns, more boxes, roughly one Team Season a month, ruleset rewards | Repeatable |

**First metric everywhere: wake rate** (door submits → town awake) [Wright]. **Second: outsider-starts-a-group** ("at least one new group came from another group's trailer") [Chen, R2, Wright].

**Biggest risks:** Team Season privacy [Wright, Mon, R2]; stacked entry rules stopping towns from waking [Wright]; compute cost (≈$0.051 per Double-day on the live model [CTO]), with older estimates much higher.

**Decisions needed (detail in §5):** spotlights during L-Talks; Team Season price band; overflow cap (6/10/15); season length; SOT "Entry model" edit; CTO go-ahead; Wright's two points (wake at 2, pick from top 3); plus four surfaced by this plan (corporate selling during the 15 nights, Team Season size vs the 15-Double roster cap, wake-rate bar, pilot terms).

---

## 2. Phases

### Phase 0: this week, before and at the L-Talks launch
**Goal:** L-Talks runs free and clean, so the fundraising read stays usable, and the groundwork for public open and revenue gets started.

**What ships**
- **Product**
  - L-Talks premiere plus 15 nights, free to watch, free to be cast, free to claim a Double. No price, discount, preorder, tip or founding offer during the 15 nights [Brief lock 1; R1; R2; Mon withdrew its $149 presale].
  - The existing "Run Doubland for Your Group" door stays as the host intake. No second form [Brief Q6].
- **Tech** (owner: CTO; Ivan approves)
  - Measurement: night-1 viewers back on nights 2, 7, 15 per real member [PLG, R1, R2]; door submits that reach 5+ completed profiles [R2]; unprompted "that's so them" and asks for more [PLG, R2]; wake rate as the first dashboard line [Wright].
  - Measure the real cost per resident per day this season (a cost input, not a test) [R1, Mon]. Verify what the CTO could not: the VPS `MAX_CONCURRENT_SIMS` value, RAM/CPU per running sim, the front-end join UI state [CTO].
  - Optional, if Ivan approves: the CTO's cheapest first step, opening self-serve join on a stopped sim (`set_sim_joinable`) so 3–5 solo users bind at the next featured boundary. **<1 dev-day, $0 LLM** [CTO §6.4].
- **Marketing:** no media plan for the Telegram group; the season's job is already defined [Brief §11].
- **Sales:** draft the Team Season page copy and the warm target list (see §3). No outreach yet.
- **Legal:** start review of Team Season guardrails (consent, no employer access to quiz data, no HR/performance use, deletion), terms of service, and the Showrunner cash-bonus question [R2, Mon r2, Chen r2].

**Owner:** Ivan (all non-tech items); CTO (tech).
**Exit metrics:** L-Talks premiere is live; tracking reports wake rate, nights 2/7/15 return, and submits-to-5-profiles; cost-per-resident-day measurement is running; the CTO plan is approved or rejected (Decision D6).
**Dependencies:** Ivan's go-ahead on the CTO plan; a legal reviewer engaged.

### Phase 1: public open (during L-Talks nights 1–15)
**Goal:** anyone 18+ can come in through a path that costs about nothing until real people show up. Grow Showrunners, not a stranger audience.

**What ships**
- **Product**
  - **Free sleeping friend town** [CTO option (b); Ivan lock]: the Showrunner starts a private town; it costs $0 while asleep; it wakes at 3 real people with profiles; it goes dormant after 14 days without quorum.
  - **Solo queue** [CTO option (c); Ivan lock]: a solo user's Double queues for the next season of the featured town and is bound while the sim is stopped. No mid-run join.
  - **Showrunner partner ladder, non-cash** [Ivan; R2 §4]: at 5+ members with profiles, the season goes live free, Founding/Executive Producer credit on every episode, the Showrunner's own daily cut, and gift Season Cuts (R2 says 2; Mon r2 says 2 gift packs). Higher rungs: extra spotlight slots and a next-season scenario pick at 10+ members or strong night-7 retention [R2, Mon r2, PLG r2]; next season free for a finale with most members still watching [R2, Chen r2]; origin credit when a member runs their own group [R2, Chen r2, PLG r2]. Wright adds a ruleset/scenario pick as the top reward. Rewards favor completed profiles and members still watching over raw invites [R2, Chen r2, Wright].
  - 18+ gating and persona content screening before any user-written persona appears in a public town or trailer [CTO §5].
- **Tech** (CTO estimates [E])
  - (b) sleeping private town: **3–5 dev-days**. Note: the CTO scoped the wake trigger at the 2nd bind; Ivan's lock is 3 people with profiles plus 14-day dormancy. The CTO should confirm the estimate still holds.
  - (c) next-season entry: **2–4 dev-days**, lowest ops.
  - Auto idle-stop and a health check before towns pass 10 [CTO §5]. No estimate given.
  - 18+ gating and persona screening: no estimate in the report.
  - Do **not** build Option 1 mid-run join (8–15 dev-days) or Option 2 per-user private town (4–7 dev-days) [CTO].
- **Marketing:** the loop is story export: episode → spotlight cut → share → an outsider asks "can I be in one?" → new Showrunner [Wright]. No paid acquisition, no ads [R1, R2 do-not-build list]. Public line: "See yourself from the outside." Never "coach" [Brief].
- **Sales:** team page built but not shown in the L-Talks group; target list finished (see §3). Whether founder conversations with companies outside the cohort can start now is Decision D1.

**Owner:** Ivan (product, Showrunner nurturing, marketing); CTO (build).
**Exit metrics**
1. **Wake rate:** door submits → town awake [Wright]. The sources set no target number (Decision D10). If it is low, relax one gate at a time [Wright].
2. **Outsider-starts-a-group:** at least one group formed from someone outside L-Talks who saw a trailer [Chen, R2, Wright].
3. Night-7 return of 25% or more of night-1 viewers, and at least one host request reaching 5 profiles. Below either, don't build [R2 kill line]. Reference bands, not results: about 60% next day, 40% after a week, 25% after a month [Brief].
**Dependencies:** CTO go-ahead (D6); entry numbers set (D3, D9); 18+ gating and screening live before public towns; terms of service reviewed.

### Phase 2: first revenue (from L-Talks night 15 to 60 days after the first charge)
**Goal:** the first paid Team Season, then Season Cuts inside running seasons.

**What ships**
- **Product**
  - **Team Season** [Ivan; R2]: a private 15–16 night season on a page only the team can open. Perks [R2, Mon r2, Chen r2, PLG r2]: company title card, a town set at their office and local spots, a choice of ruleset, every member's Season Cut included, a producer seat for the team lead, premiere and finale cuts for a watch party, a finale reel for an all-hands, kickoff and wrap calls, invoice/PO billing, "dignity mode" exits ("moves on"), deletion on request. Extra Doubles $50–100 each [Mon r2, R2].
  - **Season Cut** [Ivan: $9–15; R2]: about 5–7 personal cuts, one time, never a daily subscription. Offered only right after a member's own free spotlight cut, never in the group episode [R2 §3]. Sold from group two on, once render cost is measured [R2].
  - **Daily spotlight** [Ivan; R2 §3]: each night the Showrunner picks one member for a free personal cut; the system suggests 3; if no pick, it goes to the featured Double. Everyone gets one before anyone gets a second; members can decline; no humiliation spotlights; a voted-out member gets a private farewell cut. Cost: about 2 cuts a day, around 32 a season, roughly $11–24 per group at the render ceiling [R2].
- **Tech:** team-only page and access control (no estimate in the CTO report); a sim slot for each Team Season that never takes a friend group's town slot [R2, Chen r2]; render-cost measurement per cut; payment for Season Cuts (no stack named in the sources); invoice/PO billing for teams, with no self-serve checkout this year [R2]. Check concurrency: default cap is 3 sims per box, about 6–10 with the env raised [CTO].
- **Marketing:** post-season story export from L-Talks; Showrunner credit on episodes; the origin credit loop [R2, Wright].
- **Sales:** see §3. Founder-led or warm-intro only [R2, PLG r2]. Chen r2 says inbound only. No SSO, no custom builds, no outbound enterprise sales [R2].

**Owner:** Ivan (sales, Showrunners); CTO (team page, render, billing).
**Exit metrics (60 days after the first charge)** [R2 §8]
1. Wake rate holds or improves [Wright].
2. Outsider-starts-a-group: at least one new group came from another group's trailer [R2, Chen r2].
3. Team Season: 2 or more of the first 5–10 qualified companies pay $1,500–2,000+. Otherwise drop it. Also drop it if team work delays a friend-group launch [R2; Mon r2: 0 of the first 10 at ≥$1,500 → drop; Chen r2: <2 inbound at ≥$2,000 in 60 days].
4. Season Cut: 10–15% or more of spotlighted members buy, and render stays ≤25–30% of price. Otherwise drop it [R2, Mon r2, Chen r2].
5. Ladder: half or more of the first 5 Showrunners reach 5 profiles. Otherwise change the ladder [R2, Chen r2].
6. Team Season costs ≤ about 15% of price [R2, Chen r2].
**Dependencies:** legal sign-off on Team Season terms and consent **before the first sale** [R2]; payments/invoicing working; render cost measured; at most 2–3 Team Seasons before group two finishes [R2, Chen r2].

### Phase 3: scale (after the 60-day check passes)
**Goal:** repeatable revenue that pays for free friend towns without a round.

**What ships**
- **Product:** a ruleset as a Team Season perk and ladder reward, with no store [R2 H3]; a free solo scene ending "bring two friends" (designed, not built; no CTO estimate) [R1, R2 H4]; a Showrunner cash bonus only if legal clears it [Ivan; Brief lock 5].
- **Tech:** (a) overflow towns, auto-opening the next open town when one is full: **+1–2 dev-days** on (c) [CTO]. More boxes: about 6–10 sims per box; 67 waiting-room towns would need about 7–11 boxes (~$150–300/mo) [CTO, E]. Cost levers (token reduction, price-sort, ~35–55% off $/Double-day) are on hold [CTO]. Revisit mid-run join only if season waits prove to hurt conversion [CTO].
- **Marketing:** feature finale towns and origin Showrunners on the site or house show [R2 ladder].
- **Sales:** roughly one Team Season a month or a quarter [R2 H6].

**Owner:** Ivan; CTO.
**Exit metrics:** wake rate; outsider-starts-a-group; **funds the next group without a round:** Team Season revenue covers at least 2x the cost of all free groups running, and at least one new group came from another group's trailer [R2]. Chen r2's version: 1 Team Season a month covers 2 friend seasons plus 1 trailer-sourced group. PLG r2's version: 2+ corporate seasons, and packs cover 50% of free towns.
**Dependencies:** legal (cash bonus); box scaling; idle-stop and health checks [CTO].

**Do not build for six months [R1, R2]:** Shape B or a solo subscription; a master sim or stranger town; a scenario store; a daily film subscription; a viewer membership; a usage meter; ads; cash for Showrunners; self-serve corporate checkout; enterprise features; any HR or performance view of personality; paid acquisition.

---

## 3. Revenue path

**Order:** Team Season first, Season Cut second, friend groups free and capped by Team Season revenue [R2, Mon r2].
**Why this order:** one Team Season pays for roughly 6–40 free friend-group seasons. Season Cuts alone won't fund free groups, since that would take about 7–33 buyers per group at the high end [R2].

**First corporate sale, step by step**
1. **Target list (Phase 0–1).** Warm intros only [PLG r2], from Ivan's own network. The L-Talks leadership community is a natural source, but nobody in it gets asked during the 15 nights [Brief lock 1; R2 §6]. Qualify team leads with an events, people or offsite budget [R2: "team lead, HR, events or people budget"]. No cold outbound enterprise sales [R2 guardrails]. Chen r2 says inbound only. That conflicts with a target list, so see D1.
2. **Team page (Phase 1).** A dedicated team-only page showing the perks list, the privacy features (opt-in, private vs shared spaces, no employer access to quiz data, deletion), and "dignity mode." Privacy is shown as visible product features, not just legal text [Wright]. Contact form or founder call, no checkout [R2].
3. **Discovery calls (after night 15).** Founder calls to 3–5 team leads asking whether they'd run this for $2,500+, with no checkout [R2 §6].
4. **Pilot offer.** The first Team Season at the band Ivan picks (D2), with the full perk set and kickoff and wrap calls, billed by invoice or PO [R2, Mon r2]. The sources propose no corporate pilot discount. Any pilot terms are Ivan's call (D11).
5. **Deliver and measure.** Cost ≤ about 15% of price [R2]. Finale reel for the all-hands. Ask for a second season or a referral.
6. **Cap.** At most 2–3 Team Seasons before group two finishes; a team never takes a friend group's slot [R2, Chen r2].
7. **Kill or keep at 60 days** (Phase 2 metric 3).

**Season Cut path:** from group two on, after the member's first free spotlight, $9–15 [Ivan], render ≤25–30% of price [R2]. Group-two timing differs: PLG r2 says from night 3, R1 says after the first week.

**For the seed room [VC]:** say "Cost scales with Doubles, not viewers." Refuse to say "people will pay for their personal daily film," or any willingness-to-pay number, until a non-L-Talks group has paid.

---

## 4. Risks
| Risk | Why it matters | Mitigation (source) |
|---|---|---|
| **Team Season privacy** | If employees suspect HR can see anything, they play "safe," the emergence goes flat, and the season doesn't renew [Wright]. | Opt-in; the employer never sees quiz answers or results; no HR/performance use; deletion on request; private trailers; shown as visible features; legal review before the first sale [R2, Mon r2, Chen r2, Wright]. |
| **Stacked entry rules** | The 3-person wake, 5-profile bonus and season-boundary solo gate, stacked together, may stop most towns from waking [Wright]. | Wake rate is the first metric; relax one gate at a time if it's low [Wright]. The CTO's own wake design was 2+ [CTO]. |
| **Compute cost** | ≈$0.051 per Double-day on the live model [CTO]. Per-Double cost rises with cast size (older 15-cast runs used 0.56–1M input tokens/DD vs 0.31–0.40M at 6) [CTO]. Older envelopes are much higher: $0.23–1.39 per resident per day [R1, CTO live estimate cited there], and $2–7 per watched town-day in June [Brief]. A 30-Double Team Season costs about $110–667 [R2, Mon r2]. | Re-measure this season [R1]; keep towns asleep at $0 until quorum [CTO, Ivan]; cap free groups by Team Season revenue [R2]. |
| **Team Season size vs roster cap** | Team Seasons are scoped to 20–30 Doubles [R2], but `self_serve_max_roster` defaults to 15 [CTO]. | CTO to confirm whether the cap can be raised for teams and what it costs; or sell up to 15 (D12). |
| **Capacity** | The default is 3 concurrent sims per box; L-Talks takes one [CTO]. | Raise the env value (about 6–10 per box) and add boxes in Phase 3 [CTO]. |
| **Moderation** | User-written personas in a public town and its trailers [CTO]. | 18+ gating and screening; the season-boundary queue is the review point [CTO]. |
| **Distorting the L-Talks read** | Any price during the 15 nights teaches the cohort to wait and muddies retention [PLG, R1, R2]. | No prices in the cohort; corporate talks kept separate (D1). |
| **Solo-founder bandwidth** | Team work can delay friend launches [R2 kill line]. | No SSO or custom builds; cap 2–3 Team Seasons early [R2]. |

---

## 5. Decisions needed (recommended default in bold)
| # | Decision | Options and sources | Recommended default |
|---|---|---|---|
| D1 | Corporate selling during the L-Talks 15 nights (conflicts with Ivan's "revenue in parallel" goal) | R2 and Chen r2: team-lead calls after night 15 only. Ivan wants revenue in parallel. | **Team page live and target list built during the 15 nights; nothing shown to the L-Talks cohort; Ivan decides whether to start warm calls outside the cohort before night 15** |
| D2 | Team Season price band | $1,500–4,000 [Mon, Eng]; $2,000–6,000 [PLG, Chen, RTV]; merged $2,000–5,000 [R2]. Ivan: above $299. | **$2,000–5,000 [R2, Chen r2]** |
| D3 | Overflow cap | 6, 10 or 15 [CTO]; the CTO recommends 10–15 | **10**: inside the CTO's 10–15, and per-Double cost rises with cast size [CTO] |
| D4 | Season length | Premiere + 15 nights [Brief, Chen, PLG]; 16 nights [Mon r2]; a 15-cast Survival lasts about 14 days [CTO] | **Premiere + 15 nights, same as L-Talks** |
| D5 | Spotlights during L-Talks | Yes, no price shown [PLG, Eng]; No, trailers aren't a product yet and it adds cost [Mon, RTV] | **Yes, small and with no price, only if Ivan OKs the render cost; Ivan as Showrunner picks** |
| D6 | CTO go-ahead | (c) 2–4 d + (b) 3–5 d, later (a) +1–2 d; no Option 1 [CTO] | **Approve (c)+(b) now; (a) in Phase 3; start with the <1-day first step** |
| D7 | SOT "Entry model" edit (needs Ivan's approval; not edited) | CTO text says "sleep until 2+ humans"; Ivan's lock says 3 with profiles plus 14-day dormancy | **Approve, with Ivan's numbers (3 with profiles, 14-day dormancy), season-boundary solo entry, no mid-run join in Survival** |
| D8 | Wright: wake at 2 people | Ivan: 3 with profiles; CTO and Wright: 2 | **Keep 3; drop to 2 first if wake rate is low [Wright: relax one gate at a time]** |
| D9 | Wright: Showrunner picks from the system's top 3 | Ivan: the Showrunner picks each day's slot; R2 has the system suggest a top 3 | **The system suggests 3; the Showrunner may pick anyone (keeps Ivan's lock); fairness rules from R2 apply** |
| D10 | Wake-rate bar | No number in any source | **Ivan sets it before Phase 1 exits** |
| D11 | Corporate pilot terms | No expert proposed a corporate discount | **Full price at the D2 band, with full perks; no discount** |
| D12 | Team Season size | 20–30 Doubles [R2, Mon r2] vs a roster cap of 15 [CTO] | **Up to 15 until the CTO confirms a higher cap and its cost** |
| D13 | Showrunner bonus contents (non-cash) | Badge and group reel [Chen r2]; credit, own cut, 2 gift cuts [R2, Mon r2] | **The R2 ladder as written; cash only after legal** |

---

## 6. Source map
| Source | Path | Used for |
|---|---|---|
| Brief | /workspace/inquiries/20261014_growth_income.md | Product, L-Talks facts, locks, cost envelope, retention bands |
| PLG r1 / r2 | /workspace/inquiries/income_replies/plg.md, plg_r2.md | Season measurements, warm-intro corporate sales, Season Cut timing, ladder tiers, story loop |
| Monetization r1 / r2 | .../monetization.md, monetization_r2.md | Team Season perks and guardrails, $1,500–4,000 band, extra-Double price, 30-Double cost, no spotlights in L-Talks, kill lines |
| Andrew Chen r1 / r2 | .../chen.md, chen_r2.md | $2,000–5,000 band, cost ≤15%, inbound-only view, cap 2–3 teams, ladder, fund line |
| VC | .../vc.md | Seed-room sentence and the claim to refuse |
| Ivan feedback r2 | .../ivan_feedback_round2.md | Showrunner as partner, corporate price above $299, free daily trailers, slot pick |
| Wright lens | .../wright.md | Wake rate as the first metric, story-export loop, top-3 pick, wake at 2, privacy risk, stacked gates |
| Merged answer r1 (partly superseded) | /workspace/inquiries/20261014_growth_income_answer.md | Cost per resident-day, do-not-build list, solo scene; the Showrunner-pays pass is superseded |
| Merged answer r2 (current) | /workspace/inquiries/20261014_growth_income_answer_r2.md | Stack, perks, guardrails, spotlight rules, ladder, kill lines, open decisions; Engagement and Reality TV positions |
| CTO solo-entry report | /workspace/solo-entry-feasibility/report.md | Options (a)/(b)/(c), dev-day estimates, $0.051/DD, roster cap 15, concurrency 3, SOT proposal |
