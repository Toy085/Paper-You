extends CharacterBody3D

@export var speed = 7.0
@export var jump_velocity = 6.0
@export var flip_speed = 15.0

@onready var sprite = $PlayerSprite
@onready var interaction_area = $Interactions
@onready var anim_player = $AnimationPlayer
@onready var hammer_area = $HammerSprite/HammerArea
@onready var camera = get_viewport().get_camera_3d()

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var in_dialogue = false
var default_rotation_x: float
var is_hammering = false

func _ready():
	GameEvents.dialogue_finished.connect(_on_dialogue_finished)
	default_rotation_x = camera.rotation.x
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

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
	
	if not is_on_floor():
		sprite.scale.y = lerp(sprite.scale.y, 0.75, delta * 6)
	elif is_on_floor():
		sprite.scale.y = lerp(sprite.scale.y, 1.0, delta * 6)

	var target_fov = 50.0 if in_dialogue else 75.0
	var target_angle = (default_rotation_x + deg_to_rad(15)) if in_dialogue else default_rotation_x
	camera.fov = lerp(camera.fov, target_fov, delta * 5.0)
	camera.rotation.x = lerp_angle(camera.rotation.x, target_angle, delta * 5.0)
	
	if not in_dialogue && not is_hammering:
		move_and_slide()

func _input(event):
	if event.is_action_pressed("interact") && not in_dialogue && is_on_floor():
		if check_for_npcs():
			return
		elif not in_dialogue:
			perform_hammer()

func check_for_npcs():
	var overlapping_areas = interaction_area.get_overlapping_areas()
	for area in overlapping_areas:
		var parent = area.get_parent()
		if parent.is_in_group("npcs"):
			parent.talk()
			in_dialogue = true
			velocity = Vector3.ZERO
			return
	return false
	
func perform_hammer():
	if is_hammering: return
	is_hammering = true
	velocity = Vector3.ZERO
	anim_player.play("hammer_swing")
	
	await anim_player.animation_finished
	is_hammering = false

func _on_hammer_area_area_entered(area: Area3D):
	var body = area.get_parent()
	if body.has_method("on_hammer_hit"):
		body.on_hammer_hit()

func _on_dialogue_finished():
	in_dialogue = false
