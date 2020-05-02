tool
extends Node2D

export(NodePath) var path

export(PackedScene) var SpawnObj:PackedScene
export var spawn_vel_mag := 100.0
export(float, 0.0, 360.0) var spawn_vel_angle := 90.0
export(int, 1, 100) var spawn_cont := 1
export(float) var spawn_delay := 0.1
export(float) var start_delay := 0.0

onready var start_timer := $start_timer
onready var delay_timer := $delay_timer


func _ready():
	$start_timer.wait_time = start_delay
	$delay_timer.wait_time = spawn_delay


func spawn():
	if path:
		pass
	else:
		var object = SpawnObj.instance()
		object.position = position
		if object is AbstractEntity:
			
