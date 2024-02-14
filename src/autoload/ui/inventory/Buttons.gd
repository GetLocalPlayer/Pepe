extends VBoxContainer

@export var _alpha = {
    focused = 1,
    unfocused = 0.7,
}

@onready var _button_groups = {
    Consumable: [$Use],
    Item: [],
}

@onready var _buttons = get_children().filter(func(child): return child is Button)
var _last_focused_item: Item = null


func _ready():
    modulate.a = _alpha.focused if has_focus() else _alpha.unfocused
    visible = has_focus()
    focus_entered.connect(_on_focus_entered)
    get_viewport().gui_focus_changed.connect(_on_viewport_focus_changed)
    for i in _buttons.size():
        var btn = _buttons[i]
        btn.hide()
        btn.focus_neighbor_left = btn.get_path()
        btn.focus_neighbor_right = btn.get_path()
        btn.focus_neighbor_top = _buttons[i - 1].get_path() if i > 0 else btn.get_path()
        btn.focus_neighbor_bottom = _buttons[i + 1].get_path() if btn != _buttons.back() else btn.get_path()


func _on_focus_entered():
    find_next_valid_focus().grab_focus.call_deferred()


func _input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed("ui_cancel"):
        if _last_focused_item:
            _last_focused_item.grab_focus.call_deferred()


func _on_viewport_focus_changed(node: Control):
    # Alpha if it's a button
    modulate.a = _alpha.focused if get_children().has(node) else _alpha.unfocused

    # Showing proper buttons
    if node is Item:
        _last_focused_item = node
        _buttons.all(func(btn): btn.hide())
        var group: Array = _button_groups[node.get_script()]
        group.all(func(btn): btn.show())
        visible = group or not group.is_empty()


