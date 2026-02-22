extends Node
class_name FiniteStateMachine


var _current_state: State

func _get_context() -> Node:
	return get_parent()


func _get_initial_state() -> State:
	return get_children().filter(func(x:Node) -> bool: return x is State).front() as State


func _set_state(new_state: State):
	if _current_state != null:
		_current_state._exit(_get_context())
	_current_state = new_state
	if new_state != null:
		new_state._enter(_get_context())


func _update_current_state(delta: float):
	_current_state._update(_get_context(), delta)


func _ready():
	var states = get_children().filter(func(x:Node) -> bool: return x is PepeState)
	for s in states:
		s.process_mode = Node.PROCESS_MODE_DISABLED
	_set_state(_get_initial_state())


func _input(event):
	if _current_state != null:
		_current_state._handle_input(_get_context(), event)


func _physics_process(delta):
	_current_state._handle_input(_get_context(), null)
	if _current_state != null:
		_update_current_state(delta)
