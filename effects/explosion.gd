extends Node2D

func _ready():
	$animation_player.play("explosion")


func _on_animation_finished(anim_name):
	self.queue_free()
