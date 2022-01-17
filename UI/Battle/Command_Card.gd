extends Sprite

var isVisible = false
var isSelecting = false

func _ready():
	hide()

func open_commands_popup():
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
		print('select a target')
