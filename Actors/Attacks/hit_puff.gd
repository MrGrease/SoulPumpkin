extends Node3D
@export var lifeTime = 1

func _on_timer_timeout():
	queue_free()
