class_name AbstractEntity
extends CharacterBody2D
# Abstract entity class to be exended by other game objects

signal collision_occured(object, collider)

@export var mass := 1.0 # (float, 1.0, 1000.0)

@export var max_linear_vel := 1000.0 # (float, 0.0, 1000.0)
@export var max_linear_acc := 500.0 # (float, 0.0, 1000.0)

@export var linear_damp := 0.0 # (float, 0.0, 1.0)

var collision_info: KinematicCollision2D

var linear_vel := Vector2.ZERO
var linear_acc := Vector2.ZERO

var _dumping_acc_threshold := 0.05
var _dumping_vel_threshold := 0.2

@onready var sprite: Sprite2D = $sprite
@onready var hitbox: CollisionShape2D = $hitbox

func _physics_process(delta):
	linear_acc = linear_acc.limit_length(max_linear_acc)
		
	linear_vel += linear_acc
		
	linear_vel = linear_vel.limit_length(max_linear_vel)
	
	if (linear_damp > 0.0 and linear_acc.length_squared() < linear_damp * linear_damp):
		if (linear_vel.length_squared() > _dumping_vel_threshold * _dumping_vel_threshold):
			linear_vel = linear_vel * (1.0 - linear_damp)
		else: 
			linear_vel = Vector2.ZERO
	
	collision_info = move_and_collide(linear_vel*delta)
	
	if collision_info:
		_handle_collision(collision_info)
	
	_update(delta)


func _update(_delta):
	pass


func _handle_collision(info: KinematicCollision2D):
	pass


func hit(damage: float):
	pass
