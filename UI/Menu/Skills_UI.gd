extends Control

onready var skill_card_1 = $Popup_Skills/Frame/PC1/Sprite/Skill_Card
onready var skill_card_2 = $Popup_Skills/Frame/PC2/Sprite/Skill_Card
onready var skill_card_3 = $Popup_Skills/Frame/PC3/Sprite/Skill_Card
onready var skill_card_4 = $Popup_Skills/Frame/PC4/Sprite/Skill_Card
onready var skill_cards = [skill_card_1, skill_card_2, skill_card_3, skill_card_4]

onready var main = get_node("../../../..").name

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
onready var active_number_of_skill_selections = number_of_skills[active_party_member]
var skill_card_selector_sprite
var skill_card_animation_player

func _ready():
	for i in 4:
		get_skills(i)
	enable_skill_card_selector_sprite()

func _input(event):
	if event.is_action_pressed("up"):
		change_skill("up")
	if event.is_action_pressed("down"):
		change_skill("down")	


func get_skills(party_member):
	var skills_text = [skill_cards[party_member].get_node("TextureRect/Skill1"), skill_cards[party_member].get_node("TextureRect/Skill2"), skill_cards[party_member].get_node("TextureRect/Skill3"), skill_cards[party_member].get_node("TextureRect/Skill4"), skill_cards[party_member].get_node("TextureRect/Skill5")]
	for i in 5:
		skills_text[i].bbcode_text = ''
	var number_of_skill_selections = number_of_skills[party_member]
	for i in number_of_skill_selections: #update names of skills
		skills_text[i].bbcode_text = skill_info[party_member][i].name
		


# straight from battlefield_template
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
			active_skill_card = skill_cards[active_party_member]
			active_number_of_skill_selections = number_of_skills[active_party_member]
			current_skill_selection = 0
			enable_skill_card_selector_sprite()
