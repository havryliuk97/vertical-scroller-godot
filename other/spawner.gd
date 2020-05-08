tool
extends Node2D

export(NodePath) var path

export(PackedScene) var SpawnObj:PackedScene

export var vel_mag := 100.0 setget set_vel_mag
export(float, 0.0, 360.0) var vel_angle := 90.0 setget set_vel_angle

export var acc_mag := 0.0 setget set_acc_mag
export(float, 0.0, 360.0) var acc_angle := 0.0 setget set_acc_angle

export(bool) var autostart := false

export(int, 1, 100) var spawn_count := 1

export(float) var spawn_delay := 0.1

var draw_lenght: = 30.0

onready var delay_timer := $delay_timer

func _ready():
	delay_timer.wait_time = spawn_delay
	if autostart and not Engine.editor_hint:
		_trigger_spawn()

func spawn():
	
	if Engine.editor_hint:
		return
	
	if spawn_count == 0:
		delay_timer.stop()
		return
	
	if path:
		pass
	else:
		var object = SpawnObj.instance()
		object.position = position
		if object is AbstractEntity:
			object.linear_vel = Vector2(vel_mag, 0.0).rotated(deg2rad(vel_angle))
			object.linear_acc = Vector2(acc_mag, 0.0).rotated(deg2rad(acc_angle))
		get_tree().root.add_child(object)
		spawn_count -= 1


func _trigger_spawn():
	delay_timer.start()


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


func _draw():
	if Engine.editor_hint:
		
		var time_step := 0.2
		var points := PoolVector2Array()
		var time := 0.0
		for i in range(draw_lenght):
			time = i * time_step
			var point = Vector2(vel_mag, 0.0).rotated(deg2rad(vel_angle))*time + Vector2(acc_mag, 0.0).rotated(deg2rad(acc_angle))*time*time/2
			points.append(point)
		
		draw_multiline(points, Color(0.4,0.6, 0.8), 2.0)