extends Node3D

@onready var animation_player = %AnimationPlayer
@onready var big_amber = %BigAmber
@onready var small_amber = %SmallAmber
@onready var amber_smoke = %AmberSmoke

func _ready():
	animation_player.play("default")
	animation_player.connect("animation_finished",
	func(_anim_name):
		queue_free()
		)
