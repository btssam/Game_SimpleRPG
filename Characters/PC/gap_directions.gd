extends Node2D





func _on_Timer_For_Test_timeout():
	get_node("../../..").test_gap_direction()


func _on_Timer_For_Load_timeout():
	get_node("../../..").to_battle_from_overworld()
