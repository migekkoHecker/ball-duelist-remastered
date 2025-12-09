extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -635.0
const CROUCH_VELOCITY = 1200.0

@onready var sprite_stand = $Sprite2D
@onready var sprite_crouch = $Sprite2D_Crouch
@onready var collision_stand = $CollisionShape2D
@onready var collision_crouch = $CollisionShape2D_Crouch
@onready var weapon_socket = $Character
@onready var hp_label = $HPLabel

# Gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Character selection
@export var character_name: String = "Knight"

# Weapon system
@export var weapon: PackedScene
@export var enemy: NodePath
@export_enum("Player 1", "Player 2") var player_id: int = 0

# Local reference to the map's GameManager
@export var game_manager: Node  # assign this in the editor

# Player key mapping
var player_data = {
	1: {"move_left": "move_left", "move_right": "move_right", "jump": "jump", "attack": "attack", "crouch": "crouch"},
	2: {"move_left": "move_left_2", "move_right": "move_right_2", "jump": "jump_2", "attack": "attack_2", "crouch": "crouch_2"}
}

# Runtime ID
var actual_player_id: int



# Crouch state
var is_crouching := false

# Movement / attack disabled flag
var disabled := false

# --------------------
#       HP SYSTEM
# --------------------
@export var max_hp := 100
var hp := max_hp

func _ready():
	actual_player_id = player_id + 1
	print("[Player] Ready:", name, "ID:", actual_player_id)


	if weapon == null:
		push_warning("No weapon assigned for character %s" % character_name)

	sprite_crouch.visible = false
	collision_crouch.disabled = true
	sprite_stand.visible = true
	collision_stand.disabled = false

	update_hp_label()
	add_to_group("players")
	print("[Player] Added to 'players' group")

func _physics_process(delta):
	if disabled:
		return

	# ---- GRAVITY ----
	if not is_on_floor():
		velocity.y += gravity * delta

	# ---- MOVE ----
	var left_key = player_data[actual_player_id]["move_left"]
	var right_key = player_data[actual_player_id]["move_right"]

	var dir := 0
	if Input.is_action_pressed(left_key):
		dir -= 1
	if Input.is_action_pressed(right_key):
		dir += 1

	if dir != 0:
		velocity.x = dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# ---- JUMP ----
	var jump_key = player_data[actual_player_id]["jump"]
	if Input.is_action_pressed(jump_key) and is_on_floor() and not is_crouching:
		velocity.y = JUMP_VELOCITY

	# ---- CROUCH ----
	var crouch_key = player_data[actual_player_id]["crouch"]
	if Input.is_action_pressed(crouch_key):
		if not is_crouching:
			enter_crouch()
		if not is_on_floor():
			velocity.y = CROUCH_VELOCITY
	else:
		if is_crouching:
			exit_crouch()

	move_and_slide()

	# ---- FLIP ----
	if dir != 0:
		sprite_stand.flip_h = dir < 0
		sprite_crouch.flip_h = dir < 0

	# ---- ATTACK ----
	var attack_key = player_data[actual_player_id]["attack"]
	if Input.is_action_just_pressed(attack_key):
		if weapon == null or enemy == null:
			return
		attack()

# --------------------
#      HP API
# --------------------
func take_damage(amount: int):
	hp -= amount
	hp = max(hp, 0)
	update_hp_label()
	print("[Player] Took damage:", name, "HP:", hp)

	if hp <= 0:
		die()

func heal(amount: int):
	hp += amount
	hp = min(hp, max_hp)
	update_hp_label()
	print("[Player] Healed:", name, "HP:", hp)

func die():
	print("[Player] DIED:", name)

	# Notify GameManager
	if game_manager:
		game_manager.player_died(self)
	else:
		print("[Player] WARNING: GameManager not assigned!")

	# Disable player safely; they are the loser
	call_deferred("_disable_player", true)


func _disable_player(loser := true):
	print("[Player] Disabling player:", name)
	disabled = true
	collision_stand.set_deferred("disabled", true)
	collision_crouch.set_deferred("disabled", true)
	sprite_stand.set_deferred("visible", false)
	sprite_crouch.set_deferred("visible", false)
	set_process(false)
	set_physics_process(false)

	if loser:
		# Only remove the loser
		queue_free()


func disable_for_game_over():
	disabled = true
	set_process(false)
	set_physics_process(false)
	collision_stand.set_deferred("disabled", true)
	collision_crouch.set_deferred("disabled", true)
	# Don't hide sprites for the winner
	print("[Player] Disabled for game over (winner stays visible):", name)


func update_hp_label():
	hp_label.text = "HP: %d" % hp
	print("[Player] HP Label updated:", name, hp)

# --------------------
#    CROUCH STATE
# --------------------
func enter_crouch():
	is_crouching = true
	sprite_stand.visible = false
	collision_stand.disabled = true
	sprite_crouch.visible = true
	collision_crouch.disabled = false
	print("[Player] Entered crouch:", name)

func exit_crouch():
	var can_stand := not test_move(global_transform, Vector2(0, -10))
	if not can_stand:
		return
	is_crouching = false
	sprite_crouch.visible = false
	collision_crouch.disabled = true
	sprite_stand.visible = true
	collision_stand.disabled = false
	print("[Player] Exited crouch:", name)

# --------------------
#    ATTACK SPAWN
# --------------------
func attack():
	print("[Player] Attack pressed:", name)
	var weapon_instance = weapon.instantiate()
	weapon_instance.global_position = weapon_socket.global_position
	weapon_instance.enemy = enemy
	get_tree().current_scene.add_child(weapon_instance)
