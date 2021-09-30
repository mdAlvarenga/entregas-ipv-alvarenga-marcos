extends Node
onready var spawn_area_extents:Vector2 = $SpawnArea/CollisionShape2D.get_shape().extents

export (PackedScene) var turret_scene

func _ready():
	call_deferred("initialize")
		
func initialize():
	var x_axis_spawn_area:Vector2 = Vector2(200, spawn_area_extents.x)
	var y_axis_spawn_area:Vector2 = Vector2(10, spawn_area_extents.y)
	for i in 4:
		_instance_turret(x_axis_spawn_area, y_axis_spawn_area)	

func _instance_turret(x_axis_spawn_area, y_axis_spawn_area):
	var turret_instance = turret_scene.instance()
	var turret_pos:Vector2 = _get_random_position(x_axis_spawn_area, y_axis_spawn_area)
	turret_instance.initialize(self, turret_pos, get_parent())
	
func _get_random_position(x_axis_spawn_area, y_axis_spawn_area):
	return Vector2(rand_range(x_axis_spawn_area.x, x_axis_spawn_area.y), rand_range(y_axis_spawn_area.x, y_axis_spawn_area.y))

