extends FiniteStateMachine


@onready var _states: Dictionary[String, PepeState] = {
	idle = $Idle,
	move = $Move,
	#exhausted = $Exhausted,
}

@onready var _debug_label = $Debug


func _process(_delta: float) -> void:
	if _debug_label.visible:
		_debug_label.text = "Curr. state: %s" % _current_state.name if _current_state else "no state"


func _set_state(new_state: State):
	if new_state != _current_state:
		super._set_state(new_state)


func _update_current_state(delta: float):
	super._update_current_state(delta)

	var pepe = _get_context() as Pepe

	pepe.apply_floor_snap() # only for testing, delete later

	if pepe.is_on_floor():
		if Input.is_action_pressed("Move"):
			_set_state(_states.move)
		else:
			_set_state(_states.idle)
