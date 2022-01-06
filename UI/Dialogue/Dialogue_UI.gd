extends Control

func print_dialogue(body):
	if body == "NPC_Template":
		print('i have blue hair')
		$Popup_Dialogue.popup_centered()
	if body == 'NPC_Template_2':
		print('i have purple hair')
		$Popup_Dialogue.popup_centered()
	
func hide_dialogue():
	$Popup_Dialogue.hide()
