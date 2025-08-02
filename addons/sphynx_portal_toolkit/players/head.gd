extends Node3D



@onready var raycast = $Camera3D/RayCast3D
@onready var hand = $Camera3D/hand
var held_item: Node3D = null

var pitch := 0.0  # Up/down
var yaw := 0.0    # Left/right

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	
	if Input.is_action_just_pressed("Interact"):  # Make sure "interact" is in InputMap
		if !held_item:
			try_pickup()
		else:
			try_dropoff()
			
func try_pickup():
	
	if held_item:
		return # Already holding something
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.has_method("on_pickup"):
			collider.collision_layer = 2
			held_item = collider
			collider.on_pickup(hand)
			
func try_dropoff():
	
	if !held_item:
		return 
	
	if held_item.has_method("on_dropoff"):
		held_item.on_dropoff()
	held_item = null

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		pitch = clamp(pitch - event.relative.y * 0.005, deg_to_rad(-70), deg_to_rad(70))
		yaw -= event.relative.x * 0.005
		
		rotation = Vector3(pitch, yaw, 0)

	if Input.is_action_just_pressed("ESC"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
