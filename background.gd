extends Sprite

export(float) var scroll_speed = 50.0
var scroll_offset:= Vector2.ZERO


func _process(delta):
	scroll_offset.y -= scroll_speed*delta
	material.set_shader_param("scroll_offset", scroll_offset)
