extends AbstractEntity

onready var DeathEffect := preload("res://effects/explosion.tscn")


func kill():
	$hitbox.hide()
	$hitbox.disabled = true
	$sprite.hide()
	$anim_timer.stop()
	$anim_player.play("death")
	$tween.interpolate_property(self, "linear_vel", linear_vel, Vector2.ZERO, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$tween.start()

func _on_anim_timer_timeout():
	if sprite.frame == 0:
		sprite.frame = 1
	else:
		sprite.frame = 0

func _spawn_explosion(radius:float = 1.0):
	var death_effect = DeathEffect.instance()
	death_effect.position = Vector2(rand_range(-radius, radius), rand_range(-radius, radius))
	add_child(death_effect)

func _on_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
