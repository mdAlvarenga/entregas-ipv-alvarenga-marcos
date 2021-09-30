extends Area2D

onready var lifetime_timer = $LifetimeTimer

export (float) var VELOCITY:float = 600.0

var direction:Vector2

func initialize(container, spawn_position:Vector2, direction:Vector2):
	container.add_child(self)
	self.direction = direction
	global_position = spawn_position
	lifetime_timer.connect("timeout", self, "_on_lifetime_timer_timeout")
	lifetime_timer.start()

func _physics_process(delta):
	position += direction * VELOCITY * delta

	# Si está fuera de la pantalla
	var visible_rect:Rect2 = get_viewport().get_visible_rect()
	if !visible_rect.has_point(global_position):
		_remove()

# Si supero una cantidad de tiempo de vida
func _on_lifetime_timer_timeout():
	_remove()

func _remove():
	get_parent().remove_child(self)
	queue_free()
	
func _on_Projectile_body_entered(body):
	var is_player_or_turret = body is Turret or body is Player
	if is_player_or_turret:
		body.hit_by_projectile()
	_kill()

func _kill():
	queue_free()
