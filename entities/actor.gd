extends AbstractEntity
class_name Actor

signal killed()

@export var hp := 1.0
@export var auto_attack := false

@export var team := 2: set = set_team
@onready var attacks := $attacks.get_children()

var is_dead := false


func _ready():
	super._ready()
	# team can be set while the scene is instantiated, before the hitbox exists
	set_team(team)

	for a in attacks:
		if a is Attack:
			a.team = team


func _physics_process(_delta):
	super._physics_process(_delta)

	if auto_attack:
		attack()


func _handle_collision(other: AbstractEntity):
	# both actors detect the overlap, so each one only kills itself
	if other is Actor:
		kill()

func attack():
	for a in attacks:
		if a is Attack:
			a.fire()


func hit(damage: float):
	hp -= damage
	if hp <= 0.0:
		kill()


func set_team(value):
	team = value
	# projectiles detect actors themselves, so actors only collide with opposing actors
	set_hitbox_layers(Teams.get_team_layer(team), Teams.get_opponents_mask(team))


func kill():
	# several hits can land in the same physics frame
	if is_dead:
		return
	is_dead = true

	disable_hitbox()
	_die()
	emit_signal("killed")
	queue_free()


# death effects of a specific actor
func _die():
	pass
