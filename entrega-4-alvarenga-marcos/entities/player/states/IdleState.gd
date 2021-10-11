extends "res://entities/AbstractState.gd"


func handle_input(event:InputEvent):
	if event.is_action_pressed("move_left") || event.is_action_pressed("move_right"):
		emit_signal("finished", "walk")
	if event.is_action_pressed("jump") and parent.is_on_floor():
		emit_signal("finished", "jump")

func update(delta:float):
	parent._handle_cannon_actions()
	parent._handle_deacceleration()
	parent._apply_movement()
