extends Node2D

signal player_killed()

onready var PlayerClass = preload("res://entities/player-ship.tscn")
onready var player: AbstractEntity
onready var camera := $camera


func _ready():
	player = $player
	player.connect("collision_occured", self, "_on_player_collided")


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
			if abs(player.linear_vel.y) > 0.1:
				player.linear_vel.y *= 0.9
			else:
				player.linear_vel.y = 0.0
		
		player.global_position.x = clamp(player.global_position.x, 0.0, 256.0)
		
		camera.position = player.position


func _unhandled_input(event):
	if player:
		if event.is_action_pressed("left"):
			player.linear_acc.x = -10.0
		
		if event.is_action_pressed("right"):
			player.linear_acc.x = 10.0
		
		if event.is_action_pressed("up"):
			player.linear_acc.y = -5.0
		
		if event.is_action_pressed("down"):
			player.linear_acc.y = 5.0


func kill_player():
	player.kill()
	player = null
	emit_signal("player_killed")


func spawn_player():
	player = PlayerClass.instance()
	player.connect("collision_occured", self, "_on_player_collided")
	player.global_position = Vector2(128.0, 300.0)
	add_child(player)


func _on_player_collided(player, collider):
	var layer = collider.get_collision_layer()
	if layer == 4 or layer == 8:
		kill_player()
