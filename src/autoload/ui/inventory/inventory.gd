extends Control

@export var _fade_screen_tween_time = 0.5
@onready var _portrait = %Portrait
@onready var _fade_screen = %FadeScreen
@onready var _backdrop = %Backdrop
@onready var _item_scroll = %ItemScroll
@onready var _item_list = %ItemList
var _last_focus: Control = null


func _ready():
	_ready_deferred.call_deferred()
	# Pause and hide if the game starts
	# not from the inventory scene.
	var tree = get_tree()
	var current_scene = tree.current_scene
	tree.paused = self == current_scene
	visible = self == current_scene


func _ready_deferred():
	_last_focus = _item_list.get_children().filter(func(node): return node is Item)[0]
	_last_focus.grab_focus()
	var on_focus_changed = func(control):
		_last_focus = control
	get_viewport().gui_focus_changed.connect(on_focus_changed)

	var on_backdrop_visibility_changed = func():
		get_tree().paused = visible
		if visible:
			await get_tree().process_frame
			""" Just to trigger item list arrangement,
			otherwise it won't be scaled/positioned/
			focused properly. """
			_item_scroll.scroll_horizontal += 1
			_item_scroll.scroll_horizontal -= 1
			_last_focus.grab_focus()

	_backdrop.visibility_changed.connect(on_backdrop_visibility_changed, CONNECT_DEFERRED)

	var on_visibility_changed = func():
		get_tree().paused = visible

	visibility_changed.connect(on_visibility_changed)


func _input(_event):
	if _fade_screen.visible:
		return
	if Input.is_action_just_pressed("OpenInventory"):
		close()


func open(health_status: float):
	var portrait_material: ShaderMaterial = _portrait.material
	portrait_material.set_shader_parameter("CurrentHealth", clamp(health_status, 0, 1))
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
