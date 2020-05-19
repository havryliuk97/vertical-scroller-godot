tool
extends Node2D

export(PackedScene) var SpawnObj:PackedScene

export(Resource) var motion_type

export(int, 1, 99) var spawn_points := 1
export(Vector2) var spawn_offset := Vector2.ZERO 

enum SpawnSequence {FORWARD, ALTERNATE, RANDOM}
export(SpawnSequence) var spawn_sequence := SpawnSequence.FORWARD


export(bool) var autostart := true

export(int, 1, 100) var spawn_count := 1

export(int) var units_per_spawn := 1 setget set_units_per_spawn

export(float) var start_delay := 0.0

export(float) var spawn_delay := 0.1

var spawn_index := 0

var index_mult = 1

var level: AbstractLevel

var path_node : Path2D
var obj_path := []

onready var start_timer := $start_timer
onready var delay_timer := $delay_timer

func _ready():
	randomize()
	start_timer.wait_time = start_delay
	delay_timer.wait_time = spawn_delay
	$Timer.start()
	
	if autostart and not Engine.editor_hint:
		if start_delay == 0.0:
			trigger_spawn()
		else:
			start_timer.start()


#func _process(delta):
#	update()


func spawn():
	
	if Engine.editor_hint:
		return
	
	level = ScenesManager.current_level
	
	var index_arr = []
	for n in range(spawn_points):
		index_arr.append(n)
	
	for i in range(units_per_spawn):
		if spawn_count == 0:
			delay_timer.stop()
			return
	
		if spawn_points > 1:
			match spawn_sequence:
				SpawnSequence.FORWARD:
					if spawn_index > spawn_points-1:
						spawn_index = 0
				SpawnSequence.ALTERNATE:
					if spawn_index == spawn_points or spawn_index == -1:
						spawn_index = clamp(spawn_index, 1, spawn_points-2)
						index_mult *= -1
				SpawnSequence.RANDOM:
					spawn_index = index_arr[randi() % index_arr.size()]
					index_arr.erase(spawn_index)
		else:
			spawn_index = 0
		
		var object = SpawnObj.instance()
		object.position = position + spawn_offset*spawn_index
		if object is AbstractEntity:
			if motion_type as SimpleMotion:
				object.linear_vel = Vector2(motion_type.vel_mag, 0.0).rotated(deg2rad(motion_type.vel_angle))
				object.linear_acc= Vector2(motion_type.acc_mag, 0.0).rotated(deg2rad(motion_type.acc_angle))
			elif motion_type as PeriodicMotion:
				object.path = calc_path(global_position + spawn_offset*spawn_index)
		
		level.enemies.add_child(object)
		
		spawn_index += index_mult
		spawn_count -= 1


func calc_path(start_pos:Vector2 = Vector2.ZERO):
	var points := []
	for i in range(0, motion_type.lenght, motion_type.step):
		var offset := Vector2.ZERO
		match motion_type.function:
			"Sine":
				offset.x = motion_type.amplitude*sin(i*motion_type.frequency)
			"Cosine":
				offset.x = motion_type.amplitude*cos(i*motion_type.frequency)
		offset.y = i
		points.append(start_pos + offset)
	return points


func trigger_spawn():
	delay_timer.start()


func _draw():
	if Engine.editor_hint:
		
		var points := []
		
		for i in range(spawn_points):
			draw_circle(spawn_offset*i, 5.0, Color(0.8, 0.5, 0.5))
			
			if motion_type as SimpleMotion:
				draw_line(spawn_offset*i, spawn_offset*i + Vector2(motion_type.vel_mag, 0.0).rotated(deg2rad(motion_type.vel_angle)), Color(0.4,0.6, 0.8), 2.0)
			elif motion_type as PeriodicMotion:
				points = calc_path(spawn_offset*i)
				draw_multiline(points, Color(0.4,0.6, 0.8), 4.0)


func set_units_per_spawn(value):
	units_per_spawn = clamp(value, 1, spawn_points)


func _on_delay_timer_timeout():
	spawn()


func _on_start_timer_timeout():
	trigger_spawn()


func _on_Timer_timeout():
	update()
