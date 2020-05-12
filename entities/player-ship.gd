extends AbstractEntity

signal player_fired(projectile, location, vel)

export var shoot := false

var sprite_frame_x := 2
var sprite_frame_y := 0
var dead := false
export var muzzle_speed := 400.0
export var spread := 2.0

onready var DeathEffect := preload("res://effects/explosion.tscn")
onready var Projectile := preload("res://entities/plasma-bolt.tscn") 


func _ready():
	randomize()


func _update(delta):
	
	sprite_frame_x = round(clamp(linear_vel.x/50.0, -2, 2))
	
	sprite.frame_coords = Vector2(2+sprite_frame_x, sprite_frame_y)
	
	if collision_info and not dead:
		emit_signal("collision_occured", self, collision_info.collider)


func kill():
	dead = true
	$fire_timer.stop()
	$hitbox.hide()
	$hitbox.disabled = true
	$sprite.hide()
	$anim_timer.stop()
	$anim_player.play("death")
	linear_acc = Vector2.ZERO
	$tween.interpolate_property(self, "linear_vel", linear_vel, Vector2.ZERO, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$tween.start()


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


func _on_fire_timer_timeout():
	if shoot:
		var vel = Vector2(0.0, -muzzle_speed).rotated(deg2rad(rand_range(-spread/2.0, spread/2.0)))
		emit_signal("player_fired", Projectile, $muzzle_pos.global_position, vel)
		$shoot_sound.pitch_scale = rand_range(0.7, 1.3)
		$shoot_sound.play()
	else:
		$fire_timer.stop()
