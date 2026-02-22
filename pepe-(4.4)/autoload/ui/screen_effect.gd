extends Control


@onready var fade: ColorRect = $FadeInOut


func _ready():
	for child in get_children():
		child.hide()


func fade_in(color: Color, time: float):
	show()
	fade.show()
	var tween = fade.create_tween()
	fade.color = Color(color, 0)
	tween.tween_property(fade, "color", Color(color, 1), time)
	await tween.finished


func fade_out(color: Color, time: float):
	show()
	fade.show()
	var tween = fade.create_tween()
	fade.color = Color(color, 1)
	tween.tween_property(fade, "color", Color(color, 0), time)
	await tween.finished