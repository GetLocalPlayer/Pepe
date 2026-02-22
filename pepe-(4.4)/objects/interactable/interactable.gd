extends Area3D
class_name Interactable


@export_multiline var _lines: Array[String]
@export var _options: Array[String]
# To avoid conflicts with @tool script in child classes
@onready var _interaction_ui = null if Engine.is_editor_hint() else get_node("/root/Interaction")
@onready var _screen_effect = null if Engine.is_editor_hint() else get_node("/root/ScreenEffect")
# Interactables with bigger interaction priority take adventage
@export var interaction_priority: int
@export var _fade_in_out_color = Color.BLACK
@export var _fade_in_out_time = 0.5
@onready var _camera: Camera3D = $Camera3D



func interact():
	var current_camera = get_viewport().get_camera_3d()
	if _camera.visible:
		await _screen_effect.fade_in(_fade_in_out_color, _fade_in_out_time)
		_camera.make_current()
		await _screen_effect.fade_out(_fade_in_out_color, _fade_in_out_time)
	if _options.is_empty():
		_interaction_ui.run(_lines)
	else:
		_interaction_ui.run_options(_lines, _options)
	var result = await _interaction_ui.finished
	if _camera.visible:
		await _screen_effect.fade_in(_fade_in_out_color, _fade_in_out_time)
		current_camera.make_current()
		await _screen_effect.fade_out(_fade_in_out_color, _fade_in_out_time)
	return result