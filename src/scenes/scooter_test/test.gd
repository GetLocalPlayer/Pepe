extends WorldEnvironment


@onready var _scooter: Scooter = $Scooter
@onready var _driver: Node3D = $TestDriver


func _ready() -> void:
	_scooter.set_driver(_driver)