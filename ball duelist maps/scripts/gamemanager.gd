extends Node

# Reference to the win label in the scene
@onready var win_label: Label = $"../CanvasLayer/WinLabel"

# Game state
var game_over := false

func _ready():
	print("[GameManager] Ready!")
	if win_label:
		win_label.visible = false
	else:
		print("[GameManager] WARNING: WinLabel not found!")

# Call this when a player dies
func player_died(player):
	if game_over:
		return

	game_over = true
	print("[GameManager] Player died:", player.name)

	# Determine winner
	var winner_player_id = 2 if player.player_id == 0 else 1
	print("[GameManager] Winner Player ID:", winner_player_id)

	# Update win label
	if win_label:
		win_label.text = "Player %d Wins!" % winner_player_id
		win_label.visible = true
	else:
		print("[GameManager] WARNING: WinLabel not assigned!")

	# Disable all players except winner
	for p in get_tree().get_nodes_in_group("players"):
		if p.actual_player_id != winner_player_id:
			print("[GameManager] Disabling loser:", p.name)
			p._disable_player(true)  # loser
		else:
			print("[GameManager] Leaving winner enabled:", p.name)
			p.disable_for_game_over()  # winner

	# Return to main menu after 2 seconds
	var t = Timer.new()
	t.wait_time = 2.0
	t.one_shot = true
	add_child(t)
	t.start()
	t.timeout.connect(_return_to_main_menu)

func _return_to_main_menu():
	print("[GameManager] Returning to Main Menu")
	get_tree().change_scene_to_file("res://loading screens/homescreen.tscn")
