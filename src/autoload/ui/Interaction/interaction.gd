extends Control


signal finished

@onready var _label = $Text
var _text_lines: Array


func _on_visibility_changed():
    get_tree().paused = visible


func _ready():
    hide()
    visibility_changed.connect(_on_visibility_changed)


func _input(_event):
    if visible and Input.is_action_just_pressed("Action"):
        if _text_lines.is_empty():
            _label.text = ""
            hide()
        else:
            _label.text = _text_lines.pop_back()


func run(lines: Array):
    if lines.is_empty():
        push_error("`lines` cannot be empty!")
    _text_lines = lines.duplicate()
    _text_lines.reverse()
    _label.text = _text_lines.pop_back()
    show()