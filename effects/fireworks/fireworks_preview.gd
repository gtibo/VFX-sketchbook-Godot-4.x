extends Node3D

const FIREWORK_EXPLOSION_SCENE = preload("./firework_explosion/firework_explosion.tscn")
const FIREWORK_ROCKET_SCENE = preload("./firework_rocket/firework_rocket.tscn")

@export var colors : Gradient
@export var probability_curve : Curve
@onready var spawn_timer = %SpawnTimer
var tick = 0
var tick_size = 100

func _ready():
	spawn_timer.timeout.connect(func():
		var progress : float = tick / float(tick_size)
		var probability : float = probability_curve.sample(progress)
		if randf() < probability:
			_spawn_random_firework()
		tick = (tick + 1) % tick_size
	)

func _get_random_point(radius : float) -> Vector3:
	return Vector3(
		randfn(0.0, 1.0) * radius,
		randfn(0.0, 1.0) * radius,
		randfn(0.0, 1.0) * radius
	)

func _spawn_random_firework():
	var end_position : Vector3 = _get_random_point(2.0)
	var start_position : Vector3 = end_position
	start_position.y = -8.0
	var rocket = FIREWORK_ROCKET_SCENE.instantiate()
	add_child(rocket)
	rocket.setup(start_position, end_position, randf_range(8.0, 12.0))
	rocket.finished.connect(_spawn_explosion.bind(end_position))

func _spawn_explosion(at : Vector3 = Vector3.ZERO):
	var firework = FIREWORK_EXPLOSION_SCENE.instantiate()
	add_child(firework)
	firework.global_position = at
	firework.setup(colors.sample(randf()), randf_range(4.0, 6.0),randi_range(48, 64))
