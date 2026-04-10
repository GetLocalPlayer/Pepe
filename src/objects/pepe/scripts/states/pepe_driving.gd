extends PepeState
class_name PepeDriving


func _enter(_context: Node) -> void:
	super._enter(_context)
	var pepe = _context as Pepe
	pepe.disable_collision()
	pepe.get_model().basis = Basis.IDENTITY
	var vehicle = pepe.get_parent() as Scooter
	vehicle.set_hands_ik(pepe.get_ik_target(pepe.ik_target_type.LEFT_HAND), pepe.get_ik_target(pepe.ik_target_type.RIGHT_HAND))
	pepe.enable_hands_ik()


func _exit(_context: Node) -> void:
	var pepe =_context as Pepe
	pepe.enable_collision()
	pepe.disable_hands_ik()
	pepe.get_model().basis = Basis.IDENTITY
	pepe.global_basis = Basis.IDENTITY


func _update (_context: Node, _delta: float): pass
func _handle_input(_context: Node, _event: InputEvent): pass