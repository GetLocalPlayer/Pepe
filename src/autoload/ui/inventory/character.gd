extends HBoxContainer

@export var _alpha = {
    focused = 1,
    unfocused = 0.7,
}


@onready var _focus_mode = focus_mode
@onready var _button_container = $Command/Buttons
@onready var _buttons = _button_container.get_children().filter(func(child): return child is Button)

@onready var _button_groups = {
    Consumable: [_button_container.get_node("Use")],
    Item: [],
}

@onready var _portrait_button = $Status/Portrait/Button

var _last_focused_item: Item = null
var _last_pressed_button: Button = null


func _ready():
    _button_container.modulate.a = _alpha.focused if has_focus() else _alpha.unfocused
    _button_container.visible = has_focus()
    focus_mode = _focus_mode if has_focus() else Control.FOCUS_NONE
    focus_entered.connect(_on_focus_entered)
    get_viewport().gui_focus_changed.connect(_on_viewport_focus_changed)
    for i in _buttons.size():
        var btn = _buttons[i]
        btn.hide()
        btn.pressed.connect(_on_button_pressed.bind(btn))
        btn.gui_input.connect(_on_button_gui_input)
        btn.focus_neighbor_left = btn.get_path()
        btn.focus_neighbor_right = btn.get_path()
        btn.focus_neighbor_top = _buttons[i - 1].get_path() if i > 0 else btn.get_path()
        btn.focus_neighbor_bottom = _buttons[i + 1].get_path() if btn != _buttons.back() else btn.get_path()
    _portrait_button.hide()
    _portrait_button.pressed.connect(_on_portrait_button_pressed)
    _portrait_button.gui_input.connect(_on_portrait_button_gui_input)


func _on_focus_entered():
    if _button_container.visible:
        _button_container.find_next_valid_focus().grab_focus.call_deferred()
    else:
        _last_focused_item.grab_click_focus.call_deferred()


func _on_button_pressed(btn: Button):
    if _last_focused_item is Consumable:
        _portrait_button.show()
        _portrait_button.grab_focus.call_deferred()
        _last_pressed_button = btn


func _on_button_gui_input(_event: InputEvent):
    if Input.is_action_just_pressed("ui_cancel"):
        _last_focused_item.grab_focus.call_deferred()


func _on_portrait_button_pressed():
    _portrait_button.hide()
    _last_focused_item.grab_focus.call_deferred()
    _last_focused_item.use.call_deferred()


func _on_portrait_button_gui_input(_event: InputEvent):
    if Input.is_action_just_pressed("ui_cancel"):
        _portrait_button.hide()
        _last_pressed_button.grab_focus.call_deferred()


func _on_viewport_focus_changed(node: Control):
    # Alpha if it's a button
    _button_container.modulate.a = _alpha.focused if _buttons.has(node) else _alpha.unfocused

    # Showing proper buttons
    if node is Item:
        _last_focused_item = node
        _buttons.all(func(btn): btn.hide())
        var group: Array = _button_groups[node.get_script()]
        group.all(func(btn): btn.show())
        _button_container.visible = group or not group.is_empty()
        focus_mode = _focus_mode if _button_container.visible else Control.FOCUS_NONE


