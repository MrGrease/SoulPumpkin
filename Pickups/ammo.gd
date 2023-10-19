extends Node3D

func _on_area_3d_body_entered(body):
	if(body.has_method("add_ammo")):
		body.add_ammo()
		queue_free()
