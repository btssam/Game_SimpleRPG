extends Control

func _ready():
	pass

func print_dialogue(body):
	if body == "NPC_Template":
		$Popup_Dialogue/Frame/Sprite.frame = 12
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
	
func hide_dialogue():
	$Popup_Dialogue.hide()
	$Popup_Dialogue/AnimationPlayer.stop()
	$Popup_Dialogue/BG/Text.percent_visible = 0
	$Popup_Dialogue/BG/Text.text = ''
