extends Node3D
@onready var dummy_mat : ShaderMaterial = %"dummy/RIG-Armature/Skeleton3D/dummy2".material_override

var emission_blend : float = 0.0 : set = _set_emission_blend

func _set_emission_blend(value : float = 0.0):
	emission_blend = clamp(value, 0.0, 1.0)
	dummy_mat.set_shader_parameter("emission_blend", value)
