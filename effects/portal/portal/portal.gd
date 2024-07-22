class_name Portal
extends Area3D

@onready var world_camera : Camera3D = get_viewport().get_camera_3d()
@onready var local_camera = %Camera3D
@export var other_portal : Portal

func _process(_delta):
	local_camera.global_transform = get_other_side_transform(world_camera.global_transform)

func get_other_side_transform(base_origin : Transform3D) -> Transform3D:
	var relative_transform = other_portal.global_transform.scaled_local(Vector3(-1.0, 1.0, -1.0)) * global_transform.inverse()
	return relative_transform * base_origin
