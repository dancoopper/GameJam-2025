extends Camera3D

@export var post_processing := true:
	set(p):
		if p:
			$Postprocess.show()
			post_processing = p
			var a = Vector3(-1, 1, 0).normalized()
			var b = Vector3(1, 0, 0).normalized()
			print("dot: ", a.dot(b))
		else:
			$Postprocess.hide()
			post_processing = p

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		global_rotation += Vector3(rad_to_deg(-event.relative.y), rad_to_deg(-event.relative.x), 0) / 10000
		#draw_process()
	if Input.is_action_just_pressed("ESC"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_VISIBLE
