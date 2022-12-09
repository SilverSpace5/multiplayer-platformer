extends Node2D

func _on_Button_pressed():
	for body in $PlayerDetect.get_overlapping_bodies():
		if body.name == network.id:
			$AnimationPlayer.play("on")
	
func _process(delta):
	$Outline.visible = false
	if $AnimationPlayer.current_animation != "on":
		for body in $PlayerDetect.get_overlapping_bodies():
			if body.name == network.id:
				$Outline.visible = true
