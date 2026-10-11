extends Node2D
class_name Spawner

signal started_spawn()
signal finished_spawn()
signal units_destroyed()
signal finish_condition_reached()

enum FinishConditions {
	IMMEDIATE,
	UNITS_SPAWNED,
	UNITS_KILLED
}

@export var team = preload("res://autoload/teams.gd").Options.ENEMIES_TEAM

@export var finish_condition: FinishConditions = FinishConditions.UNITS_KILLED

@export var SpawnObj: PackedScene

@export var initial_velocity := Vector2.ZERO

@export var spawn_count := 1 # (int, 1, 100)

@export var start_delay := 0.05 # (float, 0.0, 10.0, 0.1)

@export var spawn_delay := 0.1 # (float, 0.1, 5.0, 0.1)

@onready var start_timer := Timer.new()
@onready var delay_timer := Timer.new()

var level

var commands := []
var units: Array


func _setup_timers():
	start_timer.wait_time = start_delay
	start_timer.one_shot = true 
	add_child(start_timer)
	
	delay_timer.wait_time = spawn_delay
	delay_timer.one_shot = true
	add_child(delay_timer)


func _ready():
	level = ScreensManager.get_current_level()
	
	_setup_timers()
	
	match finish_condition:
		FinishConditions.IMMEDIATE:
			connect("started_spawn", Callable(self, "_on_finished_condition_reached").bind(), CONNECT_DEFERRED)
		FinishConditions.UNITS_SPAWNED:
			connect("finished_spawn", Callable(self, "_on_finished_condition_reached").bind(), CONNECT_DEFERRED)
		FinishConditions.UNITS_KILLED:
			connect("units_destroyed", Callable(self, "_on_finished_condition_reached").bind(), CONNECT_DEFERRED)
	
	for child in get_children():
		if child is Command and not commands.has(child):
			commands.append(child)


func _on_unit_died(entity: Actor):
	units.erase(entity)
	if units.size() == 0:
		emit_signal("units_destroyed")


func _on_finished_condition_reached():
	emit_signal("finish_condition_reached")


func start_spawning():
	emit_signal("started_spawn")
	
	if start_delay > 0.0:
		start_timer.start()
		await start_timer.timeout
	
	for _i in spawn_count:
		spawn()
		delay_timer.start()
		await delay_timer.timeout
	
	emit_signal("finished_spawn")


func spawn():
	var entity = SpawnObj.instantiate() as Actor
	entity.team = team
	entity.position = position
	entity.linear_vel = initial_velocity.limit_length(entity.max_linear_vel)
	
	entity.connect("tree_exited", Callable(self, "_on_unit_died").bind(entity))
	
	if commands.size():
		var controller = AIController.new()
		var controller_commands = CommandsQueue.new()
		
		for command in commands:
			controller_commands.add_command(command.duplicate())
		
		controller.set_commands_queue(controller_commands)
		
		entity.add_child(controller)
	
	units.append(entity)
	
	level.add_entity(entity)


func add_command(node):
	commands.append(node)
		
	add_child(node)


func remove_command(node):
	commands.erase(node)
		
	remove_child(node)
