extends PepeWalking
class_name PepeWalkingBackwards


func _init():
	_anim_param.path = "parameters/WalkingBackwards/BlendSpace1D/blend_position"


func _enter(context: Node):
	get_playback(context).travel(animation.states.walking_backwards)
	_handle_input(context, null)


func _update(context: Node, delta: float):
	var anim_tree = get_animation_tree(context)
	super._update(context, -delta if anim_tree.get(_anim_param.path) != 0 else delta)
