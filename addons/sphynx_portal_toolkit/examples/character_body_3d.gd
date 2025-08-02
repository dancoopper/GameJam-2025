extends CharacterBody3D

@export var cam: Camera3D
@export var move_speed: float = 5.0
@export var jump_force: float = 8.0
@export var gravity: float = 20.0

var default_rotation

func _ready():
	default_rotation = rotation

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("A", "D", "S", "W")
	
	# Movement relative to camera view
	var cam_basis = cam.global_transform.basis
	var forward = -cam_basis.z.normalized()
	var right = cam_basis.x.normalized()
	var direction = (right * input_dir.x + forward * input_dir.y).normalized()
	
	var horizontal_velocity = direction * move_speed
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z

	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if rotation != default_rotation:
			rotation = rotation.slerp(default_rotation, 5.0 * delta)
		# Jump
		if Input.is_action_just_pressed("SPACE"):
			velocity.y = jump_force

	move_and_slide()
