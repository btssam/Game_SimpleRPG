extends Node

var Player

func save_player_node(position):
	Player = $PC_OW_Template
	Player.position = position
	
func load_player_node():
	move_child(Player, 3)
