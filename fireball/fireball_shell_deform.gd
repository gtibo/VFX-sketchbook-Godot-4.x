extends Node3D

@onready var fireball_shell_mesh = %FireballShellMesh
@onready var fire_trail = %FireTrail
@onready var fire_smoke = %FireSmoke

signal is_out

func out():
	fireball_shell_mesh.hide()
	fire_trail.emitting = false
	fire_smoke.emitting = false
	await get_tree().create_timer(4.0).timeout
	is_out.emit()
