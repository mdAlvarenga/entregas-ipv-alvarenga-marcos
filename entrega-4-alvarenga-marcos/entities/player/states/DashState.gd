extends "res://entities/AbstractState.gd"

onready var dashTimer = $DashTimer

func enter():
	dashTimer.start()
	parent._handle_move_input()
	#if parent.is_on_floor():	
	parent.velocity.x = parent.velocity.x * parent.DASH
	

func update(delta:float):
	parent._handle_cannon_actions()
	
	if parent.move_direction == 0:
		parent._handle_deacceleration()
	#if parent.is_on_floor():
	parent._apply_movement()

func _on_DashTimer_timeout():
	print("timeout timer")
	if parent.move_direction != 0:
		emit_signal("finished","walk")
	else:
		emit_signal("finished","idle")

