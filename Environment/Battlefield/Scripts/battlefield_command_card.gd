extends "res://Environment/Battlefield/Scripts/battlefield_targeting.gd"
#currently this script is unused


onready var command_card = $BattleUI/Command_Card

var cardIsVisible =  false
#var isSelectingSkill = false

#var current_selection = 0
var number_of_selections = 4

var card_selector_sprite
var card_animation_player


func _ready():
	command_card.hide()


func _input(event):
	if not isSelectingTarget and not isSelectingSkill: #and not isSelectingSkill
		if event.is_action_pressed("interact"):
			process_command()
#			isSelectingSkill = true
	
	if isSelectingSkill:
		if event.is_action_pressed("up"):
			change_skill("up")
		if event.is_action_pressed("down"):
			change_skill("down")


func process_command(): #callback #should be called process_command
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
				print('trying to attack')
				select_target()
#				isSelectingTarget = false #this is added, but should not be needed in new version
			elif current_selection == 1: #skill
				print('no skills')
			elif current_selection == 2: #item
				print('no items')
			elif current_selection == 3: #flee
				current_selection = 0
				get_tree().call_group("battle_group", "close_scene")


func change_skill(direction):
	
	if direction == 'up':
		if current_selection > 0 :
			print('selection up')
			disable_card_selector_sprite()
			current_selection -= 1
			enable_card_selector_sprite()
	elif direction == 'down':
		if current_selection < number_of_selections - 1:
			print('selection down')
			disable_card_selector_sprite()
			current_selection += 1
			enable_card_selector_sprite()

func get_card_nodes(): #get the selector and animator of current selection(label node)
	var children_list = command_card.get_children()
	var commands_list = children_list[1].get_children()
	var command_children_list = commands_list[current_selection].get_children()
	card_selector_sprite = command_children_list[0]
	card_animation_player = command_children_list[1]

func enable_card_selector_sprite(): #must rename thise two functions, as the same name is in battlefield_targeting
	get_card_nodes()
	card_selector_sprite.visible = true
	card_animation_player.play('blink')
	
func disable_card_selector_sprite():
	get_card_nodes()
	card_selector_sprite.visible = false
	card_animation_player.stop()
