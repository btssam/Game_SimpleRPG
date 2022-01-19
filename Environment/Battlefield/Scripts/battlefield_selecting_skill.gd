extends "res://Environment/Battlefield/Scripts/battlefield_targeting.gd"


func _input(event):
	if isSelectingSkill:
		if event.is_action_pressed("up"):
			change_skill("up")
		if event.is_action_pressed("down"):
			change_skill("down")


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
