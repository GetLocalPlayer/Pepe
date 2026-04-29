extends Interactable
class_name Intercom

"""
The intercom will look into his children for
a child with name equil to the given flat
number. Then every child of obtained instance
of IntercomeAnswer beomces an optin in a dialogue
recursively.
"""

signal _called_or_canceled(number: int)

@export var _max_number: int = 48

@onready var _settings = $"/root/Settings"
@onready var _interaface: IntercomInterface = $Interface


func _ready() -> void:
	super._ready()
	_interaface.disable_buttons()
	_interaface.call_pressed.connect(_called_or_canceled.emit)


func _input(event: InputEvent) -> void:
	if event.is_action(_settings.input_map.cancel) and event.is_pressed() and not event.is_echo():
		_called_or_canceled.emit(-1)


func _run() -> Variant:
	var mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_interaface.play_idle()
	while true:
		_interaface.enable_buttons()
		var number = await _called_or_canceled
		_interaface.disable_buttons()
		var answer: IntercomAnswer = get_node_or_null(str(number)) as IntercomAnswer
		if not answer:
			if number == -1:
				_interaface.play_idle()
				break
			elif number < 1 or number > _max_number:
				await _interaface.play_error()
				_interaface.play_idle()
			else:
				await _interaface.play_call()
				_ui.show()
				_interaface.play_idle()
				await _ui.run_lines(_lines)
				_ui.hide()
				break
		else:
			await _interaface.play_call()
			await _interaface.play_pick_up()
			var last_answer = await _run_answer(answer)
			await _interaface.play_hang_up()
			_interaface.play_idle()
			if not last_answer.get_hang_up_lines().is_empty():
				_ui.show()
				await _ui.run_lines(last_answer.get_hang_up_lines())
				_ui.hide()
			break
	Input.mouse_mode = mouse_mode
	return null



# Returns last played answer
func _run_answer(answer: IntercomAnswer) -> IntercomAnswer:
	var lines = await answer.pick_up()
	if not lines.is_empty():
		_ui.show()
		await _ui.run_lines(lines)
	var next_answers = answer.get_child_answers()
	if next_answers.is_empty():
		return answer
	else:
		if next_answers.size() == 1:
			return await _run_answer(next_answers[0])
		else:
			var options: Array[String] = []
			for a in next_answers:
				options.append(a.get_option_string())
			_ui.show()
			_ui.run_options(options)
			var selected = await _ui.option_pressed
			return await _run_answer(next_answers[selected])
			
