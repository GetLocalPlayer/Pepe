extends ScrollContainer


@onready var _item_list = $ItemList.get_children().filter(func(child): return child is Item)

@export var _scroll_tween_time: float = 0.15
@export var _scroll_alpha_range = {
	min = 0.4,
	max = 1,
}
@export var _scroll_margin_range = {
	min = 0,
	max = 0.75,
}

@onready var _last_focused_item: Item = null


func _ready():
	for i in _item_list.size():
		var item: Item = _item_list[i]
		item.focus_neighbor_top = get_node(focus_neighbor_top).get_path()
		item.focus_neighbor_bottom = get_node(focus_neighbor_bottom).get_path()
		item.focus_neighbor_left = item.get_path() if i == 0 else _item_list[i - 1].get_path()
		item.focus_neighbor_right = item.get_path() if item == _item_list.back() else _item_list[i + 1].get_path()

		var on_item_focus_entered = func():
			var tween = create_tween()
			tween.tween_property(self, "scroll_horizontal", item.position.x, _scroll_tween_time)
			_last_focused_item = item

		item.focus_entered.connect(on_item_focus_entered)

	get_h_scroll_bar().value_changed.connect(_on_scroll_value_changed, CONNECT_DEFERRED)
	visibility_changed.connect(_on_visibility_changed)
	_on_visibility_changed.call_deferred()
	focus_entered.connect(_on_focus_entered)


func _on_focus_entered():
	if _last_focused_item:
		_last_focused_item.grab_focus.call_deferred()


func _on_visibility_changed():
	if visible:
		_on_scroll_value_changed(scroll_horizontal)


func _on_scroll_value_changed(_new_value):
	var parent_rect = get_parent().get_rect()
	for item in _item_list:
		var item_rect = get_transform() * item.get_parent().get_transform() * item.get_rect()
		var offset = item_rect.get_center() - parent_rect.get_center()
		var fade_factor = clamp(abs(offset.x) / (parent_rect.size.x / 2), 0, 1)
		var alpha_range = _scroll_alpha_range.max - _scroll_alpha_range.min
		item.modulate = Color(item.modulate, (1 - fade_factor) * alpha_range + _scroll_alpha_range.min)

		var margin_range = _scroll_margin_range.max - _scroll_margin_range.min
		var margin = item_rect.size * 0.5 * (fade_factor * margin_range + _scroll_margin_range.min)
		item.add_theme_constant_override("margin_left", margin.x)
		item.add_theme_constant_override("margin_right", margin.x)
		item.add_theme_constant_override("margin_top", margin.y)
		item.add_theme_constant_override("margin_bottom", margin.y)
	

