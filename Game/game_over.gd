extends Node2D

onready var player_node = get_node("../Party/PC_Template")
onready var player_2_node = get_node("../Party/Party_PC_Template1")
onready var main_node = get_node("..")
onready var party_node = get_node("../Party/")



func _input(event):
	if event.is_action_pressed('interact'):
		main_node.switch_scene("gameover", "town")
		player_node.isDead = false #need to reset each player and the party isPartyDead
		party_node.isBattling = false
		party_node.animation_name = 'idle_down'
		player_node.hp = player_node.maxhp #need to reset all char' hp
		player_2_node.hp = player_2_node.maxhp
