extends Control


func _ready():
	pass




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
