extends Node2D

var timer = 0


func _on_Play2_toggled(button_pressed):
	$Play2.text = "Picked"
	get_tree().change_scene("res://Scenes/game.tscn")

func _on_Play3_toggled(button_pressed):
	$Play3.text = "Picked"
	get_tree().change_scene("res://Scenes/game.tscn")

func _on_Play4_toggled(button_pressed):
	$Play4.text = "Picked"
	get_tree().change_scene("res://Scenes/game.tscn")

func _on_Play5_toggled(button_pressed):
	$Play5.text = "Picked"
	get_tree().change_scene("res://Scenes/game.tscn")

func _process(delta):
	$Cursor.visible = Input.get_mouse_mode() == 1
	timer += delta
	$Play.rect_rotation = sin(timer*1.25) * 7
	$Play2.rect_rotation = sin(timer*1.25) * 7
	$Play3.rect_rotation = sin(timer*1.25) * 7
	$Play4.rect_rotation = sin(timer*1.25) * 7
	$Play5.rect_rotation = sin(timer*1.25) * 7
	$Cursor.position = get_global_mouse_position()
