extends KinematicBody2D

export (float) var speed = 500
export (float) var gravity = 50
export (float) var jumpSpeed = 1000
var velocity = Vector2.ZERO
var anim = "Idle"
var moveTimer = 0
var id = ""

func _process(delta):
	if id == network.id:
		moveTimer -= delta
		var target = get_global_mouse_position()
		var dis = target.distance_to(position)
		
		var onFloor = false
		for body in $Area2D.get_overlapping_bodies():
			if body.name != name:
				onFloor = true
		
		velocity.y += gravity
		velocity.x *= 0.9
		if is_on_ceiling():
			velocity.y = gravity
		if is_on_floor():
			velocity.y = 0
			if dis < 300:
				if position.y > target.y: #rand_range(0, 100) < 1:
					velocity.y = -jumpSpeed
					global.jumps += 1
			else:
				if rand_range(0, 100) < 1:
					global.jumps += 1
					velocity.y = -jumpSpeed
		if moveTimer <= 0:
			if dis < 300:
				moveTimer = rand_range(0.025, 0.2)
			else:
				moveTimer = rand_range(0.1, 0.25)
			var move = 0
			if position.x < target.x:
				move = 1
			if position.x > target.x:
				move = -1
			if dis >= 300:
				move = 0
			if move > 0 or rand_range(0, 100) < 25:
				velocity.x += speed
				$Player.scale.x = 4
			if move < 0 or rand_range(0, 100) < 25:
				velocity.x -= speed
				$Player.scale.x = -4
		
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
	else:
		if network.playerData.has(id):
			if network.playerData[id].has("pos"):
				$AnimationPlayer.play(network.playerData[id]["anim"])
				$Tween.interpolate_property(self, "position", position, Vector2(network.playerData[id]["pos"][0], network.playerData[id]["pos"][1]), 0.1)
				$Tween.start()
				$Player.scale.x = network.playerData[id]["scale"]
