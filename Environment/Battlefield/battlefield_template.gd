extends "res://Environment/Battlefield/Scripts/battlefield_selecting_skill.gd"
#also extends:
# battlefield_initialize.gd
# battlefield_targeting




func _ready():
	pass


#handle inputs
func _input(event):
	if event.is_action_pressed("test_key"):
		close_scene()




#respond to input
func close_scene():
	get_tree().call_group("level_switching", "switch_scene", "battle", "overworld")
	get_tree().call_group("battle_check_group", "reset_battle_check")

