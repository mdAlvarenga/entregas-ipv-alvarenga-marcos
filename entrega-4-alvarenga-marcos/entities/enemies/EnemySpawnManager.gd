tool
extends Node

const enemy_spawner_resource = preload("res://entities/enemies/EnemySpawnPoint.tscn")

export (bool) var generate_spawn setget set_generate_spawn

# Execution on editor
func set_generate_spawn(value):
	generate_spawn = false
	if value:
		_create_spawn_point_for_editor()

func _create_spawn_point_for_editor():
	if !Engine.editor_hint:
		return
	
	var new_spawn:EnemySpawnPoint = enemy_spawner_resource.instance()
	add_child(new_spawn)
	new_spawn.set_owner(get_tree().get_edited_scene_root())


## Execution on runtime
func _ready():
	if !Engine.editor_hint:
		call_deferred("_initialize")

func _initialize():
	var visible_rect:Rect2 = get_viewport().get_visible_rect()
	for spawner in get_children():
		if !spawner is EnemySpawnPoint:
			return
		spawner.spawn()
