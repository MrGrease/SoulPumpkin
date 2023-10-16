extends Node3D

@export var projectileToSpawnDay:Resource = null 
@export var projectileToSpawnNight:Resource = null 

func spawnDayTimeProjectile():
	var instance = projectileToSpawnDay.instantiate()
	get_tree().get_root().add_child(instance)
	instance.global_transform = global_transform

func spawnNightTimeProjectile():
	var instance = projectileToSpawnNight.instantiate()
	get_tree().get_root().add_child(instance)
	instance.global_transform = global_transform
