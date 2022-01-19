extends Node2D


var enemy_node = "res://Characters/NPC/Enemy/Enemy_Template.tscn"
var enemy = load(enemy_node).instance()

var number_of_units = 0
var enemy_list = []
#var random_enemy = 0

#var turn_order = []

func _ready():
	get_random_number_of_units()
	add_enemies()
#	get_turn_order()


#spawn enemies
func get_random_number_of_units():
	randomize()
	number_of_units = randi()%3 + 1
	return number_of_units
	
#func get_random_unit():
#	randomize()
#	random_enemy = randi()%4 + 1
#	return random_enemy

func add_enemies():
	for i in range(0, number_of_units):
		var enemy = load(enemy_node).instance()
		call_deferred("add_child", enemy)
		enemy_list.push_back(enemy)
		call_deferred('change_position')

func change_position():
	for i in range(0, number_of_units):
		if number_of_units == 3:
			enemy_list[i].position = Vector2(224, 256 + 128 * i)
		if number_of_units == 2:
			enemy_list[i].position = Vector2(224, 341 + 85 * i)
		if number_of_units == 1:
			enemy_list[i].position = Vector2(224, 384)


#battle code
#func get_turn_order():
#	turn_order = enemy_list.push_front($PC_OW_Template)
#	print(turn_order)
