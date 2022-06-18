extends Control

onready var skill_card_1 = $Popup_Skills/Frame/PC1/Sprite/Skill_Card
onready var skill_card_2 = $Popup_Skills/Frame/PC2/Sprite/Skill_Card
onready var skill_card_3 = $Popup_Skills/Frame/PC3/Sprite/Skill_Card
onready var skill_card_4 = $Popup_Skills/Frame/PC4/Sprite/Skill_Card
onready var skill_cards = [skill_card_1, skill_card_2, skill_card_3, skill_card_4]

onready var skill_info_1 = get_node("../../../../Party/PC_Template").skills
onready var skill_info_2 = get_node("../../../../Party/Party_PC_Template1").skills
onready var skill_info_3 = get_node("../../../../Party/Party_PC_Template2").skills
onready var skill_info_4 = get_node("../../../../Party/Party_PC_Template3").skills
onready var skill_info = [skill_info_1, skill_info_2, skill_info_3, skill_info_4]

onready var number_of_skills_1 =  get_node("../../../../Party/PC_Template").number_of_skills
onready var number_of_skills_2 =  get_node("../../../../Party/Party_PC_Template1").number_of_skills
onready var number_of_skills_3 =  get_node("../../../../Party/Party_PC_Template2").number_of_skills
onready var number_of_skills_4 =  get_node("../../../../Party/Party_PC_Template3").number_of_skills
onready var number_of_skills = [number_of_skills_1, number_of_skills_2, number_of_skills_3, number_of_skills_4]

onready var current_skill_selection = 0
var active_party_member = 0
onready var active_skill_card = skill_cards[active_party_member]
onready var active_number_of_skill_selections = number_of_skills[active_party_member] #could just be current_skills.length()
onready var total_number_of_skill_selections = 5 #will need to be updated based on total skill options
var skill_card_selector_sprite
var skill_card_animation_player

onready var choices_node = get_node("Popup_Skills/Frame/Choices")

var isSelectingSkill = true
var isSelectingNewSkill = false

onready var current_skill_info_1 = get_node("../../../../Party/PC_Template").current_skills
onready var current_skill_info_2 = get_node("../../../../Party/Party_PC_Template1").current_skills
onready var current_skill_info_3 = get_node("../../../../Party/Party_PC_Template2").current_skills
onready var current_skill_info_4 = get_node("../../../../Party/Party_PC_Template3").current_skills
onready var current_skill_info = [current_skill_info_1, current_skill_info_2, current_skill_info_3, current_skill_info_4]

var skill_choice_selector_sprite
var skill_choice_animation_player
var current_choice_selection = 0
var active_number_of_choice_selections
var choices_array = []

func _ready():
	for i in 4:
		get_skills(i)
	enable_skill_card_selector_sprite()
	set_choices()

func _input(event):
	if event.is_action_pressed("up") and isSelectingSkill:
		change_skill("up")
	if event.is_action_pressed("down") and isSelectingSkill:
		change_skill("down")
	if event.is_action_pressed("interact") and isSelectingSkill:
		isSelectingSkill = false
		set_deferred("isSelectingNewSkill", true)
#		isSelectingNewSkill = true
		stop_skill_card_selector_sprite()
		enable_skill_choice_selector_sprite()
	if event.is_action_pressed("down") and isSelectingNewSkill:
		change_choice("down")
	if event.is_action_pressed("up") and isSelectingNewSkill:
		change_choice("up")
	if event.is_action_pressed("interact") and isSelectingNewSkill:
		choose_skill()
		isSelectingNewSkill = false
		isSelectingSkill = true
	###need to add tab button to show skill details


func get_skills(party_member):
	var skills_text = [skill_cards[party_member].get_node("TextureRect/Skill1"), skill_cards[party_member].get_node("TextureRect/Skill2"), skill_cards[party_member].get_node("TextureRect/Skill3"), skill_cards[party_member].get_node("TextureRect/Skill4"), skill_cards[party_member].get_node("TextureRect/Skill5")]
	for i in 5:
		skills_text[i].bbcode_text = ''
	var number_of_skill_selections = number_of_skills[party_member]
	for i in number_of_skill_selections: #update names of skills
		skills_text[i].bbcode_text = current_skill_info[party_member][i].name
		


func get_skill_card_nodes():
	var skills_list = active_skill_card.get_node("TextureRect").get_children()
	skill_card_selector_sprite = skills_list[current_skill_selection].get_node("Selector")
	skill_card_animation_player = skills_list[current_skill_selection].get_node("AnimationPlayer")
#
func enable_skill_card_selector_sprite():
	get_skill_card_nodes()
	skill_card_selector_sprite.visible = true
	skill_card_animation_player.play('blink')
#
func disable_skill_card_selector_sprite():
	get_skill_card_nodes()
	skill_card_selector_sprite.visible = false
	skill_card_animation_player.stop()

func stop_skill_card_selector_sprite():
	get_skill_card_nodes()
	skill_card_selector_sprite.visible = true
	skill_card_animation_player.play('blink')
	skill_card_animation_player.stop()
#
func change_skill(direction):
	if direction == 'up':
		if current_skill_selection > 0 :
			disable_skill_card_selector_sprite()
			current_skill_selection -= 1
			enable_skill_card_selector_sprite()
		elif active_party_member != 0:
			disable_skill_card_selector_sprite()
			active_party_member -= 1
			call_deferred("set_choices")
#			set_choices()
			active_skill_card = skill_cards[active_party_member]
			active_number_of_skill_selections = number_of_skills[active_party_member]
			current_skill_selection = 0
			enable_skill_card_selector_sprite()
	elif direction == 'down':
		if current_skill_selection < active_number_of_skill_selections - 1:
			disable_skill_card_selector_sprite()
			current_skill_selection += 1
			enable_skill_card_selector_sprite()
		elif active_party_member != 3:
			disable_skill_card_selector_sprite()
			active_party_member += 1
			call_deferred("set_choices")
#			set_choices()
			active_skill_card = skill_cards[active_party_member]
			active_number_of_skill_selections = number_of_skills[active_party_member]
			current_skill_selection = 0
			enable_skill_card_selector_sprite()

func set_choices():
	var text_array = choices_node.get_children()
	text_array.pop_front()
	for i in 5:
		text_array[i].bbcode_text = ''
	choices_array = []
	for i in total_number_of_skill_selections:
		if not current_skill_info[active_party_member].has(skill_info[active_party_member][i]):
			if skill_info[active_party_member][i].name != 'null':
				choices_array.append(skill_info[active_party_member][i])
	active_number_of_choice_selections = choices_array.size()
	for i in choices_array.size():
		text_array[i].bbcode_text = choices_array[i].name


func get_skill_choice_nodes():
	var skill_choice_node = choices_node.get_child(current_choice_selection+1)
	skill_choice_selector_sprite = skill_choice_node.get_node("Selector")
	skill_choice_animation_player = skill_choice_node.get_node("AnimationPlayer")
	
func enable_skill_choice_selector_sprite():
	get_skill_choice_nodes()
	skill_choice_selector_sprite.visible = true
	skill_choice_animation_player.play('blink')
	
func disable_skill_choice_selector_sprite():
	get_skill_choice_nodes()
	skill_choice_selector_sprite.visible = false
	skill_choice_animation_player.stop()
	
func change_choice(direction):
	if direction == 'up':
		if current_choice_selection > 0 :
			disable_skill_choice_selector_sprite()
			current_choice_selection -= 1
			enable_skill_choice_selector_sprite()
	elif direction == 'down':
		if current_choice_selection < active_number_of_choice_selections - 1:
			disable_skill_choice_selector_sprite()
			current_choice_selection += 1
			enable_skill_choice_selector_sprite()

func choose_skill():
	disable_skill_choice_selector_sprite()
	enable_skill_card_selector_sprite()
	
	print('name of skill :')
	print(choices_array[current_choice_selection].name)
	print(current_skill_info[active_party_member][current_skill_selection].name)
	#change the current_skills of the node of the player node
	
	var new_current_skills = current_skill_info[active_party_member].duplicate()
	new_current_skills.pop_at(current_skill_selection)
	new_current_skills.insert(current_skill_selection, choices_array[current_choice_selection]) #inserts at current_choice_selection
	current_skill_info[active_party_member] = new_current_skills
	if active_party_member == 0:
		get_node("../../../../Party/PC_Template").current_skills = new_current_skills
	else:
		get_node("../../../../Party/Party_PC_Template" + str(active_party_member)).current_skills = new_current_skills
		
	
	var new_skill_choices = choices_array.duplicate()
	new_skill_choices.pop_at(current_choice_selection)
	new_skill_choices.insert(current_choice_selection, current_skill_info[active_party_member][current_skill_selection])
	choices_array = new_skill_choices
	
	
	get_skills(active_party_member)
	
	set_choices()
