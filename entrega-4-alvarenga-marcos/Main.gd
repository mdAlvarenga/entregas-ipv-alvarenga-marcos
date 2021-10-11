extends Node

onready var player = $Environment/Player

func _ready():
	randomize()
	player.initialize(self)

func _unhandled_input(event):
	if event.is_action("restart"):
		_restart_level()

func _restart_level():
	get_tree().reload_current_scene()

