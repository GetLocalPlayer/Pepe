extends Control

@export var _fade_screen_tween_time = 0.5
@onready var _portrait = %Portrait
@onready var _fade_screen = %FadeScreen
@onready var _backdrop = %Backdrop
@onready var _item_list = %ItemList


func _ready():
    _item_list.find_next_valid_focus().grab_focus.call_deferred()

    var tree = get_tree()
    var current_scene = tree.current_scene

    visibility_changed.connect(func(): tree.paused = visible)

    # for testing runs from editor
    tree.paused = self == current_scene
    visible = self == current_scene


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