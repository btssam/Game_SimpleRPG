extends "res://Characters/PC/Overworld/Scripts/pc_interaction.gd"


#battle check
var steps_since_last = 0
var current_position = Vector2()
var previous_position = Vector2()
var next_battle_counter = 0

func _ready():
	get_next_battle_counter()


#check for battles
func start_timer():
	$Delta_Position1.start()

func _on_Delta_Position1_timeout():
	previous_position = position
	$Delta_Position2.start()

func _on_Delta_Position2_timeout(): #get delta of position (displacement) and use to determine if battle
	current_position = position
	check_for_battle()
	
func get_next_battle_counter(): #how many steps until next battle
	randomize()
	next_battle_counter = randi() % 900 + 1 + 100

func check_for_battle():
	var x_displacement = abs(current_position.x - previous_position.x)
	var y_displacement = abs(current_position.y - previous_position.y)
	var displacement = x_displacement + y_displacement
	steps_since_last += displacement
	if steps_since_last > next_battle_counter or Input.is_action_pressed("test_key"):
		get_tree().call_group("level_switching", "switch_scene", 'overworld', 'battle')
		battling = true
		get_next_battle_counter()
	else:
		$Delta_Position1.start()

func reset_battle_check():
	steps_since_last = 0
	$Delta_Position1.start()
	battling = false
	
func stop_battle_check():
	steps_since_last = 0
	$Delta_Position1.stop()
	battling = false
