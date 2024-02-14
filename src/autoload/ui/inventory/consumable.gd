@tool
class_name Consumable
extends Item


enum EffectType {
    HEALTH_RESTORATION,
}


@export var value: float:
    get:
        return _value
    set(newValue):
        _value = newValue


@export var type: EffectType


var _value: float


func _ready():
    super._ready()


func use():
    match type:
        EffectType.HEALTH_RESTORATION:
            get_tree().call_group("Player", "RestoreHealth", value)