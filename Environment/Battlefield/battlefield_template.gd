extends Node2D

###initialize
var enemy_node = "res://Characters/NPC/Enemy/Enemy_Template.tscn"
var number_of_units = 0
var enemy_list = []
###targeting
var isSelectingTarget = false
#var target_type = "enemy"
var target_type = "enemy"
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
onready var command_cards = [command_card_1, command_card_2, command_card_3, command_card_4]

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
onready var players = [player_node, player_2_node, player_3_node, player_4_node]
var active_party_member = 1 #set during act_in_order. around isPlayersTurn
###skills
onready var skill_card_1 = $BattleUI/Command_Card/Skill_Card
onready var skill_card_2 = $BattleUI/Command_Card2/Skill_Card
onready var skill_card_3 = $BattleUI/Command_Card3/Skill_Card
onready var skill_card_4 = $BattleUI/Command_Card4/Skill_Card
onready var skill_cards = [skill_card_1, skill_card_2, skill_card_3, skill_card_4]
var isSelectingSkill = false
var current_skill_selection = 0
var number_of_skill_selections = 0
var skill_card_selector_sprite
var skill_card_animation_player
var targetable_ally_list = []
var targetable_number_of_allies

var current_skill_effect_type = ''
var current_skill_effect = ''
var current_skill_mp = 0
var current_skill_description = ''
var current_skill_multi = 0.0
var current_skill_stat = 0
var skill_stat_assigner = 0
var current_skill_total_effect = 0

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
	###keep_hp
	initalize_targetable_ally_list()
	player_node.check_for_death()
	player_2_node.check_for_death()
	player_3_node.check_for_death()
	player_4_node.check_for_death()

	act_in_order()

func _input(event):
	if isVictorious:
		if event.is_action_pressed("interact"):
			close_scene()
	if not party_node.isPartyDead and not party_node.isAttacking: #cant interact while mid animation
		###targeting
		if isPlayersTurn:
			if isSelectingTarget:
				if event.is_action_pressed("up"):
					change_target("up")
				if event.is_action_pressed("down"):
					change_target("down")
				if event.is_action_pressed("interact"):
					return_target()
				if event.is_action_pressed("esc"):
					isSelectingTarget = false
					disable_selector_sprite()
					target_type = 'enemy' #prevent issues with attacking after skill
					process_command() #enable cursor right away
		###commandcard
			elif not isSelectingTarget:
				if event.is_action_pressed("interact"):
					process_command() #popup command_card
		
			if isSelectingCommand:
				if event.is_action_pressed("up"):
					change_command("up")
				if event.is_action_pressed("down"):
					change_command("down")
		###skillcard
			if isSelectingSkill:
				if event.is_action_pressed("up"):
					change_skill("up")
				if event.is_action_pressed("down"):
					change_skill("down")
				if event.is_action_pressed("esc"):
					isSelectingSkill = false
					isSelectingCommand = true
					disable_skill_card_selector_sprite()
					skill_cards[active_party_member - 1].hide()
					enable_card_selector_sprite()
		###testing
		if event.is_action_pressed("test_key"):
				close_scene()



###initialize
#spawn enemies
func get_random_number_of_units(): # 1-3
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

func change_enemy_position(): # only account for up to 3 enemies
	for i in range(0, number_of_units):
		if number_of_units == 3:
			enemy_list[i].position = Vector2(224, 256 + 128 * i)
		if number_of_units == 2:
			enemy_list[i].position = Vector2(224, 341 + 85 * i)
		if number_of_units == 1:
			enemy_list[i].position = Vector2(224, 384)


####commandcard
func process_command(): #which action occurs when space is pressed: (process_input)
	if isPlayersTurn: #disallows interaction if not players turn
		get_card_nodes()

		if not isSelectingTarget:
			if not cardIsVisible: #pop up card
				command_cards[active_party_member - 1].show()
				cardIsVisible = true
				isSelectingCommand = true
				enable_card_selector_sprite()
			else: #make selection. hide card
				disable_card_selector_sprite()
				if current_selection != 1: #hide main card if not selecting a skill
					command_cards[active_party_member - 1].hide()
					cardIsVisible = false
				current_command = current_selection  #do this here so dif. skills may target differently
				if current_selection == 0: #attack
					select_target()
				elif current_selection == 1 and isSelectingSkill == false: #open skill menu
					update_log('You have no skills.')
					isSelectingCommand = false
					isSelectingSkill = true
					get_skills(active_party_member)
					skill_cards[active_party_member - 1].show()
					
					enable_skill_card_selector_sprite()
				elif current_selection == 1 and isSelectingSkill == true: #select the skill
					disable_skill_card_selector_sprite()
					get_skill_effect()
				elif current_selection == 2: #item
					update_log('You have no items.')
					isSelectingCommand = false
					current_selection = 0 #will need to move this to after I process item selection
					current_command  = 0 #''
				elif current_selection == 3: #flee
					isSelectingCommand = false
					close_scene()

func change_command(direction):
	disable_card_selector_sprite()
	if direction == 'up':
		if current_selection > 0 :
			current_selection -= 1
	elif direction == 'down':
		if current_selection < number_of_selections - 1:
			current_selection += 1
	enable_card_selector_sprite()

func get_card_nodes():
	var commands_list
	commands_list = command_cards[active_party_member - 1].get_node("TextureRect").get_children()
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
	isSelectingSkill = false
	isSelectingTarget = true #I at one point needed to use set_deferred
	enable_selector_sprite()

func change_target(direction):
	disable_selector_sprite()
	if target_type == "enemy":
		if direction == 'up' and current_target > 0:
			current_target -= 1
		elif direction == 'down' and current_target < targetable_number_of_units - 1:
			current_target += 1
	elif target_type == "ally": #inverse for allies, as the positioning is inverse
		if direction == 'up' and current_target < targetable_number_of_allies - 1:
			current_target += 1
		elif direction == 'down' and current_target > 0:
			current_target -= 1
	enable_selector_sprite()
	
func get_target_nodes():
	target_selector_sprite = targetable_enemy_list[current_target].get_node("Selector")
	target_animation_player = targetable_enemy_list[current_target].get_node("AnimationPlayer")
	
func enable_selector_sprite():
	if target_type == "enemy":
		get_target_nodes()
		target_selector_sprite.visible = true
		target_animation_player.play('blink')
	elif target_type == "ally":
		get_target_ally_nodes()
		target_selector_sprite.visible = true
		target_animation_player.play('blink')
	elif target_type == "enemies":
		enable_enemies_selector()
	elif target_type == "allies":
		enable_allies_selector()
	elif target_type == "none":
		enable_self_selector()

func disable_selector_sprite():
	if target_type == "enemy":
		get_target_nodes()
		target_selector_sprite.visible = false
		target_animation_player.stop()
	elif target_type == "ally":
		get_target_ally_nodes()
		target_selector_sprite.visible = false
		target_animation_player.stop()
	elif target_type == "enemies":
		disable_enemies_selector()
	elif target_type == "allies":
		disable_allies_selector()
	elif target_type == "none":
		disable_self_selector()

func return_target():
	isSelectingTarget = false
	disable_selector_sprite()
	get_command()

#respond_to_command
func get_command():
	if current_command == 0: #attack
		target_type = 'enemy' #issue when selecting attack after canceling skill
		party_node.isAttacking = true
		players[active_party_member - 1].get_node("AnimationPlayer").play("attack")
		yield(players[active_party_member - 1].get_node("AnimatedSprite"), "animation_finished")
		players[active_party_member - 1].update_animation("battling")
		targetable_enemy_list[current_target].hp -= players[active_party_member - 1].attack
		party_node.isAttacking = false
	if current_command == 1: #skills. this needs to be updated when a new type of skill is add
		command_cards[active_party_member - 1].hide()
		skill_cards[active_party_member - 1].hide()
		cardIsVisible = false
		party_node.isAttacking = true
		players[active_party_member - 1].get_node("AnimationPlayer").play("attack")
		yield(players[active_party_member - 1].get_node("AnimatedSprite"), "animation_finished")
		players[active_party_member - 1].update_animation("battling")
		if target_type == 'enemy':
			if current_skill_effect_type == 'damage':
				targetable_enemy_list[current_target].hp -= current_skill_total_effect
		if target_type == 'enemies':
			if current_skill_effect_type ==  'damage':
				for i in targetable_number_of_units:
					targetable_enemy_list[i-1].hp -= current_skill_total_effect
					check_enemy_death()
		if target_type == 'ally':
			if current_skill_effect_type == 'heal':
				targetable_ally_list[current_target].hp += current_skill_total_effect
				check_max_player_health()
		if target_type == 'allies':
			if current_skill_effect_type == 'heal':
				for i in 4:
					players[i].hp += current_skill_total_effect
				check_max_player_health()
		if target_type == 'none':
			if current_skill_effect_type == 'heal':
				players[active_party_member - 1].hp += current_skill_total_effect
			check_max_player_health()
		players[active_party_member - 1].mp -= current_skill_mp
		check_mp()
		update_PC_UI()
		current_skill_selection = 0
		number_of_skill_selections = 0
		party_node.isAttacking = false
	check_enemy_death()
	update_enemy_UI()
	shift_turn_order()
	act_in_order()
	current_selection = 0
	current_command = 0
	current_target = 0
	target_type = 'enemy'


###other
func close_scene():
	get_node("../Party").isBattling = false
	main_node.switch_scene('battle', 'overworld')
	player_node.reset_battle_check()
	current_selection = 0
	isVictorious = false


###updating UI
func update_enemy_UI():
	var newText = ''
	for i in range(0, number_of_units):
		newText += enemy_list[i].enemy_name + ': ' + str(enemy_list[i].hp) + '\n'
	enemy_stats_node.text = newText

func update_PC_UI():
	var newText = ''
	for i in 4:
		var player_number = 4-i
		newText += 'P' + str(player_number) + ' [color=#CD5C5C]HP[/color]: ' + str(players[player_number-1].hp) + '/' + str(players[player_number-1].maxhp) + ' [color=#1E90FF]MP[/color]: ' + str(players[player_number-1].mp)  + '/' + str(players[player_number-1].maxmp) + '\n'
	pc_stats_node.bbcode_text = newText

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
func initialize_turn_order(): # would like to base on speed stat. likely would need enemy speed stats. and different enemy types
	randomize()
	var randomized_list = enemy_list.duplicate()
	randomized_list.append(player_node)
	randomized_list.append(player_2_node)
	randomized_list.append(player_3_node)
	randomized_list.append(player_4_node)
	randomized_list.shuffle()
	turn_order = randomized_list

func act_in_order():
	if not isVictorious:
		if turn_order[0].name == "PC_Template":
				update_log("It is Player 1's turn!")
				active_party_member = 1
				isPlayersTurn = true
		elif turn_order[0].name == "Party_PC_Template1":
				update_log("It is Player 2's turn!")
				active_party_member = 2
				isPlayersTurn = true
		elif turn_order[0].name == "Party_PC_Template2":
				update_log("It is Player 3's turn!")
				active_party_member = 3
				isPlayersTurn = true
		elif turn_order[0].name == "Party_PC_Template3":
				update_log("It is Player 4's turn!")
				active_party_member = 4
				isPlayersTurn = true
		else:
			if party_node.isPartyDead:
				turn_order = []
			else:
				update_log("It is [color=#8B0000]" + turn_order[0].enemy_name + "[/color]'s turn!")
				isPlayersTurn = false
				enemy_attack()

func shift_turn_order():
	var first_unit = turn_order[0] #shift the turn order forward once someone goes
	for i in range(0, turn_order.size()):
		if i + 1 < turn_order.size():
			turn_order[i] = turn_order[i+1]
		else:
			turn_order[i] = first_unit

#enemy_AI
func enemy_attack(): #could use targetable ally list
	enemy_animationPlayer_node = turn_order[0].get_node("AnimationPlayer")
	enemy_animationPlayer_node.play('attack')
	var hasSelected =  false
	yield(enemy_animationPlayer_node, "animation_finished")
	randomize()
	var random_player_target = randi()%4 + 1 #check if player is alive, then pick a different target
	while !hasSelected: #set a loop to pick a random target. maybe based on an aggro stat or player hp
		if !players[random_player_target - 1].isDead:
			players[random_player_target - 1].hp -= 1
			players[random_player_target - 1].check_for_death()
			hasSelected = true
		if random_player_target < 4: #why is this here. so that when they randomize a dead target, it goes onto the next
			random_player_target += 1
		else:
			random_player_target = 1
	call_deferred("update_PC_UI") #if i dont defer, player goes to -1 as it is updated too quickly
	shift_turn_order()
	act_in_order()

func check_enemy_death():
	for i in range(0, targetable_number_of_units):
		if targetable_enemy_list[i-1].hp <= 0:
			targetable_enemy_list[i-1].hp = 0
			update_log("[color=#8B0000]" + targetable_enemy_list[i-1].enemy_name  + "[/color]" +  " has perished!")
			targetable_enemy_list[i-1].get_node("AnimationPlayer").play("dying")
			turn_order.erase(targetable_enemy_list[i-1])
			targetable_enemy_list.erase(targetable_enemy_list[i-1])
			current_target = 0
			targetable_number_of_units -= 1
	if targetable_number_of_units <= 0:
		victory_node.visible = true
		isVictorious = true
		update_log('You are victorious!')



#skills
func get_skills(party_member):
	var skills_text = [skill_cards[party_member - 1].get_node("TextureRect/Skill1"), skill_cards[party_member - 1].get_node("TextureRect/Skill2"), skill_cards[party_member - 1].get_node("TextureRect/Skill3"), skill_cards[party_member - 1].get_node("TextureRect/Skill4"), skill_cards[party_member - 1].get_node("TextureRect/Skill5")]
	for i in 5:
		skills_text[i].text = ''
	number_of_skill_selections = players[party_member - 1].number_of_skills
	for i in number_of_skill_selections: #update names of skills
		skills_text[i].text = players[party_member - 1].skills[i].name

func get_skill_card_nodes():
	var skills_list
	skills_list = skill_cards[active_party_member - 1].get_node("TextureRect").get_children()
	skill_card_selector_sprite = skills_list[current_skill_selection].get_node("Selector")
	skill_card_animation_player = skills_list[current_skill_selection].get_node("AnimationPlayer")

func enable_skill_card_selector_sprite():
	get_skill_card_nodes()
	skill_card_selector_sprite.visible = true
	skill_card_animation_player.play('blink')

func disable_skill_card_selector_sprite():
	get_skill_card_nodes()
	skill_card_selector_sprite.visible = false
	skill_card_animation_player.stop()

func change_skill(direction):
	if direction == 'up':
		if current_skill_selection > 0 :
			disable_skill_card_selector_sprite()
			current_skill_selection -= 1
			enable_skill_card_selector_sprite()
	elif direction == 'down':
		if current_skill_selection < number_of_skill_selections - 1:
			disable_skill_card_selector_sprite()
			current_skill_selection += 1
			enable_skill_card_selector_sprite()

func get_skill_effect():
	target_type = players[active_party_member - 1].skills[current_skill_selection].targets
	current_skill_effect_type = players[active_party_member - 1].skills[current_skill_selection].effect_type
	current_skill_effect = players[active_party_member - 1].skills[current_skill_selection].effect
	current_skill_mp = players[active_party_member - 1].skills[current_skill_selection].mp.to_int()
	current_skill_description = players[active_party_member - 1].skills[current_skill_selection].description
	current_skill_stat = current_skill_effect.left(3)
	current_skill_multi = current_skill_effect.right(4).to_float()
	skill_stat_assigner = {'ATK': players[active_party_member - 1].attack, 'DEF': players[active_party_member - 1].defence, 'INT': players[active_party_member - 1].intellect, 'SPD': players[active_party_member - 1].speed}
	current_skill_stat = skill_stat_assigner[current_skill_stat]
	current_skill_total_effect = current_skill_stat * current_skill_multi
	print('Current_skill_effect_type: ' + str(current_skill_effect_type) +
	'\nCurrent_skill_total_effect' + str(current_skill_total_effect) +
	'\nCurrent_skill_mp: ' + str(current_skill_mp) +
	'\nCurrent_skill_description: ' + str(current_skill_description))
	select_target()

func initalize_targetable_ally_list():
	targetable_ally_list = players.duplicate()
	targetable_number_of_allies = players.size()

func get_target_ally_nodes():
	target_selector_sprite = targetable_ally_list[current_target].get_node("Selector")
	target_animation_player = targetable_ally_list[current_target].get_node("AnimationPlayer")

func enable_enemies_selector():
	for i in targetable_number_of_units:
		target_selector_sprite = targetable_enemy_list[i].get_node("Selector")
		target_animation_player = targetable_enemy_list[i].get_node("AnimationPlayer")
		target_selector_sprite.visible = true
		target_animation_player.play('blink')
		
func disable_enemies_selector():
	for i in targetable_number_of_units:
		target_selector_sprite = targetable_enemy_list[i].get_node("Selector")
		target_animation_player = targetable_enemy_list[i].get_node("AnimationPlayer")
		target_selector_sprite.visible = false
		target_animation_player.stop()

func enable_allies_selector():
	for i in targetable_number_of_allies:
		target_selector_sprite = targetable_ally_list[i].get_node("Selector")
		target_animation_player = targetable_ally_list[i].get_node("AnimationPlayer")
		target_selector_sprite.visible = true
		target_animation_player.play('blink')
		
func disable_allies_selector():
	for i in targetable_number_of_allies:
		target_selector_sprite = targetable_ally_list[i].get_node("Selector")
		target_animation_player = targetable_ally_list[i].get_node("AnimationPlayer")
		target_selector_sprite.visible = false
		target_animation_player.stop()

func enable_self_selector():
	target_selector_sprite = players[active_party_member - 1].get_node("Selector")
	target_animation_player = players[active_party_member - 1].get_node("AnimationPlayer")
	target_selector_sprite.visible = true
	target_animation_player.play('blink')
	
func disable_self_selector():
	target_selector_sprite = players[active_party_member - 1].get_node("Selector")
	target_animation_player = players[active_party_member - 1].get_node("AnimationPlayer")
	target_selector_sprite.visible = false
	target_animation_player.stop()

func check_max_player_health():
	for i in 4:
		if players[i].hp > players[i].maxhp:
			players[i].hp = players[i].maxhp

func check_skills_mp():
	pass

func check_mp():
	if players[active_party_member - 1].mp < 0:
		players[active_party_member - 1].mp = 0
	if players[active_party_member - 1].mp > players[active_party_member - 1].maxmp:
		players[active_party_member - 1].mp = players[active_party_member - 1].maxmp
