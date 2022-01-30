extends Node2D

onready var player = get_node("../PC_Template")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed('interact'):
		get_tree().call_group("level_switching", "switch_scene", "gameover", "town")
		player.isDead = false
		player.battling = false
		var AnimatedSpriteNode = player.get_node("AnimatedSprite")
		AnimatedSpriteNode.animation = "walk_down"
		AnimatedSpriteNode.stop()
		AnimatedSpriteNode.frame = 1
		player.hp = player.maxhp
