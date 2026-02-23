extends CharacterBody3D
class_name Pepe


signal gets_exhausted
signal stamina_restored


@export var max_health = 100

@export var health: float = max_health:
	get:
		return health
	set(value):
		health = value if value >= 0 and value <= max_health else health

@export var gravity: float = 10
@export var turn_speed: float = 60
@export var max_stamina:float = 20
## Per second
@export var stamina_restoration_rate: float = 5
## Per second
@export var stamina_consumption_rate: float = 10
@export var stamina: float = max_stamina:
	get:
		return stamina
	set(value):
		var emit_restored = stamina < max_stamina and value >= max_stamina
		stamina = clampf(value, 0, max_stamina)
		exhausted = stamina <= 0
		if emit_restored:
			stamina_restored.emit()
		


var exhausted: bool = stamina <= 0:
	set(value):
		var emit_gets_exhausted = not exhausted and value
		exhausted = value
		if emit_gets_exhausted:
			gets_exhausted.emit()



@onready var model: Node3D = $aigirl
@onready var _interactable_detector = $InteractableDetector
@onready var _ui = {
	interaction = get_node("/root/Interaction"),
	inventory = get_node("/root/Inventory"),
}

func get_animation_tree() -> AnimationTree:
	return $AnimationTree


func _input(_event):
	if Input.is_action_just_pressed("Action"):
		if _interactable_detector.has_overlapping_areas():
			get_viewport().set_input_as_handled()
			var interactables: Array[Area3D] = _interactable_detector.get_overlapping_areas()
			interactables.sort_custom(func(a, b): return a.interaction_priority > b.interaction_priority)
			(interactables[0] as Interactable).interact()
	if Input.is_action_just_pressed("OpenInventory"):
		get_viewport().set_input_as_handled()
		_ui.inventory.open()
