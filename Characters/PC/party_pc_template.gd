extends KinematicBody2D

###movement
#var motion = Vector2()
#var running = false
#var speed = 2
###battle check
#var isBattling = false
###combat stats
export var hp = 6
export var maxhp = 6
var isDead = false
###nodes
onready var main_node = get_node("..")
###attacking
var isAttacking = false
###following/movement
var direction_array = []
var position_array = []
var current_direction = Vector2()
var initial_direction

var animation_name

func _ready():
	#movement
	$AnimatedSprite.animation = "walk_down"
	$AnimatedSprite.frame = 1

func _process(delta):
	move_follower()



###movement/following
func move_follower():
	if direction_array.size() > 0:  #party has moved
		if position == position_array[0]: #once follower reaches where the postion of when the party changed directions... (round helps prevent problem with collision slightly altering position. I need to deal with the fact that they move slightly when pushing against a wall, rather than just rounding. checking for collision_info at the right time helps)
			print('change_direction')
			current_direction = direction_array[0] #...change direction
			animation_name = convert_movement_to_string(current_direction)
			update_animation(animation_name)
			remove_last_direction()
	move_and_collide(current_direction)

func remove_last_direction():
	direction_array.pop_front()
	position_array.pop_front()

func add_directions(leader_position, direction): #when party moves, this happens
	#oftentimes not called after return from battle. perhaps if moving the same direction as before?
	print('Added_directions at ' + str(leader_position) + ' heading toward ' + str(direction))
	position_array.append(leader_position) #could round here
	direction_array.append(direction)

func movement_has_begun():
	current_direction = initial_direction
	animation_name = convert_movement_to_string(current_direction)
	update_animation(animation_name)

func get_initial_direction():
	if get_parent().gap_direction == 'up':
		initial_direction = Vector2(0,1) #opposite of gap_direction
	elif get_parent().gap_direction == 'down':
		initial_direction = Vector2(0,-1)
	elif get_parent().gap_direction == 'right':
		initial_direction = Vector2(-1,0)
	elif get_parent().gap_direction == 'left':
		initial_direction = Vector2(1,0)

func stop_follower():
	update_animation('stop')
	call_deferred("set_process", false) #stop all that occurs during process. this will  cause problems when I integrate other behavior, like combat, during process. maybe have to use another node with another script to handle it by using another process for that node

func resume_follower():
	update_animation(animation_name)
	call_deferred("set_process", true)

func convert_movement_to_string(direction):
	if direction == Vector2(0, -1):
		return('up')
	elif direction == Vector2(0, 1):
		return('down')
	elif direction == Vector2(-1, 0):
		return('left')
	elif direction == Vector2(1, 0):
		return('right')

func update_animation(animation):
	if animation == 'up':
		$AnimatedSprite.play("walk_up")
	elif animation == 'down':
		$AnimatedSprite.play("walk_down")
	elif animation == 'left':
		$AnimatedSprite.play("walk_left")
	elif animation == 'right':
		$AnimatedSprite.play("walk_right")
	elif animation == 'stop':
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 1


###scene_change
func reset_follower():
	direction_array = []
	position_array = []
	current_direction = Vector2(0,0)
	get_initial_direction()
	if not get_parent().isBattling:
		$AnimatedSprite.animation = "walk_down"
		$AnimatedSprite.frame = 1
	else:
		$AnimatedSprite.animation = "idle_battle"
		$AnimatedSprite.frame = 0

###Battling code
func check_for_death():
	if hp <= 0:
		hp = 0
		get_node("../Battlefield_Template").update_log("You have died!")
		isDead = true
		$AnimatedSprite.play("dying")
		yield($AnimatedSprite, "animation_finished")
		main_node.switch_scene('battle', 'gameover')
