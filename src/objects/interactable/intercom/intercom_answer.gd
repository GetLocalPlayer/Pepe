extends Node
class_name IntercomAnswer


## Sound played before giving options.
## Also played after the call is answered.
@export var _answer: AudioStreamMP3
## This string will be used as an option,
## if this IntercomAnswer is a child of another
## IntercomAnswer. If empty, the node's name
## is used.
@export var _option_string: String: get = get_option_string
## Lines shown after _answer is finished,
## return by .pick_up() method
@export var _after_pick_up_lines: Array[String] = []
## Lines used after the call is finished and hung up.
@export var _hang_up_lines: Array[String] = []: get = get_hang_up_lines

func get_hang_up_lines() -> Array[String]:
	return _hang_up_lines

# Return string that will represent this
# node as an option if it's a child of another
# IntercomAnswer. Return the node's name if
# the field is empty.
func get_option_string() -> String:
	return _option_string if _option_string else str(name)

@onready var _audio_player: AudioStreamPlayer = AudioStreamPlayer.new()


func _ready() -> void:
	add_child(_audio_player, INTERNAL_MODE_BACK)


## Return lines after playing
func pick_up() -> Array[String]:
	if _answer:
		_audio_player.stop()
		_audio_player.stream = _answer
		_audio_player.play()
		await _audio_player.finished
	return _after_pick_up_lines


func get_child_answers() -> Array[IntercomAnswer]:
	var result: Array[IntercomAnswer] = []
	for child in get_children():
		if child is IntercomAnswer:
			result.append(child)
	return result


