extends Area3D

@export var areaText = "area"

func _on_body_entered(body):
	if body.has_method("setSituationText"):
		body.setSituationText(areaText)


func _on_body_exited(body):
	if body.has_method("setSituationText"):
		body.setSituationText("")
