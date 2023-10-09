extends Node3D

func hit():
	var t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	t.tween_property(self, "scale", Vector3(1.4, 0.6, 1.4), 0.2)
	t.tween_property(self, "scale", Vector3(0.8, 1.2, 0.8), 0.2)
	t.tween_property(self, "scale", Vector3.ONE, 0.1)
	
	var t_rot = create_tween()
	
	t_rot.tween_property(self, "rotation_degrees:z", -15.0, 0.2)
	t_rot.tween_property(self, "rotation_degrees:z", 5.0, 0.2)
	t_rot.tween_property(self, "rotation_degrees:z", 0.0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
