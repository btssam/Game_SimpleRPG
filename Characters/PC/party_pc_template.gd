extends KinematicBody2D

###movement
#var motion = Vector2()
#var running = false
#var speed = 2
###battle check
#var isBattling = false
###combat stats
export var hp: int
export var maxhp: int
var isDead = false
###nodes
onready var main_node = get_node("../..")
###attacking
var isAttacking = false
###following/movement
var direction_array = []
var position_array = []
var current_direction = Vector2()
var initial_direction

var animation_name
onready var animation_dict = {'up': 'walk_up', 'down': 'walk_down', 'left': 'walk_left', 'right': 'walk_right'}
###stats
var player_name = ''
export var attack = 1
export var defence = 1
export var intellect = 1
export var speed = 1
export var mp = 1
export var maxmp = 1
#skills
export var skill_1 = {"name": "null", "targets": "null", "effect_type": "null", "effect": "null"}
#export var skill_1 = "null"
export var skill_2 = {"name": "null", "targets": "null", "effect_type": "null", "effect": "null"}
export var skill_3 = {"name": "null", "targets": "null", "effect_type": "null", "effect": "null"}
export var skill_4 = {"name": "null", "targets": "null", "effect_type": "null", "effect": "null"}
export var skill_5 = {"name": "null", "targets": "null", "effect_type": "null", "effect": "null"}
onready var skills = [skill_1, skill_2, skill_3, skill_4, skill_5]
export var number_of_skills = 0

func _ready():
	#movement
	$AnimatedSprite.animation = "walk_down"
	$AnimatedSprite.frame = 1
	#stats
	set_player_name()

func _process(delta):
	move_follower()



###movement/following
func move_follower():
	if direction_array.size() > 0:  #party has moved
		if position == position_array[0]: #once follower reaches where the postion of when the party changed directions... (round helps prevent problem with collision slightly altering position. I need to deal with the fact that they move slightly when pushing against a wall, rather than just rounding. checking for collision_info at the right time helps)
			current_direction = direction_array[0] #...change direction
			animation_name = convert_movement_to_string(current_direction)
			update_animation(animation_name)
			remove_last_direction()
	move_and_collide(current_direction)

func remove_last_direction():
	direction_array.pop_front()
	position_array.pop_front()

func add_directions(leader_position, direction): #when party moves, this happens
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
	if animation == 'stop':
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 1
	elif animation == 'battling':
		$AnimatedSprite.stop()
		$AnimatedSprite.play("idle_battle")
		$AnimatedSprite.frame = 0
	elif animation == 'idle_down':
		$AnimatedSprite.play("walk_down")
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 1
	else:
		$AnimatedSprite.play(animation_dict[animation])

###scene_change
func reset_follower():
	direction_array = []
	position_array = []
	current_direction = Vector2(0,0)
	get_initial_direction()
	if not get_parent().isBattling:
		update_animation("idle_down")
	else:
		if not isDead: #remain dead on game_over screen
			update_animation("battling")

###Battling code
func check_for_death():
	if hp <= 0:
		hp = 0
		get_node("../../Battlefield_Template").update_log("A party member is dead!")
		isDead = true
		if get_node("../../Battlefield_Template").turn_order.has(get_node(".")):
			print('removing from turn_order')
			get_node("../../Battlefield_Template").turn_order.erase(get_node("."))
		if get_node("../../Battlefield_Template").targetable_ally_list.has(get_node(".")):
			print(get_node("../../Battlefield_Template").targetable_ally_list)
			print('removing from targetable players')
			get_node("../../Battlefield_Template").targetable_ally_list.erase(get_node("."))
		get_parent().check_if_party_is_dead()
		$AnimatedSprite.play("dying")
		yield($AnimatedSprite, "animation_finished")
		if get_parent().isPartyDead:
			main_node.switch_scene('battle', 'gameover')

func set_player_name():
	if name == 'Party_PC_Template1':
		player_name = 'Brigit'
	if name == 'Party_PC_Template2':
		player_name = 'Set'
	if name == 'Party_PC_Template3':
		player_name = 'Alastor'
