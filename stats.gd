extends Node

@export var max_health : int = 1: set = set_max_health
@onready var health = max_health : set = set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = max(1, value)
	if health != null:
		health = min(health, max_health)
		
	emit_signal("max_health_changed", max_health)

func set_health(value: int) -> void:
	health = value
	if health <= 0:
		emit_signal("no_health")
	emit_signal("health_changed", value)

func _ready() -> void:
	health = max_health
