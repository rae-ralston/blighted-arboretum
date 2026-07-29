extends Node2D

@onready var line: Line2D = $Line2D

@export var start_node: NetworkNode
@export var end_node: NetworkNode

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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if _is_near_line(get_global_mouse_position(), 10):
				open()

func open() -> void:
	is_open = true
	line.default_color = Color(1.0, 0.7, 0.1)
	line.width = 4.0
