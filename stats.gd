extends Node

@export var max_health : int = 1
@onready var health = max_health : set = set_health

signal no_health

func set_health(value: int) -> void:
	health = value
	if health <= 0:
		emit_signal("no_health")
