extends Area2D

@export var show_hit : bool = true

const HitEffect = preload("res://Effects/hit_effect.tscn")

func _on_area_entered(_area: Area2D) -> void:
	if show_hit:
		var main = get_tree().current_scene
		var effect = HitEffect.instantiate()
		main.add_child(effect)
		effect.global_position = global_position
