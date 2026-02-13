extends StaticBody3D

@export_multiline var dialogue_lines: Array[String] = [
	"Hello there!",
	"And Hello World",
	"I'm an NPC"
]

func talk():
	GameEvents.request_dialogue.emit(dialogue_lines)
