extends PepeIdle
class_name PepeExhausted


var _restored_stamina: float


func _enter(context: Node):
	get_playback(context).travel(animation.states.exhausted)
	_restored_stamina = 0


func _update(context: Node, delta: float):
	super._update(context, delta)
	var pepe = context as Pepe
	_restored_stamina += pepe.stamina
	pepe.stamina = _restored_stamina if _restored_stamina >= pepe.max_stamina else 0.0


func _handle_input(_context: Node, _event: InputEvent): pass
