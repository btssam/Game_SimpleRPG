extends Control #How do I want the menu to behave in battle. Just inacessable entirely (a lot of games do that). Maybe can only Quit, Load, Status, Option. Inacessable because I want exit to be able to be used to back out of a command

onready var menu_node = get_node("Popup_Menu")
onready var party_node = get_node("../../../Party")
var isMenuOpen = false
var current_selection = 1
var isSubMenuOpen = false

var status_node = "res://UI/Menu/Status_UI.tscn"
var skills_node = "res://UI/Menu/Skills_UI.tscn"
var items_node = "res://UI/Menu/Inventory/Items_UI.tscn"
#could have an array of each submenu node, so I don't have to do chaining if statements, but could use array[current_selection]

#status
onready var player1_node = get_node("../../../Party/PC_Template")
onready var player2_node = get_node("../../../Party/Party_PC_Template1")
onready var player3_node = get_node("../../../Party/Party_PC_Template2")
onready var player4_node = get_node("../../../Party/Party_PC_Template3")
onready var players = [player1_node, player2_node, player3_node, player4_node]
onready var number_of_party_members = 4

func _ready():
	pass

func _process(delta):
	if isMenuOpen:
		party_node.stop_party()
		party_node.animation_name = 'stop'
		party_node.get_node("PC_Template").update_animation('stop')

func _input(event):
	if not party_node.isBattling:
		if event.is_action_pressed("esc"):
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
	$Popup_Menu/Frame/Options.get_child(current_selection-1).get_child(0).show() #Selector
	$Popup_Menu/Frame/Options.get_child(current_selection-1).get_child(1).play("blink") #AP

func disable_selector():
	$Popup_Menu/Frame/Options.get_child(current_selection-1).get_child(0).hide() #Selector
	$Popup_Menu/Frame/Options.get_child(current_selection-1).get_child(1).stop() #Anmplayer

func process_selection():
	if current_selection == 1:
		open_submenu()
	elif current_selection == 2:
		open_submenu()
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
	if current_selection == 1:
		var items = load(items_node).instance()
		add_child(items)
		get_node("Items_UI/Popup_Items").show()
	if current_selection == 2:
		var skills = load(skills_node).instance()
		add_child(skills)
		get_node("Skills_UI/Popup_Skills").show()
	if current_selection == 3:
		var status = load(status_node).instance()
		add_child(status)
		call_deferred("update_status")
#		update_status()
		get_node("Status_UI/Popup_Status").show()

func close_submenu():
	isSubMenuOpen = false
	#should I set isMenuOpen to true?
	isMenuOpen = true
	if current_selection == 1:
		remove_child(get_node("Items_UI"))
	if current_selection == 2:
		remove_child(get_node("Skills_UI"))
	if current_selection == 3:
		remove_child(get_node("Status_UI"))

func update_status(): #could move this to Status_UI.tscn
	var current_status_node = get_node("Status_UI/Popup_Status/Frame")
#	pass #grab the current hp from each player, likely should note maxhp
	var status_1 = current_status_node.get_node("PC1/Sprite/Info")
	var status_2 = current_status_node.get_node("PC2/Sprite/Info")
	var status_3 = current_status_node.get_node("PC3/Sprite/Info")
	var status_4 = current_status_node.get_node("PC4/Sprite/Info")
	var status_array = [status_1, status_2, status_3, status_4]
	for i in number_of_party_members:
		status_array[i].text = players[i].player_name + '\n' + 'HP:' + str(players[i].hp) + '/' + str(players[i].maxhp) + ' ATK:' + str(players[i].attack) + ' DEF:' + str(players[i].defence) + '\n' + 'MP:' + str(players[i].mp) + '/' + str(players[i].maxmp) + ' INT:' + str(players[i].intellect) + ' SPD:' + str(players[i].speed)




#func get_equipment():
#	for x in 2: #for armor and weapon
#		for i in current_equipment.size():
#			if current_equipment[i].name == player.equipment[x].name:
#				icon = current_equipment[i].icon
