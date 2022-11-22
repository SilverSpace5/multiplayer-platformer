extends Node

var server = WebSocketClient.new()
var id = ""
var connected = false
var data = {}
var playerData = {}

func sendData(data):
	server.get_peer(1).put_packet(JSON.print(data).to_utf8())

func _ready():
	id = global.getId(10)
	print("Connecting...")
	while not connected:
		server.connect_to_url("wss://server-template.silverspace505.repl.co")
		server.connect("data_received", self, "_onData")
		server.connect("connection_established", self, "_connected")
		yield(get_tree().create_timer(3), "timeout")
		if not connected:
			print("Retrying")
			server.disconnect_from_host()
	
	
func _process(delta):
	server.poll()
	data["jumps"] = global.jumps
	if connected:
		playerData[id] = data
		sendData({"broadcast": ["data", [id, data]]})
	#client.get_peer(1).put_packet()

func _connected(proto):
	print("Found Server")
	sendData({"connected": [id, "oiesnfoi"]})

func playerDisconnected(id):
	playerData.erase(id)
	print(id + " Disconnected :(")

func playerConnected(id):
	print(id + " Connected!")

func success():
	print("Connected!")
	connected = true
	
func _onData():
	var data = JSON.parse(server.get_peer(1).get_packet().get_string_from_utf8()).result
	if data.has("success"):
		if data["success"]:
			success()
	if data.has("data"):
		playerData[data["data"][0]] = data["data"][1]
	if data.has("playerDisconnected"):
		playerDisconnected(data["playerDisconnected"])
	if data.has("playerConnected"):
		playerConnected(data["playerConnected"])
