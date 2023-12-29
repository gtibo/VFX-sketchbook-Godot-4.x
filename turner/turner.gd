extends Node3D

@onready var _camera = %Camera3D
@export var low_angle : float = -5.0
@export var high_angle : float = -50.0
@export var min_zoom : float = 2.0
@export var max_zoom : float = 10.0
@export var _zoom = 5.5 : set = _set_zoom
@export var lock_x : bool = false

@export var auto_spin : bool = false
var _is_spinning : bool = false
@onready var _spin_timer = %SpinTimer

var _is_grabbing = false

func _set_zoom(value : float):
	_zoom = clamp(value, min_zoom, max_zoom)
	if !is_inside_tree(): return
	var t = create_tween().set_trans(Tween.TRANS_LINEAR)
	t.tween_property(_camera, "position:z", _zoom, 0.2)

func _ready():
	_camera.position.z = _zoom
	_is_spinning = auto_spin
	_spin_timer.timeout.connect(func(): _is_spinning = true)

func _process(delta):
	if _is_spinning: rotation.y += 0.05 * delta

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: _is_grabbing = event.pressed
		var wheel_up = event.button_index == MOUSE_BUTTON_WHEEL_UP
		var wheel_down = event.button_index == MOUSE_BUTTON_WHEEL_DOWN
		var wheel_direction = float(wheel_down) - float(wheel_up)
		if wheel_direction != 0: _zoom += wheel_direction * 0.25
		return
	
	if event is InputEventMouseMotion and _is_grabbing:
		_is_spinning = false
		if auto_spin: _spin_timer.start()
		rotation.y += -event.relative.x * 0.004
		if !lock_x:
			rotation.x += -event.relative.y * 0.004
			rotation.x = clamp(rotation.x, deg_to_rad(high_angle), deg_to_rad(low_angle))
