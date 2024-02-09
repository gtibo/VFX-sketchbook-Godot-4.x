extends Node3D

@export var zone_length : float = 10.0
@onready var rocks_particles = %RocksParticles
@onready var small_rocks = %SmallRocks
@onready var dust_particles = %DustParticles
@onready var hit_zone = %HitZone
@onready var hit_zone_collision = %HitZoneCollision

func _ready():
	var half_length = zone_length / 2.0
	hit_zone.position.x = -half_length
	var t = create_tween()
	t.tween_property(hit_zone, "position:x", half_length, 2.0)
	t.tween_callback(hit_zone_collision.set_deferred.bind("disabled", true))
	
	rocks_particles.emitting = true
	dust_particles.emitting = true
	await get_tree().create_timer(10.0).timeout
	queue_free()
