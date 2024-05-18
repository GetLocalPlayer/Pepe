extends Control


signal finished(int)

@onready var _label: RichTextLabel = %Text
@onready var _text_button: Button = %ButtonNext
@onready var _buttons: Array[Button] = [%Button1, %Button2, %Button3, %Button4]


func _on_visibility_changed():
	get_tree().paused = visible


func _ready():
	hide()
	visibility_changed.connect(_on_visibility_changed)
	for btn in _buttons:
		btn.pressed.connect(_on_button_pressed.bind(btn))


func _on_button_pressed(btn: Button):
	finished.emit(_buttons.find(btn))
	hide()


func run(lines: Array):
	if lines.is_empty():
		push_error("`lines` cannot be empty!")
	run_options(lines, [])



"""
	Accepts lines and names for buttons.
"""
func run_options(lines: Array[String], button_names: Array[String]):
	for btn in _buttons:
		btn.hide()
	show()
	_text_button.grab_focus()
	for s in lines:
		_label.text = "[center]%s" % s
		await _text_button.pressed

	if button_names.is_empty():
		finished.emit(-1)
		hide()
		return
	
	for i in range(button_names.size() if button_names.size() <= _buttons.size() else _buttons.size()):
		var btn = _buttons[i]
		btn.show()
		btn.text = button_names[i]

	_buttons[0].grab_focus()
	
	
