extends Area2D

@export var bounce_force: float = -800.0
@export var damage: int = 10

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Bounce the player upward
		if body.has_method("apply_central_impulse"):
			body.apply_central_impulse(Vector2(0, bounce_force))

		# Deal damage
		if body.has_method("take_damage"):
			body.take_damage(damage)
