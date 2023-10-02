@tool
extends MeshInstance3D

var points_count : int = 8
var resolution : int = 8

var global_points : PackedVector3Array = []
var transforms : Array[Transform3D] = []

var i_mesh = ImmediateMesh.new()

func _ready():
	global_points.resize(points_count)

func _process(delta):
	global_points[0] = global_position
	for i in range(points_count-1, -1, -1):
		if i == 0: continue
		var previous_point = global_points[i - 1]
		global_points[i] = global_points[i].move_toward(previous_point, 10.0 * delta)
	
	i_mesh.clear_surfaces()
	i_mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	for p in global_points:
		i_mesh.surface_add_vertex(to_local(p))
	i_mesh.surface_end()
	mesh = i_mesh
