extends Area3D
class_name IntercomInterface

signal cancel_pressed
signal call_pressed(number: int)

@export var _max_number_length: int = 4
@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _call_timer: Timer = _anim_player.get_node("CallTimer")
@export var _min_call_time: float = 7.5
@export var _max_call_time: float = 15

func play_idle() -> void:
	_anim_player.play("idle")

func play_talk() -> void:
	_anim_player.play("talk")

func play_error() -> void:
	_anim_player.play("error")
	await _anim_player.animation_finished

func play_call() -> void:
	_anim_player.play("call")
	_call_timer.start(randf_range(_min_call_time, _max_call_time))
	await _call_timer.timeout
	_anim_player.stop()

func play_pick_up() -> void:
	_anim_player.play("pick_up")
	await _anim_player.animation_finished

func play_hang_up() -> void:
	_anim_player.play("hang_up")
	await _anim_player.animation_finished


@onready var _button_sounds: Dictionary[String, AudioStreamPlayer] = {
	normal = $ButtonSounds/Normal,
	special = $ButtonSounds/Special,
}
@onready var _screen: Label3D = $Screen


@onready var _numbers: Dictionary[Object, int] = {
	$Button0: 0,
	$Button1: 1,
	$Button2: 2,
	$Button3: 3,
	$Button4: 4,
	$Button5: 5,
	$Button6: 6,
	$Button7: 7,
	$Button8: 8,
	$Button9: 9,
}
@onready var _call_button: Object = $ButtonCall
@onready var _cancel_button: Object = $ButtonCancel


func _input_event(_camera: Camera3D, event: InputEvent, _event_position: Vector3, _normal: Vector3, shape_idx: int) -> void:
	var e: InputEventMouseButton = event as InputEventMouseButton
	var left_mouse_just_pressed: bool = e and e.button_index == MOUSE_BUTTON_LEFT and e.is_pressed() and not e.is_echo()
	var obj: Object = shape_owner_get_owner(shape_find_owner(shape_idx))
	if not obj or not left_mouse_just_pressed:
		return

	if obj in _numbers:
		_button_sounds.normal.play()
		if _anim_player.is_playing():
			_anim_player.pause()
			_screen.text = ""
		if _screen.text.length() < _max_number_length:
			_screen.text += str(_numbers[obj])


	match obj:
		_call_button:
			_button_sounds.special.play()
			if _screen.text.is_valid_int():
				call_pressed.emit(int(_screen.text))
		_cancel_button:
			_button_sounds.special.play()
			_screen.text = ""
			play_idle()
			cancel_pressed.emit()


func disable_buttons() -> void:
	input_ray_pickable = false


func enable_buttons() -> void:
	input_ray_pickable = true
