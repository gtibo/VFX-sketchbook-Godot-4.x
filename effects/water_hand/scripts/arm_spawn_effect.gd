extends Node3D

@onready var animation_player = $AnimationPlayer

func play_effect():
	animation_player.stop()
	animation_player.play("default")
