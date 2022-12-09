extends Sprite

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	update2()
	
func update2():
	visible = Input.get_mouse_mode() == 1
	global_position = get_global_mouse_position()
