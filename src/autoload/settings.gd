extends Node



func _ready() -> void:
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	var e = event as InputEventKey
	if e and e.keycode == KEY_ESCAPE and e.pressed and not e.echo:
		match Input.mouse_mode:
			Input.MouseMode.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE
			Input.MouseMode.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED
