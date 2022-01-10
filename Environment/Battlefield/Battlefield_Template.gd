extends Node2D

var enemy_node = "res://Characters/NPC/Enemy/Enemy_Template.tscn"
var enemy = load(enemy_node).instance()

func _ready():
	add_enemies()

func get_random_number_of_units():
	randomize()
	return randi()%3 + 1
	
func get_random_unity():
	randomize()
	return randi()%4 + 1

func add_enemies():
	for number in range(0, get_random_number_of_units()):
		print('add enemy')
		var enemy = load(enemy_node).instance()
		call_deferred("add_child", enemy)
