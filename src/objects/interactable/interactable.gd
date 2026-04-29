extends Area3D
class_name Interactable


signal camera_switched_in
signal camera_switched_out


@export_multiline var _lines: Array[String]: get = _get_lines
@export var _options: Array[String]
# To avoid conflicts with @tool script in child classes
@onready var _ui: InteractableUI = $UI
@onready var _screen_effect = null if Engine.is_editor_hint() else get_node("/root/ScreenEffect")
# Interactables with bigger interaction priority take adventage
@export var interaction_priority: int
@export var _fade_in_out_color = Color.BLACK
@export var _fade_in_out_time = 0.5
@onready var _camera: Camera3D = $Camera3D
var _switched_camera: Camera3D


func has_camera() -> bool:
	return _camera.visible


func _ready() -> void:
	if owner:
		_ui.hide()


func _get_lines() -> Array[String]:
	return _lines
	

func _run() -> Variant:
	_ui.show()
	_ui.run(_lines, _options)
	var result = await _ui.lines_finished if _options.is_empty() else await _ui.option_pressed
	_ui.hide()
	return result


func _switch_camera() -> void:
	await _screen_effect.fade_in(_fade_in_out_color, _fade_in_out_time)
	if not _camera.current:
		_switched_camera = get_viewport().get_camera_3d()
		_camera.make_current()
		camera_switched_in.emit()
	else:
		_switched_camera.make_current()
		_switched_camera = null
		camera_switched_out.emit()
	await _screen_effect.fade_out(_fade_in_out_color, _fade_in_out_time)


func interact() -> Variant:
	get_tree().paused = true
	process_mode = PROCESS_MODE_ALWAYS
	if has_camera(): await _switch_camera()
	var result = await _run()
	if has_camera(): await _switch_camera()
	get_tree().paused = false
	process_mode = PROCESS_MODE_INHERIT
	return result
