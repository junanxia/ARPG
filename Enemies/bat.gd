extends CharacterBody2D

@export var ACCELERATION : int = 230
@export var MAX_SPEED : int = 50
@export var FRICTION : int = 200
@export var WANDER_TARGET_RANGE : int = 4

@onready var stats: Node = $Stats
@onready var player_detection_zone: Area2D = $PlayerDetectionZone
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var hurtbox: Area2D = $Hurtbox
@onready var soft_collision: Area2D = $SoftCollision
@onready var wander_controller: Node2D = $WanderController

const Effect = preload("res://Effects/enemy_death_effect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

func _ready():
	state = pick_rand_state([IDLE, WANDER])

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
			update_state()
		WANDER:
			seek_player()
			update_state()
			update_pos_and_flip(wander_controller.target_position, delta)
			
			if global_position.distance_to(wander_controller.target_position) <= WANDER_TARGET_RANGE:
				state = pick_rand_state([IDLE, WANDER])
				wander_controller.start_timer(randi_range(1, 3))
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				update_pos_and_flip(player.global_position, delta)
			else:
				state = IDLE
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400		
	move_and_slide()

func update_state():
	if wander_controller.get_left_time() <= 0:
		state = pick_rand_state([IDLE, WANDER])
		wander_controller.start_timer(randi_range(1, 3))	

func update_pos_and_flip(position, delta):
	var vec = global_position.direction_to(position)  # (player.global_position - global_position).normalized()
	velocity = velocity.move_toward(vec * MAX_SPEED, ACCELERATION * delta)
	animated_sprite.flip_h = velocity.x < 0

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE
		
func pick_rand_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	velocity = area.knockback_vector * 120
	hurtbox.start_invincibleity(0.5)

func _on_stats_no_health() -> void:
	create_effect()
	queue_free()
