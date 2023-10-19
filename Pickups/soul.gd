extends Node3D

func _on_area_3d_body_entered(body):
	if(body.has_method("add_soul")):
		body.add_soul()
		queue_free()
