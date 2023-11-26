extends Node3D

@onready var hit_box : HitBox3D = %HitBox
@onready var dummy_skin = %DummySkin

var _tween : Tween

func _ready():
	hit_box.hit.connect(_on_hit)

func _on_hit():
	if _tween && _tween.is_valid(): _tween.kill()
	_tween = create_tween()
	_tween.tween_property(dummy_skin, "scale", Vector3(1.2, 0.8, 1.2), 0.08)
	_tween.tween_property(dummy_skin, "scale", Vector3(0.8, 1.2, 0.8), 0.08)
	_tween.tween_property(dummy_skin, "scale", Vector3.ONE, 0.1)
	_tween.set_parallel(true)
	_tween.tween_property(dummy_skin, "emission_blend", 0.8, 0.1)
	_tween.chain().tween_property(dummy_skin, "emission_blend", 0.0, 2.0).set_delay(0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
