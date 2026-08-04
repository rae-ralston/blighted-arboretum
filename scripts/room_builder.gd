class_name RoomBuilder extends Node2D

@export var layout: RoomLayout
@export var node_scene: PackedScene
@export var path_scene: PackedScene

func _ready() -> void:
	var node_map: Dictionary = {}
	
	#must add nodes first so paths have something to connect to
	for node_def in layout.nodes:
		var node = node_scene.instantiate()
		node.name = node_def.node_name
		node.node_type = node_def.node_type
		node.position = node_def.position
		add_child(node)
		node_map[node_def.node_name] = node
	
	for path_def in layout.paths:
		var path = path_scene.instantiate()
		path.start_node = node_map[path_def.from_node]
		path.end_node = node_map[path_def.to_node]
		path.spore_cost = path_def.spore_cost
		add_child(path)
