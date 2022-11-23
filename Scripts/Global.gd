extends Node

var letters = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
var jumps = 0
var scene:Node = null
var sceneName = "Menu"

func _ready():
	scene = get_tree().get_root().get_node(sceneName)

func _process(delta):
	scene = get_tree().get_root().get_node(sceneName)
	network.data["scene"] = sceneName
	if Input.is_mouse_button_pressed(1):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func getId(digits:int):
	var id = ""
	for i in range(digits):
		randomize()
		id += letters[round(rand_range(0, len(letters)-1))]
	return id
