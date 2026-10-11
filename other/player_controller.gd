extends Node2D

signal player_killed()
signal player_spawned(player)

var p_width:float = 16.0
var p_height:float = 24.0

var player: Actor: set = set_player
var _target_position: Vector2

@export var is_conrol_blocked := false: set = set_control_blocked

@export var slowdown_radius := 10.0

func _ready():
	if player != null:
		_target_position = player.global_position

func _process(_delta):
	if player != null:
		player.linear_acc = Steering.arrive(player, _target_position, slowdown_radius)
		
		player.global_position.x = clamp(player.global_position.x, p_width / 2, 256.0 - p_width / 2)
		player.global_position.y = clamp(player.global_position.y, p_height, 320.0 - p_height)


func _unhandled_input(event):
	if event is InputEventScreenDrag and not is_conrol_blocked:
		_target_position += event.relative
		queue_redraw()


func set_control_blocked(value: bool):
	if not value:
		_target_position = player.global_position
	
	is_conrol_blocked = value


func set_player(p: Actor):
	player = p
	if player != null :
		_target_position = player.global_position


func _draw():
	draw_circle(_target_position, 3.0, Color.GREEN)
