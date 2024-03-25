extends Node

@onready var scene_holder = %SceneHolder
@onready var transition = %Transition
@onready var toggle_button = %ToggleButton
@onready var panel_container = %PanelContainer
@onready var scroll_container = %ScrollContainer
@onready var scene_list = %SceneList
@export var scene_data_list : Array[EffectData] = []

const LEFT_ARROW_ICON = preload("res://assets/left_arrow_icon.png")
const RIGHT_ARROW_ICON = preload("res://assets/right_arrow_icon.png")

const SCENE_BUTTON = preload("res://viewer/scene_button.tscn")
var current_scene : Node = null
var loading = false

signal on_load(state : bool)

func _on_toggle(value : bool):
	toggle_button.icon = LEFT_ARROW_ICON if value else RIGHT_ARROW_ICON
	var target_x : float = 0.0 if value else -scroll_container.size.x
	var t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t.tween_property(panel_container, "position:x", target_x, 0.25)

func _ready():
	toggle_button.toggled.connect(_on_toggle)
	
	for scene_data in scene_data_list:
		var btn = SCENE_BUTTON.instantiate()
		scene_list.add_child(btn)
		var scene_path = scene_data.scene_path
		btn.connect("pressed", set_scene_preview.bind(scene_path))
		on_load.connect(func(state : bool):
			btn.disabled = state
			)
		btn.set_title(scene_data.title)
		if scene_data.thumbnail: 
			btn.set_thumbnail(scene_data.thumbnail)
	
	if scene_data_list.is_empty(): return
	# Load default scene
	set_scene_preview(scene_data_list[0].scene_path)
	
func set_scene_preview(scene_path : String):
	if loading: return
	loading = true
	on_load.emit(true)
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
	on_load.emit(false)
