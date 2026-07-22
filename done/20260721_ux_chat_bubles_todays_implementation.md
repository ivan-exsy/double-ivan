# UX Brief: Doubland in-world chat clarity

**Audience:** External UX / interaction design partners  
**Product:** Doubland (Double social simulation viewer)  
**Owner:** Product / Eng (Ivan)  
**Date:** 2026-07-21  
**Status:** Consultation request — design direction, not implementation yet  
**Related SOT:** `sot/sot_chats.md` §5 (bubble runtime constraints)

---

## 1. Problem (one sentence)

When two or more Doubles sit near each other and talk, **name tags and chat bubbles stack on top of each other**, so viewers cannot reliably tell **who is speaking, who is listening, and which reply belongs to which conversation**.

---

## 2. Product context

Doubland is a top-down sprite world. Viewers watch AI agents (“Doubles”) live their day. Social moments are the emotional payoff — but only if the viewer can follow them without friction.

**How chat is shown today**

| Layer | What the viewer sees |
|--------|----------------------|
| Status sticker | First name + activity emoji ~40px above each sprite |
| Chat bubble | Cream speech bubble with a **speaker-name tab**, text body, and a tail aimed at the speaker |
| Interaction model | Click a bubble → skip **one** line (fast-forward reading). No hover-pause. |
| Pacing | Default playback is **6×** sim time; bubble dwell is intentionally slower (~readable at ~1× feel) so people can read while sprites move fast |

**What already works well**

- Speaker identity on the bubble (name tab + tail).
- Sub-linear bubble pacing so reading survives acceleration.
- Click-to-skip for impatient viewers.
- Horizontal “push apart” when two bubbles overlap (capped ~120px).
- Speaker’s own name sticker hides while their bubble is up.
- Cap of 5 concurrent conversations; one active bubble per speaker.

**Where it breaks**

- Nearby pairs: bubbles + remaining stickers (partners, bystanders) collide in the same screen region.
- Listener is only implied by layout bias (“bubble sits on the side away from partner”) — **not labeled**.
- Multiple conversations in one cluster: no visual “pair bond” (who is talking *with whom*).
- Status stickers have depth stacking, not shared XY layout with bubbles — two systems, no joint composition.
- At high speed, if agents walk apart while a slow bubble is still reading, remaining lines can be truncated (transcript still exists elsewhere; in-world continuity suffers).

---

## 3. Design constraints (non-negotiable for v1 solutions)

1. **In-world, not a sidebar transcript as the primary experience.** Bubbles over sprites are the product language. A history panel may exist as secondary, not a replacement.
2. **Playback acceleration stays.** Default ~6× (options 1× / 6× / 15×). Reading must remain viable without forcing users to drop to 1× for every chat.
3. **Tiles / dense scenes.** Many agents can co-locate (cafés, meetings, survival huddles). Solutions must degrade gracefully with **2-person chats and multi-pair clusters**.
4. **Data we already have:** speaker name, partner (`chatting_with`), optional `conversation_id` / participants / observation location. We can surface “A ↔ B”; we should not invent new narrative UI that fights the sim clock.
5. **Keep click-to-skip** unless research shows a better primary control (e.g. skip-all, temporary pause-on-focus). Hover-pause was deliberately removed (it stalled the world).

---

## 4. Jobs to be done (viewer)

1. Instantly answer: **Who is talking right now?**
2. Instantly answer: **Who are they talking to?**
3. Follow a short exchange (greeting or ~6–8 turns) **without scrubbing or opening a card**.
4. Optionally skip ahead when they already understand the beat.
5. Still understand the scene when **two pairs chat in the same room**.

---

## 5. Questions we want UX to answer

1. **Pair association:** Connector lines, shared bubble frames, color tokens per conversation, midpoint “conversation focal,” or something else — what reads at a glance in a dense tile map?
2. **Status vs chat hierarchy:** While chatting, should partner/bystander stickers dim, collapse, or relocate? Should status and bubble share one layout engine?
3. **Listener labeling:** Explicit “→ Bob”, dual avatars on the bubble, or pure spatial language?
4. **Cluster overflow:** When push-apart isn’t enough, do we collapse to a conversation chip, camera nudge, or sequential focus?
5. **Speed vs completeness:** At 6×/15×, prefer longer dwell (risk truncation if people move), condensed paraphrases, freeze-while-reading, or auto-zoom on active chat?
6. **Control model:** Keep per-line click-skip, add skip-conversation, or add “focus this chat” (dim others)?

---

## 6. Success criteria (for proposed directions)

A proposal is strong if a first-time viewer, at **default 6×**, can:

- [ ] Name speaker and listener for a seated 2-person chat in **&lt; 2 seconds**
- [ ] Track a 4–6 turn exchange without opening persona cards
- [ ] Distinguish **two simultaneous pairs** in the same viewport without mis-attributing lines
- [ ] Still use click (or proposed control) to skim when desired
- [ ] Avoid covering critical sprite body language for more than a moment

Out of scope for this brief: user↔Double “Chat with Double” (separate Talk tab UX); backend chat triggering / LLM quality.

---

## 7. Ask of the UX team

Deliver **2–3 directional concepts** (lo-fi frames or annotated stills from a café / meeting cluster), each with:

- How speaker + listener + pair are encoded  
- Behavior under 2-pair overlap  
- Behavior at 6× playback  
- Rough engineering cost (light FE layout vs new UI system)  
- Recommendation + what to prototype first  

Target: a direction we can spike in frontend within one sprint after selection.

---

*Engineering reference (current impl): Phaser DOM bubbles (`ChatBubbleHTML` + `MultiSpeechController`), Phaser name stickers (`StatusSticker`), sub-linear dwell (`playbackTiming`), normative contract `sot_chats.md` §5.*
