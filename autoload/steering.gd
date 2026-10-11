extends Node

func seek(entity: AbstractEntity, target: Vector2) -> Vector2:
	var steering: Vector2
	
	var desired_vel = (target - entity.global_position).normalized() * entity.max_linear_vel
	steering = desired_vel - entity.linear_vel
	
	return steering


func arrive(entity: AbstractEntity, target: Vector2, slowdown_radius: float) -> Vector2:
	var steering: Vector2
	
	var desired_vel = target - entity.global_position
	
	var distance_sqrd = desired_vel.length_squared()
	
	if (distance_sqrd < slowdown_radius * slowdown_radius):
		desired_vel = desired_vel.normalized() * entity.max_linear_vel * (distance_sqrd / slowdown_radius / slowdown_radius)
	else:
		desired_vel = desired_vel.normalized() * entity.max_linear_vel
	
	steering = desired_vel - entity.linear_vel
	
	return steering
