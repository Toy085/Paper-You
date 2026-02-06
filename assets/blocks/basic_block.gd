extends StaticBody3D

func on_hammer_hit():
	print("I got hit by the hammer!")
	
	# Paper Mario Juice: Make the block bounce up and down
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y + 0.5, 0.1) # Up
	tween.tween_property(self, "position:y", position.y, 0.1)     # Down
