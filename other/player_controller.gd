extends Node2D

signal player_killed()
signal player_spawned(player)

export(float) var basic_speed := 0.0
export(PackedScene) var PlayerClass = preload("res://entities/player-ship.tscn")

var p_width:float = 16.0
var p_height:float = 24.0

onready var player: AbstractEntity
onready var camera := $camera


func _ready():
	if not player:
		spawn_player()


func _process(delta):
	
	if player != null:
		if not(Input.is_action_pressed("left") or 
				Input.is_action_pressed("right")):
			player.linear_acc.x = 0.0
			if abs(player.linear_vel.x) > 0.1:
				player.linear_vel.x *= 0.9
			else:
				player.linear_vel.x = 0.0
		
		if not(Input.is_action_pressed("up") or 
				Input.is_action_pressed("down")):
			player.linear_acc.y = 0.0
			if abs(player.linear_vel.y) > -basic_speed+0.01:
				player.linear_vel.y *= 0.9
			else:
				player.linear_vel.y = 0.0
		
		
		
		player.position.x = clamp(player.position.x, p_width/2, 256.0-p_width/2)
		player.position.y = clamp(player.position.y, p_height, 320.0-p_height)
		
		camera.position.x = player.position.x
	
	position.y -= basic_speed * delta


func _unhandled_input(event):
	if player:
		if event.is_action_pressed("left"):
			player.linear_acc.x = -400.0
		
		if event.is_action_pressed("right"):
			player.linear_acc.x = 400.0
		
		if event.is_action_pressed("up"):
			player.linear_acc.y = -250.0
		
		if event.is_action_pressed("down"):
			player.linear_acc.y = 250.0


func kill_player():
	player.kill()
	player = null
	emit_signal("player_killed")


func spawn_player():
	player = PlayerClass.instance()
	player.connect("collision_occured", self, "_on_player_collided")
	player.position = Vector2(128.0, 300.0)
	
	add_child(player)
	emit_signal("player_spawned", player)
	print("player spawned emitted")


func _on_player_collided(player, collider):
	var layer = collider.get_collision_layer()
	if layer == 4 or layer == 8:
		collider.kill()
		kill_player()
