extends StaticBody3D

@export_multiline var dialogue_text: String = "Hello World!"

func talk():
	print("NPC says: ", dialogue_text)
	GameEvents.request_dialogue.emit(dialogue_text)
