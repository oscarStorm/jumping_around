class_name PlayerSFX
extends Node

var player: PlayerBase

@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var footsteps: AudioStreamPlayer2D = $"../Footsteps"
@onready var jump: AudioStreamPlayer2D = $"../Jump"
@onready var jump_timer: Timer = $"../JumpTimer"

func setup(player_ref: PlayerBase) -> void:
	player = player_ref

func update_footsteps() -> void:
	if player == null:
		return

	var is_running := player.is_on_floor() and absf(player.velocity.x) > 1.0
	if is_running:
		if not footsteps.playing:
			footsteps.play()
	else:
		footsteps.stop()

func start_jump() -> void:
	if player == null:
		return

	_update_facing()
	_play_animation(&"jumping")
	jump.play()
	jump_timer.start()

func update_animation() -> void:
	if player == null:
		return

	_update_facing()

	if not player.is_on_floor():
		if Input.is_action_pressed("glide"):
			if "idle_flip_h" in player:
				sprite.flip_h = player.get("idle_flip_h")
			_play_animation(&"gliding")
		else:
			_play_animation(&"jumping")
	elif absf(player.velocity.x) > 1.0:
		_play_animation(&"running")
	else:
		if "idle_flip_h" in player:
			sprite.flip_h = player.get("idle_flip_h")
		_play_animation(&"idle")

func _update_facing() -> void:
	if player.direction > 0.0:
		sprite.flip_h = false
	elif player.direction < 0.0:
		sprite.flip_h = true

func _play_animation(animation_name: StringName) -> void:
	if sprite.animation != animation_name:
		sprite.play(animation_name)
