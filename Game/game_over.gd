extends Node2D

onready var player_node = get_node("../PC_Template")
onready var main_node = get_node("..")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed('interact'):
		main_node.switch_scene("gameover", "town")
#		get_tree().call_group("level_switching", "switch_scene", "gameover", "town")
		player_node.isDead = false
		player_node.battling = false
		var AnimatedSpriteNode = player_node.get_node("AnimatedSprite")
		AnimatedSpriteNode.animation = "walk_down"
		AnimatedSpriteNode.stop()
		AnimatedSpriteNode.frame = 1
		player_node.hp = player_node.maxhp
