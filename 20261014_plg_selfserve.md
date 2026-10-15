# PLG: self-serve conversion for Team Season and Season Cut
*2026-10-14. COS-synthesis, needs review. Prices are bands from the plan, not data. Adults 18+ only. Nothing is shown to the L-Talks cohort during nights 1–15.*

## Team Season: sells itself
1. **Public team page with the price on it.** Put the band, the perks, a sample finale reel and the privacy features on the page. Size tiers go up to 15 Doubles (roster cap). Replace "contact us" with "Start your team season."
2. **Checkout = sleeping town.** The team lead pays by card. Invoice is also self-serve, by entering a PO number. That creates a private town that sleeps at $0 and sends a team invite link. Capture the charge when the town wakes at 5 profiles. If it hasn't woken in 14 days, refund automatically. The buyer risks nothing until the team shows up, which replaces the discovery call.
3. **Fork in the Showrunner door.** Ask "Friends or work team?" Work goes to the team checkout. Friends go to the free town. One door, no second form.
4. **Entry points from shared content.** Every public trailer and share page gets a quiet footer line: "Doubland for teams." A friend group's finale card offers "Run a season for your team." Members are the ones who carry it to work.
5. **Rebuy at the finale.** The team lead gets "Book next season" plus their finale reel. Rebooking is the cheapest second sale.

## Season Cut: sells itself
6. **One tap right after the free spotlight**, priced in the product: "Get your next 5 days, $9–15." Use a wallet pay button. No countdown, and nothing in the group episode.
7. **Gift loop.** The Showrunner's gift cuts, and any member, can gift a Cut to someone in the cast. A received gift turns into a purchase the next time.
8. **No social pressure.** Never show who bought.

## Build now
- **Phase 0:** event tracking with a share_id, the spotlight delivered/watched/shared events, and a Stripe account plus terms drafts with Legal.
- **Phase 1:** the public team page and checkout, built on the sleeping-town build (b) with a paid flag and capture-on-wake. Also the door fork, the trailer and finale footers, and a Cut purchase screen built but kept dark until group two.

## Conflicts with the plan's defaults
- The plan says no self-serve corporate checkout this year, a team page with a contact form only, and founder calls. This proposal reverses all three, per Ivan.
- D1 moots the warm-call question: the page is public, but it's never pushed to the L-Talks cohort.
- Legal sign-off before the first charge still holds. Capture-on-wake doesn't change that.
- Team size is capped at 15 until the CTO raises the roster cap (D12).
- Season Cut timing: group two, as the plan says. Optionally, test it on the L-Talks cohort only after night 15.
- Invoice and PO billing become self-serve. There is no SSO and no custom build.

## Kill check
At 60 days: at least 2 self-serve team checkouts reaching wake, and at least 10% of spotlighted members buying a Cut. Otherwise, add founder calls back for teams.
