extends VBoxContainer


signal finished(taken: bool)


@export var _item_scale_tween_time = 0.75

@onready var _buttons = {
	yes = %YesButton,
	no = %NoButton,
}

@onready var _item_scroll = %ItemScroll
@onready var _item_list = %ItemList
@onready var _description = %Descritpion
@onready var _description_button = %DescriptionButton


func _ready():
	visibility_changed.connect(_on_visibility_changed)
	_buttons.yes.grab_focus.call_deferred()
	_buttons.yes.pressed.connect(_on_yes_pressed)
	_buttons.no.pressed.connect(_on_no_pressed)
	hide()



func _on_no_pressed():
	_close()
	finished.emit(false)


func _on_yes_pressed():
	_close()
	finished.emit(true)


func _close():
	_buttons.yes.hide()
	_buttons.no.hide()
	_description.hide()
	var tween = create_tween()
	var item_scroll_scale = _item_scroll.scale
	tween.tween_property(_item_scroll, "scale", Vector2(0, 0), _item_scale_tween_time)
	await tween.parallel().tween_interval(_item_scale_tween_time).finished
	_item_scroll.scale = item_scroll_scale
	hide()


func _on_visibility_changed():
	get_tree().paused = visible


func run(item_name: String, amount: int, lines: Array[String]) -> void:
	if not _item_list.has_node(item_name):
		push_warning("No item `%s` found in the ItemList.tscn!" % item_name)
		return
	if lines.is_empty():
		push_error("Lines cannot be empty!")
		return
		
	show()
	
	for i in _item_list.get_children():
		i.amount = amount if i.name == item_name else 0

	var tween = create_tween()
	tween.tween_property(_item_scroll, "scale", _item_scroll.scale, _item_scale_tween_time)
	tween.parallel().tween_callback(_buttons.yes.show).set_delay(_item_scale_tween_time)
	_item_scroll.scale = Vector2(0, 0)
	_buttons.yes.hide()
	_buttons.no.hide()
	_description.hide()
	await tween.parallel().tween_interval(_item_scale_tween_time).finished

	_description.show()
	_description_button.grab_focus()
	for i in range(lines.size() - 1):
		_description.text = lines[i]
		await _description_button.pressed
	_description.text = lines.back()
	_buttons.yes.show()
	_buttons.yes.grab_focus()
	_buttons.no.show()
