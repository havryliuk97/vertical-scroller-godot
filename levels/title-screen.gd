extends Control

export var scroll_speed := 70.0

onready var bg := $parallax


func _ready():
	pass


func _process(delta):
	bg.scroll_offset.y += scroll_speed*delta
