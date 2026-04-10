extends CollisionShape3D
class_name PepeStairsDetector


@export_range(1, 100, 1) var count: int = 16
var _detectors: Array[CollisionShape3D] = [self]


func _ready() -> void:
	get_parent().ready.connect(_on_parent_ready, CONNECT_ONE_SHOT)


func _on_parent_ready() -> void:
	var angular_step: float = TAU / count
	var last_pos: Vector3 = position
	for i in count - 1:
		var n: CollisionShape3D = duplicate()
		get_parent().add_child(n)
		_detectors.append(n)
		last_pos = last_pos.rotated(Vector3.UP,  angular_step)
		n.position = last_pos


func disable() -> void:
		for d in _detectors:
			d.disabled = true


func enable() -> void:
	for d in _detectors:
		d.disabled = false