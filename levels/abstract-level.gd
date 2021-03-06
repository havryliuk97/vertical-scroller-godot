class_name AbstractLevel
extends Node2D

var spawner_queue
var active_spawner:Spawner
var spawner_idx := 0

onready var enemies := $enemies
onready var respawn_timer := $respawn_timer
onready var respawn_screen := $hud/respanw_screen
onready var respawn_counter := $hud/respanw_screen/respawn_hud/countdown
onready var player_controller := $player_controller
onready var spawners := $spawners


func _ready():
	ScenesManager.set_current_level(self)
	player_controller.connect("player_killed", self, "_on_player_killed")
	player_controller.connect("player_spawned", self, "_on_player_spawned")
	_on_player_spawned(player_controller.player)
	respawn_screen.hide()
	spawner_queue = $spawners.get_children()
	active_spawner = spawner_queue[spawner_idx]
	active_spawner.start_timer.start()
	active_spawner.connect("units_destroyed", self, "_next_spawner")


func _process(delta):
	if not player_controller.player:
		respawn_counter.text = str(round(respawn_timer.time_left))
	for enemy in $enemies.get_children():
		if enemy.global_position.y > 360.0:
			enemy.queue_free()
	for projectile in $player_projectiles.get_children():
		if projectile.global_position.y < -10.0:
			projectile.queue_free()


func _on_player_killed():
	respawn_screen.show()
	respawn_timer.start()

func _on_player_spawned(player:AbstractEntity):
	print("player spawned received")
	player.connect("player_fired", self, "_on_player_fired")


func _next_spawner():
	spawner_idx += 1
	if spawner_idx < spawner_queue.size():
		active_spawner = spawner_queue[spawner_idx]
		active_spawner.start_timer.start()
		active_spawner.connect("units_destroyed", self, "_next_spawner")
	else:
		print("Level Ended!")


func _on_player_fired(Projectile:PackedScene, location: Vector2, vel: Vector2):
	var projectile:AbstractEntity = Projectile.instance()
	projectile.global_position = location
	projectile.linear_vel = vel
	projectile.rotation = vel.angle()
	$player_projectiles.add_child(projectile)


func _on_respawn_timer_timeout():
	respawn_screen.hide()
	player_controller.spawn_player()
