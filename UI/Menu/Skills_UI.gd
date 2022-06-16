extends Control

onready var skill_card_1 = $Popup_Skills/Frame/PC1/Sprite/Skill_Card
onready var skill_card_2 = $Popup_Skills/Frame/PC2/Sprite/Skill_Card
onready var skill_card_3 = $Popup_Skills/Frame/PC3/Sprite/Skill_Card
onready var skill_card_4 = $Popup_Skills/Frame/PC4/Sprite/Skill_Card
onready var skill_card = [skill_card_1, skill_card_2, skill_card_3, skill_card_4]

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

func _ready():
	print( str(skill_card) + str(skill_info) + str(number_of_skills))
#	print(main)

func get_skills():
	pass

#func enable_card_selector_sprite():
#	get_card_nodes()
#	card_selector_sprite.visible = true
#	card_animation_player.play('blink')


# straight from battlefield_template
#func get_skills(party_member):
#	var skills_text = [skill_cards[party_member - 1].get_node("TextureRect/Skill1"), skill_cards[party_member - 1].get_node("TextureRect/Skill2"), skill_cards[party_member - 1].get_node("TextureRect/Skill3"), skill_cards[party_member - 1].get_node("TextureRect/Skill4"), skill_cards[party_member - 1].get_node("TextureRect/Skill5")]
#	for i in 5:
#		skills_text[i].bbcode_text = ''
#	number_of_skill_selections = players[party_member - 1].number_of_skills
#	for i in number_of_skill_selections: #update names of skills
#		if has_enough_mp(i):
#			skills_text[i].bbcode_text = players[party_member - 1].skills[i].name
#		else:
#			skills_text[i].bbcode_text = '[color=#A9A9A9]' + players[party_member - 1].skills[i].name + '[/color]'
