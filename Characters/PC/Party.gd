extends Node2D

#I need to figure out how to remove the inital velocity from the queation, so that I start stopped.

var direction = Vector2(0,0)
const gap = -35
var previous_direction = Vector2(0,0)
onready var follower = preload("res://Characters/PC/Follower_Test.tscn")
var collision_info
var isStartingToMove = false


func _ready():
	add_follower()
	add_follower()
	add_follower()

func _process(delta):
	if(Input.is_action_pressed("up")):
		direction = Vector2(0,-1)
		party_has_begun_moving()
		move_followers()
	elif(Input.is_action_just_released("up")):
		stop_party()
	elif(Input.is_action_pressed("down")):
		direction = Vector2(0,1)
		party_has_begun_moving()
		move_followers()
	elif(Input.is_action_just_released("down")):
		stop_party()
	elif(Input.is_action_pressed("left")):
		direction = Vector2(-1,0)
		party_has_begun_moving()
		move_followers()
	elif(Input.is_action_just_released("left")):
		stop_party()
	elif(Input.is_action_pressed("right")):
		direction = Vector2(1,0)
		party_has_begun_moving()
		move_followers()
	elif(Input.is_action_just_released("right")):
		stop_party()
	if check_for_collision():
		stop_party_for_collision()
	move_party()
	
func move_party():
	var isDirectionChanged = false
	if previous_direction != direction: #previous_direction only exists to note when 
		previous_direction = direction ##direction has changed
		isDirectionChanged = true       #i. e. to set this variable
	var leader_position = get_node("Leader_Test").position
#	get_node("Leader_Test").position += direction
	collision_info = get_node("Leader_Test").move_and_collide(direction)

	if isDirectionChanged:
		for i in range(1, get_child_count()):
			get_child(i).add_directions(leader_position, direction)

func add_follower():
	var inst = follower.instance()
	var previous_follower = get_child(get_child_count() -1 )
#	if(previous_follower.name != "Leader_Test"): #if other followers, grab the most rect ones information
#		inst.current_direction = previous_follower.current_direction
#		for i in range(0,previous_follower.position_array.size()): #grab the same arrays as previous follower for position and driection
#			inst.position_array.append(previous_follower.position_array[i])
#			inst.directions.append(previous_follower.directions[i])
##		inst.position = previous_follower.position + previous_follower.current_direction * gap #set the position of the instance, using direction to determine where to place
#	else: #if first add, just use the leaders position
#		inst.current_direction = direction
##		inst.position = previous_follower.position + direction * gap
	inst.position = previous_follower.position + Vector2(gap, 0) #dont need to use the other two ways of adding position as I'm not adding during movement
	add_child(inst)
	#commented most of this out as it is primarily there for adding followers during movement and is not necessary



#func add_directions(leader_position, direction):
#	position_array.append(leader_position)
#	directions.append(direction)


func stop_party():
	direction = Vector2(0,0) #if I leave this in, I can stop when I release a key, if I comment it out, the follower stops when I collide
	for i in range(1, get_child_count()):
#		get_child(i).isStopped = true
		get_child(i).set_deferred("isStopped", true)

func stop_party_for_collision():
	for i in range(1, get_child_count()):
		get_child(i).isStopped = true
#		get_child(i).set_deferred("isStopped", true)

func move_followers():
	for i in range(1, get_child_count()):
		get_child(i).isStopped = false

func check_for_collision():
	if collision_info != null:
		stop_party_for_collision()
		return true   #is constantly true when touching wall, so can't move then
	else:
		return false

func party_has_begun_moving(): #so that it still works even though I'm not starting with an inital velocity on the party
	if not isStartingToMove:
		get_tree().call_group("party_movement_group", "movement_has_begun") #could just loop through each child and call function directly. I don't know what's more efficient.
		isStartingToMove = true
