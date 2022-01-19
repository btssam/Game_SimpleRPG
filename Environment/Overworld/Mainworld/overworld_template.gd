extends Node2D

func _ready():
	get_tree().call_group("battle_check_group", "start_timer") #when enter overworld, start checking for battles

var from_scene = "overworld"
var to_scene = ""


func _on_Area2D_To_Town_body_entered(body):
	to_scene = "town"
	get_tree().call_group("level_switching", "switch_scene", from_scene, to_scene)
	get_tree().call_group("battle_check_group", "stop_battle_check")
