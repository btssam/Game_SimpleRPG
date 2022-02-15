extends Node2D

var direction = Vector2(0,0)
const gap = -35
var previous_direction = Vector2(0,0)
onready var follower_1 = preload("res://Characters/PC/Party_PC_Template1.tscn")
onready var follower_2 = preload("res://Characters/PC/Party_PC_Template2.tscn")
onready var follower_3 = preload("res://Characters/PC/Party_PC_Template3.tscn")
var follower_instance
var collision_info
var isAgainstAWall = false
var collision_direction
var isStartingToMove = false
var isStopped = false

var animation_name

var gap_direction = 'down'

#battle
var isBattling = false


func _ready():
	position = get_node("../Town_Template/Spawn_Points/Initial").position
	add_followers(3)

func _process(delta):
	if not isBattling:
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
		get_node("PC_Template").update_animation(animation_name)
		call_deferred("check_for_collision") #if not deferred, followers will move too late
		if isAgainstAWall:
			stop_party_for_collision()
		move_party()


func move_party():
	if not isStopped or isAgainstAWall:
		var isDirectionChanged = false
		if previous_direction != direction: #previous_direction exists to note when 
			previous_direction = direction  #direction has changed
			isDirectionChanged = true       #i. e. to set this variable
		var leader_position = get_node("PC_Template").position
		collision_info = get_node("PC_Template").move_and_collide(direction)
		adjust_z_index()

		if isDirectionChanged:
			for i in range(1, get_child_count()):
				get_child(i).add_directions(leader_position, direction)

func add_follower():
	var previous_follower = get_child(get_child_count() -1 )
	add_child(follower_instance)
	if gap_direction == 'left':
		follower_instance.position = previous_follower.position + Vector2(gap, 0)
	elif gap_direction == 'right':
		follower_instance.position = previous_follower.position + Vector2(-gap, 0)
	elif gap_direction == 'up':
		follower_instance.position = previous_follower.position + Vector2(0, gap)
	elif gap_direction == 'down':
		follower_instance.position = previous_follower.position + Vector2(0, -gap)
	for i in range(1, get_child_count()): #too early if I instead run on follower's _ready(). Then, followers dont move
		get_child(i).get_initial_direction()
	
func add_followers(number_of_followers):
	for i in range(1, number_of_followers + 1):
		if i == 1:
			follower_instance = follower_1.instance()
		elif i == 2:
			follower_instance = follower_2.instance()
		elif i == 3:
			follower_instance = follower_3.instance()
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
	if collision_info != null:
		collision_direction = direction
		isAgainstAWall = true
	else:
		if direction != collision_direction: #not moving toward wall
			set_deferred("isAgainstAWall", false)

func party_has_begun_moving():
	if not isStartingToMove: #used so that this only occurs once
		for i in range(1, get_child_count()):
			get_child(i).movement_has_begun()
		isStartingToMove = true


#scene transition
func reset_party_position():
	var leader_position = get_node("PC_Template").position
	for i in range(1, get_child_count()):
		if gap_direction == 'left': #maybe a gap_direction for battle #should check if gap_direction collides, especially on return from battle
			get_child(i).position = get_child(i-1).position + Vector2(gap,0)
		elif gap_direction == 'right':
			get_child(i).position = get_child(i-1).position + Vector2(-gap, 0)
		elif gap_direction == 'up':
			get_child(i).position = get_child(i-1).position + Vector2(0, gap)
		elif gap_direction == 'down':
			get_child(i).position = get_child(i-1).position + Vector2(0, -gap)
		get_child(i).reset_follower()
		get_child(i).add_directions(leader_position, direction) #wrong direction when returning from battle
	isStartingToMove = false

func adjust_z_index():
	for i in range(1,get_child_count()):
		if get_child(i).current_direction == Vector2(0, -1):
			get_child(i).z_index = i + 1
		elif get_child(i).current_direction == Vector2(0, 1):
			get_child(i).z_index = 4 - i
