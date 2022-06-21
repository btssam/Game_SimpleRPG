extends Node

var weak_hp = {"name": "Weak HP", "description": "Restores 5 HP to a target.", "effect_type": "heal_hp", "effect": "5", "targets": "ally"}
var med_hp = {"name": "Med HP", "description": "Restores 10 HP to a target.", "effect_type": "heal_hp", "effect": "10", "targets": "ally"}
var high_hp = {"name": "High HP", "description": "Restores 15 HP to a target.", "effect_type": "heal_hp", "effect": "15", "targets": "ally"}
var weak_mp = {"name": "Weak MP", "description": "Restores 5 MP to a target.", "effect_type": "heal_mp", "effect": "5", "targets": "ally"}
var med_mp = {"name": "Weak MP", "description": "Restores 10 MP to a target.", "effect_type": "heal_mp", "effect": "10", "targets": "ally"}
var high_mp = {"name": "High MP", "description": "Restores 15 MP to a target.", "effect_type": "heal_mp", "effect": "15", "targets": "ally"}
var inventory = {
	weak_hp: 6,
	med_hp: 3,
	high_hp: 1,
	weak_mp: 4,
	med_mp: 2,
	high_mp: 1
}
