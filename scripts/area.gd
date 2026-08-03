extends Area2D

signal show_text

@export var target_label_path: NodePath = ^"../Label3"

@onready var timer: Timer = $Timer
@onready var target_label: Label = get_node(target_label_path)

var player_inside := false


func _ready() -> void:
	target_label.visible = false
	timer.wait_time = 2.0
	timer.one_shot = true

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)


func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBase:
		player_inside = true
		timer.start()


func _on_body_exited(body: Node2D) -> void:
	if body is PlayerBase:
		player_inside = false
		timer.stop()


func _on_timer_timeout() -> void:
	if player_inside:
		target_label.visible = true
		show_text.emit()
