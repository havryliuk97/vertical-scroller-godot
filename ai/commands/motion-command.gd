extends Command
class_name MotionCommand

@export var max_vel := 0.0

var _original_actor_max_vel


func start():
	if max_vel != 0.0 and actor.max_linear_vel > max_vel:
		_original_actor_max_vel = actor.max_linear_vel
		actor.max_linear_vel = max_vel
		
	super.start()


func finish():
	if _original_actor_max_vel != null:
			actor.max_linear_vel = _original_actor_max_vel
	super.finish()

