extends Node2D

var timer = 0

func _ready():
	global.sceneName = "Character Select"
	$Play.disabled = true
	
func _process(delta):
	timer += delta
	$Play.rect_rotation = sin(timer*1.25) * 7
	$Pick.rect_rotation = sin(timer*1.25) * 7

func _on_Play_pressed():
	$Play.text = "Loading..."
	$Play.disabled = true
	get_tree().change_scene("res://Scenes/game.tscn")

func _on_Pick_pressed():
	$Pick.text = "Picked"
	$Pick.disabled = true
	$Play.disabled = false
