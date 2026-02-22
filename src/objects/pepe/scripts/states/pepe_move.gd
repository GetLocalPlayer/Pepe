extends PepeState
class_name PepeMove


enum Modes {WALK, RUN, SPRINT}
enum Directions {LEFT = -1, STRAIGHT = 0, RIGHT = 1}

var backwards: bool = false
var direction = 0
var mode = 0 

func _enter(_context: Node) -> void:
	super._enter(_context)


func _update(_context: Node, delta: float) -> void:
	var pepe = _context as Pepe
	backwards = Input.is_action_pressed(input_actions.backwards)
	if not backwards and mode == Modes.SPRINT:
		pepe.stamina -= pepe.stamina_consumption_rate * delta
	if pepe.exhausted:
		mode = Modes.WALK
	var anim_tree = pepe.get_animation_tree()
	var rm_position = anim_tree.get_root_motion_position()
	var rm_rotation = anim_tree.get_root_motion_rotation()
	pepe.model.quaternion *= rm_rotation
	pepe.velocity = pepe.model.quaternion * rm_position / delta
	pepe.move_and_slide()


func _handle_input(_context: Node, _event: InputEvent) -> void:
	backwards = Input.is_action_pressed(input_actions.backwards)
	if Input.is_action_pressed(input_actions.walk):
		mode = Modes.WALK
	elif Input.is_action_pressed(input_actions.sprint):
		mode = Modes.SPRINT
	else:
		mode = Modes.RUN
	direction = Directions.STRAIGHT
	direction += Directions.LEFT if Input.is_action_pressed(input_actions.left) else 0
	direction += Directions.RIGHT if Input.is_action_pressed(input_actions.right) else 0


func _exit(_context: Node) -> void: pass