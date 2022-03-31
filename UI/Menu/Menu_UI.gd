extends Control #How do I want the menu to behave in battle. Just inacessable entirely (a lot of games do that). Maybe can only Quit, Load, Status, Option

onready var menu_node = get_node("Popup_Menu")
onready var party_node = get_node("../../Party")
var isMenuOpen = false
var current_selection = 1
var isSubMenuOpen = false

var status_node = "res://UI/Menu/Status_UI.tscn"
var current_submenu_node


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
			open_menu()
		elif !isSubMenuOpen: #menu open but submenu closed (main menu)
			disable_selector()
			close_menu()
		
		if isSubMenuOpen:
			close_submenu()
			
	if isMenuOpen:
		if event.is_action_pressed("down"):
			if current_selection < 8:
				disable_selector()
				current_selection += 1
				enable_selector()
		if event.is_action_pressed("up"):
			if current_selection > 1:
				disable_selector()
				current_selection -= 1
				enable_selector()
		if event.is_action_pressed("interact"):
			process_selection()

func enable_selector():
	if current_selection == 1:
		$Popup_Menu/Frame/Options/Items/Selector.show()
		$Popup_Menu/Frame/Options/Items/AnimationPlayer.play("blink")
	elif current_selection == 2:
		$Popup_Menu/Frame/Options/Skills/Selector.show()
		$Popup_Menu/Frame/Options/Skills/AnimationPlayer.play("blink")
	elif current_selection == 3:
		$Popup_Menu/Frame/Options/Status/Selector.show()
		$Popup_Menu/Frame/Options/Status/AnimationPlayer.play("blink")
	elif current_selection == 4:
		$Popup_Menu/Frame/Options/Quests/Selector.show()
		$Popup_Menu/Frame/Options/Quests/AnimationPlayer.play("blink")
	elif current_selection == 5:
		$Popup_Menu/Frame/Options/Option/Selector.show()
		$Popup_Menu/Frame/Options/Option/AnimationPlayer.play("blink")
	elif current_selection == 6:
		$Popup_Menu/Frame/Options/Save/Selector.show()
		$Popup_Menu/Frame/Options/Save/AnimationPlayer.play("blink")
	elif current_selection == 7:
		$Popup_Menu/Frame/Options/Load/Selector.show()
		$Popup_Menu/Frame/Options/Load/AnimationPlayer.play("blink")
	elif current_selection == 8:
		$Popup_Menu/Frame/Options/Quit/Selector.show()
		$Popup_Menu/Frame/Options/Quit/AnimationPlayer.play("blink")

func disable_selector():
	if current_selection == 1:
		$Popup_Menu/Frame/Options/Items/Selector.hide()
		$Popup_Menu/Frame/Options/Items/AnimationPlayer.stop()
	elif current_selection == 2:
		$Popup_Menu/Frame/Options/Skills/Selector.hide()
		$Popup_Menu/Frame/Options/Skills/AnimationPlayer.stop()
	elif current_selection == 3:
		$Popup_Menu/Frame/Options/Status/Selector.hide()
		$Popup_Menu/Frame/Options/Status/AnimationPlayer.stop()
	elif current_selection == 4:
		$Popup_Menu/Frame/Options/Quests/Selector.hide()
		$Popup_Menu/Frame/Options/Quests/AnimationPlayer.stop()
	elif current_selection == 5:
		$Popup_Menu/Frame/Options/Option/Selector.hide()
		$Popup_Menu/Frame/Options/Option/AnimationPlayer.stop()
	elif current_selection == 6:
		$Popup_Menu/Frame/Options/Save/Selector.hide()
		$Popup_Menu/Frame/Options/Save/AnimationPlayer.stop()
	elif current_selection == 7:
		$Popup_Menu/Frame/Options/Load/Selector.hide()
		$Popup_Menu/Frame/Options/Load/AnimationPlayer.stop()
	elif current_selection == 8:
		$Popup_Menu/Frame/Options/Quit/Selector.hide()
		$Popup_Menu/Frame/Options/Quit/AnimationPlayer.stop()

func process_selection():
	if current_selection == 1:
		print('Items')
	elif current_selection == 2:
		print('Skills')
	elif current_selection == 3:
		open_submenu()
	elif current_selection == 4:
		print('Quests')
	elif current_selection == 5:
		print('Option')
	elif current_selection == 6:
		print('Save')
	elif current_selection == 7:
		print('Load')
	elif current_selection == 8:
		get_tree().quit() #Should probably quit to a main menu

func open_menu():
	enable_selector()
	menu_node.show()
	isMenuOpen = true

func close_menu():
	menu_node.hide()
	isMenuOpen = false
	current_selection = 1

func open_submenu():
	disable_selector()
	isSubMenuOpen = true
	isMenuOpen = false
	menu_node.hide()
	if current_selection == 3:
		var status = load(status_node).instance()
		add_child(status)
		get_node("Status_UI/Popup_Status").show()

func close_submenu():
	isSubMenuOpen = false
	if current_selection == 3:
		remove_child(get_node("Status_UI"))
