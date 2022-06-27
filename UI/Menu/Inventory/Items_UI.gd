extends Control

onready var item_card_1 = $Popup_Items/Frame/PC1/Sprite/Item_Card
onready var item_card_2 = $Popup_Items/Frame/PC2/Sprite/Item_Card
onready var item_card_3 = $Popup_Items/Frame/PC3/Sprite/Item_Card
onready var item_card_4 = $Popup_Items/Frame/PC4/Sprite/Item_Card
onready var item_cards = [item_card_1, item_card_2, item_card_3, item_card_4]

onready var equipped_items_1 = get_node("../../../../Party/PC_Template").equipped_items
onready var equipped_items_2 = get_node("../../../../Party/Party_PC_Template1").equipped_items
onready var equipped_items_3 = get_node("../../../../Party/Party_PC_Template2").equipped_items
onready var equipped_items_4 = get_node("../../../../Party/Party_PC_Template3").equipped_items
onready var equipped_items = [equipped_items_1, equipped_items_2, equipped_items_3, equipped_items_4]

onready var current_inventory = get_node("../../../../Party/PC_Template/Inventory").current_inventory
onready var all_inventory = get_node("../../../../Party/PC_Template/Inventory").all_items

onready var current_item_selection = 0
var active_party_member = 0
onready var active_item_card = item_cards[active_party_member]
onready var number_of_item_selections = 3 #could have different quantities for each PC
onready var total_of_current_inventory = current_inventory.size()
#var item_card_selector_sprite
#var item_card_animation_player
var current_selector_sprite
var current_selector_animation_player

onready var choices_node = get_node("Popup_Items/Frame/Choices")

var isSelectingItem = false
var isSelectingNewItem = true #should likely default to selecting inventory, rather than equipped_items (e.g. this one)

onready var grid_container_node = choices_node.get_node("NinePatchRect/GridContainer")
var item_choice_selector_sprite
var item_choice_animation_player
var current_choice_selection = 0
onready var number_of_choice_selections = current_inventory.size()

var isInfoOpen = false

onready var item_selector_node = "res://UI/Menu/Inventory/Item_Selector.tscn"

var isOnEquipPage = false

onready var current_equips = get_node("../../../../Party/PC_Template/Inventory").current_equips
onready var all_equips = get_node("../../../../Party/PC_Template/Inventory").all_equips

onready var equip_card_1 = $Popup_Equip/Frame/PC1/Sprite/Equip_Card
onready var equip_card_2 = $Popup_Equip/Frame/PC2/Sprite/Equip_Card
onready var equip_card_3 = $Popup_Equip/Frame/PC3/Sprite/Equip_Card
onready var equip_card_4 = $Popup_Equip/Frame/PC4/Sprite/Equip_Card
onready var equip_cards = [equip_card_1, equip_card_2, equip_card_3, equip_card_4]

onready var equipment_1 = get_node("../../../../Party/PC_Template").equipment
onready var equipment_2 = get_node("../../../../Party/Party_PC_Template1").equipment
onready var equipment_3 = get_node("../../../../Party/Party_PC_Template2").equipment
onready var equipment_4 = get_node("../../../../Party/Party_PC_Template3").equipment
onready var equipment = [equipment_1, equipment_2, equipment_3, equipment_4]

onready var choices_node_equipment =  get_node("Popup_Equip/Frame/Choices")
onready var grid_container_node_equipment = choices_node_equipment.get_node("NinePatchRect/GridContainer")
onready var equip_selector_node = "res://UI/Menu/Inventory/Equip_Selector.tscn"

func _ready():
	for i in 4:
		get_items(i)
#	enable_item_selector_sprite()
	set_choices()
	set_choices_equipment()
#	enable_item_choice_selector_sprite()
	get_item_choice_nodes()
	enable_selector()

func _input(event):
	#add if's for if is on equip page
	if event.is_action_pressed("up") and isSelectingNewItem:
		change_choice("up")
	if event.is_action_pressed("down") and isSelectingNewItem:
		change_choice("down")
	if event.is_action_pressed("interact") and isSelectingNewItem:
		isSelectingNewItem = false
		set_deferred("isSelectingItem", true)
#		stop_item_choice_selector_sprite()
		get_item_choice_nodes()
		stop_selector()
#		enable_item_selector_sprite()
		get_item_card_nodes()
		enable_selector()
	if event.is_action_pressed("up") and isSelectingItem:
		change_item("up")
	if event.is_action_pressed("down") and isSelectingItem:
		change_item("down")
	if event.is_action_pressed("interact") and isSelectingItem:
		isSelectingItem = false
		set_deferred("isSelectingNewItem", true)
		choose_item()
#		disable_item_selector_sprite()
#		enable_item_choice_selector_sprite()
	if event.is_action_pressed("right") and not isOnEquipPage:
		get_node("Popup_Items").hide()
		isOnEquipPage = true
		isSelectingNewItem = true
#		enable_item_choice_selector_sprite() #why enable, then disable
#		disable_item_choice_selector_sprite()
		get_item_choice_nodes()
		disable_selector()
#		disable_item_selector_sprite()
		get_item_card_nodes()
		disable_selector()
		current_item_selection = 0
		current_choice_selection = 0 #reset all previous notions, so that when I return to items, im not stuck in previous setting
		active_party_member = 0
		active_item_card = item_cards[active_party_member]
		isSelectingItem = false
		isSelectingNewItem = true
		for i in 4:
			get_equipment(i)
		get_node("Popup_Equip").show()
	if event.is_action_pressed("left") and isOnEquipPage:
		get_node("Popup_Equip").hide()
		isOnEquipPage = false
#		enable_item_choice_selector_sprite()
		get_item_choice_nodes()
		enable_selector()
		get_node("Popup_Items").show()
	if event.is_action_pressed("info") and !isInfoOpen:
		isInfoOpen = true
		get_info()
		get_node("Popup_Items/Popup_Info").show()
	elif event.is_action_pressed("info") and isInfoOpen:
		isInfoOpen = false
		get_node("Popup_Items/Popup_Info").hide()
		

#all my functions can use if isOnEquipPage to determine the intial nodes

func get_items(party_member):
	var items_text_nodes = [item_cards[party_member].get_node("TextureRect/Item1"), item_cards[party_member].get_node("TextureRect/Item2"), item_cards[party_member].get_node("TextureRect/Item3")]
	for i in 3:
		items_text_nodes[i].bbcode_text = ''
	for i in number_of_item_selections: #3
		items_text_nodes[i].bbcode_text = equipped_items[party_member][i].name


func get_item_card_nodes():
	var items_list = active_item_card.get_node("TextureRect").get_children()
	current_selector_sprite = items_list[current_item_selection].get_node("Selector")
	current_selector_animation_player = items_list[current_item_selection].get_node("AnimationPlayer")

#func enable_item_selector_sprite(): #I could just use the same selector_sprite function and just set a different node. change to current_selector_sprite and current_animation_player and coudld just use the different get_node functions
#	get_item_card_nodes()
#	item_card_selector_sprite.visible = true
#	item_card_animation_player.play('blink')

func enable_selector():
	current_selector_sprite.visible = true
	current_selector_animation_player.play('blink')
	

func disable_selector():
	current_selector_sprite.visible = false
	current_selector_animation_player.stop()

func stop_selector():
	current_selector_sprite.visible = true
	current_selector_animation_player.play('blink')
	current_selector_animation_player.stop()

func change_item(direction):
	if direction == 'up':
		if current_item_selection > 0 :
#			disable_item_selector_sprite()
			get_item_card_nodes()
			disable_selector()
			current_item_selection -= 1
#			enable_item_selector_sprite()
			get_item_card_nodes()
			enable_selector()
		elif active_party_member != 0:
#			disable_item_selector_sprite()
			get_item_card_nodes()
			disable_selector()
			active_party_member -= 1
#			call_deferred("set_choices")
#			set_choices()
			active_item_card = item_cards[active_party_member]
#			active_number_of_skill_selections = number_of_skills[active_party_member]
			current_item_selection = number_of_item_selections - 1
#			enable_item_selector_sprite()
			get_item_card_nodes()
			enable_selector()
	elif direction == 'down':
		if current_item_selection < number_of_item_selections - 1:
#			disable_item_selector_sprite()
			get_item_card_nodes()
			disable_selector()
			current_item_selection += 1
#			enable_item_selector_sprite()
			get_item_card_nodes()
			enable_selector()
		elif active_party_member != 3:
#			disable_item_selector_sprite()
			get_item_card_nodes()
			disable_selector()
			active_party_member += 1
#			call_deferred("set_choices")
#			set_choices()
			active_item_card = item_cards[active_party_member]
#			active_number_of_skill_selections = number_of_skills[active_party_member]
			current_item_selection = 0
#			enable_item_selector_sprite()
			get_item_card_nodes()
			enable_selector()

func set_choices():
	for i in current_inventory.size(): #determine by inventory.size(), should max at 16
		var item_to_be_loaded = load(item_selector_node).instance()
		grid_container_node.add_child(item_to_be_loaded)
		var current_item = grid_container_node.get_child(i)
		current_item.get_node("Sprite").frame = current_inventory[i].icon_number
		current_item.get_node("Selector").frame = current_inventory[i].icon_number

func get_item_choice_nodes():
	var item_choice_node = grid_container_node.get_child(current_choice_selection)
	current_selector_sprite = item_choice_node.get_node("Selector")
	current_selector_animation_player = item_choice_node.get_node("AnimationPlayer")

#func enable_item_choice_selector_sprite():
#	get_item_choice_nodes()
#	current_selector_sprite.visible = true
#	current_selector_animation_player.play('blink')
#
#func disable_item_choice_selector_sprite():
#	get_item_choice_nodes()
#	current_selector_sprite.visible = false
#	current_selector_animation_player.stop()
#
#func stop_item_choice_selector_sprite():
#	get_item_card_nodes()
#	current_selector_sprite.visible = true
#	current_selector_animation_player.play('blink')
#	current_selector_animation_player.stop()

func change_choice(direction):
	if direction == 'up':
		if current_choice_selection > 0 :
#			disable_item_choice_selector_sprite()
			get_item_choice_nodes()
			disable_selector()
			current_choice_selection -= 1
#			enable_item_choice_selector_sprite()
			get_item_choice_nodes()
			enable_selector()
	elif direction == 'down':
		if current_choice_selection < number_of_choice_selections - 1:
#			disable_item_choice_selector_sprite()
			get_item_choice_nodes()
			disable_selector()
			current_choice_selection += 1
#			enable_item_choice_selector_sprite()
			get_item_choice_nodes()
			enable_selector()

func choose_item():
#	disable_item_selector_sprite()
	get_item_card_nodes()
	disable_selector()
#	disable_item_choice_selector_sprite()
	get_item_choice_nodes()
	disable_selector()

	var new_current_items = equipped_items[active_party_member].duplicate()
	new_current_items.pop_at(current_item_selection)
	new_current_items.insert(current_item_selection, current_inventory[current_choice_selection])
	equipped_items[active_party_member] = new_current_items

	if active_party_member == 0: #change the equipped_items of the player node
		get_node("../../../../Party/PC_Template").equipped_items = new_current_items
	else:
		get_node("../../../../Party/Party_PC_Template" + str(active_party_member)).equipped_items = new_current_items
		
		
	get_items(active_party_member) #update info in current menu
	
	current_choice_selection = 0
	get_item_choice_nodes()
	enable_selector()

func get_info():
	var base_node
	if not isOnEquipPage:
		base_node = get_node("Popup_Items/Popup_Info/ColorRect/Frame")
	elif isOnEquipPage:
		base_node = get_node("Popup_Equip/Popup_Info/ColorRect/Frame")
	var info_name_node = base_node.get_node("Name")
	var info_desc_node = base_node.get_node("Desc")
	var info_quantity_node = base_node.get_node("Quantity")
	var info_effect_type_node = base_node.get_node("Effect_Type")
	var info_effect_node = base_node.get_node("Effect")
	var info_targets_node = base_node.get_node("Targets")
	var info_icon_node = base_node.get_node("Icon") #would be ottally different nodes for equips
	var current_selected_item_info
	if isSelectingItem:
		current_selected_item_info = equipped_items[active_party_member][current_item_selection]
	elif isSelectingNewItem:
		current_selected_item_info = current_inventory[current_choice_selection]
	info_name_node.bbcode_text = current_selected_item_info.name
	info_desc_node.bbcode_text = current_selected_item_info.description
	info_quantity_node.bbcode_text = "[color=#1E90FF]Quantity[/color]: " + str(current_selected_item_info.quantity)
	info_effect_type_node.bbcode_text = "[color=#b99c4b]Effect[/color]: " + current_selected_item_info.effect_type
	info_effect_node.bbcode_text = "[color=#b99c4b]Scale[/color]: " + str(current_selected_item_info.effect)
	info_targets_node.bbcode_text = "[color=#b99c4b]Targets[/color]: " + current_selected_item_info.targets
	info_icon_node.bbcode_text = "[color=#b99c4b]Icon[/color]: " + str(current_selected_item_info.icon_number)
	
	

func get_equipment(player):
	for x in 2: #for armor and weapon
		var this_equipment = equip_cards[player].get_node("TextureRect").get_child(x)
		for i in current_equips.size():
			if current_equips[i].variable_name == equipment[player][x]:
				this_equipment.get_node("Sprite").frame = current_equips[i].icon_number
				this_equipment.get_node("Selector").frame = current_equips[i].icon_number

func set_choices_equipment():
	for i in current_equips.size(): #determine by equips.size(), should max at 16
		var item_to_be_loaded = load(equip_selector_node).instance()
		grid_container_node_equipment.add_child(item_to_be_loaded)
		var current_item = grid_container_node_equipment.get_child(i)
		current_item.get_node("Sprite").frame = current_equips[i].icon_number
		current_item.get_node("Selector").frame = current_equips[i].icon_number
