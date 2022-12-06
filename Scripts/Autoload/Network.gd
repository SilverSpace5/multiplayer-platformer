extends Node

# the client
var server = WebSocketClient.new()
# how the server identifies you
var id = ""
# whether you have connected
var connected = false
# Data that is sent to the server every frame of the game
var data = {}
# Everyone's data
var playerData = {}
# Whether you have found the server
var foundServer = false

# Sends data to server
func sendData(data):
	if foundServer:
		server.get_peer(1).put_packet(JSON.print(data).to_utf8())

func _ready():
	# Gets a unique id for networking
	id = global.getId(10)
	# Sets up functions for events in the client
	server.connect("data_received", self, "_onData")
	server.connect("connection_established", self, "_connected")
	server.connect("connection_closed", self, "_disconnected")
	server.connect("connection_error", self, "_disconnected")
	# Debug
	print("Connecting...")
	# Will retry connection
	while not connected:
		# Connects to server
		server.connect_to_url("wss://server-template.silverspace505.repl.co")
		yield(get_tree().create_timer(3), "timeout")
		# Reconnecting
		if not connected:
			print("Retrying")
			server.disconnect_from_host()
	
func _process(delta):
	# Allows for messages to go through the server and client
	server.poll()
	# Sets data for you, so that the rest of the code knows if your playing
	playerData[id] = data
	# Broadcasts data to everyong whos playing
	if connected:
		sendData({"broadcast": [{"data": [id, data]}, false]})

func _disconnected(wasClean):
	# Updating info vars
	connected = false
	foundServer = false
	# Debug
	print("Disconnected")
	if not wasClean:
		print("Reconnecting")
		# Reconnects
		while not connected:
			server.connect_to_url("wss://server-template.silverspace505.repl.co")
			yield(get_tree().create_timer(3), "timeout")
			if not connected:
				print("Retrying")
				server.disconnect_from_host()
	else:
		print("Timeout")
		get_tree().change_scene("res://Scenes/Timeout.tscn")
	
# Runs when found the server
func _connected(proto):
	print("Found Server")
	foundServer = true
	# Requests to the server to join (this detects the version of the game)
	sendData({"connected": [id, "multiplayer-platformer-v1"]})

func playerDisconnected(id):
	playerData.erase(id)
	if global.sceneName == "Menu" or global.sceneName == "Game":
		var players = global.scene.get_node("Players")
		if players.has_node(id):
			players.get_node(id).queue_free()
	print(id + " Disconnected :(")

func playerConnected(id):
	print(id + " Connected!")

func joinMenu(id):
	if global.sceneName == "Menu":
		var player2 = load("res://PlayerMenu.tscn").instance()
		global.scene.get_node("Players").add_child(player2)
		player2.id = id
		player2.name = id

func leaveMenu(id):
	if global.sceneName == "Menu":
		var players = global.scene.get_node("Players")
		if players.has_node(id):
			players.get_node(id).queue_free()

func leaveGame(id):
	if global.sceneName == "Game":
		var players = global.scene.get_node("Players")
		if players.has_node(id):
			players.get_node(id).queue_free()

func joinGame(id):
	if global.sceneName == "Game":
		var player2 = load("res://Player.tscn").instance()
		global.scene.get_node("Players").add_child(player2)
		player2.id = id
		player2.name = id

func success():
	print("Connected!")
	connected = true
	
func _onData():
	var data = JSON.parse(server.get_peer(1).get_packet().get_string_from_utf8()).result
	if data.has("important"):
		sendData({"recieved": data["important"]})
	if data.has("success"):
		if data["success"]:
			success()
	if data.has("data"):
		playerData[data["data"][0]] = data["data"][1]
	if data.has("playerDisconnected"):
		playerDisconnected(data["playerDisconnected"])
	if data.has("playerConnected"):
		playerConnected(data["playerConnected"])
	if data.has("playerData"):
		playerData = data["playerData"]
	if data.has("joinMenu"):
		joinMenu(data["joinMenu"])
	if data.has("leaveMenu"):
		leaveMenu(data["leaveMenu"])
	if data.has("joinGame"):
		joinGame(data["joinGame"])
	if data.has("leaveGame"):
		leaveGame(data["leaveGame"])
