extends PepeState
class_name PepeMove


enum Modes {WALK, RUN, SPRINT}
enum Directions {LEFT = -1, STRAIGHT = 0, RIGHT = 1}

var backwards: bool = false
var direction = Directions.STRAIGHT
var mode = 0 

func _enter(_context: Node) -> void:
	super._enter(_context)


func _update(_context: Node, delta: float) -> void:
	var pepe = _context as Pepe
	backwards = Input.is_action_pressed(input_actions.backwards)
	if not backwards and mode == Modes.SPRINT:
		pepe.stamina -= pepe.stamina_consumption_rate * delta
	var anim_tree = pepe.get_animation_tree()
	var rm_position = anim_tree.get_root_motion_position()
	var rm_rotation = anim_tree.get_root_motion_rotation()
	pepe.model.quaternion *= rm_rotation
	pepe.velocity = pepe.model.quaternion * rm_position / delta
	pepe.move_and_slide()


func _handle_input(_context: Node, event: InputEvent) -> void:
	var e = event as InputEventKey
	if not e: return
	backwards = Input.is_action_pressed(input_actions.backwards)
	if e.is_action(input_actions.walk) and e.pressed and not e.echo:
		mode = Modes.WALK if mode != Modes.WALK else Modes.RUN
	if (_context as Pepe).exhausted:
		mode = Modes.WALK
	elif Input.is_action_pressed(input_actions.sprint):
		mode = Modes.SPRINT
	elif mode != Modes.WALK:
		mode = Modes.RUN
	var dir = Directions.STRAIGHT as int
	dir += Directions.LEFT if Input.is_action_pressed(input_actions.left) and e.pressed else 0
	dir += Directions.RIGHT if Input.is_action_pressed(input_actions.right) and e.pressed else 0
	direction = dir as Directions


func _exit(_context: Node) -> void: pass
