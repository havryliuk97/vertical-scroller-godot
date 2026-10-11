extends Node
class_name Command

signal started()
signal finished()

enum {
	WAITING,
	EXECUTING,
	FINISHED
}

var status: int = WAITING

var actor: Actor: set = set_actor


func start():
	status = EXECUTING
	emit_signal("started")


func finish():
	status = FINISHED
	emit_signal("finished")


func _execute(delta):
	pass


func _physics_process(delta):
	if(status == EXECUTING):
		_execute(delta)


func set_actor(new_actor: Actor):
	actor = new_actor
