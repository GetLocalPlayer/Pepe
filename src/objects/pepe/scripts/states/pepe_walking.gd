extends PepeIdle
class_name PepeWalking


func _init():
	_anim_param.path = "parameters/Walking/BlendSpace1D/blend_position"


func _enter(context: Node):
	get_playback(context).travel(animation.states.walking)
	_handle_input(context, null)


func _update(context: Node, delta: float):
	var body = context as CharacterBody3D;
	var anim_tree = get_animation_tree(context)
	var rm_rotation = anim_tree.get_root_motion_rotation()
	var rm_position = anim_tree.get_root_motion_position()
	body.quaternion *= rm_rotation
	body.velocity = (anim_tree.get_root_motion_rotation_accumulator().inverse() * body.quaternion) * rm_position / delta
	body.move_and_slide()

