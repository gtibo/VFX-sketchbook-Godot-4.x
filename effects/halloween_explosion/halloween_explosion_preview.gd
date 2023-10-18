extends Node3D

@onready var jack_o_lantern = %JackOLantern
@onready var camera : Camera3D = $Turner/Camera3D
var explosion_scene : PackedScene = preload("./explosion/explosion.tscn")

func _ready():
	jack_o_lantern.idle()
	jack_o_lantern.exploded.connect(explode)
	
func _input(_event):
	if !jack_o_lantern.is_idling: return
	if Input.is_action_just_pressed("ui_accept"):
		jack_o_lantern.explode()

func explode():
	await get_tree().process_frame
	var explosion = explosion_scene.instantiate()
	add_child(explosion)
	camera.shake()
	explosion.tree_exited.connect(jack_o_lantern.idle)
