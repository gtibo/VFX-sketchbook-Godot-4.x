extends Node3D

@onready var animation_tree = %AnimationTree
@onready var blink_timer = %BlinkTimer

func _ready():
	blink_timer.start(1.0)
	blink_timer.timeout.connect(_on_blink_timer)

func _on_blink_timer():
	blink_timer.start(randf_range(1.0, 4.0))
	animation_tree.set("parameters/BlinkShot/request", true)
