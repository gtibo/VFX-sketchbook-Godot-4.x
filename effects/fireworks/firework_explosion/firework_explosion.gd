extends Node3D

@onready var trails = %Trails
@onready var sparks = %Sparks

func _ready():
	trails.emitting = true
	trails.one_shot = true
	sparks.emitting = true
	sparks.one_shot = true
	var lifetime_timer = get_tree().create_timer(4.0)
	lifetime_timer.timeout.connect(func():
		queue_free()
		)

# Size 
func setup(base_color : Color, base_velocity : float = 6.0, trails_count : int = 18):
	var small_sparks = 8
	trails.process_material.set("initial_velocity_min", base_velocity * 0.8)
	trails.process_material.set("initial_velocity_max", base_velocity * 1.2)
	trails.process_material.color = base_color.lightened(0.2)
	trails.amount = trails_count
	trails.process_material.sub_emitter_frequency = small_sparks
	sparks.process_material.color = base_color.lightened(0.5)
	sparks.amount = trails_count * small_sparks
