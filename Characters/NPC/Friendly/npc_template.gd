extends KinematicBody2D

func pass_body_to_dialogue(body):
	if name == body:  #assure that this is not done by everyone in group
		get_tree().call_group("interact_NPC", "print_dialogue", body)
