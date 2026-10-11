extends TextureRect

@export var scroll_speed: float = 50.0
var scroll_offset:= Vector2.ZERO


func _process(delta):
	scroll_offset.y -= scroll_speed*delta
	material.set_shader_parameter("scroll_offset", scroll_offset)
