class_name Selector
extends MarginContainer


@export var _tween_time: float = 0.15

@onready var _item_scroll = %ItemScroll


func _ready():
	var on_focus_changed = func(node):
		var p = _item_scroll.global_position if node is Item else node.global_position
		var s = _item_scroll.get_global_rect().size if node is Item else node.get_global_rect().size
		var tween = create_tween()
		tween.tween_property(self, "global_position", p, _tween_time)
		tween.parallel().tween_property(self, "size", s, _tween_time)

	get_viewport().gui_focus_changed.connect(on_focus_changed)

