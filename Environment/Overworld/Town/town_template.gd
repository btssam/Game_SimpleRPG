extends Node2D

onready var main_node = get_node("..")
var from_scene = "town"
var to_scene = ""



func _on_Area2D_To_Overworld_body_entered(body):
	to_scene = "overworld"
	main_node.switch_scene(from_scene, to_scene)
