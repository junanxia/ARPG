extends CharacterBody2D

@export var ACCELERATION : int = 230
@export var MAX_SPEED : int = 50
@export var FRICTION : int = 200

@onready var stats: Node = $Stats
@onready var player_detection_zone: Area2D = $PlayerDetectionZone
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var hurtbox: Area2D = $Hurtbox

const Effect = preload("res://Effects/enemy_death_effect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

func create_effect():
	var effect = Effect.instantiate()
	get_parent().add_child(effect)
	effect.position = position

func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	move_and_slide()
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				var vec = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(vec * MAX_SPEED, ACCELERATION * delta)
				animated_sprite.flip_h = velocity.x < 0
			else:
				state = IDLE
			
	move_and_slide()

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE
	else:
		state = IDLE

func _on_hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	velocity = area.knockback_vector * 120
	hurtbox.start_invincibleity(0.5)

func _on_stats_no_health() -> void:
	create_effect()
	queue_free()
