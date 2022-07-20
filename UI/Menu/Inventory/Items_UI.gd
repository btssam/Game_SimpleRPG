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
var isSelectingNewItem = true 

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

onready var active_equip_card = equip_cards[active_party_member]
onready var choices_node_equipment =  get_node("Popup_Equip/Frame/Choices")
onready var grid_container_node_equipment = choices_node_equipment.get_node("NinePatchRect/GridContainer")
onready var equip_selector_node = "res://UI/Menu/Inventory/Equip_Selector.tscn"

onready var isSelectingArmor = 0

var isEquippableByAny = true

func _ready():
	for i in 4:
		get_items(i)
	for i in 4:
		get_equipment(i)
	set_choices()
	set_choices_equipment()
	get_item_choice_nodes()
	enable_selector()

func _input(event):
	if event.is_action_pressed("up") and isSelectingNewItem and !isInfoOpen:
		change_choice("up")
	if event.is_action_pressed("down") and isSelectingNewItem and !isInfoOpen:
		change_choice("down")
	if event.is_action_pressed("interact") and isSelectingNewItem and !isInfoOpen:
		isSelectingNewItem = false
		set_deferred("isSelectingItem", true)
		check_equippable_players()
		if isOnEquipPage:
			get_equip_choices_nodes()
		elif !isOnEquipPage:
			get_item_choice_nodes()
		stop_selector()
		if isOnEquipPage:
			get_equip_card_nodes()
		elif !isOnEquipPage:
			get_item_card_nodes()
		enable_selector()
	if event.is_action_pressed("up") and isSelectingItem and !isInfoOpen:
		if isOnEquipPage and isEquippableByAny:
			change_equip("up")
		elif !isOnEquipPage:
			change_item("up")
	if event.is_action_pressed("down") and isSelectingItem and !isInfoOpen:
		if isOnEquipPage and isEquippableByAny:
			change_equip("down")
		elif !isOnEquipPage:
			change_item("down")
	if event.is_action_pressed("interact") and isSelectingItem and !isInfoOpen:
		isSelectingItem = false
		set_deferred("isSelectingNewItem", true)
		if isOnEquipPage:
			choose_equip()
		elif not isOnEquipPage:
			choose_item()
	if event.is_action_pressed("right") and not isOnEquipPage and !isInfoOpen: #go to equips
		get_node("Popup_Items").hide()
		number_of_choice_selections = current_equips.size()
		isOnEquipPage = true
		get_item_choice_nodes()
		disable_selector()
		get_item_card_nodes()
		disable_selector()
		current_item_selection = 0
		current_choice_selection = 0 #reset all previous notions, so that when I return to items, im not stuck in previous setting
		active_party_member = 0
		get_equip_choices_nodes()
		enable_selector()
		active_item_card = item_cards[active_party_member]
		active_equip_card = equip_cards[active_party_member]
		isSelectingItem = false
		isSelectingNewItem = true
		get_node("Popup_Equip").show()
	if event.is_action_pressed("left") and isOnEquipPage and !isInfoOpen: #go to items
		get_node("Popup_Equip").hide()
		number_of_choice_selections = current_inventory.size()
		isOnEquipPage = false
		get_equip_choices_nodes()
		disable_selector()
		get_equip_card_nodes()
		disable_selector()
		current_item_selection = 0
		current_choice_selection = 0
		active_party_member = 0
		get_item_choice_nodes()
		enable_selector()
		active_item_card = item_cards[active_party_member]
		active_equip_card = equip_cards[active_party_member]
		isSelectingItem = false
		isSelectingNewItem = true
		get_node("Popup_Items").show()
	if event.is_action_pressed("info") and !isInfoOpen:
		isInfoOpen = true
		get_info()
		if not isOnEquipPage:
			get_node("Popup_Items/Popup_Info").show()
		elif isOnEquipPage:
			get_node("Popup_Equip/Popup_Info").show()
	elif event.is_action_pressed("info") and isInfoOpen:
		isInfoOpen = false
		if not isOnEquipPage:
			get_node("Popup_Items/Popup_Info").hide()
		elif isOnEquipPage:
			get_node("Popup_Equip/Popup_Info").hide()
		

#all my functions can use if isOnEquipPage to determine the intial nodes. not really

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
			get_item_card_nodes()
			disable_selector()
			current_item_selection -= 1
			get_item_card_nodes()
			enable_selector()
		elif active_party_member != 0:
			get_item_card_nodes()
			disable_selector()
			active_party_member -= 1
			active_item_card = item_cards[active_party_member]
			current_item_selection = number_of_item_selections - 1
			get_item_card_nodes()
			enable_selector()
	elif direction == 'down':
		if current_item_selection < number_of_item_selections - 1:
			get_item_card_nodes()
			disable_selector()
			current_item_selection += 1
			get_item_card_nodes()
			enable_selector()
		elif active_party_member != 3:
			get_item_card_nodes()
			disable_selector()
			active_party_member += 1
			active_item_card = item_cards[active_party_member]
			current_item_selection = 0
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

func change_choice(direction):
	if direction == 'up':
		if current_choice_selection > 0 :
			if isOnEquipPage:
				get_equip_choices_nodes()
			if not isOnEquipPage:
				get_item_choice_nodes()
			disable_selector()
			current_choice_selection -= 1
			if isOnEquipPage:
				get_equip_choices_nodes()
			if not isOnEquipPage:
				get_item_choice_nodes()
			enable_selector()
	elif direction == 'down':
		if current_choice_selection < number_of_choice_selections - 1:
			if isOnEquipPage:
				get_equip_choices_nodes()
			if not isOnEquipPage:
				get_item_choice_nodes()
			disable_selector()
			current_choice_selection += 1
			if isOnEquipPage:
				get_equip_choices_nodes()
			if not isOnEquipPage:
				get_item_choice_nodes()
			enable_selector()

func choose_item():
	get_item_card_nodes()
	disable_selector()
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
	var current_selected_item_info
	if not isOnEquipPage:
		base_node = get_node("Popup_Items/Popup_Info/ColorRect/Frame")
		if isSelectingItem:
			current_selected_item_info = equipped_items[active_party_member][current_item_selection]
		elif isSelectingNewItem:
			current_selected_item_info = current_inventory[current_choice_selection]
		var info_effect_type_node = base_node.get_node("Effect_Type")
		var info_effect_node = base_node.get_node("Effect")
		var info_targets_node = base_node.get_node("Targets")
		var info_icon_node = base_node.get_node("Icon") 
		info_effect_type_node.bbcode_text = "[color=#b99c4b]Effect[/color]: " + current_selected_item_info.effect_type
		info_effect_node.bbcode_text = "[color=#b99c4b]Scale[/color]: " + str(current_selected_item_info.effect)
		info_targets_node.bbcode_text = "[color=#b99c4b]Targets[/color]: " + current_selected_item_info.targets
		info_icon_node.bbcode_text = "[color=#b99c4b]Icon[/color]: " + str(current_selected_item_info.icon_number)
	elif isOnEquipPage:
		base_node = get_node("Popup_Equip/Popup_Info/ColorRect/Frame")
		if isSelectingItem:
#			current_selected_item_info = equipped_items[active_party_member][current_item_selection]
			current_selected_item_info = equipment[active_party_member][isSelectingArmor] #this is still just the variable_name
			for i in current_equips.size():
				if current_equips[i].variable_name == equipment[active_party_member][isSelectingArmor]:
					current_selected_item_info = current_equips[i]
					break
		elif isSelectingNewItem:
#			current_selected_item_info = current_inventory[current_choice_selection]
			current_selected_item_info = current_equips[current_choice_selection]
		var info_type_node = base_node.get_node("Type")
		var info_player_node = base_node.get_node("Player")
		var info_stats_node = base_node.get_node("Stats")
		info_type_node.bbcode_text = "[color=#b99c4b]Type[/color]: " + current_selected_item_info.type
		info_player_node.bbcode_text = "[color=#b99c4b]Player[/color]: " + current_selected_item_info.player
		info_stats_node.bbcode_text = "[color=#b99c4b]Stats[/color]: " + str(current_selected_item_info.stats)
	var info_name_node = base_node.get_node("Name")
	var info_desc_node = base_node.get_node("Desc")
	var info_quantity_node = base_node.get_node("Quantity")
	info_name_node.bbcode_text = current_selected_item_info.name
	info_desc_node.bbcode_text = current_selected_item_info.description
	info_quantity_node.bbcode_text = "[color=#1E90FF]Quantity[/color]: " + str(current_selected_item_info.quantity)
	
	

func get_equipment(player): #set the icons
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


func get_equip_card_nodes(): #check for which equip slot here (get_info)
	var current_item = current_equips[current_choice_selection]
	if current_item.type == "weapon":
		isSelectingArmor = 0
	elif current_item.type == "armor":
		isSelectingArmor = 1
	var equip_card_node = active_equip_card.get_node("TextureRect").get_child(isSelectingArmor)
	current_selector_sprite = equip_card_node.get_node("Selector")
	current_selector_animation_player = equip_card_node.get_node("AnimationPlayer")

func get_equip_choices_nodes():
	var equips_choices_node = grid_container_node_equipment.get_child(current_choice_selection)
	current_selector_sprite = equips_choices_node.get_node("Selector")
	current_selector_animation_player = equips_choices_node.get_node("AnimationPlayer")

func change_equip(direction): #need to check if equipment is equipable on that character. need to check for slot of equipment
	print('change_equip()')
	if direction == 'up':
		if active_party_member != 0:
			get_equip_card_nodes()
			disable_selector()
			active_party_member -= 1
			active_equip_card = equip_cards[active_party_member]
			get_equip_card_nodes()
			enable_selector()
	elif direction == 'down':
		if active_party_member != 3:
			get_equip_card_nodes()
			disable_selector()
			active_party_member += 1
			active_equip_card = equip_cards[active_party_member]
			get_equip_card_nodes()
			enable_selector()

func choose_equip():
#	get_item_card_nodes()
	get_equip_card_nodes()
	disable_selector()
#	get_item_choice_nodes()
	get_equip_choices_nodes()
	disable_selector()

#	var new_current_items = equipped_items[active_party_member].duplicate()
	var new_current_equips = equipment[active_party_member].duplicate()
	new_current_equips.pop_at(isSelectingArmor) #0 if weapon, 1 if armor, which is already the order of my equipment array
	new_current_equips.insert(isSelectingArmor, current_equips[current_choice_selection].variable_name)
	equipment[active_party_member] = new_current_equips

	if active_party_member == 0: #change the equipped_items of the player node
		get_node("../../../../Party/PC_Template").equipment = new_current_equips
	else:
		get_node("../../../../Party/Party_PC_Template" + str(active_party_member)).equipment = new_current_equips
		
#	get_items(active_party_member) #update info in current menu
	get_equipment(active_party_member)

	current_choice_selection = 0
#	get_item_choice_nodes()
	get_equip_choices_nodes()
	enable_selector()

func check_equippable_players():
	if current_equips[current_choice_selection].player == 'any':
		isEquippableByAny = true
	else:
		isEquippableByAny = false
		print('restricting selection')
		if current_equips[current_choice_selection].player == 'Frey':
			active_party_member = 0
		elif current_equips[current_choice_selection].player == 'Brigit':
			active_party_member = 1
		elif current_equips[current_choice_selection].player == 'Set':
			active_party_member = 2
		elif current_equips[current_choice_selection].player == 'Alastor':
			active_party_member = 3
		active_equip_card = equip_cards[active_party_member]
