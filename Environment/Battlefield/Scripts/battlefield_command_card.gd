extends "res://Environment/Battlefield/Scripts/battlefield_selecting_skill.gd"
#currently this script is unused


onready var command_card = $"../PC_Template/Command_Card"

var cardIsVisible = false

var number_of_selections = 4
#var current_open_cards = 0

var selector_sprite
var animation_player

func _ready():
	command_card.hide()

func _input(event):
	if event.is_action_pressed("interact"):
		process_command()

func process_command():
	get_nodes()

	if not isSelectingTarget:
		if not cardIsVisible:
			print('show command card')
			command_card.show()
			cardIsVisible = true
			enable_command_selector_sprite()
		else:
			disable_command_selector_sprite()
			command_card.hide()
			cardIsVisible = false
			if current_selection == 0: #attack
				isSelectingTarget = true
				select_target()
			elif current_selection == 1: #skill
				print('no skills')
			elif current_selection == 2: #item
				print('no items')
			elif current_selection == 3: #flee
				current_selection = 0
				get_tree().call_group("battle_group", "close_scene")

func change_current_selection(direction):   #instead of using get_nodes, just do something like $command_card/texturerect/"attack" and change the in quote part only
	if direction == 'up':
		if current_selection > 0 :
			get_nodes()
			disable_selector_sprite()
			current_selection -= 1
			get_nodes()
			enable_selector_sprite()
	elif direction == 'down':
		if current_selection < number_of_selections - 1:
			get_nodes()
			disable_selector_sprite()
			current_selection += 1
			get_nodes()
			enable_selector_sprite()
	
func get_nodes(): #get the selector and animator of current selection(label node)
	var children_list = command_card.get_children()
	var commands_list = children_list[1].get_children()
	var command_children_list = commands_list[current_selection].get_children()
	selector_sprite = command_children_list[0]
	animation_player = command_children_list[1]

func enable_command_selector_sprite():
	get_nodes()
	selector_sprite.visible = true
	animation_player.play('blink')
	
func disable_command_selector_sprite():
	get_nodes()
	selector_sprite.visible = false
	animation_player.stop()

