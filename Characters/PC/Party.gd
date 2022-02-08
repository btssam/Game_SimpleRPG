extends Node2D

#I need to figure out how to remove the inital velocity from the queation, so that I start stopped.

var direction = Vector2(0,0)
const gap = -35
var previous_direction = Vector2(0,0)
onready var follower = preload("res://Characters/PC/Follower_Test.tscn")
var collision_info
var isAgainstAWall = false
var collision_direction
var isStartingToMove = false
var isStopped = false


func _ready():
	add_follower()
	add_follower()
	add_follower()

func _process(delta):
	if(Input.is_action_pressed("up")):
		direction = Vector2(0,-1)
		party_has_begun_moving()
		resume_follower_movement()
	elif(Input.is_action_just_released("up")):
		stop_party()
	elif(Input.is_action_pressed("down")):
		direction = Vector2(0,1)
		party_has_begun_moving()
		resume_follower_movement()
	elif(Input.is_action_just_released("down")):
		stop_party()
	elif(Input.is_action_pressed("left")):
		direction = Vector2(-1,0)
		party_has_begun_moving()
		resume_follower_movement()
	elif(Input.is_action_just_released("left")):
		stop_party()
	elif(Input.is_action_pressed("right")):
		direction = Vector2(1,0)
		party_has_begun_moving()
		resume_follower_movement()
	elif(Input.is_action_just_released("right")):
		stop_party()
	call_deferred("check_for_collision")
	if isAgainstAWall:
		stop_party_for_collision()
	move_party()
	
func move_party():
	if not isStopped or isAgainstAWall:
		var isDirectionChanged = false
		if previous_direction != direction: #previous_direction only exists to note when 
			previous_direction = direction  #direction has changed
			isDirectionChanged = true       #i. e. to set this variable
		var leader_position = get_node("Leader_Test").position
		collision_info = get_node("Leader_Test").move_and_collide(direction)

		if isDirectionChanged:
			for i in range(1, get_child_count()):
				get_child(i).add_directions(leader_position, direction)

func add_follower():
	var inst = follower.instance()
	var previous_follower = get_child(get_child_count() -1 )
	inst.position = previous_follower.position + Vector2(gap, 0)
	add_child(inst)

func stop_party():
	if not isAgainstAWall:
		isStopped = true
#	print('leader_position: ' +str(position))
	for i in range(1, get_child_count()):
#		print('transmitted: ' + str(OS.get_ticks_msec()))
#		get_child(i).set_deferred("isStopped", true)
		get_child(i).call_deferred("stop_follower")
#		get_child(i).stop_follower()

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
	if not isStartingToMove:
		for i in range(1, get_child_count()):
			get_child(i).movement_has_begun()
		isStartingToMove = true
