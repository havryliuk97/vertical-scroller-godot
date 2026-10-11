extends MotionCommand
class_name FollowPath

@export var path_bake_interval := 5.0
@export var arrive_threshold := 1.0

var path: Path2D
var path_points: Array
var current_point: Vector2


func _ready():
	pass


func start():
	if (path == null): 
		var child_path = get_child(0) as Path2D
	
		if(child_path != null):
			path = child_path
			path.curve.bake_interval = path_bake_interval
			var curve_points = path.curve.get_baked_points()
			path_points = Array(curve_points)
			current_point = path_points.pop_front()
		else:
			printerr("Path3D not set")
			return
	super.start()



func _reach_point(point: Vector2) -> bool:
	# points are in path's local space, so they need to be translated to global coords 
	var target_pos = path.global_position + point
	var dist = (target_pos - actor.global_position).length_squared()
	
	if (dist > arrive_threshold * arrive_threshold):
		actor.linear_acc = Steering.seek(actor, target_pos)
		return false
	
	return true


func _execute(_delta): 
	if(not actor or not path_points): return
	
	var point_reached = _reach_point(current_point)
	
	if point_reached:
		current_point = path_points.pop_front()
		if not current_point:
			actor.linear_acc = Vector2.ZERO
			finish()
