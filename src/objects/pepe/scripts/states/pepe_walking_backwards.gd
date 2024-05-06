extends PepeWalking
class_name PepeWalkingBackwards


func _init():
	_anim_param.path = "parameters/WalkingBackwards/BlendSpace1D/blend_position"


func _enter(context: Node):
	get_playback(context).travel(animation.states.walking_backwards)
	_handle_input(context, null)

