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

onready var current_item_selection = 0
var active_party_member = 0
onready var active_item_card = item_cards[active_party_member]
onready var number_of_item_selections = 3 #could have different quantities for each PC
onready var total_of_current_inventory = current_inventory.size()
var item_card_selector_sprite
var item_card_animation_player

onready var choices_node = get_node("Popup_Items/Frame/Choices")

var isSelectingItem = true
var isSelectingNewItem = false #should likely default to selecting inventory, rather than equipped_items (e.g. this one)

var item_choice_selector_sprite
var item_choice_animation_player
var current_choice_selection = 0

#var isInfoOpen = false

func _ready():
	for i in 4:
		get_items(i)
	enable_item_selector_sprite()

func _input(event):
	if event.is_action_pressed("up") and isSelectingItem:
		change_item("up")
	if event.is_action_pressed("down") and isSelectingItem:
		change_item("down")

func get_items(party_member):
	var items_text_nodes = [item_cards[party_member].get_node("TextureRect/Item1"), item_cards[party_member].get_node("TextureRect/Item2"), item_cards[party_member].get_node("TextureRect/Item3")]
	for i in 3:
		items_text_nodes[i].bbcode_text = ''
	for i in number_of_item_selections: #3
		items_text_nodes[i].bbcode_text = equipped_items[party_member][i].name


func get_item_card_nodes():
	var items_list = active_item_card.get_node("TextureRect").get_children()
	item_card_selector_sprite = items_list[current_item_selection].get_node("Selector")
	item_card_animation_player = items_list[current_item_selection].get_node("AnimationPlayer")

func enable_item_selector_sprite():
	get_item_card_nodes()
	item_card_selector_sprite.visible = true
	item_card_animation_player.play('blink')

func disable_item_selector_sprite():
	get_item_card_nodes()
	item_card_selector_sprite.visible = false
	item_card_animation_player.stop()

func stop_item_selector_sprite():
	get_item_card_nodes()
	item_card_selector_sprite.visible = true
	item_card_animation_player.play('blink')
	item_card_animation_player.stop()

#func change_item(direction):
#	if direction == 'up':
#		if current_item_selection > 0 :
#			disable_item_selector_sprite()
#			current_item_selection -= 1
#			enable_item_selector_sprite()
#	elif direction == 'down':
#		if current_item_selection < number_of_item_selections - 1:
#			disable_item_selector_sprite()
#			current_item_selection += 1
#			enable_item_selector_sprite()

func change_item(direction):
	if direction == 'up':
		if current_item_selection > 0 :
			disable_item_selector_sprite()
			current_item_selection -= 1
			enable_item_selector_sprite()
		elif active_party_member != 0:
			disable_item_selector_sprite()
			active_party_member -= 1
#			call_deferred("set_choices")
#			set_choices()
			active_item_card = item_cards[active_party_member]
#			active_number_of_skill_selections = number_of_skills[active_party_member]
			current_item_selection = number_of_item_selections - 1
			enable_item_selector_sprite()
	elif direction == 'down':
		if current_item_selection < number_of_item_selections - 1:
			disable_item_selector_sprite()
			current_item_selection += 1
			enable_item_selector_sprite()
		elif active_party_member != 3:
			disable_item_selector_sprite()
			active_party_member += 1
#			call_deferred("set_choices")
#			set_choices()
			active_item_card = item_cards[active_party_member]
#			active_number_of_skill_selections = number_of_skills[active_party_member]
			current_item_selection = 0
			enable_item_selector_sprite()
