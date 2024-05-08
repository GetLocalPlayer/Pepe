@tool
extends Button

@onready var _shader = material as ShaderMaterial
@export var _normal_font_size = 32:
	get:
		return _normal_font_size
	set(value):
		_normal_font_size = value
		_on_focus_changed()

@export var _focused_font_size = 48


func _ready():
	focus_entered.connect(_on_focus_changed)
	focus_exited.connect(_on_focus_changed)
	set("theme_override_font_sizes/font_size", _normal_font_size)


func _on_focus_changed():
	_shader.set_shader_parameter("flashing_enabled", has_focus())
	set("theme_override_font_sizes/font_size", _focused_font_size if has_focus() else _normal_font_size)
	print(has_focus())