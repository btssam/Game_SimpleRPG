extends Sprite


var isVisible = false
var isSelecting = false

var current_selection = 0
var number_of_selections = 2
#var current_open_cards = 0

var selector_sprite
var animation_player


func _ready():
	hide()


func open_commands_popup(): #callback
	get_nodes()
	
	if not isSelecting:
		if not isVisible:
			show()
			isVisible = true
			enable_selector_sprite()
		else:
			disable_selector_sprite()
			hide()
			isVisible = false
			if current_selection == 0: #attack
				isSelecting = true
				select_a_target()
			else: #flee
				get_tree().call_group("battle_group", "close_scene")
		
func select_a_target():
	get_tree().call_group("battle_group", "select_target")

func hasSelected(): #callback
	isSelecting = false
	set_skill()

func change_current_selection(direction):
	if direction == 'up':
		if current_selection > 0 :
			get_nodes()
			disable_selector_sprite()
			current_selection -= 1
			get_nodes()
			enable_selector_sprite()
	elif direction == 'down':
		if current_selection < number_of_selections - 1:
			get_nodes()
			disable_selector_sprite()
			current_selection += 1
			get_nodes()
			enable_selector_sprite()
	
func get_nodes(): #get the selector and animator of current selection(label node)
	var children_list = get_children()
	var commands_list = children_list[1].get_children()
	var command_children_list = commands_list[current_selection].get_children()
	selector_sprite = command_children_list[0]
	animation_player = command_children_list[1]

func enable_selector_sprite():
	selector_sprite.visible = true
	animation_player.play('blink')
	
func disable_selector_sprite():
	selector_sprite.visible = false
	animation_player.stop()

func set_skill():
	get_tree().call_group("battle_group", "get_skill", current_selection)
