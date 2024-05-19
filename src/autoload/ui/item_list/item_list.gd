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
	var file = FileAccess.open(scene_file_path.get_basename() + ".json", FileAccess.WRITE_READ)
	var stringfied = JSON.stringify(names)
	if stringfied != file.to_string():
		file.store_string(stringfied)
		file.close()