extends "res://Environment/Battlefield/Scripts/battlefield_targeting.gd"


onready var command_card = $BattleUI/Command_Card
var card_selector_sprite
var card_animation_player

var cardIsVisible =  false

var number_of_selections = 4


func _ready():
	command_card.hide()


func _input(event):
	if not isSelectingTarget:
		if event.is_action_pressed("interact"):
			process_command()
	
	if isSelectingSkill:
		if event.is_action_pressed("up"):
			change_skill("up")
		if event.is_action_pressed("down"):
			change_skill("down")


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
				select_target()    # see battlefield_targeting
			elif current_selection == 1: #skill
				print('no skills')
				isSelectingSkill = false
			elif current_selection == 2: #item
				print('no items')
				isSelectingSkill = false
			elif current_selection == 3: #flee
				isSelectingSkill = false
				current_selection = 0
				get_tree().call_group("battle_group", "close_scene") #currently in template


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
