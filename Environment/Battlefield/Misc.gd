extends Node

onready var battlefield_template = owner
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print('blah Im misc')
	print(owner.player_4_node)
	print(battlefield_template.player_4_node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Battlefield_Template_battlefield_initialized():
	print('catching initalized signal. blah Im' + str(name))
	var battlefield_template = owner
	print(battlefield_template.player_4_node)
