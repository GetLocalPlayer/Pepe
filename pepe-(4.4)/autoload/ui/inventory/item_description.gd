extends RichTextLabel



func _ready():
    text = ""
    var on_focus_changed = func(control):
        if control is Item:
            text = (control as Item).description
    get_viewport().gui_focus_changed.connect(on_focus_changed)
