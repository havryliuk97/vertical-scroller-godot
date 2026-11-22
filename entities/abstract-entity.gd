class_name AbstractEntity
extends Node2D
# Abstract entity class to be exended by other game objects
# Moves itself by linear_vel, collisions are detected by an optional "hitbox" Area2D child

signal collision_occured(object, collider)

@export var mass := 1.0 # (float, 1.0, 1000.0)

@export var max_linear_vel := 1000.0 # (float, 0.0, 1000.0)
@export var max_linear_acc := 500.0 # (float, 0.0, 1000.0)

@export var linear_damp := 0.0 # (float, 0.0, 1.0)

var linear_vel := Vector2.ZERO
var linear_acc := Vector2.ZERO

var _dumping_vel_threshold := 0.2

@onready var sprite: Sprite2D = $sprite
@onready var hitbox: Area2D = get_node_or_null("hitbox")


func _ready():
	if hitbox:
		hitbox.area_entered.connect(_on_hitbox_area_entered)


func _physics_process(delta):
	linear_acc = linear_acc.limit_length(max_linear_acc)

	linear_vel += linear_acc

	linear_vel = linear_vel.limit_length(max_linear_vel)

	if (linear_damp > 0.0 and linear_acc.length_squared() < linear_damp * linear_damp):
		if (linear_vel.length_squared() > _dumping_vel_threshold * _dumping_vel_threshold):
			linear_vel = linear_vel * (1.0 - linear_damp)
		else:
			linear_vel = Vector2.ZERO

	position += linear_vel * delta

	_update(delta)


func _update(_delta):
	pass


func _on_hitbox_area_entered(area: Area2D):
	var other = area.get_parent() as AbstractEntity
	if other:
		emit_signal("collision_occured", self, other)
		_handle_collision(other)


func _handle_collision(_other: AbstractEntity):
	pass


func hit(_damage: float):
	pass


# works before the entity is in the tree too, e.g. when a team is set right after instantiate()
func set_hitbox_layers(layer: int, mask: int):
	var box = get_node_or_null("hitbox") as Area2D
	if box:
		box.collision_layer = layer
		box.collision_mask = mask


# deferred, because monitoring can't change while area signals are being sent
func disable_hitbox():
	if hitbox:
		hitbox.hide()
		hitbox.set_deferred("monitoring", false)
		hitbox.set_deferred("monitorable", false)
