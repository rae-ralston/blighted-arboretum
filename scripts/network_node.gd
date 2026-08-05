extends Area2D
class_name NetworkNode

signal node_connected(node_type: NodeType)

enum	 NodeType { HEART, STANDARD, TARGET, BONUS }

@export var node_type: NodeType = NodeType.STANDARD
@export var spore_rate: float = 1.0

var connected: bool = false

func _ready() -> void:
	if node_type == NodeType.HEART:
		set_connected(true)

func _process(delta: float) -> void:
	if connected:
		GameManager.add_spores(spore_rate * delta)

func _draw() -> void:
	var color: Color = Color(0.9, 0.9, 0.9)
	
	match node_type:
		NodeType.STANDARD:
			color = Color(0.6, 0.3, 0.8)
		NodeType.HEART:
			color = Color(0.6, 0, 0)
		NodeType.TARGET:
			color = Color(0, 0.6, 0.2)
		NodeType.BONUS:
			color = Color(0, 0.6, 0.9)

	draw_circle(Vector2.ZERO, 24.0, color)

func set_connected(value: bool) -> void:
	connected = value
	if value:
		node_connected.emit(node_type)
	queue_redraw()
