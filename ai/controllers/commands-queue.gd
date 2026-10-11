@tool
extends Node
class_name CommandsQueue

signal queue_finished()

var current_command: Command

var finished_commands := []
var waiting_commands := []

func _ready():
	pass


func assign_actor(actor: AbstractEntity):
	if current_command:
		current_command.actor = actor
	for command in waiting_commands:
		(command as Command).actor = actor


func start_next_command():
	var next_command = waiting_commands.pop_front() as Command
	finished_commands.append(current_command)
	
	if(next_command):
		current_command = next_command
		current_command.start()
	else:
		emit_signal("queue_finished")


func start_executing():
	var command = waiting_commands.pop_front() as Command
	
	if(command):
		current_command = command
		command.start()


func get_commands() -> Array:
	return get_children()


func has_command_executing() -> bool:
	return current_command and current_command.status == Command.EXECUTING


func add_command(command: Command):
	command.connect("finished", Callable(self, "start_next_command"))
	waiting_commands.append(command)
	add_child(command)
