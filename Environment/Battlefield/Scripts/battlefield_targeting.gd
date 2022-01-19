extends "res://Environment/Battlefield/Scripts/battlefield_initalize.gd"

var isSelectingTarget = false
var current_target = 0
var isSelectingSkill = false
#var current_skill = 0

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
	

