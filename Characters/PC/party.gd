extends Node2D

var direction = Vector2(0,0)
const gap = -35
var previous_direction = Vector2(0,0)
onready var follower_1 = preload("res://Characters/PC/Party_PC_Template1.tscn")
onready var follower_2 = preload("res://Characters/PC/Party_PC_Template2.tscn")
onready var follower_3 = preload("res://Characters/PC/Party_PC_Template3.tscn")
onready var followers = [follower_1, follower_2, follower_3]
var follower_instance
var collision_info
var isAgainstAWall = false
var collision_direction = Vector2(0,0)
var isStartingToMove = false
var isStopped = false

var animation_name = 'stop'

var gap_direction = 'down'
var gap_difference_dict = {'left' : Vector2(gap,0), 'right': Vector2(-gap,0), 'up': Vector2(0, gap), 'down': Vector2(0, -gap)}

var collision_direction_info

onready var menu_node = get_node("../CanvasLayer/GUI/Menu_UI/")

#battle
var isBattling = false #changed by PC_Template upon entering/leaving battle
var isAttacking = false #changed by Battlefield_Template
var isPartyDead = false


func _ready():
	position = get_node("../Town_Template/Spawn_Points/Initial").position
	add_followers(3)

func _process(delta):
	if not isBattling and not menu_node.isMenuOpen and not menu_node.isSubMenuOpen:
#	if not isBattling:
		if(Input.is_action_pressed("up")):
			direction = Vector2(0,-1)
			party_has_begun_moving()
			resume_follower_movement()
			animation_name = 'up'
		elif(Input.is_action_just_released("up")):
			stop_party()
			animation_name = 'stop'
		elif(Input.is_action_pressed("down")):
			direction = Vector2(0,1)
			party_has_begun_moving()
			resume_follower_movement()
			animation_name = 'down'
		elif(Input.is_action_just_released("down")):
			stop_party()
			animation_name = 'stop'
		elif(Input.is_action_pressed("left")):
			direction = Vector2(-1,0)
			party_has_begun_moving()
			resume_follower_movement()
			animation_name = 'left'
		elif(Input.is_action_just_released("left")):
			stop_party()
			animation_name = 'stop'
		elif(Input.is_action_pressed("right")):
			direction = Vector2(1,0)
			party_has_begun_moving()
			resume_follower_movement()
			animation_name = 'right'
		elif(Input.is_action_just_released("right")):
			stop_party()
			animation_name = 'stop'
		get_node("PC_Template").update_animation(animation_name) #if not deferred, followers will move too late?
		check_for_collision()
		if isAgainstAWall:
			stop_party_for_collision()
		if not isAgainstAWall:
			move_party()
#	if menu_node.isMenuOpen:
#		animation_name = 'stop'


func move_party():
	if not isStopped:
		var isDirectionChanged = false
		if previous_direction != direction: #previous_direction exists to note when 
			previous_direction = direction  #direction has changed
			isDirectionChanged = true       #i. e. to set this variable
		var leader_position = get_node("PC_Template").position
		get_node("PC_Template").move_and_collide(direction)
		adjust_z_index()

		if isDirectionChanged and direction != collision_direction:
			for i in range(1, get_child_count()):
				get_child(i).add_directions(leader_position, direction)

func add_follower():
	var previous_follower = get_child(get_child_count() -1 )
	add_child(follower_instance)
	follower_instance.position = previous_follower.position + gap_difference_dict[gap_direction]
	for i in range(1, get_child_count()): #too early if I instead run on follower's _ready(). Then, followers dont move
		get_child(i).get_initial_direction()
	
func add_followers(number_of_followers):
	for i in range(1, number_of_followers + 1):
		follower_instance = followers[i-1].instance()
		add_follower()

func stop_party():
	if not isAgainstAWall:
		isStopped = true
	for i in range(1, get_child_count()):
		get_child(i).call_deferred("stop_follower") #if not deferred: follower gap increases

func stop_party_for_collision():
	isStopped = true
	for i in range(1, get_child_count()):
		get_child(i).stop_follower()
		
func resume_follower_movement():
	isStopped = false
	for i in range(1, get_child_count()):
		get_child(i).resume_follower()

func check_for_collision():
	move_and_collide_test()
	if collision_info != null:
		collision_direction = direction
		isAgainstAWall = true
	else:
		if direction != collision_direction: #not moving toward wall
			set_deferred("isAgainstAWall", false)
			move_and_collide_test_collision_direction()

func party_has_begun_moving():
	if not isStartingToMove: #used so that this only occurs once
		for i in range(1, get_child_count()):
			get_child(i).movement_has_begun()
		isStartingToMove = true


#scene transition
func reset_party_position():
	var leader_position = get_node("PC_Template").position
	for i in range(1, get_child_count()):
		if gap_direction != 'battling':
			get_child(i).position = get_child(i-1).position + gap_difference_dict[gap_direction]
		else:
			get_child(i).position = get_child(i-1).position + Vector2(0, -80)
		get_child(i).reset_follower()
		previous_direction = Vector2(0,0)
		direction = Vector2 (0,0)
	isStartingToMove = false

func adjust_z_index():
	if direction == Vector2(0, -1):
		get_node("PC_Template").z_index = 1
	elif direction == Vector2(0, 1):
		get_node("PC_Template").z_index = 4
	for i in range(1,get_child_count()):
		if get_child(i).current_direction == Vector2(0, -1):
			get_child(i).z_index = i + 1
		elif get_child(i).current_direction == Vector2(0, 1):
			get_child(i).z_index = 4 - i

func move_and_collide_test():
	collision_info = get_node("PC_Template").move_and_collide(direction, true, true, true)

func move_and_collide_test_collision_direction():
	collision_direction_info = get_node("PC_Template").move_and_collide(collision_direction, true, true, true)
	if collision_direction_info == null: #not moving toward wall
		collision_direction = Vector2(0,0)


#combat
func check_if_party_is_dead():
	var number_dead = 0
	for i in range(0, get_child_count()):
		if get_child(i).isDead == true:
			number_dead += 1
	if number_dead == 4:
		print('Party is Dead!')
		isPartyDead = true
	else:
		number_dead = 0
