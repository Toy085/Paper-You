extends CanvasLayer

func _ready():
	hide() # Start hidden

func _input(event):
	if event.is_action_pressed("ui_cancel"): # Usually Esc
		toggle_pause()

func toggle_pause():
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	
	if new_pause_state:
		show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		hide()
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_resume_pressed():
	toggle_pause()

func _on_quit_pressed():
	get_tree().quit()
