extends Node2D

@onready var start_position = global_position
@export var target_position = start_position
@export var wander_range : int = 32
@onready var timer: Timer = $Timer

func _ready():
	target_position = start_position
	
func update_target_position():
	var target_vec = Vector2(randi_range(-wander_range, wander_range), randi_range(-wander_range, wander_range))
	target_position = start_position + target_vec

func start_timer(duration):
	timer.start(duration)
	
func get_left_time():
	return timer.time_left

func _on_timer_timeout() -> void:
	update_target_position()
