extends "res://entities/AbstractState.gd"


func update(delta):
	parent._handle_cannon_actions()
	parent._handle_move_input()
	parent._apply_movement()
	if parent.move_direction == 0:
		emit_signal("finished", "idle")
