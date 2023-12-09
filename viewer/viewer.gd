extends Node

@onready var scene_holder = %SceneHolder
@onready var transition = %Transition
@export var scene_data_list : Array[EffectData] = []
@onready var scene_list = %SceneList
const SCENE_BUTTON = preload("res://viewer/scene_button.tscn")
var current_scene : Node = null
var loading = false

func _ready():
	for scene_data in scene_data_list:
		var btn = SCENE_BUTTON.instantiate()
		scene_list.add_child(btn)
		var scene_path = scene_data.scene_path
		btn.connect("pressed", set_scene_preview.bind(scene_path))
		btn.set_title(scene_data.title)
		if scene_data.thumbnail: 
			btn.set_thumbnail(scene_data.thumbnail)
	
	if scene_data_list.is_empty(): return
	# Load default scene
	set_scene_preview(scene_data_list[0].scene_path)
	
func set_scene_preview(scene_path : String):
	if loading: return
	loading = true
	if current_scene:
		transition.fade_in()
		await transition.transition_finished
		current_scene.queue_free()
		await get_tree().process_frame
	
	transition.fade_out()
	current_scene = load(scene_path).instantiate()
	scene_holder.add_child(current_scene)
	await transition.transition_finished
	loading = false
	
