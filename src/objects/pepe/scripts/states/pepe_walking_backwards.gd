extends PepeWalking
class_name PepeWalkingBackwards


func _enter(context: Node):
	get_playback(context).travel(animation.states.walking_backwards)
