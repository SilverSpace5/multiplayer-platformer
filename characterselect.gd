extends Node2D

var timer = 0

func _on_Play2_toggled(button_pressed):
	$Play2.text = "Picked"
	
func _process(delta):
	$Cursor.visible = Input.get_mouse_mode() == 1
	timer += delta
	$Play.rect_rotation = sin(timer*1.25) * 7
	$Play2.rect_rotation = sin(timer*1.25) * 7
	$Cursor.position = get_global_mouse_position()
