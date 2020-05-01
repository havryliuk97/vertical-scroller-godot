class_name AbstractEntity
extends KinematicBody2D
# Abstract entity class to be exended by other game objects

signal collision_occured(object, collider)

export var max_linear_vel : float
export var max_linear_acc : float

export var linear_vel := Vector2.ZERO
export var linear_acc := Vector2.ZERO
var collision_info: KinematicCollision2D

onready var sprite := $sprite

func _physics_process(delta):
	if max_linear_acc > 0.0:
		linear_acc = linear_acc.clamped(max_linear_acc)
	
	linear_vel += linear_acc
	
	if max_linear_vel > 0.0:
		linear_vel = linear_vel.clamped(max_linear_vel)
		
	collision_info = move_and_collide(linear_vel*delta)
	_update(delta)

func _update(delta):
	pass


func hit():
	pass
