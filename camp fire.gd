extends Node2D

func _ready():
	$CampFire.visible = false
	$Light2D.visible = false

func _on_Button_pressed():
	for body in $Area2D.get_overlapping_bodies():
		if body.name == network.id:
			$CampFire.visible = true
			$Light2D.visible = true





func _on_Area2D2_mouse_entered():
	if $CampFire.visible != true:
		$CampFireOff.visible = true
		$CampFireOff2.visible = false
	else:
		$CampFireOff2.visible = true
		$CampFireOff.visible = false
