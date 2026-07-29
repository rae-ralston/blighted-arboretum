extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.spores_changed.connect(_on_spores_changed)
	_on_spores_changed(GameManager.spores)

func _on_spores_changed(new_amount: float) -> void:
	text = "Spores: %d" % new_amount
