extends MeshInstance3D

signal finished

func setup(start_position : Vector3, end_position : Vector3, speed : float = 10.0):
	var t = create_tween()
	var duration = abs(start_position.y - end_position.y) / speed
	t.tween_method(func(progress : float):
		position = start_position.lerp(end_position, progress)
		material_override.set_shader_parameter("lifetime", progress)
		, 0.0, 1.0, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	t.tween_callback(func():
		finished.emit()
		queue_free()
		)
