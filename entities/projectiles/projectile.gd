extends AbstractEntity
class_name Projectile

@export var damage := 1.0

var team : set = set_team

var _has_hit := false

func _handle_collision(other: AbstractEntity):
	# a projectile can overlap several actors in the same frame, it only hits the first one
	if _has_hit or not other is Actor:
		return
	_has_hit = true

	print("Projectile collided")
	other.hit(damage)

	_on_hit()


func set_team(value):
	team = value
	set_hitbox_layers(Teams.get_team_layer(team, Teams.PARTICLES_BIT_OFFSET), Teams.get_opponents_mask(team))


func _on_hit():
	queue_free()
