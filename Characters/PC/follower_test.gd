extends KinematicBody2D

var directions = []
var position_array = []
var current_direction = Vector2()


func _process(delta):
	if directions.size() > 0:
		if position == position_array[0]:
			current_direction = directions[0]
			remove_last_direction()
	position += current_direction


func remove_last_direction():
	directions.pop_front()
	position_array.pop_front()

func add_directions(leader_position, direction):
	position_array.append(leader_position)
	directions.append(direction)
