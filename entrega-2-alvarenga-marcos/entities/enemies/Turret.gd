extends Sprite
class_name Turret
export var projectile_scene:PackedScene

onready var fire_position:Position2D = $FirePosition

var player:Sprite
var projectile_container:Node

func _ready():
	$Timer.start()
	
func set_values(player, projectile_container):
	self.player = player
	self.projectile_container = projectile_container	
	
func _on_Timer_timeout():
	fire()

func fire():
	var projectile:Projectile = projectile_scene.instance()
	projectile_container.add_child(projectile)
	var direction = (player.global_position - fire_position.global_position).normalized()
	projectile.set_starting_values(fire_position.global_position, direction )
	projectile.connect("delete_requested", self, "_on_projectile_delete_requested")
	
func _on_projectile_delete_requested(projectile):
	projectile_container.remove_child(projectile)
	projectile.queue_free()

func get_turret_width():
	return texture.get_width()
	
func get_turret_height():
	return texture.get_height()
