tool
extends Node2D

enum MotionType {SIMPLE, PERIODIC, SQUARE}
enum SpawnSequence {FORWARD, ALTERNATE, RANDOM}

export(MotionType) var motion_type setget set_motion

export(Resource) var motion

export(PackedScene) var SpawnObj:PackedScene

export(int, 1, 99) var spawn_points := 1
export(Vector2) var spawn_offset := Vector2.ZERO 


export(SpawnSequence) var spawn_sequence := SpawnSequence.FORWARD

export(bool) var autostart := true

export(int, 1, 100) var spawn_count := 1

export(int) var units_per_spawn := 1 setget set_units_per_spawn

export(float) var start_delay := 0.0

export(float) var spawn_delay := 0.1

var spawn_index := 0

var index_mult = 1

var level: AbstractLevel

var simple_motion: SimpleMotion
var periodic_motion: PeriodicMotion
var square_motion: SquareMotion

onready var start_timer := $start_timer
onready var delay_timer := $delay_timer

func _ready():
	randomize()
	
	simple_motion = SimpleMotion.new()
	periodic_motion = PeriodicMotion.new()
	square_motion = SquareMotion.new()
	
	if start_delay != 0.0:
		start_timer.wait_time = start_delay
		
	delay_timer.wait_time = spawn_delay
	
	if not motion:
		set_motion(MotionType.SIMPLE)
	
	if autostart and not Engine.editor_hint:
		if start_delay == 0.0:
			trigger_spawn()
		else:
			start_timer.start()


func _process(delta):
	update()


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
		object.position = position + spawn_offset.rotated(rotation)*spawn_index
		if object is AbstractEntity:
			if motion as SimpleMotion:
				object.linear_vel = Vector2(motion.vel_mag, 0.0).rotated(deg2rad(motion.vel_angle))
				object.linear_acc= Vector2(motion.acc_mag, 0.0).rotated(deg2rad(motion.acc_angle))
			else:
				object.path = motion.calc_path(global_position + spawn_offset.rotated(rotation)*spawn_index, rotation)
		
		level.enemies.add_child(object)
		
		spawn_index += index_mult
		spawn_count -= 1


func trigger_spawn():
	delay_timer.start()


func _draw():
	if Engine.editor_hint:
		
		var points := []
		
		for i in range(spawn_points):
			draw_circle(spawn_offset*i, 5.0, Color(0.8, 0.5, 0.5))
			
			if motion as SimpleMotion:
				draw_line(spawn_offset*i, spawn_offset*i + Vector2(motion.vel_mag, 0.0).rotated(deg2rad(motion.vel_angle)), Color(0.4,0.6, 0.8), 2.0)
			else:
				points = motion.calc_path(spawn_offset*i)
				draw_polyline(points, Color(0.4,0.6, 0.8), 2.0)
				for point in points:
					draw_circle(point, 2.0, Color(0.8,0.6, 0.2))


func set_units_per_spawn(value):
	units_per_spawn = clamp(value, 1, spawn_points)


func _on_delay_timer_timeout():
	spawn()


func _on_start_timer_timeout():
	trigger_spawn()


func _on_Timer_timeout():
	update()


func set_motion(value):
	motion_type = value
	match motion_type:
		MotionType.SIMPLE:
			motion = simple_motion
		MotionType.PERIODIC:
			motion = periodic_motion
		MotionType.SQUARE:
			motion = square_motion
	property_list_changed_notify()
