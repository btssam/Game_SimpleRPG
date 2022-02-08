extends KinematicBody2D

var directions = []
var position_array = []
var current_direction = Vector2()
var isStopped = false
var initial_direction

func _ready():
	get_inital_direction()

func _process(delta):
	move_follower()

func move_follower():
#	if not isStopped:
	if directions.size() > 0:  #party has moved'
		if position == position_array[0]: #once follower reaches where the postion of when the party changed directions
			current_direction = directions[0] #change direction
			remove_last_direction()
	move_and_collide(current_direction)
#	else:
#		print('isStopped during process' + str(OS.get_ticks_msec())) #it is 20 ms too late when it recognizes that it should not be moving_and_colliding
##		remove_last_direction()

func remove_last_direction():
	directions.pop_front()
	position_array.pop_front()

func add_directions(leader_position, direction): #when party moves, this happens
	position_array.append(leader_position)
	directions.append(direction)

func movement_has_begun():
	current_direction = initial_direction

func get_inital_direction():
	var vector_to_player =  (get_node("../Leader_Test").position - position)
	if vector_to_player.x != 0:
		vector_to_player.x = vector_to_player.x / vector_to_player.x
	elif vector_to_player.y != 0:
		vector_to_player.y = vector_to_player.y / vector_to_player.y
	initial_direction = vector_to_player

func stop_follower():
#	print('recievied: ' + str(OS.get_ticks_msec()))
#	print('position[0]: ' + str(position_array[0]))
#	isStopped = true
#	print('current_d: ' + str(current_direction))
#	print('directions[0]: ' + str(directions[0]))
#	print('stop')
#	set_process(false)
	call_deferred("set_process", false)

func resume_follower():
#	print('resume')
#	set_process(true)
	call_deferred("set_process", true)
