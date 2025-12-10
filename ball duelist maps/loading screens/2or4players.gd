extends Node2D

# 2-player maps (eerste 2 maps)
const MAPS_2P: Array[String] = [
	"res://2player maps/map_2.tscn",
	"res://2player maps/map_3.tscn",
	"res://2player maps/map_4.tscn",
	"res://2player maps/map_5.tscn",
]

# 4-player maps
const MAPS_4P: Array[String] = [
	"res://4player maps/4playermap_1.tscn",
]

func _ready():
	randomize()
	# Verbind de knoppen met de juiste functies
	$Button.pressed.connect(_on_Button_pressed)    # 2-player
	$Button2.pressed.connect(_on_Button2_pressed)  # 4-player

# 2-player knop gedrukt
func _on_Button_pressed():
	print("4-player button pressed")
	load_random_map(MAPS_4P)

# 4-player knop gedrukt
func _on_Button2_pressed():
	print("2-player button pressed")
	load_random_map(MAPS_2P)

# Random map laden
func load_random_map(map_list: Array[String]):
	var path: String = map_list[randi() % map_list.size()]
	print("Loading map:", path)
	var scene := load(path)
	if scene:
		get_tree().change_scene_to_packed(scene)
	else:
		print("Failed to load scene:", path)





func _on_button_2_pressed():
	pass # Replace with function body.
