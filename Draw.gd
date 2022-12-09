extends Node2D
tool

export var cameraX = 0
export var cameraY = 0
export var cameraZ = 0
var lines = []
export var update3d = false

func go3d(x, y, z):
	return Vector2((x-cameraX) * ((z-cameraZ)/100+1), (y-cameraY) * ((z-cameraZ)/100+1))

func _process(delta):
	lines = []
	lines.append([go3d(0, 0, 0), go3d(50, 0, 0)])
	lines.append([go3d(50, 0, 0), go3d(50, 50, 0)])
	if update3d:
		update()

func _draw():
	for line in lines:
		draw_line(line[0], line[1], Color(1, 1, 1), 2)
