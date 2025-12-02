extends Resource  # Could also just be Node, but Resource is cleaner for a database

# Example: this holds all character data
var characters = {
	"Knight": {
		"weapons": [ preload("res://Player/Character/Knight/Main_Attack/Main_AttackP1.tscn") ]
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
		return weapon_list[0]  # Pick first weapon as default
	return null
