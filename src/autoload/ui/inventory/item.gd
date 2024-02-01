@tool
class_name Item
extends MarginContainer


@export var description: String = ""


@export var amount: int:
    get:
        return _amount
    set(value):
        if value >= 0:
            _amount = value
        if not is_node_ready(): return
        label.text = "x%d" % _amount
        if _amount > 0:
            model_owner.show()
            label.show()
        else:
            label.hide()
            model_owner.hide()


@export var model: PackedScene:
    get:
        return _model
    set(value):
        _model = value
        if not is_node_ready(): return
        for child in model_owner.get_children():
            child.queue_free()
        if value != null:
            model_owner.add_child(value.instantiate())


@export var model_scale: float:
    get:
        return _model_scale
    set(value):
        _model_scale = value
        if not is_node_ready(): return     
        model_owner.scale = Vector3(value, value, value) 


@export var model_offset: Vector3:
    get:
        return _model_offset
    set(value):
        _model_offset = value
        if not is_node_ready(): return
        model_owner.position = value


var acitons: Array:
    get = _get_actions


var _amount: int
var _model: PackedScene
var _model_scale: float
var _model_offset: Vector3


@onready var model_owner = %ModelOwner
@onready var sub_viewport = $SubViewport
@onready var texture_rect = $Texture
@onready var label = %Amount
@onready var player = %AnimationPlayer


func _ready():
    texture_rect.texture = sub_viewport.get_texture()
    model_owner.scale = Vector3(model_scale, model_scale, model_scale)
    model_owner.position = model_offset
    if amount <= 0:
        model_owner.hide()
        label.hide()
    if model != null:
        model_owner.add_child(model.instantiate())
    player.play(player.autoplay)


func _get_actions() -> Array:
    return []