extends Sprite
export var H_SPEED_LIMIT:float = 600.0
export var FRICTION_WEIGHT:float = 0.1
export var ACCELERATION:float = 20.0
export var MINIMUM_DISTANCE:int = 10

onready var cannon:Sprite = $Cannon

var speed = 200 #Pixeles
var projectile_container:Node
var velocity:Vector2 = Vector2.ZERO

func set_projectile_container(container:Node):
	cannon.projectile_container = container
	projectile_container = container
	
func _physics_process(delta):
	var mouse_position:Vector2 = get_global_mouse_position()
	cannon.look_at(mouse_position)
	
	# Cannon fire
	if Input.is_action_just_pressed("fire"):
		if projectile_container == null:
			projectile_container = owner
			cannon.projectile_container = projectile_container
		cannon.fire()
		
	# Player movement
	var h_movement_direction:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if h_movement_direction != 0:
		velocity.x = clamp(velocity.x + (h_movement_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
	
	position += velocity * delta

func get_limit_for_rendering_turret():
	# Un poco más del borde para que no spawnee tan cerca
	return position.y - (texture.get_height() + MINIMUM_DISTANCE)
