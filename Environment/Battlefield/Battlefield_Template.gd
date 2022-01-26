
extends Node2D

###initalize
var enemy_node = "res://Characters/NPC/Enemy/Enemy_Template.tscn"
var enemy = load(enemy_node).instance()

var number_of_units = 0
var enemy_list = []
#var random_enemy = 0

#var turn_order = []



###targeting
var isSelectingTarget = false
var current_target = 0
var isSelectingSkill = false
var current_skill = 0

var current_selection = 0



#command card
onready var command_card = $BattleUI/Command_Card
var card_selector_sprite
var card_animation_player

var cardIsVisible =  false

var number_of_selections = 4


func _ready():
	####initalize
	get_random_number_of_units()
	add_enemies()
#	get_turn_order()
	###command card
	command_card.hide()

func _input(event):
	###targeting
	if isSelectingTarget:
		if event.is_action_pressed("up"):
			change_target("up")
		if event.is_action_pressed("down"):
			change_target("down")
		if event.is_action_pressed("interact"):
			return_target()
	###commandcard
	if not isSelectingTarget:
		if event.is_action_pressed("interact"):
			process_command()
	
	if isSelectingSkill:
		if event.is_action_pressed("up"):
			change_skill("up")
		if event.is_action_pressed("down"):
			change_skill("down")
	
	###other
	if event.is_action_pressed("test_key"):
			close_scene()



###initalize
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



###targeting

#targeting an enemy
func select_target():
	isSelectingSkill = false
	set_deferred("isSelectingTarget", true )
	enable_selector_sprite()

func change_target(direction):
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
	
func return_target():
	isSelectingTarget = false
	disable_selector_sprite()
	get_skill()

#respond_to_skill
func get_skill():
	current_skill = current_selection
	respond_to_skill()
	
func respond_to_skill():
	if current_skill == 0: #attack
		print('attempt to lower hp')
		enemy_list[current_target].hp -= 1
		update_UI()




####commandcard

func process_command():
	get_card_nodes()

	if not isSelectingTarget:
		if not cardIsVisible:
			command_card.show()
			cardIsVisible = true
			isSelectingSkill = true
			enable_card_selector_sprite()
		else:
			disable_card_selector_sprite()
			command_card.hide()
			cardIsVisible = false
			if current_selection == 0: #attack
				select_target()
			elif current_selection == 1: #skill
				print('no skills')
				isSelectingSkill = false
			elif current_selection == 2: #item
				print('no items')
				isSelectingSkill = false
			elif current_selection == 3: #flee
				isSelectingSkill = false
				current_selection = 0
				close_scene()


func change_skill(direction):
	
	if direction == 'up':
		if current_selection > 0 :
			disable_card_selector_sprite()
			current_selection -= 1
			enable_card_selector_sprite()
	elif direction == 'down':
		if current_selection < number_of_selections - 1:
			disable_card_selector_sprite()
			current_selection += 1
			enable_card_selector_sprite()

func get_card_nodes(): #get the selector and animator of current selection(label node)
	var children_list = command_card.get_children()
	var commands_list = children_list[1].get_children()
	var command_children_list = commands_list[current_selection].get_children()
	card_selector_sprite = command_children_list[0]
	card_animation_player = command_children_list[1]

func enable_card_selector_sprite():
	get_card_nodes()
	card_selector_sprite.visible = true
	card_animation_player.play('blink')
	
func disable_card_selector_sprite():
	get_card_nodes()
	card_selector_sprite.visible = false
	card_animation_player.stop()









###other
func close_scene():
	get_tree().call_group("level_switching", "switch_scene", "battle", "overworld")
	get_tree().call_group("battle_check_group", "reset_battle_check")



func update_UI():
	for i in range(0, number_of_units):
		print(enemy_list[i].hp)
