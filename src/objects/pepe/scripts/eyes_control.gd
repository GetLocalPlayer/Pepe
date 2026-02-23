extends Node

@export var _eyes_uv_controller_path: NodePath = ""
@export var _eyes_path: NodePath = ""
@export var _eyes_material_index = 0


@onready var _pepe: Pepe = owner
var _blend_param_path = "parameters/Eyes/blend_position"
var _requiest_param_path = "parameters/Moving/request"
@onready var _anim_tree: AnimationTree = get_parent()
var _blending = {
	blink = 0,
	exhausted = -1,
}



func _ready() -> void:
	_pepe.stamina_restored.connect(func() -> void:
		_anim_tree.set(_blend_param_path, _blending.blink)
		_anim_tree.set(_requiest_param_path, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	)
	_pepe.gets_exhausted.connect(func() -> void:
		_anim_tree.set(_blend_param_path, _blending.exhausted)
		_anim_tree.set(_requiest_param_path, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	)


func _process(_delta: float) -> void:
	var controller = get_node_or_null(_eyes_uv_controller_path) as Node3D
	var material = get_node(_eyes_path).mesh.surface_get_material(_eyes_material_index) as BaseMaterial3D
	if controller and material:
		material.uv1_offset = Vector3(controller.position.x , controller.position.z, material.uv1_offset.y)