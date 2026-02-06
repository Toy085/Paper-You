extends Area3D

var value = 1

@onready var coinModell = $coinModell

func _ready():
	# Spin animation
	var tween = create_tween().set_loops()
	tween.tween_property(coinModell, "rotation:y", deg_to_rad(360), 1.5).from(0)

	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("Coin touched by: ", body.name)
	if body.is_in_group("player"):
		GameEvents.add_money(value)
		# Add a sound or particle effect here!
		queue_free() # Delete the coin
