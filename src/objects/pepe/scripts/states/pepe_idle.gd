extends PepeState
class_name PepeIdle


var _anim_param = {
	path = "parameters/Idle/blend_position",
	tween_time = 0.3,
}



func _enter(context: Node):
	get_playback(context).travel(animation.states.idle)
	_handle_input(context, null)


func _update (context: Node, delta: float):
	var body = context as CharacterBody3D;
	var anim_tree = get_animation_tree(context)
	if anim_tree.get_process_delta_time() > 0:
		var rm_rotation = anim_tree.get_root_motion_rotation()
		var rm_position = anim_tree.get_root_motion_position()
		body.quaternion *= rm_rotation
		body.velocity = (anim_tree.get_root_motion_rotation_accumulator().inverse() * body.quaternion) * rm_position / anim_tree.get_process_delta_time()
		body.move_and_slide()

	var pepe = context as Pepe
	pepe.stamina += delta * pepe.stamina_restoration_rate


func _handle_input(context: Node, _event: InputEvent):
	var anim_tree = get_animation_tree(context)
	var new_value = 0
	new_value -= 1 if Input.is_action_pressed(input_actions.left) else 0
	new_value += 1 if Input.is_action_pressed(input_actions.right) else 0
	var tween = anim_tree.create_tween()
	tween.tween_property(anim_tree, _anim_param.path, new_value, _anim_param.tween_time)


func _exit(_context: Node): pass

