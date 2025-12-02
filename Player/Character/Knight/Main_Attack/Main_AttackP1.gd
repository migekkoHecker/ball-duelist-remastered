extends BaseWeapon

# All damage, targeting, logic is inherited.
# Only signals are handled here.

func _on_Area2D_body_entered(body):
	handle_hit(body)

func _on_area_2d_body_entered(body):
	handle_hit(body)

func _on_body_entered(body):
	handle_hit(body)
