class_name PlayerBase
extends CharacterBody2D

const DECELERATION := 0.1 
const ACCELERATION := 0.1
const SPEED := 140.0
const JUMP_VELOCITY := 200.0
const GRAVITY := 900.0
const GLIDE_GRAVITY := GRAVITY * 0.5
const GLIDE_GRAVITY_FALL := GRAVITY * 0.05
const UPWARDS_FORCE := 1000.0
var direction: float = 0.0
var gravity_2 := GRAVITY

func move(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity_2*delta

	gravity_2 = GRAVITY

	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED*ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED*DECELERATION)

func perform_jump()-> void:
	var can_jump := is_on_floor()
	
	if can_jump:
		velocity.y -= JUMP_VELOCITY	

func perform_glide()-> void:
	var can_glide := !is_on_floor() and velocity.y < 0

	if can_glide:
		gravity_2 = GLIDE_GRAVITY
	
func perform_last_glide()->void:
	var last_glide := !is_on_floor() and velocity.y > 0

	if last_glide:
		gravity_2 = GLIDE_GRAVITY_FALL
