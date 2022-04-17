extends KinematicBody2D

###movement
#var motion = Vector2()
#var running = false
#var speed = 2
###npc check
var isInteractable = false
var current_interaction
###battle check
#var isBattling = false #should be on party
var steps_since_last = 0
var current_position = Vector2()
var previous_position = Vector2()
var next_battle_counter = 0
###combat stats
export var hp = 1
export var maxhp = 1
var isDead = false
###nodes
onready var main_node = get_node("../..")
onready var dialogue_node = get_node("../../CanvasLayer/GUI/Dialogue_UI")
###attacking
var isAttacking = false
###stats
export var player_name = "Frey"
export var attack = 1
export var defence = 1
export var intellect = 1
export var speed = 1
export var mp = 1
export var maxmp = 1



func _ready():
	#movement
	$AnimatedSprite.animation = "walk_down"
	$AnimatedSprite.frame = 1
	#battle check
	get_next_battle_counter()

func _physics_process(delta):
	pass


func _input(event):
	#npc interaction
	if event.is_action_pressed("interact"):
		if isInteractable:
			dialogue_node.print_dialogue(current_interaction)



###movement
func update_animation(animation):
	if animation == 'up':
		$AnimatedSprite.play("walk_up")
#		$AnimatedSprite.advance(0) # I do not remember why I had this here at all
	elif animation == 'down':
		$AnimatedSprite.play("walk_down")
	elif animation == 'left':
		$AnimatedSprite.play("walk_left")
	elif animation == 'right':
		$AnimatedSprite.play("walk_right")
	elif animation == 'stop':
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 1
	elif animation == 'battling':
		$AnimatedSprite.stop()
		$AnimatedSprite.play("idle_battle")
		$AnimatedSprite.frame = 0
	elif animation == 'idle_down':
		$AnimatedSprite.play("walk_down")
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 1



###check for interaction, like NPCs
func _on_Area2D_Interact_body_entered(body):
	if 'NPC_Template' in body.name:
		isInteractable = true
		current_interaction = body.name #get name of interacted NPC

func _on_Area2D_Interact_body_exited(body):
	if 'NPC_Template' in body.name:
		isInteractable = false
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
		get_parent().isBattling = true
		main_node.switch_scene("overworld", "battle")
		get_parent().stop_party() #stop leader
		update_animation("battling")
		get_next_battle_counter()
	else:
		$Delta_Position1.start()

func reset_battle_check(): #return from battle. resets hp and such. ultimately, wont want to do this. want to maintain prev.
	get_parent().animation_name = 'idle_down'
	isDead = false #need to set party (children) isBattling here as well
	get_node("../Party_PC_Template1").isDead = false
	get_node("../Party_PC_Template2").isDead = false
	get_node("../Party_PC_Template3").isDead = false
	get_parent().isBattling = false #need to set party (children) isBattling here as well
	get_parent().isPartyDead = false
	steps_since_last = 0
	$Delta_Position2.stop()
	$Delta_Position1.start()
	
func stop_battle_check():
	get_parent().isBattling = false #need to set party (children) isBattling here as well
	steps_since_last = 0
	$Delta_Position1.stop()
	$Delta_Position2.stop()

###Battling code
func check_for_death():
	if hp <= 0:
		hp = 0
		get_node("../../Battlefield_Template").update_log("A party member died!")
		isDead = true
		if get_node("../../Battlefield_Template").turn_order.has(get_node(".")):
			print('removing from turn_order')
			get_node("../../Battlefield_Template").turn_order.erase(get_node("."))
		get_parent().check_if_party_is_dead()
		$AnimatedSprite.play("dying")
		yield($AnimatedSprite, "animation_finished")
		if get_parent().isPartyDead:
			main_node.switch_scene('battle', 'gameover')
