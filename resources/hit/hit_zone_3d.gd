extends Area3D

signal hit(hit_position, hit_normal)

func _ready():
	connect("area_entered", func(area : Area3D):
		var hit_box = area as HitBox3D
		if hit_box == null: return
		hit_box.hit.emit()
		hit.emit(global_position, global_position.direction_to(hit_box.global_position))
		)
	
