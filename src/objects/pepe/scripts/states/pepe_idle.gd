extends PepeState
class_name PepeIdle


enum Directions { LEFT = -1, STRAIGHT = 0, RIGHT = 1}

var _accumulated_stamina: float

var exhausted: bool = false
var direction: int = 0


func _enter(context: Node):
	super._enter(context)
	_accumulated_stamina = 0
	exhausted = (context as Pepe).exhausted
	_handle_input(context, null)


func _update (context: Node, delta: float):
	var pepe = context as Pepe
	if direction:
		var anim_tree = pepe.get_animation_tree()
		var rm_rotation = anim_tree.get_root_motion_rotation()
		pepe.model.quaternion *= rm_rotation

	var restored_stamina = delta * pepe.stamina_restoration_rate 
	if exhausted:
		_accumulated_stamina += restored_stamina
		if _accumulated_stamina >= pepe.max_stamina:
			pepe.stamina = pepe.max_stamina
	else:
		pepe.stamina += restored_stamina
	exhausted = pepe.exhausted


func _handle_input(_context: Node, _event: InputEvent):
	direction = Directions.STRAIGHT
	if Input.is_action_pressed(input_actions.left):
		direction += Directions.LEFT
	if Input.is_action_pressed(input_actions.right):
		direction += Directions.RIGHT


func _exit(_context: Node) -> void: pass