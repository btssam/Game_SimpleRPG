extends Node

var Player

func save_player_node(position):
	Player = $PC_OW_Template
	Player.position = position
	print('save_player')
	
func load_player_node():
	add_child(Player)
	move_child(Player, 3)
	print(Player.position)
	print('load_player')
