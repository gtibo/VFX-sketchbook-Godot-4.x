class_name SimpleProjectile
extends Node3D

@export var spawn_scene : PackedScene
@export var impact_scene : PackedScene

@onready var hit_zone_3d = %HitZone3D
@onready var fireball = %Fireball

var target_node : Node3D
var velocity : Vector3
var speed = 0.4

func launch(start_position : Vector3, start_velocity : Vector3, target : Node3D):
	global_position = start_position
	velocity = start_velocity
	target_node = target
	
	_look_at_velocity()
	
	var spawn = spawn_scene.instantiate()
	add_sibling(spawn)
	spawn.transform = transform

func _ready():
	hit_zone_3d.connect("hit", func(hit_pos, hit_normal):
		fireball.out()
		set_process(false)
		var impact = impact_scene.instantiate()
		add_sibling(impact)
		impact.global_position = hit_pos
		impact.look_at(impact.transform.origin + hit_normal, Vector3.UP)
		)
	fireball.connect("is_out", queue_free)

func _process(delta):
	if target_node == null: return
	var direction = (target_node.global_position - global_position).limit_length(speed)
	velocity = velocity.move_toward(direction, speed * delta * 3.0)
	position += velocity
	_look_at_velocity()
	
func _look_at_velocity():
	var look_at_target = transform.origin + velocity
	if transform.origin != look_at_target:
		look_at(look_at_target, Vector3.UP, true)
