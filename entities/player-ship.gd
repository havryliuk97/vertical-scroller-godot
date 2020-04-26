extends AbstractEntity

onready var DeathEffect := preload("res://effects/explosion.tscn")

var sprite_frame_x := 2
var sprite_frame_y := 0

var dead := false


func _ready():
	randomize()


func _physics_process(delta):
	
	sprite_frame_x = round(clamp(linear_vel.x/50.0, -2, 2))
	
	sprite.frame_coords = Vector2(2+sprite_frame_x, sprite_frame_y)
	
	_update(delta)
	
	if collision_info and not dead:
		emit_signal("collision_occured", self, collision_info.collider)


func kill():
	dead = true
	$hitbox.hide()
	$sprite.hide()
	$anim_timer.stop()
	$anim_player.play("death")


func _spawn_explosion(radius:float = 1.0):
	var death_effect = DeathEffect.instance()
	death_effect.position = Vector2(rand_range(-radius, radius), rand_range(-radius, radius))
	add_child(death_effect)


func _on_anim_timer_timeout():
	if sprite_frame_y == 0:
		sprite_frame_y = 1
	else:
		sprite_frame_y = 0 

func _on_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
