extends CharacterBody3D
class_name Pepe

@export var max_health = 100

@export var health: float = max_health:
	get:
		return health
	set(value):
		health = value if value >= 0 and value <= max_health else health

@export var gravity: float = 10
@export var turn_speed: float = 60
@export var max_stamina:float = 20
@export var stamina_restoration_rate: float = 5 # per second
@export var stamina: float = max_stamina:
	get:
		return stamina
	set(value):
		stamina = 0.0 if value < 0.0 else max_stamina if value > max_stamina else value

var exhausted: bool:
	get:
		return stamina <= 0


@onready var _interactable_detector = $InteractableDetector
@onready var _ui = {
	interaction = get_node("/root/Interaction"),
	inventory = get_node("/root/Inventory"),
}


func _input(_event):
	if Input.is_action_just_pressed("Action"):
		if _interactable_detector.has_overlapping_areas():
			get_viewport().set_input_as_handled()
		for a in _interactable_detector.get_overlapping_areas():
			a.interact()
	if Input.is_action_just_pressed("OpenInventory"):
		get_viewport().set_input_as_handled()
		_ui.inventory.open()
