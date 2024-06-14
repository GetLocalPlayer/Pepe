@tool
class_name Item
extends Button



@export_multiline var description: String = ""


@export var amount: int = 1:
    get:
        return amount
    set(value):
        amount = value if value >= 0 else 0
        if not is_node_ready(): return
        _label.text = "x%d" % amount
        visible = amount > 0
        _label.visible = amount > 1


@export var _model: PackedScene:
    get:
        return _model
    set(value):
        _model = value
        if not is_node_ready(): return
        for child in _model_owner.get_children():
            child.queue_free()
        if value != null:
            _model_owner.add_child(value.instantiate())


@export var _model_scale: float:
    get:
        return _model_scale
    set(value):
        _model_scale = value
        if not is_node_ready(): return     
        _model_owner.scale = Vector3(value, value, value) 


@export var _model_offset: Vector3:
    get:
        return _model_offset
    set(value):
        _model_offset = value
        if not is_node_ready(): return
        _model_owner.position = value

@export var _model_rotation: Vector3:
    get:
        return _model_rotation
    set(value):
        _model_rotation = value
        if not is_node_ready(): return
        for child in _model_owner.get_children():
            child.rotation = value


@onready var _model_owner = %ModelOwner
@onready var _sub_viewport = $SubViewport
@onready var _label = %Amount
@onready var _anim_player = %AnimationPlayer


func _ready():
    icon = _sub_viewport.get_texture()
    _model_owner.scale = Vector3(_model_scale, _model_scale, _model_scale)
    _model_owner.position = _model_offset
    for child in _model_owner.get_children():
        child.rotation = _model_rotation
    if _model != null:
        _model_owner.add_child(_model.instantiate())
    amount = amount # just to trigger setter
    _anim_player.play(_anim_player.autoplay)


func use():
    push_warning("Not implemented")