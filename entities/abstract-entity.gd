class_name AbstractEntity
extends KinematicBody2D
# Abstract entity class to be exended by other game objects

onready var sprite := $sprite

export var max_linear_vel := 100.0
export var max_linear_acc := 5.0

var linear_vel := Vector2.ZERO
var linear_acc := Vector2.ZERO

var collision_info: KinematicCollision2D

signal collision_occured(object, collider)

func _update(delta):
	linear_acc = linear_acc.clamped(max_linear_acc)
	linear_vel += linear_acc
	linear_vel = linear_vel.clamped(max_linear_vel)
#	print(linear_acc.length())
	collision_info = move_and_collide(linear_vel*delta)


func hit():
	pass
