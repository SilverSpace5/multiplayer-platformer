extends Node

var letters = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
var scene:Node = null
var sceneName = "Loading"
var saveData = {}
var lastData = {}
var defaultData = {
	"username": "Unnamed",
	"character": 0,
	"setup": false
}
var player = null
var textures = []
# 0 = Blue Guy, 1 = Tim

func _ready():
	for character in ["blue-guy2", "tim", "Phil"]:
		textures.append(load("res://Assets/Players/" + character + ".png"))
	
	# Gets the current scene
	scene = get_tree().get_root().get_node(sceneName)
	
	# Loads the data
	saveData = SaveLoad.loadData("team-sowflux-multiplayer-platformer.data")
	lastData = saveData.duplicate(true)
	for key in defaultData:
		if not saveData.has(key):
			saveData[key] = defaultData[key]
	for key in saveData:
		if not defaultData.has(key):
			saveData.erase(key)

func _process(delta):
	# Updates save data if needed
	if saveData != lastData:
		lastData = saveData.duplicate(true)
		SaveLoad.saveData("team-sowflux-multiplayer-platformer.data", saveData)
	
	# Gets the current scene
	scene = get_tree().get_root().get_node(sceneName)
	# Sends the current scene to everyone whos playing
	network.data["scene"] = sceneName
	# Locks and unlocks the cursor
	if Input.is_mouse_button_pressed(1):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Gets a random ID
func getId(digits:int):
	var id = ""
	for i in range(digits):
		randomize()
		id += letters[round(rand_range(0, len(letters)-1))]
	return id
