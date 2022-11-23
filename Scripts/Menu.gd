extends Control

var timer = 0

func _process(delta):
	$Cursor.visible = Input.get_mouse_mode() == 1
	timer += delta
	$Title.rect_position.x = 252 + sin(timer*2) * 10
	$Play.rect_rotation = sin(timer*1.25) * 10
	$Cursor.position = get_global_mouse_position()
	
func _ready():
	while not network.connected:
		yield(get_tree().create_timer(0), "timeout")
	yield(get_tree().create_timer(0.5), "timeout")
	for player in network.playerData:
		var player2 = load("res://PlayerMenu.tscn").instance()
		$Players.add_child(player2)
		player2.id = player
		player2.name = player

func _on_Play_pressed():
	get_tree().change_scene("res://characterselect.tscn")
	$Play.text = "Loading..."
	
