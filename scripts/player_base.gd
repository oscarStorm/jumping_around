class_name PlayerBase
extends CharacterBody2D

const DECELERATION := 0.1 
const ACCELERATION := 0.1
const SPEED := 140.0
const JUMP_VELOCITY := 350.0
var GRAVITY := 900.0
const UPWARDS_FORCE := 1000.0
var direction: float = 0.0

func move(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY*delta

	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED*ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED*DECELERATION)

func perform_jump()-> void:
	var can_jump := is_on_floor()
	
	if can_jump:
		velocity.y -= JUMP_VELOCITY	
