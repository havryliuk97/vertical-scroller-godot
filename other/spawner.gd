tool

class_name Spawner
extends Node2D

signal finished_spawn()
signal units_destroyed()

enum MotionType {SIMPLE, PERIODIC, SQUARE}
enum SpawnSequence {FORWARD, ALTERNATE, RANDOM}

export(MotionType) var motion_type setget set_motion

export(Resource) var motion

export(PackedScene) var SpawnObj:PackedScene

export(int, 1, 99) var spawn_points := 1
export(Vector2) var spawn_offset := Vector2.ZERO 

export(SpawnSequence) var spawn_sequence := SpawnSequence.FORWARD

export(bool) var autostart := false

export(int, 1, 100) var spawn_count := 1

export(int) var units_per_spawn := 1 setget set_units_per_spawn

export(float) var start_delay := 0.0

export(float) var spawn_delay := 0.1

export(bool) var spawn_dummies := false

var spawn_index := 0

var index_mult = 1

var level

var units

# TODO: change saving instances to saving params of 
# previous instance when chaned to new type, and creating
# new instance with those params when changed back to previous type 
var simple_motion: SimpleMotion
var periodic_motion: PeriodicMotion
var square_motion: SquareMotion

onready var start_timer := $start_timer
onready var delay_timer := $delay_timer
onready var dummy_timer := $dummy_timer

func _ready():
	randomize()
	
#	simple_motion = SimpleMotion.new()
#	periodic_motion = PeriodicMotion.new()
#	square_motion = SquareMotion.new()
	
	spawn_index = 0
	
	if start_delay != 0.0:
		start_timer.wait_time = start_delay
	
	delay_timer.wait_time = spawn_delay
	dummy_timer.wait_time = spawn_delay
	dummy_timer.start()
	
	units=spawn_count
	
	if not motion:
		set_motion(MotionType.SIMPLE)
	
	if autostart and not Engine.editor_hint:
		if start_delay == 0.0:
			trigger_spawn()
		else:
			start_timer.start()


func _process(delta):
	for dummy in $dummies.get_children():
		if dummy.position.y > 360 or dummy.position.y < -40:
			dummy.queue_free()
		if dummy.position.x > 270 or dummy.position.x < -30:
			dummy.queue_free()
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
			emit_signal("finished_spawn")
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
			if motion:
				object.linear_vel = Vector2(motion.vel_mag, 0.0).rotated(deg2rad(motion.vel_angle))
				object.linear_acc= Vector2(motion.acc_mag, 0.0).rotated(deg2rad(motion.acc_angle))
				if motion as PathMotion:
					object.path = motion.calc_path(global_position + spawn_offset.rotated(rotation)*spawn_index, rotation)
		
		object.connect("tree_exited", self, "_on_unit_died")
		level.enemies.add_child(object)
		
		spawn_index += index_mult
		spawn_count -= 1


func spawn_dummy():
	
	if not (Engine.editor_hint and spawn_dummies):
		return
	
	var index_arr = []
	for n in range(spawn_points):
		index_arr.append(n)
	
	for i in range(units_per_spawn):
	
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
		
		if SpawnObj:
			var dummy
			dummy = SpawnObj.instance()
			dummy.position = global_position + spawn_offset.rotated(rotation)*spawn_index
			if motion:
				dummy.linear_vel = polar2cartesian(motion.vel_mag, deg2rad(motion.vel_angle))
				dummy.linear_acc = polar2cartesian(motion.acc_mag, deg2rad(motion.acc_angle))
				if motion as PathMotion:
					dummy.path = motion.calc_path(global_position + spawn_offset.rotated(rotation)*spawn_index, rotation)
	
				$dummies.add_child(dummy)
				
				spawn_index += index_mult


func trigger_spawn():
	delay_timer.start()


func _draw():
	if Engine.editor_hint:
		
		var points := []
		
		for i in range(spawn_points):
			draw_circle(spawn_offset*i, 5.0, Color(0.8, 0.5, 0.5))
			
			if motion:
				draw_line(spawn_offset*i, spawn_offset*i + polar2cartesian(motion.vel_mag, deg2rad(motion.vel_angle)), Color(0.4,0.6, 0.8), 2.0)
				if motion as PathMotion:
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


func _on_unit_died():
	units -= 1
	if units == 0:
		emit_signal("units_destroyed")


func set_motion(value):
	motion_type = value
#	match motion_type:
#		MotionType.SIMPLE:
#			motion = simple_motion
#		MotionType.PERIODIC:
#			motion = periodic_motion
#		MotionType.SQUARE:
#			motion = square_motion
	match motion_type:
		MotionType.SIMPLE:
			motion = SimpleMotion.new()
		MotionType.PERIODIC:
			motion = PeriodicMotion.new()
		MotionType.SQUARE:
			motion = SquareMotion.new()
	property_list_changed_notify()


func _on_dummy_timer_timeout():
	spawn_dummy()
