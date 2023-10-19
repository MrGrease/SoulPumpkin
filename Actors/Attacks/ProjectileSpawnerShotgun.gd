extends projectileSpawner

func spawnDayTimeProjectile():
	var rng = RandomNumberGenerator.new()
	for n in 8:
		var instance = projectileToSpawnDay.instantiate()
		get_tree().get_root().add_child(instance)
		instance.global_transform = global_transform
		instance.position.x += rng.randf_range(-1.0, 1.0)
		instance.position.y += rng.randf_range(-1.0, 1.0)
		instance.position.z += rng.randf_range(-1.0, 1.0)

