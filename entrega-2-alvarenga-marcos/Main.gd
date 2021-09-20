extends Node

func _ready():
	var player:Sprite = $Player
	player.set_projectile_container(self)
	$TurretSpawner.spawn_with_limit(player, self)
