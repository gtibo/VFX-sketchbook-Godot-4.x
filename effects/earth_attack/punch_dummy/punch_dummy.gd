extends CharacterBody3D

@onready var hit_box : HitBox3D = %HitBox
const GRAVITY : float = 50.0
@onready var dummy_skin = %DummySkin

var initial_position : Vector3

func _ready():
	initial_position = global_position
	hit_box.hit.connect(func():
		hit_box.active = false
		var t = create_tween().set_ease(Tween.EASE_OUT)
		t.tween_property(dummy_skin, "emission_blend", 1.0, 0.15)
		t.tween_callback(func():
			hide()
			).set_delay(0.15)
		t.tween_callback(func():
			show()
			dummy_skin.emission_blend = 0.0
			hit_box.active = true
			global_position = initial_position
			).set_delay(4.0)
		velocity += Vector3(1.0, 1.0, randfn(0.0, 0.1)).normalized() * 20.0
		)

func _physics_process(delta):
	velocity.y -= GRAVITY * delta
	if is_on_floor():
		var f = Vector2(velocity.x, velocity.z).move_toward(Vector2.ZERO, 50.0 * delta)
		velocity.x = f.x
		velocity.z = f.y
	move_and_slide()
