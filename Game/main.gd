extends Node

onready var Player = $PC_OW_Template

#levels
onready var overworld = load("res://Environment/Overworld/Mainworld/Overworld_Template.tscn").instance()
onready var town = load("res://Environment/Overworld/Town/TownTemplate.tscn").instance()

func switch_scene(from_scene, to_scene):
	if from_scene == "town" and to_scene == "overworld":
#		Player.position = Vector2(496, 384)
		Player.position = Vector2(200, 200)
		load_scene(overworld)
		print('to overworld')
	if from_scene == "overworld":
		if to_scene == "town":
			Player.position = Vector2(200, 200)
			load_scene(town)
			print('to town')
			

func load_scene(scene_name):
	call_deferred("add_child", scene_name)
	call_deferred("move_child", Player, 3) #so that the Player is above the BG
