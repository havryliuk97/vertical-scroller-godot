extends Node2D

onready var respawn_timer := $respawn_timer
onready var respawn_screen := $hud/respanw_screen
onready var respawn_counter := $hud/respanw_screen/respawn_hud/countdown
onready var player_controller := $player_controller


func _ready():
	player_controller.connect("player_killed", self, "_on_player_killed")
	respawn_screen.hide()


func _process(delta):
	if not player_controller.player:
		respawn_counter.text = str(str(round(respawn_timer.time_left)))


func _on_player_killed():
	respawn_screen.show()
	respawn_timer.start()


func _on_respawn_timer_timeout():
	respawn_screen.hide()
	player_controller.spawn_player()
