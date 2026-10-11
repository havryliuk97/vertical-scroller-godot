extends AbstractEntity
class_name Projectile

@export var damage := 1.0

var team : set = set_team

func _handle_collision(collision: KinematicCollision2D):
	print("Projectile collided")
	var collider = collision.get_collider()
	if collider is Actor:
		collider.hit(damage)
	
	_on_hit()


func set_team(value):
	team = value
	collision_layer = Teams.get_team_layer(team, Teams.PARTICLES_BIT_OFFSET)


func _on_hit():
	queue_free()
