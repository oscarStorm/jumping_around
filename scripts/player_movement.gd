extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var footsteps: AudioStreamPlayer2D = $Footsteps
@onready var jump_timer: Timer = $JumpTimer

var facing_left := false
var jump_pending := false


func _ready() -> void:
	sprite.animation_finished.connect(_on_sprite_animation_finished)
	jump_timer.timeout.connect(_on_jump_timer_timeout)
	jump_timer.one_shot = true


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Check for jump input
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not jump_pending:
		# Start animation and timer immediately
		jump_pending = true
		sprite.play("jumping", 1.0, false)
		jump_timer.start()

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

	# Animation Logic
	if jump_pending:
		if footsteps.playing:
			footsteps.stop()
	elif not is_on_floor():
		if footsteps.playing:
			footsteps.stop()
		# Don't change animation while in air

	elif direction != 0:
		if sprite.animation != "running":
			sprite.play("running")
	else:
		sprite.flip_h = facing_left
		if sprite.animation != "idle":
			sprite.play("idle")


func _on_sprite_animation_finished() -> void:
	if sprite.animation == "jumping":
		sprite.pause()
		sprite.set_frame_and_progress(
			sprite.sprite_frames.get_frame_count("jumping") - 1,
			1.0
		)


func _on_jump_timer_timeout() -> void:
	# Execute the jump
	if is_on_floor() and jump_pending:
		velocity.y = JUMP_VELOCITY
	jump_pending = false
