extends PepeWalking
class_name PepeRunning


func _enter(context: Node):
    get_playback(context).travel(animation.states.running)


func _update(context: Node, delta: float):
    super._update(context, delta)
    (context as Pepe).stamina -= delta
