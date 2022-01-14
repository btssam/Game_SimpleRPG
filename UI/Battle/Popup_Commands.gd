extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().position = self.position
#	print(get_parent().position)


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	 get_parent().position = self.position

func open_commands_popup():
	print('open command popup2')
	popup()
