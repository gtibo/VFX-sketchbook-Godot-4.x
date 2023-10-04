extends Camera3D

@export var shake_amount : Curve
@export var shake_duration : Curve

func random_vector_3d() -> Vector3:
	var phi = randf() * TAU
	var costheta = randfn(0.0, 1.0)
	var tetha = acos(costheta)
	
	var x = sin(tetha) * cos(phi)
	var y = sin(tetha) * sin(phi)
	var z = cos(tetha)
	
	return Vector3(x, y, z)

func shake():
	var t = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	var shake_count : int = 6
	var vector = Vector3(1.0, 0.0, 0.0)
	for i in shake_count:
		var progress : float = i / float(shake_count - 1)
		var inv = i % 2
		var v = vector if bool(inv) else -vector
		t.tween_property(self, "position", v * shake_amount.sample(progress), shake_duration.sample(progress) * 0.2)
	
