extends Sprite


var isVisible = false
var isSelecting = false

var current_selection = 0
var number_of_selections = 4
#var current_open_cards = 0

var selector_sprite
var animation_player


func _ready():
	hide()


func process_command(): #callback #should be called process_command
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
				isSelecting = false #this is added, but should not be needed in new version
			elif current_selection == 1: #skill
				print('no skills')
			elif current_selection == 2: #item
				print('no items')
			elif current_selection == 3: #flee
				current_selection = 0
				get_tree().call_group("battle_group", "close_scene")
				
		
func select_a_target(): #to battlefield_targeting
	get_tree().call_group("battle_group", "select_target")

#func hasSelected(): #callback from battlefield_targeting
#	isSelecting = false  #this is not done in new versions
#	get_tree().call_group("battle_group", "get_skill", current_selection) #to battlefield_selecting_skill

func change_current_selection(direction):
	if direction == 'up':
		if current_selection > 0 :
			disable_selector_sprite()
			current_selection -= 1
			enable_selector_sprite()
	elif direction == 'down':
		if current_selection < number_of_selections - 1:
			disable_selector_sprite()
			current_selection += 1
			enable_selector_sprite()
	
func get_nodes(): #get the selector and animator of current selection(label node)
	var children_list = get_children()
	var commands_list = children_list[1].get_children()
	var command_children_list = commands_list[current_selection].get_children()
	selector_sprite = command_children_list[0]
	animation_player = command_children_list[1]

func enable_selector_sprite(): #must rename thise two functions, as the same name is in battlefield_targeting
	get_nodes()
	selector_sprite.visible = true
	animation_player.play('blink')
	
func disable_selector_sprite():
	get_nodes()
	selector_sprite.visible = false
	animation_player.stop()
