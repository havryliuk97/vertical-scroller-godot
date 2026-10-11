extends AbstractEntity
class_name Actor

signal killed()

@export var hp := 1.0
@export var auto_attack := false

@export var team := 2: set = set_team
@onready var attacks := $attacks.get_children()


func _ready():
	for a in attacks:
		if a is Attack:
			a.team = team


func _physics_process(_delta):
	super._physics_process(_delta)

	if auto_attack:
		attack()


func _handle_collision(info: KinematicCollision2D):
	var collider = info.get_collider()
	
	if collider.has_method("kill"):
		collider.kill()
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
	collision_layer = Teams.get_team_layer(team)
	collision_mask = Teams.get_team_mask(team)


func kill():
	emit_signal("killed")
	queue_free()
