extends Node2D
class_name BaseWeapon

@export var enemy: NodePath
@export var damage := 20
@export var life_time := 0.2

func _ready():
	if enemy == null or not has_node(enemy):
		push_warning("Weapon has no valid enemy!")
		return

	var target = get_node(enemy)
	look_at(target.global_position)

	await get_tree().create_timer(life_time).timeout
	if is_instance_valid(self):
		queue_free()

func handle_hit(body):
	if enemy == null or not has_node(enemy):
		return

	var real_enemy = get_node(enemy)

	if body != real_enemy:
		return

	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
