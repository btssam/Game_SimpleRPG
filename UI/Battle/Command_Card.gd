extends Sprite

var isVisible = false

func _ready():
	hide()

func open_commands_popup():
	if not isVisible:
		show()
	else:
		hide()
