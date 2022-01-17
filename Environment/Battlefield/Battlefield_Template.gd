extends Node2D

var enemy_node = "res://Characters/NPC/Enemy/Enemy_Template.tscn"
var enemy = load(enemy_node).instance()

var enemy_list = []
var number_of_units = 0
#var turn_order = []

var isSelectingSkill = false
#var current_skill = 0

var isSelectingTarget = false
var current_target = 0

func _ready():
	get_random_number_of_units()
	add_enemies()
#	get_turn_order()
	
func _input(event):
	if event.is_action_pressed("test_key"):
		close_scene()
	if event.is_action_pressed("interact"):
		open_command_popup()
	
	if isSelectingTarget:
		if event.is_action_pressed("up"):
			change_target("up")
		if event.is_action_pressed("down"):
			change_target("down")
			
	if isSelectingSkill:
		if event.is_action_pressed("up"):
			change_skill("up")
		if event.is_action_pressed("down"):
			change_skill("down")
	
	


#spawn enemies
func get_random_number_of_units():
	randomize()
	number_of_units = randi()%3 + 1
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

#open commands
func open_command_popup():
	get_tree().call_group("battle_group", "open_commands_popup")
	isSelectingSkill = true

#select a target
func select_target():
	isSelectingSkill = false
	isSelectingTarget = true
	print('select a target')
	enable_selector_sprite()

func change_target(direction):
	print('move target ' + direction)
	if direction == 'up':
		if current_target > 0:
			disable_selector_sprite()
			current_target -= 1
			enable_selector_sprite()
	elif direction == 'down':
		if current_target < number_of_units - 1:
			disable_selector_sprite()
			current_target += 1
			enable_selector_sprite()
	print(enemy_list[current_target])
	
func change_skill(direction):
	print('move option ' + direction)
	
func enable_selector_sprite():
	var children_list = enemy_list[current_target].get_children()
	var selector = children_list[1]
	var animationPlayer = children_list[2]
	selector.visible = true
	animationPlayer.play('blink')

func disable_selector_sprite():
	var children_list = enemy_list[current_target].get_children()
	var selector = children_list[1]
	var animationPlayer = children_list[2]
	selector.visible = false
	animationPlayer.stop()
