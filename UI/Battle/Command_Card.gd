extends Sprite

var isVisible = false
var isSelecting = false

#var current_open_cards = 0

func _ready():
	hide()

func open_commands_popup():
	if not isSelecting:
		if not isVisible:
			show()
			isVisible = true
		else:
			hide()
			isVisible = false
			isSelecting = true
			select_a_target()
		
func select_a_target():
	if isSelecting:
		get_tree().call_group("battle_group", "select_target")

func hasSelected():
	isSelecting = false
