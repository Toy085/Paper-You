extends Area3D

var value = 1

@onready var coinModell = $coinModell

func _ready():
	# Spin animation
	var spin_tween = create_tween().set_loops()
	spin_tween.tween_property(coinModell, "rotation:y", deg_to_rad(360), 1.5).from(0)

	# Hover animation
	var hover_tween = create_tween().set_loops()
	hover_tween.tween_property(coinModell, "position:y", 0.3, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	hover_tween.tween_property(coinModell, "position:y", 0.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		GameEvents.add_money(value)
		# Add a sound or particle effect here!
		queue_free() # Delete the coin
