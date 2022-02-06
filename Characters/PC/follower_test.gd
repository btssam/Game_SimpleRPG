extends KinematicBody2D

var directions = []
var position_array = []
var current_direction = Vector2()
var isStopped = false
var initial_direction

func _ready():
	get_inital_direction()

func _process(delta):
	if not isStopped:
		if directions.size() > 0:  #party has moved'
#			print('directions[0]')
#			print(directions[0])
#			print('position_array[0]')
#			print(position_array[0])
			if position == position_array[0]: #once follower reaches where the postion of when the party changed directions, #never reaches this as it doesn't start moving so doesnt't just immediately go to initial position. this is what movement has begun does
#				print(directions[0])
#				print(position_array[0])
				current_direction = directions[0] #change direction
				remove_last_direction()
	#	position += current_direction
		move_and_collide(current_direction)

func remove_last_direction():
	directions.pop_front()
	position_array.pop_front()

func add_directions(leader_position, direction): #when party moves, this happens
	position_array.append(leader_position)
	directions.append(direction)

func movement_has_begun(): #so that it still works even though I'm not starting with an inital velocity on the party
	
#	current_direction = directions[0] #this causes the followers to always go whcihever way the player initally goes, not toward the player's inital position
	current_direction = initial_direction

func get_inital_direction():
	var vector_to_player =  (get_node("../Leader_Test").position - position)
	if vector_to_player.x != 0:
		vector_to_player.x = vector_to_player.x / vector_to_player.x
	elif vector_to_player.y != 0:
		vector_to_player.y = vector_to_player.y / vector_to_player.y
	initial_direction = vector_to_player
	
