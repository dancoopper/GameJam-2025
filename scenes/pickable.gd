extends RigidBody3D

var _target: Node3D = null;

func _process(delta):
	if _target:
		position = _target.global_position

func on_dropoff():
	_target = null
	linear_velocity = Vector3(0.1, 3, 0.1)

func on_pickup(target: Node3D):
	_target = target
