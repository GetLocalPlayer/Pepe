extends Area3D
class_name Interactable


@export_multiline var _lines: Array[String]
@export var _options: Array[String]
# To avoid conflicts with @tool script in child classes
@onready var _interaction_ui = null if Engine.is_editor_hint() else get_node("/root/Interaction")
@export var interaction_priority: int



func interact():
	if _options.is_empty():
		_interaction_ui.run(_lines)
	else:
		_interaction_ui.run_options(_lines, _options)
	return await _interaction_ui.finished