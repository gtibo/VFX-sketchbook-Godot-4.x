extends Area3D

var collision_shape : CollisionShape3D

signal hit(hit_position, hit_normal)

func _ready():
	var collisions = find_children("", "CollisionShape3D")
	if collisions.is_empty(): return
	collision_shape = collisions[0]
	connect("area_entered", func(area : Area3D):
		var hit_box = area as HitBox3D
		if hit_box == null: return
		hit_box.hit.emit()
		collision_shape.set_deferred("disabled", true)
		hit.emit(global_position, global_position.direction_to(hit_box.global_position))
		)
	
