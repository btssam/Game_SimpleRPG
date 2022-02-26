extends Node2D

onready var player_node = get_node("../Party/PC_Template")
onready var player_2_node = get_node("../Party/Party_PC_Template1")
onready var player_3_node = get_node("../Party/Party_PC_Template2")
onready var player_4_node = get_node("../Party/Party_PC_Template3")
onready var main_node = get_node("..")
onready var party_node = get_node("../Party/")



func _input(event):
	if event.is_action_pressed('interact'):
		main_node.switch_scene("gameover", "town")
		player_node.isDead = false
		player_2_node.isDead = false
		player_3_node.isDead = false
		player_4_node.isDead = false
		party_node.isBattling = false
		party_node.isPartyDead = false
		party_node.animation_name = 'idle_down'
		player_2_node.animation_name = 'idle_down'
		player_2_node.update_animation('idle_down')
		player_3_node.animation_name = 'idle_down'
		player_3_node.update_animation('idle_down')
		player_4_node.animation_name = 'idle_down'
		player_4_node.update_animation('idle_down')
		player_node.hp = player_node.maxhp
		player_2_node.hp = player_2_node.maxhp
		player_3_node.hp = player_3_node.maxhp
		player_4_node.hp = player_4_node.maxhp
		
