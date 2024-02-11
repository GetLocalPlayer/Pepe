extends State
class_name PepeState


var animation = {
    node_path = "AnimationTree",
    playback_path = "parameters/playback",
    states = {
        idle = "Idle",
        exhausted = "Exhausted",
        walking = "Walking",
        running = "Running",
        walking_backwards = "WalkingBackwards",
    },
}


var input_actions = {
    left = "TurnLeft",
    right = "TurnRight",
}


func get_animation_tree(context: Node) -> AnimationTree:
    return context.get_node(animation.node_path)


func get_playback(context: Node) -> AnimationNodeStateMachinePlayback:
    return get_animation_tree(context).get(animation.playback_path)