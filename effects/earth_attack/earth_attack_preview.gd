extends Node3D

const EARTH_SPIKES = preload("./earth_spikes.tscn")

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		_launch()

func _ready():
	_launch()

func _launch():
	var earth_spikes = EARTH_SPIKES.instantiate()
	add_child(earth_spikes)
