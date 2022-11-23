extends Sprite

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	visible = Input.get_mouse_mode() == 1
	position = get_global_mouse_position()
