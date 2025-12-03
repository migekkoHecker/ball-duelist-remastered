extends Resource
class_name CharacterDatabase  # Give it a class name so we can type it

var characters = {
	"Knight": {
		"weapons": [ preload("res://Player/Character/Knight/Main_Attack/Main_AttackP1.tscn") ],
		"second": [ preload("res://Player/Character/Knight/Second_Attack/Second_AttackP1.tscn") ]
	},
	"Gunman": {
		"weapons": [ preload("res://Player/Character/Gunman/Main_Attack/Main_AttackP1.tscn") ]
	},
	"Mage": {
		"weapons": [ preload("res://Player/Character/Mage/Main_Attack/Main_AttackP1.tscn") ]
	}
}

func get_default_weapon(character_name: String) -> PackedScene:
	if not characters.has(character_name):
		push_warning("Character '%s' not found" % character_name)
		return null
	var weapon_list = characters[character_name]["weapons"]
	if weapon_list.size() > 0:
		return weapon_list[0]
	return null

func get_super_weapon(character_name: String) -> PackedScene:
	if not characters.has(character_name):
		push_warning("Character '%s' not found" % character_name)
		return null
	var super_list = characters[character_name].get("second", [])
	if super_list.size() > 0:
		return super_list[0]
	return null
