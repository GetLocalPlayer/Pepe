extends State
class_name PepeState


var input_actions = {
	left = "TurnLeft",
	right = "TurnRight",
	sprint = "Sprint",
	walk = "Walk",
	backwards = "WalkBackwards",
}


func _enter(_context: Node) -> void:
	var pepe = _context as Pepe
	pepe.get_animation_tree().advance_expression_base_node = get_path()
	pepe.get_animation_tree().get("parameters/playback").travel(name)
