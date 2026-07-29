extends Node

signal spores_changed(new_amount: float)
var spores: float = 0.0

func add_spores(amount: float) -> void:
	spores += amount
	spores_changed.emit(spores)

func spend_spores(amount: float) -> void:
	spores -= amount
	spores_changed.emit(spores)

func can_spend_spores(amount: float) -> bool:
	return spores >= amount
