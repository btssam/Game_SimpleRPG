extends Node

#lists all possible items, should default to 0 value.
var weak_h = {"name": "Weak H", "description": "Restores 5 HP to a target.", "effect_type": "heal_hp", "effect": "5", "targets": "ally", "quantity": 6, "icon_number": 3}
var med_h = {"name": "Med H", "description": "Restores 10 HP to a target.", "effect_type": "heal_hp", "effect": "10", "targets": "ally", "quantity": 3, "icon_number": 5}
var high_h = {"name": "High H", "description": "Restores 15 HP to a target.", "effect_type": "heal_hp", "effect": "15", "targets": "ally", "quantity": 1, "icon_number": 4}
var weak_m = {"name": "Weak M", "description": "Restores 5 MP to a target.", "effect_type": "heal_mp", "effect": "5", "targets": "ally", "quantity": 4, "icon_number": 1}
var med_m = {"name": "Med M", "description": "Restores 10 MP to a target.", "effect_type": "heal_mp", "effect": "10", "targets": "ally", "quantity": 2, "icon_number": 2}
var high_m = {"name": "High M", "description": "Restores 15 MP to a target.", "effect_type": "heal_mp", "effect": "15", "targets": "ally", "quantity": 0, "icon_number": 0}


var sword_1 = {"name": "Shortsword", "description": "A simple, yet effective, blade.", "stats": ["ATK+2", "DEF+2"], "type": "weapon", "player": "Alastor", "quantity": 1, "icon_number": 0}
var sword_2 = {"name": "Golden Sword", "description": "A blade made of precious metals.", "stats": ["INT+3", "DEF+1", "SPD+1"], "type": "weapon", "player": "Alastor", "quantity": 1, "icon_number": 8}
var spear_1 =  {"name": "Light Spear", "description": "A swift spear.", "stats": ["ATK+2", "SPD+1", "DEF+1"], "type": "weapon", "player": "Frey", "quantity": 1, "icon_number": 13}
var spear_2 =  {"name": "Iron Spear", "description": "A spear made of iron.", "stats": ["ATK+3", "SPD-4"], "type": "weapon", "player": "Frey", "quantity": 1, "icon_number": 6}
var bow_1 = {"name": "Shortbow", "description": "This bow is quick and deadly.", "stats": ["ATK+2", "SPD+4"], "type": "weapon", "player": "Brigit", "quantity": 1, "icon_number": 5}
var bow_2 = {"name": "Elven Bow", "description": "A bow found in a sylvan area.", "stats": ["ATK+3"], "type": "weapon", "player": "Brigit", "quantity": 1, "icon_number": 7}
var staff_1 ={"name": "Druid Staff", "description": "A traditional magick staff.", "stats": ["ATK+1", "INT+2"], "type": "weapon", "player": "Set", "quantity": 1, "icon_number": 10}
var staff_2 = {"name": "Burning Staff", "description": "This staff is hot to the touch.", "stats": ["INT+3", "DEF-1"], "type": "weapon", "player": "Set", "quantity": 1, "icon_number": 11}

var shield_1 = {"name": "Round Shield", "description": "A wooden shield.", "stats": ["DEF+2"], "type": "armor", "player": "any", "quantity": 1, "icon_number": 15}
var shield_2 = {"name": "Gemmed Shield", "description": "A shield encrusted in gems.", "stats": ["DEF+1", "INT+1"], "type": "armor", "player": "any", "quantity": 1, "icon_number": 16}
var armor_1 = {"name": "Heavy Armor", "description": "Sturdy, bulky armor", "stats": ["SPD-5", "DEF+3"], "type": "armor", "player": "any", "quantity": 1, "icon_number": 17}
var armor_2 = {"name": "Sleek Armor", "description": "Slim, leather armor.", "stats": ["SPD+5"], "type": "armor", "player": "any", "quantity": 4, "icon_number": 18}

var all_items = [weak_h, med_h, high_h, weak_m, med_m, high_m]
var current_inventory

var all_equips = [sword_1, sword_2, spear_1, spear_2, bow_1, bow_2, staff_1, staff_2, shield_1, shield_2, armor_1, armor_2]
var current_equips

func _ready():
	update_inventory()
	update_equips()

func update_inventory():
	#should be called whenever quantity changes, checking if empty. Though perhaps I still want to see it grayed out. Maybe only after combat to allow for grayed out text. Not sure if this will even be necessary, I seem to be updating the quantity in combat fine. Would I want an empty item to be automatically replaced with a random item after a battle? Definitely not. As current_inventory is used to figure out which are equipped, that would cause such a reallocation and I don't believe I want that, so I don't think this updating will be necessary. Maybe when menu is opened?
	current_inventory = []
	for i in all_items.size():
		if all_items[i].quantity != 0:
			current_inventory.append(all_items[i])

func update_equips():
	current_equips = []
	for i in all_equips.size():
		if all_equips[i].quantity != 0:
			current_equips.append(all_equips[i])
