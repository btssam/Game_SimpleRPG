extends Node

#levelswitching
onready var party_node = $Party/
var town_node = "res://Environment/Overworld/Town/Town_Template.tscn"
var overworld_node = "res://Environment/Overworld/Mainworld/Overworld_Template.tscn"
var battle_node = "res://Environment/Battlefield/Battlefield_Template.tscn"
var gameover_node = "res://Game/Game_Over.tscn"
var current_scene = "town"

var party_return_position
var gap_directions_test = "res://Characters/PC/Gap_Directions.tscn"


func _ready():
	test_gap_direction()

#func _process(delta):
#	test_gap_direction()

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
			var battle = load(battle_node).instance()
			party_node.gap_direction = 'battling'
			party_return_position = party_node.position + party_node.get_node("PC_Template").position
			party_node.get_node("PC_Template").position = Vector2(0,0)
			party_node.position = battle.get_node("Spawn_Points/PC_1").position
			load_scene(battle)
			call_deferred("remove_child", $Overworld_Template)
			current_scene = "battle"
	
	if from_scene == "battle":
		if to_scene == "overworld":
			var overworld = load(overworld_node).instance()
			party_node.gap_direction = 'down'
			party_node.get_node("PC_Template").position = Vector2(0,0)
			party_node.position = party_return_position #need to adjust gap_direction based on that.
			load_scene(overworld)
			call_deferred("remove_child", $Battlefield_Template)
			current_scene = "overworld"
		if to_scene == "gameover":
			var gameover = load(gameover_node).instance()
			party_node.get_node("PC_Template").position = Vector2(0,0)
			party_node.position = Vector2(512, 384)
			load_scene(gameover)
			call_deferred("remove_child", $Battlefield_Template)
			current_scene = "gameover"
			
	if from_scene == "gameover":
		if to_scene == "town":
			var town = load(town_node).instance()
			party_node.get_node("PC_Template").position = Vector2(0,0)
			party_node.position = Vector2(512, 384)
			load_scene(town)
			call_deferred("remove_child", $Game_Over)
			current_scene = "town"
	get_node("Party").reset_party_position()

func load_scene(scene_name):
	call_deferred("add_child", scene_name)


func test_gap_direction():
	party_node.add_child(load(gap_directions_test).instance())
	print(party_node.get_node("Gap_Directions/Timer"))
	party_node.get_node("Gap_Directions/Timer").start()
	yield(party_node.get_node("Gap_Directions/Timer"), "timeout")
	if party_node.get_node("Gap_Directions/Down_Gap_Test").overlaps_body(get_node("Town_Template/Collision")): #change to ow_template
		print('problem with down_direction')
	elif party_node.get_node("Gap_Directions/Right_Gap_Test").overlaps_body(get_node("Town_Template/Collision")):
		print('problem with right_direction')
	elif party_node.get_node("Gap_Directions/Left_Gap_Test").overlaps_body(get_node("Town_Template/Collision")):
		print('problem with left_direction')
	elif party_node.get_node("Gap_Directions/Up_Gap_Test").overlaps_body(get_node("Town_Template/Collision")):
		print('problem with up_direction')
	else:
		print('use default collision')
	party_node.get_node("Gap_Directions").queue_free()
