# Soak observation handoff — `20260613-1` (2026-06-15)

**TL;DR:** The CDN/transport layer your soak validates held up the whole run. But the
backend has been throwing a recurring **timezone error** since ~the survival day‑1→day‑2
rollover (~03:00 UTC Jun 15) that breaks agent proximity observations and stalled the
Survival game — so agent *behaviour/content* from that point is degraded. Movement and
step generation themselves kept going. **Your call:** if Step 5.3 closure rests on
transport metrics plus at least the first clean day, you likely have enough; if you need
representative multi‑day content, we'd run a fresh sim after we fix the bug.

## What worked (transport / CDN plane — your acceptance surface)
- Steps kept generating and publishing throughout.
- CDN‑served bundles + manifest + sprite‑manifest; **0 realtime sockets, 0 gateway
  step/status polling** (your `cdn-smoke` result holds).
- Reveal‑edge / Jump‑to‑Live / clamp ±1 re‑check passed (Step 3 gap closed).
- Day‑1 highlights published and FE‑served from the CDN at day close.

→ Nothing we found implicates the CDN viewer path. The transport soak data looks valid.

## What we found (backend caveat — affects content, not transport)
- From ~03:00 UTC Jun 15, the engine repeatedly hits
  `TypeError: can't subtract offset-naive and offset-aware datetimes` in the
  **proximity‑observation / conversation‑trigger path**.
- Effect: agents move but stop perceiving each other reliably → conversations get
  suppressed/erratic, and the Survival game stalled (frozen at day‑1 night; one player
  already eliminated; it never advanced).
- This is a **timezone bug** tied to owner‑timezone anchoring — **not** an env/mode
  misconfiguration. Survival was correctly enabled (it re‑initialised cleanly on each
  engine relaunch); the observation layer it depends on is what's breaking.
- Heads‑up: because it's triggered by owner‑timezone‑aware clocks, it likely affects
  **any owner‑tz live sim**, not just this one. We're treating the fix as priority.

## Your decision
- **Close on the current sim** — appropriate if Step 5.3 acceptance is the transport/CDN
  metrics above and you're satisfied with the clean day‑1 window (incl. day‑1 highlights).
  The degradation is backend content, not the viewer path.
- **Run a fresh sim** — preferable if you need representative multi‑day *content*
  (realistic conversations, survival events, richer highlights) across the soak window.
  Day‑2+ won't be representative. This sim's Survival season is also damaged independently
  (eliminated player, wrong total‑day count), so a fresh fork is cleaner on both counts.

Either way we'll fix the timezone bug; if you want a fresh sim we'll fork once the fix
lands. Let us know which way you're leaning and whether you need anything else captured
before we touch `20260613-1`.
