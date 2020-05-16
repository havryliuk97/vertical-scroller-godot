tool
extends Node2D

export(NodePath) var path_link

export(PackedScene) var SpawnObj:PackedScene

export(int, 1, 99) var spawn_points := 1 setget set_spawn_points
export(Vector2) var spawn_offset := Vector2.ZERO setget set_spawn_offset

enum SpawnSequence {FORWARD, ALTERNATE, RANDOM, AT_ONCE}
export(SpawnSequence) var spawn_sequence := SpawnSequence.FORWARD

export var vel_mag := 100.0 setget set_vel_mag
export(float, 0.0, 360.0) var vel_angle := 90.0 setget set_vel_angle

export var acc_mag := 0.0 setget set_acc_mag
export(float, 0.0, 360.0) var acc_angle := 0.0 setget set_acc_angle

export(bool) var autostart := false

export(int, 1, 100) var spawn_count := 1

export(float) var start_delay := 0.0

export(float) var spawn_delay := 0.1

var draw_lenght := 30.0

var spawn_index := 0

var index_mult = 1

var level: AbstractLevel

var obj_path := []

onready var start_timer := $start_timer
onready var delay_timer := $delay_timer

func _ready():
	start_timer.wait_time = start_delay
	delay_timer.wait_time = spawn_delay
	
	if path_link:
		obj_path = calc_obj_path(get_node(path_link).curve.get_baked_points(), get_node(path_link).position)
	
	if autostart and not Engine.editor_hint:
		if start_delay == 0.0:
			trigger_spawn()
		else:
			start_timer.start()

func spawn():
	
	if Engine.editor_hint:
		return
	
	level = ScenesManager.current_level
	
	if spawn_count == 0:
		delay_timer.stop()
		return
	
	match spawn_sequence:
		SpawnSequence.FORWARD:
			if spawn_index > spawn_points-1:
				spawn_index = 0
		SpawnSequence.ALTERNATE:
			if spawn_index == spawn_points or spawn_index == -1:
				spawn_index = clamp(spawn_index, 1, spawn_points-2)
				index_mult *= -1
		
	var object = SpawnObj.instance()
	object.position = position + spawn_offset*spawn_index
	if object is AbstractEntity:
		if obj_path:
			object.path = obj_path
		object.linear_vel = Vector2(vel_mag, 0.0).rotated(deg2rad(vel_angle))
		object.linear_acc = Vector2(acc_mag, 0.0).rotated(deg2rad(acc_angle))
	
	level.enemies.add_child(object)

	spawn_index += index_mult
	spawn_count -= 1


func trigger_spawn():
	delay_timer.start()


func calc_obj_path(path_points:PoolVector2Array, offset:Vector2 = Vector2.ZERO):
	var path := []
	for i in range(path_points.size()):
		path.append(global_position + offset + path_points[i])
	
	return path


func _on_delay_timer_timeout():
	spawn()


func set_vel_mag(value):
	vel_mag = value
	update()


func set_vel_angle(value):
	vel_angle = value
	update()


func set_acc_mag(value):
	acc_mag = value
	update()


func set_acc_angle(value):
	acc_angle = value
	update()


func set_spawn_points(value):
	spawn_points = value
	update()


func set_spawn_offset(value):
	spawn_offset = value
	update()


func _draw():
	if Engine.editor_hint:
		
		for i in range(spawn_points):
			draw_circle(spawn_offset*i, 5.0, Color(0.8, 0.5, 0.5))
			
			if not path_link:
				var time_step := 0.2
				var points := PoolVector2Array()
				var time := 0.0
				for j in range(draw_lenght):
					time = j * time_step
					var point = spawn_offset*i + Vector2(vel_mag, 0.0).rotated(deg2rad(vel_angle))*time + Vector2(acc_mag, 0.0).rotated(deg2rad(acc_angle))*time*time/2
					points.append(point)
				
				draw_multiline(points, Color(0.4,0.6, 0.8), 2.0)
		
	if path_link and obj_path:
		draw_polyline(obj_path, Color(0.4,0.6, 0.8), 2.0)


func _on_start_timer_timeout():
	trigger_spawn()
