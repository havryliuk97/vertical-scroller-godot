extends Command
class_name SetVel

@export var vel := Vector2.ZERO

func _execute(delta): 
	if(not actor): return
	
	actor.linear_damp = 0.0
	actor.linear_vel = vel.limit_length(actor.max_linear_vel)
	
	finish()
	
