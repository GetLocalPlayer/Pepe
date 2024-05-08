@tool
extends VFlowContainer


func _notification(what: int) -> void:
	# TOOL MODE
	if not Engine.is_editor_hint():
		return

	match what:
		NOTIFICATION_EDITOR_POST_SAVE:
			_on_scene_saved()


func _on_scene_saved() -> void:
	var names: Array[String] = []
	for child in get_children():
		if child is Item:
			names.append(child.name)
	var file = FileAccess.open(scene_file_path.get_basename() + ".json", FileAccess.WRITE)
	file.store_string(JSON.stringify(names))
	file.close()