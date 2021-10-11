extends KinematicBody2D
class_name Player

signal hit()
signal dead()

onready var cannon = $Cannon
onready var state_machine = $StateMachine
onready var floor_raycasts:Array = $FloorRaycasts.get_children()

const FLOOR_NORMAL := Vector2.UP
const SNAP_DIRECTION := Vector2.DOWN
const SNAP_LENGTH := 32.0
const SLOPE_THRESHOLD := deg2rad(60)

export (int) var max_health = 20
export (float) var ACCELERATION:float = 30.0
export (float) var H_SPEED_LIMIT:float = 400.0
export (int) var jump_speed = 1000
export (float) var FRICTION_WEIGHT:float = 0.1
export (int) var gravity = 30

var projectile_container

var velocity:Vector2 = Vector2.ZERO
var snap_vector:Vector2 = SNAP_DIRECTION * SNAP_LENGTH
var move_direction:int = 0
var stop_on_slope:bool = true


func _ready():
	state_machine.set_parent(self)
	PlayerData.call_deferred("set_max_health", max_health)


func initialize(projectile_container):
	self.projectile_container = projectile_container
	cannon.projectile_container = projectile_container


func _handle_move_input():
	move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if move_direction != 0:
		velocity.x = clamp(velocity.x + (move_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)


func _handle_deacceleration():
	velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0


func _handle_cannon_actions():
	var mouse_position_normalized:Vector2 = (get_global_mouse_position() - cannon.global_position).normalized()
	cannon.rotation = mouse_position_normalized.angle()


	if Input.is_action_just_pressed("fire_cannon"):
		if projectile_container == null:
			projectile_container = get_parent()
			cannon.projectile_container = projectile_container
		cannon.fire()


func _apply_movement():
	velocity.y += gravity
	velocity = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, stop_on_slope, 4, SLOPE_THRESHOLD)
	if is_on_floor() && snap_vector == Vector2.ZERO:
		snap_vector = SNAP_DIRECTION * SNAP_LENGTH


func notify_hit(amount):
	state_machine.notify_hit(amount)


func _remove():
	hide()
	collision_layer = 0


func is_on_floor()->bool:
	var is_colliding:bool = .is_on_floor()
	for raycast in floor_raycasts:
		raycast.force_raycast_update()
		is_colliding = is_colliding || raycast.is_colliding()
	return is_colliding


