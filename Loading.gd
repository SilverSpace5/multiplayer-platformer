
extends Node2D

func _ready():
	global.sceneName = "Loading"
	while not network.connected:
		yield(get_tree().create_timer(0), "timeout")
	yield(get_tree().create_timer(0.5), "timeout")
	network._disconnected(false)
	get_tree().change_scene("res://Scenes/Setup.tscn")
