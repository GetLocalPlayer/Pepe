extends Area3D
class_name CameraRoomConstraint


"""
A node that is used as a room with a camera attached
to its ceiling. The camera will be following the target
at the given distance INSIDE the room, the camera
cannot leave the room. If the target is outside of the room
the camera tries to find the clossest to the target
position on the ceiling. Ceiling is represented as a
Plane instance with its edges represented as a Curve3D
instance for calculating the closest point to the target
on the edges of the ceiling.

The name of the target must be specified in "Target
Node Name" property in the inspector. The target
can have "CameraTarget" node whose position will
be used in 'look_at'.

Area3D is used to detect collision with the target
and make its camera current.
"""

# The _camera will target child node of the target
# with name in CAMERA_TARGET_NAME if exists, otherwise
# global position of the target.
const CAMERA_TARGET_NAME = "CameraTarget"
@export var _make_current_on_enter: bool = true
## What entering body must be named to make the 
## camera follow it
@export var _target_node_name = "Player"
## At which max distance the camera starts
## following the target
@export var _follow_distance: float = 3
@export var _camera_tween_time: float = 1

@onready var _shape_node: CollisionShape3D = $CollisionShape3D
var _shape: Shape3D:
	get:
		return _shape_node.shape

@onready var _camera: Camera3D = $Camera3D
var _ceiling: Plane = Plane()
var _edges: Curve3D = Curve3D.new()
var _target: Node3D


func _ready() -> void:
	if not _shape:
		push_warning(name, " - no collision shape found!")
		return
	var box = _shape as BoxShape3D
	if not box:
		push_warning(name, "collision shape must be a 'BoxShape3D'!")
		return
	box.changed.connect(_udpate_ceiling)
	_udpate_ceiling()
	body_entered.connect(_on_body_entered)
	for body in get_overlapping_bodies():
		if body.name == _target_node_name:
			_on_body_entered(body)

func _process(delta: float) -> void:
	if _camera.current and _target:
		_update_camera(delta)

"""
Recalculate ceiling plane and its edges each
time the shape's properties are changed.
"""
func _udpate_ceiling() -> void:
	var box = _shape as BoxShape3D
	var half_size = box.size * 0.5
	_ceiling.d = half_size.y
	_ceiling.normal = _shape_node.basis.y
	_edges.clear_points()
	_edges.bake_interval = 999999999
	var p1 = half_size
	var p2 = Vector3(-half_size.x, half_size.y, half_size.z)
	var p3 = Vector3(-half_size.x, half_size.y, -half_size.z)
	var p4 = Vector3(half_size.x, half_size.y, -half_size.z)
	_edges.add_point(p1)
	_edges.add_point(p2)
	_edges.add_point(p3)
	_edges.add_point(p4)


func _on_body_entered(body: Node3D) -> void:
	if not body.name == _target_node_name:
		return
	_target = body.get_node(CAMERA_TARGET_NAME) if body.has_node(CAMERA_TARGET_NAME) else body
	if _make_current_on_enter and not _camera.current:
		_camera.make_current()
		_update_camera(_camera_tween_time)


func _update_camera(delta: float) -> void:
	var c_pos = _ceiling.project(_shape_node.to_local(_camera.global_position))
	var t_pos = _shape_node.to_local(_target.global_position)
	var t_proj = _ceiling.project(t_pos)
	var dist = sqrt(_follow_distance**2 + _ceiling.d**2)
	var new_c_pos = t_proj.move_toward(c_pos, dist)
	var points: PackedVector3Array = _edges.get_baked_points()
	var first_sign = sign( (points[1] - points[0]).dot(new_c_pos - points[0]) )
	points.append(points[0])
	for i: int in range(1, points.size() - 1):
		var p1 = points[i]
		var p2 = points[i + 1]
		var v1 = p2 - p1
		var v2 = new_c_pos - p1
		var dot = v1.dot(v2)
		var curr_sign = sign(dot)
		if curr_sign != 0 and curr_sign != first_sign:
			new_c_pos = _edges.get_closest_point(new_c_pos)
			break

	var new_transform = _camera.global_transform \
		.translated(_shape_node.to_global(new_c_pos) - _camera.global_position) \
		.looking_at(_target.global_position)	
		
	_camera.global_transform = _camera.global_transform.interpolate_with(new_transform, delta / _camera_tween_time if _camera_tween_time > 0 else delta)
