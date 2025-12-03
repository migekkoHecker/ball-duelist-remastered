extends BaseWeapon

var has_hit := false  # track whether it already hit

func _on_Area2D_body_entered(body):
	handle_hit_once(body)

func _on_area_2d_body_entered(body):
	handle_hit_once(body)

func _on_body_entered(body):
	handle_hit_once(body)

func handle_hit_once(body):
	if has_hit:
		return  # only hit once

	if enemy == null or not has_node(enemy):
		return

	var real_enemy = get_node(enemy)

	if body != real_enemy:
		return

	if body.has_method("take_damage"):
		body.take_damage(damage)  # apply damage
		has_hit = true

	# Do NOT call queue_free() here, weapon stays after hit
