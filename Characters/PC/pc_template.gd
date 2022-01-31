extends KinematicBody2D

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
export var hp = 6
export var maxhp = 6
var isDead = false
###nodes
onready var main_node = get_node("..")
onready var dialogue_node = get_node("../GUI/Dialogue_UI")


func _ready():
	#movement
	$AnimatedSprite.animation = "walk_down"
	$AnimatedSprite.frame = 1
	#battle check
	get_next_battle_counter()

func _physics_process(delta):
	#movement
	update_movement()
	move_and_collide(motion) #could I call these on _input instead? Didn't seem to work initially

func _input(event):
	#npc interaction
	if event.is_action_pressed("interact"):
		if interactable:
			dialogue_node.print_dialogue(current_interaction)
			

func _process(delta):
	pass



###movement
func update_movement():
	if not battling:
		
		if Input.is_action_pressed("left"):
			$AnimatedSprite.play("walk_left")
			$AnimatedSprite.speed_scale = 1
			motion.x = -speed
			motion.y = 0
			if Input.is_action_pressed("run"):
				$AnimatedSprite.speed_scale = 2
				motion.x = -2 * speed
		elif Input.is_action_just_released("left"):
			$AnimatedSprite.stop()
			$AnimatedSprite.frame = 1
			motion.x = 0
			motion.y = 0
			
		elif Input.is_action_pressed("right"):
			$AnimatedSprite.play("walk_right")
			$AnimatedSprite.speed_scale = 1
			motion.x = speed
			motion.y = 0
			if Input.is_action_pressed("run"):
				$AnimatedSprite.speed_scale = 2
				motion.x =  2 * speed
		elif Input.is_action_just_released("right"):
			$AnimatedSprite.stop()
			$AnimatedSprite.frame = 1
			motion.x = 0
			motion.y = 0
			
		elif Input.is_action_pressed("up"):
			$AnimatedSprite.play("walk_up")
			$AnimatedSprite.speed_scale = 1
			motion.y = -speed
			motion.x = 0
			if Input.is_action_pressed("run"):
				$AnimatedSprite.speed_scale = 2
				motion.y = -2 *speed
		elif Input.is_action_just_released("up"):
			$AnimatedSprite.stop()
			$AnimatedSprite.frame = 1
			motion.x = 0
			motion.y = 0
			
		elif Input.is_action_pressed("down"):
			$AnimatedSprite.play("walk_down")
			$AnimatedSprite.speed_scale = 1
			motion.y = speed
			motion.x = 0
			if Input.is_action_pressed("run"):
				$AnimatedSprite.speed_scale = 2
				motion.y = 2 *speed
		elif Input.is_action_just_released("down"):
			$AnimatedSprite.stop()
			$AnimatedSprite.frame = 1
			motion.x = 0
			motion.y = 0
			
	else: #in battle
		motion.x = 0
		motion.y = 0
		if not isDead:
			$AnimatedSprite.stop()
			$AnimatedSprite.animation = "walk_left"
			$AnimatedSprite.frame = 1


###check for interaction, like NPCs
func _on_Area2D_Interact_body_entered(body):
	if 'NPC_Template' in body.name:
		interactable = true
		current_interaction = body.name #get name of interacted NPC

func _on_Area2D_Interact_body_exited(body):
	if 'NPC_Template' in body.name:
		interactable = false
		current_interaction = 'none'
		dialogue_node.hide_dialogue()


###check for battles
func get_next_battle_counter(): #how many steps (pixels) until next battle
	randomize()
	next_battle_counter = randi() % 900 + 1 + 100 #100 to 1000

func _on_Delta_Position1_timeout():
	previous_position = position
	$Delta_Position2.start()

func _on_Delta_Position2_timeout(): #get delta of position (displacement between two point) and use to determine if battle
	current_position = position
	check_for_battle()

func check_for_battle():
	var x_displacement = abs(current_position.x - previous_position.x)
	var y_displacement = abs(current_position.y - previous_position.y)
	var displacement = x_displacement + y_displacement
	steps_since_last += displacement
	if steps_since_last > next_battle_counter or Input.is_action_pressed("test_key"):
		main_node.switch_scene("overworld", "battle")
		battling = true
		get_next_battle_counter()
	else:
		$Delta_Position1.start()

func reset_battle_check(): #return from battle
	$AnimatedSprite.stop()
	$AnimatedSprite.animation = "walk_down"
	$AnimatedSprite.frame = 1
	isDead = false
	battling = false
	steps_since_last = 0
	$Delta_Position2.stop()
	$Delta_Position1.start()
	
func stop_battle_check():
	battling = false
	steps_since_last = 0
	$Delta_Position1.stop()
	$Delta_Position2.stop()


###Battling code
func check_for_death():
	if hp <= 0:
		hp = 0
		get_node("../Battlefield_Template").update_log("You have died!")
		isDead = true
		$AnimatedSprite.play("dying")
		yield($AnimatedSprite, "animation_finished")
		main_node.switch_scene('battle', 'gameover')
		

