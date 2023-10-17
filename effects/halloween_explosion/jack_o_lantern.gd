extends Node3D

@onready var animation_tree = %AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var jack_o_lantern = %jack_o_lantern

signal exploded

var is_idling = true

func idle():
	if !is_inside_tree(): return
	is_idling = true
	state_machine.travel("Fall", true)
	await get_tree().process_frame
	jack_o_lantern.show()
	
func explode():
	is_idling = false
	animation_tree.set("parameters/OneShot/request", true)
	animation_tree.connect("animation_finished", func(_anim_name):
		jack_o_lantern.hide()
		exploded.emit()
		, CONNECT_ONE_SHOT)
	
