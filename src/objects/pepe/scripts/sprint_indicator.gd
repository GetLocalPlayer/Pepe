extends VBoxContainer


@onready var _pepe: Pepe = owner
@onready var _bar: ProgressBar = $Bar


func _process(_delta: float) -> void:
	visible = _pepe.stamina < _pepe.max_stamina
	_bar.value = _pepe.stamina/_pepe.max_stamina
