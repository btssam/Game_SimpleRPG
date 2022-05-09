extends Node2D

onready var player_node = get_node("../Party/PC_Template")
onready var player_2_node = get_node("../Party/Party_PC_Template1")
onready var player_3_node = get_node("../Party/Party_PC_Template2")
onready var player_4_node = get_node("../Party/Party_PC_Template3")
onready var players = [player_node, player_2_node, player_3_node, player_4_node]
onready var main_node = get_node("..")
onready var party_node = get_node("../Party/")



func _input(event):
	if event.is_action_pressed('interact'):
		main_node.switch_scene("gameover", "town")
		party_node.isBattling = false
		party_node.isPartyDead = false
		for i in 4:
			players[i].isDead = false
			players[i].hp = players[i].maxhp
		party_node.animation_name = 'idle_down'
		for i in 3: #doesnt need to be done to player_1
			players[i+1].animation_name = 'idle_down'
			players[i+1].update_animation('idle_down')
