extends Interactable


@onready var _text = _lines[0]
@onready var _lamp: OmniLight3D = $Lamp


func interact():
	_lines[0] = _text % ("off" if _lamp.visible else "on")
	if await super.interact() == 0:
		_lamp.visible = not _lamp.visible