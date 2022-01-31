extends Node2D

var from_scene = "town"
var to_scene = ""
onready var main_node = get_node("..")



func _on_Area2D_To_Overworld_body_entered(body):
	to_scene = "overworld"
	main_node.switch_scene(from_scene, to_scene)
