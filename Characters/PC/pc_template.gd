extends KinematicBody2D
#also extends:
# pc_interaction.gd
# pc_momvement.gd


###movement
var motion = Vector2()
var running = false
var speed = 2



###npc check
var interactable = false
var current_interaction




###battle check
var battling = false
var steps_since_last = 0
var current_position = Vector2()
var previous_position = Vector2()
var next_battle_counter = 0


###combat stats
export var hp = 5
export var maxhp = 5



func _ready():
	#movement
	$Sprite.frame = 25 #idle_down
	#battle check
	get_next_battle_counter()


func _physics_process(delta):
	#movement
	update_movement()
	move_and_collide(motion) #could I call these on _input instead?


func _input(event):
	#npc interaction
	if event.is_action_pressed("interact"):
		if interactable:
			get_tree().call_group("interact_NPC", "pass_body_to_dialogue", current_interaction)

func _process(delta):
	pass


###movement

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
			$AnimationPlayer.stop()
			$Sprite.frame = 37 #idle_left
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
			$Sprite.frame = 13 #idle_right
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
			$AnimationPlayer.stop()
			$Sprite.frame = 1 #idle_up
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
			$AnimationPlayer.stop()
			$Sprite.frame = 25 #idle_down
			motion.x = 0
			motion.y = 0
	else:
		motion.x = 0
		motion.y = 0
		$AnimationPlayer.stop()
		$Sprite.frame = 37 #idle_left



###check for interaction, like NPCs
func _on_Area2D_Interact_body_entered(body):
	if 'NPC_Template' in body.name:
		interactable = true
		current_interaction = body.name #get name of interacted NPC

func _on_Area2D_Interact_body_exited(body):
	if 'NPC_Template' in body.name:
		interactable = false
		current_interaction = 'none'
		get_tree().call_group('interact_NPC', 'hide_dialogue')



###check for battles
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
	print('reset battle check')
	steps_since_last = 0
	$Delta_Position2.stop()
	$Delta_Position1.start()
	battling = false
	
func stop_battle_check():
	print('stop battle check')
	steps_since_last = 0
	$Delta_Position1.stop()
	$Delta_Position2.stop()
	battling = false



###Battling code
func battle_loop():
	pass

func check_for_death():
	if hp <= 0:
		hp = 0
		get_tree().call_group("battle_group", "update_log", "I dead")
		$Sprite.hide()
		$Sprite_Battle.show()
		$AnimationPlayer.stop()
		$AnimationPlayer.call_deferred("play", "dying")
#		$AnimationPlayer.play("dying")


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == 'dying':
		print('animation_started')


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'dying':
		print('animation_stopped')
