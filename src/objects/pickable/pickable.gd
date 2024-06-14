@tool
extends Interactable
class_name Pickable


@export_file("*.json") var _item_list_JSON_path = "res://autoload/ui/item_list/item_list.json"
@export var _amount: int = 1
@export var _item_name_color: Color = Color.CHARTREUSE
var _item_name: String = "_NO_ITEM_SELECTED_"
@export_multiline var _default_interaction_line: String = "[center]You have found [color=#{_item_name_color}]{_item_name}[/color] (x[color=#{_item_name_color}]{_amount}[/color]). Take it?"
@export_multiline var _interaction_lines: Array[String]


@onready var _pickup_ui = null if Engine.is_editor_hint() else get_node("/root/Pickup")
@onready var _inventory_ui = null if Engine.is_editor_hint() else get_node("/root/Inventory")

	

func interact():
	var lines = [ _default_interaction_line, ] if _interaction_lines.is_empty() else _interaction_lines.duplicate()
	for i in range(lines.size()):
		lines[i] = lines[i].format(
			{
				"_item_name_color": _item_name_color.to_html(false),
				"_item_name": _item_name,
				"_amount": _amount
			}
		)
	var array_of_strings: Array[String] = []
	array_of_strings.assign(lines)
	_pickup_ui.run(_item_name, _amount, array_of_strings)
	if await _pickup_ui.finished:
		_inventory_ui.add_item(_item_name, _amount)
		queue_free()


func _get_items():
	var file = FileAccess.open(_item_list_JSON_path, FileAccess.READ)
	if file != null:
		var json = JSON.new()
		var err = json.parse(file.get_as_text())
		if err == OK:
			if typeof(json.data) != TYPE_ARRAY:
				push_error("Unexpected data")
			else:
				return json.data
		else:
			push_error("JSON Parse Error: ", json.get_error_message(), " in ", file.get_as_text(), " at line ", json.get_error_line())
	else:
		push_error(FileAccess.get_open_error())
	return null


func _get_property_list() -> Array[Dictionary]:
	var items = _get_items()
	var hint_string = "_NO_ITEM_SELECTED_"
	for s in items:
		hint_string += "," + s
	return [{
		"name": "_item_name",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": hint_string,
	}]
