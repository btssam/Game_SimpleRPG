extends Node

#levelswitching
onready var player_node = $PC_Template
var town_node = "res://Environment/Overworld/Town/Town_Template.tscn"
var overworld_node = "res://Environment/Overworld/Mainworld/Overworld_Template.tscn"
var battle_node = "res://Environment/Battlefield/Battlefield_Template.tscn"
var gameover_node = "res://Game/Game_Over.tscn"
var current_scene = "town"



func _input(event):
	###for testing
	if event.is_action_pressed("mute_music"):
		if current_scene == "town":
			$Town_Template/AudioStreamPlayer.playing = !$Town_Template/AudioStreamPlayer.playing
		elif current_scene == "battle":
			$Battlefield_Template/AudioStreamPlayer.playing = !$Battlefield_Template/AudioStreamPlayer.playing
		elif current_scene == "overworld":
			$Overworld_Template/AudioStreamPlayer.playing = !$Overworld_Template/AudioStreamPlayer.playing
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

# need to add a spawn_point argument for positioning
func switch_scene(from_scene, to_scene): 
	if from_scene == "town":
		if to_scene == "overworld":
			var overworld = load(overworld_node).instance()
			player_node.position = Vector2(496, 368)
			load_scene(overworld)
			call_deferred("remove_child", $Town_Template)
#			remove_child($Town_Template)
			current_scene = "overworld"
			
	if from_scene == "overworld":
		if to_scene == "town":
			var town = load(town_node).instance()
			player_node.position = Vector2(512, 96)
			load_scene(town)
			remove_child($Overworld_Template)
			current_scene = "town"
		if to_scene == "battle":
			var battle = load(battle_node).instance()
			player_node.position = Vector2(800, 512)
			load_scene(battle)
			remove_child($Overworld_Template)
			current_scene = "battle"
	
	if from_scene == "battle":
		if to_scene == "overworld":
			var overworld = load(overworld_node).instance()
			player_node.position = Vector2(500, 500)
			load_scene(overworld)
			remove_child($Battlefield_Template)
			current_scene = "overworld"
		if to_scene == "gameover":
			var gameover = load(gameover_node).instance()
			player_node.position = Vector2(512, 384)
			load_scene(gameover)
			remove_child($Battlefield_Template)
			current_scene = "gameover"
			
	if from_scene == "gameover":
		if to_scene == "town":
			var town = load(town_node).instance()
			player_node.position = Vector2(512, 384)
			load_scene(town)
			remove_child($Game_Over)
			current_scene = "town"

func load_scene(scene_name):
	call_deferred("add_child", scene_name)

