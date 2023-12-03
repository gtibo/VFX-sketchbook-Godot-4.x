extends ColorRect

signal transition_finished


func fade_in():
	show()
	var t = create_tween()
	t.tween_property(self, "modulate:a", 1.0, 0.2).from(0.0)
	t.tween_callback(func():
		transition_finished.emit()
	)
	
func fade_out():
	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.0, 0.2).from(1.0)
	t.tween_callback(func():
		hide()
		transition_finished.emit()
	)
