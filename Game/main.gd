extends Node


onready var Player = $PC_OW_Template

var town_node = "res://Environment/Overworld/Town/TownTemplate.tscn"
var overworld_node = "res://Environment/Overworld/Mainworld/Overworld_Template.tscn"

func switch_scene(from_scene, to_scene):
	if from_scene == "town":
		if to_scene == "overworld":
			var overworld = load(overworld_node).instance()
			Player.position = Vector2(496, 368)
			load_scene(overworld)
			
	if from_scene == "overworld":
		if to_scene == "town":
			var town = load(town_node).instance()
			Player.position = Vector2(512, 96)
			load_scene(town)

func load_scene(scene_name):
	call_deferred("add_child", scene_name)
	call_deferred("move_child", Player, 3) #so that the Player is above the BG

