extends RigidBody3D


@export var item_name: String = "Default Item"

var target: Node3D = null;

func _process(delta):
	if target:
		position = target.global_position

func on_dropoff():
	target = null
	linear_velocity = Vector3(0.1, 3, 0.1)

func on_pickup(parent_node: Node3D):
	target = parent_node
