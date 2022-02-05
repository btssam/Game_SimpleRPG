extends KinematicBody2D

var directions = []
var position_array = []
var current_direction = Vector2()
var isStopped = false

func _process(delta):
	if not isStopped:
		if directions.size() > 0:  #party has moved'
			if position == position_array[0]: #once follower reaches where the postion of when the party changed directions, #never reaches this as it doesn't start moving so doesnt't just immediately go to initial position. this is what movement has begun does
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
	current_direction = directions[0]
