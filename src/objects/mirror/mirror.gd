@tool
extends MeshInstance3D


@export var _main_camera: Camera3D
@export_range(0.01, 1, 0.01) var _resolution_factor: float = 0.5:
	set(value):
		_resolution_factor = value
		if is_node_ready():
			_mirror_viewport.size = get_viewport().size * value

@export var _transparent_background: bool = false:
	set(value):
		_transparent_background = value
		_mirror_viewport.transparent_bg = value

@export_flags_3d_render var _cull_mask = 1:
	set(value):
		_cull_mask = value
		if is_node_ready():
			_mirror_camera.cull_mask = _cull_mask

@onready var _mirror_camera: Camera3D = %MirrorCamera
@onready var _mirror_viewport: SubViewport = $MirrorViewport


func _ready() -> void:
	mesh = mesh.duplicate()
	mesh.changed.connect(_on_mesh_changed)
	_mirror_camera.cull_mask = _cull_mask
	_on_mesh_changed()
	get_viewport().size_changed.connect(_on_vieport_size_changed)
	_on_vieport_size_changed()


func _on_mesh_changed() -> void:
	if not mesh is PlaneMesh:
		push_error("The mesh must be `PlaneMesh`")


func _on_vieport_size_changed():
	_mirror_viewport.size = get_viewport().size * _resolution_factor 


func _process(_delta) -> void:
	var camera = _main_camera if _main_camera != null else get_viewport().get_camera_3d()
	if camera == null or not camera.current:
		return
	_mirror_camera.fov = camera.fov
	_mirror_camera.keep_aspect = camera.keep_aspect

	var mirror_plane: Plane = Plane(global_basis[mesh.orientation].normalized(), global_position)

	var projection: Vector3 = mirror_plane.project(camera.global_position)
	var mirrored_pos: Vector3 = camera.global_position + (projection - camera.global_position) * 2
	_mirror_camera.global_position = mirrored_pos
	

	var n: Vector3 = mirror_plane.normal
	var mirror_matrix: Basis = Basis(
		Vector3.RIGHT - 2 * Vector3(n.x * n.x, n.x * n.y, n.x * n.z),
		Vector3.UP - 2 * Vector3(n.x * n.y, n.y * n.y, n.y * n.z),
		Vector3.BACK - 2 * Vector3(n.x * n.z, n.y * n.z, n.z * n.z)
	)

	_mirror_camera.global_basis = camera.global_basis
	_mirror_camera.scale = camera.scale
	# Left and right in a mirror are inverted
	_mirror_camera.scale.x *= -1

	var t: Transform3D = Transform3D(mirror_matrix * _mirror_camera.global_basis, mirrored_pos)
	
	# We will be loking in the mirror perpendicularly so we just
	# adjust the frustrum offset which gives the required effect
	# cutting anything behind the mirror in the same time.
	t = t.looking_at(projection)
	var proj_offset: Vector3 = projection * t
	var mirror_offset: Vector3 = global_position * t
	var frustum_offset: Vector3 = mirror_offset - proj_offset
	_mirror_camera.global_transform = t
	_mirror_camera.set_frustum(max(mesh.size.x, mesh.size.y), Vector2(frustum_offset.x, frustum_offset.y), abs(mirror_offset.z) + 0.01, camera.far)

	(material_override as ShaderMaterial).set_shader_parameter("mesh_size", mesh.size)
