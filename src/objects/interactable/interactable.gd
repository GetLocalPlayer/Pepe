extends StaticBody3D


@export var _lines: Array[String]
@onready var _interaction_ui = get_node("/root/Interaction")


func interact():
	_interaction_ui.run(_lines)
	await _interaction_ui.finished