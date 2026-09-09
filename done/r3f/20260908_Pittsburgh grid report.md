> **Archived 2026-09-09. Not live.** Breakfasts tracker: double-docs/BREAKFASTS-BOARD.md. Spec: double-docs/MVP-breakfasts.md. Map checklist: double-docs/R3F/TODOs_ivan-nicolas.md.

# The grid under Pittsburgh, and what it costs

**For:** Ivan · **From:** Nicolas · **2026-09-08**

I hit this while drawing PPG Cafe. It is not a change of plan and it does not block Saturday. I am
still drawing. But it is worth ten minutes of your time before we furnish ten more rooms.

---

## The short version

Pittsburgh's streets run at four different angles, and the two main ones are **45.6 degrees apart**.
On a square tilemap that is the worst case that exists, not a hard case. Every building edge comes out
as a staircase, and since the A* walks in four directions only, the Doubles walk that staircase too.

**No rotation fixes it.** Sweeping all 900 candidate angles, the best one aligns **38.2%** of the
street length. None reaches 50%.

**In a city with one street grid, the same sweep reaches 89 to 97%.**

The question is yours: **is Pittsburgh a requirement, or was it a sample?**

---

## 1. The numbers

Street centrelines inside your `world.json` bbox, weighted by length, angles modulo 90.
Aligned means within 5 degrees of an axis.


|                                              | Pittsburgh       |
| -------------------------------------------- | ---------------- |
| street length aligned to the axes today      | **1.6%**         |
| distinct grid directions holding 10% or more | **4**            |
| angle between the two main ones              | **45.6 degrees** |
| best rotation of the sampling grid           | **38.2%**        |


**Why 45.6 is the number that matters.** Angles repeat every 90 degrees, so two directions can never be
further apart than 45. Yours are at 45.6. Any rotation that aligns one grid puts the other exactly on
the diagonal. There is no clever angle here.

The four directions are the real city. Smithfield, Fort Pitt Boulevard and Forbes run in one. Penn,
Liberty and Fort Duquesne run in the other. Mount Washington and the south bank add two more. **The
second screenshot has them drawn over your own map.**

One note in case you compare against the assessment I sent yesterday, which said 82.5%. Same
definition, same threshold, wider area: that measured 313 km of centreline, most of Pittsburgh. Inside
your bbox there are 29 km, and the figure there is **91.9%**. Both are right for what they measured.
The one that describes the rectangle players see is 91.9%.

---

## 2. What it does to the walking

I ran your own `path_finder()` over 25 door to door routes here and 25 equivalent routes in the
village. All 50 found a path, none teleported.


|                                     | village        | Pittsburgh     |
| ----------------------------------- | -------------- | -------------- |
| average straight run before turning | **6.37 cells** | **3.28 cells** |
| forced turns per 100 cells          | 5.39           | **14.10**      |


A Double here is forced to turn **2.62 times more often**, meaning going straight was actually blocked.
Motion is smooth, the waypoints interpolate and the frontend tweens. The shape of the path is the
staircase.

**Two honest caveats, because they cut against my own argument.**

**Half the zigzag is not the city.** Of the turns I counted, 404 were forced and **445 were not**:
straight ahead was open and the path turned anyway. On a 4 connected grid with uniform cost, while
distance remains on both axes, going straight and turning cost the same, so the heap breaks the tie
rather than the map. **That half survives any city.** The lever for it is a turn penalty or a stable tie
break favouring the current heading. I have not measured what that would buy.

**Eight directions makes it worse.** I ran three readings of that change over the same routes. The
straight run goes from 3.28 to 2.46, 2.18 and 2.77. All down. Normalised by distance travelled it turns
30.7 times per 100 against 29.6 today. The measurement does show the gain where it exists: in a one cell
wide diagonal corridor it takes the straight run from 1.00 to 29.00. Your streets are wide, and on a
wide street four more directions mostly add ties.

Even at its best rotation, Pittsburgh reaches 5.43 and still does not match the village's 6.37. The
village rotated peaks exactly at 0 degrees, which is what an aligned city should do.

---

## 3. Other cities, same measurement

Same bbox size as yours, 1,635 by 1,748 metres, centred downtown.


| city               | grid directions | aligned today | best rotation |
| ------------------ | --------------- | ------------- | ------------- |
| Salt Lake City     | 1               | 96.5%         | 96.7%         |
| Phoenix            | 1               | 93.4%         | 93.6%         |
| Chicago, the Loop  | 1               | 89.1%         | 89.4%         |
| Manhattan, Midtown | 1               | 0.1%          | **97.4%**     |
| **Pittsburgh**     | **4**           | **1.6%**      | **38.2%**     |


Chicago, Phoenix and Salt Lake City work as they are, no change to anything.

**Manhattan is the best of all of them, and getting there is small.** It needs the sampling to be
rotated 29 degrees when the world is rasterised. That is not a change to the grid: the output is still
409 by 437 axis aligned cells, and collision, sectors, arenas, the A* and the tilemap all see exactly
what they see today. The only difference is which piece of the world lands in which cell. Today
`lonLatToLocalMeters` scales each axis independently and there is no angle in `OsmWorld` or
`RasterOptions`, so it is roughly ten lines across two functions.

Two consequences worth naming. A rotated sample over an unrotated bbox leaves empty corners, so the
fetch needs a slightly larger box. And `mazeSize` is derived from the bbox, so it needs to follow.

**This is also why rotation does not rescue Pittsburgh.** The mechanism is fine. There is simply no
single angle here, because there are four grids and the two big ones are at the maximum separation.

---

## 4. What it would cost

**Almost all of it is yours, and almost none of it is new work.** You pick the city and the bbox, run
the pipeline you already have, and publish the grid. We draw on whatever you publish.

**One thing has to move first.** `isDowntownSimPad` accepts pads only between latitude 40.4355 and
40.4455, and `place-osm-pittsburgh.ts:21` always passes it. Run against a Chicago bbox, the pipeline
produced **0 enterable buildings with no error and no warning**. With the filter off, 5 of 10 survive.
Small change, but it will cost someone a day if they meet it cold.

**What is not affected.** Your `interior.ts` never mentions longitude, latitude or a bbox. It works on
the cell grid it is handed, so **the hollowing, the door fix and the furniture fix all survive a city
change untouched.** And the backend has not ingested Pittsburgh yet, `maze.py` still points at
`the_ville/`, so the expensive half is unpaid in either city.

On our side the drawing is scripted, so it re-runs on whatever grid you publish. PPG Cafe is the first
screenshot.

---

## What I need from you

**One answer: is Pittsburgh a requirement or a diff city would be better?**