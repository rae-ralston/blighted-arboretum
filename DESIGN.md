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
- Procedural path cost derivation (from length, node types, transformation stage) — prerequisite for map generation

---

## Core Mechanics

### Primary Interaction — Path Opening (Model A)
Each room contains nodes (dead plants, buried bulbs, moisture pools) connected by pre-defined growth channels: cracks in flagstone, exposed root channels, gaps between stones. The player spends **spores** to open a path segment. Opening a path extends the network to the next node, which begins generating spores passively.

The puzzle is in the ordering and routing. Paths branch. Not everything can be opened at once. Some nodes only activate when connected *through* a specific upstream node type — order of operations matters.

**Path costs:** Each path has a spore cost set per-path in the editor (exported variable). This enables bottleneck layouts where a direct route costs more than going around through intermediate nodes. *Long-term: derive cost procedurally from path length, endpoint node types, or transformation stage — needed before map generation is viable.*

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

Each stage generates more spores. Full transformation of a room unlocks the next.

**Trigger:** The player spends spores to advance a node's transformation stage. This competes directly with opening new paths — deepen what you have, or expand outward.

**Interaction:** Click a connected node to advance it to the next stage (if affordable). Unconnected nodes cannot be transformed. A hover panel with node-specific information will be added later; click-to-transform is the initial implementation.

**Spore rate multipliers:** 1x → 1.5x → 2x → 3x across the four stages. Exact values to be tuned by feel.

**Costs:** Progressively more expensive per stage. Exact values TBD — set when implementation begins.

**Node type rules:**
- STANDARD and BONUS nodes: fully transformable in-session via click
- TARGET nodes: transformable in-session, visually distinct from STANDARD
- HEART node: visually distinct, not click-transformable in-session — advancement is a prestige upgrade that persists across runs

**Open questions:**
- Exact spore cost per stage (tune after first implementation)
- Whether BONUS nodes have any transformation quirks or behave identically to STANDARD

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

### 1. Animation
- [x] Pulse shader on active `Line2D` paths
- [x] Crawl animation when opening a path (mycelium spreading along the line)
- [ ] Node awakening animation — tween `draw_radius` 24→38→24 in `set_connected()`
- [ ] Room complete animation — label animates in rather than snapping visible

### 2. Visual Affordance
- [ ] Hover highlight on reachable-but-locked paths
- [ ] Nodes visually distinguish connected vs dormant state
- [ ] "Can't afford" feedback — flash path when clicked without enough spores
- [ ] Path cost visible on hover
- [ ] Spore generation rate display alongside spore counter
- [ ] Restart / reset after room complete

### 3. Room Layout
- [x] Data-driven room layout system (NodeDefinition, PathDefinition, RoomLayout resources + RoomBuilder)
- [ ] Redesign DemoRoom with branching paths and real routing decisions
- [ ] Mix of TARGET and BONUS nodes at meaningful positions
- [ ] At least one path that requires a routing choice

### 4. Win Condition
- [x] Track how many TARGET nodes are connected
- [x] Trigger room complete state when all targets connected
- [x] Room complete UI feedback

### 5. Background + Atmosphere
- [ ] Dark background color on DemoRoom
- [ ] Basic atmosphere pass

### 6. Transformation Arc
- [ ] Add `transformation_stage: int` and `stage_costs: Array[float]` to NetworkNode
- [ ] Click-to-transform on connected STANDARD, BONUS, and TARGET nodes
- [ ] Spore rate multipliers per stage (1x / 1.5x / 2x / 3x)
- [ ] "Can't afford" feedback on node click
- [ ] Node visual states: Dead → Infected → Consumed → Transformed (palette per DESIGN.md)
- [ ] Path visual states matching connected node stages
- [ ] Smooth visual transitions between stages
- [ ] HEART node locked from in-session transformation (prestige upgrade — defer to prestige loop)

### 7. Procedural Aesthetics
- [ ] Fungal node clusters — Polygon2D vertices offset by noise
- [ ] Glow effects via CanvasItem additive blending
- [ ] Room dressing — silhouette Victorian elements (dead topiaries, iron trellises, cracked urns, bare fencing)
- [ ] Particle effects on active nodes and paths

### 8. Meta-map
- [ ] Top-down arboretum overview scene
- [ ] Rooms represented as selectable locations
- [ ] Room unlock on completion — adjacent rooms become available
- [ ] Meta-map visually reflects blight spread room by room

### 9. More Rooms
- [ ] Design 2–3 additional room layouts with distinct routing puzzles
- [ ] Implement using RoomBuilder + RoomLayout resources

### 10. Prestige Loop
- [ ] Seasonal reset — spores, network state, room progress reset
- [ ] Prestige currency (name TBD) earned at run end
- [ ] Permanent upgrade tree (contents TBD — design after meta-map validated)
- [ ] Offline progression — ~50% rate, soft cap at a few minutes' worth

### 11. Deferred
- [ ] Save / load state
- [ ] Sound effects
- [ ] Music

---

## Open Questions

- Prestige currency name (Rot Essence, Spore Memory, etc.)
- Specific contents of the permanent upgrade tree — defer until post-demo
- How many rooms in the first full run? (Target for initial build, not demo)
