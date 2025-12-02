extends Control

func _ready():
	# Connect buttons (can also connect in the editor)
	$VBoxContainer/StartButton.pressed.connect(_on_play_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	# Load the gameplay scene
	get_tree().change_scene_to_file("res://Maps/map_1.tscn")

func _on_quit_pressed():
	get_tree().quit()
