extends Node

onready var Player = $PC_OW_Template

var town_node = "res://Environment/Overworld/Town/Town_Template.tscn"
var overworld_node = "res://Environment/Overworld/Mainworld/Overworld_Template.tscn"
var battle_node = "res://Environment/Battlefield/Battlefield_Template.tscn"

# need to add a spawn_point argument for positioning
func switch_scene(from_scene, to_scene): 
	if from_scene == "town":
		if to_scene == "overworld":
			var overworld = load(overworld_node).instance()
			Player.position = Vector2(496, 368)
			load_scene(overworld)
			remove_child($Town_Template)
			
	if from_scene == "overworld":
		if to_scene == "town":
			var town = load(town_node).instance()
			Player.position = Vector2(512, 96)
			load_scene(town)
			remove_child($Overworld_Template)
		if to_scene == "battle":
			var battle = load(battle_node).instance()
			Player.position = Vector2(800, 512)
			load_scene(battle)
			remove_child($Overworld_Template) #bc this is being called from the player, otherwise it is just queued free itself. should possible to just free all from here for consistency
	
	if from_scene == "battle":
		if to_scene == "overworld":
			var overworld = load(overworld_node).instance()
			Player.position = Vector2(500, 500)
			load_scene(overworld)
			remove_child($Battlefield_Template)


func load_scene(scene_name):
	call_deferred("add_child", scene_name)

