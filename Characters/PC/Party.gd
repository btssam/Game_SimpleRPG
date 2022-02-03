extends Node2D

var direction = Vector2(1,0)
const gap = -35
var next_follower_direction = Vector2(1,0)
var previous_direction = Vector2(1,0)
onready var follower = preload("res://Characters/PC/Follower_Test.tscn")
var collision_info


func _ready():
	add_follower()

func _process(delta):
	if(Input.is_action_pressed("up")):
		direction = Vector2(0,-1)
		move_followers()
	elif(Input.is_action_just_released("up")):
		stop_party()
	elif(Input.is_action_pressed("down")):
		direction = Vector2(0,1)
		move_followers()
	elif(Input.is_action_just_released("down")):
		stop_party()
	elif(Input.is_action_pressed("left")):
		direction = Vector2(-1,0)
		move_followers()
	elif(Input.is_action_just_released("left")):
		stop_party()
	elif(Input.is_action_pressed("right")):
		direction = Vector2(1,0)
		move_followers()
	elif(Input.is_action_just_released("right")):
		stop_party()
	if check_for_collision():
		stop_party()
	else:
		move_party()
	
func move_party():
	var isDirectionChanged = false
	if previous_direction != direction:
		previous_direction = direction
		isDirectionChanged = true
	var leader_position = get_node("Leader_Test").position
#	get_node("Leader_Test").position += direction
	collision_info = get_node("Leader_Test").move_and_collide(direction)

	if isDirectionChanged:
		for i in range(1, get_child_count()):
			get_child(i).add_directions(leader_position, direction)

func add_follower():
	var inst = follower.instance()
	var previous_follower = get_child(get_child_count() -1 )
	if(previous_follower.name != "Leader_Test"):
		inst.current_direction = previous_direction.current_direction
		for i in range(0,previous_follower.position_array.size()):
			inst.position_array.append(previous_follower.position_array[i])
			inst.directions.append(previous_follower.directions[i])
		inst.position = previous_follower.position + previous_follower.current_direction * gap #move and collide
	else:
		inst.current_direction = direction
		inst.position = previous_follower.position + direction * gap
	add_child(inst)

func stop_party():
	print(collision_info)
	direction = Vector2(0,0)
	for i in range(1, get_child_count()):
		get_child(i).isStopped = true

func move_followers():
	for i in range(1, get_child_count()):
		get_child(i).isStopped = false

func check_for_collision():
	if collision_info != null:
		return true
	else:
		return false
