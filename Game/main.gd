extends Node

#levelswitching
onready var party_node = $Party
var town_node = "res://Environment/Overworld/Town/Town_Template.tscn"
var overworld_node = "res://Environment/Overworld/Mainworld/Overworld_Template.tscn"
var battle_node = "res://Environment/Battlefield/Battlefield_Template.tscn"
var gameover_node = "res://Game/Game_Over.tscn"
var current_scene = "town"

var party_return_position
onready var gap_test_node = party_node.get_node("PC_Template/Gap_Directions")
var return_gap_direction

onready var menu_node = get_node("GUI/Menu_UI/Popup_Menu")



func _input(event):
	###for testing
	if event.is_action_pressed("mute_music"):
		if current_scene == "town":
			$Town_Template/AudioStreamPlayer.playing = !$Town_Template/AudioStreamPlayer.playing
		elif current_scene == "battle":
			$Battlefield_Template/AudioStreamPlayer.playing = !$Battlefield_Template/AudioStreamPlayer.playing
		elif current_scene == "overworld":
			$Overworld_Template/AudioStreamPlayer.playing = !$Overworld_Template/AudioStreamPlayer.playing
#	if event.is_action_pressed("start"):
#		get_tree().quit()
		



func switch_scene(from_scene, to_scene): 
	if from_scene == "town":
		if to_scene == "overworld":
			var overworld = load(overworld_node).instance()
			party_node.gap_direction = 'down'
			party_node.get_node("PC_Template").position = Vector2(0,0) #otherwise, it retains the difference between the spawn_point of the previous frame and the end position of the party_leader. the party_node doesn't move at all during movement
			party_node.position = overworld.get_node("Spawn_Points/From_Town").position
			load_scene(overworld)
			call_deferred("remove_child", $Town_Template)
			current_scene = "overworld"
			
	if from_scene == "overworld":
		if to_scene == "town":
			var town = load(town_node).instance()
			party_node.gap_direction = 'up'
			party_node.get_node("PC_Template").position = Vector2(0,0)
			party_node.position = town.get_node("Spawn_Points/From_Overworld").position
			load_scene(town)
			call_deferred("remove_child", $Overworld_Template)
			current_scene = "town"
		if to_scene == "battle":
			test_gap_direction()
	
	if from_scene == "battle":
		if to_scene == "overworld":
			var overworld = load(overworld_node).instance()
			party_node.get_node("PC_Template").position = Vector2(0,0)
			party_node.position = party_return_position
			party_node.gap_direction = return_gap_direction
			load_scene(overworld)
			call_deferred("remove_child", $Battlefield_Template)
			current_scene = "overworld"
		if to_scene == "gameover":
			var gameover = load(gameover_node).instance()
			party_node.gap_direction = 'up'
			party_node.get_node("PC_Template").position = Vector2(0,0)
#			party_node.position = Vector2(512, 384)
			party_node.position = gameover.get_node("Spawn_Points/Initial").position
			load_scene(gameover)
			call_deferred("remove_child", $Battlefield_Template)
			current_scene = "gameover"

	if from_scene == "gameover":
		if to_scene == "town":
			var town = load(town_node).instance()
			party_node.gap_direction = 'down'
			party_node.get_node("PC_Template").position = Vector2(0,0)
#			party_node.position = Vector2(512, 384)
			party_node.position = town.get_node("Spawn_Points/From_Overworld").position
			load_scene(town)
			call_deferred("remove_child", $Game_Over)
			current_scene = "town"
	get_node("Party").reset_party_position()

func load_scene(scene_name):
	call_deferred("add_child", scene_name)

#return from battle
func test_gap_direction(): #doesn't test again other collision types beside enviornment
	var gap_direction_confirmed = false
	return_gap_direction = 'down'
	var collision_node = get_node("Overworld_Template/Collision")
	while(!gap_direction_confirmed):
		if !gap_test_node.get_node("Down_Gap_Test").overlaps_body(collision_node):
			return_gap_direction = 'down'
			gap_direction_confirmed = true
		elif !gap_test_node.get_node("Right_Gap_Test").overlaps_body(collision_node):
			return_gap_direction = 'right'
			gap_direction_confirmed = true
		elif !gap_test_node.get_node("Left_Gap_Test").overlaps_body(collision_node):
			return_gap_direction = 'left'
			gap_direction_confirmed = true
		elif !gap_test_node.get_node("Up_Gap_Test").overlaps_body(collision_node):
			return_gap_direction == 'up'
			gap_direction_confirmed = true
		else:
			print('error, no gap directions are satisfactory')
			return_gap_direction == 'down'
			gap_direction_confirmed = true
	to_battle_from_overworld()

func to_battle_from_overworld():
	var battle = load(battle_node).instance()
	party_node.gap_direction = 'battling'
	party_return_position = party_node.position + party_node.get_node("PC_Template").position
	party_node.get_node("PC_Template").position = Vector2(0,0)
	party_node.position = battle.get_node("Spawn_Points/PC_1").position
	call_deferred("remove_child", $Overworld_Template)
	current_scene = "battle"
	load_scene(battle)
	get_node("Party").reset_party_position()
