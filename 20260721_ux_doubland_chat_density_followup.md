# UX Follow-up: Dense café chat placement (post Conversation Anchor spike)

**Audience:** External UX / interaction design partners  
**Product:** Doubland (Double social simulation viewer)  
**Owner:** Product / Eng (Ivan)  
**Date:** 2026-07-21  
**Status:** Follow-up after Phase-1 spike — need layout/density direction  
**Related:** Original brief `20260721_ux_doubland_chat_clarity_1pager.md`; expert response “Shared Conversation Anchor”; FE spike now in `double-front`

---

## 1. What we shipped (spike)

We implemented the expert **Shared Conversation Anchor** concept for two-person chats:

- One bubble per conversation, anchored near the **participant midpoint**
- Persistent pair label: `A ↔ B`
- Current speaker still shown in the yellow name tab
- Two short connectors from bubble to both participants (speaker thicker/more opaque)
- Both participants’ normal status stickers hidden while the conversation is active
- Click-to-skip on the utterance body unchanged
- Default playback still **6×**; bubble dwell still sub-linear

**What improved:** In a clean two-person scene, “who with whom” is clearer than before.

**What did not improve enough:** In a **busy café** with several simultaneous chats, the screen becomes a wall of overlapping cream bubbles. Sprites and world action disappear under chat chrome. Pair labels help attribution, but **spatial readability still fails**.

---

## 2. Evidence (café cluster)

Attached / reference screenshot: multiple Doubles chatting in the café.

Observed failure modes:

1. **Bubble–bubble occlusion** — expanded anchors stack on top of each other; lower conversations become unreadable.
2. **Sprite occlusion** — large opaque bubbles cover faces/bodies in the cluster (violates “see the Doubles” job).
3. **Midpoint trap** — placing at the pair midpoint puts UI *into* the densest part of the room instead of around it.
4. **Connector loss** — thin lines into a crowd don’t resolve “which sprite” quickly enough at 6×.
5. **Redundant chrome** — pair label + speaker tab + connectors + bystander stickers (e.g. Irene) compete for the same airspace.
6. **Ambiguous multi-tag stacking** — when bubbles overlap, speaker tabs from different conversations can sit on the same visual stack and look like one bubble has two speakers.

Success criteria from the original brief are **not met** for the café case, even though pair identity encoding is present.

---

## 3. Product constraints (unchanged)

1. **In-world bubbles remain primary** — not “move chat to a sidebar.” Secondary transcript/history may exist; it is not the main experience.
2. **Default playback stays 6×** (options 1× / 6× / 15×). Reading must survive acceleration without forcing pause.
3. **Dense co-location is real** — cafés, meetings, survival huddles. Design must handle **2–4+ simultaneous pairs** in one viewport.
4. **No hover-pause** (intentionally removed; it stalled the world).
5. **Click-to-skip one line** stays unless you explicitly replace the control model.
6. **No auto-camera zoom/pan as the primary fix** (conflicts with viewer control and recording/Director camera).
7. **Do not change LLM / chat generation** — visualization + layout only.
8. **Backend already provides:** speaker, `chatting_with`, `conversation_id`, `participants`, optional `observation_location`. Prefer using that; don’t invent new narrative UI that fights the sim clock.
9. **Normative FE behavior still includes** max ~5 active conversations, one bubble per speaker, 3-zone walk-apart (APART drops remaining queue), scrub clears bubbles.

---

## 4. Engineering reality (so proposals stay spikeable)

### What FE can do in ~1 sprint after you choose a direction

- Place anchors in **candidate slots around the cluster** (not only midpoint), with hysteresis so they don’t jump every frame
- Cap simultaneous **expanded** bubbles (e.g. 1–2) and collapse the rest to **chips** (`A ↔ B · speaking` / unread)
- Shrink bubble typography / max width at zoomed-out views
- Dim or suppress **bystander** stickers in the active cluster (not only chatting participants)
- Stronger connector endpoints (dot on sprite) + shorter max connector length
- Focus interaction: click pair label → keep that conversation expanded; others chip

### What is harder / multi-sprint

- True shared occupancy service (sprites + stickers + bubbles + chips + viewport edges as one layout solver)
- Separation-grace “keep reading after walk-apart” (conflicts with current APART SOT)
- Polished group (3+) anchors and group-split animation
- Production conversation color/token system

### Known tech debt from the spike

- Collision is still mostly **horizontal push-apart** (±120px) between bubble AABBs — not “outside the people”
- Bubbles and stickers still do not share a full protected-zone solver
- Bubbles scale with camera zoom (shrink when zoomed out) — dense rooms get worse at wide framing

---

## 5. Jobs we still need solved (viewer)

In a café with **3 simultaneous pairs** at **6×**, a first-time viewer should:

1. See **most Doubles’ bodies** (not a wall of text)
2. Read at least **one** conversation without opening a transcript
3. Instantly know **who is talking to whom** for that focused conversation
4. Know that **other chats exist** without needing them all fully expanded
5. Switch focus to another pair in one click, without pausing the world

---

## 6. Questions for UX (please answer with frames if possible)

1. **Placement:** Where should expanded anchors live relative to a dense sprite cluster — ring outside the cluster, nearest free edge, fan above room, or something else?
2. **How many expanded at once?** Hard max of 1 vs 2 vs “as many as fit”? What happens to the rest (chips along edge, stacked rail, fade)?
3. **Focus model:** Is “click pair label / chip to focus” the right primary control, with click-body still = skip line?
4. **Size:** Should expanded bubbles get **smaller** in dense/zoomed-out scenes (trade completeness of text vs seeing sprites)?
5. **Identity hierarchy:** When space is tight, what do we keep first — pair label, speaker name, connectors, utterance text?
6. **Bystanders:** Dim, collapse emoji-only, or relocate stickers for non-chatting Doubles in the same room?
7. **Café acceptance frames:** Please annotate the attached café screenshot (or equivalent) showing your recommended expanded vs chipped layout for 3 pairs.

---

## 7. Ask of the UX team

Deliver **one recommended dense-scene layout model** (with 1–2 alternates if useful), optimized for the café case, that we can spike in FE in about **one sprint**:

- Annotated café still(s): expanded positions + chip positions
- Rules for overflow / priority when space runs out
- Interaction notes (focus, minimize, skip) that respect constraints above
- Rough engineering cost: light layout tweak vs new ConversationLayoutManager

**Out of scope for this follow-up:** redesigning transcript UI, user↔Double chat, LLM quality, auto-zoom as the main solution.

---

## 8. Attachment checklist for Ivan when sending

- [ ] Café screenshot (current spike — messy multi-bubble)
- [ ] Optional: clean two-person screenshot showing spike success
- [ ] This brief
- [ ] Original brief + prior Shared Conversation Anchor PDF (for continuity)

---

*Engineering contact points: `ChatBubbleHTML`, `SpeechController`, `MultiSpeechController`, `StatusSticker`, `playbackTiming`; SOT `sot_chats.md` §5.*
