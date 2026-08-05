class_name RoomBuilder extends Node2D

signal room_complete

@export var layout: RoomLayout
@export var node_scene: PackedScene
@export var path_scene: PackedScene

var _target_count: int = 0
var _targets_connected: int = 0

func _ready() -> void:
	var node_map: Dictionary = {}
	
	#must add nodes first so paths have something to connect to
	for node_def in layout.nodes:
		var node = node_scene.instantiate()
		node.name = node_def.node_name
		node.node_type = node_def.node_type
		node.position = node_def.position
		node.node_connected.connect(_on_node_connected)
		add_child(node)
		node_map[node_def.node_name] = node
		
		if node_def.node_type == NetworkNode.NodeType.TARGET:
			_target_count += 1
	
	for path_def in layout.paths:
		var path = path_scene.instantiate()
		path.start_node = node_map[path_def.from_node]
		path.end_node = node_map[path_def.to_node]
		path.spore_cost = path_def.spore_cost
		add_child(path)

func _on_node_connected(node_type: NetworkNode.NodeType) -> void:
	if node_type == NetworkNode.NodeType.TARGET:
		_targets_connected += 1
		if _targets_connected >= _target_count:
			room_complete.emit()
