extends KinematicBody2D




var motion = Vector2()
var running = false
var speed = 2

var interactable = false
var current_interaction

var steps_since_last = 0
var current_position = Vector2()
var previous_position = Vector2()

var on_overworld = false
var battling = false

func _ready():
	$AnimationPlayer.play("idle_down")
	
	
func _physics_process(delta):
	update_movement()
	move_and_collide(motion)
	check_for_interaction(current_interaction)


#overworld movement
func update_movement():
	if not battling:
		if Input.is_action_pressed("left"):
			$AnimationPlayer.play("walk_left")
			motion.x = -speed
			motion.y = 0
			if Input.is_action_pressed("run"):
				$AnimationPlayer.play("walk_left", -1 , 2.0)
				motion.x = -2 * speed
		elif Input.is_action_just_released("left"):
			$AnimationPlayer.play("idle_left")
			motion.x = 0
			motion.y = 0
			
		elif Input.is_action_pressed("right"):
			$AnimationPlayer.play("walk_right")
			motion.x = speed
			motion.y = 0
			if Input.is_action_pressed("run"):
				$AnimationPlayer.play("walk_right", -1 , 2.0)
				motion.x =  2 * speed
		elif Input.is_action_just_released("right"):
			$AnimationPlayer.play("idle_right")
			motion.x = 0
			motion.y = 0
			
		elif Input.is_action_pressed("up"):
			$AnimationPlayer.play("walk_up")
			motion.y = -speed
			motion.x = 0
			if Input.is_action_pressed("run"):
				$AnimationPlayer.play("walk_up", -1 , 2.0)
				motion.y = -2 *speed
		elif Input.is_action_just_released("up"):
			$AnimationPlayer.play("idle_up")
			motion.x = 0
			motion.y = 0
			
		elif Input.is_action_pressed("down"):
			$AnimationPlayer.play("walk_down")
			motion.y = speed
			motion.x = 0
			if Input.is_action_pressed("run"):
				$AnimationPlayer.play("walk_down", -1 , 2.0)
				motion.y = 2 *speed
		elif Input.is_action_just_released("down"):
			$AnimationPlayer.play("idle_down")
			motion.x = 0
			motion.y = 0
	else:
		motion.x = 0
		motion.y = 0
		$AnimationPlayer.play("idle_left")

#check for interaction, like NPCs
func check_for_interaction(current_interaction):
	if Input.is_action_just_pressed("interact"):
		if interactable:
			get_tree().call_group("interact_NPC", "pass_body_to_dialogue", current_interaction)
		else:
			print('cant interact')
		
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


func _on_Delta_Position2_timeout():
	current_position = position
	check_for_battle()
	
func check_for_battle():
	var x_displacement = abs(current_position.x - previous_position.x)
	var y_displacement = abs(current_position.y - previous_position.y)
	var displacement = x_displacement + y_displacement
	steps_since_last += displacement
	if steps_since_last > 600 or Input.is_action_pressed("test_key"):
			get_tree().call_group("level_switching", "switch_scene", 'overworld', 'battle')
			battling = true
	else:
		$Delta_Position1.start()

func reset_battle_check():
	$Delta_Position1.stop()
	$Delta_Position2.stop()
	steps_since_last = 0
