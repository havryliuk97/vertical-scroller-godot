@tool
extends Node
class_name AIController

@export var auto_start := true

var actor: AbstractEntity: set = set_actor
var commands_queue: CommandsQueue: set = set_commands_queue


func _ready():
	if auto_start and actor and commands_queue:
		commands_queue.start_executing()


func set_actor(new_actor: AbstractEntity):
	actor = new_actor
	if(commands_queue):
		commands_queue.assign_actor(actor)


func set_commands_queue(new_queue: CommandsQueue):
	commands_queue = new_queue
	commands_queue.assign_actor(actor)


func _notification(what):
	if what == NOTIFICATION_PARENTED:
		var parent = get_parent()
		if parent is AbstractEntity:
			set_actor(parent)
	elif what == NOTIFICATION_UNPARENTED:
		var parent = get_parent()
		if parent is AbstractEntity:
			set_actor(null)
