extends Node3D



@onready var raycast = $Camera3D/RayCast3D
@onready var hand = $Camera3D/hand
var held_item: Node3D = null

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	
	if Input.is_action_just_pressed("Interact"):  # Make sure "interact" is in InputMap
		if !held_item:
			try_pickup()
		else:
			try_dropoff()

	
	#var object = raycast.get_collider()
	#if raycast.is_colliding() or player_holding:
		#if object.is_in_group("pickable"):
			#if Input.is_action_pressed("Interact"):
				#print("interact button pressed")
				#object.global_position = hand.global_position
				#object.global_rotation = hand.global_rotation
				#object.collision_layer = 2
				#
				#object.linear_velocity = Vector3(0.1, 3, 0.1)
			
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
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation += Vector3(rad_to_deg(-event.relative.y), rad_to_deg(-event.relative.x), 0) / 10000
		#draw_process()
	if Input.is_action_just_pressed("ESC"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_VISIBLE
