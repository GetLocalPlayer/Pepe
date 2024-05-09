extends Control

@export var _fade_screen_tween_time = 0.5
@onready var _fade_screen = %FadeScreen
@onready var _backdrop = %Backdrop
@onready var _item_scroll = %ItemScroll
@onready var _item_list = %ItemList
@onready var _exit_button = %ExitButton


func _ready():
	# Pause and hide if the game starts
	# not from the inventory scene.
	get_tree().paused = self == get_tree().current_scene
	visible = self == get_tree().current_scene
	if visible:
		_item_scroll.grab_focus.call_deferred()

	_backdrop.visibility_changed.connect(_on_backdrop_visibility_changed, CONNECT_DEFERRED)
	visibility_changed.connect(_on_visibility_changed)

	_exit_button.pressed.connect(close)
	_exit_button.gui_input.connect(_input)


func _on_backdrop_visibility_changed():
	get_tree().paused = visible
	if visible:
		await get_tree().process_frame
		""" Just to trigger item list arrangement,
		otherwise it won't be scaled/positioned/
		focused properly. """
		_item_scroll.scroll_horizontal += 1
		_item_scroll.scroll_horizontal -= 1
		_item_scroll.grab_focus.call_deferred()


func _on_visibility_changed():
	get_tree().paused = visible
	if visible:
		_item_scroll.grab_focus.call_deferred()


func _input(_event):
	if get_tree().current_scene == self:
		return
	if _fade_screen.visible:
		return
	if Input.is_action_just_pressed("ui_cancel"):
		var focus = get_viewport().gui_get_focus_owner()
		if focus is Item or focus == _exit_button:
				close()


func open():
	show()
	_backdrop.hide()
	_fade_screen.show()
	var tween = _fade_screen.create_tween()
	_fade_screen.color.a = 0
	tween.tween_property(_fade_screen, "color", Color(_fade_screen.color, 1), _fade_screen_tween_time)
	tween.tween_callback(_backdrop.show)
	tween.tween_property(_fade_screen, "color", Color(_fade_screen.color, 0), _fade_screen_tween_time)
	tween.tween_callback(_fade_screen.hide)


func close():
	_fade_screen.show()
	var tween = _fade_screen.create_tween()
	_fade_screen.color.a = 0
	tween.tween_property(_fade_screen, "color", Color(_fade_screen.color, 1), _fade_screen_tween_time)
	tween.tween_callback(_backdrop.hide)
	tween.tween_property(_fade_screen, "color", Color(_fade_screen.color, 0), _fade_screen_tween_time)
	tween.tween_callback(hide)


func add_item(item_name, amount) -> void:
	var item = _item_list.get_node_or_null(item_name)
	if item == null:
		push_error("No item `%s` has been found in the inventory!" % item_name)
		return
	item.amount += amount
