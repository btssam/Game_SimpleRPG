extends "res://Environment/Battlefield/Scripts/battlefield_targeting.gd"
#also extends:
# battlefield_initialize.gd





func _ready():
	pass


#handle inputs
func _input(event):
	if event.is_action_pressed("test_key"):
		close_scene()
		
	if not isSelectingTarget:
		if event.is_action_pressed("interact"):
			open_command_popup()
	
	if isSelectingTarget:
		if event.is_action_pressed("up"):
			change_target("up")
		if event.is_action_pressed("down"):
			change_target("down")
		if event.is_action_pressed("interact"):
			return_target()
			
	if isSelectingSkill:
		if event.is_action_pressed("up"):
			change_skill("up")
		if event.is_action_pressed("down"):
			change_skill("down")





#respond to input
func close_scene():
	get_tree().call_group("level_switching", "switch_scene", "battle", "overworld")
	get_tree().call_group("battle_check_group", "reset_battle_check")

#open commands
func open_command_popup():
	get_tree().call_group("battle_group", "open_commands_popup")
	isSelectingSkill = true
	
#select command
func change_skill(direction):
	get_tree().call_group("battle_group", "change_current_selection", direction)

#respond_to_skill
func get_skill(skill):
	current_skill = skill
	print("skill recieved:" + str(current_skill))
	respond_to_skill(current_skill, current_target)
	
func respond_to_skill(skill, target):
	if skill == 0:
		print('attempt to lower hp')
		enemy_list[target].hp -= 1
		print(enemy_list[target].hp)
