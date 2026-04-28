@tool
extends InteractableUI
class_name PickableUI


@export_range(0, 10, 0.01) var _item_appearing_time: float = 0.5
@onready var _item_preview: Control = $ItemPreview
@onready var _item_scroll: ScrollContainer = _item_preview.get_node("ScrollContainer")
@onready var _item_list: _ItemList = _item_scroll.get_node("ItemList")


func _ready() -> void:
	super._ready()
	_reset_item_list()


func _reset_item_list() -> void:
	for s in _item_list.get_item_names():
		_item_list.set_item_count(s, 0)


func set_item(item_name: String, count: int) -> void:
	_reset_item_list()
	_item_list.set_item_count(item_name, count)


func get_item_names() -> Array[String]:
	return _item_list.get_item_names()


func run(lines: Array[String], options: Array[String]) -> void:
	_item_preview.scale = Vector2.ZERO
	_item_preview.show()
	var tween = create_tween()
	tween.tween_property(_item_preview, "scale", Vector2.ONE, _item_appearing_time)
	await tween.finished
	await super.run(lines, options)


func _on_option_pressed(btn: Button) -> void:
	var tween = create_tween()
	tween.tween_property(_item_preview, "scale", Vector2.ZERO, _item_appearing_time)
	await tween.finished
	_item_preview.hide()
	super._on_option_pressed(btn)
