@tool
extends CenterContainer


@export_group("Clothing Paths")
@export var _body_parts_parent_path: NodePath
@export_storage var _clothing_paths: Dictionary[String, NodePath] = {}


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	for child in get_children():
		if child is TextureButton:
			properties.append({
				name = child.name,
				type = TYPE_NODE_PATH,
			})
	return properties


func _is_clothing_property(property: StringName) -> bool:
	return _clothing_paths.has(property)



func _get(property: StringName) -> Variant:
	if _is_clothing_property(property): return _clothing_paths[property]
	return null


func _set(property: StringName, value: Variant) -> bool:
	if _is_clothing_property(property):
		_clothing_paths[property] = value
		return true
	return false


func _property_can_revert(property: StringName) -> bool:
	return _is_clothing_property(property)


func _property_get_revert(property: StringName) -> Variant:
	if _is_clothing_property(property): return NodePath("") 
	return null


func _ready() -> void:
	for btn: TextureButton in get_children().filter(func(n: Node) -> bool: return n is TextureButton):
		if not _clothing_paths.has(btn.name):
			_clothing_paths[btn.name] = NodePath("")
		btn.toggled.connect(_on_button_toggled.bind(btn.name))
		_on_button_toggled(btn.button_pressed, btn.name)


func _on_button_toggled(toggled: bool, body_part_name: String) -> void:
	var btn = get_node(body_part_name) as TextureButton
	btn.self_modulate.a = 1 if toggled else 0
	var mesh: MeshInstance3D
	if _body_parts_parent_path:
		mesh = get_node(_body_parts_parent_path).get_node(body_part_name)
		if mesh and mesh.name != "Head": mesh.visible = not toggled
		mesh = get_node(_clothing_paths[body_part_name])
		if mesh: mesh.visible = toggled


func _process(_delta: float) -> void:
	match Input.mouse_mode:
		Input.MOUSE_MODE_CAPTURED:
			hide()
		_:
			show()