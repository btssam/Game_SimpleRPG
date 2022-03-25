extends Control

onready var menu_node = get_node("Popup_Menu")
onready var party_node = get_node("../../Party")
var isMenuOpen = false
var current_selection = 1


func _ready():
	pass

func _process(delta):
	if isMenuOpen:
		party_node.stop_party()
		party_node.animation_name = 'stop'
		party_node.get_node("PC_Template").update_animation('stop')

func _input(event):
	if event.is_action_pressed("start"):
		if !isMenuOpen:
			enable_selector()
			menu_node.show()
			isMenuOpen = true
		else:
			menu_node.hide()
			isMenuOpen = false
	if isMenuOpen:
		if event.is_action_pressed("down"):
			current_selection += 1
			print(current_selection)

func enable_selector():
	if current_selection == 1:
		$Popup_Menu/Frame/Options/Items/Selector.show()

func disable_selector():
	pass
