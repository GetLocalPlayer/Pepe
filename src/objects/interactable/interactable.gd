extends Area3D
class_name Interactable


@export var _lines: Array[String]
# To avoid conflicts with @tool script in child classes
@onready var _interaction_ui = null if Engine.is_editor_hint() else get_node("/root/Interaction")



func interact():
	_interaction_ui.run(_lines)
	await _interaction_ui.finished
