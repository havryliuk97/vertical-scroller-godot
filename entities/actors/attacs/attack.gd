extends Node
class_name Attack

@export var params: Resource: set = _set_params
var team
@onready var delay_timer := Timer.new()

func _ready():
	if not Engine.is_editor_hint():
		if params and params is AttackParams:
			delay_timer.wait_time = params.delay
		add_child(delay_timer)


func fire():
	pass


func _set_params(new_params: Resource):
	if new_params is AttackParams:
		params = new_params
