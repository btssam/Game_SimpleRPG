extends Node2D

var enemy_node = "res://Characters/NPC/Enemy/Enemy_Template.tscn"
var enemy = load(enemy_node).instance()

var enemy_list = []
var number_of_units = 0
var turn_order = []

func _ready():
	get_random_number_of_units()
	add_enemies()
#	get_turn_order()
	
func _input(event):
	if event.is_action_pressed("test_key"):
		close_scene()
	if event.is_action_pressed("interact"):
		open_command_popup()


#spawn enemies
func get_random_number_of_units():
	randomize()
	number_of_units = randi()%3 + 1
	number_of_units = 2
	return number_of_units
	
#func get_random_unit():
#	randomize()
#	return randi()%4 + 1

func add_enemies():
	for i in range(0, number_of_units):
		var enemy = load(enemy_node).instance()
		call_deferred("add_child", enemy)
		enemy_list.push_back(enemy)
		call_deferred('change_position')
		print('enemies_added')

func change_position():
	for i in range(0, number_of_units):
		if number_of_units == 3:
			enemy_list[i].position = Vector2(224, 256 + 128 * i)
		if number_of_units == 2:
			enemy_list[i].position = Vector2(224, 341 + 85 * i)
		if number_of_units == 1:
			enemy_list[i].position = Vector2(224, 384)

#respond to input
func close_scene():
	get_tree().call_group("level_switching", "switch_scene", "battle", "overworld")
	get_tree().call_group("battle_check_group", "reset_battle_check")

#battle code
#func get_turn_order():
#	turn_order = enemy_list.push_front($PC_OW_Template)
#	print(turn_order)

func open_command_popup():
#	var commands_popup = preload("res://UI/Battle/Popup_Commands.tscn").instance()
#	var player_node = get_tree().get_root().get_node("Main/PC_OW_Template")
#	player_node.add_child(commands_popup)
	print('open command popup')
	get_tree().call_group("battle_group", "open_commands_popup")
