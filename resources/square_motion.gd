extends PathMotion

class_name SquareMotion

enum Direction {LEFT = -1, RIGHT = 1}

export(int, "Left", "Center", "Right") var align := 1
export(Direction) var start_dir := Direction.RIGHT

export(float) var l1 := 50.0 # lenght from start point to begining of the pattern
export(float) var width := 50.0
export(float) var height := 20.0

export(int, 4, 100) var lenght := 40


func _init(a:= 1, sd = 1,i_l1 = 50.0, w = 1.0, h = 80.0, l = 40):
	align = a
	start_dir = sd
	l1 = i_l1
	width = w
	height = h
	lenght = l


func calc_path(start_pos:Vector2 = Vector2.ZERO, angle = 0.0):
	var points := []
	points.append(start_pos)
	var pattern_start = start_pos + Vector2(0.0,l1).rotated(angle)
	points.append(pattern_start)
	var mult1 = -align + 1 #multiplier for displaysment of second point in the path 
	
	if mult1 == 0:
		mult1 = 0.5 * start_dir
	
	points.append(pattern_start + Vector2(width*mult1,0.0).rotated(angle))
	
	var mult2 = -1*sign(mult1)
	
	for i in range(0, lenght):
		var offset := Vector2.ZERO
		if i % 2 == 0:
			offset.x = 0.0
			offset.y = height
		else:
			offset.x = width*mult2
			offset.y = 0.0
			mult2 *= -1
		
		points.append(points[points.size()-1] + offset.rotated(angle))
	return points
