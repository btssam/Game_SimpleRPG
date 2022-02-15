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

var animation_movement_direction

func _ready():
	#movement
	$AnimatedSprite.animation = "walk_down"
	$AnimatedSprite.frame = 1
	#following/movement
#	get_initial_direction()

func _process(delta):
	#movement
#	update_movement()
#	move_and_collide(motion) #could I call these on _input instead? Didn't seem to work initially
	#following/movement
	move_follower()



###movement/following
func move_follower():
	if direction_array.size() > 0:  #party has moved
		if position.round() == position_array[0].round(): #once follower reaches where the postion of when the party changed directions... (round helps prevent problem with collision slightly altering position
#			print(name + ' has begun movement toward direction: ' +  str(direction_array[0]) + ' at position: ' + str(position))
			current_direction = direction_array[0] #...change direction
			animation_movement_direction = convert_movement_to_string(current_direction)
			update_movement_animation(animation_movement_direction)
			remove_last_direction()
	move_and_collide(current_direction)
	adjust_z_index()

func remove_last_direction():
	direction_array.pop_front()
	position_array.pop_front()

func add_directions(leader_position, direction): #when party moves, this happens
#	print('direction added on ' + str(name) + ' at ' + str(leader_position))
	position_array.append(leader_position)
	direction_array.append(direction)

func movement_has_begun():
	current_direction = initial_direction
	animation_movement_direction = convert_movement_to_string(current_direction)
	update_movement_animation(animation_movement_direction)

func get_initial_direction():
	if get_parent().gap_direction == 'up':
		initial_direction = Vector2(0,1) #opposite of gap_direction
	elif get_parent().gap_direction == 'down':
		initial_direction = Vector2(0,-1)
	elif get_parent().gap_direction == 'right':
		initial_direction = Vector2(-1,0)
	elif get_parent().gap_direction == 'left':
		initial_direction = Vector2(1,0)
#	var vector_to_player =  (get_node("../PC_Template").position - position)
#	if vector_to_player.x != 0 and vector_to_player.x > 0: #normalize
#		vector_to_player.x = vector_to_player.x / vector_to_player.x
#	elif vector_to_player.x != 0 and vector_to_player.x < 0:
#		vector_to_player.x = -vector_to_player.x / vector_to_player.x
#	elif vector_to_player.y != 0 and vector_to_player.y > 0:
#		vector_to_player.y = vector_to_player.y / vector_to_player.y
#	elif vector_to_player.y != 0 and vector_to_player.y < 0:
#		vector_to_player.y = -vector_to_player.y / vector_to_player.y
#	initial_direction = vector_to_player
#	print(initial_direction)

func stop_follower():
	update_movement_animation('stop')
	call_deferred("set_process", false) #stop all that occurs during process. this will  cause problems when I integrate other behavior, like combat, during process. maybe have to use another node with another script to handle it by using another process for that node

func resume_follower():
	update_movement_animation(animation_movement_direction)
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

func update_movement_animation(direction): #make sure I call this before I stop_process
	if direction == 'up':
		$AnimatedSprite.play("walk_up")
	elif direction == 'down':
		$AnimatedSprite.play("walk_down")
	elif direction == 'left':
		$AnimatedSprite.play("walk_left")
	elif direction == 'right':
		$AnimatedSprite.play("walk_right")
	elif direction == 'stop':
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 1


###scene_change
func reset_follower():
	direction_array = []
	position_array = []
	current_direction = Vector2(0,0)
	get_initial_direction()
	$AnimatedSprite.animation = "walk_down"
	$AnimatedSprite.frame = 1


func adjust_z_index():
	if current_direction == Vector2(0, -1):
		pass
	elif current_direction == Vector2(0, 1):
		pass

###movement
#func update_movement():
#	if not isBattling:
#
#		if Input.is_action_pressed("left"):
#			$AnimatedSprite.play("walk_left")
#			$AnimatedSprite.speed_scale = 1
#			motion.x = -speed
#			motion.y = 0
#			if Input.is_action_pressed("run"):
#				$AnimatedSprite.speed_scale = 2
#				motion.x = -2 * speed
#		elif Input.is_action_just_released("left"):
#			$AnimatedSprite.stop()
#			$AnimatedSprite.frame = 1
#			motion.x = 0
#			motion.y = 0
#
#		elif Input.is_action_pressed("right"):
#			$AnimatedSprite.play("walk_right")
#			$AnimatedSprite.speed_scale = 1
#			motion.x = speed
#			motion.y = 0
#			if Input.is_action_pressed("run"):
#				$AnimatedSprite.speed_scale = 2
#				motion.x =  2 * speed
#		elif Input.is_action_just_released("right"):
#			$AnimatedSprite.stop()
#			$AnimatedSprite.frame = 1
#			motion.x = 0
#			motion.y = 0
#
#		elif Input.is_action_pressed("up"):
#			$AnimatedSprite.play("walk_up")
#			$AnimatedSprite.speed_scale = 1
#			motion.y = -speed
#			motion.x = 0
#			if Input.is_action_pressed("run"):
#				$AnimatedSprite.speed_scale = 2
#				motion.y = -2 *speed
#		elif Input.is_action_just_released("up"):
#			$AnimatedSprite.stop()
#			$AnimatedSprite.frame = 1
#			motion.x = 0
#			motion.y = 0
#
#		elif Input.is_action_pressed("down"):
#			$AnimatedSprite.play("walk_down")
#			$AnimatedSprite.speed_scale = 1
#			motion.y = speed
#			motion.x = 0
#			if Input.is_action_pressed("run"):
#				$AnimatedSprite.speed_scale = 2
#				motion.y = 2 *speed
#		elif Input.is_action_just_released("down"):
#			$AnimatedSprite.stop()
#			$AnimatedSprite.frame = 1
#			motion.x = 0
#			motion.y = 0
#
#	else: #in battle
#		motion.x = 0
#		motion.y = 0
#		if not isDead:
#			if not isAttacking:
#				$AnimatedSprite.animation = "idle_battle"


###Battling code
func check_for_death():
	if hp <= 0:
		hp = 0
		get_node("../Battlefield_Template").update_log("You have died!")
		isDead = true
		$AnimatedSprite.play("dying")
		yield($AnimatedSprite, "animation_finished")
		main_node.switch_scene('battle', 'gameover')
