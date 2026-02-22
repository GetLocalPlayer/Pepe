extends ColorRect


@onready var _player = get_node("/root/Player")
@onready var _shader = material as ShaderMaterial

func _ready() -> void:
    _player.health_changed.connect(_on_player_health_changed)
    _on_player_health_changed(0, 0)


func _on_player_health_changed(_old_value: float, _new_value: float):
    _shader.set_shader_parameter("CurrentHealth", _player.health / _player.max_health)