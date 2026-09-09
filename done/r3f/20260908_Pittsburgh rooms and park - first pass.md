> **Archived 2026-09-09. Not live.** Breakfasts tracker: double-docs/BREAKFASTS-BOARD.md. Spec: double-docs/MVP-breakfasts.md. Map checklist: double-docs/R3F/TODOs_ivan-nicolas.md.

# Pittsburgh: the eleven rooms and the park — first pass

**For:** Ivan · **From:** Nicolas · **2026-09-08**

**This is a first pass, not the finished work.** Everything is drawn and every room is walkable, but
the hand pass over the placements has not happened yet. Section 6 says what that step is and what it
can and cannot change.

---

## 1. The split we agreed, item by item

**Your side, from your message on the 8th:** preview wiring, object-file export, validator, hollowing
the five home pads, roofs off. **My side:** furniture, the park as a place, and the five homes, with
homes replacing plumbing rather than adding to it.

### Mine

| | |
|---|---|
| **Furnish the five shops, PPG Cafe first** | done. PPG, Fifth Avenue Market, EQT Supply Store, O'Reilly Pub, Penn College |
| **Point State Park as a readable park** | done. Grass, the fountain esplanade, trees, benches and rock |
| **Furnish the five homes**, two Doubles per building | done on the pads you hollowed. First & Market takes one bed, see section 2 |

### Yours

| | |
|---|---|
| Hollowing the five home pads | done by you, and I drew on them |
| Clearing the placeholder furniture that sealed PPG and First & Market | done by you |
| Object-file export | yours, still to run over the drawing |
| Validator | yours |
| Roofs off in the preview | done |
| **Preview wiring** | **I did this one, see below** |

### The one thing of yours I did, because nothing was visible without it

**The preview was not rendering a single drawn tile, for two separate reasons.** I could not check my
own work, let alone hand you something to glance at, so I fixed both rather than wait.

1. **`downtown.json` was saving its layers as base64 with zlib.** Phaser cannot read compressed layer
   data: it skipped all eleven layers and fell back to the flat `paint.json` image. Anything drawn was
   invisible. The file is now saved as CSV, which is what `the_ville` uses.
2. **The preview loaded the extruded tilesets without their margin and spacing.** Phaser then reads
   seventeen columns where the sheets have sixteen, so every gid resolves to a different tile. The cafe
   rendered as a bedroom. `components/DowntownPreviewCanvas.tsx` now passes `margin 1, spacing 2`, the
   same way `scenes/MainScene.ts:452` already did.

**Both are on your side of the split and both are counted in my hours.** Take them or redo them your
way; I am flagging them rather than folding them in quietly.

---

## 2. What is on the map

Eleven sectors, `9,574` cells across the drawing layers of `downtown.json`.

| | cells | |
|---|---:|---|
| PPG Cafe | 219 | tables and chairs, counter with stools, kitchen behind it, piano |
| Fifth Avenue Market | 460 | shelving aisles, produce cases, counter, flowers |
| EQT Supply Store | 311 | product shelving, counter |
| O'Reilly Pub | 157 | bar with stools, kitchen behind |
| Penn College | 465 | desks in rows, blackboards, podium |
| Roosevelt · Encore · Gateway | 172 · 170 · 170 | two sleeping areas each, kitchen, bathroom, dining table |
| Midtown Tower | 75 | two beds, bathroom |
| First & Market Apartments | 67 | one bed, bathroom, kitchen |
| Point State Park | 7,308 | grass, the fountain esplanade, 535 placements of tree, bush, bench and rock |

Every room's floor is one connected component reachable from the door you published, and that is
checked on every write rather than once at the end.

**Two results came out of the pads rather than out of the drawing.**

**First & Market holds one bed, not two.** Its interior is 25 cells and the usable room is 4 by 4. The
smallest bed in the village kit is 2 by 4, and two of them fill the room and disconnect the floor. So
the five homes hold nine Doubles, not ten.

**Midtown and First & Market carry four and five object names**, against eight in the poorest village
dwelling. Same reason: 28 and 25 cells, and two beds already take twelve.

---

## 3. How the placement works

**The repertoire and the relationships come from your village, measured, and are asserted before
anything is drawn.** Where each chair sits relative to its table, the spacing of stools along a bar,
the sink one row below the rack, the standing row of every piece. If the village does not measure a
relation, the run stops rather than guessing at it.

**Placement is chosen by rule, not piece by piece.** The room is zoned first from the pad shape and
the door position, then whole groups are placed into the zones: a table with its chairs is one unit,
a bar with its stools is one unit.

**Wall pieces come from a table derived from your village map**: for each ring cell, its four
neighbours plus which side the floor is on. **414 of 428 wall cells resolve by that rule.** The other
14 are corners the kit has no piece for; they are listed cell by cell with the reason.

**Then it is rendered, looked at, and corrected against what the render shows**, and that cycle
repeats. Some things only the picture catches: a room can pass every numeric check and still read as
one solid mass of furniture with an empty half. The stopping rule is a zone far below its village
equivalent, a large patch of floor with nothing near it, or a group that does not read as a group.

**Density follows the village**, per your note. PPG Cafe sits at village cafe level, the shops came
out at or above their village equivalents, and the homes are at the top of the village range.

---

## 4. What was not touched

**No walk file was modified. `collision_maze.csv`, `paint.json`, `sector_maze.csv`, `arena_maze.csv`
and the block files are byte identical to what you published**, checked by hash against
`origin/pittsburgh`. The only file changed under `public/assets/pittsburgh/` is `visuals/downtown.json`.

Nothing was drawn outside the eleven sectors: **zero cells in Star Loft, on Residence 1 to 15, or
anywhere else on the map.** The occupancy guide layer is byte identical. The Tiled scaffold was not
re-run.

Outside the assets, the two preview changes described in section 1.

---

## 5. What needs you: the colliders

Nothing in Pittsburgh blocks. In your village, Hobbs Cafe has 53 cells of furniture art and 18 of them
block: the counter and the fridge are solid, the chairs and the table tops are not. Here a Double
walks straight through the bar, the counter and the fridge.

It does not carry over because `collision_maze.csv` comes from the OSM raster in `emit.ts:102-104`,
not from the tilemap, so drawing a counter writes no collision anywhere.

**The cell list is ready: 239 cells across the eleven rooms**, derived from your village piece by
piece, and checked so that with all of them blocked every room stays one connected component reachable
from its door. **232 are measured against the village. 7 are declared**, marked as such in the file with
the piece and the reason: they are bed headboards, where the village always has the piece against a
wall and its collision cannot be told apart from the wall's.

Every declared cell carries its origin and its reason in the file, so you can see which part of the
list is measurement and which part is my judgement before you apply any of it.

### The two kinds of object, because it decides where a piece can go

`game_object_maze` does not mark where the furniture is. It marks the cell the agent occupies while
using it. In the village, 0 of 680 game objects sit on a blocked cell.

| | the agent | the object cell |
|---|---|---|
| **stands on it** | bed, chair, shower, toilet | on the art itself |
| **stands beside it** | counter, fridge, cooking area, sink | on the floor next to the art, usually one tile below |

So a fridge can have its body against the wall and its object cell on the free floor in front. A bed
cannot: the whole piece has to be on floor, because the agent lies on it.

Both were measured across the village per object name, with the instances that go the other way listed
individually rather than averaged.

---

## 6. Where the rooms stand, and what is still to come

**What is left is my own pass by hand: sitting with each room and moving individual tiles by eye.**
Everything up to here was placed by rule and then reviewed against renders. The last step is the one
where I go in myself and fix the details that only reading the picture catches. That has not happened
yet, and it is what I would do next.

**How the rooms measure against your village, with the same code run on both sides.** The measure is
how much of the furniture sits against a wall, which is the thing the village does and we did not.

**The homes are there.** Compared against village dwellings of their own kind, all five are inside the
range. That split matters: village dwellings with a dining table sit at 56 to 76 percent, those
without sit at 77 to 94, and the two groups do not overlap. Our three large homes have a dining table
and measure 61 to 63, at the median of their group. The two small ones measure 85 and 91, above the
median of theirs.

**O'Reilly Pub is there too**, on every measure.

**Penn College sits just under, and it is a trade-off rather than a defect.** Pushing the desks
against the wall passes that measure and welds them into one block; keeping them in straight rows with
aisles reads as a classroom and costs six points of wall contact. I chose the rows. Both arrangements
were measured.

**PPG Cafe has a real ceiling and it comes from the shape.** Of the 38 arrangements that keep the room
walkable, none does better than what is there now. **There are 20 positions where a piece fits except
for one or two cells, and those cells are wall.** The large table reaches 4 of its 14 cells against a
wall. That is the diamond footprint: a rectangle does not fit against a stepped edge that turns.

Worth saying, because it cuts against the obvious explanation: **the staircase is not a general
problem.** Measured piece by piece, Penn College and O'Reilly Pub have zero pieces blocked by it. A
staircase that only steps one way does not stop a piece sliding along it. What stops a piece is a
notch, and only the cafe's footprint has them.

**One structural difference worth naming, because the lever is yours.** Village dwellings have interior
partitions, so most of their floor is next to a wall: 54 to 78 percent of their floor cells touch one,
against 39 to 76 here. Our pads are open shells with only a perimeter. It is not costing us on the
measurements above, but it is why a home reads as one open floor rather than two rooms. **If you want
the homes to read as two bedrooms, which was the point of two Doubles per building, that is the change:
a partition with a doorway inside the larger pads.** Those would be new `building` cells in
`paint.json`, which is a walk file, so it is not something I will touch.

One case where the pad shape prevents something outright: **in Gateway Tower the dining set is a 4 by 4
island and there is no position on that pad where it does not touch the perimeter**, because the pad is
a ribbon two to four cells wide. In the village that piece sits clear of the walls in 14 of 14
instances.

**One change you should know about before you look at the classroom.** Penn College went from 33 desks
to 26 when the rows were straightened, which is 28 fewer `classroom student seating` cells in the object
export. Two stools added to the pub give back two, so the net is 26 fewer object cells across the map.
Nothing else moved: no new unknown gids and no new violations.

---

## 7. Hours

**2026-09-07, invoiced separately as agreed**

| | h |
|---|---:|
| Review and analysis of the published files | 1.0 |
| Planning and back and forth | 1.0 |
| | **2.0** |

**2026-09-08, against the 35 hour estimate**

| | h |
|---|---:|
| Measuring the pads, the doors and reachability from each door | 0.5 |
| Getting the tilemap to render at all, the two preview items in section 1 | 0.5 |
| Building the room repertoires out of your village, piece by piece | 1.0 |
| Drawing the five shops | 1.5 |
| Drawing the five homes | 1.0 |
| Point State Park | 0.8 |
| Walls across the ten rooms | 0.7 |
| Review passes and corrections against the renders | 1.5 |
| | **7.5** |

| | h |
|---|---:|
| **Total so far** | **9.5** |
