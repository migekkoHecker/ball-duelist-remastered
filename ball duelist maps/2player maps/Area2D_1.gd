extends Area2D

@export var target_position: Vector2
@export var cooldown_time := 0.3

var cooldown := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if cooldown:
		return

	body.global_position = target_position

	cooldown = true
	await get_tree().create_timer(cooldown_time).timeout
	cooldown = false
