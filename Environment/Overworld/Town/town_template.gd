extends Node2D


var from_scene = "town"
var to_scene = ""


func _on_Area2D_To_Overworld_body_entered(body):
	to_scene = "overworld"
	get_tree().call_group("level_switching", "switch_scene", from_scene, to_scene)
