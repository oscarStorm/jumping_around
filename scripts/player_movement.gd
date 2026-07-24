extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var footsteps: AudioStreamPlayer2D = $Footsteps

var facing_left := false


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED

		facing_left = direction < 0
		sprite.flip_h = facing_left

		if is_on_floor() and not footsteps.playing:
			footsteps.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

		if footsteps.playing:
			footsteps.stop()

	move_and_slide()

	if not is_on_floor() and footsteps.playing:
		footsteps.stop()

	if direction == 0:
		sprite.flip_h = !facing_left

		if sprite.animation != "idle":
			sprite.play("idle")
	else:
		if sprite.animation != "running":
			sprite.play("running")
