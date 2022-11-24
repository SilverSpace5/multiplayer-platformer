extends Node2D

func _ready():
	$CampFire.visible = false

func _on_Button_pressed():
	for body in $Area2D.get_overlapping_bodies():
		if body.name == network.id:
			$CampFire.visible = true



