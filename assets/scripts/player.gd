extends CharacterBody3D

@export var speed = 7.0
@export var jump_velocity = 6.0
@export var flip_speed = 15.0 

@onready var sprite = $Sprite3D
@onready var interaction_area = $Interactions

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	#Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		#Movement
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		#Paper Flip
		if input_dir.x > 0:
			sprite.scale.x = lerp(sprite.scale.x, 1.0, delta * flip_speed)
		elif input_dir.x < 0:
			sprite.scale.x = lerp(sprite.scale.x, -1.0, delta * flip_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _input(event):
	if event.is_action_pressed("interact"):
		check_for_npcs()

func check_for_npcs():
	var overlapping_areas = interaction_area.get_overlapping_areas()
	for area in overlapping_areas:
		var parent = area.get_parent()
		if parent.is_in_group("npcs"):
			parent.talk()
			return
