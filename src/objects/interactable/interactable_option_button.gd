@tool
extends Button
class_name InteractableOptionButton


@onready var _label = $Label


@export var _normal_font_size = 32:
	get:
		return _normal_font_size
	set(value):
		_normal_font_size = value
		if is_node_ready(): _on_focus_changed()

@export var _focused_font_size = 48


func _ready() -> void:
	material = material.duplicate()
	focus_entered.connect(_on_focus_changed)
	focus_exited.connect(_on_focus_changed)
	_label.set("theme_override_font_sizes/font_size", _normal_font_size)


func _on_focus_changed():
	(material as ShaderMaterial).set_shader_parameter("flashing_enabled", has_focus())
	_label.set("theme_override_font_sizes/font_size", _focused_font_size if has_focus() else _normal_font_size)


func set_label_text(_text: String) -> void:
	_label.text = _text
