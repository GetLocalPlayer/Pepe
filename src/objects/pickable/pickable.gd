@tool
extends Interactable
class_name Pickable


@export var _item_name: String = "": get = get_item_name

func get_item_name() -> String:
	return _item_name

@export var _count: int = 1: get = get_item_count, set = set_item_count

func get_item_count() -> int:
	return _count

func set_item_count(value: int) -> void:
	_count = value if value >=0 else 0
	if is_node_ready(): _ui.set_item(_item_name, _count)	


@export var _item_name_color: Color = Color.CHARTREUSE:
	set(value):
		_item_name_color = value
		if is_node_ready():
			_ui.set_item(value, _count)

@export_multiline var _default_interaction_line: String = "[center]You have found [color=#{_item_name_color}]{_item_name}[/color] (x[color=#{_item_name_color}]{_count}[/color]). Take it?"


func _ready() -> void:
	_ui.set_item(_item_name, _count)


func _get_lines() -> Array[String]:
	if Engine.is_editor_hint(): return _lines
	var lines: Array[String] = []
	for s in _lines if not _lines.is_empty() else [_default_interaction_line]:
		lines.append(s.format({
			"_item_name_color" = _item_name_color.to_html(false),
			"_item_name" = _item_name,
			"_count" = _count
		}))
	return lines


# If returns true, the item was taken
func interact() -> Variant:
	var result = await super.interact()
	if result == 0:
		queue_free()
	return result == 0


func _validate_property(property: Dictionary) -> void:
	match property.name:
		"_item_name":
			var items: Array[String] = _ui.get_item_names()
			items.sort()
			property.hint = PROPERTY_HINT_ENUM
			property.hint_string = "_NONE_," + ",".join(items)
