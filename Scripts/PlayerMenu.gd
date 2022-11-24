extends KinematicBody2D

export (float) var speed = 500
export (float) var gravity = 50
export (float) var jumpSpeed = 1000
var velocity = Vector2.ZERO
var anim = "Idle"
var moveTimer = 0
var id = ""
var timer = 0
var lastPos = Vector2(0, 0)

func _process(delta):
	timer += delta
	var onFloor = false
	for body in $Area2D.get_overlapping_bodies():
		if body.name != name:
			onFloor = true
	if id == network.id:
		$Player.texture = global.textures[global.saveData["character"]]
		$Username.text = global.saveData["username"]
		moveTimer -= delta
		var target = get_global_mouse_position()
		var dis = target.distance_to(position)
		var disX = abs(target.x-position.x)
		
		velocity.y += gravity
		velocity.x *= 0.9
		if is_on_ceiling():
			velocity.y = gravity
		if is_on_floor():
			velocity.y = 0
			if dis < 200:
				if position.y > target.y: #rand_range(0, 100) < 1:
					velocity.y = -jumpSpeed
			else:
				if rand_range(0, 100) < 1:
					velocity.y = -jumpSpeed
		if moveTimer <= 0:
			if dis < 200 and disX > 20:
				moveTimer = 0
				speed /= 10
			else:
				moveTimer = rand_range(0.1, 0.25)
			var move = 0
			if position.x < target.x:
				move = 1
			if position.x > target.x:
				move = -1
			if dis >= 200:
				move = 0
				if move > 0 or rand_range(0, 100) < 25:
					velocity.x += speed
					$Player.scale.x = 4
				if move < 0 or rand_range(0, 100) < 25:
					velocity.x -= speed
					$Player.scale.x = -4
			elif disX > 20:
				if move > 0:
					velocity.x += speed
					$Player.scale.x = 4
				if move < 0:
					velocity.x -= speed
					$Player.scale.x = -4
					
			if dis < 200 and disX > 20:
				speed *= 10
		
		anim = "Idle"
		if abs(velocity.x) > speed/10:
			anim = "Run"
		if not onFloor:
			anim = "Jump"
		$AnimationPlayer.play(anim)
		move_and_slide(velocity, Vector2.UP)
		network.data["pos"] = [position.x, position.y]
		network.data["anim"] = anim
		network.data["scale"] = $Player.scale.x
		network.data["velocity"] = [velocity.x, velocity.y]
		network.data["character"] = global.saveData["character"]
		network.data["username"] = global.saveData["username"]
	else:
		if network.playerData.has(id):
			if network.playerData[id].has("pos"):
				collision_layer = 2
				collision_mask = 2
				$Player.texture = global.textures[network.playerData[id]["character"]]
				$Username.text = network.playerData[id]["username"]
				if lastPos != Vector2(network.playerData[id]["pos"][0], network.playerData[id]["pos"][1]):
					$Tween.interpolate_property(self, "position", position, Vector2(network.playerData[id]["pos"][0], network.playerData[id]["pos"][1]), 0.1)
					$Tween.start()
					lastPos = Vector2(network.playerData[id]["pos"][0], network.playerData[id]["pos"][1])
				$Player.scale.x = network.playerData[id]["scale"]
				if $Tween.is_active():
					$AnimationPlayer.play(network.playerData[id]["anim"])
					velocity = Vector2(network.playerData[id]["velocity"][0], network.playerData[id]["velocity"][1])
			if not $Tween.is_active():
				anim = "Idle"
				if abs(velocity.x) > speed/10:
					anim = "Run"
				if not onFloor:
					anim = "Jump"
				$AnimationPlayer.play(anim)
				move_and_slide(velocity, Vector2.UP)
				velocity.y += gravity
				velocity.x *= 0.9
		else:
			if timer > 1:
				queue_free()
