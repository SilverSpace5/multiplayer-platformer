extends KinematicBody2D

export (float) var speed = 500
export (float) var gravity = 50
export (float) var jumpSpeed = 1000
var velocity = Vector2.ZERO
var anim = "Idle"
var id = ""
var jump = 0
var timer = 0
var lastPos = Vector2.ZERO
var diving = false
var move = Vector2.ZERO

func _process(delta):
	timer += delta
	var onFloor = false
	for body in $Area2D.get_overlapping_bodies():
		if body.name != name:
			onFloor = true
	if id == network.id:
		global.player = self
		$Player.texture = global.textures[global.saveData["character"]]
		$Username.text = global.saveData["username"]
		
		if Input.is_action_pressed("down"):
			diving = true
		
		if diving:
			if velocity.y < gravity:
				velocity.y = gravity
			gravity *= 2
		velocity.y += gravity
		velocity.x *= 0.5
		if diving:
			gravity /= 2
		
		if onFloor:
			diving = false
		
		if is_on_floor():
			velocity.y = 0
		if Input.is_action_just_pressed("jump") and onFloor:
			jump = 0
			velocity.y = -jumpSpeed
		if Input.is_action_pressed("jump") and jump < 6:
			jump += 1
			velocity.y += -jumpSpeed*jump
		if Input.is_action_pressed("left"):
			velocity.x -= speed
			$Player.scale.x = -4
		if Input.is_action_pressed("right"):
			velocity.x += speed
			$Player.scale.x = 4
		
		if is_on_ceiling():
			velocity.y = gravity
		
		anim = "Idle"
		if abs(velocity.x) > speed/10:
			anim = "Run"
		if not onFloor:
			anim = "Jump"
		if diving:
			anim = "Dive"
		$AnimationPlayer.play(anim)
		move = Vector2.ZERO
		var lastPos2 = position
		move_and_slide(velocity, Vector2.UP)
		move = position-lastPos2
	else:
		if network.playerData.has(id):
			if network.playerData[id].has("pos"):
				var pos = Vector2(network.playerData[id]["pos"][0], network.playerData[id]["pos"][1])
				var vel = Vector2(network.playerData[id]["velocity"][0], network.playerData[id]["velocity"][1])
				$Player.texture = global.textures[network.playerData[id]["character"]]
				$Username.text = network.playerData[id]["username"]
				if lastPos != pos:
					$Tween.interpolate_property(self, "position", position, pos, 0.1)
					$Tween.start()
					lastPos = pos
					velocity = vel
				$Player.scale.x = network.playerData[id]["scale"]
				if $Tween.is_active():
					$AnimationPlayer.play(network.playerData[id]["anim"])
					velocity = vel
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

func _on_sendData_timeout():
	if network.id == id:
		network.data["pos"] = [position.x, position.y]
		network.data["anim"] = anim
		network.data["scale"] = $Player.scale.x
		network.data["velocity"] = [move.x, move.y]
		network.data["character"] = global.saveData["character"]
		network.data["username"] = global.saveData["username"]
