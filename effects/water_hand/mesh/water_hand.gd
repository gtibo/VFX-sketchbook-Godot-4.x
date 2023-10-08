extends Node3D

@onready var animation_tree : AnimationTree = %AnimationTree

signal raised
signal slaped

func play_default():
	animation_tree.set("parameters/Transition/transition_request", "default")
