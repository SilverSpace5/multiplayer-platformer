extends Control

var timer = 0

func _ready():
	global.sceneName = "Timeout"

func _process(delta):
	timer += delta
	$Title.rect_position.x = 387 + sin(timer*2) * 10

func _on_Reconnect_pressed():
	get_tree().change_scene("res://Scenes/Loading.tscn")
