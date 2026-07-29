extends Node2D

@onready var line: Line2D = $Line2D

@export var start_node: NetworkNode
@export var end_node: NetworkNode
@export var spore_cost: float = 10.0

var is_open: bool = false

func _ready() -> void:
	line.points = [start_node.global_position, end_node.global_position]
	line.default_color = Color(0.2, 0.1, 0.2)
	line.width = 2.0

func _is_near_line(point: Vector2, threshold: float) -> bool:
	var segment_start = start_node.global_position
	var segment_end = end_node.global_position
	var segment_dir = segment_end - segment_start
	var to_point = point - segment_start
	
	var projection = to_point.dot(segment_dir) / segment_dir.dot(segment_dir)
	projection = clamp(projection, 0.0, 1.0)
	var closest_point = segment_start + projection * segment_dir
	
	return point.distance_to(closest_point) < threshold

func _click_is_near_line(event: InputEvent) -> bool:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if _is_near_line(get_global_mouse_position(), 10):
				return true
	return false

func _is_reachable() -> bool:
	return start_node.is_connected or end_node.is_connected

func _unhandled_input(event: InputEvent) -> void:
	if _click_is_near_line(event):
		if not is_open and _is_reachable():
			if GameManager.can_spend_spores(spore_cost):
				open()

func open() -> void:
	is_open = true
	GameManager.spend_spores(spore_cost)
	
	if start_node.is_connected:
		end_node.set_connected(true)
	else:
		start_node.set_connected(true)
	
	line.default_color = Color(1.0, 0.7, 0.1)
	line.width = 4.0
