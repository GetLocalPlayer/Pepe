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



@onready var _model: Node3D = $aigirl
@onready var _interactable_detector = $InteractableDetector
@onready var _ui = {
	interaction = get_node("/root/Interaction"),
	inventory = get_node("/root/Inventory"),
}


@onready var _collision_shape: CollisionShape3D = $CollisionShape3D
@onready var _stairs_detector: PepeStairsDetector = $StairsDetector
@onready var _hands_ik_controller: CCDIK3D = %HandsIKController
@onready var _left_hand_ik_target: Marker3D = $LeftHandIKTarget
@onready var _right_hand_ik_target: Marker3D = $RightHandIKTarget
enum ik_target_type {LEFT_HAND, RIGHT_HAND}


var _input_actions: Dictionary[String, String] = {
	action = "Action",
	inventory = "OpenInventory",
}


func get_ik_target(type: ik_target_type) -> Marker3D:
	match type:
		ik_target_type.LEFT_HAND:
			return _left_hand_ik_target
		ik_target_type.RIGHT_HAND:
			return _right_hand_ik_target
	return null


func enable_hands_ik() -> void:
	_hands_ik_controller.active = true


func disable_hands_ik() -> void:
	_hands_ik_controller.active = false

	
func get_animation_tree() -> AnimationTree:
	return $AnimationTree



func _input(event):
	if event as InputEventKey: _handle_input_actions(event)


func _handle_input_actions(event: InputEventKey) -> void:
	if event.is_action(_input_actions.action):
		if _interactable_detector.has_overlapping_areas():
			get_viewport().set_input_as_handled()
			var interactables: Array[Area3D] = _interactable_detector.get_overlapping_areas()
			interactables.sort_custom(func(a, b): return a.interaction_priority > b.interaction_priority)
			(interactables[0] as Interactable).interact()
	if event.is_action(_input_actions.inventory):
		get_viewport().set_input_as_handled()
		_ui.inventory.open()


func enable_collision() -> void:
	_collision_shape.set_deferred("disabled", false)
	_stairs_detector.enable.call_deferred()
	_interactable_detector.monitoring = true


func disable_collision() -> void:
	_collision_shape.set_deferred("disabled", true)
	_stairs_detector.disable.call_deferred()
	_interactable_detector.monitoring = false


func get_overlaping_scooter() -> Scooter:
	for b: Node3D in _interactable_detector.get_overlapping_bodies():
		if b is Scooter:
			return b as Scooter
	return null


func get_model() -> Node3D:
	return _model