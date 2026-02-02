extends Control

@onready var text_label = $Dialogue/RichTextLabel
@onready var panel = $Dialogue

var is_typing: bool = false
var current_tween: Tween

func _ready():
	panel.hide() # Hide UI at start
	GameEvents.request_dialogue.connect(show_dialogue)

func show_dialogue(content: String):
	text_label.text = content
	panel.show()
	text_label.visible_ratio = 0.0
	is_typing = true
	
	if current_tween:
		current_tween.kill()
	
	current_tween = create_tween()
	# Calculate speed based on text length
	var duration = content.length() * 0.03
	
	current_tween.tween_property(text_label, "visible_ratio", 1.0, duration)
	current_tween.finished.connect(_on_typing_finished)

func _on_typing_finished():
	is_typing = false

func _unhandled_input(event):
	if event.is_action_pressed("interact") and panel.visible:
		if is_typing:
			if current_tween:
				current_tween.kill()
			text_label.visible_ratio = 1.0
			is_typing = false
		else:
			# Hide the box
			panel.hide()
			await get_tree().process_frame
			GameEvents.dialogue_finished.emit()
