extends Node
export (int) var turrets_number
export var turret_scene:PackedScene

onready var viewport_size = get_viewport().get_visible_rect().size

var container:Node
var player:Sprite
var y_spawn_bottom_limit:int

func spawn_with_limit(player:Sprite, container:Node):
	self.container = container	
	self.player = player
	self.y_spawn_bottom_limit = player.get_limit_for_rendering_turret() 
	
	for i in range(turrets_number):
		randomize()
		_spawn_turret()		

func _spawn_turret():
	var turret:Turret = turret_scene.instance()
	turret.set_values(player, container)
	
	turret.set_position(_get_random_position_for(turret.get_turret_width(), turret.get_turret_height()))
	container.add_child(turret)

func _get_random_position_for(x_spawn_left_limit, y_spawn_top_limit):
	var x_spawn_right_limit = viewport_size.x - x_spawn_left_limit
		
	var random_position_x = randi() % int(x_spawn_right_limit)
	var random_position_y = randi() % int(y_spawn_bottom_limit)
	var position_x = clamp(random_position_x, x_spawn_left_limit, x_spawn_right_limit)
	var position_y = clamp(random_position_y, y_spawn_top_limit, y_spawn_bottom_limit)
	
	return Vector2(position_x, position_y)
