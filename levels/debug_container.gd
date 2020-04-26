extends VBoxContainer

var linear_vel := Vector2.ZERO
var linear_acc := Vector2.ZERO

onready var vel_label := $vel_label
onready var acc_label := $acc_label

var _format_string = "%s: %s, mag: %s"

func _process(delta):
	vel_label.text = _format_string % ["Vel", linear_vel, stepify(linear_vel.length(), 0.01)]
	acc_label.text = _format_string % ["Acc", linear_acc, stepify(linear_acc.length(), 0.01)]
	
