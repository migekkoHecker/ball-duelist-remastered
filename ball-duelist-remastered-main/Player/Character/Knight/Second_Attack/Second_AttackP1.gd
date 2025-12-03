extends BaseWeapon

@export var speed: float = 1000

var target_position: Vector2
var direction: Vector2

func _ready():
	super()  # Sets up damage and lifetime

	if enemy == null or not has_node(enemy):
		print("ERROR: Invalid target")
		queue_free()
		return

	var target_node = get_node(enemy)
	target_position = target_node.global_position
	direction = (target_position - global_position).normalized()
	look_at(target_position)

func _process(delta):
	# Move straight toward locked position
	global_position += direction * speed * delta

	# Optional: delete when close enough
	#if global_position.distance_to(target_position) < 10:
		#queue_free()

# Signals
func _on_Area2D_body_entered(body):
	handle_hit(body)

func _on_area_2d_body_entered(body):
	handle_hit(body)

func _on_body_entered(body):
	handle_hit(body)

