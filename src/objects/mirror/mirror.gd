@tool
extends MeshInstance3D


@export var _main_camera: Camera3D
@export_range(0.01, 1, 0.1) var _resolution_factor: float = 0.5:
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
var _mirror_plane: Plane


func _ready() -> void:
	mesh = mesh.duplicate()
	mesh.changed.connect(_on_mesh_changed)
	_mirror_viewport.size = get_viewport().size * _resolution_factor
	_mirror_camera.cull_mask = _cull_mask
	_on_mesh_changed()


func _on_mesh_changed() -> void:
	if not mesh is PlaneMesh:
		push_error("The mesh must be `PlaneMesh`")
	else:
		_mirror_plane = Plane(global_transform.basis[mesh.orientation].normalized(), global_position)
	


func _on_vieport_size_changed():
	_mirror_viewport.size = get_viewport().size * _resolution_factor


func _process(_delta) -> void:
	var camera = _main_camera if _main_camera != null else get_viewport().get_camera_3d()

	if _main_camera != null and camera != _main_camera:
		return

	if camera == null:
		return
	_mirror_camera.fov = camera.fov
	var projection = _mirror_plane.project(camera.global_position)
	var mirrored_pos = camera.global_position + (projection - camera.global_position) * 2
	_mirror_camera.global_position = mirrored_pos

	var n = _mirror_plane.normal
	var mirror_matrix: Basis = Basis(
		Vector3.RIGHT - 2 * Vector3(n.x * n.x, n.x * n.y, n.x * n.z),
		Vector3.UP - 2 * Vector3(n.y * n.x, n.y * n.y, n.y * n.z),
		Vector3.BACK - 2 * Vector3(n.z * n.x, n.z * n.y, n.z * n.z)
	)
	_mirror_camera.global_basis = mirror_matrix * camera.global_basis
