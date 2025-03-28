extends CharacterBody2D

enum {
	MOVE,
	ATTACK,
	ROLL,
	IDEL,
}

@export var ACCELERATION : int = 500
@export var MAX_SPEED : int = 100
@export var ROLL_SPEED : int = 140
@export var FRICTION : int = 500

var state = MOVE
var roll_vector = Vector2.DOWN

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var sword_hitbox: Area2D = $HitboxPivot/SwordHitbox

func _ready() -> void:
	animation_tree.active = true
	sword_hitbox.knockback_vector = roll_vector

func _physics_process(_delta: float) -> void:
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		ROLL:
			roll_state()

func move_state():
	var input_vec = Vector2.ZERO
	
	input_vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vec.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vec = input_vec.normalized()
	
	if input_vec != Vector2.ZERO:
		roll_vector = input_vec
		sword_hitbox.knockback_vector = roll_vector
		
		animation_tree.set("parameters/Idle/blend_position", input_vec)
		animation_tree.set("parameters/Run/blend_position", input_vec)
		animation_tree.set("parameters/Attack/blend_position", input_vec)
		animation_tree.set("parameters/Roll/blend_position", input_vec)
		animation_state.travel("Run")	
		
		velocity = velocity.move_toward(input_vec * MAX_SPEED, ACCELERATION)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
func attack_state():
	animation_state.travel("Attack")

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	move_and_slide()
	animation_state.travel("Roll")
	
func attack_finished():
	state = MOVE

func roll_finished():
	velocity = Vector2.ZERO
	state = MOVE
