extends Node2D

###initialize
var enemy_node = "res://Characters/NPC/Enemy/Enemy_Template.tscn"

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


###updating UI
onready var enemyStats = get_node("BattleUI/Battle_Bottom_UI/Enemies_Stats/Label")
onready var PCStats = get_node("BattleUI/Battle_Bottom_UI/PCs_Stats/Label")
onready var UILog = get_node("BattleUI/Battle_Bottom_UI/Log/Label")
var logArray = []



###turn ordering
var turn_order = []
onready var player = get_node("../PC_Template")
var isPlayersTurn = true

var enemyAnimationPlayer


func _ready():
	####initialize
	get_random_number_of_units()
	add_enemies()
	###command card
	command_card.hide()
	###UI_update
	initialize_enemy_UI()
	initialize_PC_UI()
	initialize_log()
	###turn_ordering
	initialize_turn_order()




func _input(event):
	###targeting
	if isPlayersTurn:
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



###initialize
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
	shift_turn_order()
	act_in_order()

#respond_to_skill
func get_skill():
	current_skill = current_selection
	respond_to_skill()
	
func respond_to_skill():
	if current_skill == 0: #attack
		enemy_list[current_target].hp -= 1
		update_enemy_UI()
	isPlayersTurn = false




####commandcard

func process_command():
	if isPlayersTurn:
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
					update_log('You have no skills.')
					isSelectingSkill = false
				elif current_selection == 2: #item
					update_log('You have no items.')
					isSelectingSkill = false
				elif current_selection == 3: #flee
					isSelectingSkill = false
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
	player.hp = player.maxhp
	current_selection = 0




###updating UI
func initialize_enemy_UI():
	for i in range(0, number_of_units):
		enemyStats.text += 'Enemy ' + str(i + 1) + ': ' + str(enemy_list[i].hp) + '\n'
	
func update_enemy_UI():
	var newText = ''
	for i in range(0, number_of_units):
		newText += 'Enemy ' + str(i + 1) + ': ' + str(enemy_list[i].hp) + '\n'
	enemyStats.text = newText

func initialize_PC_UI():
	PCStats.text += 'Player 1: ' + str(player.hp) + '\n'    #need to integrate multiple PC's
	

func update_PC_UI():
	var newText = ''
	newText = 'Player 1: ' + str(player.hp) + '\n'    #need to integrate multiple PC's
	PCStats.text = newText

func initialize_log():
	UILog.text = ''

func update_log(message):
	logArray.push_front(message + '\n')
	var currentText = ''
	if logArray.size() <= 6:
		for i in range(0, logArray.size()):
			currentText += logArray[i]
	else:
		for i in range(0, logArray.size()):
				if logArray.size() < 6:
					logArray[i] = logArray[i+1]
				currentText += logArray[i]
		logArray.pop_back()
	UILog.text = currentText
	

###turn ordering
func initialize_turn_order():
	randomize()
	var randomized_list = enemy_list.duplicate()
	randomized_list.shuffle()
	randomized_list.push_front(player)
	turn_order = randomized_list
	act_in_order()

func act_in_order():
	if turn_order[0].name == "PC_Template":
		update_log("It is the player's turn!")
		isPlayersTurn = true
	else:
		update_log("It is the enemy's turn!")
		isPlayersTurn = false
		enemy_attack()

func shift_turn_order():
	var first_unit = turn_order[0]
	for i in range(0, turn_order.size()):
		if i + 1 < turn_order.size():
			turn_order[i] = turn_order[i+1]
		else:
			turn_order[i] = first_unit

#enemy_AI
func enemy_attack():
	player.hp -= 1
	get_tree().call_group("battle_group", "check_for_death")
	call_deferred("update_PC_UI")
	get_animation_player()
	enemyAnimationPlayer.play('attack')
	yield(enemyAnimationPlayer, 'animation_finished')
	shift_turn_order()
	act_in_order()


func get_animation_player():
	var children_list = turn_order[0].get_children()
	enemyAnimationPlayer = children_list[2]
