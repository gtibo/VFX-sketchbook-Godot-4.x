extends Node3D

var explosion_scene : PackedScene = preload("./explosion/explosion.tscn")

func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		explode()

func explode():
	var explosion = explosion_scene.instantiate()
	add_child(explosion)
