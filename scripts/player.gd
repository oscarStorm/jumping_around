extends PlayerBase
@onready var jump_timer: Timer = $JumpTimer
@onready var player_sfx: PlayerSFX = $PlayerSFX

var idle_flip_h := false
var jump_queued := false

func _ready() -> void:
	jump_timer.timeout.connect(_on_jump_timer_timeout)
	player_sfx.setup(self)


func _physics_process(delta: float) -> void:
	direction = Input.get_axis("move_left", "move_right")

	if direction > 0:
		idle_flip_h = true
	elif direction < 0:
		idle_flip_h = false

	if request_jump() and is_on_floor() and not jump_queued:
		jump_queued = true
		player_sfx.start_jump()
	
	move(delta)
	move_and_slide()
	
	player_sfx.update_footsteps()
	player_sfx.update_animation()

func request_jump() -> bool:
	return Input.is_action_just_pressed("jump")

func _on_jump_timer_timeout() -> void:
	if jump_queued:
		perform_jump()
		jump_queued = false
