extends AbstractEntity


func _update(delta):
	if collision_info:
		var collider = collision_info.collider
		var layer = collider.get_collision_layer()
		if layer == 4:
			collider.kill()
			queue_free()


func _on_delete_timer_timeout():
	queue_free()
