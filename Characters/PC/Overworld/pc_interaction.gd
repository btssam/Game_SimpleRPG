extends "res://Characters/PC/Overworld/pc_movement.gd"


#npc check
var interactable = false
var current_interaction


func _input(event):
	if event.is_action_pressed("interact"):
		if interactable:
			get_tree().call_group("interact_NPC", "pass_body_to_dialogue", current_interaction)


#check for interaction, like NPCs
func _on_Area2D_Interact_body_entered(body):
	if 'NPC_Template' in body.name:
		interactable = true
		current_interaction = body.name #get name of interacted NPC

func _on_Area2D_Interact_body_exited(body):
	if 'NPC_Template' in body.name:
		interactable = false
		current_interaction = 'none'
		get_tree().call_group('interact_NPC', 'hide_dialogue')
