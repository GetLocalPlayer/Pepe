extends Node


signal died
signal health_restored(value: float)
signal health_changed(old_value: float, new_value: float)


var max_health: float = 100
var health: float = 10:
    get:
        return health
    set(value):
        var h = health
        health = 0.0 if value < 0.0 else max_health if value > max_health else value
        if h != health:
            health_changed.emit(h, health)
        if value == 0:
            died.emit()


func _ready():
    add_to_group("Player")



func restore_health(value: float) -> void:
    if value < 0: return
    var h = health
    health += value
    health_restored.emit(health - h)