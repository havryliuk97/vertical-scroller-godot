extends AbstractEntity

func _physics_process(delta):
	_update(delta)


func _on_anim_timer_timeout():
	if sprite.frame == 0:
		sprite.frame = 1
	else:
		sprite.frame = 0

