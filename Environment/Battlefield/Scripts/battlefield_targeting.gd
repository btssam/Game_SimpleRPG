extends "res://Environment/Battlefield/Scripts/battlefield_initalize.gd"


var isSelectingTarget = false
var current_target = 0
var isSelectingSkill = false
var current_skill = 0


func _ready():
	pass

func _input(event):
	if not isSelectingTarget:
		if event.is_action_pressed("interact"):
			open_command_popup()
	
	elif isSelectingTarget:
		if event.is_action_pressed("up"):
			change_target("up")
		if event.is_action_pressed("down"):
			change_target("down")
		if event.is_action_pressed("interact"):
			return_target()


#open commands
func open_command_popup():
	get_tree().call_group("battle_group", "open_commands_popup")
#	print($"../PC_Template/Command_Card")
#	$"../PC_Template/Command_Card".show()     I could use this to acces the command_card
#   											rather than use a group call.
	isSelectingSkill = true

#targeting an enemy
func select_target():
	isSelectingSkill = false
	isSelectingTarget = true
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
	print(current_target)
	isSelectingTarget = false
	disable_selector_sprite()
	get_tree().call_group("battle_group", "hasSelected")
	
