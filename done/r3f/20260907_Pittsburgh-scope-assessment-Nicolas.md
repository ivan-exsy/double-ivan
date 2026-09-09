> **Archived 2026-09-09. Not live.** Breakfasts tracker: double-docs/BREAKFASTS-BOARD.md. Spec: double-docs/MVP-breakfasts.md. Map checklist: double-docs/R3F/TODOs_ivan-nicolas.md.

# Phaser playable map: scope assessment (Nicolas)

**For:** Ivan · **Date:** 2026-09-07 · **Assessing:** your three points from today, to mirror into `MVP-breakfasts.md`
**Assumption behind every hour:** me full time, 12 h/day. "Likely" is the central estimate; the range says what moves it.
**How the numbers were made:** measured on your published files, then re-measured by a second pass that did not see the first.

**Status (2026-09-09):** Homes layout locked in [`MVP-breakfasts.md`](../MVP-breakfasts.md) §1b — livable units; Ivan stamps walls/extra doors. Do **not** treat §0 as live. Ivan checklist: [`TODOs_ivan-nicolas.md`](TODOs_ivan-nicolas.md).

**Status (2026-09-08):** Option A, split. Ivan took plumbing; Nico draws. Shops and the five homes are hollowed; Fifth Avenue door is `[286, 162]`. Canvas is `public/assets/pittsburgh/visuals/downtown.json` (409×437, village tilesets, locked occupancy guide). Village `MainScene` stays on `the_ville`. Object catalog is 46 names; maze still zeros until Nico places. Do not rebuild a blank Tiled file.

> \*\*Read section 0 first.\*\* Two bugs in your generator mean the five interiors do not work today, and no amount of art fixes that.
> \*\*By hand: 45 h, about 4 days.\*\* Range 29 to 73. **(2026-09-08: Tiled document + MainScene retarget, object CSV export, and validator are Ivan’s — not in Nico’s remaining quote.)**
> \*\*With a generator: 93 h, about 8 days.\*\* Range 57 to 156. **Not this cohort.**

\---

## 0\. Two bugs make your five interiors unwalkable

### Bug 1: the hollowing produces a checkerboard

Counting 4-connected components over `interior` and `door` cells in your published `paint.json`:

|||
|-|-|
|interior + door cells|355|
|separate connected components|**350**|
|largest component|**2 cells**|
|components of a single cell|345, which is 99%|

There are no rooms. There are 345 isolated cells and five pairs.

**Cause, `interior.ts:108-127`.** The loop sets `cell.kind = 'interior'` while `isInteriorCandidate` (`:46-50`) requires all four neighbours to still be `kind === 'building'`. The first cell converted stops being `building`, so its neighbour no longer qualifies. One yes, one no, in both directions.

**It blocks, it does not just look wrong.** Your A\* is 4-connected: `path\_finder.py:235` walks `(-1,0), (1,0), (0,-1), (0,1)` and nothing else. Checkerboard cells only touch diagonally.

**And this is the part worth knowing:** when the A\* finds no path, `path\_finder.py:289-293` returns `\[start, end]`. Not a failure, a jump. So a Double sent into PPG Cafe does not get stuck at the door, it teleports across the wall, which is the one thing your own lock rules out.

### Bug 2: the door is punched without checking it reaches the floor

`punchDoor` (`interior.ts:73-85`) walks the pad and takes the first edge cell that touches walkable outdoor. It never checks that the cell also touches interior floor. Post-fix, that leaves one of the five still broken:

||door|touches the floor after the fix|distance to nearest floor|
|-|-|-|-|
|PPG Cafe|`\[273, 221]`|yes|1|
|EQT Supply Store|`\[346, 151]`|yes|1|
|O'Reilly Pub|`\[323, 132]`|yes|1|
|Penn College|`\[267, 130]`|yes|1|
|**Fifth Avenue Market**|`\[289, 161]`|**no**|**3**|

Fixing bug 1 alone gives Fifth Avenue Market 221 walkable cells that nobody can reach. It needs a one-line change too: pick the door among pad cells that touch the floor.

### What the fixes change

Both are small changes in your generator, both touch collision, so both are yours.

||today, checkerboard|after both fixes|
|-|-|-|
|PPG Cafe|40|**95**|
|Fifth Avenue Market|109|221|
|EQT Supply Store|63|141|
|O'Reilly Pub|30|69|
|Penn College|108|229|
|**total**|**350**|**755**|

PPG Cafe at 95 walkable is above the \~74 of village Hobbs you set as the ceiling, so that lock needs a decision from you.

**Why this comes before the art.** Drawing on 350 isolated cells means furnishing rooms nobody can enter, and then redrawing 1,032 cells once they are fixed. That is paying for the drawing twice.

\---

## 1\. Two things about your grid that decide the number

**One Pittsburgh cell is 16 real square metres.** Your `world.json` says `meters\_per\_cell: 1` and `real\_meters\_per\_game\_meter: 4`. A village cell is one square metre. Same tile on screen, sixteen times the ground.

|village room|cells|real m²|Pittsburgh venue|cells (fixed)|real m²|
|-|-|-|-|-|-|
|cafe (Hobbs)|96|96|PPG Cafe|95|1,520|
|store (Willows)|224|224|Fifth Avenue Market|221|3,536|
|supply store (Harvey Oak)|164|164|EQT Supply Store|141|2,256|
|pub (Rose and Crown)|70|70|O'Reilly Pub|69|1,104|
|classroom (Oak Hill)|76|76|Penn College|229|3,664|

In the village a cell is a square metre, so a cell is a chair. In Pittsburgh a cell is 16, so **a cell is not a table, it is a table area**. Placing objects at 4:1 is zoning, not furnishing.

**Pittsburgh is diagonal and the village is not.** Orientation of 313 km of street centreline against your grid axes:

|deviation from nearest axis|share of street length|
|-|-|
|under 5 degrees|11.2%|
|5 to 10|6.3%|
|10 to 15|21.4%|
|25 to 30|20.1%|
|the rest, up to 45|41.0%|

**82.5% of your streets sit more than 10 degrees off the grid**, and the two peaks are the Monongahela and Allegheny grids meeting at an angle, which is the real city. On an orthogonal tilemap that means staircases on every building edge and every kerb. The village kit was drawn for square rooms on straight axes and has no 27 degree case. A person resolves a staircase corner by eye in seconds; a classifier that does it well with an orthogonal kit is exactly the code that goes wrong.

\---

## 2\. The number, two ways

Both assume your two fixes land first, so the canvas is **1,032 cells**: 755 in the five venues and 277 in the homes.

### Option A: draw it by hand. 45 h, about 4 days

Open Tiled, place the tiles, export. About 1,960 placements at village density. The park grass is a fill, not placements.

|Piece|Min|**Likely**|Max|
|-|-|-|-|
|Verify both fixes: diagnose, confirm after you apply them, re-measure the canvas|2|**5**|9|
|Draw the eleven interiors: floors, walls, furniture|10|**15**|24|
|The park: grass by fill, trails and trees by hand|4|**6**|10|
|Build the Tiled document: 409x437 with the 27 tilesets, and retarget `MainScene` off `the\_ville`|3|**5**|8|
|Derive your object CSVs from the drawn tilemap|4|**5**|8|
|Validator, cell by cell, with a known-bad case|3|**4**|6|
|Your eye pass and the fixes|3|**5**|8|
|**Total**|**29**|**45**|**73**|

**Ivan took (2026-09-08), not Nico’s remaining quote:** Tiled canvas (`downtown.json`; village `MainScene` stays `the_ville` — do not retarget, do not start a blank `.tmx`); object export after he places (`npx tsx scripts/export-pittsburgh-objects.ts` — re-run if occupancy generator is rerun, it wipes the catalog); validator (chair on water). Nico’s remaining lines: interiors, park, eye pass.

**What you give up:** repeatability. If you rerun your generator and the pads move, the drawing is redone. A second city starts from zero.

### Option B: build the generator. 93 h, about 8 days

||Likely|Range|
|-|-|-|
|Verify both fixes|5|2 to 9|
|**Shared machinery**, built once|**35**|23 to 56|
|1. Five commercial enterables|13|8 to 21|
|2. Homes|11|6 to 17|
|3. Point State Park|26|16 to 48|
|Extra eye pass for the larger canvas|3|2 to 5|
|**Total**|**93**|57 to 156|

**Shared machinery, 35 h:** the name-to-art table derived from `the\_ville` (3), the wall classifier (10), the placement engine (9), writing the CSVs and regenerating `maze\_registry` (3), the Tiled document and the `MainScene` retarget (6), the validator (4).

\---

## 3\. Four things in the scope that do not hold as written

**First \& Market Apt 1 to 5 do not exist.** Your grid has one sector, `First \& Market Apartments`, 50 cells, 24 interior after the fix. Five apartments would be under 5 cells each, against roughly 37 for a village apartment.

**Star Loft cannot be hollowed.** 11 cells of pad, and not one has all four neighbours inside it, so the rule yields **0** interior cells with or without the fixes.

So point 2 is six sectors, not ten:

||pad|interior after the fix|real m²|
|-|-|-|-|
|Roosevelt Building|116|79|1,264|
|Encore on 7th|115|75|1,200|
|Gateway Tower|116|72|1,152|
|Midtown Tower|53|27|432|
|First \& Market Apartments|50|24|384|
|Star Loft|11|**0**|0|

Your `VILLE\_SIM\_BUILDINGS` recipes have minimums from 104 to 288 cells, and three of these six are under that.

**`Residence 1` to `15` do not exist anywhere in the grid.** Not in `sector\_blocks.csv`, not in `arena\_blocks.csv`, not in `maze\_registry.json`, not in the code. The only match is `YWCA Residence`, an OSM sector. Both spawn layers are empty as well: `spawning\_location\_maze.csv` has zero non-zero values out of 178,733, and its blocks file is 1 byte. So the brief's premise that they are spawn markers has nothing behind it, and join has nothing to read.

**The only outdoor kit you have is the village one.** Which tileset feeds which layer:

|layer|source|
|-|-|
|Exterior Ground|CuteRPG Field, Village, Mountains, Desert. No LimeZu at all|
|Exterior Decoration L1 and L2|CuteRPG Forest, Field, Desert, Village|
|Wall|Room\_Builder, 1,429 of 1,429|
|Interior Ground|Room\_Builder 1,206, CuteRPG Field 1,023|

Walls are fully LimeZu and safe. Exteriors are entirely the small-town kit, and `Pitts\_Phaser.md:90` says not to copy the medieval kit village into Pittsburgh. Even interior floors are 46% CuteRPG, so the floor is a choice too. The estimate assumes the park reads like a town park; an urban set instead pushes that line from 4 h to 12 or more.

\---

## 4\. What "copy furniture from reference places" can and cannot mean

None of the five destinations shares the shape of its source: PPG Cafe is the triangular footprint of One PPG Place, not a 12 by 8 room. So the layout cannot be transplanted cell for cell.

**What travels is the repertoire and the density.** A cafe has tables, customer seating, behind-the-counter, refrigerator and cooking area at 0.23 objects per cell, which gives PPG Cafe about 22 objects across its 95 cells.

The mapping is not manual. Crossing your `game\_object\_maze` with the art layers, **45 of your 46 object names** resolve to their tiles automatically, across 493 of 680 cells. Nobody has to open a tileset and identify pieces by eye.

Walls are the opposite. Your Tiled has no wangsets, no terrains and no tile properties, so nothing says which piece is a corner. Deriving it from village usage: of 107 wall pieces, **64 have one consistent neighbour pattern and 43 do not**, which is 724 of 1,429 cells. That is why the wall classifier is the largest line in option B.

\---

## 5\. What happens to everything you did not name

Your three points touch **6,975 of the 178,733 cells in the grid, which is 3.9%**: the eleven pads at 1,481 cells, plus the 5,494 of the Point State Park sector. The map as a whole:

|class|cells|share|
|-|-|-|
|water, the three rivers|57,000|31.9%|
|woods, the far shores|51,118|28.6%|
|highway|29,650|16.6%|
|park|19,730|11.0%|
|building|10,078|5.6%|
|open|9,104|5.1%|
|border|1,688|0.9%|
|interior, door, furniture|365|0.2%|

I read "everything else: sealed pads or walkable hollow" as: **that stays exactly as it looks today.** What lands is your current map with eleven buildings opened up and furnished, plus the park. Streets stay beige strips, rivers stay flat blue, the far shores stay dark green, the other pads stay brown rectangles.

If you were picturing drawn streets with kerbs and crossings, rivers with banks, the bridges, and the rest of the buildings with roofs, that is a different scope and a different number, and it needs art that does not exist: your exterior tiles have dirt paths rather than urban asphalt, and nothing in the village uses a steel bridge or a river of 57,000 cells.

**So: does the other 96.1% stay as it is today, or is it in?**

\---

## 6\. Price

At **$30/hour**, against the same bands.

||Hours|Min|Likely|Max|
|-|-|-|-|-|
|**A. By hand**|29 / 45 / 73|$870|**$1,350**|$2,190|
|**B. Generator**|57 / 93 / 156|$1,710|**$2,790**|$4,680|

\---

## 7\. Out of scope, and what stays yours

Collision, your walk grid and your pathfinding, including both fixes in section 0. Cap 6, 4:1 and the door rules stay as they are. I draw on the files; if art and walk disagree I fix the picture or ask you first.

**Current (2026-09-08):** Ivan owns occupancy, Tiled canvas, export, validator, ingest. Nico draws furniture and the park as a place. Home connectivity check is welcome; do not change collision.

Not hollowing Wood Street Studios, Academic Hall Dorm, YWCA or Penn Avenue Library, as you said. Not the facade and height work: `Pitts\_Phaser.md` phases B onward stay parked while this lands.

\---

## 8\. What I would do

**Your two fixes first, then option A.** At this scope the by-hand route is half the cost, it fits the week, and eleven interiors plus one park is not enough surface for a generator to pay for itself. The diagonal grid pushes the same way: it is the kind of problem a person solves by eye and a classifier gets wrong.

The generator only wins if more buildings, another city, or moving pads are coming. If any of that is on the way, say so now and I build B instead, because doing A first and B later means paying for the drawing twice.

Either way, the object layer is what turns Doubles from walking to doing. Today `game\_object\_blocks.csv` is 1 byte and `game\_object\_maze` is all zeros, so even with the rooms fixed, a Double reaches PPG Cafe and has nothing to sit at.

**Current (2026-09-08):** catalog is **46** Downtown names (village ids). Maze is still all zeros until Nico places furniture in Tiled. That last sentence was true of the empty occupancy pack; it is not true of the catalog.

