extends Node3D

@onready var animation_player = %AnimationPlayer

func _input(_event):
	if animation_player.is_playing(): return
	if Input.is_action_just_pressed("ui_accept"):
		animation_player.play("default")
