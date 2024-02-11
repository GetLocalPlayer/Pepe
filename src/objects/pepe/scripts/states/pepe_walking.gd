extends PepeState
class_name PepeWalking


func _enter(context: Node):
    get_playback(context).travel(animation.states.walking)


func _update(context: Node, delta: float):
    var anim_tree = get_animation_tree(context)
    var motion = anim_tree.get_root_motion_position() / delta
    var pepe = context as Pepe
    var rotation = 0
    rotation += pepe.turn_speed if Input.is_action_pressed(input_actions.left) else 0
    rotation -= pepe.turn_speed if Input.is_action_pressed(input_actions.right) else 0
    var body = context as CharacterBody3D
    body.rotate_y(deg_to_rad(rotation) * delta)
    body.velocity = (
        body.transform.basis.get_rotation_quaternion() * 
        Vector3(motion.x, 0, motion.z)
    )
    body.move_and_slide()


func _handle_input(_context: Node, _event: InputEvent): pass
func _exit(_context: Node): pass