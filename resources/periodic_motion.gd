extends PathMotion

class_name PeriodicMotion

enum Function {SINE, COSINE, SQUARE, SAW}

export(Function) var function := Function.SINE

export(float) var amplitude := 1.0
export(float) var period:= 80.0
export(int, 20, 400) var lenght := 400
export(int, 1, 20) var step :=1

func _init(i_func = Function.SINE, a = 1.0, p = 80.0, l = 400, s = 1):
	function = i_func
	amplitude = a
	period = p
	lenght = l
	step = s

func calc_path(start_pos:Vector2 = Vector2.ZERO, angle = 0.0):
	var points := []
	for i in range(0, lenght, step):
		var offset := Vector2.ZERO
		match function:
			Function.SINE:
				offset.x = amplitude*sin(i*PI*2/period)
			Function.COSINE:
				offset.x = amplitude*cos(i*PI*2/period)
			Function.SQUARE:
				offset.x = amplitude*sign(sin(i*PI*2/period))
		offset.y = i
		points.append(start_pos + offset.rotated(angle))
	return points
