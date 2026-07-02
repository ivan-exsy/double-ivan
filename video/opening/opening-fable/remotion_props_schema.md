# Remotion props schema — visual micro-beat model

**Purpose:** the contract the beat planner (`build_day_remotion_props.py`) must emit so the renderer can reproduce Anya's visual grammar. Replaces the current "1 narration segment = 1 beat" output. Aligned with the audit deliverables in this folder (`visual_beat_map.csv`, `transition_primitive_catalog.md`, `visual_acceptance_rubric.md`) and with existing renderer types in `video/remotion/src/types.ts`.

## Design principles

1. **Two clocks.** `visualBeats` is the master timeline. Narration is attached loosely via `voAnchor` — a beat may start mid-VO-sentence and VO may span several beats. The planner never stretches a beat to fit narration.
2. **Layers are stateful, not per-beat.** A layer is declared once with its own lifespan; beats reference which layers persist/enter/exit. This is what makes `persistentLayerSwap` and `textHoldAcrossBackgroundCut` expressible.
3. **Every beat names a primitive.** No untyped crossfades. The renderer maps primitive → existing component (`SharedCenterReplace.tsx`, `PersistentLayerSwap.tsx`, `UiStateMorph.tsx`, `CardSelectZoom.tsx`, `RadialObjectMatch.tsx`, `QuestionToUrlTakeover.tsx`, plus new ones below).
4. **Text is a micro-event track**, not a beat property. Type-and-hold timing lives on the event.

## TypeScript schema (extends `types.ts`)

```typescript
// ---- Layer track: declared once, referenced by id across beats ----
export type LayerKind =
  | "heroVideo"      // full-bleed clip (Village.mp4, Talk.mp4, ...)
  | "heroImage"      // full-bleed still / tile map
  | "anchorImage"    // persistent PNG anchor (family photo, cast band)
  | "uiCard"         // HUD card in a named slot; contents can morph
  | "uiPanel"        // selection panel / dashboard / feed
  | "character"      // full-body cutout on light gray
  | "gauge"          // pressure gauge chassis
  | "wordmark"       // DOUBLE / DOUBLAND logo
  | "figureFx";      // wireframe silhouettes, particle ghosts

export type LayerZone = "fullBleed" | "top" | "centerBand" | "bottom" | "right" | "custom";

export type VisualLayer = {
  layerId: string;              // e.g. "familyPhoto", "talkFigures", "selectionPanel"
  kind: LayerKind;
  src?: string | null;          // asset path (from asset_to_beat_map.csv)
  zone: LayerZone;
  startSec: number;             // layer lifespan — independent of beat boundaries
  endSec: number;
  idleMotion?:                  // required if the layer is ever the only moving thing
    | "clipPlayback" | "ringRotate" | "needleSweep" | "feedTick"
    | "fogDrift" | "bubblePulse" | "cameraDrift" | "none";
  states?: {                    // for uiCard/uiPanel/gauge: uiStateMorph targets
    atSec: number;
    stateId: string;            // e.g. "allianceCard" -> "decisionCard" -> "relationshipGraph"
    payload?: Record<string, unknown>;
  }[];
};

// ---- Visual beat track: the master clock ----
export type TransitionPrimitive =
  | "hardCut" | "sharedCenterReplace" | "persistentLayerSwap" | "uiStateMorph"
  | "cardSelectZoom" | "panelReturn" | "radialObjectMatch" | "gaugeStateAnim"
  | "textHoldAcrossBackgroundCut" | "heroRevealUnderText" | "wordToLogoMorph"
  | "logoMatchCarry" | "textResetLoop" | "scanGlitchReveal" | "urlPlateReveal"
  | "questionToUrlTakeover" | "fadeToBlackBeat" | "cardSwapOverAnchor"
  | "cardRowBuild" | "isolatedHold";

export type VisualBeat = {
  beatId: string;               // "B01"...
  startSec: number;
  endSec: number;               // enforce: endSec - startSec <= 2.5 unless a layer has idleMotion
  sectionId: number;            // matches timecode_index sections 0-18
  entryPrimitive: TransitionPrimitive;
  entryDurationSec: number;     // from transition_primitive_catalog.md typical durations
  layersPersisting: string[];   // layerIds that must not dip in opacity across entry
  layersEntering: string[];
  layersExiting: string[];
  luminanceTarget?: "dark" | "mid" | "bright";  // drives rubric gate 7
  voAnchor?: {                  // loose narration attachment — informational only
    segmentId: string;          // day_log narration segment id
    coupling: "starts" | "continues" | "independent";
  };
};

// ---- Text micro-event track (replaces per-beat `text`) ----
export type TextEvent = {
  atSec: number;
  text: string;                 // <= 8 words, uppercase phrase
  zone: "centerBand" | "caption" | "gaugeLabel" | "urlPlate";
  typeDurationSec: number;      // cursor visible only during this window
  holdSec: number;              // 0.6-1.4 motionless after last character
  exit: "phraseSwap" | "hardCut" | "glitchCollapse" | "persistAcrossCut"
      | "opacityTakeover" | "morphToLogo";
};

// ---- Top-level (extends TrailerProps) ----
export type VisualTrailerProps = TrailerProps & {
  schemaVersion: 2;
  visualLayers: VisualLayer[];
  visualBeats: VisualBeat[];
  textEvents: TextEvent[];      // supersedes textTrack when schemaVersion >= 2
};
```

## Compiler rules for the beat planner

1. **Split every narration segment into 2–4 visual beats.** Template per segment type: text retype (`sharedCenterReplace`), one anchor-preserving change (`persistentLayerSwap` or `uiStateMorph`), optional background cut under held text (`textHoldAcrossBackgroundCut`).
2. **Beat length cap:** 2.5s hard max without `idleMotion`; 4.0s absolute max. A 15s narration segment becomes ≥4 beats, never one.
3. **Persistence quota:** ≥60% of beat entries must list ≥1 `layersPersisting` (rubric gate 3). `hardCut` allowed max once per ~8s.
4. **Cast section is a fixed pattern**, not free-form: for each character emit `panelReturn` (0.6–0.8s, `selectionPanel` layer reused) then `cardSelectZoom` (1.8–2.3s, character layer, `luminanceTarget: "bright"`).
5. **Text:** phrase splitter breaks narration captions into ≤8-word phrases; emit one `TextEvent` per phrase; never two text events typing simultaneously.
6. **Luminance plan:** hook/end sections `dark`, world+cast `bright`, dense-UI `mid`. Validator plots mean luma per second and checks 3 regimes exist.
7. **Duration:** distribute beats within the reference section skeleton (76.6s ±5s); do not derive section length from narration audio length.

## Renderer work implied (gap vs existing components)

| Needed | Status |
|---|---|
| `SharedCenterReplace`, `PersistentLayerSwap`, `UiStateMorph`, `CardSelectZoom`, `RadialObjectMatch`, `QuestionToUrlTakeover`, `PressureGauges`, `MidUrlPlate`, `TypingText` | exist — need to accept layer-referencing props instead of per-beat inline props |
| Layer manager (renders `visualLayers` with independent lifespans; beats only change state) | **new** — core piece |
| `panelReturn`, `textHoldAcrossBackgroundCut`, `heroRevealUnderText`, `wordToLogoMorph`, `textResetLoop`, `scanGlitchReveal` | new but thin — mostly compositions of layer manager + TypingText |
| Rubric validator (gates 1–8) in `validate_trailer.py` | extend existing validator |

## Example: one narration segment compiled correctly

Narration: *"This season, the Pistsov family enters."* (~3.2s)

```json
{
  "visualLayers": [
    {"layerId": "streetClip", "kind": "heroVideo", "src": "Village.mp4", "zone": "fullBleed", "startSec": 31.8, "endSec": 33.0, "idleMotion": "clipPlayback"},
    {"layerId": "porchClip", "kind": "heroVideo", "src": "Family.mp4", "zone": "fullBleed", "startSec": 33.0, "endSec": 35.0, "idleMotion": "clipPlayback"},
    {"layerId": "familyPhoto", "kind": "anchorImage", "src": "Family.png", "zone": "bottom", "startSec": 33.0, "endSec": 35.0}
  ],
  "visualBeats": [
    {"beatId": "B24", "startSec": 31.8, "endSec": 33.0, "sectionId": 8, "entryPrimitive": "heroRevealUnderText", "entryDurationSec": 0.4, "layersPersisting": [], "layersEntering": ["streetClip"], "layersExiting": [], "luminanceTarget": "mid", "voAnchor": {"segmentId": "vo_08", "coupling": "starts"}},
    {"beatId": "B25", "startSec": 33.0, "endSec": 35.0, "sectionId": 8, "entryPrimitive": "textHoldAcrossBackgroundCut", "entryDurationSec": 0.05, "layersPersisting": ["familyPhoto"], "layersEntering": ["porchClip"], "layersExiting": ["streetClip"], "luminanceTarget": "mid", "voAnchor": {"segmentId": "vo_08", "coupling": "continues"}}
  ],
  "textEvents": [
    {"atSec": 31.8, "text": "THIS SEASON", "zone": "centerBand", "typeDurationSec": 0.4, "holdSec": 0.7, "exit": "phraseSwap"},
    {"atSec": 33.0, "text": "THE PISTSOV FAMILY ENTERS", "zone": "centerBand", "typeDurationSec": 0.6, "holdSec": 1.4, "exit": "persistAcrossCut"}
  ]
}
```

One 3.2s narration line → 2 beats, 1 background cut, 1 persisting anchor, 2 typed phrases. The current pipeline would have produced 1 static card.
