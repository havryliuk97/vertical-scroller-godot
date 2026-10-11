extends Actor

@onready var death_effect_scene := preload("res://effects/explosion.tscn")

@export var lean_frames_count: int = 1 


func _update(_delta):
	var frame = lean_frames_count + round(linear_vel.x / max_linear_vel * lean_frames_count)
	
	sprite.frame = frame


func kill():
	hitbox.hide()
	hitbox.disabled = true
	sprite.hide()
	_spawn_explosion()
	
	super.kill()


func _spawn_explosion(radius:float = 1.0):
	var death_effect = death_effect_scene.instantiate()
	death_effect.global_position = global_position + Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
	ScreensManager.get_current_level().add_effect(death_effect)
