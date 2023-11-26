extends Node3D

func hit():
	var t = create_tween().set_ease(Tween.EASE_OUT)
	t.tween_property(self, "scale", Vector3(1.4, 0.6, 1.4), 0.2)
	t.tween_property(self, "scale", Vector3(0.8, 1.2, 0.8), 0.2)
	t.tween_property(self, "scale", Vector3.ONE, 0.1)
	
