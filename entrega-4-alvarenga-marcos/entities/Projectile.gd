extends Node2D

onready var lifetime_timer = $LifetimeTimer
onready var hitbox = $Hitbox

export (float) var VELOCITY:float = 800.0
export (int) var damage = 1

var direction:Vector2

func initialize(container, spawn_position:Vector2, direction:Vector2):
	container.add_child(self)
	self.direction = direction
	global_position = spawn_position
	lifetime_timer.connect("timeout", self, "_on_lifetime_timer_timeout")
	lifetime_timer.start()

func _physics_process(delta:float):
	position += direction * VELOCITY * delta

func _on_lifetime_timer_timeout():
	hitbox.collision_layer = 0
	hitbox.collision_mask = 0
	call_deferred("_remove")

func _remove():
	if is_instance_valid(self):
		get_parent().remove_child(self)
		queue_free()

func _on_Hitbox_body_entered(body):
	if body.has_method("notify_hit"):
		body.notify_hit(-damage)
	hitbox.collision_layer = 0
	hitbox.collision_mask = 0
	lifetime_timer.stop()
	call_deferred("_remove")

