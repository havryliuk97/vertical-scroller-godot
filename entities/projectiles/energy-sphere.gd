extends Projectile

@onready var anim_player := $animation

func _on_hit():
	hitbox.hide()
	hitbox.disabled = true
	
	linear_vel = Vector2.ZERO
	linear_acc = Vector2.ZERO
	
	anim_player.play("hit")
	anim_player.connect("animation_finished", Callable(self, "_on_hit_anim_finished"))


func _on_hit_anim_finished(anim_name: String):
	if anim_name == "hit":
		queue_free()


func _on_removat_timer_timeout():
	_on_hit()
