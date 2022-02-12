extends Node2D

var from_scene = "overworld"
var to_scene = ""
onready var main_node = get_node("..")



func _ready():
	get_node("../Party/PC_Template/Delta_Position1").start()


#func _on_Area2D_To_Town_body_entered(body):
#	to_scene = "town"
#	get_node("../PC_Template").stop_battle_check()
#	main_node.switch_scene(from_scene, to_scene)
