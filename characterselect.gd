extends Node2D

var timer = 0

func _ready():
	global.sceneName = "Character Select"
	
func _process(delta):
	timer += delta
	$Play.rect_rotation = sin(timer*1.25) * 7
	$Pick.rect_rotation = sin(timer*1.25) * 7

func _on_Play_pressed():
	$Play.text = "HI"
