extends Control

var isCurrentlyInteracting = false
var isDialogueFinished = false



func print_dialogue(body):
	if isCurrentlyInteracting == false and isDialogueFinished == false:
		isCurrentlyInteracting = true
		if body == "NPC_Template":
			$Popup_Dialogue/Frame/Sprite.frame = 12 #portrait image
			$Popup_Dialogue/BG/Text.text = """I have blue hair.
			Ever heard of it?
			It is unnatural."""
			$Popup_Dialogue.popup_centered()
			$Popup_Dialogue/AnimationPlayer.play("scrolling_text")
		if body == 'NPC_Template_2':
			$Popup_Dialogue/Frame/Sprite.frame = 8
			$Popup_Dialogue/BG/Text.text = """I have purple hair.
			With it, I intimidate the masses. They think I know eldritch magic."""
			$Popup_Dialogue.popup_centered()
			$Popup_Dialogue/AnimationPlayer.play("scrolling_text")
		yield($Popup_Dialogue/AnimationPlayer, "animation_finished")
		isCurrentlyInteracting = false
		isDialogueFinished = true
	elif isCurrentlyInteracting == true and isDialogueFinished == false: #allow closing during dialogue
		isCurrentlyInteracting = false
		hide_dialogue()
	elif isDialogueFinished == true:
		isDialogueFinished = false
		isCurrentlyInteracting = false
		hide_dialogue()

func hide_dialogue():
	$Popup_Dialogue.hide()
	$Popup_Dialogue/AnimationPlayer.stop()
	$Popup_Dialogue/BG/Text.percent_visible = 0
	$Popup_Dialogue/BG/Text.text = ''
