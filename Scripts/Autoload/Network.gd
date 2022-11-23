extends Node

var server = WebSocketClient.new()
var id = ""
var connected = false
var data = {}
var playerData = {}
var foundServer = false

func sendData(data):
	if foundServer:
		server.get_peer(1).put_packet(JSON.print(data).to_utf8())

func _ready():
	id = global.getId(10)
	server.connect("data_received", self, "_onData")
	server.connect("connection_established", self, "_connected")
	server.connect("connection_closed", self, "_disconnected")
	server.connect("connection_error", self, "_disconnected")
	print("Connecting...")
	while not connected:
		server.connect_to_url("wss://server-template.silverspace505.repl.co")
		yield(get_tree().create_timer(3), "timeout")
		if not connected:
			print("Retrying")
			server.disconnect_from_host()
	
func _process(delta):
	server.poll()
	data["jumps"] = global.jumps
	if connected:
		playerData[id] = data
		sendData({"broadcast": [{"data": [id, data]}, false]})
	#client.get_peer(1).put_packet()

func _disconnected(wasClean):
	connected = false
	foundServer = false
	print("Disconnected, reconnecting")
	while not connected:
		server.connect_to_url("wss://server-template.silverspace505.repl.co")
		yield(get_tree().create_timer(3), "timeout")
		if not connected:
			print("Retrying")
			server.disconnect_from_host()
	

func _connected(proto):
	print("Found Server")
	foundServer = true
	sendData({"connected": [id, "oiesnfoi"]})

func playerDisconnected(id):
	playerData.erase(id)
	if global.sceneName == "Menu":
		var players = global.scene.get_node("Players")
		if players.has_node(id):
			players.get_node(id).queue_free()
	print(id + " Disconnected :(")

func playerConnected(id):
	print(id + " Connected!")
	if global.sceneName == "Menu":
		var player2 = load("res://PlayerMenu.tscn").instance()
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
