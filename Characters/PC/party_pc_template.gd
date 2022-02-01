extends KinematicBody2D

###movement
var motion = Vector2()
var running = false
var speed = 2
###battle check
var isBattling = false
###combat stats
export var hp = 6
export var maxhp = 6
var isDead = false
###nodes
onready var main_node = get_node("..")
###attacking
var isAttacking = false


func _ready():
	#movement
	$AnimatedSprite.animation = "walk_down"
	$AnimatedSprite.frame = 1

func _physics_process(delta):
	#movement
	update_movement()
	move_and_collide(motion) #could I call these on _input instead? Didn't seem to work initially

func _input(event):
	pass



###movement
func update_movement():
	if not isBattling:
		
		if Input.is_action_pressed("left"):
			$AnimatedSprite.play("walk_left")
			$AnimatedSprite.speed_scale = 1
			motion.x = -speed
			motion.y = 0
			if Input.is_action_pressed("run"):
				$AnimatedSprite.speed_scale = 2
				motion.x = -2 * speed
		elif Input.is_action_just_released("left"):
			$AnimatedSprite.stop()
			$AnimatedSprite.frame = 1
			motion.x = 0
			motion.y = 0
			
		elif Input.is_action_pressed("right"):
			$AnimatedSprite.play("walk_right")
			$AnimatedSprite.speed_scale = 1
			motion.x = speed
			motion.y = 0
			if Input.is_action_pressed("run"):
				$AnimatedSprite.speed_scale = 2
				motion.x =  2 * speed
		elif Input.is_action_just_released("right"):
			$AnimatedSprite.stop()
			$AnimatedSprite.frame = 1
			motion.x = 0
			motion.y = 0
			
		elif Input.is_action_pressed("up"):
			$AnimatedSprite.play("walk_up")
			$AnimatedSprite.speed_scale = 1
			motion.y = -speed
			motion.x = 0
			if Input.is_action_pressed("run"):
				$AnimatedSprite.speed_scale = 2
				motion.y = -2 *speed
		elif Input.is_action_just_released("up"):
			$AnimatedSprite.stop()
			$AnimatedSprite.frame = 1
			motion.x = 0
			motion.y = 0
			
		elif Input.is_action_pressed("down"):
			$AnimatedSprite.play("walk_down")
			$AnimatedSprite.speed_scale = 1
			motion.y = speed
			motion.x = 0
			if Input.is_action_pressed("run"):
				$AnimatedSprite.speed_scale = 2
				motion.y = 2 *speed
		elif Input.is_action_just_released("down"):
			$AnimatedSprite.stop()
			$AnimatedSprite.frame = 1
			motion.x = 0
			motion.y = 0
			
	else: #in battle
		motion.x = 0
		motion.y = 0
		if not isDead:
			if not isAttacking:
				$AnimatedSprite.animation = "idle_battle"


###Battling code
func check_for_death():
	if hp <= 0:
		hp = 0
		get_node("../Battlefield_Template").update_log("You have died!")
		isDead = true
		$AnimatedSprite.play("dying")
		yield($AnimatedSprite, "animation_finished")
		main_node.switch_scene('battle', 'gameover')
