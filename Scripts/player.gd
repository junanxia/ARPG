extends CharacterBody2D

const ACCELERATION = 500
const MAX_SPEED = 100
const FRICTION = 500

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

func _physics_process(_delta: float) -> void:
	var input_vec = Vector2.ZERO
	
	input_vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vec.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vec = input_vec.normalized()
	
	if input_vec != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vec)
		animation_tree.set("parameters/Run/blend_position", input_vec)
		animation_state.travel("Run")
		
		velocity = velocity.move_toward(input_vec * MAX_SPEED, ACCELERATION)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	move_and_slide()
