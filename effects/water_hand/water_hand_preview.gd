extends Node3D

@onready var water_hand = %WaterHand
@onready var wet_player = %WetPlayer
@onready var target = %Target
@onready var camera : Camera3D = $Turner/Camera3D
@onready var impact_splash = %ImpactSplash
@onready var arm_impact_droplet = %ArmImpactDroplet
@onready var hand_splash = %HandSplash
@onready var cooldown_timer : Timer = %CooldownTimer
@onready var arm_spawn_effect = %ArmSpawnEffect

func _input(_event):
	if cooldown_timer.time_left != 0: return
	if Input.is_action_just_pressed("ui_accept"):
		arm_spawn_effect.play_effect()
		await get_tree().create_timer(0.15).timeout
		water_hand.play_default()
		cooldown_timer.start(3.0)
		
func _ready():
	water_hand.raised.connect(func():
		hand_splash.splash()
		wet_player.stop(true)
		wet_player.play("default", 0.1)
		)
	water_hand.slaped.connect(func():
		target.hit()
		impact_splash.splash()
		camera.shake()
		arm_impact_droplet.emitting = true
		)
