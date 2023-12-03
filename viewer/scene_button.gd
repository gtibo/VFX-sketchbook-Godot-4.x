extends VBoxContainer

@onready var title_label = %TitleLabel
@onready var thumbnail_texture = %ThumbnailTexture

signal pressed

func set_title(title : String):
	title_label.text = title

func set_thumbnail(texture : Texture2D):
	thumbnail_texture.texture = texture

func _gui_input(event):
	if !(event is InputEventMouseButton): return
	if event.button_index != 1: return
	if event.is_pressed(): 
		pressed.emit()
		get_viewport().set_input_as_handled()
