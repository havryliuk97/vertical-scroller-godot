extends Node

var current_level:AbstractLevel setget set_current_level


func set_current_level(value:AbstractLevel):
	current_level = value
	print("Level set to ", value)
