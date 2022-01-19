extends "res://Characters/PC/Overworld/pc_movement.gd"


#npc check
var interactable = false
var current_interaction

#battle check
var steps_since_last = 0
var current_position = Vector2()
var previous_position = Vector2()
var next_battle_counter = 0

#battle code
#onready var popup = $Popup_Commands


func _ready():
	$AnimationPlayer.play("idle_down")
	get_next_battle_counter()


func _physics_process(delta):
#	update_movement()
#	move_and_collide(motion)
	check_for_interaction(current_interaction)
#	popup.rect_global_position = self.position - Vector2(60, 0) #move popup



#check for interaction, like NPCs
func check_for_interaction(current_interaction):
	if Input.is_action_just_pressed("interact"):
		if interactable:
			get_tree().call_group("interact_NPC", "pass_body_to_dialogue", current_interaction)
		
func _on_Area2D_Interact_body_entered(body):
	if 'NPC_Template' in body.name:
		interactable = true
		current_interaction = body.name #get name of interacted NPC

func _on_Area2D_Interact_body_exited(body):
	if 'NPC_Template' in body.name:
		interactable = false
		current_interaction = 'none'
		get_tree().call_group('interact_NPC', 'hide_dialogue')


#check for battles
func start_timer():
	$Delta_Position1.start()

func _on_Delta_Position1_timeout():
	previous_position = position
	$Delta_Position2.start()

func _on_Delta_Position2_timeout(): #get delta of position (displacement) and use to determine if battle
	current_position = position
	check_for_battle()
	
func get_next_battle_counter(): #how many steps until next battle
	randomize()
	next_battle_counter = randi() % 900 + 1 + 100

func check_for_battle():
	var x_displacement = abs(current_position.x - previous_position.x)
	var y_displacement = abs(current_position.y - previous_position.y)
	var displacement = x_displacement + y_displacement
	steps_since_last += displacement
	if steps_since_last > next_battle_counter or Input.is_action_pressed("test_key"):
			get_tree().call_group("level_switching", "switch_scene", 'overworld', 'battle')
			battling = true
			get_next_battle_counter()
	else:
		$Delta_Position1.start()

func reset_battle_check():
	steps_since_last = 0
	$Delta_Position1.start()
	battling = false
	


#Battling code
func battle_loop():
	pass
