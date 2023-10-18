extends Camera3D

@export var shake_amount : Curve
@export var shake_duration : Curve

func shake():
	shake_value("h_offset", randi_range(4, 6))
	shake_value("v_offset", randi_range(4, 6))
	
func shake_value(property_name : String, shake_count : int, vector : float = 1.0):
	var t = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	for i in shake_count:
		var progress : float = i / float(shake_count - 1)
		var inv = i % 2
		var v = vector if bool(inv) else -vector
		t.tween_property(self, property_name, v * shake_amount.sample(progress), shake_duration.sample(progress) * 0.2)
