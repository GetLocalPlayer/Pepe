extends VehicleBody3D
class_name Scooter


## km/h
@export var _max_speed: float = 50
@export var _engine_force: float = 100
@export var _brake_force: float = 5
@export var _tilt_stabilizing_factor: float = 10
## The higher the speed the lesser stabilization
## is require down to 0. This value defines
## minimal stabilization. For instance, value 0.2
## means that even at full speed stabilization
## cannot be lesser than 20% ot its full strength.
@export_range(0, 1, 0.01) var _minimal_tilt_stabilizing_factor = 0.2
## Max steering used at 0 speed
@export_range(0, 90, 1, "radians_as_degrees") var _max_steering: float = deg_to_rad(50)
## How much time in second must it take to
## fully rotate the wheel and the handle bar
## to the steering angle.
@export var _steering_time: float = 0.25


@onready var _pid: PIDController = $TiltController

@onready var _models: Dictionary[String, Node3D] = {
	handlebar = $Model/Handlebar,
	front_wheel = $Model/Handlebar/FrontWheel,
	back_wheel = $Model/BackWheel,
}
@onready var _wheels: Dictionary[String, VehicleWheel3D] = {
	front = $FrontWheel,
	back = $BackWheel,
}

@onready var _max_rpm: float = (_max_speed * 1000 / 60) / (2 * PI * _wheels.back.wheel_radius)


var _actions: Dictionary[String, String] = {
	left = "TurnLeft",
	right = "TurnRight",
	forward = "Forward",
	backwards = "Backwards",
	brake = "Brake",
}


func _process(delta: float) -> void:
	# Handlebar model rotation
	var handlebar_x = _models.handlebar.global_basis.x
	var wheel_x = _wheels.front.global_basis.x
	var a = handlebar_x.signed_angle_to(wheel_x, Vector3.UP)
	if not is_zero_approx(a):
		var q = _models.handlebar.global_basis.get_rotation_quaternion()
		q = Quaternion(_models.handlebar.global_basis.y, a) * q
		_models.handlebar.global_basis = q
	# Front wheel model rotation and position
	var rps = _wheels.front.get_rpm() / 60
	var b = _models.front_wheel.global_basis
	b = Quaternion(b.x, rps * TAU * delta) * b.get_rotation_quaternion()
	_models.front_wheel.global_basis = b
	var p =_models.handlebar.to_local(_wheels.front.global_position)
	_models.front_wheel.position.y = p.y
	#_models.front_wheel.position.z = p.z
	# Back wheel model full tranform
	_models.back_wheel.global_basis = b
	_models.back_wheel.global_transform = _wheels.back.global_transform


func _input(event: InputEvent) -> void:
	if event as InputEventKey: _handle_input_actions(event)
	if Input.is_key_pressed(KEY_E) and not event.is_echo():
		get_tree().reload_current_scene()


func _handle_input_actions(event: InputEventKey) -> void:
	if event.is_action(_actions.forward):
		_handle_engine_force(event.pressed)
	if event.is_action(_actions.brake):
		_handle_brake(event.pressed and not event.echo, not event.pressed)
	if (event.is_action(_actions.left) or event.is_action(_actions.right)) and not event.echo:
		var dir = 0
		if event.is_action_pressed(_actions.left, true): dir -= 1 
		if event.is_action_pressed(_actions.right, true): dir += 1
		_handle_steering(dir)


func _handle_engine_force(pressed: bool) -> void:
	engine_force = _engine_force if pressed else 0.


func _handle_brake(just_pressed: bool, just_released: bool) -> void:
	if just_pressed:
		brake = _brake_force
		engine_force = 0
		brake = _brake_force
	if just_released:
		brake = 0
		brake = 0


func _handle_steering(dir: int) -> void:
	var s = _max_steering * -dir
	var tween = create_tween() 
	tween.tween_property(self, "steering", s, _steering_time)
	tween = _models.handlebar.create_tween()
	tween.tween_property(_models.handlebar, "rotation", Vector3(_models.handlebar.basis.get_euler().x, s, 0), _steering_time)


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if _wheels.back.get_rpm() >= _max_rpm:
		engine_force = 0
	if not(_wheels.front.is_in_contact() or _wheels.back.is_in_contact()):
		_pid.reset()
		return
	var b = state.transform.basis
	var proj = (Vector3.UP - Vector3.UP.project(b.z)).normalized()
	var tilt = proj.signed_angle_to(b.y, b.z)
	if not is_zero_approx(tilt):
		var correction = _pid.update(rad_to_deg(tilt), 0, state.step) * clampf(1 - _wheels.back.get_rpm()/_max_rpm, _minimal_tilt_stabilizing_factor, 1)
		state.apply_torque(global_basis.z * deg_to_rad(correction) * _tilt_stabilizing_factor * mass)
		

	
		
