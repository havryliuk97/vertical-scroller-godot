tool

extends AbstractEntity

func _draw():
	draw_rect(Rect2(Vector2(-5, -10), Vector2(10, 20)), Color(0.3, 0.7, 0.3))

func _on_time_to_die():
	print("dummy deleted")
	queue_free()
