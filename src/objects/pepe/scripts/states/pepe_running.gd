extends PepeWalking
class_name PepeRunning


func _init():
	_anim_param.path = "parameters/Running/BlendSpace1D/blend_position"
	_anim_param.tween_time = 0.15

	
func _enter(context: Node):
	get_playback(context).travel(animation.states.running)
	_handle_input(context, null)


func _update(context: Node, delta: float):
	super._update(context, delta)
	# Consume stamina during running
	(context as Pepe).stamina -= delta
