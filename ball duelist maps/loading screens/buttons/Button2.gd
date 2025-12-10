extends Button

# List all your map scene paths here
const MAPS := [
	"res://map_2.tscn",
	"res://map_3.tscn",
	"res://map_4.tscn",
	"res://map_5.tscn",
]

func _ready():
	randomize()

func _on_pressed():
	load_random_map()

func load_random_map():
	var random_map_path = MAPS[randi() % MAPS.size()]
	var scene = load(random_map_path)
	get_tree().change_scene_to_packed(scene)
	
