# Blighted Arboretum — Design Document

## Concept

An incremental puzzle game in Godot. The player is a fungal blight — a spreading network consuming and transforming an abandoned Victorian arboretum. The blight is not destruction: it is transformation. Something run-down and broken becomes something strange and alive.

**Tone:** Dark fairy tale. Decay becoming beauty. Not horror.

---

## Structure

### Meta-Map
A top-down overview of the arboretum grounds. Rooms (the rose garden, the greenhouse, the hedge maze, etc.) appear as distinct locations. As the blight spreads, the overview visually reflects the transformation room by room. The player selects a room from the meta-map to zoom in and play its puzzle.

### Rooms
Individual puzzle spaces — each is a self-contained Godot scene. Hand-crafted layouts. Clear progression gates: completing a room unlocks adjacent rooms on the meta-map.

- **Origin:** each room has a single heart node. The blight starts there and spreads outward — no starting anywhere.
- **Path visibility:** all paths and nodes are visible from the start, but dim/dormant until opened. The player sees the full puzzle; the act of playing is lighting it up.
- **Win condition:** rooms have required target nodes (must connect to complete) and optional bonus nodes (generate extra spores, reward optimization). Completion is clear; thoroughness is rewarded.

### Prestige
The garden resets seasonally. The blight's network carries forward in strength. Each reset, the arboretum is restored — and consumed again, faster.

**What resets:** spore count, network state, room progress.

**What carries over:** a prestige currency (name TBD — *Rot Essence*, *Spore Memory*, etc.) earned at run's end, spent on a permanent upgrade tree. Unlocked room types and node types also persist — once discovered, always available.

**Upgrade tree shape:** a mix of *speed* upgrades (same game, faster) and *capability* upgrades (new things you can do). Specifics to be designed after the demo is validated.

**Offline progression:** spores accumulate at ~50% rate while away, softly capped at a few minutes' worth. Rewards returning without making the routing puzzle irrelevant. *Defer implementation until post-demo.*

**Stretch / expansion goals (not in scope for initial build):**
- Procedural room arrangement on the meta-map (map generation)
- Depth layer: going underground after consuming the surface
- Adjacent estates: spreading beyond the arboretum

---

## Core Mechanics

### Primary Interaction — Path Opening (Model A)
Each room contains nodes (dead plants, buried bulbs, moisture pools) connected by pre-defined growth channels: cracks in flagstone, exposed root channels, gaps between stones. The player spends **spores** to open a path segment. Opening a path extends the network to the next node, which begins generating spores passively.

The puzzle is in the ordering and routing. Paths branch. Not everything can be opened at once. Some nodes only activate when connected *through* a specific upstream node type — order of operations matters.

### Depth Layer — Node Placement (light Model B)
Unlocked through upgrades. Special fungal node types can be placed along open paths to modify flow: amplifiers, spreaders, catalysts. This layer adds combinatorial depth without being the core interaction.

### Resource: Spores
- Generated passively by connected nodes
- Spent to open path segments and buy upgrades
- The primary currency through prestige

### Transformation Arc
Nodes and sections of the arboretum move through visual states:

```
Dead → Infected → Consumed → Transformed
```

Each state generates more spores. Full transformation of a room unlocks the next.

---

## Visual Direction

### Palette (shifts by transformation stage)
| Stage | Colors |
|---|---|
| Dead | Near-black, grey, muted brown |
| Infected | Sickly amber, dull green |
| Consumed | Deep teal, bioluminescent green |
| Transformed | Vivid violet, blue-white |

### Art Approach
- Dark backgrounds hide complexity — deep soil and stone tones
- Silhouette-based Victorian garden elements: dead topiaries, iron trellises, cracked urns, bare iron fencing. High contrast, forgiving to execute.
- Mycelium lines are **procedural** — generated in Godot, not hand-drawn
- Glow effects on dark backgrounds via `CanvasItem` additive blending
- Fungal node clusters: `Polygon2D` vertices offset by noise — no hand-drawing required

### Procedural Animation (target)
- **Crawl:** mycelium visibly threads along a path over 1–2 seconds when opened
- **Pulse:** recurring wave animation flows along active paths, making the network feel alive at idle

---

## Development Approach

### Order of Work
1. **Demo** — placeholder shapes + pulse shader + routing mechanic. Prove the feel.
2. **Validate** — is the pacing right? Does opening paths feel satisfying?
3. **Procedural aesthetics** — grow the art from code: fungal clusters, crawl animation, particles
4. **Room dressing** — silhouette assets for the arboretum setting
5. **Meta-map + prestige** — once one room feels complete

### Demo Scope (one room, ~5 minutes of content)
- Single hand-placed room layout
- Colored `Polygon2D` circles for nodes, `Line2D` for paths
- Instant path open + pulse shader on active lines
- Spore counter, passive generation from connected nodes
- No upgrades, no transformation stages — just the routing loop

### Placeholder Art for Demo
- Nodes: flat colored circles
- Paths: plain `Line2D`
- Pulse: UV-offset shader on active `Line2D` (code, not art)

---

## Build TODO

### 1. Animation (highest impact on feel)
- [ ] Pulse shader on active `Line2D` paths
- [ ] Crawl animation when opening a path (mycelium spreading along the line)
- [ ] Node awakening animation when a node becomes connected

### 2. Visual Affordance (makes the puzzle readable)
- [ ] Hover highlight on reachable-but-locked paths
- [ ] Nodes visually distinguish connected vs dormant state
- [ ] "Can't afford" feedback when clicking a path without enough spores

### 3. Room Layout (reveals puzzle depth)
- [ ] Redesign DemoRoom with branching paths and real routing decisions
- [ ] Mix of TARGET and BONUS nodes at meaningful positions
- [ ] At least one path that requires a routing choice

### 4. Win Condition (gives the room purpose)
- [ ] Track how many TARGET nodes are connected
- [ ] Trigger room complete state when all targets connected
- [ ] Room complete UI feedback

### 5. Background + Atmosphere (cheap wins)
- [ ] Dark background color on DemoRoom
- [ ] Basic atmosphere pass once above items are in

---

## Open Questions

- Prestige currency name (Rot Essence, Spore Memory, etc.)
- Specific contents of the permanent upgrade tree — defer until post-demo
- How many rooms in the first full run? (Target for initial build, not demo)
