extends Control

@onready var coin_label = $coinText

func _ready():
	GameEvents.money_changed.connect(_update_coin_ui)
	_update_coin_ui(GameEvents.total_money)

func _update_coin_ui(amount: int):
	coin_label.text = "Coins: [wave amp=50.0]" + str(amount) + "[/wave]"
	
	# Coin text pop animation
	var tween = create_tween()
	tween.tween_property(coin_label, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(coin_label, "scale", Vector2(1.0, 1.0), 0.2)
