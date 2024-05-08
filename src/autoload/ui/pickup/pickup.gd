extends VBoxContainer


@export var _item_scale_tween_time = 0.75

@onready var _buttons = {
	yes = %YesButton,
	no = %NoButton,
}

@onready var _item_scroll = %ItemScroll
@onready var _item_list = %ItemList
@onready var _description = %Descritpion


func _ready():
	visibility_changed.connect(_on_visibility_changed)
	_buttons.yes.grab_focus.call_deferred()


func _on_visibility_changed():
	if visible:
		_buttons.yes.grab_focus()


func _take_item(item_name: String) -> void:
	if not _item_list.has_node(item_name):
		push_warning("No item `%s` found in the ItemList.tscn!" % item_name)
		return

	show()
	var item = _item_list.get_node(item_name)
	_item_scroll.scroll_horizontal = item.position.x

	var tween = _item_scroll.create_tween()
	tween.tween_property(_item_scroll, "scale", _item_scroll.scale, _item_scale_tween_time)
	tween.parallel().tween_property(_buttons.yes, "visible", true, _item_scale_tween_time)
	tween.parallel().tween_property(_buttons.no, "visible", true, _item_scale_tween_time)
	tween.parallel().tween_property(_buttons.no, "visible", true, _item_scale_tween_time)
	tween.parallel().tween_property(_description, "visible", true, _item_scale_tween_time)
	_item_scroll.scale = 0
	_buttons.yes.visible = false
	_buttons.no.visible = false
	_description.visible = false

	
