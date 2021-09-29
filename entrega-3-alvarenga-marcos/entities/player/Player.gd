extends KinematicBody2D
class_name Player

onready var cannon = $Cannon

export (float) var ACCELERATION:float = 20.0
export (float) var H_SPEED_LIMIT:float = 600.0
export (float) var FRICTION_WEIGHT:float = 0.1
export (float) var JUMP_SPEED:float = -400
export (float) var GRAVITY:float = 2
export (bool) var SNAP:bool = false
export (float) var SLOPE_SLIDE_THRESHOLD:float = 50.0

var velocity:Vector2 = Vector2.ZERO
var projectile_container

func initialize(projectile_container):
	self.projectile_container = projectile_container
	cannon.projectile_container = projectile_container

func _get_input():	
	_get_mouse_position_input()
	_get_cannon_fire_input()
	
	# Player movement
	if is_on_floor() and (Input.is_action_just_released("move_right") or Input.is_action_just_released("move_left")):
		velocity.y = 0
	
	var h_movement_direction:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if h_movement_direction != 0:
		velocity.x = clamp(velocity.x + (h_movement_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
	
	if Input.is_action_just_pressed("Jump") and SNAP:
		velocity.y = JUMP_SPEED
		SNAP = false
		
func _physics_process(delta):
	_get_input()	
	velocity.y += GRAVITY
	
	var snap_vector = Vector2(0,32) if SNAP else Vector2()
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, SLOPE_SLIDE_THRESHOLD)
	
	var just_landed := is_on_floor() and not SNAP
	if just_landed:
		SNAP = true
	
func _get_mouse_position_input():
	# Cannon rotation
	var mouse_position:Vector2 = get_global_mouse_position()
	cannon.look_at(mouse_position)

func _get_cannon_fire_input():
	# Cannon fire
	if Input.is_action_just_pressed("fire_cannon"):
		if projectile_container == null:
			projectile_container = get_parent()
			cannon.projectile_container = projectile_container
		cannon.fire()
	
