extends KinematicBody2D

var direction_array = []
var position_array = []
var current_direction = Vector2()
var isStopped = false
var initial_direction
var follower_gap = 35
var previous_direction
var previous_position
var isAGap = false

func _ready():
	get_inital_direction()

func _process(delta):
	if not isStopped:
		if direction_array.size() > 0:  #party has moved'
			if position == position_array[0]: #once follower reaches where the postion of when the party changed directions
				if direction_array.size() > 1:
					if previous_direction == direction_array[1] and Vector2(0,0) == direction_array[0]:
						check_for_gap()
				current_direction = direction_array[0] #change direction
				remove_last_direction()
		if isAGap:
			print('adjusting')
			fix_gap()
		else:
			move_and_collide(current_direction)
#	else:
#		if direction_array.size() > 1:
#			if previous_direction == direction_array[1] and Vector2(0,0) == direction_array[0]:
#				print(position_array[0])

func remove_last_direction():
	previous_direction = direction_array[0]
	previous_position = position_array[0]
	direction_array.pop_front()
	position_array.pop_front()

func add_directions(leader_position, direction): #when party moves, this happens
	position_array.append(leader_position)
	direction_array.append(direction)

func movement_has_begun():
	current_direction = initial_direction

func get_inital_direction():
	var vector_to_player =  (get_node("../Leader_Test").position - position)
#	if vector_to_player.x != 0:
#		vector_to_player.x = vector_to_player.x / vector_to_player.x
#	elif vector_to_player.y != 0:
#		vector_to_player.y = vector_to_player.y / vector_to_player.y
	vector_to_player = normalize(vector_to_player)
	initial_direction = vector_to_player


func normalize(vector):
#	print(vector)
	if vector.x != 0:
		vector.x = vector.x / vector.x
	elif vector.y != 0:
		vector.y = vector.y / vector.y
#	print(vector)
	return vector

func check_for_gap():
	var this_child_count
	var next_in_line
	for i in range(1, get_node("..").get_child_count()):
		if get_node("..").get_child(i) == get_node("."):
			this_child_count = i
			next_in_line = get_node("..").get_child(i-1)
	print('Gap should be: ' + str(follower_gap * direction_array[1]))
	print('Gap is' + str(next_in_line.position - position))
	if (follower_gap * direction_array[1]) != (next_in_line.position - position):
		fix_gap()
		isAGap = true
	isAGap = false
#	var vector_to =  (get_node("../Leader_Test").position - position)
#	vector_to = normalize(vector_to)
#	print(vector_to)
#	print(get_node("../Leader_Test").position)
#	print(position)
#	if get_node('.') == get_node(
#	print(get_node("../Leader_Test").position - position)
	#check for 35, 75, or 105 in x y or z and if not, normalize, then multiply by that

func fix_gap():
	print('fix_gap()')
	print(position_array[0])
	var this_child_count
	var next_in_line
	var desired_gap = follower_gap * direction_array[1]
	for i in range(1, get_node("..").get_child_count()):
		if get_node("..").get_child(i) == get_node("."):
			this_child_count = i
			next_in_line = get_node("..").get_child(i-1)
	print('Desired postion:' + str(next_in_line.position - desired_gap))
#	position_array[0] = next_in_line.position - desired_gap
#	position = next_in_line.position - desired_gap
	isAGap = false
