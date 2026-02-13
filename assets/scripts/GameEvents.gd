extends Node

var total_money: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_money(amount: int):
	total_money += amount
	money_changed.emit(total_money)

signal request_dialogue(message: Array)
signal dialogue_finished
signal money_changed(new_amount: int)
