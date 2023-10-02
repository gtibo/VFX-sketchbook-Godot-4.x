extends Node3D

@onready var target = %Target
@onready var output = %Output
@onready var shot_timeout = $ShotTimeout

var projectile_scene : PackedScene = preload("./simple_projectile.tscn")

var last_shot : float = 0.0

func _process(_delta):
	if Input.is_action_pressed("ui_accept") && shot_timeout.time_left == 0.0:
		shoot()
		shot_timeout.start()
	
func shoot():
	var projectile : SimpleProjectile = projectile_scene.instantiate()
	add_child(projectile)
	
	var speed = 0.2 * randfn(1.0, 0.1)
	projectile.speed = speed
	
	var base_x : Vector3 = output.transform.basis.x * speed
	var b_y = base_x.rotated(Vector3(0, 1, 0), randfn(0.0, PI * 0.5))
	var b_z = base_x.rotated(Vector3(0, 0, 1), randf() * PI * 0.5)
	base_x = (b_y * 0.4 + b_z * 0.6).normalized()
	
	projectile.launch(output.global_position, base_x * speed, target)
