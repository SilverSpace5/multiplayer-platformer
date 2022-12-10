extends Node2D

var timer = 0

func _ready():
	for tilePos in $Detail.get_used_cells_by_id(17):
		$Detail.set_cellv(tilePos, -1)
		var water = load("res://Water.tscn").instance()
		water.position = tilePos*32+Vector2(16, 16)
		$Water.add_child(water)
	global.sceneName = "Game"
	yield(get_tree().create_timer(0.1), "timeout")
	for player in network.playerData:
		if network.playerData[player].has("scene"):
			if network.playerData[player]["scene"] == "Game":
				var player2 = load("res://Player.tscn").instance()
				$Players.add_child(player2)
				player2.position = Vector2(100, 125)
				player2.id = player
				player2.name = player

func _process(delta):
	if global.player:
		Cursor.position += (global.player.position-$Camera2D.position)/5
		$Camera2D.position += (global.player.position-$Camera2D.position)/5
	timer += delta
	if timer < 0.5:
		return
	var names = []
	for player in $Players.get_children():
		names.append(player.name)
	for player in network.playerData:
		if not player in names:
			if network.playerData[player].has("scene"):
				if network.playerData[player]["scene"] == "Game":
					var player2 = load("res://Player.tscn").instance()
					$Players.add_child(player2)
					player2.position = Vector2(100, 125)
					player2.id = player
					player2.name = player
		else:
			if network.playerData[player].has("scene"):
				if network.playerData[player]["scene"] != "Game":
					print(network.playerData[player]["scene"])
					$Players.get_node(player).queue_free()

func _on_Menu_pressed():
	global.player = null
	network.sendData({"broadcast": [{"leaveGame": network.id, "joinMenu": network.id}, true]})
	$Camera2D/Menu.text = "Loading..."
	get_tree().change_scene("res://Scenes/Menu.tscn")
