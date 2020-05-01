extends AbstractEntity

onready var DeathEffect := preload("res://effects/explosion.tscn")

func _update(delta):
	if collision_info:
		var collider = collision_info.collider
		var layer = collider.get_collision_layer()
		if layer == 2:
			collider.queue_free()
			kill()
#			emit_signal("collision_occured", self, collision_info.collider)

func kill():
	$hitbox.hide()
	$hitbox.disabled = true
	$sprite.hide()
	$anim_timer.stop()
	$anim_player.play("death")

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
		print("died")
		queue_free()
