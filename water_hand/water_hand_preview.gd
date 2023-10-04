extends Node3D

@onready var water_hand : AnimationPlayer = %WaterHand/AnimationPlayer
@onready var camera_3d = %Camera3D
@onready var target = %Target

@onready var impact_splash = %ImpactSplash
@onready var hand_splash = %HandSplash

func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		play_animation()

func play_animation():
	hand_splash.splash()
	water_hand.play("Slap")
	var timer : SceneTreeTimer = get_tree().create_timer(1.55)
	timer.timeout.connect(impact_animation)

func impact_animation():
	target.hit()
	impact_splash.splash()
	camera_3d.shake()
