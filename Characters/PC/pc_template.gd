extends "res://Characters/PC/Overworld/Scripts/pc_check_for_battle.gd"
#also extends:
# pc_interaction.gd
# pc_momvement.gd

###combat stats
export var hp = 5
export var maxhp = 5



func _ready():
	pass
func _physics_process(delta):
	pass
func _input(event):
	pass
func _process(delta):
	pass


#Battling code
func battle_loop():
	pass

func check_for_death():
	if hp <= 0:
		hp = 0
		get_tree().call_group("battle_group", "update_log", "I dead")
		$Sprite.hide()
		$Sprite_Battle.show()
		$AnimationPlayer.stop()
		$AnimationPlayer.call_deferred("play", "dying")
#		$AnimationPlayer.play("dying")


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == 'dying':
		print('animation_started')


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'dying':
		print('animation_stopped')
