extends Node

#lists all possible items, should default to 0 value.
var weak_h = {"name": "Weak H", "description": "Restores 5 HP to a target.", "effect_type": "heal_hp", "effect": "5", "targets": "ally", "quantity": 6}
var med_h = {"name": "Med H", "description": "Restores 10 HP to a target.", "effect_type": "heal_hp", "effect": "10", "targets": "ally", "quantity": 3}
var high_h = {"name": "High H", "description": "Restores 15 HP to a target.", "effect_type": "heal_hp", "effect": "15", "targets": "ally", "quantity": 1}
var weak_m = {"name": "Weak M", "description": "Restores 5 MP to a target.", "effect_type": "heal_mp", "effect": "5", "targets": "ally", "quantity": 4}
var med_m = {"name": "Med M", "description": "Restores 10 MP to a target.", "effect_type": "heal_mp", "effect": "10", "targets": "ally", "quantity": 2}
var high_m = {"name": "High M", "description": "Restores 15 MP to a target.", "effect_type": "heal_mp", "effect": "15", "targets": "ally", "quantity": 0}

var all_items = [high_m, weak_m, med_m, weak_h, high_h, med_h] #order is used to determine frame #

var current_inventory = []

func _ready():
	for i in all_items.size():
		if all_items[i].quantity != 0:
			current_inventory.append(all_items[i])

func update_inventory():
	#should be called whenever quantity changes, checking if empty. Though perhaps I still want to see it grayed out. Maybe only after combat to allow for grayed out text. Not sure if this will even be necessary, I seem to be updating the quantity in combat fine. Would I want an empty item to be automatically replaced with a random item after a battle? Definitely not. As current_inventory is used to figure out which are equipped, that would cause such a reallocation and I don't believe I want that, so I don't think this updating will be necessary. Maybe when menu is opened?
		current_inventory = []
		for i in all_items.size():
			if all_items[i].quantity != 0:
				current_inventory.append(all_items[i])
