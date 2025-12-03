extends BaseWeapon

@export var speed: float = 220

var target_node: Node = null

func _ready():
	super()  # Sets up damage and lifetime

	if enemy == null or not has_node(enemy):
		print("ERROR: Invalid target")
		queue_free()
		return

	target_node = get_node(enemy)
	look_at(target_node.global_position)

func _process(delta):
	if not is_instance_valid(target_node):
		queue_free()
		return

	# Move toward the target each frame
	var dir = (target_node.global_position - global_position).normalized()
	global_position += dir * speed * delta
	look_at(target_node.global_position)

# Signals
func _on_Area2D_body_entered(body):
	handle_hit(body)

func _on_area_2d_body_entered(body):
	handle_hit(body)

func _on_body_entered(body):
	handle_hit(body)
