extends PlayerBase
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var footsteps: AudioStreamPlayer2D = $Footsteps
@onready var jump: AudioStreamPlayer2D = $Jump
@onready var jump_timer: Timer = $JumpTimer


var idle_flip_h := false

func _ready() -> void:
	jump_timer.timeout.connect(_on_jump_timer_timeout)


func _physics_process(delta: float) -> void:
	direction = Input.get_axis("move_left", "move_right")
	if direction > 0:
		idle_flip_h = true
	elif direction < 0:
		idle_flip_h = false

	if request_jump():
		_start_jump()
 
	move(delta)
	move_and_slide()

	_update_footsteps()
	_update_animation()

func _start_jump() -> void:
	if direction != 0.0:
		sprite.flip_h = direction < 0.0
	_play_animation("jumping", true)
	jump.play()
	jump_timer.start()

func _update_footsteps() -> void:
	var should_play := direction != 0.0 and is_on_floor() and not is_jump_pending()
	if should_play and not footsteps.playing:
		footsteps.play()
	elif not should_play and footsteps.playing:
		footsteps.stop()



func _update_animation() -> void:
	if direction != 0.0:
		sprite.flip_h = direction < 0.0

	if is_jump_pending() or not is_on_floor():
		_play_animation("jumping")
	elif direction != 0.0:
		_play_animation("running")
	else:
		sprite.flip_h = idle_flip_h
		_play_animation("idle")

func _play_animation(animation_name: StringName, from_start: bool = false) -> void:
	if sprite.animation != animation_name:
		sprite.play(animation_name)
	elif from_start:
		sprite.play(animation_name, 1.0, false)

func _on_jump_timer_timeout() -> void:
	perform_jump()
