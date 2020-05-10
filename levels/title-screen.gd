extends Control

export var scroll_speed := 70.0

onready var bg := $parallax


func _ready():
	pass


func _process(delta):
	bg.scroll_offset.y += scroll_speed*delta


func _on_play_button_pressed():
	get_tree().change_scene("res://levels/level-1/level-1.tscn")
