extends "res://Environment/Battlefield/Scripts/battlefield_initalize.gd"


var isSelectingTarget = false
var current_target = 0
var isSelectingSkill = false
var current_skill = 0

var current_selection = 0

func _ready():
	pass

func _input(event):

	if isSelectingTarget:
		if event.is_action_pressed("up"):
			change_target("up")
		if event.is_action_pressed("down"):
			change_target("down")
		if event.is_action_pressed("interact"):
			return_target()


#	#selecting skills
#	if isSelectingSkill: #handled by command_card. comment me out
#		if event.is_action_pressed("up"):
#			change_skill("up")
#		if event.is_action_pressed("down"):
#			change_skill("down")


#targeting an enemy
func select_target():
	print('pick a target')
	isSelectingSkill = false
#	yield(get_tree().create_timer(0.5), "timeout") #testing
	isSelectingTarget = true
	enable_selector_sprite()

func change_target(direction):
	print('change_target')
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
	get_skill()
	


#selecting skills
#select command
func change_skill(direction):
	get_tree().call_group("battle_group", "change_current_selection", direction)

#respond_to_skill
func get_skill():
	current_skill = current_selection
	print("skill recieved:" + str(current_skill))
	respond_to_skill()
	
func respond_to_skill():
	if current_skill == 0: #attack
		print('attempt to lower hp')
		enemy_list[current_target].hp -= 1
		print(enemy_list[current_target].hp)
