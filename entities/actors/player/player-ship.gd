extends Actor

@export var lean_frames_count: int = 1 

var sprite_frame_x := 1
var sprite_frame_y := 0

@onready var death_effect_scene := preload("res://effects/explosion.tscn")


func _update(_delta):
	sprite_frame_x = round(linear_vel.x / max_linear_vel * lean_frames_count)
	
	sprite.frame_coords = Vector2(lean_frames_count + sprite_frame_x, 0)


func die():
	emit_signal("killed")
	hitbox.hide()
	hitbox.disabled = true
	sprite.hide()
	linear_acc = Vector2.ZERO
	_spawn_explosion()
	queue_free()


func _spawn_explosion(radius:float = 1.0):
	var death_effect = death_effect_scene.instantiate()
	death_effect.global_position = global_position + Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
	
	ScreensManager.get_current_level().add_effect(death_effect)
