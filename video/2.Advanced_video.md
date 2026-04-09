

## Table of Contents

### Production plan: Daily Snapshot
- [1) Data you must log during the day](#1-data-you-must-log-during-the-day)
- [2) Threads & arcs (multi-day processes)](#2-threads--arcs-multi-day-processes)
- [3) Event scoring (for trailer selection)](#3-event-scoring-for-trailer-selection)
- [4) Daily selection algorithm (high level)](#4-daily-selection-algorithm-high-level)
- [5) Edit blueprint (music, structure, timing)](#5-edit-blueprint-music-structure-timing)
- [6) Shot-picking rules (automatable)](#6-shot-picking-rules-automatable)
- [7) Pseudocode (selection → timeline)](#7-pseudocode-selection-timeline)
- [8) How to compute key scores (practical)](#8-how-to-compute-key-scores-practical)
- [9) Multi-day storytelling (thread continuity)](#9-multi-day-storytelling-thread-continuity)
- [10) Personalization & routing](#10-personalization--routing)
- [11) Safety & tone guardrails](#11-safety--tone-guardrails)
- [12) Delivery assets](#12-delivery-assets)
- [13) KPIs & optimization loop](#13-kpis--optimization-loop)
- [14) Minimal technical stack](#14-minimal-technical-stack)
- [15) Producer “auto-cut” spec (what the robot editor actually creates)](#15-producer-auto-cut-spec-what-the-robot-editor-actually-creates)

### General concept
- [Objectives (always)](#objectives-always)
- [The pro workflow (end-to-end)](#the-pro-workflow-end-to-end)
- [90-second beat sheet (timecoded)](#90-second-beat-sheet-timecoded)
- [Shot selection rules](#shot-selection-rules)
- [Rhythm & cutting](#rhythm--cutting)
- [Music & sound design playbook](#music--sound-design-playbook)
- [Cards, copy, and VO (clarity without spoilers)](#cards-copy-and-vo-clarity-without-spoilers)
- [Structure templates (use whichever fits the film)](#structure-templates-use-whichever-fits-the-film)
- [Ethics & legal (don’t get burned)](#ethics--legal-dont-get-burned)
- [Common mistakes (avoid)](#common-mistakes-avoid)
- [Practical edit checklist](#practical-edit-checklist)
- [Mini playbook by genre](#mini-playbook-by-genre)
- [If you’re doing this yourself (fast path)](#if-youre-doing-this-yourself-fast-path)

## *Production plan: Daily Snapshot*

*Cross check with available info in sim folder to take advantage of the existing data*

### **1) Data you must log during the day**

For every interaction and notable solo action:

* `event_id, sim_day, t_start/t_end, location_id`
* `actors[]` (ids), `audience[]` (co-present)
* `type` (dialogue, DM, plan, conflict, gift, collab, breakup, discovery, win/loss, arrival/departure, secret, rumor, party, crisis, etc.)
* Text: transcript, summary, intents (extracted), topics
* Scores (compute live or batch):

  * `salience` (tf-idf/topic centrality vs day)
  * `sentiment` (−1..+1), `arousal` (0..1), `toxicity` (0..1)
  * `novelty` (distance from actor’s 7-day behavior baseline)
  * `impact` (immediate changes in goals/relationships/resources)
  * `conflict` (stance polarity between actors)
  * `virality_pred` (simple model: arousal×novelty×network_exposure)
  * `continuity_refs` (thread ids this event advances)
* Media handles: `cam_ids`, best angles, closeups, reaction shots, wild SFX, subtitles.
* Safety flags (NSFW, doxx, bullying, etc.)

### **2) Threads & arcs (multi-day processes)**

Maintain two layers:

* **Thread** (2–5 day span): e.g., “Study group forms for math contest,” “Roommate tension over rent.”
* **Season Arc** (10–30 day): e.g., “Startup launch,” “Band rivalry.”

Each event can tag `thread_id[]`. Nightly, update:

* `progress_delta` (how much this event moved the thread forward)
* `heat` (EMA of engagement on that thread)
* `who’s involved` (set of actors)

### **3) Event scoring (for trailer selection)**

Per event, compute a composite **TrailerScore**:

```
TrailerScore = 
  w1*salience_norm +
  w2*|sentiment| +
  w3*arousal +
  w4*novelty +
  w5*impact +
  w6*conflict +
  w7*virality_pred +
  w8*progress_delta +
  w9*reaction_quality +
  w10*coverage_gap_bonus
```

* `reaction_quality`: availability of clean reactions/closeups.
* `coverage_gap_bonus`: boost for under-represented major actors/threads to avoid a monoculture cut.
* Tune weights by optimizing for click-through to full episodes and watch-time.

**ThreadScore** (for longer processes):

```
ThreadScore_today = α*sum(TopK events’ TrailerScore) 
                  + β*heat 
                  + γ*arc_priority
```

### **4) Daily selection algorithm (high level)**

Goal: 90s cut with 3–5 micro-stories + connective tissue.

**Constraints**

* 1 Hook (≤5s)
* 2–3 Top Threads (each gets 15–20s mini-arc)
* 1–2 “Spice” moments (5–8s each: humor/wow/wholesome)
* 1 Stop-down + Title + Button (10–12s total)
* ≤6 caption cards (2–5 words each)
* ≥4 reaction shots
* No spoilers of thread resolution

**Steps**

1. **Rank events** by TrailerScore.
2. **Cluster** top ~60 events into threads by `thread_id` or semantic clustering.
3. **Pick** top 2–3 threads by ThreadScore with diversity constraint (distinct actors/tones).
4. **Within each chosen thread**, assemble a 3-beat mini-arc:

   * Beat A (setup): want/problem (clip with clear premise line or visual)
   * Beat B (complication): reversal/escalation
   * Beat C (tease): unresolved moment or question
5. **Add 1–2 spice moments** (off-thread) with high arousal/novelty that don’t spoil resolutions.
6. **Ensure coverage**: at least 6–10 unique faces across the cut unless a single story dominated the day (>70% ThreadScore).
7. **Legal/safety filter**: drop/blur anything flagged; replace with alternate angles or captions.

### **5) Edit blueprint (music, structure, timing)**

**Music structure** (pre-licensed stems):

* 0:00–0:05: Tone setter (minimal)
* 0:05–0:35: Rhythmic engine (light percussion)
* 0:35–1:15: Build → Drop (stop-down around ~0:55)
* 1:15–1:30: Finale/resolve hit → Title → Button

**Timecoded beat sheet (90s)**

* 0:00–0:05 Hook (most viral image/line of day; no logos)
* 0:05–0:15 Day premise card + quick montage (3–4 shots)
* 0:15–0:35 Thread 1 (A→B→C)
* 0:35–0:55 Thread 2 (A→B→C)
* 0:55–1:00 Stop-down (silence + line/DM screenshot/closeup)
* 1:00–1:15 Thread 3 (A→B→C) or Spice Duo
* 1:15–1:22 Title card (DAY 17 • TOWN ALPHA)
* 1:22–1:30 Button (stinger line/reaction) + CTA: “Tap to watch the full scene”

**Cards/captions (max 6)**

* World/Today’s vibe, Stakes, Tease lines (2–5 words). Example:

  * “Rumors Spread Fast”
  * “A Deal… With a Catch”
  * “Who Do You Trust?”

### **6) Shot-picking rules (automatable)**

* Prefer **cause→effect** pairs (setup shot → immediate reaction).
* Faces early, spectacle later.
* Pull **clean reactions** (surprise, cringe, laugh, glare).
* Use **alt angles/crops** to avoid revealing resolutions.
* Auto-subtitle punchlines and key lines (<=7 words on screen).
* Insert **map/location bumpers** (0.5–0.8s) for spatial clarity if scenes jump.

### **7) Pseudocode (selection → timeline)**

```python
def daily_snapshot(sim_day):
    events = load_events(sim_day)
    events = safety_filter(events)
    for e in events:
        e.trailer_score = score_event(e)
    top_events = nlargest(60, events, key=lambda x: x.trailer_score)

    clusters = cluster_by_thread_or_semantics(top_events)
    threads = [
        {
          "id": cid,
          "events": sorted(evts, key=lambda e: e.trailer_score, reverse=True),
          "score": thread_score(evts)
        } 
        for cid, evts in clusters.items()
    ]
    threads = diversify_and_pick(threads, k=3)

    # build mini-arcs
    segments = []
    for th in threads:
        A = pick_setup(th.events)       # clear want/problem
        B = pick_complication(th.events, exclude=[A])
        C = pick_tease(th.events, exclude=[A,B], no_spoiler=True)
        segments += [A, B, C]

    spices = pick_spice_moments(events, exclude=set(segments), k=2)

    # assemble timeline
    timeline = []
    timeline.append(pick_hook(top_events))
    timeline += add_premise_burst(events)
    timeline += interleave_by_music([segments[0:3], segments[3:6], segments[6:9]], spices)

    timeline = insert_stopdown(timeline)
    timeline += [title_card(sim_day), button_stinger(events)]

    return conform_to_duration(timeline, target_sec=90, keep_priority="score")
```

### **8) How to compute key scores (practical)**

* **Salience:** Max(tf-idf(event_text), topic centrality in daily LDA), normalized 0–1.
* **Novelty:** 1 − cosine similarity to the actor’s last 7-day embedding centroid (dialog+actions).
* **Impact:** Weighted sum of deltas: relationship edge weights, goal progress %, resource change, schedule deviation.
* **Conflict:** Jensen-Shannon distance between actors’ intent distributions in the scene + sentiment polarity gap.
* **Progress delta:** Thread state machine step advanced (0..1).
* **Reaction quality:** presence of closeup cams, clean audio, face-affect classifier confidence.

### **9) Multi-day storytelling (thread continuity)**

* Maintain a **“Previously on” state** per thread with 1-line memory (≤80 chars).
* If a thread featured yesterday and progresses today, auto-add a **single 2-s card**: “Yesterday: X. Today: Y?”
* Never resolve a thread inside the daily snapshot; show the **moment before** the resolution and CTA to the full episode.

### **10) Personalization & routing**

* Build a **Character Affinity Vector** per viewer (watch, hover, replay, follows, comments).
* Reorder the 3 mini-arcs to put the viewer’s top-affinity character first; keep the same global set to preserve community discourse.
* Dynamic CTA links map each tease to the **exact timestamp** in the full episode.

### **11) Safety & tone guardrails**

* Filter/blur: personal identifiers, harassment, NSFW, minors’ sensitive content.
* Down-rank scenes where `toxicity>0.6` unless **consensual drama** tag and policy allows.
* Provide “Skip this storyline” control in feed personalization.

### **12) Delivery assets**

* **Horizontal 16:9** master; auto-generate 9:16 and 1:1 crops with smart reframe on faces.
* **Thumbnails (choose 1 of 5):**

  * Score = face_salience × arousal × novelty × text_legibility
  * Use big face + micro-text (≤3 words), high-contrast, no clutter.

### **13) KPIs & optimization loop**

Primary: **Episode click-through rate (CTR) from snapshot**, **Snapshot VTR (0→90s)**, **Thread follow-rate**, **Daily return rate**.
Secondary: **Unique faces seen**, **Thread diversity per day**, **Complaint rate**.

**A/B ideas**

* Hook style (line vs image), stop-down timing, number of cards (2 vs 5), 2 vs 3 threads, music intensity, personalization on/off, CTA copy.

### **14) Minimal technical stack**

* **Ingest:** Kafka topics per event; transcripts via ASR; embeddings with small text model.
* **Store:** Postgres (events/threads), S3 (media), Redis (today’s scores).
* **Compute:** Nightly batch (Spark/SQL) + on-demand scorer; FFmpeg for auto-edits; optional Premiere/Resolve XML export for human polish.
* **Serving:** CDN for videos; deep links with `?t=xx` to episode timestamps.

# 15) **Producer “auto-cut” spec (what the robot editor actually creates)**

* Max 130 shots; average shot length shrinks across timeline.
* 1–2 match cuts (action/shape) auto-detected by optical flow/SSIM.
* Submix: DX ducking over MX by 6–9 dB; 2–3 custom hits + 1 recurring motif (tick/heartbeat/lullaby).
* Captions burned-in for punchlines and whispered lines only.

---

## **General concept**
https://chatgpt.com/c/68dbfb70-01dc-8328-8f61-9346f2b8cc24

Below is how pro trailer houses turn a 2-hour feature into a 90-second “must-watch.”

### *Objectives (always)*

1. Hook fast (first 3–5s).
2. Convey premise + stakes without spoilers.
3. Build escalating emotion → leave with a *gap* (open loop) + a memorable button.

### *The pro workflow (end-to-end)*

1. **Brief + angle.** Two sentences: *Who wants what? What blocks them? Why now?* Pick an angle (romance, mystery, spectacle, heart) that matches target audience.
2. **Pull selects.** AE watches the whole film fast, tagging: hero lines, turns, reveals (flag as *forbidden*), set-pieces, reaction shots, silent emotive moments, clean SFX, alt takes, laughs. Build stringouts per bucket.
3. **Tagline + logline.** Draft 5–10 punchy options for cards/VO before editing. Copy drives cut.
4. **Music hunt.** Find 3 tracks: *Intro (tone)* → *Build (rhythmic engine)* → *Finale (drop + resolve)*. Pull stems (drums, pads, vocals).
5. **Skeleton edit.** Place music structure first. Rough in: Hook → Setup → Escalation → Pivot → Montage → Stop-down → Title → Button.
6. **Micro-tension pass.** Ensure a new question, twist, or sensory jolt **every 3–5 seconds**.
7. **Sound design.** Risers, hits, bass drops, whooshes, breaths, clock ticks, *BRAAAM* only if earned. Create 2–3 clean “silence” moments.
8. **Card/VO pass.** Write minimal cards (3–6 total) and/or VO to clarify premise and compress exposition.
9. **Finish.** Color pop, grit or halation for genre, tasteful grain; tasteful speed ramps; legal/rating cards; title treatment; date.
10. **Notes + alt versions.** 5–10% changes per note round. Cut A/B variants (alt hook, alt button, alt music).

### 90-second beat sheet (timecoded)

* **0:00–0:05 – Hook.** One irresistible image or line. No logos yet. (e.g., impossible visual, chilling whisper, joke that lands)
* **0:05–0:15 – Premise snap.** 2–3 shots + a single card or VO that states the world & problem.
* **0:15–0:30 – Character + desire.** Show protagonist, want, and the cost of failure.
* **0:30–0:50 – Escalation.** Pace lifts. Add secondary characters, first set-piece hits, hint of villain/antagonistic force.
* **0:50–1:05 – Pivot/turn.** A reveal or contradiction that reframes stakes. Quick stop-down (music drops to near-silence).
* **1:05–1:20 – Finale montage.** Rhythm tightens (6–12 frames/shot possible). Parallel action, reaction faces, quotable lines.
* **1:20–1:25 – Title card.** Big, legible.
* **1:25–1:30 – Button.** Last laugh, sting, or chill, then date/CTA.

### Shot selection rules

* Prefer **cause→effect pairs** (setup cut → payoff cut) to create story logic even out of order.
* **Faces > spectacle** early; spectacle later for payoff.
* Avoid any shot that resolves the central question. Keep third-act material abstract (cropped, no context, alternate angles).
* Pull **reaction shots**; they sell jokes, terror, awe, and glue discontinuous events.
* Keep **clean heads/tails** on selects for SFX tails and whooshes.

### Rhythm & cutting

* Cut to **music phrasing**, not just beat. Land plot beats on section changes (intro→verse→build→drop).
* Typical 90s trailer: ~70–130 shots. Average shot length shrinks over time.
* Use **J-cuts/L-cuts** for dialogue momentum.
* **Stop-downs** (250–600 ms of near-silence) amplify the next hit.

### Music & sound design playbook

* Track arc: **Tone setter → Rhythmic engine → Big finish.**
* License tracks with **stems**. Build your own escalations (add percussion, sub impacts, reversed cymbals, clock ticks).
* Dialogue denoise; keep breaths on emotional lines.
* Layer **impact → tail** (hit + boom + low whoomp).
* One **signature motif** (heartbeat, lullaby, ticking) threaded 3–4 times.

### Cards, copy, and VO (clarity without spoilers)

* 3–6 cards max. 2–5 words each. Present tense. No clichés.
* **Card cadence:** World → Problem → Stakes → Title → Date/CTA.
* VO only if voice is iconic or exposition is dense. Keep VO lines to < 2 per act.

### Structure templates (use whichever fits the film)

* **Problem–Promise:** “She needs X. He’ll do anything. The clock is ticking.”
* **Mystery Box:** Questions only; answers withheld. Heavy on mood and symbols.
* **Character Hook (comedy/feel-good):** Flaw → fish-out-of-water beats → heart moment → ensemble laughs → button gag.
* **Set-Piece Driver (action/horror):** Mini set-piece in three movements as the trailer’s spine.

### Ethics & legal (don’t get burned)

* **No fake plot.** Compression is fine; fabrication that betrays the film backfires.
* Clear **music rights**, dialogue rights, guild rules. Use MPAA/ratings cards properly.
* Protect **twist images**; if used, strip context.
* Accessibility: burnt-in captions for digital.

### Common mistakes (avoid)

* Front-loading logos; bury the hook.
* Explaining the plot. Use images + one crisp line.
* Wall-to-wall music with no dynamics.
* Over-long cards, cliché VO, meme-sound overuse.
* Spoiling third-act solutions.

### Practical edit checklist

* Build bins: Dialogue gems / Emotions / Villain / Stunts / Beauty / Quiet moments / Transitions (whip, match) / Reactions / Wild SFX.
* Color early “enough” for decisions (fast LUT); final pass later.
* Submix: DX, MX, SFX; sidechain DX over MX.
* Add 2–3 **match cuts** (action, shape, motion) for polish.
* Create **alt hooks** (at least 3) and **alt buttons** (2+).
* Export social cut-downs (15/30s) and square/vertical crops.

### Mini playbook by genre

* **Action/Thriller:** ticking motif; map stakes visually; 1 big set-piece teased; 1 stop-down; hard final hit.
* **Horror:** everyday → wrongness; long tension holds; one scream; hard silence before title; button = tiny uncanny beat.
* **Comedy:** 2–3 jokes that land cleanly; one heart beat; end on a topper gag; punchy card copy.
* **Drama/Romance:** faces, music swells, one devastating line, one hope line; lyrical pacing with a late montage.

### If you’re doing this yourself (fast path)

1. Write 10 loglines and 10 hooks. Pick the top 2 of each.
2. Music first. Place section markers.
3. Assemble a 60-sec core cut that works *without* cards.
4. Add 3–5 cards max.
5. Sound design stop-downs and 3 signature hits.
6. Title + date + button.
7. Show to 3 people. Change anything they didn’t *feel* within 5s.
