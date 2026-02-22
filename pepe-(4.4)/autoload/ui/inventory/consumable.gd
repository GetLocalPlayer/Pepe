@tool
class_name Consumable
extends Item


enum EffectType {
    HEALTH_RESTORATION,
}

@export var type: EffectType

@export var value: float:
    get:
        return value
    set(newValue):
        value = newValue

@onready var _player = get_node_or_null("/root/Player")

func _ready():
    super._ready()


func use():
    match type:
        EffectType.HEALTH_RESTORATION:
            _player.restore_health(value)
    amount -= 1