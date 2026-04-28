@tool
extends VFlowContainer
class_name _ItemList


func get_item_names() -> Array[String]:
	var result: Array[String] = []
	for child in get_children():
		if child is Item:
			result.append(child.name)
	return result


func set_item_count(item_name: String, count: int) -> void:
	var item: Item = get_node_or_null(item_name) as Item
	if item:
		item.count = count
	else:
		push_warning("Item list doesn't contain an item named `%s`" % item_name)


func _notification(what: int) -> void:
	# TOOL MODE
	if not Engine.is_editor_hint():
		return

	match what:
		NOTIFICATION_EDITOR_POST_SAVE:
			if owner == null: _on_scene_saved()


func _on_scene_saved() -> void:
	var file = FileAccess.open(scene_file_path.get_basename() + ".json", FileAccess.WRITE_READ)
	var stringfied = JSON.stringify(get_item_names())
	if stringfied != file.to_string():
		file.store_string(stringfied)
		file.close()
