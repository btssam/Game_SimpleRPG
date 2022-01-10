extends Node2D

func _ready():
	print('overworld _ready')
	get_tree().call_group("battle_check_group", "start_timer")

var from_scene = "overworld"
var to_scene = ""


func _on_Area2D_To_Town_body_entered(body):
	to_scene = "town"
	get_tree().call_group("level_switching", "switch_scene", from_scene, to_scene)
	call_deferred("queue_free")
