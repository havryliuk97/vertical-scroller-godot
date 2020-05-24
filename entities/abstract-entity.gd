tool

class_name AbstractEntity
extends KinematicBody2D
# Abstract entity class to be exended by other game objects

signal collision_occured(object, collider)

var path
var waypoint_idx := 0

export var debug := true

export var arrive_threshold := 10.0

export var max_linear_vel := 1000.0
export var max_linear_acc := 500.0

export var linear_vel := Vector2.ZERO
export var linear_acc := Vector2.ZERO

var collision_info: KinematicCollision2D
var desired_vel := Vector2.ZERO

onready var sprite := $sprite


func seek(agent:AbstractEntity, target:Vector2):
	pass


func _physics_process(delta):
	if path and waypoint_idx < path.size() - 1:
		var dist_sqr = global_position.distance_squared_to(path[waypoint_idx])
		
		if dist_sqr < arrive_threshold * arrive_threshold:
			waypoint_idx += 1
			
		desired_vel = (path[waypoint_idx] - global_position).normalized() * max_linear_vel
		linear_acc = (desired_vel - linear_vel)/20.0
#		linear_vel = (path[waypoint_idx] - global_position).normalized() * max_linear_vel
		
	if max_linear_acc > 0.0:
		linear_acc = linear_acc.clamped(max_linear_acc)
		
	linear_vel += linear_acc
		
	if max_linear_vel > 0.0:
		linear_vel = linear_vel.clamped(max_linear_vel)
		
		
	collision_info = move_and_collide(linear_vel*delta)
	_update(delta)
	update()

func _update(delta):
	pass


func hit():
	pass


func _draw():
	if debug and path:
		draw_line(Vector2.ZERO, path[waypoint_idx] - global_position, Color(1.0, 0.3, 0.1))
