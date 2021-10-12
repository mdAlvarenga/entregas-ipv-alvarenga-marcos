extends Node

export (NodePath) var pathfinding:NodePath

func _ready():
	if pathfinding.is_empty():
		return
		
	var pathfinder:PathfindAstar = get_node(pathfinding)
	if pathfinding == null:
		return
		
	for child in get_children():
		if child is Turret:
			child.pathfinding = pathfinder
