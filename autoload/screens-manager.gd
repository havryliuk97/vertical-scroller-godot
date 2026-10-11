extends Node

const game_scene_path = "/root/Game"

var Menus = {
	TITLE_SCREEN = "res://screens/title-screen.tscn"
}

var Levels = {
	LEVEL_1 = "res://levels/level-1/level-1.tscn"
}

func set_game_screen(path):
	var game = get_node(game_scene_path) as Game
	game.set_screen(path)


func get_current_level() -> AbstractLevel:
	var game = get_node("/root/Game") as Game
	return game.current_screen as AbstractLevel
