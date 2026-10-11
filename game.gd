extends Node2D
class_name Game

@onready var screen_container = $"screen-container"
@onready var current_screen = $"screen-container/title_screen"

func set_screen(path):
	var new_screen = load(path).instantiate()
	
	current_screen.queue_free()
	
	current_screen = new_screen
	screen_container.add_child(new_screen)
