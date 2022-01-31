extends Node2D

onready var player_node = get_node("../PC_Template")
onready var main_node = get_node("..")



func _input(event):
	if event.is_action_pressed('interact'):
		main_node.switch_scene("gameover", "town")
		player_node.isDead = false
		player_node.battling = false
		var AnimatedSpriteNode = player_node.get_node("AnimatedSprite")
		AnimatedSpriteNode.animation = "walk_down"
		AnimatedSpriteNode.stop()
		AnimatedSpriteNode.frame = 1
		player_node.hp = player_node.maxhp
