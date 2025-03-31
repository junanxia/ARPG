extends Area2D

const HitEffect = preload("res://Effects/hit_effect.tscn")

signal invincible_started
signal invincible_ended

@onready var timer: Timer = $Timer

var invincible = false: set = set_invincible

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincible_started")
	else:
		emit_signal("invincible_ended")	

func start_invincibleity(duration):
	self.invincible = true
	timer.start(duration)

func create_effect():
	var main = get_tree().current_scene
	var effect = HitEffect.instantiate()
	main.add_child(effect)
	effect.global_position = global_position	

func _on_timer_timeout() -> void:
	self.invincible = false

func _on_invincible_started() -> void:
	set_deferred("monitoring", false)

func _on_invincible_ended() -> void:
	set_deferred("monitoring", true)
