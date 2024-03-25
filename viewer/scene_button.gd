extends TextureButton

@onready var title_label = %TitleLabel

func _ready():
	toggled.connect(_on_toggle)
	_on_toggle(button_pressed)
	
func _on_toggle(state : bool):
	material.set_shader_parameter("greyscale", float(!state))

func set_title(title : String):
	title_label.text = title

func set_thumbnail(texture : Texture2D):
	texture_normal = texture
