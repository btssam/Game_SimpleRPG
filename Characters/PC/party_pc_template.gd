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
	get_inital_direction()

func _process(delta):
	#movement
#	update_movement()
#	move_and_collide(motion) #could I call these on _input instead? Didn't seem to work initially
	#following/movement
	move_follower()



###movement/following
func move_follower():
	if direction_array.size() > 0:  #party has moved
		if position == position_array[0]: #once follower reaches where the postion of when the party changed directions...
			current_direction = direction_array[0] #...change direction
			remove_last_direction()
	move_and_collide(current_direction)

func remove_last_direction():
	direction_array.pop_front()
	position_array.pop_front()

func add_directions(leader_position, direction): #when party moves, this happens
	position_array.append(leader_position)
	direction_array.append(direction)

func movement_has_begun():
	current_direction = initial_direction

func get_inital_direction():
	var vector_to_player =  (get_node("../PC_Template").position - position)
	if vector_to_player.x != 0:
		vector_to_player.x = vector_to_player.x / vector_to_player.x
	elif vector_to_player.y != 0:
		vector_to_player.y = vector_to_player.y / vector_to_player.y
	initial_direction = vector_to_player

func stop_follower():
	call_deferred("set_process", false) #stop all that occurs during process. this will  cause problems when I integrate other behavior, like combat, during process. maybe have to use another node with another script to handle it by using another process for that node

func resume_follower():
	call_deferred("set_process", true)
