extends Node2D

###initialize
var enemy_node = "res://Characters/NPC/Enemy/Enemy_Template.tscn"
var number_of_units = 0
var enemy_list = []
###targeting
var isSelectingTarget = false
var current_target = 0
var isSelectingCommand = false
var current_command = 0
var current_selection = 0
var target_selector_sprite
var target_animation_player
###command card
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
onready var player_node = get_node("../PC_Template")
var isPlayersTurn = true
var enemyAnimationPlayer
###nodes
onready var main_node = get_node("..")


func _ready():
	####initialize
	get_random_number_of_units()
	get_random_unit()
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
	if not player_node.isDead: #can't do anything when dead. ultimately should be isTeamDead
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
			elif not isSelectingTarget:
				if event.is_action_pressed("interact"):
					process_command()
		
			if isSelectingCommand:
				if event.is_action_pressed("up"):
					change_command("up")
				if event.is_action_pressed("down"):
					change_command("down")
		###testing
		if event.is_action_pressed("test_key"):
				close_scene()



###initialize
#spawn enemies
func get_random_number_of_units():
	randomize()
	number_of_units = randi()%3 + 1
	return number_of_units

func get_random_unit():
	randomize()
	var random_enemy = randi()%6 #0-5
	return random_enemy

func add_enemies():
	for i in range(0, number_of_units):
		var enemy = load(enemy_node).instance()
		var enemy_sprite = enemy.get_node("Sprite")
		enemy_sprite.frame = get_random_unit()
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


####commandcard
func process_command():
	if isPlayersTurn:
		get_card_nodes()

		if not isSelectingTarget:
			if not cardIsVisible:
				command_card.show()
				cardIsVisible = true
				isSelectingCommand = true
				enable_card_selector_sprite()
			else:
				disable_card_selector_sprite()
				command_card.hide()
				cardIsVisible = false
				current_command = current_selection  #do this here so dif. skills may target differently
				if current_selection == 0: #attack
					select_target()
				elif current_selection == 1: #skill
					update_log('You have no skills.')
					isSelectingCommand = false
				elif current_selection == 2: #item
					update_log('You have no items.')
					isSelectingCommand = false
				elif current_selection == 3: #flee
					isSelectingCommand = false
					close_scene()

func change_command(direction):
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

func get_card_nodes():
	var commands_list = command_card.get_node("TextureRect").get_children()
	card_selector_sprite = commands_list[current_selection].get_node("Selector")
	card_animation_player = commands_list[current_selection].get_node("AnimationPlayer")

func enable_card_selector_sprite():
	get_card_nodes()
	card_selector_sprite.visible = true
	card_animation_player.play('blink')
	
func disable_card_selector_sprite():
	get_card_nodes()
	card_selector_sprite.visible = false
	card_animation_player.stop()


###targeting
#targeting an enemy
func select_target():
	isSelectingCommand = false
	isSelectingTarget = true #I at one point needed to use set_deferred
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
	get_target_nodes()
	target_selector_sprite.visible = true
	target_animation_player.play('blink')

func disable_selector_sprite():
	get_target_nodes()
	target_selector_sprite.visible = false
	target_animation_player.stop()

func get_target_nodes():
	target_selector_sprite = enemy_list[current_target].get_node("Selector")
	target_animation_player = enemy_list[current_target].get_node("AnimationPlayer")

func return_target():
	isSelectingTarget = false
	disable_selector_sprite()
	get_command()
	shift_turn_order()
	act_in_order()

#respond_to_command
func get_command():
	if current_command == 0: #attack
		enemy_list[current_target].hp -= 1
		update_enemy_UI()
	isPlayersTurn = false


###other
func close_scene():
	main_node.switch_scene('battle', 'overworld')
	player_node.reset_battle_check()
	player_node.hp = player_node.maxhp
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
	PCStats.text += 'Player 1: ' + str(player_node.hp) + '\n'    #need to integrate multiple PC's

func update_PC_UI():
	var newText = ''
	newText = 'Player 1: ' + str(player_node.hp) + '\n'    #need to integrate multiple PC's
	PCStats.text = newText

func initialize_log():
	UILog.text = ''

func update_log(message):
	logArray.push_front(message + '\n')
	var currentText = ''
	if logArray.size () > 6: #check if log is too long
		logArray.pop_back()
	for i in range(0, logArray.size()):
		currentText += logArray[i]
	UILog.text = currentText


###turn ordering
func initialize_turn_order():
	randomize()
	var randomized_list = enemy_list.duplicate()
	randomized_list.shuffle()
	randomized_list.push_front(player_node) #Shouldn't necessarily be first, just for testing. Can fix by moving this line up
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
	var first_unit = turn_order[0] #move the turn order forward once someone goes
	for i in range(0, turn_order.size()):
		if i + 1 < turn_order.size():
			turn_order[i] = turn_order[i+1]
		else:
			turn_order[i] = first_unit

#enemy_AI
func enemy_attack():
	player_node.hp -= 1
	player_node.check_for_death()
	call_deferred("update_PC_UI") #if i dont defer, player goes to -1 as it is updated too quickly
	enemyAnimationPlayer = turn_order[0].get_node("AnimationPlayer")
	enemyAnimationPlayer.play('attack')
	yield(enemyAnimationPlayer, 'animation_finished')
	shift_turn_order()
	act_in_order()
