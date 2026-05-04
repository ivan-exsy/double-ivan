# Opening trailer — product thinking (PRD §4.2)

The PRD has the structural skeleton (five beats, six cast, 2:30–3:00). What it does not have yet is what makes this trailer hit *different* from day-overview — and that is the question worth answering before building.

> ## STATUS — v0 SHIPPED 2026-05-01
>
> **Pipeline is live and end-to-end-validated against `20260430-7`** (4-persona Pistsov family). Validator PASSED:
> - 16:9 master 130.0s × 1280×720, 24.7 MB
> - 9:16 vertical 130.0s × 1080×1920, 37.7 MB
> - Narration 88 words (within 60-220 bound)
> - Total wall time 332s (~5.5 min)
> - LLM cost ~$0.002 on Tier B (gpt-5-mini)
>
> **CLI:** `python -m video.generate_trailer 20260430-7 --mode opener --top 4 --cohort-name "Pistsov family" --season-title "Who will stay alive"`
>
> **What's in v0:** mode-dispatch wiring · 4 LLM helpers (bio + archetype + trait + stakes-montage narration) · Phaser asset capture (homes + 6 establishing shots) · native Phaser sprite-walkout fallback · cast-intro composer · cold-open + stakes-montage + end-card composers · mode-aware validator · YouTube description generator works unchanged (per-scene `?double=` deep-links rotate correctly).
>
> **What still needs commissioned assets** (the v0 placeholders ship working trailers; commissioned drops upgrade quality without code changes): §TODO-A polished sprite walkouts (Grok Imagine) · §TODO-C anthem track (Suno) · §TODO-D per-persona stings (Suno) · §TODO-E commissioned trading-card frame PNGs (Figma/Midjourney). **§TODO-I cinematic atmospheric clips landed 2026-05-04** (5 Grok Imagine flyovers in `video/fly-over/`).
>
> **Status table** — see each §TODO heading below for full per-item state.
>
> | TODO | State | Note |
> |---|---|---|
> | §TODO-A Sprite walkouts | **PARTIAL** | Native Phaser WebM fallback shipped; Grok Imagine MP4 drop-in slot live |
> | §TODO-B One-line bios | **DONE** | Tier-B LLM call shipped |
> | §TODO-C Anthem track | **OPEN — placeholder** | Using `music_drama.mp3`; commission Suno track |
> | §TODO-D Archetype stings | **OPEN** | Archetype classification shipped; per-persona sting playback not yet wired |
> | §TODO-E Trading-card frames | **PARTIAL** | FFmpeg-drawn borders shipped per archetype; commissioned PNGs slot in via `card_frame_{archetype}.png` |
> | §TODO-F Home/establishing shots | **DONE** | `video/capture_static_assets.py` shipped |
> | §TODO-G Archetype classifier | **DONE** | `_classify_archetype` Tier-B LLM call shipped |
> | §TODO-H Cold-open narration | **DONE** | Templated line + ElevenLabs TTS shipped |
> | §TODO-I Stakes-montage source | **DONE 2026-05-04** | 5 Grok Imagine flyovers landed at `video/fly-over/cinematic_flyover_*.mp4`; `_generate_opener_script` updated to use them; `compose_opener_trailer` resolves `fly-over/...` paths transparently. Phaser establishing shots remain as fallbacks. |
> | §TODO-J End card | **DONE** | `generate_opener_end_card` shipped |
> | §TODO-K Sketch normalization | **DECIDED** | Leave as-is for v0 |
> | §TODO-L Cohort/season title | **DECIDED** | Pistsov family / Who will stay alive |

> ## Decisions locked — 2026-05-01
>
> **Scope:** Greenlight scope A (full opening), **dropping the Relationship Reveal beat**. Final beat sheet: cold open → cast intros → stakes montage → end card. Cuts ~25s; the relationship hints are sequenced into cast-intro adjacencies and stakes-montage cuts instead.
>
> **Portraits — sketches, not photos.** All cast portraits use `onboarding/user_photos/double-sketches/{agent_id}.png` (hand-drawn colored sketches, already in repo). Privacy-safe → enables open social sharing now (no consent gate). Real-photo path is dropped from v1; no `--portrait-mode` toggle needed.
>
> **No voice lines — silent trait moments.** ElevenLabs TTS in someone else's voice for "I'm here to play" undercuts the recognition beat. Cast intros run with anthemic music, sprite cameo, name card, and on-screen text trait moment — no per-persona spoken lines. The narrator only speaks during the cold open.
>
> **Build order locked:** Cast-intros stage first (the novel piece) → anthem + cold open + stakes montage scaffold → end card last.

## What the opening is actually for

**Day-overview** tells a story. It says “here’s what happened on Day 2.” The viewer is reacting to events.

**Opening** makes the viewer care about the cast before any story has happened. It is the season title sequence: Survivor’s “16 strangers, 39 days” intro, The Bachelor first-night arrival, Big Brother house tour.

For a cohort product where “the social graph is the product” (per Nicolas’s gate doc), the opening has one job above all others: **make every friend feel like the lead character of their own arc** — even the ones who will get voted out Day 1. If your Aunt Maria sees the opening and does not lean forward when she sees herself, the whole pitch breaks.

## The five emotions, in order

| Beat | Emotion | What lands it |
| --- | --- | --- |
| Cold open | Intrigue + grandeur | World pan, gold lettering, narrator names the stakes (“Eight friends. Three days. One survives.”) |
| Cast intros | Recognition (“that’s me / that’s Sasha”) | Real face → name → one-line identity → sprite cameo |
| Relationship reveal | Anticipation (“they’re going to clash”) | Pairs, alliances hinted, rivals named |
| Stakes montage | Drama (“this is going to be intense”) | Fast cuts: vote, alliance, elimination iconography |
| End card | Action (“watch now”) | “DAY 1 STARTS NOW” + CTA |

The whole thing does a job a 60s day-in-life trailer cannot: **selling the people, not the events.**

## How to structure the cast intros (the ~90s that matter most)

Each persona gets ~15 seconds. Structure aligned with reality-TV title sequences (revised 2026-05-01 — sketch portraits replace photos, silent trait moment replaces voice line):

| Time | Beat | Role |
| --- | --- | --- |
| 0.0s | **Sketch portrait** full-screen on trading-card frame (1.5s) | **Recognition** |
| 1.5s | Crossfade into their sim home | **Bridge:** sketch → game |
| 2.5s | Sprite walks out / turns / waves (2–3s, generated micro-video) | **Life:** not a static card |
| 5.0s | Name card + one-line bio overlay (3s) | **Verbal identity** |
| 8.0s | **Trait moment as on-screen text** over silent sprite footage (4s) | **Personality without voice** |
| 12.0s | Persona sting + cut to next persona (3s overlap with anthem) | **Rhythm** |

Six personas × 15s ≈ 90s of cast. Hard musical cuts on transitions read as kinetic. **No spoken VO during cast intros** — the anthem carries the rhythm, on-screen text carries personality, the per-persona sting punctuates each card.

## Asset strategy — what makes or breaks this

### Tier 1 — must-have, biggest impact

- **Stylized sketch portraits.** Already in repo at `onboarding/user_photos/double-sketches/{agent_id}.png` — hand-drawn colored sketches, one per persona. Privacy-safe and shareable. Zero new asset work; just a render pass to extract + composite.
- **Sprite cameos at home (2–3s each).** Pan to home → sprite walks out / turns / smiles → name card lands. Generated as **Grok Imagine micro-videos** seeded with the persona's sketch + their top-down room screenshot — see §TODO-A below for the prompt template. Native Phaser recording is the fallback if Grok Imagine output is inconsistent.
- **One-line bio per persona.** Generated from the soul `.md` with a small Tier B LLM call. Example tone: "Ivan — wants to win at any cost." "Katya — sees through everything." See §TODO-B below.
- **Anthem music track.** ~165s, big anthemic build with 6 musical stings at 15s intervals (one per cast reveal). Suno/Udio per existing music pipeline. See §TODO-C below for the full prompt.
- **Per-persona intro stings.** 1-2s SFX per persona, varied by gender + psychological archetype (champion / wildcard / observer / connector). See §TODO-D.
- **Trading card frame templates (3 types).** Champion, Wildcard, Observer — each one a PNG overlay applied around the sketch portrait. See §TODO-E.

### Tier 2 — strong nice-to-have

- **Stylized “trading card” frames.** Photo + cohort-themed border + role tag (alliance leader / wildcard / quiet ones). ~3h FFmpeg + drawtext templates.
- **One-liner dialogue audio.** Short ElevenLabs TTS per persona in their voice. Voice mapping exists. ~$0.05/persona, ~2h setup.
- **Static establishing shots** of key locations (Hobbs Cafe, Ville center, council). Freeze-frames from prior recordings + title overlays — no new capture.

### Tier 3 — defer past v1

- **AI stylized portraits** (Midjourney/SD): cool but $1–3 per cohort + manual step; real photos already win recognition for v1.
- **Affinity-graph overlay** (PRD §5.5): striking, but PRD says skip in v1 if time-constrained. Hint relationships via pairing in intros and stakes montage instead.
- **Per-persona prediction tags** (“least likely to win”): fun, post-MVP — needs scoring/prompt step.
- **Picture-in-picture / split-screen rivalries:** great look, doubles FFmpeg complexity — defer.

## Build order (locked)

1. **Cast-intro stage only** — 6 × ~15s: sketch portrait → sprite cameo (Grok Imagine micro-video) → name card + bio → silent trait moment + persona sting. Render in isolation as a smoke test on `20260430-7` cast.
2. **Anthem + cold open + stakes montage** — scaffold around the cast intros once they land. Anthem drives the rhythm; narrator only speaks during the cold open.
3. **End card + CTA** — mechanical (drawtext, reuse end-card infra). "DAY 1 STARTS NOW" + cohort/season + watch-live framing + `www.doubland.ai` (per video_playbook §4.7; v0 shipped a `doubland.ai/waitlist` line — superseded 2026-05-04).
4. ~~**Relationship reveal**~~ — **dropped from v1**. Pairs hinted by sequencing in cast intros and by adjacency in the stakes montage; full split-screen deferred to v2.

**Estimate:** ~3 working days (down from ~3-4 because relationship reveal is dropped). PRD §5.8 (ranker), §5.9 (mode dispatch), and §5.10 (orchestrator) already shipped on day-overview and opening reuses all three.

## Channel unlock

Once opening ships, the YouTube workflow can post the **season premiere on Day 0**, then a **day-overview every day after**. Two artifact types cover the full season arc, without day-in-life trailers unless you want a single-protagonist deep dive.

---

# TODO — Asset / content prep before implementation

This is the punch-list to execute *before* I start coding the §4.2 Opening trailer pipeline. Each section names the asset, the tool, the prompt or spec, and the deliverable file path. Items marked **[YOU]** are things only you can do (commission, generate, decide); items marked **[ME]** I'll handle in code once the inputs land.

The cohort for the v1 smoke test is `20260430-7` (4 personas: Gosha, Ivan, Katya, Luba). For a real cohort of 6-8 personas, replicate the per-persona items 6-8×.

---

## §TODO-A. Sprite walk-out micro-videos (6 × 2.5s) — Grok Imagine

> **STATE 2026-05-01:** **PARTIAL — drop-in slot ready.** Native Phaser sprite-walkout WebMs shipped via `record_sprite_walkout` in `video/record_scenes.py` and are auto-captured by the orchestrator at Stage 4 (`video/assets/opening/sprite_walkout_{agent_id}.webm`). The composer prefers `.mp4` first; commissioning the Grok Imagine versions and dropping them into `video/assets/opening/sprite_walkout_{agent_id}.mp4` upgrades the visual quality with zero code changes. The native Phaser fallback is what's running in v0; the prompt template below is for the upgrade path.

**Deliverable:** `video/assets/opening/sprite_walkout_{agent_id}.mp4` per persona. 1280×720, MP4 H.264, 30fps, ~2.5s. Transparent or matching dark background.

**Inputs you provide per persona:**
- `onboarding/user_photos/double-sketches/{agent_id}.png` — colored sketch (already in repo)
- Top-down screenshot of their assigned home zone — **see §TODO-F for capture method** (you'll commission these once and reuse)

**Workflow per persona:**
1. Open Grok Imagine → image-to-video.
2. Upload the sketch as the primary reference.
3. Upload the room screenshot as a secondary reference / background plate.
4. Use the prompt template below, replacing the placeholders with that persona's specifics.
5. Generate 2-3 takes; pick the best.
6. Save as `sprite_walkout_{agent_id}.mp4` and drop into `video/assets/opening/`.

**Prompt template (copy-paste, fill placeholders):**

```
A friendly hand-drawn cartoon character in colored-pencil / hand-sketched art
style steps into the frame from the [LEFT|RIGHT|BACK], walks two or three
casual steps forward toward the camera, turns slightly to face the viewer,
gives a subtle [SMILE|WAVE|NOD], and holds for the final beat.

Character must match the attached sketch reference exactly: same line weight,
same color palette, same shading style, same hairstyle, same outfit. Do not
restyle the character — preserve the sketch art.

Setting: [DESCRIBE THE ROOM FROM THE TOP-DOWN SCREENSHOT — e.g.
"a warm-lit cafe interior with wooden tables, soft amber overhead lighting,
gentle ambient bokeh in the background"]. Background is slightly out of focus
to keep the character sharp. Camera is locked / no pan.

Mood: [WARM | CONFIDENT | INTRIGUING | PLAYFUL — pick one matching their
psychological archetype].

Duration: 2.5 seconds. Output: 1280×720, 30fps. The character should be
fully on-frame by the 1.0s mark and hold the final pose from 2.0-2.5s.

Style anchors: hand-drawn animation, light cel-shading, gentle ambient
motion in hair / clothing, no harsh perspective shifts.
```

**Per-persona placeholder fills (you author these or extract from each soul `.md`):**
- Direction of entry: usually `LEFT` for first persona, alternate per persona for visual variety
- Action: pick from {SMILE, WAVE, NOD, TILT_HEAD, GLANCE_OVER_SHOULDER}
- Setting description: ~20 words from the top-down screenshot
- Mood word: derived from psychological archetype (see §TODO-G card-type assignment)

**Fallback if Grok Imagine output is inconsistent:** record native Phaser scene (existing `record_scenes.py` works) — sprite cameo via `__followPersona` + 3-step walk-out at Day-0 spawn. Lower polish than hand-drawn animation but zero new dependency. Decide per persona based on Grok output quality.

**Acceptance:** First frame of clip has full character on-screen by 1.0s mark; final 0.5s holds steady (so the name card overlay can land cleanly); no abrupt scene cuts inside the clip.

---

## §TODO-B. Per-persona one-line bios (6 × ~10 words) — LLM-generated, you curate

> **STATE 2026-05-01:** **DONE.** `_generate_one_line_bio` shipped in `video/showrunner.py`; runs at Stage 2 of the opener pipeline using Tier B (gpt-5-mini). Each bio costs ~$0.0001. Bios for the `20260430-7` run came back tight and on-format ("Gosha — organizes teams relentlessly, protects allies, plans ahead." etc.). No `bios.json` file is written separately — the bios live inside each `cast_intro` scene of `script.json`.

**Deliverable:** `video/assets/opening/bios.json` — a dict `{persona_name: bio_text}`. ~10 words per bio. Designed to land on screen at 5.0s and read in ~2 seconds.

**Generation:** I'll wire a small Tier B LLM call (`gpt-5-mini`) that ingests each persona's soul `.md` (path: `souls/{name}.md`) and returns one line. Pre-build target structure: `<Name> — <verb-phrase capturing their drive>`.

**Prompt I'll use (you can tune the tone instructions):**

```
You are writing the one-line bio that lands on screen during a reality-TV
opening trailer's cast-intro card for a Survival-mode AI persona.

Read the persona's soul file (attached). Output EXACTLY ONE LINE in the form:

  {Persona First Name} — {verb phrase capturing what drives them in 5-9 words}

Rules:
- Active voice. Present tense.
- No metaphors. No clichés ("born to win", "ready for anything").
- Capture the strongest drive or trait — what would make them dangerous,
  vulnerable, or surprising in a vote-out game.
- 5-9 words after the em-dash. No more.
- No exclamation marks.

Examples (calibration):
  Ivan — wants to win at any cost.
  Katya — sees through everything, says nothing.
  Gosha — treats every conversation like an SAT section.
  Luba — looks out for the quiet ones.

Output: the bio line ONLY, no commentary.
```

**Your call to make:** review the 6 bios after generation; reject + regen any that read generic. ~5 min/cohort.

---

## §TODO-C. Anthem music track (~165s) — Suno or Udio

> **STATE 2026-05-01:** **OPEN — placeholder running.** v0 uses the existing `video/audio/music_drama.mp3` as a stand-in (75s, will fade out at the 75s mark of the 130s trailer). Drop-in path ready: when `video/audio/music_anthem.mp3` lands, the script's `mood: "drama"` field needs to flip to `"anthem"` (or you can rename the file to `music_drama.mp3` to keep the wiring). The audio mix path's `apad` already pads the trailer to full duration regardless of music length; the placeholder doesn't break the pipeline, just runs silent in the second half.

**Deliverable:** `video/audio/music_anthem.mp3`. ~165s, normalized −16 LUFS, MP3 192 kbps, 1.5s fade-out tail to silence.

**Tool:** Suno v4 or Udio (whichever you have credits on). Both accept structured prompts.

**Prompt:**

```
[Genre] Cinematic anthemic orchestral hybrid — reality TV grand premiere
[Tempo] 110 BPM
[Length] 165 seconds
[Vocals] NONE — fully instrumental
[Mood] Big, hopeful, slightly tense; reverent but kinetic
[Reference tracks] Survivor S43 main theme; Big Brother UK 2023 intro;
                   "Heroes" (David Bowie) cinematic-orchestral cover
[Instrumentation] Cinematic strings, light electronic percussion, brass
                  swells for hooks, sub-bass for grandeur, sparse piano

Structure:
  0:00–0:08  Cold open: sparse strings + low piano, builds tension under VO
  0:08–0:16  Hook plant: drums kick in subtly under cold-open VO tail
  0:16–0:30  Stakes drop: full orchestra hits + percussion drives rhythm
  0:30–2:15  Cast intros: rhythmic motif, persistent driving beat, with
             6 musical "stings" at 15s intervals (0:30, 0:45, 1:00, 1:15,
             1:30, 1:45) — each sting is a 0.5s harmonic accent that
             punctuates a name-card reveal
  2:15–2:35  Build: tension rises, drums intensify, brass swells
  2:35–2:50  Stakes montage: full ensemble, big anthemic chorus
  2:50–2:55  Final hit + 5s tail to silence

Output: 1.5s fade-out at the very end; clean silence beyond 165s.
```

**Acceptance:** generate 2-3 candidates, pick the one whose 6 stings hit cleanly at the 15s intervals. Normalize via the existing `video/audio/normalize.sh` (or whatever the existing music tracks ran through — reuse the same toolchain so loudness matches `music_drama.mp3` etc.).

---

## §TODO-D. Per-persona intro stings (4 archetype stings, 1.5-2.5s each) — Suno or sound library

> **STATE 2026-05-01:** **OPEN.** Archetype classification is shipped (`_classify_archetype` Tier B LLM call assigns champion/wildcard/observer/connector to each persona); the `archetype` field is on every cast_intro scene and on the persona's trading-card frame. **Sting playback is NOT yet wired** in the cast-intro composer — when the WAVs land, a small `compose_cast_intro` change overlays the matching sting at the scene-out moment. v0 ships without stings; the anthem placeholder fills the audio.

**Deliverable:** `video/assets/opening/sting_{archetype}.wav` × 4 archetypes. ~1.5-2.5s each, normalized −12 LUFS peak (sits 4 dB above the ducked anthem).

Each persona is mapped to ONE archetype (see §TODO-G); the matching sting plays at the moment that persona's name card lands. Four stings cover most psychology + gender combinations cleanly.

**Archetype 1 — Champion** (alliance leader, dominant, driven)
```
[Genre] Cinematic sports / triumphant
[Length] 2.0 seconds
[Mood] Bold, decisive, victorious
[Sound] Brass hit (rising trumpet) + tom drum thud + cymbal crash tail
[Reference] NBA finals intro stinger, NFL opening cinematic hit
[Tempo] Free, single hit
[Output] 1.5-2.0s, sharp attack, tail to silence
```

**Archetype 2 — Wildcard** (chaotic, unpredictable, playful)
```
[Genre] Electronic / playful synth
[Length] 1.5 seconds
[Mood] Mischievous, surprising, slightly off-kilter
[Sound] Synth zap + tape rewind + tempo skip / vinyl scratch
[Reference] Stranger Things intro accents, glitch-pop transitions
[Tempo] Free, syncopated
[Output] 1.5s, playful tail
```

**Archetype 3 — Observer** (quiet, strategist, watchful)
```
[Genre] Ambient cinematic
[Length] 2.5 seconds
[Mood] Pensive, deliberate, suspenseful
[Sound] Low cello sustained note + soft cymbal swell + single piano note
[Reference] True Detective S1 transitions, Ozark scene-break stings
[Tempo] Free, slow
[Output] 2.5s, soft attack, long tail
```

**Archetype 4 — Connector** (warm, nurturer, social glue)
```
[Genre] Acoustic warm / folk-cinematic
[Length] 2.0 seconds
[Mood] Inviting, sincere, warm
[Sound] Warm piano chord + acoustic guitar pluck + gentle bell
[Reference] This Is Us scene transitions, "wholesome" reality TV reveals
[Tempo] Free, gentle
[Output] 2.0s, soft attack, sustaining tail
```

**Acceptance:** all four stings sit cleanly under the anthem when ducked −6 dB; the attack hits within 100ms of card-land moment.

---

## §TODO-E. Trading card frame templates (3 types) — PNG overlays

> **STATE 2026-05-01:** **PARTIAL — placeholder borders shipped.** v0 generates archetype-tinted borders inline via FFmpeg `drawbox` (4 thin rectangles around the canvas, archetype-specific border color + role-tag drawtext). Visible in every cast intro on `data/20260430-7/opener&001/output/trailer_16x9.mp4`. The placeholder is functional but visually utilitarian — not the final polished card aesthetic. **Drop-in slot ready:** when commissioned PNGs land at `video/assets/opening/card_frame_{archetype}.png`, a small `compose_cast_intro` change layers the PNG above the sketch portrait before drawtext applies. The full visual specs below are unchanged from the original commission brief.

**Deliverable:** `video/assets/opening/card_frame_{type}.png` × 3 types. 1280×720, transparent PNG, with a sketch-portrait cutout zone in the upper-left and overlay zones for name + bio + role tag.

The 3 types map to persona archetypes from §TODO-G (Champion / Wildcard / Observer). Connector personas use the Champion frame in v1 (a 4th frame is post-MVP polish).

**Tool options (your call):**
1. **Figma → PNG export** (~1 hour per frame; cleanest output, full creative control)
2. **Midjourney prompt** (per-frame; faster but less precise on text-cutout zones)
3. **FFmpeg drawtext + simple geometric shapes** (no external dependency, but lower polish — fallback if you want to ship in a day without commissioning art)

**Common spec across all three frames:**
- Canvas: 1280×720, transparent PNG.
- Sketch portrait cutout zone: 320×400 px, positioned at (80, 160) — upper-left third of canvas.
- Name text zone: 720×60 px at (440, 200) — to the right of the portrait.
- Role tag zone: 200×40 px at (440, 280) — directly under name.
- Bio text zone: 720×80 px at (440, 340) — under the role tag.
- Trait moment text zone: 1100×120 px at (90, 540) — bottom of canvas, large readable text.
- Right side (560-1280, 0-160): reserved for sprite walkout video that lands at 2.5s.

**Frame 1 — Champion** (alliance leader, dominant, driven)
```
[Visual style] Reality-TV trading card, premium-tournament aesthetic
[Border] 8px solid metallic gold/bronze gradient (CSS-equivalent
         linear-gradient(135deg, #C8A86B, #8B6E2F))
[Corner flourishes] Ornate filigree corners (small, ~40px each)
[Background fill] Warm radial gradient: center #2A1810 fading to edges #0A0504
[Role tag style] Wax-seal style — circular badge, gold rim, "ALLIANCE LEADER"
                 in bold serif white text inside
[Name typography] Bold serif (e.g. "Cinzel" or "Trajan Pro"), white,
                  letter-spacing 0.05em, 48pt
[Bio typography] Italic serif, off-white #E8DCC4, 24pt
[Trait-moment typography] Same as bio, 36pt, drop-shadow 2px black
```

**Frame 2 — Wildcard** (chaotic, unpredictable, playful)
```
[Visual style] Hand-drawn / scrapbook aesthetic, slightly off-kilter
[Border] 6px hand-drawn / sketchy line (black with subtle ink-bleed),
         intentionally slightly uneven (matches the sketch art style)
[Frame tilt] Whole frame rotated 1.5° clockwise — the card looks pinned-on
[Corner accents] Torn-paper / masking-tape rectangles at 2 corners,
                 hand-drawn style
[Background fill] Off-white #F4EBD8 (paper texture if available)
[Role tag style] Hand-drawn rectangle with "WILDCARD" in marker-style font
                 (e.g. "Permanent Marker"), slightly tilted opposite to the frame
[Name typography] Marker-style font (Permanent Marker, Architects Daughter),
                  black, 48pt, slight rotation
[Bio typography] Hand-drawn font, 24pt, dark grey
[Trait-moment typography] Marker font, 36pt, navy ink color
```

**Frame 3 — Observer** (quiet strategist, watchful)
```
[Visual style] Minimalist editorial — quiet confidence, thin lines
[Border] 1px solid line, neutral cream #E5DCC9, subtle shadow
[Background fill] Soft gradient cream #F8F4ED → light taupe #E5DCC9
[Role tag style] Single thin line of text in lower-left corner of card,
                 "OBSERVER" in small all-caps, 14pt, letter-spacing 0.2em
[Name typography] Light-weight modern sans-serif (e.g. "Inter Light",
                  "Helvetica Neue Light"), charcoal #2A2A2A, 48pt
[Bio typography] Same family, 22pt, mid-grey #6B6B6B
[Trait-moment typography] Same family, 32pt, charcoal
[Ornament] Single thin horizontal hairline (1px) under the name,
           360px wide, neutral grey
```

**Acceptance:** mock all three frames with one persona's sketch (use Luba's sketch — already on disk) and review side-by-side. The three frames must read as distinct personalities at thumbnail size (240px wide).

---

## §TODO-F. Top-down room screenshots (one per persona) — Phaser capture

> **STATE 2026-05-01:** **DONE.** `video/capture_static_assets.py` shipped — Playwright + Phaser camera-API screenshots producing both per-persona home top-downs AND the 6 establishing shots used by the stakes montage. Reuses Nicolas's `__headlessReady && __cameraSettled` gate. Idempotent (re-runs skip already-captured PNGs unless `--force`). The orchestrator runs it automatically at Stage 4 of the opener pipeline. For `20260430-7`: 4 home shots + 6 establishing shots produced in ~3 seconds wall time (cached after first run).

**Deliverable:** `video/assets/opening/home_topdown_{agent_id}.png` per persona. 1280×720, PNG, top-down view of their assigned home / living-room zone at Day-0.

**Method:** I'll write a small Playwright script (~30 LOC) that does:

```
1. Navigate to /simulations/20260430-7?recording=true&step=0
2. Wait for __headlessReady && __cameraSettled
3. For each persona name:
   - window.__panCameraTo(home_x, home_y)
   - window.__setCameraZoom(0.7) (wider zoom to catch the room)
   - await 500ms for tween settle
   - page.screenshot() → home_topdown_{agent_id}.png
4. Move on to next persona
```

The home_x/home_y per persona comes from `scratch.living_area` (already in Supabase) or by parsing the persona's soul `.md`. **[ME]** — I'll build this as part of the implementation; **[YOU]** confirm the cohort + sim name.

---

## §TODO-G. Persona archetype assignment (which trading-card type) — LLM, you curate

> **STATE 2026-05-01:** **DONE.** `_classify_archetype` shipped in `video/showrunner.py`; runs at Stage 2 of the opener pipeline using Tier B (gpt-5-mini). Returns `{archetype, confidence, justification}` per persona. ~$0.0002 per persona. Archetype is stored on each cast_intro scene in `script.json` and drives both the trading-card border style (placeholder) and the per-persona sting selection (when stings ship). For `20260430-7`: Pistsov family classified as champion/observer/connector mix (varies slightly between runs because the bootstrap scratch is generic for this baseline cohort).

**Deliverable:** `video/assets/opening/archetypes.json` — `{persona_name: archetype_string}` where archetype ∈ {`champion`, `wildcard`, `observer`, `connector`}.

Determines which trading-card frame and which intro sting each persona gets.

**Generation:** Tier B LLM call ingesting soul `.md` + recent scratch + relationship_affinity. Returns one of the four archetypes plus a one-line justification (logged for auditability, not surfaced).

**Prompt I'll use:**

```
You are classifying an AI persona into one of four reality-TV archetypes
for an opening-trailer cast card. Read the persona's soul file and the
attached scratch summary. Output JSON.

Archetypes:
  champion   — alliance leader, decisive, plays to win, comfortable
               wielding influence
  wildcard   — chaotic, unpredictable, playful, breaks plans for fun
               or for principle
  observer   — quiet strategist, watches more than speaks, reads the room,
               long-game thinker
  connector  — warm, social glue, builds bridges, default-trusted by the
               cohort; "looks out for the quiet ones"

Output:
  {
    "archetype": "<one of the four>",
    "confidence": 0.0-1.0,
    "justification": "one sentence — what behavior or trait drives this pick"
  }

If the persona straddles two archetypes, pick the one their *strongest*
moment in the data would land on. No ties.
```

**Your call:** review the assignments after generation; override any that don't match your cohort intuition. ~3 min/cohort.

---

## §TODO-H. Cold-open narration line + voiceover

> **STATE 2026-05-01:** **DONE.** `_opener_cold_open_line()` in `video/showrunner.py` templates the line as `"{N} friends. {D} days. One survives."` (or `"{N} friends. One game. One survives."` when season length is unknown). The line is embedded in `narrator_script` and rendered alongside the stakes-montage narration via the existing TTS path — single audio file `audio/narration.mp3` covers both. For `20260430-7` (4 personas, season length unspecified): "4 friends. One game. One survives." Switching to a different variant from the menu below is a one-line code change in `_opener_cold_open_line`.

**Deliverable:** `video/assets/opening/cold_open.mp3` — single ElevenLabs TTS line in the existing narrator voice (`cIO62fcmCSQhE0DE2WS2`, the one used in day-overview). ~3-5s of speech.

**Line template:**
```
"{N} friends. {D} days. One survives."
```
Where N = cohort size, D = season length. Examples:
- 4 friends. 3 days. One survives. (matches `20260430-7`)
- 8 friends. 7 days. One survives.

If you want a more cinematic opener, here are 3 alternatives I'd ship-ready:
1. "{N} friends. They thought they knew each other. They were wrong."
2. "Day Zero. {N} friends. One season. No way out."
3. "Welcome to The Ville. {N} friends. {D} days. A vote every night."

**Your call:** pick one of the four (or write your own); I'll generate the TTS as part of the pipeline.

---

## §TODO-I. Stakes-montage source clips — **DONE 2026-05-04**

> **STATE 2026-05-04:** **DONE.** 5 Grok Imagine cinematic flyover MP4s landed at `video/fly-over/` and wired into the default `_generate_opener_script` `atmospheric_clips` list:
>
> | File | Replaces / role |
> |---|---|
> | `cinematic_flyover_village_overhead.mp4` | replaces `establish_village_overhead.png` |
> | `cinematic_flyover_homes_row_approach.mp4` | replaces `establish_homes_row.png` |
> | `cinematic_flyover_hobbs_cafe_interior.mp4` | replaces `establish_council_zone.png` (cafe is the social stage per playbook §3.8) |
> | `cinematic_flyover_cafe_exterior_pan.mp4` | replaces `establish_cafe_exterior.png` |
> | `cinematic_flyover_village_dusk_wind_down.mp4` | replaces `establish_village_dusk.png` |
> | `establish_village_dawn.png` (kept) | no dawn flyover produced — optional follow-on |
>
> `compose_opener_trailer` resolves path-prefixed entries (`fly-over/...`) relative to `video/` and bare filenames relative to `assets_dir`, so the two-source mix works transparently. **LLM-generated narration ships:** `_generate_stakes_montage_narration` produces ~75-110 words referencing the cohort + season. **Original §STATE 2026-05-01 (PARTIAL)** kept below for context — the Phaser establishing shots from that v0 layer are still resident in `video/assets/opening/` as fallbacks if a flyover MP4 ever goes missing.

> **STATE 2026-05-01 (superseded — kept for context):** **PARTIAL — Phaser layer shipped, Grok layer pending.** The 30s stakes montage in v0 is built from the 6 Phaser establishing shots (village_overhead / cafe_exterior / homes_row / council_zone / village_dawn / village_dusk) — each gets ken-burns slow-zoom, crossfaded together via `compose_opener_stakes_montage`. **Grok Imagine cinematic MP4s drop in** by adding their filenames to `script.json`'s `stakes_montage.atmospheric_clips` array — composer mixes PNG (ken-burns) and MP4 (plays in-place) sources transparently.

**Constraint clarified:** Opening trailers are produced **before** the sim starts running, so there is no real game footage available — no votes, no eliminations, no alliance moments to draw from. The original options 1 and 3 only work for retroactive opening trailers; the v1 production case is Day-0 capture only.

**Decision:** stakes montage is built from **Day-0 atmospheric content**, with the narrator carrying the dramatic weight (not the visuals).

**Two source layers, layered in compose:**

1. **Phaser establishing shots** (~6-8 wide-angle visuals of the world)
   - Captured via the same Playwright path as §TODO-F: navigate to `?recording=true&step=0`, drive the camera with `__panCameraTo` + `__setCameraZoom(0.4-0.6)` for wide views, screenshot.
   - Targets: village center (overhead), Hobbs Cafe exterior, council chamber (or its analog at `20260430-7`), the homes-row pan, a wide sunrise / sunset version of the village if the FE supports time-of-day shading.
   - Output: `video/assets/opening/establish_{name}.png` × 6-8.
   - **[ME]** — add to the Playwright capture script.

2. **Grok Imagine 3D / cinematic renderings** (~4-6 hero shots)
   - Generated stylized cinematic renders of the Phaser world or key assets, used as atmospheric inserts during the stakes-montage narration. Think establishing shots from the title sequence of a prestige show.
   - **YOU produce these via Grok Imagine** using the prompt template below.

**Stakes-montage narration carries the drama:**

The visuals are atmospheric Day-0 world shots; the narrator's lines do the heavy lifting. ElevenLabs TTS in the same narrator voice as the cold open. ~25-30s of script over 6-8 cuts averaging 4s each.

**Narration generation:** I'll add a `_generate_stakes_montage_narration` LLM call (Tier B) that ingests the cohort's persona list + survival rules + cohort name, and returns a script in the same Attenborough-meets-TikTok voice as the day-in-life narrator. ~$0.005 per call. Sample tone:

```
"Eight friends. They've shared birthdays, secrets, breakups. Now they share
a clock. Three days. One vote every night. The house remembers everyone who
slept here last week — by Friday, four of them won't be coming back.
Some will lie. Some will cry. One will wake up alone."
```

**Grok Imagine prompts for the 3D / cinematic renderings (you produce 4-6 of these):**

These are atmospheric establishing shots — the equivalent of a Survivor opening flyover or the *True Detective* main-titles sequence. Each is a static or slowly-panning rendering, ~3-5s, used as a background plate for narration. **No characters in any of these** (cast intros own the character work; stakes montage is world-only).

```
[Subject] A wide cinematic 3D render of a small fictional village, viewed
from a slow camera dolly at golden-hour light. Inspired by The Sims and
Stardew Valley overhead view but rendered in a richer, more cinematic
3D style with volumetric lighting and atmospheric depth.

[Specific shot — pick one per asset]:
  - "Empty village square at golden hour, long shadows, soft gold lighting,
     wisps of smoke from distant chimneys"
  - "Aerial dolly over a cluster of small houses, each with a single
     lit window, dusk falling, the camera slowly descends"
  - "Interior of an empty cafe at first light, sun streaming through
     wooden blinds, single coffee cup steaming on the counter, no people"
  - "A hand-drawn ballot box on a wooden table, single shaft of light
     from above, dust motes catching the light"
  - "Long row of empty wooden chairs in a council circle at twilight,
     central fire pit unlit, leaves drifting"
  - "Wide overhead pan across a quiet sleeping village at midnight,
     a single window lit in one home, soft moonlight, breathing-pace
     drift"

[Style] Cinematic 3D rendering, slight stylized hand-painted feel, rich
warm/cool color contrast, atmospheric haze, depth of field with foreground
softness. NOT photorealistic; NOT cartoon. The aesthetic of a prestige
animated film (Pixar Up opening, Spirited Away interiors).

[Camera] Static or slow lateral dolly. NEVER fast cuts — these clips
get cut quickly in compose; each individual clip should feel calm.

[Output] 1280×720, 3-5 seconds per clip, MP4 H.264.
```

**Acceptance:** generate 4-6 candidates per shot description; pick the ones that read most cinematic. The compose stage cuts each to 2-3s in the final montage; full-length is generated for safety margin.

**Deliverable layout (actual, as of 2026-05-04):**
```
video/assets/opening/                                  (Phaser captures)
  establish_village_overhead.png       (fallback — superseded by flyover)
  establish_cafe_exterior.png          (fallback — superseded by flyover)
  establish_homes_row.png              (fallback — superseded by flyover)
  establish_council_zone.png           (fallback — superseded by hobbs cafe interior flyover)
  establish_village_dawn.png           (active — no flyover yet)
  establish_village_dusk.png           (fallback — superseded by flyover)

video/fly-over/                                        (Grok Imagine cinematic MP4s)
  cinematic_flyover_village_overhead.mp4               (4s)
  cinematic_flyover_homes_row_approach.mp4             (3s)
  cinematic_flyover_cafe_exterior_pan.mp4              (4s)
  cinematic_flyover_hobbs_cafe_interior.mp4            (4s)
  cinematic_flyover_village_dusk_wind_down.mp4         (4s)
```

---

## §TODO-J. End card design

> **STATE 2026-05-04:** **SHIPPED v0; v2 spec pending (see PRD TODO-13).** `generate_opener_end_card()` in `video/compose_trailer.py` produces a 5s 3-line card: `DAY 1 STARTS NOW` (80pt white) + cohort/season subtitle (32pt grey) + `doubland.ai/waitlist` CTA (28pt gold #C8A86B). v2 swaps the single waitlist CTA line for a multi-line watch-live block (per video_playbook §4.7) and bumps duration ~5s → ~8s.

**Deliverable:** generated in compose stage via FFmpeg drawtext, no asset file needed beyond a font choice.

**v2 Spec (current target):**
- Background: dark neutral #0A0A0A with a subtle radial light at center
- Title (line 1, centered, 80pt, white serif): `DAY 1 STARTS NOW`
- Subtitle (line 2, centered, 32pt, off-white): `{cohort_name} — {season_title}`
- Body (line 3, centered, 28pt, off-white): `Watch live. Scroll back. Follow every Double.`
- Body (line 4, centered, 24pt, off-white): `New trailer daily at 6:30 PM.`
- CTA (line 5, centered, 28pt, gold #C8A86B): `www.doubland.ai`
- Duration: ~8s (extra reading time for 5 lines vs the v0 3-line card)

**Your inputs:** cohort_name (e.g. "The Pistsov Family Sim", or whatever the cohort calls itself).

---

## §TODO-K. Sketch normalization — **DECIDED 2026-05-01**

**Decision:** leave sketches as-is for the MVP release. Trading-card frame masks the inconsistency; if it reads as a problem in the smoke test, revisit with option 2 (re-render) or option 3 (Photoshop pass) for the polished investor cut.

---

## §TODO-L. Cohort name + season title — **DECIDED 2026-05-01**

- **Cohort name:** Pistsov family
- **Season title:** Who will stay alive

End card resolves to (v2 spec):
```
DAY 1 STARTS NOW
Pistsov family — Who will stay alive

Watch live. Scroll back. Follow every Double.
New trailer daily at 6:30 PM.

www.doubland.ai
```
v0 shipped a single-line `doubland.ai/waitlist` CTA — superseded 2026-05-04 per video_playbook §4.7.

---

## Summary — what's done, what's left (revised 2026-05-01)

### ✅ What I shipped today (v0 working pipeline)

End-to-end opener trailer renders against `20260430-7` and passes the validator. All eight implementation steps from the §4.2 plan landed:
- Mode-dispatch wiring (`--mode opener` + `--cohort-name` + `--season-title` + `--top` CLI args)
- Day-0 cast extraction (`extract_opener_context`)
- Phaser asset capture (homes + 6 establishing shots — `video/capture_static_assets.py`)
- 4 LLM helpers (bio + archetype + trait + stakes-montage narration) on Tier B
- Showrunner opener mode (`_generate_opener_script` + `_validate_opener_script`)
- Native Phaser sprite-walkout fallback (`record_sprite_walkout`)
- Cast-intro composer + cold-open + stakes-montage + end-card composers
- Mode-aware validator (95-180s duration, 60-220 word narration)

### 🚧 What still needs commissioned assets — the v1 polish drops

| Priority | Item | Effort | Drop-in path |
|---|---|---|---|
| **P1** | §TODO-A polished sprite walkouts via Grok Imagine | ~2-4h × 6 personas | Drop `sprite_walkout_{agent_id}.mp4` into `video/assets/opening/`; composer prefers `.mp4` over `.webm` automatically |
| **P1** | §TODO-C anthem music track via Suno (~165s with 6 stings) | ~1-2h | Drop `music_anthem.mp3` into `video/audio/`; flip script's `mood` field to `"anthem"` (or rename file to `music_drama.mp3` for zero-config swap) |
| **P1** | §TODO-E commissioned trading-card frame PNGs (3 archetypes) | ~3-6h | Drop `card_frame_{archetype}.png` into `video/assets/opening/`; ~10 LOC change in `compose_cast_intro` to layer the PNG |
| **P2** | §TODO-D archetype intro stings (4 archetypes) | ~1-2h | Drop `sting_{archetype}.wav` into `video/assets/opening/`; ~20 LOC change in `compose_cast_intro` to play sting at scene-out |
| ✅ DONE | ~~§TODO-I cinematic atmospheric MP4s via Grok Imagine~~ | shipped 2026-05-04 | 5 flyovers in `video/fly-over/`; `_generate_opener_script` and `compose_opener_trailer` updated |

**Total polish effort remaining:** ~7-14 hours of asset commissions (sprite walkouts, anthem, trading-card PNGs, archetype stings); ~1 hour of code changes once assets land. The current v0 ships a watchable trailer without any of these — they upgrade quality, not function.

### 🎬 What you can demo right now

The v0 trailer at `data/20260430-7/opener&001/output/trailer_16x9.mp4` (130s, 24.7 MB). It demonstrates:
- All 4 Pistsov family members getting recognition beats with sketch portraits + sprite cameos + bios + trait moments
- Archetype-themed borders (gold for champion, etc.)
- Cold-open narration over a slow zoom on the village
- Stakes-montage narration over ken-burns establishing shots
- Branded end card (v0: single-line `doubland.ai/waitlist`; v2 target per playbook §4.7: multi-line watch-live + `www.doubland.ai`)
- YouTube-paste-ready description with rotating per-cast `?double=` deep-links

Use it for internal review or a tier-2 investor preview. Keep §TODO-A/C/E for the polished investor-grade demo.

### 🔁 Recommended next action

Send §TODO-A, §TODO-C, §TODO-E asset prompts (already written above) to whoever produces them. While those are in flight, the v0 pipeline is fully functional for any iteration / cohort change — you can already run the opener against any sim with `extract_opener_context` data available.
