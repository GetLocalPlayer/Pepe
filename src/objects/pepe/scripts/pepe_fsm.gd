extends FiniteStateMachine


var _states = {
	idle = PepeIdle.new(),
	exhausted = PepeExhausted.new(),
	walking = PepeWalking.new(),
	walking_backwards = PepeWalkingBackwards.new(),
	running = PepeRunning.new(),
}



func _get_initial_state() -> State:
	return _states.idle


func _set_state(new_state: State):
	if new_state != _current_state:
		super._set_state(new_state)


func _update_current_state(delta: float):
	super._update_current_state(delta)

	var pepe = _get_context() as Pepe
	var body = _get_context() as CharacterBody3D

	body.apply_floor_snap() # only for testing, delete later

	if body.is_on_floor():
		if Input.is_action_pressed("Move"):
			if Input.is_action_pressed("WalkBackwards"):
				_set_state(_states.walking_backwards)
			elif Input.is_action_pressed("RunModifier") and not pepe.exhausted:
				_set_state(_states.running)
			else:
				_set_state(_states.walking)
		else:
			_set_state(_states.exhausted if pepe.exhausted else _states.idle)