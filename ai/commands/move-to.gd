extends MotionCommand
class_name MoveTo


@export var arrive_threshold := 1.0
@export var slowdown_radius := 10.0

var target: Node2D


func _ready():
	pass


func start():
	if (target == null): 
		var child_target = get_child(0) as Node2D
	
		if(child_target):
			target = child_target
		else:
			printerr("Target not set")
			return
	
	super.start()


func _execute(delta): 
	if(not actor): return
	
	var dist = (target.global_position - actor.global_position).length_squared()
	
	if (dist > arrive_threshold * arrive_threshold):
		actor.linear_acc = Steering.arrive(actor, target.global_position, slowdown_radius)
	else:
		actor.linear_acc = Vector2.ZERO
		finish()

