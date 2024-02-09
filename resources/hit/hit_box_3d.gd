extends Area3D
class_name HitBox3D

signal hit
var active : bool = true : set = _set_active
var collision_shape : CollisionShape3D

func _set_active(value : bool):
	if active == value: return
	active = value
	if collision_shape:
		collision_shape.set_deferred("disabled", !active)

func _ready():
	collision_shape = find_children("", "CollisionShape3D", false).pop_front() as CollisionShape3D
	if collision_shape:
		collision_shape.set_deferred("disabled", !active)
