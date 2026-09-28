extends Node

onready var battlefield_template = owner

func _ready():
	pass

func _on_Battlefield_Template_battlefield_initialized():
	var battlefield_template = owner

func close_scene():
	battlefield_template.get_node("../Party").isBattling = false
	battlefield_template.main_node.switch_scene('battle', 'overworld')
	battlefield_template.player_node.reset_battle_check()
	battlefield_template.current_selection = 0
	battlefield_template.isVictorious = false
