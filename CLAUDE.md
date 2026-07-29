# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Blighted Arboretum — an incremental puzzle game in Godot 4.6. The player is a fungal blight spreading through an abandoned Victorian arboretum. Core loop: passive spore generation from connected nodes, spent to open path segments that connect new nodes. See `DESIGN.md` for full game design documentation.

## Running the Game

Open the project in Godot 4.6 and press F5, or use Project → Run. There is no CLI build step. The main scene is `scenes/rooms/DemoRoom.tscn`.

## Architecture

### Autoload
`GameManager` (scripts/game_manager.gd) is registered as a singleton autoload. It owns the spore resource and emits `spores_changed(new_amount: float)` whenever the value changes. All nodes read/write spores through GameManager — never directly between each other.

### Component Scenes
Two reusable components in `scenes/components/`:

**NetworkNode** (`scripts/network_node.gd`) — `Area2D` with `class_name NetworkNode`. Manages node type (`HEART/STANDARD/TARGET/BONUS`), connection state, and spore generation via `_process`. HEART nodes auto-connect in `_ready()`. Visual state is drawn via `_draw()`; call `queue_redraw()` after any state change, never from inside `_draw()`.

**PathSegment** (`scripts/path_segment.gd`) — `Node2D` containing a `Line2D`. Holds references to two `NetworkNode` endpoints. Click detection uses mathematical distance-to-segment (not physics), checked in `_unhandled_input`. Opening a path requires: not already open, reachable (one endpoint connected), and sufficient spores. On open, connects the unconnected endpoint.

### Room Structure
Rooms (e.g. `scenes/rooms/DemoRoom.tscn`) contain:
- A `Node2D` group holding all `NetworkNode` and `PathSegment` instances
- A `CanvasLayer` → `Label` for UI (spore counter via `scripts/ui_spore_count.gd`)

PathSegments reference their endpoint nodes via exported `NodePath`s, resolved at runtime. Both nodes and paths are siblings under the same parent — path position must stay at `(0,0)` so `global_position` comparisons between nodes and paths are consistent.

### Coordinate Space
`PathSegment` uses `global_position` (not `position`) for both line drawing and click detection. This keeps them consistent and future-proofs against camera or nested scene changes.

## Role Note

The developer is learning Godot and GDScript. The assistant role on this project is teacher and guide — explain concepts and approaches, review code, identify issues. Do not write or modify code unless explicitly asked.
