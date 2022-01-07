extends Node2D

onready var main_node = get_tree().get_root().get_node("Main")
var next_positon = Vector2(496, 384)


func _on_Area2D_Change_Level_body_entered(body):
	get_tree().call_group("level_switching", "save_player_node", next_positon)
	get_tree().call_group("level_switching", "load_player_node")

	
	main_node.add_child((load("res://Environment/Overworld/Mainworld/Overworld_Template.tscn").instance()))
	queue_free()
