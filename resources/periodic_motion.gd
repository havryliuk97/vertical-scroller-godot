extends Resource

class_name PeriodicMotion

const NAME := "PERIODIC"

export(String, "Sine", "Cosine") var function := "Sine"

export(float) var amplitude := 1.0
export(float) var frequency := 1.0
export(int, 20, 400) var lenght := 400
export(int, 1, 20) var step :=1

func _init(i_func = "Sine", a =1.0, f = 1.0, l = 400):
	function = i_func
	amplitude = a
	frequency = f
	lenght = l
