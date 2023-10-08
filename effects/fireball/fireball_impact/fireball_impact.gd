extends Node3D

@onready var animation_player = %AnimationPlayer
@onready var flash = %Flash

func _ready():
	flash.scale = Vector3.ONE * randfn(1.0, 0.1)
	animation_player.play("default")
	var queue_timer = get_tree().create_timer(4.0)
	queue_timer.connect("timeout", queue_free)
