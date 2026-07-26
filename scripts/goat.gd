extends CharacterBody2D

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var goat_timer: Timer = $GoatTimer
@onready var goat_sound: AudioStreamPlayer2D = $GoatSound

func _ready() -> void:
	goat_timer.timeout.connect(_on_goat_timer_timeout)
	_set_next_goat_sound()
	$AnimatedSprite2D.play("default")

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta

	move_and_slide()

func _on_goat_timer_timeout() -> void:
	goat_sound.play()
	_set_next_goat_sound()

func _set_next_goat_sound() -> void:
	goat_timer.wait_time = randf_range(3.0, 8.0)
	goat_timer.start()
