extends Node3D

@export var _min_distance: float = 1
@export var _max_distance: float = 4
@export var _distance_sensitivity: = 0.3
@export var _distance_lerp_factor = 5
var _accumulated_distance: float = lerp(_min_distance, _max_distance, 0.5)

@export_range(0, 180, 5, "radians_as_degrees") var _max_angle: float = deg_to_rad(80)
@export_range(0, 90, 5, "radians_as_degrees") var _h_rotation_sensitivity = 0.2
@export_range(0, 90, 5, "radians_as_degrees") var _v_rotation_sensitivity = 0.2
@onready var _init_angle: float = _max_angle * 0.5

## How much seconds it'll take for the camera's
## target to get to the scooter position.
@export var _target_position_align_lerp_factor: float = 10

@onready var _camera: Camera3D = $Camera3D
@onready var _body: Node3D = owner
# Camera's target is free from the owner's transform
# hence I calculate its local position on _ready.
@onready var _target_offset: Vector3 = _body.to_local(global_position)


func _ready() -> void:
	top_level = true
	quaternion = Quaternion(global_basis.x, _init_angle) * quaternion
	_process(1)


func _input(event: InputEvent) -> void:
	if not Input.mouse_mode == Input.MouseMode.MOUSE_MODE_CAPTURED:
		return

	var e = event as InputEventMouseMotion
	if e and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var motion = e.screen_relative
		var rot = Vector2(deg_to_rad(motion.x) * _h_rotation_sensitivity, deg_to_rad(motion.y) * _v_rotation_sensitivity)
		quaternion = Quaternion(-Vector3.MODEL_TOP, rot.x) * quaternion
		var new_q = Quaternion(global_basis.x, rot.y) * quaternion
		var euler = new_q.get_euler(EULER_ORDER_YXZ)
		var a = euler.x if not is_equal_approx(absf(euler.z), PI) else PI - euler.x
		if a < 0:
			new_q = Quaternion(global_basis.x, absf(a)) * new_q
		if a > _max_angle:
			new_q = Quaternion(global_basis.x, _max_angle - a) * new_q
		quaternion = new_q
		
	e = event as InputEventMouseButton
	if e:
		var dir: int = -1 if e.button_index == MOUSE_BUTTON_WHEEL_UP else 1 if e.button_index == MOUSE_BUTTON_WHEEL_DOWN else 0
		if dir:
			_accumulated_distance = clampf(_accumulated_distance + dir * _distance_sensitivity, _min_distance, _max_distance)
		


func _process(delta: float) -> void:
	var tar_pos = global_position.lerp(_body.global_position + _target_offset, clampf(delta * _target_position_align_lerp_factor, 0, 1))
	global_position = tar_pos
	_camera.global_position = _camera.global_position.lerp(tar_pos - global_basis.z * _accumulated_distance, clampf(delta * _distance_lerp_factor, 0, 1))
