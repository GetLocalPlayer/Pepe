extends FiniteStateMachine


@onready var _states: Dictionary[String, PepeState] = {
	idle = $Idle,
	move = $Move,
	driving = $Driving
}

@onready var _driving_allowed_states: Array[PepeState] = [_states.idle, _states.move]

@onready var _debug_label = $Debug


var _input_actions: Dictionary[String, String] = {
	mount_dismount = "MountDismount",
}


func _process(_delta: float) -> void:
	if _debug_label.visible:
		_debug_label.text = "Curr. state: %s" % _current_state.name if _current_state else "no state"


func _set_state(new_state: State):
	if new_state != _current_state:
		super._set_state(new_state)


func _update_current_state(delta: float):
	super._update_current_state(delta)
	var pepe = _get_context() as Pepe
	if pepe.is_on_floor():
		if Input.is_action_pressed("Move"):
			_set_state(_states.move)
		else:
			_set_state(_states.idle)


func _input(event) -> void:
	var e = event as InputEventKey
	if e and e.is_action(_input_actions.mount_dismount) and not e.is_echo() and e.pressed:
		var pepe = _get_context() as Pepe
		if _current_state == _states.driving:
			var vehicle = pepe.get_parent() as Scooter
			vehicle.remove_driver()
			_set_state(_states.idle)
		if _current_state in _driving_allowed_states:
			var vehicle = pepe.get_overlaping_scooter() as Scooter
			if vehicle:
				vehicle.set_driver(pepe)
				_set_state(_states.driving)
	else:
		super._input(event)
	
