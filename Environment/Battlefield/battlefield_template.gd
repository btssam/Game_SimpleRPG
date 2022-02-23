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
onready var command_card_1 = $BattleUI/Command_Card
onready var command_card_2 = $BattleUI/Command_Card2
onready var command_card_3 = $BattleUI/Command_Card3
onready var command_card_4 = $BattleUI/Command_Card4

var card_selector_sprite
var card_animation_player
var cardIsVisible =  false
var number_of_selections = 4
###updating UI
onready var enemy_stats_node = get_node("BattleUI/Battle_Bottom_UI/Enemies_Stats/Label")
onready var pc_stats_node = get_node("BattleUI/Battle_Bottom_UI/PCs_Stats/Label")
onready var ui_log_node = get_node("BattleUI/Battle_Bottom_UI/Log/Label")
var log_array = []
###turn ordering
var turn_order = []
onready var player_node = get_node("../Party/PC_Template")
var isPlayersTurn = true
var enemy_animationPlayer_node
###nodes
onready var main_node = get_node("..")
###enemy death
var targetable_enemy_list = []
var targetable_number_of_units
onready var victory_node = get_node("BattleUI/Victory_Popup")
var isVictorious = false
var isPlayerAnimating = false
###adding party
onready var party_node = get_node("../Party")
onready var player_2_node = get_node("../Party/Party_PC_Template1")
onready var player_3_node = get_node("../Party/Party_PC_Template2")
onready var player_4_node = get_node("../Party/Party_PC_Template3")
var active_party_member = 1 #set during act_in_order. around isPlayersTurn

func _ready():
	####initialize
	get_random_number_of_units()
	get_random_unit()
	add_enemies()
	###command card
	command_card_1.hide()
	command_card_2.hide()
	command_card_3.hide()
	command_card_4.hide()
	###UI_update
#	initialize_enemy_UI()
	update_enemy_UI()
#	initialize_PC_UI()
	update_PC_UI()
	initialize_log()
	###turn_ordering
	initialize_turn_order()

func _input(event):
	if isVictorious:
		if event.is_action_pressed("interact"):
			close_scene()
	if not player_node.isDead and not party_node.isAttacking: #can't do anything when dead. should be isTeamDead #party_node.isPartyDead
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
	targetable_number_of_units = number_of_units
	return number_of_units

func get_random_unit():
	randomize()
	var random_enemy = randi()%6 #0-5
	return random_enemy

func add_enemies():
	for i in range(0, number_of_units):
		var enemy = load(enemy_node).instance()
		var enemy_sprite = enemy.get_node("Sprite") #eventually will want different enemy scenes for each when they have dif functions
		enemy_sprite.frame = get_random_unit()
		if enemy_sprite.frame == 0:
			enemy.enemy_name = "Blue Fairy"
		elif enemy_sprite.frame == 1:
			enemy.enemy_name = "Brown Fairy"
		elif enemy_sprite.frame == 2:
			enemy.enemy_name = "Brown Wolf"
		elif enemy_sprite.frame == 3:
			enemy.enemy_name = "Green Wolf"
		elif enemy_sprite.frame == 4:
			enemy.enemy_name = "Red Goblin"
		elif enemy_sprite.frame == 5:
			enemy.enemy_name = "Purple Goblin"
		call_deferred("add_child", enemy)
		enemy_list.push_back(enemy)
		call_deferred('change_enemy_position')
	targetable_enemy_list = enemy_list.duplicate()

func change_enemy_position():
	for i in range(0, number_of_units):
		if number_of_units == 3:
			enemy_list[i].position = Vector2(224, 256 + 128 * i)
		if number_of_units == 2:
			enemy_list[i].position = Vector2(224, 341 + 85 * i)
		if number_of_units == 1:
			enemy_list[i].position = Vector2(224, 384)


####commandcard
func process_command():
	if isPlayersTurn: #which players?
		get_card_nodes()

		if not isSelectingTarget:
			if not cardIsVisible: #pop up card
#				command_card_1.show()
				if active_party_member == 1:
					command_card_1.show()
				elif active_party_member == 2:
					command_card_2.show()
				cardIsVisible = true
				isSelectingCommand = true
				enable_card_selector_sprite()
			else: #make selection. hide card
				disable_card_selector_sprite()
#				command_card_1.hide()
				if active_party_member == 1:
					command_card_1.hide()
				elif active_party_member == 2:
					command_card_2.hide()
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
#	var commands_list = command_card_1.get_node("TextureRect").get_children()
	var commands_list
	if active_party_member == 1:
		commands_list = command_card_1.get_node("TextureRect").get_children()
	elif active_party_member == 2:
		commands_list = command_card_2.get_node("TextureRect").get_children()
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
		if current_target < targetable_number_of_units - 1:
			disable_selector_sprite()
			current_target += 1
			enable_selector_sprite()
	
func get_target_nodes():
	target_selector_sprite = targetable_enemy_list[current_target].get_node("Selector")
	target_animation_player = targetable_enemy_list[current_target].get_node("AnimationPlayer")
	
func enable_selector_sprite():
	get_target_nodes()
	target_selector_sprite.visible = true
	target_animation_player.play('blink')

func disable_selector_sprite():
	get_target_nodes()
	target_selector_sprite.visible = false
	target_animation_player.stop()

func return_target():
	isSelectingTarget = false
	disable_selector_sprite()
	get_command()
#	shift_turn_order()
#	act_in_order()

#respond_to_command
func get_command():
	if current_command == 0: #attack
		party_node.isAttacking = true
#		player_node.get_node("AnimationPlayer").play("attack")
#		yield(player_node.get_node("AnimatedSprite"), "animation_finished")
#		player_node.update_animation("battling")
		if active_party_member == 1:
			player_node.get_node("AnimationPlayer").play("attack")
			yield(player_node.get_node("AnimatedSprite"), "animation_finished")
			player_node.update_animation("battling")
		elif active_party_member == 2:
			player_2_node.get_node("AnimationPlayer").play("attack")
			yield(player_2_node.get_node("AnimatedSprite"), "animation_finished")
			player_2_node.update_animation("battling")
		elif active_party_member == 3:
			player_3_node.get_node("AnimationPlayer").play("attack")
			yield(player_3_node.get_node("AnimatedSprite"), "animation_finished")
			player_3_node.update_animation("battling")
		elif active_party_member == 4:
			player_4_node.get_node("AnimationPlayer").play("attack")
			yield(player_4_node.get_node("AnimatedSprite"), "animation_finished")
			player_4_node.update_animation("battling")
		party_node.isAttacking = false
		targetable_enemy_list[current_target].hp -= 1
		check_enemy_death()
		update_enemy_UI()
		shift_turn_order()
		act_in_order()
	isPlayersTurn = false #which Players? use active_party_member to clarify


###other
func close_scene():
	get_node("../Party").isBattling = false
	main_node.switch_scene('battle', 'overworld')
	player_node.reset_battle_check()
	player_node.hp = player_node.maxhp
	player_2_node.hp = player_2_node.maxhp #add other players
	player_3_node.hp = player_3_node.maxhp
	player_4_node.hp = player_4_node.maxhp
	current_selection = 0
	isVictorious = false


###updating UI
#func initialize_enemy_UI():
#	for i in range(0, number_of_units):
#		enemy_stats_node.text += enemy_list[i].enemy_name + ': ' + str(enemy_list[i].hp) + '\n'

func update_enemy_UI():
	var newText = ''
	for i in range(0, number_of_units):
		newText += enemy_list[i].enemy_name + ': ' + str(enemy_list[i].hp) + '\n'
	enemy_stats_node.text = newText

#func initialize_PC_UI():
#	pc_stats_node.text += 'Player 1: ' + str(player_node.hp) + '\n' + 'Player 2: ' + str(player_2_node.hp) + '\n' #need to integrate multiple PC's. Should be backwards (Player 1 last), so that it aligns with the PC positions

func update_PC_UI():
	var newText = ''
	newText = 'Player 4: ' + str(player_4_node.hp) + '\n' + 'Player 3: ' + str(player_3_node.hp) + '\n' + 'Player 2: ' + str(player_2_node.hp) + '\n' + 'Player 1: ' + str(player_node.hp) + '\n'  #need to integrate multiple PC's
	pc_stats_node.text = newText
	
	#couldnt I just use update_UI instead of initialize (it sets with = rather than +=)

func initialize_log():
	ui_log_node.bbcode_text = ''

func update_log(message):
	log_array.push_front(message + '\n')
	var currentText = ''
	if log_array.size () > 6: #check if log is too long
		log_array.pop_back()
	for i in range(0, log_array.size()):
		currentText += log_array[i]
	ui_log_node.bbcode_text = currentText


###turn ordering
func initialize_turn_order():
	randomize()
	var randomized_list = enemy_list.duplicate()
	randomized_list.push_front(player_node) #Shouldn't necessarily be first, just for testing. Can fix by moving this line up
	randomized_list.shuffle()
	turn_order = randomized_list
	act_in_order()

func act_in_order():
	if not isVictorious:
		if turn_order[0].name == "PC_Template":
				update_log("It is the player's turn!")
				isPlayersTurn = true
		else:
			if player_node.hp <= 0:
				turn_order = []
			else:
				update_log("It is [color=red]" + turn_order[0].enemy_name + "[/color]'s turn!")
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
	enemy_animationPlayer_node = turn_order[0].get_node("AnimationPlayer")
	enemy_animationPlayer_node.play('attack')
	yield(enemy_animationPlayer_node, 'animation_finished')
	player_node.hp -= 1
	player_node.check_for_death() #my enemy attacks after character is daed, therefore glitching the game_over_load
	call_deferred("update_PC_UI") #if i dont defer, player goes to -1 as it is updated too quickly
	shift_turn_order()
	act_in_order()

func check_enemy_death():
	for i in range(0, targetable_number_of_units):
		if targetable_enemy_list[i-1].hp <= 0:
			targetable_enemy_list[i-1].hp = 0
			update_log("[color=red]" + targetable_enemy_list[i-1].enemy_name  + "[/color]" +  " has perished!")
			targetable_enemy_list[i-1].get_node("AnimationPlayer").play("dying")
			turn_order.erase(targetable_enemy_list[i-1])
			targetable_enemy_list.erase(targetable_enemy_list[i-1])
			current_target = 0
			targetable_number_of_units -= 1
	if targetable_number_of_units <= 0:
		victory_node.visible = true
		isVictorious = true
		update_log('You are victorious!')
