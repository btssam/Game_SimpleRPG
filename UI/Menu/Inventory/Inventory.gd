extends Node

var weak_h = {"name": "Weak H", "description": "Restores 5 HP to a target.", "effect_type": "heal_hp", "effect": "5", "targets": "ally"}
var med_h = {"name": "Med H", "description": "Restores 10 HP to a target.", "effect_type": "heal_hp", "effect": "10", "targets": "ally"}
var high_h = {"name": "High H", "description": "Restores 15 HP to a target.", "effect_type": "heal_hp", "effect": "15", "targets": "ally"}
var weak_m = {"name": "Weak M", "description": "Restores 5 MP to a target.", "effect_type": "heal_mp", "effect": "5", "targets": "ally"}
var med_m = {"name": "Med M", "description": "Restores 10 MP to a target.", "effect_type": "heal_mp", "effect": "10", "targets": "ally"}
var high_m = {"name": "High M", "description": "Restores 15 MP to a target.", "effect_type": "heal_mp", "effect": "15", "targets": "ally"}
var inventory = {
	"weak_h": 6,
	"med_h": 3,
	"high_h": 1,
	"weak_m": 4,
	"med_m": 2,
	"high_m": 1
}
