extends ScrollContainer


@onready var _items = $AllItems.get_children().filter(func(child): return child is Item)
@onready var _exit_button = %ExitButton
@onready var _command_button = %CommandButton_1

@export var _scroll_tween_time: float = 0.15
@export var _scroll_alpha_factor: float = 2.5
@export var _scroll_margin_factor: float = 1


func _ready():
	for i in _items.size():
		var item: Item = _items[i]
		item.focus_neighbor_top = _command_button.get_path()        
		item.focus_neighbor_bottom = _exit_button.get_path()
		item.focus_neighbor_left = item.get_path() if i == 0 else _items[i - 1].get_path()
		item.focus_neighbor_right = item.get_path() if item == _items.back() else _items[i + 1].get_path()

		var on_focus_entered = func():
			_command_button.focus_neighbor_bottom = item.get_path()
			_exit_button.focus_neighbor_top = item.get_path()

			var tween = create_tween()
			tween.tween_property(self, "scroll_horizontal", item.position.x, _scroll_tween_time)

		item.focus_entered.connect(on_focus_entered)

	var on_scroll_value_changed = func(_new_value):
		var parent_rect = get_parent().get_rect()
		for item in _items:
			var item_rect = get_transform() * item.get_parent().get_transform() * item.get_rect()
			var offset = item_rect.get_center() - parent_rect.get_center()
			var fade_factor = clamp(abs(offset.x) / (parent_rect.size.x / 2), 0, 1)
			item.modulate = Color(item.modulate, (1 - fade_factor) * _scroll_alpha_factor)

			var margin = item_rect.size * 0.5 * fade_factor * _scroll_margin_factor
			item.add_theme_constant_override("margin_left", margin.x)
			item.add_theme_constant_override("margin_right", margin.x)
			item.add_theme_constant_override("margin_top", margin.y)
			item.add_theme_constant_override("margin_bottom", margin.y)


	get_h_scroll_bar().value_changed.connect(on_scroll_value_changed, CONNECT_DEFERRED)
