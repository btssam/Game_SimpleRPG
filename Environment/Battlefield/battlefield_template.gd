extends "res://Environment/Battlefield/Scripts/battlefield_command_card.gd"
#also extends:
# battlefield_initialize.gd
# battlefield_targeting




func _ready():
	pass


func _input(event):
	if event.is_action_pressed("test_key"):
		close_scene()




func close_scene():
	get_tree().call_group("level_switching", "switch_scene", "battle", "overworld")
	get_tree().call_group("battle_check_group", "reset_battle_check")

