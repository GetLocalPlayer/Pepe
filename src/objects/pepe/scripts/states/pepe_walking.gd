extends PepeIdle
class_name PepeWalking


func _init():
	_anim_param.path = "parameters/Walking/BlendSpace1D/blend_position"


func _enter(context: Node):
	get_playback(context).travel(animation.states.walking)
	_handle_input(context, null)


func _update(context: Node, delta: float):
	var pepe = context as Pepe
	var stamina = pepe.stamina
	super._update(pepe, delta)
	# Do not restore stamina during moving
	pepe.stamina = stamina

