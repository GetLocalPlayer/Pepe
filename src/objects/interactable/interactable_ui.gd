extends Control
class_name InteractableUI


signal option_pressed(intex: int)
signal lines_finished


@export var _label_appearing_rate: int = 50 # chars per second
@onready var _label: RichTextLabel = $Text
@onready var _next_line_button: Button = $Text/NextLineButton
@onready var _option_button_container: Control = $Options/Buttons
@onready var _base_option_button: InteractableOptionButton = $Options/Buttons/BaseButton
var _option_buttons: Array[InteractableOptionButton] = []
var _recycled_option_buttons: Array[InteractableOptionButton] = []


func _get_option_button() -> Button:
	var btn: Button
	if _recycled_option_buttons.is_empty():
		btn = _base_option_button.duplicate()
		btn.pressed.connect(_on_option_pressed.bind(btn))
	else:
		btn = _recycled_option_buttons.pop_front()
	return btn


func _on_option_pressed(btn: Button) -> void:
	var index = _option_buttons.find(btn)
	clear_options()
	option_pressed.emit(index)


func _recycle_option_button(btn: Button) -> void:
	btn.set_label_text("")
	btn.hide()
	btn.get_parent().remove_child(btn)
	_recycled_option_buttons.append(btn)



func _ready() -> void:
	hide()
	clear_lines()
	_next_line_button.hide()
	_option_button_container.remove_child(_base_option_button)
	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	if visible:
		clear_lines()
		clear_options()


func run(lines: Array[String], options: Array[String]) -> void:
	await run_lines(lines)
	lines_finished.emit()
	run_options(options)


func run_lines(lines: Array[String]) -> void:
	clear_lines()
	if lines.is_empty():
		return
	_label.show()
	show()
	_next_line_button.show()
	_next_line_button.grab_focus()
	for s in lines:
		_label.text = "[center]%s" % s
		_label.visible_characters = 0
		var tween = _label.create_tween()
		tween.tween_property(_label, "visible_characters", _label.text.length(), float(s.length()) / float(_label_appearing_rate))
		await _next_line_button.pressed
		_label.visible_characters = -1
		tween.stop()
	_next_line_button.hide()


func run_options(options: Array[String]) -> void:
	if options.is_empty():
		return
	show()
	for s: String in options:
		var btn: Button = _get_option_button()
		_option_buttons.append(btn)
		_option_button_container.add_child(btn)
		btn.set_label_text(s)
		btn.show()

	_option_buttons[0].grab_focus()
	
	
func clear_options() -> void:
	while not _option_buttons.is_empty():
		_recycle_option_button(_option_buttons.pop_back())


func clear_lines() -> void:
	_label.text = ""
	_label.hide()