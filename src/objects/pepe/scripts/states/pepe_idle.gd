extends State
class_name PepeIdle


var _animation = {
    node_path = "AnimationTree",
    playback_path = "parameters/playback",
    param_path = "parameters/Idle/blend_position",
    param_tween_time = 0.3,
    state = "Idle",
}

var _input_actions = {
    left = "TurnLeft",
    right = "TurnRight",
}


func _enter(context: Node):
    var anim_tree: AnimationTree = context.get_node(_animation.node_path)
    var playback = anim_tree.get(_animation.playback_path)
    playback.travel(_animation.state)
    _handle_input(context, null)
    var body = context as CharacterBody3D
    var pepe = context as Pepe
    body.velocity = Vector3.UP * (-pepe.gravity);


func _update (context: Node, delta: float):
    var body = context as CharacterBody3D;
    var anim_tree: AnimationTree = context.get_node(_animation.node_path) 
    var rotation = anim_tree.get_root_motion_rotation() / delta
    body.rotate_y(rotation.normalized().get_euler(EULER_ORDER_YXZ).y)
    var pepe: Pepe = context
    pepe.stamina += delta * pepe.stamina_restoration_rate


func _handle_input(context: Node, _event: InputEvent):
    var anim_tree: AnimationTree = context.get_node(_animation.node_path)
    var param_value = 0
    param_value -= 1 if Input.is_action_pressed(_input_actions.left) else 0
    param_value += 1 if Input.is_action_pressed(_input_actions.right) else 0
    var tween = anim_tree.create_tween()
    tween.tween_property(anim_tree, _animation.param_path, param_value, _animation.param_tween_time)


func _exit(_context: Node):
    pass

