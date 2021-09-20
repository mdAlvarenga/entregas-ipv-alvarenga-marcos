extends Sprite
export var projectile_scene:PackedScene

onready var fire_position:Position2D = $FirePosition

var projectile_container:Node

func fire():
	var projectile_instance:Projectile = projectile_scene.instance()
	projectile_container.add_child(projectile_instance)
	var fire_direction:Vector2 = (fire_position.global_position - global_position).normalized()
	projectile_instance.set_starting_values(fire_position.global_position, fire_direction)
	projectile_instance.connect("delete_requested", self, "_on_projectile_delete_requested")

func _on_projectile_delete_requested(projectile):
	projectile_container.remove_child(projectile)
	projectile.queue_free()
