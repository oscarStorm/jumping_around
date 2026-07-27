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
	if player.is_on_floor() and sprite.animation != "idle":
		footsteps.play()
	else:
		footsteps.stop()

func start_jump() -> void:
	if player.direction != 0.0:
		sprite.flip_h = player.direction < 0.0
	_play_animation("jumping")
	jump.play()
	jump_timer.start()

func update_animation() -> void:
	if player.direction != 0.0:
		sprite.flip_h = player.direction < 0.0
	if not player.is_on_floor():
		_play_animation("jumping")
	elif player.direction != 0.0:
		_play_animation("running")
	else:
		sprite.flip_h = player.idle_flip_h
		_play_animation("idle")

func _play_animation(animation_name: StringName) -> void:
	if sprite.animation != animation_name:
		sprite.play(animation_name)
