extends StaticBody3D

var value = 1.0

func on_hammer_hit():
	
	# Paper Mario Juice: Make the block bounce up and down
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y + 0.5, 0.05) # Up
	tween.tween_property(self, "position:y", position.y, 0.1)     # Down
	GameEvents.add_money(value)
