extends Node2D
class_name BaseWeapon

@export var enemy: NodePath
@export var damage := 20
@export var life_time := 0.2

# Seconds between attacks for THIS WEAPON
@export var cooldown := 0.3

# Assigned by Player when spawning
@export var owner_id := -1   # Player ID (1,2,3...)

# Should this weapon disappear on hit?
@export var destroy_on_hit := true

# GLOBAL TABLE:
# weapon_name -> { player_id -> last_shot_time }
static var cooldown_table := {}

# Keep track of who has already been hit
var hit_targets := []

func _ready():
	var weapon_id = get_script().resource_path
	var now = Time.get_ticks_msec() / 1000.0

	# Init tables
	if not cooldown_table.has(weapon_id):
		cooldown_table[weapon_id] = {}

	if not cooldown_table[weapon_id].has(owner_id):
		cooldown_table[weapon_id][owner_id] = 0.0

	var last_time = cooldown_table[weapon_id][owner_id]

	# REAL COOLDOWN CHECK
	if now - last_time < cooldown:
		queue_free()
		return

	# Register fire time
	cooldown_table[weapon_id][owner_id] = now

	# --------------------------------
	# NORMAL WEAPON SETUP
	# --------------------------------
	if enemy == null or not has_node(enemy):
		push_warning("Weapon has no valid enemy!")
		return

	var target = get_node(enemy)
	look_at(target.global_position)

	await get_tree().create_timer(life_time).timeout
	if is_instance_valid(self):
		queue_free()


# ------------------
# HIT DETECTION API
# ------------------
func handle_hit(body):
	if enemy == null or not has_node(enemy):
		return

	var real_enemy = get_node(enemy)

	if body != real_enemy:
		return

	# Already hit this target? Skip
	if real_enemy in hit_targets:
		return

	# Deal damage
	if body.has_method("take_damage"):
		body.take_damage(damage)
		hit_targets.append(real_enemy)

	# Destroy if configured
	if destroy_on_hit:
		queue_free()
