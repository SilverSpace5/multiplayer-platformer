extends Control

var timer = 0

func _ready():
	if global.saveData["setup"]:
		get_tree().change_scene("res://Scenes/Menu.tscn")
		
	global.sceneName = "Setup"
	# Loads the username
	$Username.text = global.saveData["username"]
	$Player.texture = global.textures[global.saveData["character"]]

func _process(delta):
	timer += delta
	$Title.rect_position.x = 252 + sin(timer*2) * 10
	global.saveData["username"] = $Username.text
	$Player.texture = global.textures[global.saveData["character"]]

func _on_Right_pressed():
	global.saveData["character"] += 1
	if global.saveData["character"] >= len(global.textures):
		global.saveData["character"] = 0

func _on_Left_pressed():
	global.saveData["character"] -= 1
	if global.saveData["character"] < 0:
		global.saveData["character"] = len(global.textures)-1

func _on_Continue_pressed():
	global.saveData["setup"] = true
	network.sendData({"broadcast": [{"joinMenu": network.id}, true]})
	get_tree().change_scene("res://Scenes/Menu.tscn")
