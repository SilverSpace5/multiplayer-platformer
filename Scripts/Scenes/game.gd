extends Node2D

func _ready():
	global.sceneName = "Game"
	yield(get_tree().create_timer(0.1), "timeout")
	for player in network.playerData:
		if network.playerData[player]["scene"] == "Game":
			var player2 = load("res://Player.tscn").instance()
			$Players.add_child(player2)
			player2.position = Vector2(100, 125)
			player2.id = player
			player2.name = player

func _process(delta):
	if global.player:
		$Camera2D.position += (global.player.position-$Camera2D.position)/5
