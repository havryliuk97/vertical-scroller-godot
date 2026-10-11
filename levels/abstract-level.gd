class_name AbstractLevel
extends Node2D

signal player_set(player)

@export var player_scene: PackedScene = preload("res://entities/actors/player/player-ship.tscn")

var spawner_queue
var active_spawner:Spawner
var player: Actor: set = set_player

@onready var entities := $entities
@onready var respawn_timer := $respawn_timer
@onready var respawn_screen := $hud/respanw_screen
@onready var respawn_counter := $hud/respanw_screen/respawn_hud/countdown
@onready var player_controller := $player_controller
@onready var spawners := $spawners
@onready var camera := $camera
@onready var player_spawn := $player_spawn
@onready var erasers := $erasers

func _ready():
	respawn_screen.hide()
	
	for eraser in erasers.get_children():
		if(eraser is Area2D):
			eraser.connect("body_entered", Callable(self, "_clear_body"))
	
	spawn_player()
	
	_process_spawners()


func _physics_process(delta):
	if player != null:
		camera.position.x = player.position.x
	else:
		respawn_counter.text = str(round(respawn_timer.time_left))


func _process_spawners():
	spawner_queue = $spawners.get_children()
	
	for spawner in spawner_queue:
		active_spawner = spawner as Spawner
		
		active_spawner.start_spawning()
		
		await active_spawner.finish_condition_reached
		
		active_spawner = null
	
	print("Level Ended!")


func spawn_player():
	if not player:
		set_player(player_scene.instantiate() as Actor)
		
		player.position = player_spawn.global_position
		
		player_controller.player = player
		
		player.team = Teams.Options.PLAYER_TEAM
		
		add_entity(player)


func add_entity(entity: AbstractEntity):
	entities.add_child(entity)


func add_effect(node):
	$effects.add_child(node)


func set_player(new_player: Actor):
	player = new_player
	if player != null:
		player.connect("killed", Callable(self, "_on_player_killed"))
	
	player_controller.player = player
	emit_signal("player_set", player)


func _on_player_killed():
	set_player(null)
	respawn_screen.show()
	respawn_timer.start()



func _on_respawn_timer_timeout():
	respawn_screen.hide()
	spawn_player()


func _clear_body(body: CharacterBody2D):
	body.queue_free()
