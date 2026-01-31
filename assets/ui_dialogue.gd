extends Control

@onready var text_label = $Dialogue/RichTextLabel
@onready var panel = $Dialogue

func _ready():
	panel.hide() # Hide UI at start
	GameEvents.request_dialogue.connect(show_dialogue)

func show_dialogue(content: String):
	text_label.text = content
	panel.show()
	
	# Close the box after X seconds
	await get_tree().create_timer(3.0).timeout
	panel.hide()
