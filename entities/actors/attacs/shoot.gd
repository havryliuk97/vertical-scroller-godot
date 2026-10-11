extends Attack
class_name ShootProjectile

@export var projectile_scene: PackedScene
@export var muzzle_pos_path: NodePath: set = _set_node_path
@export var muzzle_vel := 100.0 # (float, 0.0, 1000.0, 0.1)
@export var muzzle_direction := Vector2.DOWN: set = _set_muzzle_direction


var muzzle_pos: Marker2D


func _ready():
	super._ready()
	if muzzle_pos_path:
		muzzle_pos = get_node(muzzle_pos_path)


func fire():
	var time_left = delay_timer.time_left
	
	if time_left > 0.1: return
	
	var projectile = projectile_scene.instantiate()
	
	if muzzle_pos:
		projectile.global_position = muzzle_pos.global_position
	projectile.linear_vel = muzzle_vel * muzzle_direction
	if team != 0:
		projectile.team = team
	
	ScreensManager.get_current_level().add_entity(projectile)
	delay_timer.start()


func _set_muzzle_direction(dir: Vector2):
	muzzle_direction = dir.normalized()


func _set_node_path(new_path: NodePath):
	muzzle_pos_path = new_path
	if muzzle_pos_path:
		muzzle_pos = get_node(muzzle_pos_path)
