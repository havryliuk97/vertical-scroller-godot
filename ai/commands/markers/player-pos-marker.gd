@tool
extends Marker2D
class_name PlayerPositionMarker

var player: Actor
var level: AbstractLevel


func _ready():
	if not Engine.is_editor_hint():
		level = ScreensManager.get_current_level()
		level.connect("player_set", Callable(self, "_on_player_changed"))
		
		player = level.player


func _physics_process(_delta):
	if player != null:
		global_position = player.global_position


func _on_player_changed(new_player: Actor):
	player = new_player
