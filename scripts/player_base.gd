class_name PlayerBase
extends CharacterBody2D

const DECELERATION := 0.1 
const ACCELERATION := 0.1
const SPEED := 140.0
const JUMP_VELOCITY := -550.0
var GRAVITY := 2000.0
const UPWARDS_FORCE := 1000.0
var direction: float = 0.0


var jump_requested := false

func move(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY*delta

	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED*ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED*DECELERATION)

func request_jump() -> bool:
	if is_jump_pressed() and is_on_floor() and not jump_requested:
		jump_requested = true
		return true
	return false

func is_jump_pressed() -> bool:
	return Input.is_action_just_pressed("jump")
	

func perform_jump() -> void:
	if not jump_requested:
		return

	var can_jump := is_on_floor()
	jump_requested = false

	if can_jump:
		velocity.y = JUMP_VELOCITY
		on_jump()

func is_jump_pending() -> bool:
	return jump_requested

func on_jump() -> void:
	pass
