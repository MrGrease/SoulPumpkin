extends Node3D
var secondScene = preload("res://Environments/world.tscn")
func _on_quit_button_pressed():
	get_tree().quit()


func _on_start_button_pressed():
	get_tree().get_root().add_child(secondScene.instantiate())
	queue_free()

