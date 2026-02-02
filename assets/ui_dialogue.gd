extends Control

@onready var text_label = $Dialogue/RichTextLabel
@onready var panel = $Dialogue

var dialogue_queue: Array[String]
var is_typing: bool = false
var current_tween: Tween

func _ready():
	panel.hide() # Hide UI at start
	GameEvents.request_dialogue.connect(start_dialogue)
	
func start_dialogue(lines: Array[String]):
	dialogue_queue = lines.duplicate()
	show_next_line()

func show_next_line():
	if dialogue_queue.is_empty():
		finish_dialogue()
		return

	var current_text = dialogue_queue.pop_front()
	text_label.text = current_text
	panel.show()
	text_label.visible_ratio = 0.0
	is_typing = true
	
	if current_tween:
		current_tween.kill()
	
	current_tween = create_tween()
	current_tween.tween_property(text_label, "visible_ratio", 1.0, current_text.length() * 0.02)
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
			show_next_line()
			
func finish_dialogue():
	panel.hide()
	# Wait a frame to prevent re-triggering the NPC
	await get_tree().process_frame 
	GameEvents.dialogue_finished.emit()
