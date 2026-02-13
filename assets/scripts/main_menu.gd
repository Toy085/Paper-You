extends Control

# Drag your first level scene here in the inspector
@export var start_level: PackedScene 

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = false

func _on_start_button_pressed():
	if start_level:
		get_tree().change_scene_to_packed(start_level)
	else:
		print("No start level assigned!")

func _on_quit_button_pressed():
	get_tree().quit()
