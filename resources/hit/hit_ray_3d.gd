extends RayCast3D

signal hit

func _physics_process(delta):
	if !is_colliding(): return
	var collider = get_collider()
	if !(collider is HitBox3D): return
	set_physics_process(false)
	hit.emit()
	print(get_collision_point(), get_collision_normal())
